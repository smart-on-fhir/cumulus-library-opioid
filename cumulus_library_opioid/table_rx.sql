drop table if exists opioid__medicationrequest;

create table opioid__medicationrequest as
select
    mr.status,
    mr.intent,
    mr.authoredon,
    date_trunc('week', date(authoredon)) AS authoredon_week,
    mr.authoredon_month,
    mr.medication_system as rx_system,
    mr.medication_code as rx_code,
    mr.medication_display as rx_display,
    mr.category_system as rx_category_system,
    mr.category_code as rx_category_code,
    mr.category_display as rx_category_display,
    p.gender,
    p.race_display,
    p.ethnicity_display,
    p.postalcode_3,
    mr.subject_ref,
    mr.id as med_admin_id
from
    core__patient as p,
    core__medicationrequest as mr
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