"""Creates medication lists from UMLS

We're leveraging the MRCONSO and MRREL tables to do some recursive lookups.
For a given medical language system, we'll build up some relationships,
and then use those as a seed for the next iteration, continuing until we've
identified all concepts related to a specific set of seed values.

Source terminology (see UMLS docs for more details):

MRCONSO (source of concept information):
    SAB: Abbreviated source name of the concept. This is the name of the source 
        medical vocabulary, i.e. SNOMED, ICD10, MEDRT, etc
    CUI: the unique identifier for a concept in UMLS
    TTY: Term type abbreviation, i.e. CD for clinical drug, DF for dose form, etc
    CODE: The primary ID for a concept in the source vocabulary
    STR: The display name of the concept, like a drug's name
MRREL (source of mapping between concepts):
    SAB: Abbreviated source name of the relationship. Same as MRCONSO SAB
    CUI1: The UMLS ID of the concept you're mapping from
    CUI2: The UMLS ID of the concept you're mapping to
    REL: An abbreviation mapping to a relationship type, like RB (broader relationship),
        or RN (narrower relationship)
    RELA: The relationship between the concepts, like `tradename_of` or 
        `has_ingredient`. May be null.
"""
import pathlib

from cumulus_library import  base_utils, errors, study_manifest
from cumulus_library.template_sql import base_templates

from cumulus_library_opioid.vocab import vocab_utils


def get_umls_stewards(
    *,config:base_utils.StudyConfig | None = None, steward: str | None = None
) -> list[str]:
    """Gets the umls steward target(s) from the StudyConfig options"""
    if (not config and not steward) or (config and steward):
        raise errors.CumulusLibraryError(
            "get_umls_stewards() expects either a StudyConfig or a string."
        )
    if config:
        steward = config.options['steward']
    stewards = []
    if steward == 'all':
        stewards = vocab_utils.get_valid_stewards_for_source_type('umls')
    else:
        if steward in vocab_utils.get_valid_stewards_for_source_type('umls'):
            stewards.append(steward)
    return stewards

def generate_umls_tables(
    config: base_utils.StudyConfig, manifest: study_manifest.StudyManifest
):
    base_path = pathlib.Path(__file__).resolve().parent
    prefix = manifest.get_prefix_with_seperator()
    cursor = config.db.cursor()
    valid_vocabs = vocab_utils.get_valid_stewards_for_source_type('umls')
    stewards = get_umls_stewards(config=config)
    for steward in stewards:
        if steward not in valid_vocabs:
            continue
        cursor = config.db.cursor()
        display_text = f"Building {steward} medications, level "
        tier =  0
        with base_utils.get_progress_bar(disable=config.verbose) as progress:
            task= progress.add_task(
                display_text + str(tier),
                total=None,
                visible=not config.verbose)
            cursor.execute(f"DROP TABLE IF EXISTS {prefix}{steward}_vocab_rel")       
            cursor.execute(f"DROP TABLE IF EXISTS {prefix}{steward}_vocab")    
            query = base_templates.get_base_template(
                'umls_iterate',
                base_path / "template_sql",
                steward=steward,
                prefix = prefix,
                sab =vocab_utils.VOCABULARIES[steward].sab,
                search_terms =vocab_utils.VOCABULARIES[steward].search_terms,
                tier = tier
            )
            cursor.execute(query)
            print(query)
            prev=0
            current = cursor.execute(f"SELECT count(*) from {prefix}{steward}_vocab_rel").fetchone()[0]
            print(current)
            while current != prev and tier !=15:
                prev = current
                tier +=1
                progress.update(
                    task,
                    description=display_text + str(tier)
                )
                query = base_templates.get_base_template(
                    'umls_iterate',
                    base_path / "template_sql",
                    steward=steward,
                    prefix = prefix,
                    sab =vocab_utils.VOCABULARIES[steward].sab,
                    search_terms =vocab_utils.VOCABULARIES[steward].search_terms,
                    tier = tier
                )
                if tier <2:
                     print(query)
                cursor.execute(query)
                current = cursor.execute(f"SELECT count(*) from {prefix}{steward}_vocab_rel").fetchone()[0]
                print(current)
        cursor.execute(f"""CREATE TABLE {prefix}{steward}_vocab AS
SELECT DISTINCT a.code, b.str 
FROM {prefix}{steward}_vocab_rel AS a, umls.mrconso as b
WHERE a.cui=b.cui""")