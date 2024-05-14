
-- #########################################
-- generator.py -- 
-- #########################################
drop   table if exists   MRCONSO_medrt;
create table             MRCONSO_medrt
select distinct * from umls.MRCONSO
where SAB ='MED-RT' and ( (lower(STR) like lower('%Benzodiazepine%')) OR (lower(STR) like lower('%Barbiturate%')) OR (lower(STR) like lower('%Nonsteroidal Anti-inflammatory Drug%')) )
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

drop   table if exists   MRREL_medrt_cui10;
create table             MRREL_medrt_cui10
 select distinct 
 R.CUI1 as CUI9 ,
 R.REL, R.RELA ,
 R.CUI2 as CUI10 ,
 D.SAB, D.TTY, D.CODE, D.STR 
 FROM  MRREL_medrt_cui9 as I,
 MRREL_medrt  as R,
 MRCONSO_drug as D 
 WHERE R.CUI1 = I.CUI9 and   R.CUI2 = D.CUI and   R.CUI2 not in (select distinct CUI from curated_cui)
;
call create_index('MRREL_medrt_cui10', 'CUI9');
call create_index('MRREL_medrt_cui10', 'CUI10');
insert into curated_cui select distinct 'CUI10' as tier, CUI10 as CUI, R.* 
 from MRREL_medrt_cui10 as R
;
 SELECT
 count(distinct CUI9) as cnt_cui9,
 count(distinct CUI10) as cnt_cui10,
 REL, RELA, TTY
 from MRREL_medrt_cui10
 group by REL,RELA, TTY
 order by cnt_cui10 desc, cnt_cui9 desc
;

-- #########################################

drop   table if exists   MRREL_medrt_cui11;
create table             MRREL_medrt_cui11
 select distinct 
 R.CUI1 as CUI10 ,
 R.REL, R.RELA ,
 R.CUI2 as CUI11 ,
 D.SAB, D.TTY, D.CODE, D.STR 
 FROM  MRREL_medrt_cui10 as I,
 MRREL_medrt  as R,
 MRCONSO_drug as D 
 WHERE R.CUI1 = I.CUI10 and   R.CUI2 = D.CUI and   R.CUI2 not in (select distinct CUI from curated_cui)
;
call create_index('MRREL_medrt_cui11', 'CUI10');
call create_index('MRREL_medrt_cui11', 'CUI11');
insert into curated_cui select distinct 'CUI11' as tier, CUI11 as CUI, R.* 
 from MRREL_medrt_cui11 as R
;
 SELECT
 count(distinct CUI10) as cnt_cui10,
 count(distinct CUI11) as cnt_cui11,
 REL, RELA, TTY
 from MRREL_medrt_cui11
 group by REL,RELA, TTY
 order by cnt_cui11 desc, cnt_cui10 desc
;

-- #########################################

drop   table if exists   MRREL_medrt_cui12;
create table             MRREL_medrt_cui12
 select distinct 
 R.CUI1 as CUI11 ,
 R.REL, R.RELA ,
 R.CUI2 as CUI12 ,
 D.SAB, D.TTY, D.CODE, D.STR 
 FROM  MRREL_medrt_cui11 as I,
 MRREL_medrt  as R,
 MRCONSO_drug as D 
 WHERE R.CUI1 = I.CUI11 and   R.CUI2 = D.CUI and   R.CUI2 not in (select distinct CUI from curated_cui)
;
call create_index('MRREL_medrt_cui12', 'CUI11');
call create_index('MRREL_medrt_cui12', 'CUI12');
insert into curated_cui select distinct 'CUI12' as tier, CUI12 as CUI, R.* 
 from MRREL_medrt_cui12 as R
;
 SELECT
 count(distinct CUI11) as cnt_cui11,
 count(distinct CUI12) as cnt_cui12,
 REL, RELA, TTY
 from MRREL_medrt_cui12
 group by REL,RELA, TTY
 order by cnt_cui12 desc, cnt_cui11 desc
;

-- #########################################

drop   table if exists   MRREL_medrt_cui13;
create table             MRREL_medrt_cui13
 select distinct 
 R.CUI1 as CUI12 ,
 R.REL, R.RELA ,
 R.CUI2 as CUI13 ,
 D.SAB, D.TTY, D.CODE, D.STR 
 FROM  MRREL_medrt_cui12 as I,
 MRREL_medrt  as R,
 MRCONSO_drug as D 
 WHERE R.CUI1 = I.CUI12 and   R.CUI2 = D.CUI and   R.CUI2 not in (select distinct CUI from curated_cui)
;
call create_index('MRREL_medrt_cui13', 'CUI12');
call create_index('MRREL_medrt_cui13', 'CUI13');
insert into curated_cui select distinct 'CUI13' as tier, CUI13 as CUI, R.* 
 from MRREL_medrt_cui13 as R
;
 SELECT
 count(distinct CUI12) as cnt_cui12,
 count(distinct CUI13) as cnt_cui13,
 REL, RELA, TTY
 from MRREL_medrt_cui13
 group by REL,RELA, TTY
 order by cnt_cui13 desc, cnt_cui12 desc
;

-- #########################################

drop   table if exists   MRREL_medrt_cui14;
create table             MRREL_medrt_cui14
 select distinct 
 R.CUI1 as CUI13 ,
 R.REL, R.RELA ,
 R.CUI2 as CUI14 ,
 D.SAB, D.TTY, D.CODE, D.STR 
 FROM  MRREL_medrt_cui13 as I,
 MRREL_medrt  as R,
 MRCONSO_drug as D 
 WHERE R.CUI1 = I.CUI13 and   R.CUI2 = D.CUI and   R.CUI2 not in (select distinct CUI from curated_cui)
;
call create_index('MRREL_medrt_cui14', 'CUI13');
call create_index('MRREL_medrt_cui14', 'CUI14');
insert into curated_cui select distinct 'CUI14' as tier, CUI14 as CUI, R.* 
 from MRREL_medrt_cui14 as R
;
 SELECT
 count(distinct CUI13) as cnt_cui13,
 count(distinct CUI14) as cnt_cui14,
 REL, RELA, TTY
 from MRREL_medrt_cui14
 group by REL,RELA, TTY
 order by cnt_cui14 desc, cnt_cui13 desc
;

-- #########################################
