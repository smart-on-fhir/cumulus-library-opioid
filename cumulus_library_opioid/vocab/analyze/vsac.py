import argparse
import pandas
import pathlib
import sys

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


def download_oid_data(
    source_vocab: str,
    *,
    api_key: str = None,
    force_recreate: bool = False,
    path: pathlib.Path | None = None,
) -> bool:
    """Fetches code definitions (assumed to be RXNorm coded) from VSAC
    :param source_vocab: the human readable label for the valueset
    :keyword api_key: UMLS API key. Will read from UMLS_API_KEY env var if none
    :keyword force_recreate: If true, redownload valueset even if it already exists
    :keyword path: A path to write data to (default: ../data)
    :returns: True if file created, false otherwise (mostly for testing)
    """
    if not path:
        path = pathlib.Path(__file__).parent.parent / "data/"
    path.mkdir(exist_ok=True, parents=True)
    if not force_recreate and (path / f"{source_vocab}.parquet").exists():
        print(f"{source_vocab} data present, skipping download")
        return False
    print(f"Downloading {source_vocab}...")
    if source_vocab not in VSAC_OIDS.keys():
        sys.exit(f"Vocab {source_vocab} not found")
    api = umls.UmlsApi(api_key=api_key)
    output = []

    response = api.get_vsac_valuesets(oid=VSAC_OIDS[source_vocab])
    for valueset in response:
        include = valueset.get("compose").get("include", [])
        for data in include:
            for concept in data.get("concept", []):
                output.append([concept["code"], concept["display"]])
    output_df = pandas.DataFrame(output, columns=["RXCUI", "STR"])
    output_df.to_csv(path / f"{source_vocab}.tsv", index=False, header=False, sep="|")
    output_df.to_parquet(path / f"{source_vocab}.parquet")
    return True


def main(cli_args=None):
    """Temporary CLI interface"""
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "source_vocab", help="Name of vocab to look up codes for", default=None
    )
    parser.add_argument("--api_key", help="UMLS api key", default=None)
    parser.add_argument(
        "--force-recreate",
        help="Force redownloading of data even if it already exists",
        action="store_true",
    )
    parser.add_argument("--path", help="optional path to write data to", default=None)
    args = parser.parse_args(cli_args)
    return download_oid_data(
        args.source_vocab,
        api_key=args.api_key,
        force_recreate=args.force_recreate,
        path=args.path,
    )


if __name__ == "__main__":
    main()