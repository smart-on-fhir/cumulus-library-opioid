create table opioid__lab as
SELECT DISTINCT
    loinc.code as loinc_code,
    loinc.display as loinc_code_display,
    lab_result,
    lab_result.code as lab_result_code,
    lab_result.display as lab_result_display,
    lab_result.system as lab_result_system,
    lab.lab_date,
    lab.lab_week,
    lab.lab_month,
    s.enc_class_code,
    s.age_at_visit,
    s.gender,
    s.race_display,
    s.ethnicity_display,
    lab.subject_ref,
    lab.encounter_ref,
    lab.observation_ref
FROM
    core__observation_lab as lab,
    opioid__define_lab as loinc,
    opioid__study_period AS s
WHERE
    lab.lab_code.code = loinc.code and
    lab.lab_code.system = loinc.system and
    lab.encounter_ref = s.encounter_ref;