import unittest
from cumulus_library_opioid.opioid.vocab.constants import CURATED_LIST

def jaccard_insert() -> str:
    _insert = list()

    for vsac1 in CURATED_LIST:
        _insert.append(jaccard_valueset(vsac1))
        _insert.append(jaccard_superset(vsac1))

        for vsac2 in CURATED_LIST:
            _insert.append(jaccard_intersect(vsac1, vsac2))
            _insert.append(jaccard_difference(vsac1, vsac2))

    _insert.append(jaccard_intersect_size())
    _insert.append(jaccard_difference_size())

    return '\n'.join(_insert)

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

class JaccardTest(unittest.TestCase):

    def test_jaccard(self):
        _output = jaccard_insert()

        with open('generated/jaccard_insert.sql', 'w') as fp:
            fp.writelines(_output)


if __name__ == '__main__':
    unittest.main()
