from typing import List
from cumulus_library.schema import counts

STUDY_PREFIX = 'opioid'

def table(tablename: str, duration=None) -> str:
    if duration:
        return f'{STUDY_PREFIX}__{tablename}_{duration}'
    else: 
        return f'{STUDY_PREFIX}__{tablename}'

def count_sepsis(duration='week'):
    view_name = table('count_sepsis', duration)
    from_table = table('sepsis')
    cols = [f'cond_{duration}',
            'category_code', 'cond_display', 'cond_system_display',
            'enc_class_code', 'age_at_visit',
            'gender', 'race_display', 'ethnicity_display']

    return counts.count_encounter(view_name, from_table, cols)

def count_study_period(duration='month'):
    """
    suicide_icd10__count_study_period_week
    suicide_icd10__count_study_period_month
    suicide_icd10__count_study_period_year
    """
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
    with open(filename, 'w') as fout:
        fout.write(concat_view_sql(view_list_sql))


if __name__ == '__main__':

    write_view_sql([
        count_study_period('week'),
        count_study_period('month'),
        count_sepsis('week'),
        count_sepsis('month'),
    ])
