import json
import pathlib
import sys

import pandas
from cumulus_library import base_utils
from cumulus_library.apis import umls

VSAC_OIDS = {
    "acep": "2.16.840.1.113762.1.4.1106.68",
    "atc_non": "2.16.840.1.113762.1.4.1032.291",
    "bioportal": None,
    "CancerLinQ_non": "2.16.840.1.113762.1.4.1260.173",
    "CancerLinQ": "2.16.840.1.113762.1.4.1116.449",
    "cliniwiz_keywords": "2.16.840.1.113762.1.4.1200.163",
    "clinwiz": "2.16.840.1.113762.1.4.1200.14",
    "ecri": "1.3.6.1.4.1.6997.4.1.2.234.999.3.2",
    "impaq": "2.16.840.1.113762.1.4.1196.87",
    "lantana": "2.16.840.1.113762.1.4.1046.241",
    "math_349": "2.16.840.1.113883.3.3157.1004.26",
    "mdpartners_non": "2.16.840.1.113762.1.4.1021.73",
    "medrt": None,
    "mitre": "2.16.840.1.113762.1.4.1032.34",
    "medrt_non": None,
    "keywords": None,
}

VALID_MSG = f"Valid stewards: all,{','.join(VSAC_OIDS.keys())}"

def download_oid_data(
    source_vocab: str,
    *,
    config: base_utils.StudyConfig,
    path: pathlib.Path | None = None,
) -> bool:
    """Fetches code definitions (assumed to be RXNorm coded) from VSAC
    :param source_vocab: the human readable label for the valueset
    :keyword config: A StudyConfig object. If umls_key is none, will check the
        UMLS_API_KEY env var
    :keyword path: A path to write data to (default: ../data)
    :returns: True if file created, false otherwise (mostly for testing)
    """
    if not path:
        path = pathlib.Path(__file__).parent.parent / "data"
    path.mkdir(exist_ok=True, parents=True)
    if not config.force_upload and (path / f"{source_vocab}.parquet").exists():
        print(f"{source_vocab} data present, skipping download")
        return False
    if source_vocab not in VSAC_OIDS.keys():
        sys.exit(f"Vocab from steward {source_vocab} not found. \n\n {VALID_MSG}")
    if VSAC_OIDS[source_vocab] is None:
        # TODO: Impove this exist message when porting to library
        sys.exit(f"No available OID for {source_vocab}.")
    print(f"Downloading {source_vocab} to {path}")
    api = umls.UmlsApi(api_key=config.umls_key)
    output = []

    response = api.get_vsac_valuesets(oid=VSAC_OIDS[source_vocab])
    for valueset in response:
        include = valueset.get("compose").get("include", [])
        for data in include:
            for concept in data.get("concept", []):
                output.append([concept["code"], concept["display"]])
    output_df = pandas.DataFrame(output, columns=["RXCUI", "STR"])
    output_df.to_csv(path / f"{source_vocab}.tsv", index=False, header=False, sep="\t")
    output_df.to_parquet(path / f"{source_vocab}.parquet")
    with open(path / f"{source_vocab}.json", "w") as f:
        f.write(json.dumps(response))
    return True


def get_vsac_stewards(config:base_utils.StudyConfig) -> list[str]:
    """Gets the steward target(s) from the StudyConfig options"""
    stewards = []
    try:
        if config.options['steward'] == 'all':
            for k,v in VSAC_OIDS.items():
                if v is not None:
                    stewards.append(k)
        else:
            if config.options['steward'] in VSAC_OIDS.keys():
                stewards.append(config.options['steward'])
            else:
                sys.exit(
                    f"{config.options['steward']} is not a valid value set steward."
                    f" \n\n{VALID_MSG}"
                )
        return stewards
    except (TypeError, KeyError):
        sys.exit(
            "This study requires specifying a value set steward. Add an argument like"
            "'--option steward:name' to specify which value sets to use.\n\n"
            f"{VALID_MSG}"
        )
