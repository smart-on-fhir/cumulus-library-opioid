-- ###########################################################
CREATE TABLE opioid__count_study_period_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , start_month, enc_class_code, age_at_visit, gender, race_display, ethnicity_display        
        FROM opioid__study_period
        group by CUBE
        ( start_month, enc_class_code, age_at_visit, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , start_month, enc_class_code, age_at_visit, gender, race_display, ethnicity_display
    from powerset 
     
    ;

-- ###########################################################
CREATE TABLE opioid__count_study_period_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , start_week, enc_class_code, age_at_visit, gender, race_display, ethnicity_display        
        FROM opioid__study_period
        group by CUBE
        ( start_week, enc_class_code, age_at_visit, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , start_week, enc_class_code, age_at_visit, gender, race_display, ethnicity_display
    from powerset 
     
    ;

-- ###########################################################
CREATE TABLE opioid__count_study_period_date AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , start_date, enc_class_code, age_at_visit, gender, race_display, ethnicity_display        
        FROM opioid__study_period
        group by CUBE
        ( start_date, enc_class_code, age_at_visit, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , start_date, enc_class_code, age_at_visit, gender, race_display, ethnicity_display
    from powerset 
     
    ;

-- ###########################################################
CREATE TABLE opioid__count_dx_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , cond_month, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display        
        FROM opioid__dx
        group by CUBE
        ( cond_month, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , cond_month, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display
    from powerset 
     
    ;

-- ###########################################################
CREATE TABLE opioid__count_dx_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , cond_week, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display        
        FROM opioid__dx
        group by CUBE
        ( cond_week, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , cond_week, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display
    from powerset 
     
    ;

-- ###########################################################
CREATE TABLE opioid__count_dx_date AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , cond_date, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display        
        FROM opioid__dx
        group by CUBE
        ( cond_date, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , cond_date, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display
    from powerset 
     
    ;

-- ###########################################################
CREATE TABLE opioid__count_dx_sepsis_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , cond_month, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display        
        FROM opioid__dx_sepsis
        group by CUBE
        ( cond_month, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , cond_month, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display
    from powerset 
     
    ;

-- ###########################################################
CREATE TABLE opioid__count_dx_sepsis_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , cond_week, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display        
        FROM opioid__dx_sepsis
        group by CUBE
        ( cond_week, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , cond_week, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display
    from powerset 
     
    ;

-- ###########################################################
CREATE TABLE opioid__count_dx_sepsis_date AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , cond_date, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display        
        FROM opioid__dx_sepsis
        group by CUBE
        ( cond_date, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , cond_date, category_code, cond_display, age_dx_recorded, gender, race_display, ethnicity_display
    from powerset 
     
    ;

-- ###########################################################
CREATE TABLE opioid__count_lab_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , lab_month, loinc_code_display, lab_result_display, gender, race_display, ethnicity_display        
        FROM opioid__lab
        group by CUBE
        ( lab_month, loinc_code_display, lab_result_display, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , lab_month, loinc_code_display, lab_result_display, gender, race_display, ethnicity_display
    from powerset 
     
    ;

-- ###########################################################
CREATE TABLE opioid__count_lab_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , lab_week, loinc_code_display, lab_result_display, gender, race_display, ethnicity_display        
        FROM opioid__lab
        group by CUBE
        ( lab_week, loinc_code_display, lab_result_display, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , lab_week, loinc_code_display, lab_result_display, gender, race_display, ethnicity_display
    from powerset 
     
    ;

-- ###########################################################
CREATE TABLE opioid__count_lab_date AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , lab_date, loinc_code_display, lab_result_display, gender, race_display, ethnicity_display        
        FROM opioid__lab
        group by CUBE
        ( lab_date, loinc_code_display, lab_result_display, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , lab_date, loinc_code_display, lab_result_display, gender, race_display, ethnicity_display
    from powerset 
     
    ;
