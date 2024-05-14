insert into jaccard_score (vsac1, vsac2, size1, size2)
select distinct A.vsac, B.vsac, A.size, B.size
from jaccard_valueset A, jaccard_valueset B
order by A.vsac, B.vsac;

update jaccard_score S, jaccard_difference_size D
set S.diff  = D.size
where S.vsac1 = D.vsac1 and S.vsac2 = D.vsac2;

update jaccard_score S, jaccard_intersect_size I
set S.inter = I.size
where S.vsac1 = I.vsac1 and S.vsac2 = I.vsac2;

update jaccard_score set score = round(inter / (size1 + size2 - inter), 3);

insert into jaccard_superset_opioid
select distinct vsac, RXCUI from jaccard_superset
where vsac not like '%_non'
and   vsac not like '%keyword%';

insert into jaccard_superset_non
select distinct vsac, RXCUI from jaccard_superset
where vsac      like '%_non'
and   vsac  not like '%keyword%';

insert into jaccard_superset_opioid_size (RXCUI, size)
select RXCUI, count(distinct vsac) as size from jaccard_superset_opioid group by RXCUI order by RXCUI;

insert into jaccard_superset_non_size (RXCUI, size)
select RXCUI, count(distinct vsac) as size from jaccard_superset_non group by RXCUI order by RXCUI;

drop    table if exists jaccard_superset_opioid_size_dist;
create  table           jaccard_superset_opioid_size_dist
select count(distinct RXCUI) cnt_rxcui, size
from jaccard_superset_opioid_size
group by size order by size desc;

drop    table if exists jaccard_superset_opioid_avg_score;
create  table           jaccard_superset_opioid_avg_score
select vsac1, round(avg(score),3) as avg_score
from jaccard_score
where vsac2 not like ('%keywords%')
and   vsac2 not like ('%_non%')
group by vsac1 order by avg_score desc;

drop    table if exists jaccard_recall;
create  table           jaccard_recall
select S.*, round((inter/size2),3) as recall
from jaccard_score S
where vsac2 not like ('%keywords%')
and   vsac2 not like ('%_non%')
order by vsac1, recall desc;
