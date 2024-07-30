drop    table   if exists   opioid.rxcui_missed;
create  table               opioid.rxcui_missed
select  distinct RXCUI
from    opioid.jaccard_difference
where   vsac1='ucdavis'
and     vsac2='opioid'
order by RXCUI;

drop    table   if exists   opioid.rxcui_invalid;
create  table               opioid.rxcui_invalid
select  distinct vsac1, RXCUI
from    opioid.jaccard_difference
where   vsac2='all_rxcui_str' order by vsac1, RXCUI;

--    -- ##################################################################################################
--    call log('rxnorm.RXNCUI', 'https://www.nlm.nih.gov/research/umls/rxnorm/docs/techdoc.html#s12_9');
--
--    drop    table   if exists   opioid.rxcui_replace;
--    create  table               opioid.rxcui_replace
--    (
--        old      varchar(8)   NOT NULL,
--        cite     varchar(50)  NOT NULL,
--        new      varchar(8)   NOT NULL
--    );
--
--    insert into opioid.rxcui_replace (cite, old, new)
--    select distinct 'rxnorm.RXNCUI', R.CUI1 as old, R.CUI2 as new
--    from opioid.rxcui_invalid I, rxnorm.RXNCUI R
--    where I.RXCUI = R.CUI1
--    order by old, new;
--
--    insert into opioid.rxcui_replace (cite, old, new)
--    select distinct 'rxnorm.RXNATOMARCHIVE', R.RXCUI as old, R.MERGED_TO_RXCUI as new
--    from    opioid.rxcui_invalid I, rxnorm.RXNATOMARCHIVE R
--    where   I.RXCUI = R.RXCUI
--    order by old, new;
--
--    insert into opioid.rxcui_replace (cite, old, new)
--    select distinct 'rxnorm.RXNCUICHANGES', R.OLD_RXCUI as old, R.NEW_RXCUI as new
--    from    opioid.rxcui_invalid I, rxnorm.RXNCUICHANGES R
--    where   I.RXCUI = R.OLD_RXCUI
--    order by old, new;
--
--
--    select  distinct R1.*, R2.*
--    from    opioid.rxcui_replace R1, opioid.rxcui_replace R2
--    where   R1.old  =   R2.old
--    and     R1.new  !=  R2.new
--    and     R1.old  !=  R1.new
--    and     R2.old  !=  R2.new
--    and     R1.cite !=  R2.cite
--    order by R1.old, R1.cite, R1.new, R2.new;