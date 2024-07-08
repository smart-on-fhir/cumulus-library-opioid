import json
import pathlib
from contextlib import nullcontext as does_not_raise
from unittest import mock

import pytest

from cumulus_library_opioid.vocab.analyze import vsac


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
def test_vsac(mock_api, name, umls, force, raises, tmp_path):
    with raises:
        with open(pathlib.Path(__file__).parent / "test_data/vsac_resp.json") as f:
            resp = json.load(f)
        mock_api.return_value.get_vsac_valuesets.return_value = resp
        cli_args = [
            name,
            "--path",
            str(tmp_path),
            "--api_key",
            umls,
        ]
        if force:
            cli_args.append("--force-recreate")
        vsac.main(cli_args)
        output_dir = list(tmp_path.glob("*"))
        assert len(output_dir) == 3
        with open(tmp_path / "acep.tsv") as f:
            tsv = f.readlines()
            assert tsv[0].strip() == "1010599\tBuprenorphine / Naloxone Oral Strip"
            assert (
                tsv[-1].strip()
                == "998213\t1 ML morphine sulfate 4 MG/ML Prefilled Syringe"
            )
        redownload = vsac.main(cli_args)
        assert redownload == force
