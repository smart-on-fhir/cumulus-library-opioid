from typing import List
from cumulus_library.schema import counts

STUDY_PREFIX = 'opioid'

def table(tablename: str, duration=None) -> str:
    if duration:
        return f'{STUDY_PREFIX}__{tablename}_{duration}'
    else: 
        return f'{STUDY_PREFIX}__{tablename}'

def count_dx(duration='week'):
    view_name = table('count_dx', duration)
    from_table = table('dx')
    cols = [f'cond_{duration}',
            'category_code', 'cond_display', 'age_dx_recorded',
            'gender', 'race_display', 'ethnicity_display']

    return counts.count_encounter(view_name, from_table, cols)

def count_lab(duration='week'):
    view_name = table('count_lab', duration)
    from_table = table('lab')
    cols = [f'lab_{duration}',
            'loinc_code_display', 'lab_result_display',
            'gender', 'race_display', 'ethnicity_display']

    return counts.count_encounter(view_name, from_table, cols)

def count_dx_sepsis(duration='week'):
    view_name = table('count_dx_sepsis', duration)
    from_table = table('dx_sepsis')
    cols = [f'cond_{duration}',
            'category_code', 'cond_display', 'age_dx_recorded',
            'gender', 'race_display', 'ethnicity_display']

    return counts.count_encounter(view_name, from_table, cols)

def count_study_period(duration='month'):
    view_name = table('count_study_period', duration)
    from_table = table('study_period')
    cols = [f'start_{duration}',
            'enc_class_code', 'age_at_visit',
            'gender', 'race_display', 'ethnicity_display']

    return counts.count_encounter(view_name, from_table, cols)

def concat_view_sql(create_view_list: List[str]) -> str:
    """
    :param create_view_list: SQL prepared statements
    :param filename: path to output file, default 'count.sql' in PWD
    """
    seperator = '-- ###########################################################'
    concat = list()

    for create_view in create_view_list:
        concat.append(seperator + '\n'+create_view + '\n')

    return '\n'.join(concat)

def write_view_sql(view_list_sql: List[str], filename='count.sql') -> None:
    """
    :param view_list_sql: SQL prepared statements
    :param filename: path to output file, default 'count.sql' in PWD
    """
    sql_optimizer = concat_view_sql(view_list_sql)
    sql_optimizer = sql_optimizer.replace("CREATE or replace VIEW", 'CREATE TABLE')
    sql_optimizer = sql_optimizer.replace("ORDER BY cnt desc", "")
    sql_optimizer = sql_optimizer.replace('WHERE cnt_subject >= 10', '')

    with open(filename, 'w') as fout:
        fout.write(sql_optimizer)


if __name__ == '__main__':

    write_view_sql([
        count_study_period('month'),
        count_study_period('week'),
        count_study_period('date'),

        count_dx('month'),
        count_dx('week'),
        count_dx('date'),

        count_dx_sepsis('month'),
        count_dx_sepsis('week'),
        count_dx_sepsis('date'),

        count_lab('week'),
        count_lab('month'),
    ])
