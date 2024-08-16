import json
import os
import pathlib
from unittest import mock

from cumulus_library import study_manifest
from cumulus_library.template_sql import base_templates

from cumulus_library_opioid.vocab import (
    umls
)

@mock.patch.dict(
    os.environ,
    clear=True,
)
def test_umls_lookup(mock_db_config_rxnorm):
    test_path = pathlib.Path(__file__).parent / 'test_data/umls_iteration'
    csvs = list(test_path.glob('*.csv'))
    cursor = mock_db_config_rxnorm.db.cursor()
    cursor.execute("CREATE SCHEMA umls")
    for csv in csvs:
        cursor.execute(f"CREATE TABLE umls.{csv.stem} AS SELECT * FROM '{csv}'")
    #print (cursor.execute("select * from umls.mrconso").fetchall())

    query = base_templates.get_base_template(
        'umls_iterate',
        test_path / "../../../cumulus_library_opioid/vocab/template_sql",
        steward='medrt',
        prefix = 'opioid__',
        sab ="MED-RT",
        search_terms =["Opioid"],
        tier = 0
    )
    cursor.execute(query)
    res = cursor.execute("SELECT * FROM opioid__medrt_vocab_rel")
    print([x[0] for x in res.description])
    for row in res.fetchall():
        print (row)
    print('----')
    query = base_templates.get_base_template(
        'umls_iterate',
        test_path / "../../../cumulus_library_opioid/vocab/template_sql",
        steward='medrt',
        prefix = 'opioid__',
        sab ="MED-RT",
        search_terms =["Opioid"],
        tier = 1
    )
    print(query)
    cursor.execute(query)
#     query="""SELECT DISTINCT
# '1' as tier,r.cui2 AS cui, r.cui1, r.rel, r.rela,r.cui2,d.sab,d.tty, d.code,d.str
# FROM
# opioid__medrt_vocab_rel AS p,
# umls.mrrel_is_a AS r,
# umls.mrconso_drugs AS d

# WHERE r.cui1 = p.cui1
# AND r.cui2 = d.cui AND r.cui2 NOT IN (SELECT DISTINCT cui from opioid__medrt_vocab_rel)"""
    #print(cursor.execute(query).fetchall())
    
    res = cursor.execute("SELECT * FROM opioid__medrt_vocab_rel").fetchall()
    
    for row in res:
        print (row)
    raise Exception