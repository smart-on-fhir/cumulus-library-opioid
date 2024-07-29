import csv
import dataclasses
import pathlib

import pandas
from cumulus_library import base_table_builder, base_utils, study_manifest
from cumulus_library.template_sql import base_templates

from cumulus_library_opioid.vocab import vsac


@dataclasses.dataclass(kw_only=True)
class TableConfig:
    """Convenience class for holding params for configuring tables from flat files"""

    file_path: str
    delimiter: str
    table_name: str
    headers: list[str]
    dtypes: dict
    parquet_types: list[str]
    filtered_path: str | None = None
    ignore_header: bool = False
    map_cols: list[dict] | None = None


class StaticBuilder(base_table_builder.BaseTableBuilder):
    display_text = "Building static data tables..."
    base_path = pathlib.Path(__file__).resolve().parent

    tables = [  # noqa: RUF012
        TableConfig(
            file_path=base_path / "./common/keywords/keywords.tsv",
            delimiter="\t",
            table_name="keywords",
            headers=["STR"],
            dtypes={"STR": "str"},
            parquet_types=["STRING"],
            filtered_path=base_path / "./common/keywords/keywords.filtered.tsv",
        ),
        TableConfig(
            file_path=base_path / "./all_rxcui_str.RXNCONSO_curated.tsv",
            delimiter="\t",
            table_name="all_rxnconso_keywords",
            headers=["RXCUI","STR","TTY","SAB","CODE","keyword","keyword_len"],
            dtypes={"RXCUI":"str","STR":"str","TTY":"str","SAB":"str","CODE":"str","keyword":"str","keyword_len":"str"},
            parquet_types=["STRING","STRING","STRING","STRING","STRING","STRING","STRING"],
        ),
        TableConfig(
            file_path=base_path / "./common/expand_rules/expand_rules.tsv",
            delimiter="\t",
            table_name="search_rules",
            headers=[
                "TTY1",
                "RELA",
                "TTY2",
                "rule",
            ],
            dtypes={"TTY1": "str", "RELA": "str", "TTY2": "str", "rule": "str"},
            parquet_types=["STRING", "STRING", "STRING", "STRING", "BOOLEAN"],
            ignore_header=True,
            map_cols=[
                {
                    "from": "rule",
                    "to": "include",
                    "map_dict": {"yes": True, "no": False},
                }
            ],
        ),
        # TODO: We should eventually replace this with a source derived from
        # UMLS directly at some point
        TableConfig(
            file_path=base_path / "./common/umls/umls_tty.tsv",
            delimiter="\t",
            table_name="umls_tty",
            headers=["TTY","TTY_STR"],
            dtypes={"TTY": "str","TTY_STR": "str",},
            parquet_types=["STRING", "STRING"],
        ),
    ]

    def filter_duplicated_meds(
        self, path: pathlib.Path, delimiter: str, filtered_path: pathlib.Path
    ):
        """Given a dataset, returns the set of shortest unique substrings from that set

        As an example, given a dataset like this:
            '831704', 'Hydone Formula Liquid'
            '1173408', 'Hydone Formula Liquid Oral Liquid Product'
            '1173409', 'Hydone Formula Liquid Oral Product'
            '93553', 'Novahistine Expectorant'
            '996245', 'Novahistine Expectorant, 10 mg-100 mg-30 mg/5 mL oral liquid'
            '1178110', 'Novahistine Expectorant Oral Liquid Product'
            '1178111', 'Novahistine Expectorant Oral Product'
            '2670', 'Codeine'
            '1007238', 'aconite / codeine / Erysimum preparation'
            '1007293', 'codeine / potassium'

        This function should return:
            'Codiene'
            'Hydone Formula Liquid'
            'Novahistine Expectorant'

        :param path: path to a file (expected to be two cols, with data in second col)
        :param delimiter: the character used to separate columns in that file
        :param filtered_path: The name of the file to write the filtered dataset to

        """
        target = path.with_suffix(".filtered.tsv")
        with open(path) as file:
            reader = csv.reader(file, delimiter=delimiter)
            keywords = sorted((row[0] for row in reader), key=len)
        unique_keywords = {}  # casefold -> normal
        for keyword in keywords:
            folded = keyword.casefold()
            if not any(x in folded for x in unique_keywords):
                unique_keywords[folded] = keyword

        df = pandas.DataFrame(unique_keywords.values())
        df.to_csv(target, sep="\t", index=False, header=False)

    def prepare_queries(
        self,
        config: base_utils.StudyConfig,
        manifest: study_manifest.StudyManifest,
        *args,
        **kwargs,
    ):
        # fetch and add vsac tables
        vsac_stewards = vsac.get_vsac_stewards(config)
        for steward in vsac_stewards:
            vsac.download_oid_data(steward, config=config, path=self.base_path /'data')
            self.tables.append(
                TableConfig(
                    file_path=self.base_path / f"data/{steward}.tsv",
                    delimiter="\t",
                    table_name=f"{steward}_vsac",
                    headers=["code","display"],
                    dtypes={"code": "str","display": "str"},
                    parquet_types=["STRING", "STRING"],
                )
            )

        with base_utils.get_progress_bar() as progress:
            task = progress.add_task(
                "Uploading static files...", total=len(self.tables)
            )

            for table in self.tables:
                # Determine what we're using as a source file
                if table.filtered_path:
                    self.filter_duplicated_meds(
                        table.file_path, table.delimiter, table.filtered_path
                    )
                    path = self.base_path / table.filtered_path
                else:
                    path = self.base_path / table.file_path
                parquet_path = path.with_suffix(".parquet")

                # Read the file, using lots of the TableConfig params, and generate
                # a parquet file
                df = pandas.read_csv(
                    path,
                    delimiter=table.delimiter,
                    names=table.headers,
                    header=0 if table.ignore_header else None,
                    dtype=table.dtypes,
                    index_col=False,
                    na_values=['\\N']
                )
                if table.map_cols:
                    for mapping in table.map_cols:
                        df[mapping["to"]] = (
                            df[mapping["from"]].str.lower().map(mapping["map_dict"])
                        )
                        table.headers.append(mapping["to"])
                df.to_parquet(parquet_path)

                # Upload to S3 and create a table that reads from it
                prefix = manifest.get_study_prefix()
                remote_path = config.db.upload_file(
                    file=parquet_path,
                    study=prefix,
                    topic=parquet_path.stem,
                    force_upload=config.force_upload,
                )
                self.queries.append(
                    base_templates.get_ctas_from_parquet_query(
                        schema_name=config.schema,
                        table_name=f"{prefix}__{table.table_name}",
                        local_location=parquet_path.parent,
                        remote_location=remote_path,
                        table_cols=table.headers,
                        remote_table_cols_types=table.parquet_types,
                    )
                )
                progress.advance(task)                
