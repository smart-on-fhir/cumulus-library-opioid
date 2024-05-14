import unittest

CURATED_NON = ['CancerLinQ_non', 'mdpartners_non', 'atc_non', 'medrt_non']
CURATED_KEYWORDS = ['cliniwiz_keywords', 'keywords']
CURATED_OPIOID = [
    'acep',
    'bioportal',
    'CancerLinQ',
    'ecri',
    'impaq',
    'lantana',
    'math_349',
    'medrt',
    'mitre']

CURATED_LIST = CURATED_OPIOID + CURATED_NON + CURATED_KEYWORDS

BASH_HEAD = """
#!/bin/bash
set -e
source db.config
source env_table_schema.sh

"""

CREATE_SCHEMA = """
drop    table if exists jaccard_valueset;
table   table           jaccard_valueset
(
    vsac        varchar(30)     not null,
    size        int             not null
);

drop    table if exists jaccard_superset;
table   table           jaccard_superset
(
    vsac        varchar(30)     not null,
    rxcui       varchar(8)      not null
);

drop    table if exists jaccard_superset_opioid;
table  table           jaccard_superset_opioid
(
    vsac        varchar(30)     not null,
    rxcui       varchar(8)      not null
);

drop    table if exists jaccard_superset_opioid_size;
table  table           jaccard_superset_opioid_size
(
    rxcui       varchar(8)      not null,
    size        int             not null
);

drop    table if exists jaccard_superset_non;
table  table           jaccard_superset_non
(
    vsac        varchar(30)     not null,
    rxcui       varchar(8)      not null
);

drop    table if exists jaccard_superset_non_size;
table  table           jaccard_superset_non_size
(
    rxcui       varchar(8)      not null,
    size        int             not null
);

drop    table if exists jaccard_intersect;
table  table           jaccard_intersect
(
    vsac1       varchar(30)     not null,
    vsac2       varchar(30)     not null,
    rxcui       varchar(8)      not null    
);

drop    table if exists jaccard_intersect_size;
table  table           jaccard_intersect_size
(
    vsac1       varchar(30)     not null,
    vsac2       varchar(30)     not null,
    size        int             not null    
);

drop    table if exists jaccard_difference;
table  table           jaccard_difference
(
    vsac1       varchar(30)     not null,
    vsac2       varchar(30)     not null,
    rxcui       varchar(8)      not null
);

drop    table if exists jaccard_difference_size;
table  table           jaccard_difference_size
(
    vsac1       varchar(30)     not null,
    vsac2       varchar(30)     not null,
    size        int             not null
);

drop    table if exists jaccard_score;
table  table           jaccard_score
(
    vsac1       varchar(30)     not null,
    vsac2       varchar(30)     not null,
    size1       int             not null, 
    size2       int             not null,
    inter       int             default 0,
    diff        int             default 0,  
    score       float           NULL
);
"""

JACCARD_SCORE = """
truncate jaccard_score; 

insert into jaccard_score (vsac1, vsac2, size1, size2)
select distinct A.vsac, B.vsac, A.size, B.size 
from jaccard_valueset A, jaccard_valueset B
order by A.vsac, B.vsac;

update jaccard_score S, jaccard_difference_size D
set S.diff  = D.size
where S.vsac1 = D.vsac1 and S.vsac2 = D.vsac2; 

update jaccard_score S, jaccard_intersect_size I 
set S.inter = I.size
where S.vsac1 = I.vsac1 and S.vsac2 = I.vsac2;

update jaccard_score set score = round(inter / (size1 + size2 - inter), 3);

insert into jaccard_superset_opioid
select distinct vsac, RXCUI from jaccard_superset 
where vsac not like '%_non' 
and   vsac not like '%keyword%'; 

insert into jaccard_superset_non 
select distinct vsac, RXCUI from jaccard_superset 
where vsac      like '%_non' 
and   vsac  not like '%keyword%'; 

insert into jaccard_superset_opioid_size (RXCUI, size)
select RXCUI, count(distinct vsac) as size from jaccard_superset_opioid group by RXCUI order by RXCUI;

insert into jaccard_superset_non_size (RXCUI, size)
select RXCUI, count(distinct vsac) as size from jaccard_superset_non group by RXCUI order by RXCUI;    

drop table if exists jaccard_superset_opioid_size_dist; 
table table          jaccard_superset_opioid_size_dist
select count(distinct RXCUI) cnt_rxcui, size
from jaccard_superset_opioid_size 
group by size order by size desc;

drop table if exists jaccard_superset_opioid_avg_score; 
table table         jaccard_superset_opioid_avg_score
select vsac1, round(avg(score),3) as avg_score
from jaccard_score
where vsac2 not like ('%keywords%')
and   vsac2 not like ('%_non%')
group by vsac1 order by avg_score desc;

drop table if exists jaccard_recall; 
table table         jaccard_recall
select S.*, round((inter/size2),3) as recall 
from jaccard_score S
where vsac2 not like ('%keywords%')
and   vsac2 not like ('%_non%') 
order by vsac1, recall desc;
 
"""

def jaccard() -> str:
    """
    select count(distinct(RXCUI)) from bioportal.curated;
    select count(distinct RXCUI2) cnt from bioportal.expand_strict_rxcui_str;
    select count(distinct RXCUI2) cnt from bioportal.expand_keywords_rxcui_str;
    """
    _insert = list()

    for vsac1 in CURATED_LIST:
        _insert.append(jaccard_valueset(vsac1))
        _insert.append(jaccard_superset(vsac1))

        for vsac2 in CURATED_LIST:
            _insert.append(jaccard_intersect(vsac1, vsac2))
            _insert.append(jaccard_difference(vsac1, vsac2))

    _insert.append(jaccard_intersect_size())
    _insert.append(jaccard_difference_size())

    return CREATE_SCHEMA + '\n'.join(_insert) + JACCARD_SCORE

def jaccard_valueset(vsac1: str) -> str:
    _insert = f" insert into jaccard_valueset (vsac, size)"
    _select = f" select '{vsac1}', count(distinct RXCUI) from {vsac1}.curated;"
    return _insert + _select

def jaccard_superset(vsac1: str) -> str:
    _insert = f" insert into jaccard_superset (vsac, rxcui)"
    _select = f" select distinct '{vsac1}', RXCUI from {vsac1}.curated;"
    return _insert + _select

def jaccard_intersect(vsac1: str, vsac2: str) -> str:
    _insert = f" insert into jaccard_intersect (vsac1, vsac2, rxcui)"
    _select = f" select distinct '{vsac1}', '{vsac2}', A.RXCUI"
    _from = f" from {vsac1}.curated A, {vsac2}.curated B"
    _where = f" where A.RXCUI= B.RXCUI ;"
    return _insert + _select + _from + _where

def jaccard_difference(vsac1: str, vsac2: str) -> str:
    _insert = f" insert into jaccard_difference (vsac1, vsac2, rxcui)"
    _select = f" select distinct '{vsac1}', '{vsac2}', A.RXCUI"
    _from = f" from {vsac1}.curated A "
    _where = f" where A.RXCUI not in (select distinct RXCUI from {vsac2}.curated B);"
    return _insert + _select + _from + _where

def jaccard_intersect_size() -> str:
    return "INSERT into jaccard_intersect_size  " \
           "select vsac1, vsac2, count(distinct RXCUI) from jaccard_intersect  " \
           "group by vsac1, vsac2 order by vsac1, vsac2;"

def jaccard_difference_size() -> str:
    return "INSERT into jaccard_difference_size  " \
           "select vsac1, vsac2, count(distinct RXCUI) from jaccard_difference  " \
           "group by vsac1, vsac2 order by vsac1, vsac2;"

def drop_all() -> str:
    _drop = [drop_database(vsac) for vsac in CURATED_LIST]

    return BASH_HEAD + '\n'.join(_drop)

def export(vsac, command=None) -> str:
    if command:
        return export(vsac) + command + "\n"
    else:
        return f"export CURATED='{vsac}'\n"

def drop_database(vsac) -> str:
    return export(vsac, "./drop_database.sh")

def make_all() -> str:
    _make = [export(vsac, './make.sh') for vsac in CURATED_LIST]
    return BASH_HEAD + '\n'.join(_make)

def make_all_recursive() -> str:
    _make = [export(vsac, './make_recursive.sh') for vsac in CURATED_LIST]
    return BASH_HEAD + '\n'.join(_make)

def make_recursive(vsac) -> str:
    _orig = f"infile/{vsac}/{vsac}.curated.tsv"
    _make = ["rm -f curated.tsv",
             f"ln -s infile/${vsac}.tsv curated.tsv",
             "./make.sh"]

    for i in range(1, 15):
        _copy = []

    return '\n'.join(_make)

def link_tier(tier='curated') -> str:
    _cmd = list()
    for vsac in CURATED_LIST:
        _cmd += [f"rm -f {vsac}.tsv",
                 f"ln -s {vsac}/{vsac}.{tier}.tsv {vsac}.tsv\n"]
    return '\n'.join(_cmd)


class JaccardTest(unittest.TestCase):

    def test_jaccard(self):
        _output = jaccard()
        print(_output)

        with open('jaccard.sql', 'w') as fp:
            fp.writelines(_output)

    def test_drop_all(self):
        with open('drop_all.sh', 'w') as fp:
            fp.writelines(drop_all())

    def test_link_tier(self):
        with open('./infile/link_curated.sh', 'w') as fp:
            fp.writelines(link_tier('curated'))

        with open('./infile/link_cat.sh', 'w') as fp:
            fp.writelines(link_tier('cat'))

    def test_make_all(self):
        with open('./make_all.sh', 'w') as fp:
            fp.writelines(make_all())

        with open('./make_all_recursive.sh', 'w') as fp:
            fp.writelines(make_all_recursive())



if __name__ == '__main__':
    unittest.main()
