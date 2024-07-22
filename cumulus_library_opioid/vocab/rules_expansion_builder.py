"""Builder for generating subsets of RxNorm data from a given valueset"""
import pathlib

from cumulus_library_opioid.vocab import vsac
from cumulus_library import base_table_builder, base_utils, study_manifest
from cumulus_library.template_sql import base_templates


class RulesExpansionBuilder(base_table_builder.BaseTableBuilder):
    display_text = "Generating rulesets..."
    base_path = pathlib.Path(__file__).resolve().parent

    def prepare_queries(
        self,
        config: base_utils.StudyConfig,
        manifest: study_manifest.StudyManifest,
        *args,
        **kwargs,
    ):
        prefix = manifest.get_prefix_with_seperator()
        stewards = vsac.get_vsac_stewards(config)
        for steward in stewards:
            self.queries.append(
                base_templates.get_base_template(
                    'create_expansion_rules_descriptions',
                    self.base_path / "template_sql",
                    steward=steward
                )
            )
            self.queries.append(
                base_templates.get_create_view_from_tables(
                    view_name=f'{prefix}{steward}_relaxed_expansion',
                    # From a domain logic perspective, the _rela table is
                    # the leftmost table and we're annotating with the
                    # data from rxnconso. Since rxnconso is much, much
                    # larger, we're moving it to the left in the actual
                    # constructed join for athena performance reasons
                    tables = [f'{prefix}rxn_curated',f'{prefix}{steward}_rela'],
                    table_aliases = ['r', 's'],
                    columns =[
                        's.rxcui',
                        'r.rxcui',
                        's.tty',
                        'r.tty',
                        's.rui',
                        's.rel',
                        's.rela',
                        's.str',
                        'r.str',
                        'r.keyword'
                    ],
                    column_aliases={ 
                        's.rxcui': 'rxcui1',
                        's.tty': 'tty1',
                        's.str': 'str1',
                        'r.rxcui': 'rxcui2',
                        'r.tty': 'tty2',
                        'r.str': 'str2',
                    },
                    join_clauses= [
                        's.rxcui2 = r.rxcui',
                        f's.rxcui2 NOT IN (SELECT DISTINCT RXCUI FROM {prefix}{steward}_rxnconso_keywords)'
                    ],
                )
            )
            self.queries.append(
                base_templates.get_create_view_from_tables(
                    view_name=f'{prefix}{steward}_strict_expansion',

                    tables = [
                        f'{prefix}{steward}_relaxed_expansion',
                        f'{prefix}expansion_rules'
                    ],
                    table_aliases = ['r', 'e'],
                    columns =[
                        'r.rxcui1',
                        'r.rxcui2',
                        'r.tty1',
                        'r.tty2',
                        'r.rui',
                        'r.rel',
                        'r.rela',
                        'r.str1',
                        'r.str2',
                        'r.keyword',
                    ],
                    join_clauses= [
                        "r.REL NOT IN ('RB', 'PAR')",
                        "e.include = TRUE",
                        "r.TTY1 = e.TTY1",
                        "r.TTY2 = e.TTY2",
                        "r.RELA = e.RELA"
                    ],
                )
            )
            #this is the set of matching keywords that are not selected
            # keyword_str/keyword_len are null
            self.queries.append(
                base_templates.get_create_view_from_tables(
                    view_name=f'{prefix}{steward}_expanded_keywords',

                    tables = [
                        f'{prefix}{steward}_relaxed_expansion',
                        f'{prefix}expansion_rules'
                    ],
                    table_aliases = ['r', 'e'],
                    columns =[
                        'r.rxcui1',
                        'r.rxcui2',
                        'r.tty1',
                        'r.tty2',
                        'r.rui',
                        'r.rel',
                        'r.rela',
                        'r.str1',
                        'r.str2',
                        'r.keyword'
                    ],
                    join_clauses= [
                        "e.tty1 = r.tty1",
                        "e.tty2 = r.tty2",
                        "r.REL NOT IN ('RB', 'PAR')",
                        "e.include IS NULL",
                        "length(r.keyword) > 1",
                        "r.RELA = e.RELA",
                        "r.RELA = e.RELA"
                    ],
                )
            )
            self.queries.append(
                base_templates.get_create_table_from_union(
                    table_name=f'{prefix}{steward}_expanded_ruleset',
                    tables = [
                        f'{prefix}{steward}_expanded_keywords',
                        f'{prefix}{steward}_strict_expansion'
                    ],
                    columns =[
                        'rxcui1',
                        'rxcui2',
                        'tty1',
                        'tty2',
                        'rui',
                        'rel',
                        'rela',
                        'str1',
                        'str2',
                        'keyword'
                    ],
                    
                )
            )