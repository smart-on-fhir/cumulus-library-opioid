drop table if exists opioid__dx_sepsis;

create TABLE opioid__dx_sepsis as
    select distinct
          C.subject_ref
        , C.encounter_ref
        , C.category.code as category_code -- https://github.com/smart-on-fhir/cumulus-library/issues/55
        , C.recorded_week
        , C.recorded_month
        , C.recorded_year
        , DX.code    as dx_code
        , DX.display as dx_display
        , S.gender
        , S.race_display
        , S.age_at_visit
        , S.enc_class_code
    from  core__condition C
        , opioid__study_period S
        , opioid__define_dx_sepsis DX
    where C.cond_code.coding[1].code = DX.code -- TODO https://github.com/smart-on-fhir/cumulus-library/issues/52
    and   C.encounter_ref = S.encounter_ref
    and   C.subject_ref = S.subject_ref
;