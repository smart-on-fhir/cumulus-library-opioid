-- ###########################################################
CREATE or replace VIEW opioid__count_dx_sepsis_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , recorded_week, category_code, enc_class_code, dx_display, gender, age_at_visit        
        FROM opioid__dx_sepsis
        group by CUBE
        ( recorded_week, category_code, enc_class_code, dx_display, gender, age_at_visit )
    )
    select
          cnt_encounter  as cnt 
        , recorded_week, category_code, enc_class_code, dx_display, gender, age_at_visit
    from powerset 
    WHERE cnt_subject >= 10 
    ORDER BY cnt desc;

-- ###########################################################
CREATE or replace VIEW opioid__count_dx_sepsis_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , recorded_month, category_code, enc_class_code, dx_display, gender, age_at_visit        
        FROM opioid__dx_sepsis
        group by CUBE
        ( recorded_month, category_code, enc_class_code, dx_display, gender, age_at_visit )
    )
    select
          cnt_encounter  as cnt 
        , recorded_month, category_code, enc_class_code, dx_display, gender, age_at_visit
    from powerset 
    WHERE cnt_subject >= 10 
    ORDER BY cnt desc;

-- ###########################################################
CREATE or replace VIEW opioid__count_study_period_week AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , start_week, enc_class_code, gender, age_at_visit        
        FROM opioid__study_period
        group by CUBE
        ( start_week, enc_class_code, gender, age_at_visit )
    )
    select
          cnt_encounter  as cnt 
        , start_week, enc_class_code, gender, age_at_visit
    from powerset 
    WHERE cnt_subject >= 10 
    ORDER BY cnt desc;

-- ###########################################################
CREATE or replace VIEW opioid__count_study_period_month AS 
    with powerset as
    (
        select
        count(distinct subject_ref)   as cnt_subject
        , count(distinct encounter_ref)   as cnt_encounter
        , start_month, enc_class_code, gender, age_at_visit        
        FROM opioid__study_period
        group by CUBE
        ( start_month, enc_class_code, gender, age_at_visit )
    )
    select
          cnt_encounter  as cnt 
        , start_month, enc_class_code, gender, age_at_visit
    from powerset 
    WHERE cnt_subject >= 10 
    ORDER BY cnt desc;
