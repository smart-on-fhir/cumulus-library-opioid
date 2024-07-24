-- ##############################################
call log('all_rxcui_str.sql', 'begin');

drop   table if exists   MRCONSO_drug;
create table             MRCONSO_drug
select distinct * from umls.MRCONSO
where SAB in ('ATC','CVX','DRUGBANK','GS','MMSL','MMX','MTHCMSFRFMTHSPL','NDDF','RXNORM','SNOMEDCT_US','USP','VANDF');

call create_index('MRCONSO_drug', 'CUI');
call create_index('MRCONSO_drug', 'CODE,SAB');

drop    table if exists rxcui_str;
create  table           rxcui_str
select distinct RXCUI, STR from rxnorm.RXNCONSO order by RXCUI,STR;

call create_index('rxcui_str', 'CUI');
call create_index('rxcui_str', 'STR');

--    TODO: deprecated?
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
