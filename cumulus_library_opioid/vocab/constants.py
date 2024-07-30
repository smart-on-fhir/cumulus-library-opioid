import unittest

CURATED_NON = ["CancerLinQ_non", "mdpartners_non", "atc_non", "medrt_non"]
CURATED_KEYWORDS = ["cliniwiz_keywords", "keywords"]
CURATED_OPIOID = [
    "acep",
    "bioportal",
    "CancerLinQ",
    "cliniwiz",
    "ecri",
    "impaq",
    "lantana",
    "math_349",
    "medrt",
    "mitre",
]

VALIDATE_SOURCES = ['all_rxcui_str', 'opioid', 'ucdavis']

CURATED_LIST = CURATED_OPIOID + CURATED_NON + CURATED_KEYWORDS + VALIDATE_SOURCES