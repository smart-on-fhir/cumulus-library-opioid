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
call log('human_atc_non', 'begin');

drop   table if exists  human_atc_non;
create table            human_atc_non like human;

load    data
local   infile     'human_atc_non.tsv'
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



--drop table if exists human_acep;
--drop table if exists human_bwh;
--drop table if exists human_CancerLinQ;
--drop table if exists human_ecri;
--drop table if exists human_impaq;
--drop table if exists human_lantana;
--drop table if exists human_mitre;
--drop table if exists human_keywords;
--drop table if exists human_atc_non;
--drop table if exists human_CancerLinQ_non;
--drop table if exists human_mdpartners_non;
--drop table if exists human_medrt_non;
