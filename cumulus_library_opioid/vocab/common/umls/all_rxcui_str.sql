-- ##############################################
call log('all_rxcui_str.sql', 'refresh');

-- ##############################################
call log('RXNCONSO_curated', 'refresh');

drop    table if exists     RXNCONSO_curated;
create  table               RXNCONSO_curated
(
    RXCUI   varchar(8)      NOT NULL,
    STR     varchar(3000)   NOT NULL,
    TTY     varchar(20)     NOT NULL,
    SAB     varchar(20)     NOT NULL,
    CODE    varchar(50)     NOT NULL,
    keyword_str varchar(50) NULL,
    keyword_len int         NULL
);

insert  into RXNCONSO_curated
        ( RXCUI,   STR,   TTY,   SAB,   CODE)
select  distinct
        C.RXCUI, C.STR, C.TTY, C.SAB, C.CODE
from    rxnorm.RXNCONSO as C
order by RXCUI,STR;

update  RXNCONSO_curated C, keywords K
set
    C.keyword_str = K.STR,
    C.keyword_len = K.LEN
where lower(C.STR) like concat('%',K.STR, '%');

-- ##############################################
call log('rxcui_str', 'refresh');

drop    table if exists rxcui_str;
create  table           rxcui_str
select distinct RXCUI, STR from rxnorm.RXNCONSO order by RXCUI,STR;

call create_index('rxcui_str', 'RXCUI');
call create_index('rxcui_str', 'STR(255)');

-- ##############################################
call log('MRCONSO_drug', 'refresh');

drop   table if exists   MRCONSO_drug;
create table             MRCONSO_drug
select distinct * from umls.MRCONSO
where SAB in ('ATC','CVX','DRUGBANK','GS','MMSL','MMX','MTHCMSFRFMTHSPL','NDDF','RXNORM','SNOMEDCT_US','USP','VANDF');

call create_index('MRCONSO_drug', 'CUI');
call create_index('MRCONSO_drug', 'CODE,SAB');

--    TODO: deprecated
--    drop    table if exists rxcui_cui;
--    create  table           rxcui_cui
--    select  distinct R.RXCUI, U.CUI, U.SAB, U.CODE
--    from    rxnorm.RXNCONSO R,
--            MRCONSO_drug U
--    where   R.SAB  = U.SAB
--    and     R.CODE = U.CODE;
--
--    call create_index('rxcui_cui', 'RXCUI');
--    call create_index('rxcui_cui', 'CUI');
--    call create_index('rxcui_cui', 'RXCUI, CUI');
--    call create_index('rxcui_cui', 'SAB, CODE');

-- ##############################################
call log('all_rxcui_str.sql', 'done');
