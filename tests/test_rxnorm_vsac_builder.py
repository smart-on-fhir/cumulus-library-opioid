import json
import os
import pathlib
from unittest import mock

from cumulus_library import study_manifest

from cumulus_library_opioid.vocab import rxnorm_vsac_builder, static_builder


@mock.patch.dict(
    os.environ,
    clear=True,
)
@mock.patch("cumulus_library.apis.umls.UmlsApi")
def test_rxnorm_vsac_builder(mock_api, mock_db_config_rxnorm):
    with open(pathlib.Path(__file__).parent / "test_data/vsac_resp.json") as f:
        resp = json.load(f)
    mock_api.return_value.get_vsac_valuesets.return_value = resp
    mock_db_config_rxnorm.options = { 'steward':'acep' }
    manifest = study_manifest.StudyManifest()
    manifest._study_config={'study_prefix':'opioid'}
    cursor = mock_db_config_rxnorm.db.cursor()

    s_builder = static_builder.StaticBuilder()    
    s_builder.execute_queries(config=mock_db_config_rxnorm, manifest=manifest)
    builder = rxnorm_vsac_builder.RxNormVsacBuilder()
    builder.execute_queries(config=mock_db_config_rxnorm, manifest=manifest)
    res = cursor.execute('select * from opioid__acep_rela').fetchall()
    assert len(res) == 900
    assert res[0] == (
        1819, 'Product containing buprenorphine (medicinal product)', 'FN', 
        'SNOMEDCT_US', 1818, 'RN', 'reformulated_to', 4716626
    )
    assert res[-1] == (
        1819, 'Buprenorphine', 'IN', 'GS', 1655031, 'RO', 'has_ingredient', 86130850
    )
