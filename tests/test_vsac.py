import json
import pathlib
from contextlib import nullcontext as does_not_raise
from unittest import mock

import pytest
from cumulus_library import base_utils

from cumulus_library_opioid.vocab import vsac


@mock.patch("cumulus_library.apis.umls.UmlsApi")
@pytest.mark.parametrize(
    "name,umls,force,raises",
    [
        ("acep", None, False, does_not_raise()),
        ("acep", "1234567", False, does_not_raise()),
        ("acep", None, True, does_not_raise()),
        ("bioportal", None, False, pytest.raises(SystemExit)),
        ("invalid", None, False, pytest.raises(SystemExit)),
    ],
)
def test_download_oid_data(mock_api, mock_db, name, umls, force, raises, tmp_path):
    with raises:
        with open(pathlib.Path(__file__).parent / "test_data/vsac_resp.json") as f:
            resp = json.load(f)
        mock_api.return_value.get_vsac_valuesets.return_value = resp
        config = base_utils.StudyConfig(
            db= mock_db,
            schema='test',
            umls_key=umls,
            force_upload=force,
            options={'steward': name}
        )
        vsac.download_oid_data(name,path=tmp_path, config=config)
        output_dir = list(tmp_path.glob("*"))
        assert len(output_dir) == 5
        with open(tmp_path / "acep.tsv") as f:
            tsv = f.readlines()
            assert tsv[0].strip() == "1010599\tBuprenorphine / Naloxone Oral Strip"
            assert (
                tsv[-1].strip()
                == "998213\t1 ML morphine sulfate 4 MG/ML Prefilled Syringe"
            )
        redownload = vsac.download_oid_data(name,path=tmp_path, config=config)
        assert redownload == force

@pytest.mark.parametrize(
    'steward,expects,raises',
    [
        (None, [None], pytest.raises(SystemExit)),
        ('acep', ['acep'], does_not_raise()),
        (
            'all', 
            [
                'acep', 'atc_non', 'CancerLinQ_non', 'CancerLinQ', 'cliniwiz_keywords', 
                'clinwiz', 'ecri', 'impaq', 'lantana', 'math_349', 'mdpartners_non', 
                'mitre'
            ], 
            does_not_raise()
        ),
        ('bcep', [None], pytest.raises(SystemExit)),
    ]
)
def test_vsac_stewards(mock_db_config,steward,expects,raises):
    with raises:
        mock_db_config.options = {'steward': steward}
        res = vsac.get_vsac_stewards(mock_db_config)
        assert res == expects

def test_vsac_stewards_no_steward_key(mock_db_config):
    with pytest.raises(SystemExit):
        mock_db_config.options = {'key': 'val'}
        res = vsac.get_vsac_stewards(mock_db_config)

