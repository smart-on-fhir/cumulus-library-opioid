"""Builder for generating subsets of RxNorm data from a given valueset"""
import pathlib

from cumulus_library import base_table_builder, base_utils, study_manifest
from cumulus_library.template_sql import base_templates

from cumulus_library_opioid.vocab import umls, vsac


class RxNormVocabBuilder(base_table_builder.BaseTableBuilder):
    display_text = "Creating RxNorm subsets from vocab definitions..."
    base_path = pathlib.Path(__file__).resolve().parent

    def prepare_queries(
        self,
        config: base_utils.StudyConfig,
        manifest: study_manifest.StudyManifest,
        *args,
        **kwargs,
    ):
        def get_create_view_filter_by(
            steward: str,
            a_table: str,
            *,
            columns : list,
            b_table:str | None= None,
            a_join_col: str | None= None,
            b_join_col: str | None= None,
            a_schema: str | None= None,
            view_name:str | None= None,
            join_clauses: list | None = None,
            column_aliases: dict | None = None
            
        ):
            a_schema = a_schema or 'rxnorm.'
            a_join_col = a_join_col or 'a.rxcui'
            b_join_col = b_join_col or 'b.code'
            b_table = b_table or f'opioid__{steward}_vocab'
            join_clauses = join_clauses or [f"{a_join_col} = {b_join_col}"]
            view_name = view_name or f'{manifest.get_study_prefix()}__{steward}_{a_table}'

            return base_templates.get_create_view_from_tables(
                view_name=view_name,
                tables = [
                    f'{a_schema}{a_table}',
                    b_table
                ],
                table_aliases = ['a','b'],
                join_clauses=join_clauses,
                columns=columns,
                column_aliases = column_aliases,
                distinct = True,

            )
        with open(self.base_path / "./common/keywords/keywords.filtered.tsv") as f:
            keywords = [row.rstrip() for row in f.readlines()]
        query = base_templates.get_base_template(
                'show_tables',
                schema_name = config.schema,
                prefix=f"{manifest.get_study_prefix()}__all_rxnconso_keywords"
            )
        res = config.db.cursor().execute(query).fetchall()
        
        #if len(res) ==0:
        self.queries.append(
            base_templates.get_base_template(
                'create_keyword_annotated_table',
                self.base_path / "template_sql",
                keywords = keywords,
                source_table="rxnorm.rxnconso",
                table_name="opioid__all_rxnconso_keywords"
            )
        )
        umls_stewards = umls.get_umls_stewards(config=config)
        vsac_stewards = vsac.get_vsac_stewards(config=config)
        for steward in umls_stewards:
            umls.generate_umls_tables(config, manifest)
        for steward in umls_stewards + vsac_stewards:
            self.queries.append(
                get_create_view_filter_by(
                    steward,
                    "rxnconso",
                    columns=['a.rxcui','a.str','a.tty','a.sab','a.code'],
                )
            )
            # self.queries.append(
            #     get_create_view_filter_by(
            #         steward,
            #         f'{steward}_rxnconso',
            #         a_schema=f'{manifest.get_study_prefix()}__',
            #         b_table = 'opioid__keywords',
            #         columns=['a.rxcui','a.str','a.tty','a.sab','a.code', 'b.str'],
            #         view_name=f'{manifest.get_study_prefix()}__{steward}_rxnconso_keywords',
            #         join_clauses = ["lower(a.str) LIKE concat('%',b.STR, '%')"],
            #         column_aliases = {"b.str": "keyword"}
            #     )
            # )
            self.queries.append(
                base_templates.get_base_template(
                    'create_keyword_annotated_table',
                    self.base_path / "template_sql",
                    keywords = keywords,
                    source_table=f"{manifest.get_study_prefix()}__{steward}_rxnconso",
                    table_name=f'{manifest.get_study_prefix()}__{steward}_rxnconso_keywords'
                )
            )
            self.queries.append(
                get_create_view_filter_by(
                    steward,
                    'rxnsty',
                    columns=['a.rxcui','a.tui','a.stn','a.sty','a.atui','a.cvf'],
                )
            )
            self.queries.append(
                get_create_view_filter_by(
                    steward,
                    'rxnrel',
                    columns=[
                        'a.rxcui1','a.rxaui1','a.stype1','a.rel','a.rxcui2','a.rxaui2',
                        'a.stype2','a.rela','a.rui','a.srui','a.sab','a.sl','a.rg'
                    ],
                    a_join_col='a.rxcui1'
                )
            )
            self.queries.append(
                get_create_view_filter_by(
                    steward,
                    f'{steward}_rxnconso_keywords',
                    view_name= f'{manifest.get_study_prefix()}__{steward}_rela',
                    a_schema = f'{manifest.get_study_prefix()}__',
                    b_table =f'{manifest.get_study_prefix()}__{steward}_rxnrel',
                    columns=['a.rxcui','a.str','a.tty','a.sab','b.rxcui2','b.rel','b.rela','b.rui'],
                    b_join_col='b.rxcui1',
                )
            )
