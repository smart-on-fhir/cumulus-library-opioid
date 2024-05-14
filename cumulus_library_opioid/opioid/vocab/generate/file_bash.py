import unittest
from cumulus_library_opioid.opioid.vocab.constants import CURATED_LIST

BASH_HEAD = """
#!/bin/bash
set -e
source db.config
source env_table_schema.sh

"""

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


class BashFileGenerateTest(unittest.TestCase):

    def test_drop_all(self):
        with open('drop_all.sh', 'w') as fp:
            fp.writelines(drop_all())

    def test_link_tier(self):
        with open('./infile/link_curated.sh', 'w') as fp:
            fp.writelines(link_tier('curated'))

        with open('./infile/link_cat.sh', 'w') as fp:
            fp.writelines(link_tier('cat'))

    def test_make_all(self):
        with open('../make_all.sh', 'w') as fp:
            fp.writelines(make_all())

        with open('./make_all_recursive.sh', 'w') as fp:
            fp.writelines(make_all_recursive())


if __name__ == '__main__':
    unittest.main()
