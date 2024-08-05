"""Convenience summary tables for rules excluded from combined_ruleset

These are primarily used as debugging tools while developing keyword lists."""

import dataclasses
import pathlib

from cumulus_library import base_table_builder, base_utils, study_manifest
from cumulus_library.template_sql import base_templates
from cumulus_library_opioid.vocab import vsac

@dataclasses.dataclass(kw_only=True)
class TableConfig:
    name: str
    relas: list[str]
    exclude_relas: bool = False

class ExcludedRulesBuilder(base_table_builder.BaseTableBuilder):
    display_text = "Summarizing excluded rules..."
    base_path = pathlib.Path(__file__).resolve().parent

    def prepare_queries(
        self,
        config: base_utils.StudyConfig,
        manifest: study_manifest.StudyManifest,
        *args,
        **kwargs,
    ):
        # Since the generic study options treat every value as string, we can't
        # do straight boolean assertions for this check
        if config.options.get('debug', 'false').lower() != 'true':
            self.display_text = 'Skipping excluded rules summary'
            return
        tables=[
            TableConfig(
                name='tradename',
                relas=['has_tradename','tradename_of'],
            ),
            TableConfig(
                name='consists',
                relas=['consists_of','constitutes'],
            ),
            TableConfig(
                name='is_a',
                relas=['isa','inverse_isa'],
            ),
            TableConfig(
                name='ingredient',
                relas=[
                    'has_ingredient','ingredient_of', 'has_precise_ingredient',
                    'precise_ingredient_of','has_ingredients','ingredients_of'
                ],
            ),
            TableConfig(
                name='dose_form',
                relas=[
                    'dose_form_of', 'has_dose_form',
                    'doseformgroup_of', 'has_doseformgroup'
                ],
            ),
            TableConfig(
                name='form',
                relas=[
                    'form_of', 'has_form',
                ],
            ),
            TableConfig(
                name='other',
                relas=[
                    'has_tradename','tradename_of','consists_of','constitutes',
                    'isa','inverse_isa','has_ingredient','ingredient_of',
                    'has_precise_ingredient','precise_ingredient_of','has_ingredients',
                    'ingredients_of','dose_form_of','has_dose_form','doseformgroup_of',
                    'has_doseformgroup','form_of','has_form'
                ],
                exclude_relas =True
            ),
        ]
        prefix = manifest.get_prefix_with_seperator()
        stewards = vsac.get_vsac_stewards(config)
        for steward in stewards:
            self.queries.append(
                base_templates.get_base_template(
                    'create_excluded_rules',
                    self.base_path / "template_sql",
                    steward=steward,
                    prefix=prefix
                )
            )
            for table in tables:
                self.queries.append(
                    base_templates.get_base_template(
                        'create_excluded_rela_types',
                        self.base_path / "template_sql",
                        name=table.name,
                        relas=table.relas,
                        exclude_relas=table.exclude_relas,
                        steward=steward,
                        prefix=prefix
                    )
                )
