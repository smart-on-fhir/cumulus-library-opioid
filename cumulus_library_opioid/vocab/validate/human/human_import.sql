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

insert into human select *, 'acep'      from human_acep;
insert into human select *, 'CancerLinQ' from human_CancerLinQ;
insert into human select *, 'ecri'      from human_ecri;
insert into human select *, 'impaq'     from human_impaq;
insert into human select *, 'keywords'  from human_keywords;
insert into human select *, 'mdpartners_non'  from human_mdpartners_non;
insert into human select *, 'medrt_non'  from human_medrt_non;
insert into human select *, 'mitre'  from human_mitre;
insert into human select *, 'ucdavis'  from human_ucdavis;

drop    table if exists conflict_false_pos;
create  table           conflict_false_pos
select  distinct rxcui, str, vsac from    human
where   VOTES = 0
and     vsac not in ('keywords')
order by         rxcui, str, vsac;

drop    table if exists conflict_false_pos_count;
create  table           conflict_false_pos_count
select vsac, count(distinct rxcui) from conflict_false_pos
group by vsac order by vsac;

drop    table if exists conflict_false_neg;
create  table           conflict_false_neg
select  distinct rxcui, str, vsac from    human
where   VOTES > 0
and     vsac not in ('medrt_non', 'mdpartners_non', 'keywords')
order by  rxcui, str, vsac;

drop    table if exists conflict_false_neg_count;
create  table           conflict_false_neg_count
select vsac, count(distinct rxcui) from conflict_false_neg
group by vsac order by vsac;

drop    table if exists opioid_valueset;
create  table           opioid_valueset
select  distinct rxcui, str from curated
UNION
select distinct rxcui, str from conflict_false_neg
order by rxcui,str;




--    select count(distinct rxcui) cnt from conflict_false_neg where vsac not in ('medrt_non', 'mdpartners_non', 'ucdavis', 'keywords');
--    --    +-----+
--    --    |  33 |
--    --    +-----+
--
--    select vsac, count(distinct rxcui) cnt from conflict_false_neg group by vsac order by cnt desc
--    --    +----------------+-----+
--    --    | vsac           | cnt |
--    --    +----------------+-----+
--    --    | medrt_non      | 129 |
--    --    | mdpartners_non |  30 |
--    --    | CancerLinQ     |  14 |
--    --    | mitre          |  11 |
--    --    | keywords       |   5 |
--    --    | ecri           |   4 |
--    --    | ucdavis        |   1 |
--    --    +----------------+-----+
--
--    select vsac, count(distinct rxcui) cnt from conflict_false_pos group by vsac order by cnt desc;
--    --    +------------+-----+
--    --    | vsac       | cnt |
--    --    +------------+-----+
--    --    | keywords   | 139 |
--    --    | ucdavis    |  57 |
--    --    | impaq      |  12 |
--    --    | medrt_non  |   6 |
--    --    | mitre      |   4 |
--    --    | CancerLinQ |   2 |
--    --    | acep       |   1 |
--    --    | ecri       |   1 |
--    --    +------------+-----+
--
--    select count(distinct rxcui) from jaccard_superset_opioid where vsac not in ('opioid', 'medrt', 'bioportal');
--    --    +-----------------------+
--    --    |                  1956 |
--    --    +-----------------------+
--
--    select vsac, count(distinct rxcui) from jaccard_superset_opioid where vsac not in ('opioid', 'medrt', 'bioportal', 'lantana') group by vsac;
--    --    +------------+-----------------------+
--    --    | vsac       | count(distinct rxcui) |
--    --    +------------+-----------------------+
--    --    | acep       |                   836 |
--    --    | CancerLinQ |                  1612 |
--    --    | ecri       |                   455 |
--    --    | impaq      |                  1004 |
--    --    | lantana    |                   379 |
--    --    | math_349   |                   349 |
--    --    | mitre      |                   753 |
--    --    +------------+-----------------------+
--
--    select count(distinct rxcui) as cnt from jaccard_superset_non where vsac not in ('medrt_non');
--    --    +------+
--    --    | 3877 |
--    --    +------+
--
--    select vsac, count(distinct rxcui) as cnt from jaccard_superset_non where vsac not in ('medrt_non') group by vsac;
--    --    +----------------+------+
--    --    | vsac           | cnt  |
--    --    +----------------+------+
--    --    | atc_non        | 1968 |
--    --    | CancerLinQ_non | 1305 |
--    --    | mdpartners_non | 1906 |
--    --    | medrt_non      | 2048 | << do not count
--    --    +----------------+------+
--
--    select count(distinct rxcui) as cnt from jaccard_superset_rwd;
--
--    select vsac, count(distinct rxcui) as cnt from jaccard_superset_rwd group by vsac;
--    --    +---------+------+
--    --    | vsac    | cnt  |
--    --    +---------+------+
--    --    | bwh     |  228 |
--    --    | ucdavis | 1137 |
--    --    +---------+------+
--
--
