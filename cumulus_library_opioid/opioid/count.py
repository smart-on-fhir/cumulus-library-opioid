from pathlib import Path
from cumulus_library.schema.counts import CountsBuilder

class OpioidCountsBuilder(CountsBuilder):
    display_text = "Creating opioid counts..."

    def count_dx(self, duration=None):
        view_name = self.get_table_name('count_dx', duration)
        from_table = self.get_table_name('dx')
        cols = ['category_code', 'cond_display', 'age_dx_recorded',
                'gender', 'race_display', 'ethnicity_display']

        if duration:
            cols.append(f'cond_{duration}')

        return self.count_patient(view_name, from_table, cols)

    def count_dx_sud(self, duration=None):
        view_name = self.get_table_name('count_dx_sud', duration)
        from_table = self.get_table_name('dx_sud')
        cols = ['category_code', 'cond_display', 'age_dx_recorded',
                'gender', 'race_display', 'ethnicity_display']

        if duration:
            cols.append(f'cond_{duration}')

        return self.count_patient(view_name, from_table, cols)

    def count_dx_sepsis(self, duration=None):
        view_name = self.get_table_name('count_dx_sepsis', duration)
        from_table = self.get_table_name('dx_sepsis')
        cols = ['category_code', 'cond_display', 'age_dx_recorded',
                'gender', 'race_display', 'ethnicity_display']

        if duration:
            cols.append(f'cond_{duration}')

        return self.count_patient(view_name, from_table, cols)

    def count_study_period(self, duration='month'):
        view_name = self.get_table_name('count_study_period', duration)
        from_table = self.get_table_name('study_period')
        cols = ['enc_class_code', 'age_at_visit',
                'gender', 'race_display', 'ethnicity_display']

        if duration:
            cols.append(f'start_{duration}')

        return self.count_encounter(view_name, from_table, cols)

    def count_lab(self, duration=None):
        view_name = self.get_table_name('count_lab', duration)
        from_table = self.get_table_name('lab')
        cols = ['loinc_code_display', 'lab_result_display',
                'gender', 'race_display', 'ethnicity_display']

        if duration:
            cols.append(f'lab_{duration}')

        return self.count_encounter(view_name, from_table, cols)

    def count_rx(self, from_table, duration=None):
        count_table = self.get_table_name(f'count_{from_table}', duration)
        from_table = self.get_table_name(from_table)

        cols = ['status', 'intent',
                'rx_display', 'rx_category_display',
                'gender', 'race_display', 'postalcode3']

        if duration:
            cols.append(f'authoredon_{duration}')

        return self.count_patient(count_table, from_table, cols)

    def prepare_queries(self, cursor=None, schema=None):
        self.queries = [
            self.count_study_period('month'),
            self.count_study_period('week'),
            self.count_study_period('date'),

            self.count_dx(),
            self.count_dx('month'),
            self.count_dx('week'),
            self.count_dx('date'),
            #self.count_dx_sud(),

            self.count_dx_sepsis(),
            self.count_dx_sepsis('month'),
            self.count_dx_sepsis('week'),
            self.count_dx_sepsis('date'),

            self.count_lab(),
            self.count_lab('month'),
            self.count_lab('week'),
            self.count_lab('date'),

            self.count_rx('medicationrequest'),
            self.count_rx('rx'),
            self.count_rx('rx_opioid'),
            self.count_rx('rx_naloxone'),
            self.count_rx('rx_buprenorphine'),
        ]

if __name__ == "__main__":
    builder = OpioidCountsBuilder()
    builder.write_counts(f"{Path(__file__).resolve().parent}/count.sql")