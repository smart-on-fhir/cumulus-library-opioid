-- ###########################################################
CREATE or replace VIEW opioid__count_study_period_week AS 
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
    WHERE cnt_subject >= 10 
    ;

-- ###########################################################
CREATE or replace VIEW opioid__count_study_period_month AS 
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
    WHERE cnt_subject >= 10 
    ;

-- ###########################################################
CREATE or replace VIEW opioid__count_dx_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , cond_week, category_code, cond_display, enc_class_code, age_at_visit, gender, race_display, ethnicity_display        
        FROM opioid__dx
        group by CUBE
        ( cond_week, category_code, cond_display, enc_class_code, age_at_visit, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , cond_week, category_code, cond_display, enc_class_code, age_at_visit, gender, race_display, ethnicity_display
    from powerset 
    WHERE cnt_subject >= 10 
    ;

-- ###########################################################
CREATE or replace VIEW opioid__count_dx_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , cond_month, category_code, cond_display, enc_class_code, age_at_visit, gender, race_display, ethnicity_display        
        FROM opioid__dx
        group by CUBE
        ( cond_month, category_code, cond_display, enc_class_code, age_at_visit, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , cond_month, category_code, cond_display, enc_class_code, age_at_visit, gender, race_display, ethnicity_display
    from powerset 
    WHERE cnt_subject >= 10 
    ;

-- ###########################################################
CREATE or replace VIEW opioid__count_sepsis_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , cond_week, category_code, cond_display, cond_system_display, enc_class_code, age_at_visit, gender, race_display, ethnicity_display        
        FROM opioid__sepsis
        group by CUBE
        ( cond_week, category_code, cond_display, cond_system_display, enc_class_code, age_at_visit, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , cond_week, category_code, cond_display, cond_system_display, enc_class_code, age_at_visit, gender, race_display, ethnicity_display
    from powerset 
    WHERE cnt_subject >= 10 
    ;

-- ###########################################################
CREATE or replace VIEW opioid__count_sepsis_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , cond_month, category_code, cond_display, cond_system_display, enc_class_code, age_at_visit, gender, race_display, ethnicity_display        
        FROM opioid__sepsis
        group by CUBE
        ( cond_month, category_code, cond_display, cond_system_display, enc_class_code, age_at_visit, gender, race_display, ethnicity_display )
    )
    select
          cnt_encounter  as cnt 
        , cond_month, category_code, cond_display, cond_system_display, enc_class_code, age_at_visit, gender, race_display, ethnicity_display
    from powerset 
    WHERE cnt_subject >= 10 
    ;
