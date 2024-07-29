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
    for table_conf in [
        {
            'name':'opioid__acep_potential_rules', 
            'columns':10,
            'count':2880,
            'first':(
                1819, '1151359', 'BN', 'SCDG', 18636093, 'RO', 'has_ingredient', 
                'Buprenorphine', 'buprenorphine / naloxone Oral Product', 
                'buprenorphine'
            ),
            'last': (
                1819, '904879', 'SY', 'SCDC', 5110638, 'RO', 'has_ingredient', 
                '(-)-buprenorphine', 'buprenorphine 0.005 MG/HR', 'buprenorphine'
            ),
        },
        {
            'name':'opioid__acep_included_rels', 
            'columns':10,
            'count':28,
            'first':(
                1819, '1431077', 'BN', 'BN', 43028489, 'RN', 'reformulated_to', 
                'reformulated_to', 'Buprenorphine', 'Zubsolv', 'zubsolv'
            ),
            'last': (
                1819, '904871', 'BN', 'BN', 3764389, 'RN', 'reformulated_to', 
                'reformulated_to', 'Buprenorphine', 'Butrans', 'butrans'
            ),
        },
        {
            'name':'opioid__acep_included_keywords', 
            'columns':10,
            'count':2808,
            'first':(
                1819, '1151359', 'BN', 'SCDG', 18636093, 'RO', 'has_ingredient', 
                'Buprenorphine', 'buprenorphine / naloxone Oral Product', 
                'buprenorphine'
            ),
            'last': (
                1819, '904879', 'SY', 'SCDC', 5110638, 'RO', 'has_ingredient',
                '(-)-buprenorphine', 'buprenorphine 0.005 MG/HR', 'buprenorphine'
            ),
        },
        # The following table has fewer rows than the proceding due to duplication
        # in the key lookup. The union operation removes extra rows.
        {
            'name':'opioid__acep_combined_ruleset', 
            'columns':10,
            'count':938,
            'first':(
                1819, '1151359', 'BN', 'SCDG', 18636093, 'RO', 'has_ingredient', 
                'Buprenorphine', 'buprenorphine / naloxone Oral Product',
                'buprenorphine'
            ),
            'last': (
                1819, '904879', 'SY', 'SCDC', 5110638, 'RO', 'has_ingredient', 
                '(-)-buprenorphine', 'buprenorphine 0.005 MG/HR', 'buprenorphine'
            ),
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