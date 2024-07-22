-- noqa: disable=all
-- This sql was autogenerated as a reference example using the library
-- CLI. Its format is tied to the specific database it was run against,
-- and it may not be correct for all databases. Use the CLI's build 
-- option to derive the best SQL for your dataset.

-- ###########################################################

CREATE OR REPLACE VIEW opioid__acep_rxnconso AS
SELECT
    a.rxcui,
    a.str,
    a.tty,
    a.sab,
    a.code
FROM rxnorm.rxnconso AS a,
    opioid__acep_vsac AS b
WHERE
    a.rxcui = b.code

-- ###########################################################

CREATE OR REPLACE VIEW opioid__acep_rxnconso_keywords_subset AS
SELECT
    a.rxcui,
    a.str,
    a.tty,
    a.sab,
    a.code,
    b.str AS keyword
FROM opioid__acep_rxnconso AS a,
    opioid__keywords AS b
WHERE
    lower(a.str) LIKE concat('%',b.STR, '%')

-- ###########################################################

CREATE OR REPLACE VIEW opioid__acep_rxnconso_keywords_annotated AS SELECT
    rxcui,
    str,
    tty,
    sab,
    code,
    b.keyword
FROM rxnorm.rxnconso AS a
    left join opioid__acep_rxnconso_keywords AS b USING(rxcui,str,tty,sab,code)

-- ###########################################################

CREATE OR REPLACE VIEW opioid__acep_rxnsty AS
SELECT
    a.rxcui,
    a.tui,
    a.stn,
    a.sty,
    a.atui,
    a.cvf
FROM rxnorm.rxnsty AS a,
    opioid__acep_vsac AS b
WHERE
    a.rxcui = b.code

-- ###########################################################

CREATE OR REPLACE VIEW opioid__acep_rxnrel AS
SELECT
    a.rxcui1,
    a.rxaui1,
    a.stype1,
    a.rel,
    a.rxcui2,
    a.rxaui2,
    a.stype2,
    a.rela,
    a.rui,
    a.srui,
    a.sab,
    a.sl,
    a.rg
FROM rxnorm.rxnrel AS a,
    opioid__acep_vsac AS b
WHERE
    a.rxcui1 = b.code

-- ###########################################################

CREATE OR REPLACE VIEW opioid__acep_rela AS
SELECT
    a.rxcui,
    a.str,
    a.tty,
    a.sab,
    b.rxcui2,
    b.rel,
    b.rela,
    b.rui
FROM opioid__acep_rxnconso_keywords AS a,
    opioid__acep_RXNREL AS b
WHERE
    a.rxcui = b.rxcui1