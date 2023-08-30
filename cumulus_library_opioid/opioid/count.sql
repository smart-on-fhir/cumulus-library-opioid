-- noqa: disable=all

CREATE TABLE opioid__count_study_period_month AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            count(DISTINCT encounter_ref) AS cnt_encounter,
            "enc_class_code",
            "age_at_visit",
            "gender",
            "race_display",
            "ethnicity_display",
            "start_month"
        FROM opioid__study_period
        GROUP BY
            cube(
                "enc_class_code",
                "age_at_visit",
                "gender",
                "race_display",
                "ethnicity_display",
                "start_month"
            )
    )

    SELECT
        cnt_encounter AS cnt,
        "enc_class_code",
        "age_at_visit",
        "gender",
        "race_display",
        "ethnicity_display",
        "start_month"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_study_period_week AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            count(DISTINCT encounter_ref) AS cnt_encounter,
            "enc_class_code",
            "age_at_visit",
            "gender",
            "race_display",
            "ethnicity_display",
            "start_week"
        FROM opioid__study_period
        GROUP BY
            cube(
                "enc_class_code",
                "age_at_visit",
                "gender",
                "race_display",
                "ethnicity_display",
                "start_week"
            )
    )

    SELECT
        cnt_encounter AS cnt,
        "enc_class_code",
        "age_at_visit",
        "gender",
        "race_display",
        "ethnicity_display",
        "start_week"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_study_period_date AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            count(DISTINCT encounter_ref) AS cnt_encounter,
            "enc_class_code",
            "age_at_visit",
            "gender",
            "race_display",
            "ethnicity_display",
            "start_date"
        FROM opioid__study_period
        GROUP BY
            cube(
                "enc_class_code",
                "age_at_visit",
                "gender",
                "race_display",
                "ethnicity_display",
                "start_date"
            )
    )

    SELECT
        cnt_encounter AS cnt,
        "enc_class_code",
        "age_at_visit",
        "gender",
        "race_display",
        "ethnicity_display",
        "start_date"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_dx AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            "category_code",
            "cond_display",
            "age_dx_recorded",
            "gender",
            "race_display",
            "ethnicity_display"
        FROM opioid__dx
        GROUP BY
            cube(
                "category_code",
                "cond_display",
                "age_dx_recorded",
                "gender",
                "race_display",
                "ethnicity_display"
            )
    )

    SELECT
        cnt_subject AS cnt,
        "category_code",
        "cond_display",
        "age_dx_recorded",
        "gender",
        "race_display",
        "ethnicity_display"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_dx_month AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            "category_code",
            "cond_display",
            "age_dx_recorded",
            "gender",
            "race_display",
            "ethnicity_display",
            "cond_month"
        FROM opioid__dx
        GROUP BY
            cube(
                "category_code",
                "cond_display",
                "age_dx_recorded",
                "gender",
                "race_display",
                "ethnicity_display",
                "cond_month"
            )
    )

    SELECT
        cnt_subject AS cnt,
        "category_code",
        "cond_display",
        "age_dx_recorded",
        "gender",
        "race_display",
        "ethnicity_display",
        "cond_month"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_dx_week AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            "category_code",
            "cond_display",
            "age_dx_recorded",
            "gender",
            "race_display",
            "ethnicity_display",
            "cond_week"
        FROM opioid__dx
        GROUP BY
            cube(
                "category_code",
                "cond_display",
                "age_dx_recorded",
                "gender",
                "race_display",
                "ethnicity_display",
                "cond_week"
            )
    )

    SELECT
        cnt_subject AS cnt,
        "category_code",
        "cond_display",
        "age_dx_recorded",
        "gender",
        "race_display",
        "ethnicity_display",
        "cond_week"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_dx_date AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            "category_code",
            "cond_display",
            "age_dx_recorded",
            "gender",
            "race_display",
            "ethnicity_display",
            "cond_date"
        FROM opioid__dx
        GROUP BY
            cube(
                "category_code",
                "cond_display",
                "age_dx_recorded",
                "gender",
                "race_display",
                "ethnicity_display",
                "cond_date"
            )
    )

    SELECT
        cnt_subject AS cnt,
        "category_code",
        "cond_display",
        "age_dx_recorded",
        "gender",
        "race_display",
        "ethnicity_display",
        "cond_date"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_dx_sepsis AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            "category_code",
            "cond_display",
            "age_dx_recorded",
            "gender",
            "race_display",
            "ethnicity_display"
        FROM opioid__dx_sepsis
        GROUP BY
            cube(
                "category_code",
                "cond_display",
                "age_dx_recorded",
                "gender",
                "race_display",
                "ethnicity_display"
            )
    )

    SELECT
        cnt_subject AS cnt,
        "category_code",
        "cond_display",
        "age_dx_recorded",
        "gender",
        "race_display",
        "ethnicity_display"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_dx_sepsis_month AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            "category_code",
            "cond_display",
            "age_dx_recorded",
            "gender",
            "race_display",
            "ethnicity_display",
            "cond_month"
        FROM opioid__dx_sepsis
        GROUP BY
            cube(
                "category_code",
                "cond_display",
                "age_dx_recorded",
                "gender",
                "race_display",
                "ethnicity_display",
                "cond_month"
            )
    )

    SELECT
        cnt_subject AS cnt,
        "category_code",
        "cond_display",
        "age_dx_recorded",
        "gender",
        "race_display",
        "ethnicity_display",
        "cond_month"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_dx_sepsis_week AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            "category_code",
            "cond_display",
            "age_dx_recorded",
            "gender",
            "race_display",
            "ethnicity_display",
            "cond_week"
        FROM opioid__dx_sepsis
        GROUP BY
            cube(
                "category_code",
                "cond_display",
                "age_dx_recorded",
                "gender",
                "race_display",
                "ethnicity_display",
                "cond_week"
            )
    )

    SELECT
        cnt_subject AS cnt,
        "category_code",
        "cond_display",
        "age_dx_recorded",
        "gender",
        "race_display",
        "ethnicity_display",
        "cond_week"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_dx_sepsis_date AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            "category_code",
            "cond_display",
            "age_dx_recorded",
            "gender",
            "race_display",
            "ethnicity_display",
            "cond_date"
        FROM opioid__dx_sepsis
        GROUP BY
            cube(
                "category_code",
                "cond_display",
                "age_dx_recorded",
                "gender",
                "race_display",
                "ethnicity_display",
                "cond_date"
            )
    )

    SELECT
        cnt_subject AS cnt,
        "category_code",
        "cond_display",
        "age_dx_recorded",
        "gender",
        "race_display",
        "ethnicity_display",
        "cond_date"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_lab AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            count(DISTINCT encounter_ref) AS cnt_encounter,
            "loinc_code_display",
            "lab_result_display",
            "gender",
            "race_display",
            "ethnicity_display"
        FROM opioid__lab
        GROUP BY
            cube(
                "loinc_code_display",
                "lab_result_display",
                "gender",
                "race_display",
                "ethnicity_display"
            )
    )

    SELECT
        cnt_encounter AS cnt,
        "loinc_code_display",
        "lab_result_display",
        "gender",
        "race_display",
        "ethnicity_display"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_lab_month AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            count(DISTINCT encounter_ref) AS cnt_encounter,
            "loinc_code_display",
            "lab_result_display",
            "gender",
            "race_display",
            "ethnicity_display",
            "lab_month"
        FROM opioid__lab
        GROUP BY
            cube(
                "loinc_code_display",
                "lab_result_display",
                "gender",
                "race_display",
                "ethnicity_display",
                "lab_month"
            )
    )

    SELECT
        cnt_encounter AS cnt,
        "loinc_code_display",
        "lab_result_display",
        "gender",
        "race_display",
        "ethnicity_display",
        "lab_month"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_lab_week AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            count(DISTINCT encounter_ref) AS cnt_encounter,
            "loinc_code_display",
            "lab_result_display",
            "gender",
            "race_display",
            "ethnicity_display",
            "lab_week"
        FROM opioid__lab
        GROUP BY
            cube(
                "loinc_code_display",
                "lab_result_display",
                "gender",
                "race_display",
                "ethnicity_display",
                "lab_week"
            )
    )

    SELECT
        cnt_encounter AS cnt,
        "loinc_code_display",
        "lab_result_display",
        "gender",
        "race_display",
        "ethnicity_display",
        "lab_week"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_lab_date AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            count(DISTINCT encounter_ref) AS cnt_encounter,
            "loinc_code_display",
            "lab_result_display",
            "gender",
            "race_display",
            "ethnicity_display",
            "lab_date"
        FROM opioid__lab
        GROUP BY
            cube(
                "loinc_code_display",
                "lab_result_display",
                "gender",
                "race_display",
                "ethnicity_display",
                "lab_date"
            )
    )

    SELECT
        cnt_encounter AS cnt,
        "loinc_code_display",
        "lab_result_display",
        "gender",
        "race_display",
        "ethnicity_display",
        "lab_date"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_medicationrequest AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            "status",
            "intent",
            "rx_display",
            "rx_category_display",
            "gender",
            "race_display",
            "postalcode3"
        FROM opioid__medicationrequest
        GROUP BY
            cube(
                "status",
                "intent",
                "rx_display",
                "rx_category_display",
                "gender",
                "race_display",
                "postalcode3"
            )
    )

    SELECT
        cnt_subject AS cnt,
        "status",
        "intent",
        "rx_display",
        "rx_category_display",
        "gender",
        "race_display",
        "postalcode3"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_rx AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            "status",
            "intent",
            "rx_display",
            "rx_category_display",
            "gender",
            "race_display",
            "postalcode3"
        FROM opioid__rx
        GROUP BY
            cube(
                "status",
                "intent",
                "rx_display",
                "rx_category_display",
                "gender",
                "race_display",
                "postalcode3"
            )
    )

    SELECT
        cnt_subject AS cnt,
        "status",
        "intent",
        "rx_display",
        "rx_category_display",
        "gender",
        "race_display",
        "postalcode3"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_rx_opioid AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            "status",
            "intent",
            "rx_display",
            "rx_category_display",
            "gender",
            "race_display",
            "postalcode3"
        FROM opioid__rx_opioid
        GROUP BY
            cube(
                "status",
                "intent",
                "rx_display",
                "rx_category_display",
                "gender",
                "race_display",
                "postalcode3"
            )
    )

    SELECT
        cnt_subject AS cnt,
        "status",
        "intent",
        "rx_display",
        "rx_category_display",
        "gender",
        "race_display",
        "postalcode3"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_rx_naloxone AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            "status",
            "intent",
            "rx_display",
            "rx_category_display",
            "gender",
            "race_display",
            "postalcode3"
        FROM opioid__rx_naloxone
        GROUP BY
            cube(
                "status",
                "intent",
                "rx_display",
                "rx_category_display",
                "gender",
                "race_display",
                "postalcode3"
            )
    )

    SELECT
        cnt_subject AS cnt,
        "status",
        "intent",
        "rx_display",
        "rx_category_display",
        "gender",
        "race_display",
        "postalcode3"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);

-- ###########################################################

CREATE TABLE opioid__count_rx_buprenorphine AS (
    WITH powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject,
            "status",
            "intent",
            "rx_display",
            "rx_category_display",
            "gender",
            "race_display",
            "postalcode3"
        FROM opioid__rx_buprenorphine
        GROUP BY
            cube(
                "status",
                "intent",
                "rx_display",
                "rx_category_display",
                "gender",
                "race_display",
                "postalcode3"
            )
    )

    SELECT
        cnt_subject AS cnt,
        "status",
        "intent",
        "rx_display",
        "rx_category_display",
        "gender",
        "race_display",
        "postalcode3"
    FROM powerset
    WHERE 
        cnt_subject >= 10
);
