-- ##############################################
call log('human_import.sql', 'begin');

drop    table if exists human;
create  table           human
(
    RXCUI   varchar(8)      NOT NULL,
    STR     varchar(3000)   NOT NULL,
    votes   tinyint             NULL,
    vote1   tinyint             NULL,
    vote2   tinyint             NULL,
    vote3   tinyint             NULL
);

call create_index('human', 'RXCUI');

-- ##############################################
call log('human_acep', 'begin');

drop   table if exists  human_acep;
create table            human_acep like human;

load    data
local   infile     'human_acep.tsv'
into    table       human_acep;
show warnings;

delete from human_acep where RXCUI = 'RXCUI';


-- ##############################################
call log('human_CancerLinQ', 'begin');

drop   table if exists  human_CancerLinQ;
create table            human_CancerLinQ like human;

load    data
local   infile     'human_CancerLinQ.tsv'
into    table       human_CancerLinQ;
show warnings;

delete from human_CancerLinQ where RXCUI = 'RXCUI';

-- ##############################################
call log('human_ecri', 'begin');

drop   table if exists  human_ecri;
create table            human_ecri like human;

load    data
local   infile     'human_ecri.tsv'
into    table       human_ecri;
show warnings;

delete from human_ecri where RXCUI = 'RXCUI';

-- ##############################################
call log('human_impaq', 'begin');

drop   table if exists  human_impaq;
create table            human_impaq like human;

load    data
local   infile     'human_impaq.tsv'
into    table       human_impaq;
show warnings;

delete from human_impaq where RXCUI = 'RXCUI';

-- ##############################################
call log('human_ucdavis', 'begin');

drop   table if exists  human_ucdavis;
create table            human_ucdavis like human;

load    data
local   infile     'human_ucdavis.tsv'
into    table       human_ucdavis;
show warnings;

delete from human_ucdavis where RXCUI = 'RXCUI';

-- ##############################################
call log('human_keywords', 'begin');

drop   table if exists  human_keywords;
create table            human_keywords like human;

load    data
local   infile     'human_keywords.tsv'
into    table       human_keywords;
show warnings;

delete from human_keywords where RXCUI = 'RXCUI';



-- ##############################################
call log('human_mitre', 'begin');

drop   table if exists  human_mitre;
create table            human_mitre like human;

load    data
local   infile     'human_mitre.tsv'
into    table       human_mitre;
show warnings;

delete from human_mitre where RXCUI = 'RXCUI';


-- ##############################################
call log('human_atc_non', 'begin');

drop   table if exists  human_atc_non;
create table            human_atc_non like human;

load    data
local   infile     'human_atc_non_fixed.tsv'
into    table       human_atc_non;
show warnings;

delete from human_atc_non where RXCUI = 'RXCUI';

-- ##############################################
call log('human_medrt_non', 'begin');

drop   table if exists  human_medrt_non;
create table            human_medrt_non like human;

load    data
local   infile     'human_medrt_non.tsv'
into    table       human_medrt_non;
show warnings;

delete from human_medrt_non where RXCUI = 'RXCUI';

-- ##############################################
call log('human_mdpartners_non', 'begin');

drop   table if exists  human_mdpartners_non;
create table            human_mdpartners_non like human;

load    data
local   infile     'human_mdpartners_non.tsv'
into    table       human_mdpartners_non;
show warnings;

delete from human_mdpartners_non where RXCUI = 'RXCUI';

-- ##############################################


--    drop   table if exists  human;
--    drop   table if exists  human_acep;
--    drop   table if exists  human_CancerLinQ;
--    drop   table if exists  human_ucdavis;
--    drop   table if exists  human_keywords;
--    drop   table if exists  human_ecri;
--    drop   table if exists  human_impaq;
--    drop   table if exists  human_mitre;
--    drop   table if exists  human_atc_non;
--    drop   table if exists  human_medrt_non;
--    drop   table if exists  human_mdpartners_non;

alter table human add column vsac varchar(50);

insert into human select *, 'acep'      from human_acep where votes > 0;
insert into human select *, 'CancerLinQ' from human_CancerLinQ where votes > 0;
insert into human select *, 'ecri'      from human_ecri where votes > 0;
insert into human select *, 'impaq'     from human_impaq where votes > 0;
insert into human select *, 'keywords'  from human_keywords where votes > 0;
insert into human select *, 'mdpartners_non'  from human_mdpartners_non where votes > 0;
insert into human select *, 'medrt_non'  from human_medrt_non where votes > 0;
insert into human select *, 'mitre'  from human_mitre where votes > 0;
insert into human select *, 'ucdavis'  from human_ucdavis where votes > 0;



