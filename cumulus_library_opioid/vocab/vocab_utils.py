import dataclasses

from cumulus_library import errors


@dataclasses.dataclass(kw_only=True)
class VocabSource:
    #VSAC
    oid: str = None
    #UMLS
    sab: str = None
    search_terms: dict = None

    def __post_init__(self):
        if ( self.oid and self.sab and self.search_terms):
            raise errors.CumulusLibraryError(
                "VocabSource is expected to have only one vocab source. Use either "
                "an OID for VSAC, or a SAB/search term pair for UMLS"
            )
        if (self.sab and not self.search_terms) or (not self.sab and self.search_terms):
            raise errors.CumulusLibraryError(
                "A VocabSource for UMLS is expected to have both `sab` and "
                "`search_terms supplied"
            )

VOCABULARIES ={
    "acep": VocabSource(oid= "2.16.840.1.113762.1.4.1106.68"),
    "atc_non": VocabSource(oid= "2.16.840.1.113762.1.4.1032.291"),
    # hand curated in previous version - omitting for now
    # "bioportal": VocabSource(),
    "CancerLinQ_non": VocabSource(oid= "2.16.840.1.113762.1.4.1260.173"),
    "CancerLinQ": VocabSource(oid= "2.16.840.1.113762.1.4.1116.449"),
    "cliniwiz_keywords": VocabSource(oid= "2.16.840.1.113762.1.4.1200.163"),
    "cliniwiz": VocabSource(oid= "2.16.840.1.113762.1.4.1200.14"),
    "ecri": VocabSource(oid= "1.3.6.1.4.1.6997.4.1.2.234.999.3.2"),
    "impaq": VocabSource(oid= "2.16.840.1.113762.1.4.1196.87"),
    "lantana": VocabSource(oid= "2.16.840.1.113762.1.4.1046.241"),
    "math_349": VocabSource(oid= "2.16.840.1.113883.3.3157.1004.26"),
    "mdpartners_non": VocabSource(oid= "2.16.840.1.113762.1.4.1021.73"),
    "medrt": VocabSource(sab = "MED-RT", search_terms=["Opioid"]),
    "mitre": VocabSource(oid= "2.16.840.1.113762.1.4.1032.34"),
    "medrt_non": VocabSource(
        sab= "MED-RT", 
        search_terms=["Benzodiazepine", "Barbiturate", "Nonsteroidal Anti-inflammatory Drug"]
    ),
    # hand curated in previous version - omitting for now
    #"keywords": VocabSource(),
}

def get_valid_stewards_for_source_type(vocab:str):
    stewards = []
    for k,v in VOCABULARIES.items():
        match vocab:
            case 'vsac':            
                if v.oid:
                    stewards.append(k)
            case 'umls':
                if v.sab:
                    stewards.append(k)
    return stewards