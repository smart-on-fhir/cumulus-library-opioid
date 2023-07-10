-- ###########################################################
CREATE TABLE opioid__count_study_period_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , enc_class_code, age_at_visit, gender, race_display, ethnicity_display, start_month        
        FROM opioid__study_period
        group by CUBE
        ( enc_class_code, age_at_visit, gender, race_display, ethnicity_display, start_month )
    )
    select
          cnt_encounter  as cnt 
        , enc_class_code, age_at_visit, gender, race_display, ethnicity_display, start_month
    from powerset 
    WHERE cnt_subject >= 1 
    ;

-- ###########################################################
CREATE TABLE opioid__count_study_period_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , enc_class_code, age_at_visit, gender, race_display, ethnicity_display, start_week        
        FROM opioid__study_period
        group by CUBE
        ( enc_class_code, age_at_visit, gender, race_display, ethnicity_display, start_week )
    )
    select
          cnt_encounter  as cnt 
        , enc_class_code, age_at_visit, gender, race_display, ethnicity_display, start_week
    from powerset 
    WHERE cnt_subject >= 1 
    ;

-- ###########################################################
CREATE TABLE opioid__count_study_period_date AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , enc_class_code, age_at_visit, gender, race_display, ethnicity_display, start_date        
        FROM opioid__study_period
        group by CUBE
        ( enc_class_code, age_at_visit, gender, race_display, ethnicity_display, start_date )
    )
    select
          cnt_encounter  as cnt 
        , enc_class_code, age_at_visit, gender, race_display, ethnicity_display, start_date
    from powerset 
    WHERE cnt_subject >= 1 
    ;

-- ###########################################################
CREATE TABLE opioid__count_dx AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display        
        FROM opioid__dx
        group by CUBE
        ( category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display )
    )
    select
          cnt_subject as cnt 
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display
    from powerset 
    WHERE cnt_subject >= 1 
    ;

-- ###########################################################
CREATE TABLE opioid__count_dx_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, cond_month        
        FROM opioid__dx
        group by CUBE
        ( category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, cond_month )
    )
    select
          cnt_subject as cnt 
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, cond_month
    from powerset 
    WHERE cnt_subject >= 1 
    ;

-- ###########################################################
CREATE TABLE opioid__count_dx_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, cond_week        
        FROM opioid__dx
        group by CUBE
        ( category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, cond_week )
    )
    select
          cnt_subject as cnt 
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, cond_week
    from powerset 
    WHERE cnt_subject >= 1 
    ;

-- ###########################################################
CREATE TABLE opioid__count_dx_date AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, cond_date        
        FROM opioid__dx
        group by CUBE
        ( category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, cond_date )
    )
    select
          cnt_subject as cnt 
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, cond_date
    from powerset 
    WHERE cnt_subject >= 1 
    ;

-- ###########################################################
CREATE TABLE opioid__count_dx_sepsis AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display        
        FROM opioid__dx_sepsis
        group by CUBE
        ( category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display )
    )
    select
          cnt_subject as cnt 
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display
    from powerset 
    WHERE cnt_subject >= 1 
    ;

-- ###########################################################
CREATE TABLE opioid__count_dx_sepsis_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, lab_month        
        FROM opioid__dx_sepsis
        group by CUBE
        ( category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, lab_month )
    )
    select
          cnt_subject as cnt 
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, lab_month
    from powerset 
    WHERE cnt_subject >= 1 
    ;

-- ###########################################################
CREATE TABLE opioid__count_dx_sepsis_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, lab_week        
        FROM opioid__dx_sepsis
        group by CUBE
        ( category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, lab_week )
    )
    select
          cnt_subject as cnt 
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, lab_week
    from powerset 
    WHERE cnt_subject >= 1 
    ;

-- ###########################################################
CREATE TABLE opioid__count_dx_sepsis_date AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, lab_date        
        FROM opioid__dx_sepsis
        group by CUBE
        ( category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, lab_date )
    )
    select
          cnt_subject as cnt 
        , category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display, lab_date
    from powerset 
    WHERE cnt_subject >= 1 
    ;

-- ###########################################################
CREATE TABLE opioid__count_lab AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , loinc_code_display, lab_result_display, gender, race_display, ethnicity_display        
        FROM opioid__lab
        group by CUBE
        ( loinc_code_display, lab_result_display, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , loinc_code_display, lab_result_display, gender, race_display, ethnicity_display
    from powerset 
    WHERE cnt_subject >= 1 
    ;

-- ###########################################################
CREATE TABLE opioid__count_lab_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , loinc_code_display, lab_result_display, gender, race_display, ethnicity_display, lab_month        
        FROM opioid__lab
        group by CUBE
        ( loinc_code_display, lab_result_display, gender, race_display, ethnicity_display, lab_month )
    )
    select
          cnt_encounter  as cnt 
        , loinc_code_display, lab_result_display, gender, race_display, ethnicity_display, lab_month
    from powerset 
    WHERE cnt_subject >= 1 
    ;

-- ###########################################################
CREATE TABLE opioid__count_lab_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , loinc_code_display, lab_result_display, gender, race_display, ethnicity_display, lab_week        
        FROM opioid__lab
        group by CUBE
        ( loinc_code_display, lab_result_display, gender, race_display, ethnicity_display, lab_week )
    )
    select
          cnt_encounter  as cnt 
        , loinc_code_display, lab_result_display, gender, race_display, ethnicity_display, lab_week
    from powerset 
    WHERE cnt_subject >= 1 
    ;

-- ###########################################################
CREATE TABLE opioid__count_lab_date AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , loinc_code_display, lab_result_display, gender, race_display, ethnicity_display, lab_date        
        FROM opioid__lab
        group by CUBE
        ( loinc_code_display, lab_result_display, gender, race_display, ethnicity_display, lab_date )
    )
    select
          cnt_encounter  as cnt 
        , loinc_code_display, lab_result_display, gender, race_display, ethnicity_display, lab_date
    from powerset 
    WHERE cnt_subject >= 1 
    ;
