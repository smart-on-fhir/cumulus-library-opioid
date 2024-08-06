-- ###########################################################################
call log('validate.sql', 'begin');

-- ###########################################################################
call log('invalid_RXCUI', 'should be null');

drop    table   if exists   invalid_RXCUI;
create  table               invalid_RXCUI
select  distinct vsac1, RXCUI
from    jaccard_difference
where   vsac2='all_rxcui_str' order by vsac1, RXCUI;

-- ###########################################################################
call log('missed_RXCUI', 'opioid missed  ucdavis (without join)');

drop    table   if exists   missed_RXCUI;
create  table               missed_RXCUI
select  distinct RXCUI
from    opioid.jaccard_difference
where   vsac1='ucdavis'
and     vsac2='opioid'
order by RXCUI;

-- ###########################################################################
call log('missed_RXCUI', 'opioid missed  ucdavis (WITH join)');

drop    table   if exists   missed_ucdavis;
create  table               missed_ucdavis
select  distinct A.RXCUI, A.STR
from    opioid.jaccard_difference J, all_rxcui_str.curated A
where   J.vsac1='ucdavis'
and     J.vsac2='opioid'
and     J.RXCUI = A.RXCUI
order by  A.RXCUI, A.STR;

-- ###########################################################################
call log('missed_*******', 'VSAC curations that were not found in opioid');

drop    table   if exists   missed_acep;
create  table               missed_acep
select  distinct A.RXCUI, A.STR
from    opioid.jaccard_difference J, all_rxcui_str.curated A
where   J.vsac1='acep'
and     J.vsac2='opioid'
and     J.RXCUI = A.RXCUI
order by A.RXCUI, A.STR;

drop    table   if exists   opioid.missed_bwh;
create  table               opioid.missed_bwh
select  distinct A.RXCUI, A.STR
from    opioid.jaccard_difference J, all_rxcui_str.curated A
where   J.vsac1='bwh'
and     J.vsac2='opioid'
and     J.RXCUI = A.RXCUI
order by A.RXCUI, A.STR;

drop    table   if exists   missed_CancerLinQ;
create  table               missed_CancerLinQ
select  distinct A.RXCUI, A.STR
from    opioid.jaccard_difference J, all_rxcui_str.curated A
where   J.vsac1='CancerLinQ'
and     J.vsac2='opioid'
and     J.RXCUI = A.RXCUI
order by A.RXCUI, A.STR;

drop    table   if exists   missed_ecri;
create  table               missed_ecri
select  distinct A.RXCUI, A.STR
from    opioid.jaccard_difference J, all_rxcui_str.curated A
where   J.vsac1='ecri'
and     J.vsac2='opioid'
and     J.RXCUI = A.RXCUI
order by A.RXCUI, A.STR;

drop    table   if exists   missed_impaq;
create  table               missed_impaq
select  distinct A.RXCUI, A.STR
from    opioid.jaccard_difference J, all_rxcui_str.curated A
where   J.vsac1='impaq'
and     J.vsac2='opioid'
and     J.RXCUI = A.RXCUI
order by A.RXCUI, A.STR;

drop    table   if exists   missed_lantana;
create  table               missed_lantana
select  distinct A.RXCUI, A.STR
from    opioid.jaccard_difference J, all_rxcui_str.curated A
where   J.vsac1='lantana'
and     J.vsac2='opioid'
and     J.RXCUI = A.RXCUI
order by A.RXCUI, A.STR;

drop    table   if exists   missed_mitre;
create  table               missed_mitre
select  distinct A.RXCUI, A.STR
from    opioid.jaccard_difference J, all_rxcui_str.curated A
where   J.vsac1='mitre'
and     J.vsac2='opioid'
and     J.RXCUI = A.RXCUI
order by A.RXCUI, A.STR;

-- ###########################################################################
call log('missed_keywords', 'keyword matches that were not in opioid vocab');

drop    table   if exists   missed_keywords;
create  table               missed_keywords
select  distinct A.RXCUI, A.STR
from    opioid.jaccard_difference J, all_rxcui_str.curated A
where   J.vsac1='keywords'
and     J.vsac2='opioid'
and     J.RXCUI = A.RXCUI
order by A.RXCUI, A.STR;

-- ###########################################################################
call log('falsepos_*******', 'False Positive entries, should be NON opioid');

drop    table   if exists   falsepos_atc_non;
create  table               falsepos_atc_non
select  distinct A.RXCUI, A.STR
from    opioid.jaccard_intersect J, all_rxcui_str.curated A
where   J.vsac1='atc_non'
and     J.vsac2='opioid'
and     J.RXCUI = A.RXCUI
order by A.RXCUI, A.STR;

drop    table   if exists   falsepos_CancerLinQ_non;
create  table               falsepos_CancerLinQ_non
select  distinct A.RXCUI, A.STR
from    opioid.jaccard_intersect J, all_rxcui_str.curated A
where   J.vsac1='CancerLinQ_non'
and     J.vsac2='opioid'
and     J.RXCUI = A.RXCUI
order by A.RXCUI, A.STR;

drop    table   if exists   falsepos_mdpartners_non;
create  table               falsepos_mdpartners_non
select  distinct A.RXCUI, A.STR
from    opioid.jaccard_intersect J, all_rxcui_str.curated A
where   J.vsac1='mdpartners_non'
and     J.vsac2='opioid'
and     J.RXCUI = A.RXCUI
order by A.RXCUI, A.STR;

drop    table   if exists   falsepos_medrt_non;
create  table               falsepos_medrt_non
select  distinct A.RXCUI, A.STR
from    opioid.jaccard_intersect J, all_rxcui_str.curated A
where   J.vsac1='medrt_non'
and     J.vsac2='opioid'
and     J.RXCUI = A.RXCUI
order by A.RXCUI, A.STR;

-- ###########################################################################
call log('validate.sql', 'done');