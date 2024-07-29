-- ############################################################################
call log('medrt_rxcui.sql', 'begin');

-- ############################################################################
-- RXCUI mapping
-- ############################################################################
call log('curated_cui_rxcui', 'refresh');

drop    table if exists curated_cui_rxcui;
create  table           curated_cui_rxcui
select  distinct        C.*, R.RXCUI
from
    curated_cui     as C,
    rxnorm.RXNCONSO  as R
where
    C.SAB  = R.SAB  and
    C.CODE = R.CODE;

drop    table if exists curated;
create  table           curated
select  distinct        RXCUI, STR
from    curated_cui_rxcui
order by RXCUI, STR;


-- ############################################################################
-- STATS
-- ############################################################################
call log('curated_cui_stat', '*');

drop    table   if exists   curated_cui_stat;
create  table               curated_cui_stat
select      count(*) as cnt, count(distinct CUI) as cnt_cui,
            tier
from        curated_cui
group by    tier
order by    tier, cnt desc, cnt_cui desc;

drop    table   if exists   curated_cui_stat_rel;
create  table               curated_cui_stat_rel
select      count(*) as cnt, count(distinct CUI) as cnt_cui,
            tier, REL
from        curated_cui
group by    tier, REL
order by    tier, cnt desc, cnt_cui desc;

drop    table   if exists   curated_cui_stat_rela;
create  table               curated_cui_stat_rela
select      count(*) as cnt, count(distinct CUI) cnt_cui,
            tier, RELA
from        curated_cui
group by    tier, RELA
order by    tier, cnt desc, cnt_cui desc;

drop    table   if exists   curated_cui_stat_rel_rela;
create  table               curated_cui_stat_rel_rela
select      count(*) as cnt, count(distinct CUI) cnt_cui,
            tier, REL, RELA
from        curated_cui
group by    tier, REL, RELA
order by    tier, cnt desc, cnt_cui desc;

drop    table   if exists   curated_cui_stat_tty;
create  table               curated_cui_stat_tty
select      count(*) as cnt, count(distinct CUI) cnt_cui,
            tier, TTY
from        curated_cui
group by    tier, TTY
order by    tier, cnt desc, cnt_cui desc;

drop    table   if exists   curated_cui_stat_sab;
create  table               curated_cui_stat_sab
select      count(*) as cnt, count(distinct CUI) cnt_cui,
            tier, SAB
from        curated_cui
group by    tier, SAB
order by    tier, cnt desc, cnt_cui desc;

-- ##############################################
call log('medrt_rxcui.sql', 'done');
