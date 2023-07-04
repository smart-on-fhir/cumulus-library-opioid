drop table if exists opioid__dx;

create table opioid__dx as
SELECT DISTINCT
    c.subject_ref,
    c.encounter_ref,
    dx.code AS cond_code,
    dx.display as cond_display,
    c.recorded_month AS cond_month,
    c.recorded_week AS cond_week,
    s.enc_class_code,
    s.age_at_visit,
    s.gender,
    s.race_display,
    s.ethnicity_display
FROM
    opioid__define_dx_icd10 AS dx,
    opioid__study_period AS s,
    core__condition AS c,
    core__condition_codable_concepts cc
WHERE
    dx.code = cc.code           and
    cc.id = c.condition_id      and
    c.encounter_ref = s.encounter_ref;