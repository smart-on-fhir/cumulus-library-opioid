import json
import os
import pathlib
from unittest import mock

from cumulus_library import study_manifest

from cumulus_library_opioid.vocab import (
    excluded_rules_builder,
)


@mock.patch.dict(
    os.environ,
    clear=True,
)
def test_additional_rules(mock_db_config):
    mock_db_config.options = { 'steward':'acep', 'debug':'true' }
    manifest = study_manifest.StudyManifest()
    manifest._study_config={'study_prefix':'opioid'}
    cursor = mock_db_config.db.cursor()
    cursor.execute(
        "CREATE TABLE opioid__acep_combined_ruleset as "
        "SELECT * FROM read_csv('./tests/test_data/excluded_rules_tables/included_rules.csv')"
    )
    cursor.execute(
        "CREATE TABLE opioid__acep_potential_rules as "
        "SELECT * FROM read_csv('./tests/test_data/excluded_rules_tables/potential_rules.csv')"
    )
    builder = excluded_rules_builder.ExcludedRulesBuilder()
    builder.execute_queries(config=mock_db_config, manifest=manifest)
    for table_conf in [
        {'name' : 'opioid__acep_excluded_rules','rows':19},
        {'name' : 'opioid__acep_excluded_tradename','rows':2},
        {'name' : 'opioid__acep_excluded_consists','rows':2},
        {'name' : 'opioid__acep_excluded_is_a','rows':2},
        {'name' : 'opioid__acep_excluded_ingredient','rows':6},
        {'name' : 'opioid__acep_excluded_dose_form','rows':4},
        {'name' : 'opioid__acep_excluded_refresh','rows':2},
        {'name' : 'opioid__acep_excluded_form','rows':2},
        {'name' : 'opioid__acep_excluded_other','rows':1},
    ]:
        res = cursor.execute (f"Select rela from {table_conf['name']}").fetchall()
        assert len(res) == table_conf['rows']
        assert len(res) == len(set(res))
