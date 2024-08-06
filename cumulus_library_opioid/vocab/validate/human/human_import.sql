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

drop   table if exists  human_ucdavis;
create table            human_ucdavis like human;

load    data
local   infile     'human_ucdavis.tsv'
into    table       human_ucdavis;
show warnings;




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
