
-- #########################################
-- generator.py -- 
-- #########################################

-- #########################################

drop   table if exists   MRCONSO_drug;
create table             MRCONSO_drug
select distinct * from umls.MRCONSO
where SAB in ('ATC','CVX','DRUGBANK','GS','MMSL','MMX','MTHCMSFRFMTHSPL','NDDF','RXNORM','SNOMEDCT_US','USP','VANDF')
;
call create_index('MRCONSO_drug', 'CUI');
call create_index('MRCONSO_drug', 'TTY');
call create_index('MRCONSO_drug', 'SAB');
call create_index('MRCONSO_drug', 'CODE');

-- #########################################

drop   table if exists   MRREL_medrt;
create table             MRREL_medrt
 select * from umls.MRREL 
 WHERE REL = 'CHD' 
 OR   RELA in ('isa','tradename_of','has_tradename','has_basis_of_strength_substance')
;
 delete from MRREL_medrt where REL in ('RB', 'PAR')
;
call create_index('MRREL_medrt', 'CUI1');
call create_index('MRREL_medrt', 'SAB');

-- #########################################
