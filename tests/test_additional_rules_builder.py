import json
import os
import pathlib
from unittest import mock

from cumulus_library import study_manifest

from cumulus_library_opioid.vocab import (
    additional_rules_builder,
    rxnorm_vsac_builder,
    static_builder,
)


@mock.patch.dict(
    os.environ,
    clear=True,
)
@mock.patch("cumulus_library.apis.umls.UmlsApi")
def test_additional_rules(mock_api, mock_db_config_rxnorm):
    with open(pathlib.Path(__file__).parent / "test_data/vsac_resp.json") as f:
        resp = json.load(f)
    mock_api.return_value.get_vsac_valuesets.return_value = resp
    mock_db_config_rxnorm.options = { 'steward':'acep' }
    manifest = study_manifest.StudyManifest()
    manifest._study_config={'study_prefix':'opioid'}
    cursor = mock_db_config_rxnorm.db.cursor()

    s_builder = static_builder.StaticBuilder()    
    s_builder.execute_queries(config=mock_db_config_rxnorm, manifest=manifest)
    r_builder = rxnorm_vsac_builder.RxNormVsacBuilder()
    r_builder.execute_queries(config=mock_db_config_rxnorm, manifest=manifest)
    builder = additional_rules_builder.AdditionalRulesBuilder()
    builder.execute_queries(config=mock_db_config_rxnorm, manifest=manifest)
    res = cursor.execute("select * from opioid__acep_rela")
    for table_conf in [
        {
            'name':'opioid__acep_potential_rules', 
            'columns':10,
            'count':36,
            'first':(1819, 1818, 'BN', 'BN', 4716626, 'RN', 'reformulated_to', 'Buprenorphine', 'Subutex', 'subutex'),
            'last': (1819, 1818, 'SY', 'BN', 4716626, 'RN', 'reformulated_to', '(-)-buprenorphine', 'Subutex', 'subutex'),
        },
        {
            'name':'opioid__acep_included_rels', 
            'columns':10,
            'count':2,
            'first':(1819, 1818, 'BN', 'BN', 4716626, 'RN', 'reformulated_to', 'Buprenorphine', 'Subutex', 'subutex'),
            'last': (1819, 1818, 'BN', 'BN', 4716626, 'RN', 'reformulated_to', 'Buprenorphine', 'Subutex', 'subutex'),
        },
        {
            'name':'opioid__acep_included_keywords', 
            'columns':10,
            'count':36,
            'first':(1819, 1818, 'BN', 'BN', 4716626, 'RN', 'reformulated_to', 'Buprenorphine', 'Subutex', 'subutex'),
            'last': (1819, 1818, 'SY', 'BN', 4716626, 'RN', 'reformulated_to', '(-)-buprenorphine', 'Subutex', 'subutex'),
        },
        # The following table has fewer rows than the proceding due to duplication
        # in the key lookup. The union operation removes extra rows.
        {
            'name':'opioid__acep_combined_ruleset', 
            'columns':10,
            'count':13,
            'first':(1819, 1818, 'BN', 'BN', 4716626, 'RN', 'reformulated_to', 'Buprenorphine', 'Subutex', 'subutex'),
            'last': (1819, 1818, 'SY', 'BN', 4716626, 'RN', 'reformulated_to', '(-)-buprenorphine', 'Subutex', 'subutex'),
        },
    ]:
        res = cursor.execute (
            f"Select * from {table_conf['name']} order by "
            f"{','.join([str(x+1) for x in range(table_conf['columns'])])}"
        ).fetchall()
        assert len(res) == table_conf['count']
        assert res[0] == table_conf['first']
        if table_conf['count'] > 1:
            assert res[-1] == table_conf['last']