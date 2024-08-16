create table opioid__lab as
SELECT DISTINCT
    loinc.code as loinc_code,
    loinc.display as loinc_code_display,
    lab.valuecodeableconcept_code as lab_result_code,
    lab.valuecodeableconcept_display as lab_result_display,
    lab.valuecodeableconcept_system as lab_result_system,
    lab.effectivedatetime_day,
    lab.effectivedatetime_week,
    lab.effectivedatetime_month,
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
    lab.observation_code = loinc.code and
    lab.observation_system = loinc.system and
    lab.subject_ref = p.subject_ref and
    lab.encounter_ref = e.encounter_ref;