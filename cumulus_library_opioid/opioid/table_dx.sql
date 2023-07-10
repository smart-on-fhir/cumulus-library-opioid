    create table opioid__dx as
    SELECT DISTINCT
        c.category.code as category_code,
        dx.code AS cond_code,
        dx.display as cond_display,
        c.recorded_month AS cond_month,
        c.recorded_week AS cond_week,
        c.recordeddate as cond_date,
        date_diff('year', date(p.birthdate), c.recordeddate) AS age_dx_recorded,
        p.gender,
        p.race_display,
        p.ethnicity_display,
        c.subject_ref,
        c.encounter_ref
    FROM
        opioid__define_dx AS dx,
        core__condition AS c,
        core__condition_codable_concepts cc,
        core__patient AS p
    WHERE
        dx.system = cc.code_system  and
        dx.code   = cc.code    and
        cc.id = c.condition_id and
        c.subject_ref = p.subject_ref
;