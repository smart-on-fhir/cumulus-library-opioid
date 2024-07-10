"""Builder for generating subsets of RxNorm data from a given valueset"""
import pathlib

from cumulus_library import base_table_builder, base_utils, study_manifest
from cumulus_library.template_sql import base_templates

from cumulus_library_opioid.vocab import vsac


class RxNormVsacBuilder(base_table_builder.BaseTableBuilder):
    display_text = "Creating RxNorm subsets from VSAC definitions..."
    base_path = pathlib.Path(__file__).resolve().parent

    def prepare_queries(
        self,
        config: base_utils.StudyConfig,
        manifest: study_manifest.StudyManifest,
        *args,
        **kwargs,
    ):
        def get_create_view_filter_by(
            steward,
            a_table,
            b_table = None,
            a_join_col = None,
            b_join_col = None,
            a_schema = None,
            view_name = None,
            **kwargs,
        ):
            a_schema = a_schema or 'rxnorm.'
            return base_templates.get_base_template(
                'create_view_from_tables',
                self.base_path / "template_sql",
                view_name=view_name or (
                    f'{manifest.get_study_prefix()}__{steward}_{a_table}'
                ),
                a_table = f'{a_schema}{a_table}',
                a_schema = a_schema,
                b_table= b_table or f'opioid__{steward}_vsac',
                a_join_col= a_join_col or 'rxcui',
                b_join_col = b_join_col or 'code',
                **kwargs
            )
        stewards = vsac.get_vsac_stewards(config)
        for steward in stewards:
            self.queries.append(
                get_create_view_filter_by(
                    steward,
                    "rxnconso",
                    a_cols=['rxcui','str','tty','sab','code'],
                )
            )
            self.queries.append(
                get_create_view_filter_by(
                    steward,
                    'rxnsty',
                    a_cols=['rxcui','tui','stn','sty','atui','cvf'],
                )
            )
            self.queries.append(
                get_create_view_filter_by(
                    steward,
                    'rxnrel',
                    a_cols=[
                        'rxcui1','rxaui1','stype1','rel','rxcui2','rxaui2',
                        'stype2','rela','rui','srui','sab','sl','rg'
                    ],
                    a_join_col='rxcui1'
                )
            )
            self.queries.append(
                get_create_view_filter_by(
                    steward,
                    f'{steward}_rxnconso',
                    view_name= f'{manifest.get_study_prefix()}__{steward}_rela',
                    a_schema = f'{manifest.get_study_prefix()}__',
                    b_table =f'{manifest.get_study_prefix()}__{steward}_RXNREL',
                    a_cols=['rxcui','str','tty','sab'],
                    b_cols=['rxcui2','rel','rela','rui'],
                    b_join_col='rxcui1'
                )
            )
