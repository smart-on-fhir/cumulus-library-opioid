-- obseleted by rxnorm_vsac_builder

-- ##############################################
call log('curate.sql', 'begin');

drop    table if exists curated;
create  table           curated
(
    RXCUI   varchar(8)      NOT NULL,
    STR     varchar(3000)   NOT NULL
);

call log('infile', 'curated.tsv');

load    data
local   infile     'data/curated.tsv'
into    table       curated;
show warnings; 

call create_index('curated','RXCUI');
call create_index('curated','STR(255)');

-- #############################################################################
call log('curated', 'curated_orig');

rename  table   curated to curated_orig;
create  table   curated
select  distinct
        trim(RXCUI) as RXCUI,
        trim(STR)   as STR
from    curated_orig
order by trim(STR);

-- if header was provided, remove header row.
delete from curated where (RXCUI like '%RXCUI%');


-- #############################################################################
call log('curated', 'curated_rxcui_str');

drop    table if exists curated_rxcui_str;
create  table           curated_rxcui_str
select  distinct
        A.RXCUI,
        A.STR
from    curated C, all_rxcui_str.curated A
where   C.RXCUI = A.RXCUI;

-- ##############################################
call log('RXNCONSO_curated', 'refresh');

drop    table if exists     RXNCONSO_curated;
create  table               RXNCONSO_curated
select  C.*
from    all_rxcui_str.RXNCONSO_curated C, curated
where   C.RXCUI = curated.RXCUI
order by C.RXCUI, C.STR;

-- ##############################################
call log('curated_keywords', 'refresh');

drop    table if exists curated_keywords;
create  table           curated_keywords
select distinct RXCUI, STR from RXNCONSO_curated where keyword_len >= 4
order by        RXCUI, STR;

-- ##############################################
call log('RXNSTY_curated', 'refresh');

drop    table if exists RXNSTY_curated;
create  table           RXNSTY_curated
select  distinct SemType.*
from    rxnorm.RXNSTY as SemType,
        curated
where   SemType.RXCUI = curated.RXCUI;

call create_index('RXNSTY_curated','RXCUI');

-- ##############################################
call log('RXNREL_curated', 'refresh');

drop    table if exists RXNREL_curated;
create  table           RXNREL_curated
select  distinct R.*
from    rxnorm.RXNREL as R,
        curated
where   R.RXCUI1 = curated.RXCUI;

call create_index('RXNREL_curated','RXCUI1');
call create_index('RXNREL_curated','RXCUI2');

-- ##############################################
call log('RXNCONSO_curated_rela', 'refresh'); 

drop    table if exists RXNCONSO_curated_rela;
create  table           RXNCONSO_curated_rela
select  distinct
        C.RXCUI,
        C.STR,
        C.TTY,
        C.SAB,
        R.RXCUI2,
        R.REL,
        R.RELA,
        R.RUI
from    RXNCONSO_curated as C,
        RXNREL_curated as R
where   R.RXCUI1 = C.RXCUI;

call create_index('RXNCONSO_curated_rela','RXCUI');
call create_index('RXNCONSO_curated_rela','RXCUI2');
call create_index('RXNCONSO_curated_rela','TTY');
call create_index('RXNCONSO_curated_rela','REL');
call create_index('RXNCONSO_curated_rela','RELA');

-- ##############################################
call log('curated.sql', 'done.');
