import os
from typing import List
from fhirclient.models.coding import Coding

from cumulus_library.helper import load_json
from cumulus_library.schema.typesystem import Vocab
import pandas

STUDY_PREFIX = "opioid"


def get_sheet(sheet_name):
    """
    Curated/Supplied by UC Davis
    :param sheet_name: Excel spreadsheet exported
    :return:
    """
    return pandas.read_excel(
        get_path("CodeBookOpioidOverDose.xlsx"), sheet_name=sheet_name
    )


def get_path(filename=None):
    if filename:
        return os.path.join(os.path.dirname(__file__), filename)
    else:
        return os.path.dirname(__file__)


def escape(sql: str) -> str:
    """
    :param sql: SQL potentially containing special chars
    :return: special chars removed like tic(') and semi(;).
    """
    return sql.replace("'", "").replace(";", ".")


def coding2view(view_name: str, concept_list: List[Coding]) -> str:
    """
    :param view_name: like define_type
    :param concept_list: list of concepts to include in definition
    :return: SQL command
    """
    header = (
        f"create or replace view {STUDY_PREFIX}__{view_name} as select * from (values"
    )
    footer = ") AS t (system, code, display) ;"
    content = list()
    for concept in concept_list:
        safe_display = escape(concept.display)
        content.append(f"('{concept.system}', '{concept.code}', '{safe_display}')")
    content = "\n,".join(content)
    return header + "\n" + content + "\n" + footer


def valueset2coding(valueset_json) -> List[Coding]:
    """
    Obtain a list of Coding "concepts" from a ValueSet.
    This method currently supports only "include" of "concept" defined fields.
    Not supported: recursive fetching of contained ValueSets, which requires UMLS API Key and Wget, etc.

    examples
    https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1146.1629/expansion/Latest
    https://cts.nlm.nih.gov/fhir/res/ValueSet/2.16.840.1.113762.1.4.1146.1629?_format=json

    :param valueset_json: ValueSet file, expecially those provided by NLM/ONC/VSAC
    :return: list of codeable concepts (system, code, display) to include
    """
    filepath = get_path(valueset_json)
    print(f"\nvalueset:{filepath}")

    valueset = load_json(get_path(valueset_json))
    parsed = list()

    for include in valueset["compose"]["include"]:
        if "concept" in include.keys():
            for concept in include["concept"]:
                concept["system"] = include["system"]
                parsed.append(Coding(concept))
    return parsed


def save(view_name: str, view_sql: str, outfile=None) -> str:
    """
    :param view_name: create view as
    :param view_sql: SQL commands
    :param outfile: default view_name.sql
    :return: outfile path
    """
    if not outfile:
        outfile = get_path(f"{view_name}.sql")
    print(f"\nsave({view_name})")
    print(f"{outfile}\n")
    with open(outfile, "w") as fp:
        fp.write(view_sql)
    return outfile


def define_rx_ucdavis():
    """
    Curated/Supplied by UC Davis
    """
    df = get_sheet("OpioidMedications")

    col_code = "RxNORM Concept Unique Identifier (RxCUI)"
    col_display = "Drug Name"

    df = df[[col_code, col_display]]
    codings = list()

    for record in df.to_dict(orient="records"):
        for code in str(record[col_code]).split(","):
            as_fhir = {
                "system": Vocab.RXNORM.value,
                "display": record[col_display],
                "code": code,
            }
            codings.append(Coding(as_fhir))

    save("define_rx_ucdavis", coding2view("define_rx_ucdavis", codings))


def define_dx():
    """
    Notice: Epic Bulk-FHIR provides SNOMED not ICD10 !
    This is for reproducibility
    """
    df = get_sheet("DxOpioid-InvolvedOverdoseCodes")

    col_code = "ICD-10-CM Codes"
    col_display = "Description"

    df = df[[col_display, col_code]]
    codings = list()

    for record in df.to_dict(orient="records"):
        for code in str(record[col_code]).split(","):
            as_fhir = {
                "system": Vocab.ICD10.value,
                "display": record[col_display],
                "code": code,
            }
            codings.append(Coding(as_fhir))

    save("define_dx", coding2view("define_dx", codings))


def define_lab():
    """
    Notice: Epic Bulk-FHIR provides SNOMED not ICD10 !
    This is for reproducibility
    """
    df = get_sheet("Opioid-InvolvedLabCodes")

    col_code = "LOINC Code"
    col_display = "Description"

    df = df[[col_display, col_code]]
    codings = list()

    for record in df.to_dict(orient="records"):
        for code in str(record[col_code]).split(","):
            as_fhir = {
                "system": Vocab.LOINC.value,
                "display": record[col_display],
                "code": code,
            }
            codings.append(Coding(as_fhir))

    save("define_lab", coding2view("define_lab", codings))


def define_sepsis():
    """
    Optional use: SEPSIS is a common and deadly outcome for OUD populations.
    :return:
    """
    codings = valueset2coding("valueset_sepsis_snomed.json")
    codings += valueset2coding("valueset_sepsis_icd10.json")

    save("define_sepsis", coding2view("define_dx_sepsis", codings))


def define_dx_sud_substance_use_disorder():
    """
    VSAC definitions of substance use disorder (SUD)
    """
    codings = valueset2coding("valueset_dx_sud_substance_use_disorder.json")
    save("define_dx_sud", coding2view("define_dx_sud", codings))


def define_rx_opioid():
    """
    VSAC definitions of opioid medications
    """
    codings = valueset2coding("valueset_rx_opioid.json")
    save("define_rx_opioid", coding2view("define_rx_opioid", codings))


def define_rx_buprenorphine():
    """
    VSAC definitions of Buprenorphine, for SUD treatment (dependence)
    """
    codings = valueset2coding("valueset_rx_buprenorphine.json")
    save("define_rx_buprenorphine", coding2view("define_rx_buprenorphine", codings))


def define_rx_naloxone():
    """
    VSAC definitions of Buprenorphine, for SUD treatment (overdose)
    """
    codings = valueset2coding("valueset_rx_naloxone.json")
    save("define_rx_naloxone", coding2view("define_rx_naloxone", codings))


if __name__ == "__main__":
    # define_dx()
    # define_lab()
    # define_rx_ucdavis()
    # define_sepsis()
    define_dx_sud_substance_use_disorder()
    define_rx_buprenorphine()
    define_rx_opioid()
    define_rx_naloxone()
