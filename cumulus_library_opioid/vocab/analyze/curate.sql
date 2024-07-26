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

--    call create_index('curated','RXCUI');
--    call create_index('curated','STR(255)');

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

-- ##############################################
call log('RXNCONSO_curated', 'refresh');

drop    table if exists     RXNCONSO_curated;
create  table               RXNCONSO_curated
select  C.*
from    all_rxcui_str.RXNCONSO_curated C, curated
where   C.RXCUI = curated.RXCUI
order by C.RXCUI, C.STR;

<<<<<<< HEAD
--    drop    table if exists     RXNCONSO_curated;
--    create  table               RXNCONSO_curated
--    (
--        RXCUI   varchar(8)      NOT NULL,
--        STR     varchar(3000)   NOT NULL,
--        TTY     varchar(20)     NOT NULL,
--        SAB     varchar(20)     NOT NULL,
--        CODE    varchar(50)     NOT NULL,
--        keyword_str varchar(50) NULL,
--        keyword_len int         NULL
--    );
--
--    insert  into RXNCONSO_curated
--            ( RXCUI,   STR,   TTY,   SAB,   CODE, keyword_str, keyword_len)
--    select  distinct
--            C.RXCUI, C.STR, C.TTY, C.SAB, C.CODE
--    from    all_rxcui_str.RXNCONSO as C, curated
--    where   C.RXCUI = curated.RXCUI
--    order by RXCUI,STR;
--
--    update  RXNCONSO_curated C, keywords K
--    set
--        C.keyword_str = K.STR,
--        C.keyword_len = K.LEN
--    where lower(C.STR) like concat('%',K.STR, '%');
=======

--reinvestigate this st/len bit
update  RXNCONSO_curated C, keywords K
set
    C.keyword_str = K.STR,
    C.keyword_len = K.LEN
where lower(C.STR) like concat('%',K.STR, '%');
>>>>>>> 1f81ff0 (Rules expansion)

--    call create_index('RXNCONSO_curated','STR(255)');
--    call create_index('RXNCONSO_curated','RXCUI');

-- ##############################################
call log('RXNSTY_curated', 'refresh');

drop    table if exists RXNSTY_curated;
create  table           RXNSTY_curated
select  distinct SemType.*
from    rxnorm.RXNSTY as SemType,
        curated
where   SemType.RXCUI = curated.RXCUI;

--    call create_index('RXNSTY_curated','RXCUI');

-- ##############################################
call log('RXNREL_curated', 'refresh');

drop    table if exists RXNREL_curated;
create  table           RXNREL_curated
select  distinct R.*
from    rxnorm.RXNREL as R,
        curated
where   R.RXCUI1 = curated.RXCUI;

--    call create_index('RXNREL_curated','RXCUI1');
--    call create_index('RXNREL_curated','RXCUI2');

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

--    call create_index('RXNCONSO_curated_rela','RXCUI');
--    call create_index('RXNCONSO_curated_rela','RXCUI2');
--    call create_index('RXNCONSO_curated_rela','TTY');
--    call create_index('RXNCONSO_curated_rela','REL');
--    call create_index('RXNCONSO_curated_rela','RELA');

-- ##############################################
call log('curated.sql', 'done.');
