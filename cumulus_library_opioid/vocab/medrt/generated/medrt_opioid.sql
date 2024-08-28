
-- #########################################
-- file_sql.py -- 
-- #########################################
drop   table if exists   MRCONSO_medrt;
create table             MRCONSO_medrt
select distinct * from umls.MRCONSO
where SAB ='MED-RT' and ( (lower(STR) like lower('%Opioid%')) )
;
call create_index('MRCONSO_medrt', 'CUI');

-- #########################################

drop   table if exists   MRREL_medrt_cui1;
create table             MRREL_medrt_cui1
select  distinct R.CUI1, R.REL, R.RELA, R.CUI2, R.SAB, C.TTY, C.CODE, C.STR
from  MRREL_medrt R, MRCONSO_medrt C
where   R.CUI1 = C.CUI
;
call create_index('MRREL_medrt_cui1', 'CUI1');
call create_index('MRREL_medrt_cui1', 'SAB,CODE');

-- #########################################

drop   table if exists   curated_cui;
create table             curated_cui
select  distinct 'CUI1' as tier, CUI1  as CUI, R.*
from    MRREL_medrt_cui1 R
;
call create_index('curated_cui', 'CUI');
call create_index('curated_cui', 'SAB,CODE');

-- #########################################

drop   table if exists   MRREL_medrt_cui2;
create table             MRREL_medrt_cui2
 select distinct 
 R.CUI1 as CUI1 ,
 R.REL, R.RELA ,
 R.CUI2 as CUI2 ,
 D.SAB, D.TTY, D.CODE, D.STR 
 FROM  MRREL_medrt_cui1 as I,
 MRREL_medrt  as R,
 MRCONSO_drug as D 
 WHERE R.CUI1 = I.CUI1 and   R.CUI2 = D.CUI and   R.CUI2 not in (select distinct CUI from curated_cui)
;
call create_index('MRREL_medrt_cui2', 'CUI1');
call create_index('MRREL_medrt_cui2', 'CUI2');
insert into curated_cui select distinct 'CUI2' as tier, CUI2 as CUI, R.* 
 from MRREL_medrt_cui2 as R
;
 SELECT
 count(distinct CUI1) as cnt_cui1,
 count(distinct CUI2) as cnt_cui2,
 REL, RELA, TTY
 from MRREL_medrt_cui2
 group by REL,RELA, TTY
 order by cnt_cui2 desc, cnt_cui1 desc
;

-- #########################################

drop   table if exists   MRREL_medrt_cui3;
create table             MRREL_medrt_cui3
 select distinct 
 R.CUI1 as CUI2 ,
 R.REL, R.RELA ,
 R.CUI2 as CUI3 ,
 D.SAB, D.TTY, D.CODE, D.STR 
 FROM  MRREL_medrt_cui2 as I,
 MRREL_medrt  as R,
 MRCONSO_drug as D 
 WHERE R.CUI1 = I.CUI2 and   R.CUI2 = D.CUI and   R.CUI2 not in (select distinct CUI from curated_cui)
;
call create_index('MRREL_medrt_cui3', 'CUI2');
call create_index('MRREL_medrt_cui3', 'CUI3');
insert into curated_cui select distinct 'CUI3' as tier, CUI3 as CUI, R.* 
 from MRREL_medrt_cui3 as R
;
 SELECT
 count(distinct CUI2) as cnt_cui2,
 count(distinct CUI3) as cnt_cui3,
 REL, RELA, TTY
 from MRREL_medrt_cui3
 group by REL,RELA, TTY
 order by cnt_cui3 desc, cnt_cui2 desc
;

-- #########################################

drop   table if exists   MRREL_medrt_cui4;
create table             MRREL_medrt_cui4
 select distinct 
 R.CUI1 as CUI3 ,
 R.REL, R.RELA ,
 R.CUI2 as CUI4 ,
 D.SAB, D.TTY, D.CODE, D.STR 
 FROM  MRREL_medrt_cui3 as I,
 MRREL_medrt  as R,
 MRCONSO_drug as D 
 WHERE R.CUI1 = I.CUI3 and   R.CUI2 = D.CUI and   R.CUI2 not in (select distinct CUI from curated_cui)
;
call create_index('MRREL_medrt_cui4', 'CUI3');
call create_index('MRREL_medrt_cui4', 'CUI4');
insert into curated_cui select distinct 'CUI4' as tier, CUI4 as CUI, R.* 
 from MRREL_medrt_cui4 as R
;
 SELECT
 count(distinct CUI3) as cnt_cui3,
 count(distinct CUI4) as cnt_cui4,
 REL, RELA, TTY
 from MRREL_medrt_cui4
 group by REL,RELA, TTY
 order by cnt_cui4 desc, cnt_cui3 desc
;

-- #########################################

drop   table if exists   MRREL_medrt_cui5;
create table             MRREL_medrt_cui5
 select distinct 
 R.CUI1 as CUI4 ,
 R.REL, R.RELA ,
 R.CUI2 as CUI5 ,
 D.SAB, D.TTY, D.CODE, D.STR 
 FROM  MRREL_medrt_cui4 as I,
 MRREL_medrt  as R,
 MRCONSO_drug as D 
 WHERE R.CUI1 = I.CUI4 and   R.CUI2 = D.CUI and   R.CUI2 not in (select distinct CUI from curated_cui)
;
call create_index('MRREL_medrt_cui5', 'CUI4');
call create_index('MRREL_medrt_cui5', 'CUI5');
insert into curated_cui select distinct 'CUI5' as tier, CUI5 as CUI, R.* 
 from MRREL_medrt_cui5 as R
;
 SELECT
 count(distinct CUI4) as cnt_cui4,
 count(distinct CUI5) as cnt_cui5,
 REL, RELA, TTY
 from MRREL_medrt_cui5
 group by REL,RELA, TTY
 order by cnt_cui5 desc, cnt_cui4 desc
;

-- #########################################

drop   table if exists   MRREL_medrt_cui6;
create table             MRREL_medrt_cui6
 select distinct 
 R.CUI1 as CUI5 ,
 R.REL, R.RELA ,
 R.CUI2 as CUI6 ,
 D.SAB, D.TTY, D.CODE, D.STR 
 FROM  MRREL_medrt_cui5 as I,
 MRREL_medrt  as R,
 MRCONSO_drug as D 
 WHERE R.CUI1 = I.CUI5 and   R.CUI2 = D.CUI and   R.CUI2 not in (select distinct CUI from curated_cui)
;
call create_index('MRREL_medrt_cui6', 'CUI5');
call create_index('MRREL_medrt_cui6', 'CUI6');
insert into curated_cui select distinct 'CUI6' as tier, CUI6 as CUI, R.* 
 from MRREL_medrt_cui6 as R
;
 SELECT
 count(distinct CUI5) as cnt_cui5,
 count(distinct CUI6) as cnt_cui6,
 REL, RELA, TTY
 from MRREL_medrt_cui6
 group by REL,RELA, TTY
 order by cnt_cui6 desc, cnt_cui5 desc
;

-- #########################################

drop   table if exists   MRREL_medrt_cui7;
create table             MRREL_medrt_cui7
 select distinct 
 R.CUI1 as CUI6 ,
 R.REL, R.RELA ,
 R.CUI2 as CUI7 ,
 D.SAB, D.TTY, D.CODE, D.STR 
 FROM  MRREL_medrt_cui6 as I,
 MRREL_medrt  as R,
 MRCONSO_drug as D 
 WHERE R.CUI1 = I.CUI6 and   R.CUI2 = D.CUI and   R.CUI2 not in (select distinct CUI from curated_cui)
;
call create_index('MRREL_medrt_cui7', 'CUI6');
call create_index('MRREL_medrt_cui7', 'CUI7');
insert into curated_cui select distinct 'CUI7' as tier, CUI7 as CUI, R.* 
 from MRREL_medrt_cui7 as R
;
 SELECT
 count(distinct CUI6) as cnt_cui6,
 count(distinct CUI7) as cnt_cui7,
 REL, RELA, TTY
 from MRREL_medrt_cui7
 group by REL,RELA, TTY
 order by cnt_cui7 desc, cnt_cui6 desc
;

-- #########################################

drop   table if exists   MRREL_medrt_cui8;
create table             MRREL_medrt_cui8
 select distinct 
 R.CUI1 as CUI7 ,
 R.REL, R.RELA ,
 R.CUI2 as CUI8 ,
 D.SAB, D.TTY, D.CODE, D.STR 
 FROM  MRREL_medrt_cui7 as I,
 MRREL_medrt  as R,
 MRCONSO_drug as D 
 WHERE R.CUI1 = I.CUI7 and   R.CUI2 = D.CUI and   R.CUI2 not in (select distinct CUI from curated_cui)
;
call create_index('MRREL_medrt_cui8', 'CUI7');
call create_index('MRREL_medrt_cui8', 'CUI8');
insert into curated_cui select distinct 'CUI8' as tier, CUI8 as CUI, R.* 
 from MRREL_medrt_cui8 as R
;
 SELECT
 count(distinct CUI7) as cnt_cui7,
 count(distinct CUI8) as cnt_cui8,
 REL, RELA, TTY
 from MRREL_medrt_cui8
 group by REL,RELA, TTY
 order by cnt_cui8 desc, cnt_cui7 desc
;

-- #########################################

drop   table if exists   MRREL_medrt_cui9;
create table             MRREL_medrt_cui9
 select distinct 
 R.CUI1 as CUI8 ,
 R.REL, R.RELA ,
 R.CUI2 as CUI9 ,
 D.SAB, D.TTY, D.CODE, D.STR 
 FROM  MRREL_medrt_cui8 as I,
 MRREL_medrt  as R,
 MRCONSO_drug as D 
 WHERE R.CUI1 = I.CUI8 and   R.CUI2 = D.CUI and   R.CUI2 not in (select distinct CUI from curated_cui)
;
call create_index('MRREL_medrt_cui9', 'CUI8');
call create_index('MRREL_medrt_cui9', 'CUI9');
insert into curated_cui select distinct 'CUI9' as tier, CUI9 as CUI, R.* 
 from MRREL_medrt_cui9 as R
;
 SELECT
 count(distinct CUI8) as cnt_cui8,
 count(distinct CUI9) as cnt_cui9,
 REL, RELA, TTY
 from MRREL_medrt_cui9
 group by REL,RELA, TTY
 order by cnt_cui9 desc, cnt_cui8 desc
;

-- #########################################
