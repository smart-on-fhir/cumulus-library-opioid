drop table if exists opioid__study_period;

CREATE TABLE opioid__study_period AS
SELECT DISTINCT
    ce.start_date,
    ce.start_week,
    ce.start_month,
    ce.end_date,
    ce.age_at_visit,
    cp.gender,
    cp.race_display,
    cp.ethnicity_display,
    cp.subject_ref,
    ce.encounter_ref,
    coalesce(ce.enc_class.code, '?') AS enc_class_code
FROM
    core__patient AS cp,
    core__encounter AS ce
WHERE
    (cp.subject_ref = ce.subject_ref)
    AND (ce.start_date BETWEEN date('2018-01-01') AND current_date)
    AND (ce.end_date BETWEEN date('2018-01-01') AND current_date)
;