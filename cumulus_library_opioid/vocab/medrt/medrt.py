import unittest

from cumulus_library_opioid.vocab.generate.file_sql import (
    create,
    file_header,
    index,
    linebreak,
    str_like,
    tic,
)

MEDRT_RELA = ["isa", "tradename_of", "has_tradename", "has_basis_of_strength_substance"]

RXNORM_SAB = [
    "ATC",
    "CVX",
    "DRUGBANK",
    "GS",
    "MMSL",
    "MMX",
    "MTHCMSFRF" "MTHSPL",
    "NDDF",
    "RXNORM",
    "SNOMEDCT_US",
    "USP",
    "VANDF",
]


def drop_tables():
    _tables = [f"MRREL_medrt_cui{tier}" for tier in range(1, 15)]
    _tables += ["MRCONSO_drug", "MRCONSO_medrt", "MRREL_medrt"]
    return "DROP table if exists " + ", ".join(_tables) + ";\n"


def MRCONSO_medrt(where_str: str) -> str:
    _sql = [
        create("MRCONSO_medrt"),
        "select distinct * from umls.MRCONSO",
        f"where SAB ='MED-RT' and ({where_str})",
        ";",
        index("MRCONSO_medrt", "CUI"),
    ]
    return "\n".join(_sql)


def MRCONSO_drug() -> str:
    _sql = [
        create("MRCONSO_drug"),
        "select distinct * from umls.MRCONSO",
        f"where SAB in ({tic(RXNORM_SAB)})",
        ";",
        index("MRCONSO_drug", "CUI"),
        index("MRCONSO_drug", "TTY"),
        index("MRCONSO_drug", "SAB"),
        index("MRCONSO_drug", "CODE"),
    ]

    return "\n".join(_sql)


def curated_cui_root() -> str:
    _sql = [
        create("curated_cui"),
        "select  distinct 'CUI1' as tier, CUI1  as CUI, R.*",
        "from    MRREL_medrt_cui1 R",
        ";",
        index("curated_cui", "CUI"),
        index("curated_cui", "SAB,CODE"),
    ]
    return "\n".join(_sql)


def curated_cui(tier) -> str:
    _sql = [
        "insert into curated_cui"
        f" select distinct 'CUI{tier}' as tier, CUI{tier} as CUI, R.* ",
        f" from MRREL_medrt_cui{tier} as R",
        ";",
    ]
    return "\n".join(_sql)


def MRREL_medrt() -> str:
    tablename = "MRREL_medrt"
    _sql = [
        create(tablename),
        " select * from umls.MRREL ",
        " WHERE REL = 'CHD' ",
        f" OR   RELA in ({tic(MEDRT_RELA)})",
        ";",
        " delete from MRREL_medrt where REL in ('RB', 'PAR')",
        ";",
        index(tablename, "CUI1"),
        index(tablename, "SAB"),
    ]
    return "\n".join(_sql)


def MRREL_medrt_cui_root() -> str:
    tablename = "MRREL_medrt_cui1"

    _select = (
        "select  distinct R.CUI1, R.REL, R.RELA, R.CUI2, R.SAB, C.TTY, C.CODE, C.STR"
    )
    _from = "from  MRREL_medrt R, MRCONSO_medrt C"
    _where = "where   R.CUI1 = C.CUI"
    _sql = [
        create(tablename),
        _select,
        _from,
        _where,
        ";",
        index(tablename, "CUI1"),
        index(tablename, "SAB,CODE"),
    ]
    return "\n".join(_sql)


def MRREL_medrt_cui(tier: int) -> str:
    tablename = f"MRREL_medrt_cui{tier}"

    _sql = [
        create(tablename),
        " select distinct ",
        f" R.CUI1 as CUI{tier-1} ,",
        " R.REL, R.RELA ,",
        f" R.CUI2 as CUI{tier} ,",
        " D.SAB, D.TTY, D.CODE, D.STR ",
        f" FROM " f" MRREL_medrt_cui{tier-1} as I,",
        " MRREL_medrt  as R,",
        " MRCONSO_drug as D ",
        f" WHERE R.CUI1 = I.CUI{tier-1}"
        f" and   R.CUI2 = D.CUI"
        f" and   R.CUI2 not in (select distinct CUI from curated_cui)",
        ";",
        index(tablename, f"CUI{tier-1}"),
        index(tablename, f"CUI{tier}"),
    ]

    return "\n".join(_sql)


def MRREL_medrt_cui_cnt(tier) -> str:
    _sql = [
        " SELECT",
        f" count(distinct CUI{tier-1}) as cnt_cui{tier-1},",
        f" count(distinct CUI{tier}) as cnt_cui{tier},",
        " REL, RELA, TTY",
        f" from MRREL_medrt_cui{tier}",
        " group by REL,RELA, TTY",
        f" order by cnt_cui{tier} desc, cnt_cui{tier-1} desc",
        ";",
    ]
    return "\n".join(_sql)


def umls_init():
    _sql = [linebreak(), MRCONSO_drug(), linebreak(), MRREL_medrt(), linebreak()]
    return "\n".join(_sql)


def medrt(where: str):
    _sql = [  # umls_init(),
        MRCONSO_medrt(where),
        linebreak(),
        MRREL_medrt_cui_root(),
        linebreak(),
        curated_cui_root(),
        linebreak(),
    ]

    # TODO: notice, 15 is the soft "max" depth of MEDRT, the recursion shoudl STOP when there are new matches.
    for tier in range(2, 15):
        _sql.append(MRREL_medrt_cui(tier))
        _sql.append(curated_cui(tier))
        _sql.append(MRREL_medrt_cui_cnt(tier))
        _sql.append(linebreak())

    return "\n".join(_sql)


def medrt_opioid():
    return medrt(str_like(["Opioid"]))


def medrt_non():
    return medrt(
        str_like(
            ["Benzodiazepine", "Barbiturate", "Nonsteroidal Anti-inflammatory Drug"]
        )
    )


class MEDRT_Test(unittest.TestCase):
    def test_sql(self):
        with open("generated/medrt_umls_init.sql", "w") as fp:
            fp.writelines(file_header() + umls_init())

        with open("generated/medrt_opioid.sql", "w") as fp:
            fp.writelines(file_header() + medrt_opioid())

        with open("generated/medrt_non.sql", "w") as fp:
            fp.writelines(file_header() + medrt_non())

        with open("generated/medrt_drop.sql", "w") as fp:
            fp.writelines(file_header() + drop_tables())


if __name__ == "__main__":
    unittest.main()
