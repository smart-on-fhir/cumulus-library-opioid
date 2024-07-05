import csv
import dataclasses
import pathlib

import pandas

from cumulus_library import base_table_builder, base_utils, study_manifest
from cumulus_library.template_sql import base_templates

@dataclasses.dataclass
class TableConfig:
    file_path: str
    delimiter: str
    table_name: str
    headers: list[str]
    dtypes: dict
    parquet_types: list[str]
    filtered_name: str | None = None
    ignore_header: bool = False
    map_cols: list[dict] | None = None

class StaticBuilder(base_table_builder.BaseTableBuilder):
    display_text = "Building static data tables..."
    base_path = pathlib.Path(__file__).resolve().parent

    tables = [
        TableConfig(
            base_path / './common/keywords/keywords.curated.tsv',
            '\t',
            'keywords',
            ['STR'],
            {"STR": 'str'},
            ['STRING'],
            filtered_name= base_path / './common/keywords/keywords.curated.filtered.tsv',
        ),
        TableConfig(
            base_path / './common/expand_rules/expand_rules.tsv',
            '\t',
            'expand_rules',
            # TODO: do we actually need to preserve 'rule'?
            ["TTY1","RELA","TTY2","rule", ],
            {"TTY1":'str',"RELA":'str',"TTY2":'str',"rule":'str'},
            ['STR','STR','STR','STR','STR'],
            ignore_header=True,
            map_cols = [{'from':'rule','to':'include',"map_dict":{ 'yes': True, 'no':False }}]
        )
    ]

    def filter_duplicated(self, path, delimiter, filtered_name):
        target = path.with_suffix(".filtered.tsv")
        #if target.exists():
        #    return
        with open(path) as file:
            reader = csv.reader(file, delimiter=delimiter)
            rows = []
            for row in reader:
                rows.append(row)
        rows.sort(key=lambda x:len(x[1]))
        unique_keywords =[]
        while len(rows) !=0:
            unique_keywords.append(rows[0][1])
            keyword = rows[0][1]
            rows.pop(0)
            matching_indexes=[]
            for index in range(0, len(rows)):
                if keyword.casefold() in rows[index][1].casefold():
                    matching_indexes.insert(0, index)
            for index in matching_indexes:
                rows.pop(index)
        df= pandas.DataFrame(unique_keywords)
        df.to_csv(target, sep='\t', index = False, header= False)

    def prepare_queries(
        self, 
        config: base_utils.StudyConfig,
        manifest: study_manifest.StudyManifest,
        *args, 
        **kwargs
    ):
        with base_utils.get_progress_bar() as progress:
            task= progress.add_task(
                "Uploading static files...",
                total=len(self.tables)
            )
            for table in self.tables:
                if table.filtered_name:
                    self.filter_duplicated(
                        table.file_path, 
                        table.delimiter,
                        table.filtered_name
                    )
                    path = self.base_path / table.filtered_name
                else:
                    path = self.base_path / table.file_path
                parquet_path = path.with_suffix(".parquet")
                df = pandas.read_csv(
                    path,
                    delimiter = table.delimiter,
                    names = table.headers,
                    header=0 if table.ignore_header else None,
                    dtype = table.dtypes,
                    index_col = False,
                )
                if table.map_cols:
                    for mapping in table.map_cols:
                        df[mapping['to']] = df[mapping['from']].str.lower().map(
                            mapping['map_dict']

                        )
                        table.headers.append(mapping['to'])
                df.to_parquet(
                    parquet_path
                )
                prefix = manifest.get_study_prefix()
                remote_path = config.db.upload_file(
                    file = parquet_path,
                    study = prefix,
                    topic= parquet_path.stem,
                    force_upload = config.force_upload
                )
                progress.advance(task)
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