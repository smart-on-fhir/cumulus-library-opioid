drop    table if exists jaccard_valueset;
create  table           jaccard_valueset
(
    vsac        varchar(30)     not null,
    size        int             not null
);

call create_index('jaccard_valueset', 'vsac');

drop    table if exists jaccard_superset;
create  table           jaccard_superset
(
    vsac        varchar(30)     not null,
    rxcui       varchar(8)      not null
);

call create_index('jaccard_superset', 'vsac');
call create_index('jaccard_superset', 'rxcui');

drop    table if exists jaccard_superset_non;
create  table           jaccard_superset_non    like jaccard_superset;

drop    table if exists jaccard_superset_opioid;
create  table           jaccard_superset_opioid like jaccard_superset;

drop    table if exists jaccard_superset_rwd;
create  table           jaccard_superset_rwd    like jaccard_superset;

drop    table if exists jaccard_superset_opioid_size;
create  table           jaccard_superset_opioid_size
(
    rxcui       varchar(8)      not null,
    size        int             not null
);

drop    table if exists jaccard_superset_non_size;
create  table           jaccard_superset_non_size   like jaccard_superset_opioid_size;

drop    table if exists jaccard_superset_rwd_size;
create  table           jaccard_superset_rwd_size   like jaccard_superset_opioid_size;

drop   table if exists jaccard_intersect;
create  table          jaccard_intersect
(
    vsac1       varchar(30)     not null,
    vsac2       varchar(30)     not null,
    rxcui       varchar(8)      not null
);

call create_index('jaccard_intersect', 'vsac1');
call create_index('jaccard_intersect', 'vsac2');
call create_index('jaccard_intersect', 'rxcui');


drop   table if exists jaccard_intersect_size;
create  table          jaccard_intersect_size
(
    vsac1       varchar(30)     not null,
    vsac2       varchar(30)     not null,
    size        int             not null
);

drop   table if exists jaccard_difference;
create table           jaccard_difference
(
    vsac1       varchar(30)     not null,
    vsac2       varchar(30)     not null,
    rxcui       varchar(8)      not null
);

call create_index('jaccard_difference', 'vsac1');
call create_index('jaccard_difference', 'vsac2');
call create_index('jaccard_difference', 'rxcui');

drop   table if exists jaccard_difference_size;
create table           jaccard_difference_size
(
    vsac1       varchar(30)     not null,
    vsac2       varchar(30)     not null,
    size        int             not null
);

drop   table if exists jaccard_score;
create table           jaccard_score
(
    vsac1       varchar(30)     not null,
    vsac2       varchar(30)     not null,
    size1       int             not null,
    size2       int             not null,
    inter       int             default 0,
    diff        int             default 0,
    score       float           NULL
);

call create_index('jaccard_score', 'vsac1');
call create_index('jaccard_score', 'vsac2');
