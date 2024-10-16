CREATE table asthma__study_period AS
SELECT DISTINCT
    E.period_start_day,
    E.period_start_week,
    E.period_start_month,
    E.period_end_day,
    E.age_at_visit,
    P.gender,
    P.race_display,
    P.ethnicity_display,
    E.class_code,
    E.class_display,
    COALESCE(E.type_system, 'None') as type_system,
    COALESCE(E.type_code, 'None')   as type_code,
    COALESCE(E.type_display, 'None')    as type_display,
    COALESCE(E.servicetype_system, 'None')  as servicetype_system,
    COALESCE(E.servicetype_code, 'None')    as servicetype_code,
    COALESCE(E.servicetype_display, 'None') as servicetype_display,
    COALESCE(E.priority_system, 'None') as priority_system,
    COALESCE(E.priority_code, 'None')   as priority_code,
    COALESCE(E.priority_display, 'None') as priority_display,
    P.subject_ref,
    E.encounter_ref
FROM
    core__patient AS P,
    core__encounter AS E
WHERE
    (P.subject_ref = E.subject_ref)
    AND (E.period_start_day BETWEEN date('2016-01-01') AND current_date)
    AND (E.period_end_day BETWEEN date('2016-01-01') AND current_date)
;