import argparse
import json
import pathlib
import sys

import pandas
from cumulus_library import base_utils, errors
from cumulus_library.apis import umls

from cumulus_library_opioid.vocab import vocab_utils

VALID_MSG = f"Valid stewards: all,{','.join(vocab_utils.VOCABULARIES.keys())}"

def download_oid_data(
    source_vocab: str,
    *,
    api_key: str | None = None,
    config: base_utils.StudyConfig | None = None,
    force_upload:str | None = None,
    path: pathlib.Path | None = None,
) -> bool:
    """Fetches code definitions (assumed to be RXNorm coded) from VSAC
    :param source_vocab: the human readable label for the valueset
    :keyword config: A StudyConfig object. If umls_key is none, will check the
        UMLS_API_KEY env var
    :keyword path: A path to write data to (default: ../data)
    :returns: True if file created, false otherwise (mostly for testing)
    """
    if config:
        api_key=config.umls_key
        force_upload=config.force_upload
    valid_vocabs = vocab_utils.get_valid_stewards_for_source_type('vsac')
    if not path:
        path = pathlib.Path(__file__).parent.parent / "data"
    path.mkdir(exist_ok=True, parents=True)
    if not (force_upload) and (path / f"{source_vocab}.parquet").exists():
        print(f"{source_vocab} data present, skipping download")
        return False
    if source_vocab not in valid_vocabs:
        sys.exit(f"Vocab from steward {source_vocab} not found. \n\n {VALID_MSG}")
    print(f"Downloading {source_vocab} to {path}")
    api = umls.UmlsApi(api_key=api_key or api_key)
    output = []

    response = api.get_vsac_valuesets(oid=utils.VOCABULARIES[source_vocab].oid)
    for valueset in response:
        contains = valueset.get("expansion").get("contains", [])
        for data in contains:
            output.append([data["code"], data["display"]])
    output_df = pandas.DataFrame(output, columns=["RXCUI", "STR"])
    output_df.to_csv(path / f"{source_vocab}.tsv", index=False, header=False, sep="\t")
    output_df.to_parquet(path / f"{source_vocab}.parquet")
    with open(path / f"{source_vocab}.json", "w") as f:
        f.write(json.dumps(response))
    return True


def get_vsac_stewards(
    *,config:base_utils.StudyConfig | None = None, steward: str | None = None
) -> list[str]:
    """Gets the vsac steward target(s) from the StudyConfig options"""
    if (not config and not steward) or (config and steward):
        raise errors.CumulusLibraryError(
            "get_vsac_stewards() expects either a StudyConfig or a string."
        )
    if config:
        steward = config.options['steward']
    stewards = []
    if steward == 'all':
        stewards = vocab_utils.get_valid_stewards_for_source_type('vsac')
    else:
        if steward in vocab_utils.get_valid_stewards_for_source_type('vsac'):
            stewards.append(steward)
    return stewards

def main(cli_args=None):
    """Temporary CLI interface"""
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "source_vocab", help="Name of vocab to look up codes for", default=None
    )
    parser.add_argument("--api_key", help="UMLS api key", default=None)
    parser.add_argument(
        "--force-upload",
        help="Force redownloading of data even if it already exists",
        action="store_true",
    )
    parser.add_argument("--path", help="optional path to write data to", default=None)
    args = parser.parse_args(cli_args)
    return download_oid_data(
        args.source_vocab,
        api_key=args.api_key,
        force_upload=args.force_upload,
        path=pathlib.Path(args.path),
    )


if __name__ == "__main__":
    main()
