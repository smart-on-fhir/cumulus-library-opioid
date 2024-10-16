drop    table if exists matt_umls_mrconso_sab_tty;
create  table           matt_umls_mrconso_sab_tty
select sab, tty, count(*) as total from umls.mrconso
group by sab,tty order by total desc;

drop    table if exists matt_umls_mrconso_drug_sab_tty;
create  table           matt_umls_mrconso_drug_sab_tty
select sab, tty, count(*) as total from all_rxcui_str.mrconso_drug
group by sab,tty order by total desc;

drop    table if exists matt_umls_mrrel_sab;
create  table           matt_umls_mrrel_sab
select sab, count(*) as total from umls.mrrel
group by sab order by total desc;

    drop    table if exists matt_umls_mrrel_is_a_sab;
    create  table           matt_umls_mrrel_is_a_sab
    select sab, count(*) as total from meddrt_hier.MRREL_medrt
    group by sab order by total desc;

