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
    p.gender,
    p.race_display,
    p.ethnicity_display,
    lab.subject_ref,
    lab.encounter_ref,
    lab.observation_ref,
    e.status
FROM
    core__observation_lab as lab,
    core__encounter as e,
    opioid__define_lab as loinc,
    core__patient AS p
WHERE
    lab.lab_code.code = loinc.code and
    lab.lab_code.system = loinc.system and
    lab.subject_ref = p.subject_ref and
    lab.encounter_ref = e.encounter_ref;