from typing import List
from cumulus_library.schema import counts

STUDY_PREFIX = 'opioid'

def table(tablename: str, duration=None) -> str:
    if duration:
        return f'{STUDY_PREFIX}__{tablename}_{duration}'
    else: 
        return f'{STUDY_PREFIX}__{tablename}'

def count_dx(duration=None):
    view_name = table('count_dx', duration)
    from_table = table('dx')
    cols = ['category_code', 'cond_display', 'age_dx_recorded',
            'gender', 'race_display', 'ethnicity_display']

    if duration:
        cols.append(f'cond_{duration}')

    return counts.count_patient(view_name, from_table, cols)

def count_dx_sud(duration=None):
    view_name = table('count_dx_sud', duration)
    from_table = table('dx_sud')
    cols = ['category_code', 'cond_display', 'age_dx_recorded',
            'gender', 'race_display', 'ethnicity_display']

    if duration:
        cols.append(f'cond_{duration}')

    return counts.count_patient(view_name, from_table, cols)

def count_dx_sepsis(duration=None):
    view_name = table('count_dx_sepsis', duration)
    from_table = table('dx_sepsis')
    cols = ['category_code', 'cond_display', 'age_dx_recorded',
            'gender', 'race_display', 'ethnicity_display']

    if duration:
        cols.append(f'cond_{duration}')

    return counts.count_patient(view_name, from_table, cols)

def count_study_period(duration='month'):
    view_name = table('count_study_period', duration)
    from_table = table('study_period')
    cols = ['enc_class_code', 'age_at_visit',
            'gender', 'race_display', 'ethnicity_display']

    if duration:
        cols.append(f'start_{duration}')

    return counts.count_encounter(view_name, from_table, cols)

def count_lab(duration=None):
    view_name = table('count_lab', duration)
    from_table = table('lab')
    cols = ['loinc_code_display', 'lab_result_display',
            'gender', 'race_display', 'ethnicity_display']

    if duration:
        cols.append(f'lab_{duration}')

    return counts.count_encounter(view_name, from_table, cols)

def count_rx_request(duration=None):
    view_name = table('count_rx_request', duration)
    from_table = table('medicationrequest')
    cols = ['status', 'intent',
            'rx_system', 'rx_display', 'rx_category_display',
            'gender', 'race_display', 'ethnicity_display', 'postalcode3']

    if duration:
        cols.append(f'authoredon_{duration}')

    return counts.count_patient(view_name, from_table, cols)

def count_rx(from_table, duration=None):
    count_table = table(f'count_{from_table}', duration)

    cols = ['status', 'intent',
            'rx_system', 'rx_display', 'rx_category_display',
            'gender', 'race_display', 'ethnicity_display', 'postalcode3']

    if duration:
        cols.append(f'authoredon_{duration}')

    return counts.count_patient(count_table, table(from_table), cols)


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
    sql_optimizer = sql_optimizer.replace('WHERE cnt_subject >= 10', 'WHERE cnt_subject >= 1')

    with open(filename, 'w') as fout:
        fout.write(sql_optimizer)


if __name__ == '__main__':

    write_view_sql([
        count_study_period('month'),
        count_study_period('week'),
        count_study_period('date'),

        count_dx(),
        count_dx('month'),
        count_dx('week'),
        count_dx('date'),
        count_dx_sud(),

        count_dx_sepsis(),
        count_dx_sepsis('month'),
        count_dx_sepsis('week'),
        count_dx_sepsis('date'),

        count_lab(),
        count_lab('month'),
        count_lab('week'),
        count_lab('date'),

        count_rx('medicationrequest', 'month'),
        count_rx('rx'),
        count_rx('rx_opioid'),
        count_rx('rx_naloxone'),
        count_rx('rx_buprenorphine'),
    ])
