drop table if exists opioid__medicationrequest;

create table opioid__medicationrequest as
select
    status,
    intent,
    authoredon,
    date_trunc('week', date(authoredon)) AS authoredon_week,
    authoredon_month,
    rx_system,
    rx_code,
    coalesce(rx_display, 'None') as rx_display,
    category_code_row.system as rx_category_system,
    category_code_row.code as rx_category_code,
    category_code_row.display as rx_category_display,
    p.gender,
    p.race_display,
    p.ethnicity_display,
    p.postalcode3,
    mr.subject_ref,
    mr.med_admin_id
from
    core__patient as p,
    core__medicationrequest as mr,
    unnest (category) as t1(category_row),
    unnest (category_row.coding) as t2(category_code_row)
where
    p.subject_ref = mr.subject_ref;

create table opioid__rx as
select distinct RX.*
from    opioid__medicationrequest as RX, opioid__define_rx as criteria
where   RX.rx_code   = criteria.code
and     RX.rx_system = criteria.system;

create table opioid__rx_buprenorphine as
select distinct RX.*
from    opioid__medicationrequest as RX, opioid__define_rx_buprenorphine as criteria
where   RX.rx_code   = criteria.code
and     RX.rx_system = criteria.system;

create table opioid__rx_naloxone as
select distinct RX.*
from    opioid__medicationrequest as RX, opioid__define_rx_naloxone as criteria
where   RX.rx_code   = criteria.code
and     RX.rx_system = criteria.system;

create table opioid__rx_opioid as
select distinct RX.*
from    opioid__medicationrequest as RX, opioid__define_rx_opioid as criteria
where   RX.rx_code   = criteria.code
and     RX.rx_system = criteria.system;
