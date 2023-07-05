# Opioid Overdose and Opioid Use Disorder (OUD) 

This study is part of the [Cumulus Library](https://github.com/smart-on-fhir/cumulus-library).

**REFERENCES**
* [Buprenorphine Quick Start Guide](BuprenorphineQuickStartGuideIndicationsMatrixCOWS.pdf)
* [Enhancing Identification of Opioid-involved Health Outcomes Using National Hospital Care Survey Data](CDC_EnhancingIdentificationOpioidOutcomesNationalHospitalCareSurveyData.pdf)
* [Linked Data on Hospitalizations, Mortality, and Drugs: Data from the National Hospital Care Survey 2016, National Death Index 2016-2017, and the Drug-Involved Mortality 2016-2017](CDC_LinkedDataHospitalizationsMortality&DrugsNatHospCareSurvey2016-17.pdf)
* [Spreadsheet: Opioid Overdose Codebook](cumulus_library_opioid/opioid/CodeBookOpioidOverDose.xlsx)

**COUNT TABLES**

-----

_Number encounters in the **study period** with demographic stratification._

<br>

| **opioid__count_study_period_week** | Cohort Summary                                                                                                                   |
|-------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| cnt                                 | count number of encounters                                                                                                       |
| start_week (or start_month)         | Week encounter started                                                                                                           |
| enc_class_code                      | [Encounter class](https://terminology.hl7.org/5.1.0/ValueSet-encounter-class.html) ambulatory, emergency, impatient, observation | 
| gender                              | [female or male sex](http://hl7.org/fhir/ValueSet/administrative-gender)                                                         |
| age_at_visit                        | patient age at time of visit                                                                                                     |
| race_display                        | [CDC R5 race](http://hl7.org/fhir/us/core/StructureDefinition/us-core-race)                                                      |
| ethnicity_display                   | [Hispanic or Latino](http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity)                                          |


<br>

---
_Number of encounters with **Opioid Overdose**_ during study period

<br>


| **Table: opioid__count_dx_week** | See [Spreadsheet: Opioid Involved Overdose Codes](cumulus_library_opioid/opioid/CodeBookOpioidOverDose.xlsx)                     |
|----------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| cnt                              | count number of encounters                                                                                                       |
| cond_week (or cond_month)        | Week of encounter with Opioid Overdose diagnosis                                                                                 |
| category_code                    | [Condition category](http://hl7.org/fhir/ValueSet/condition-category) encounter-diagnosis or problem-list-item                   | 
| cond_display                     | Opioid diagnosis ICD10 display                                                                                                   |
| enc_class_code                   | [Encounter class](https://terminology.hl7.org/5.1.0/ValueSet-encounter-class.html) ambulatory, emergency, impatient, observation | 
| gender                           | [female or male sex](http://hl7.org/fhir/ValueSet/administrative-gender)                                                         |
| age_at_visit                     | patient age at time of visit                                                                                                     |
| race_display                     | [CDC R5 race](http://hl7.org/fhir/us/core/StructureDefinition/us-core-race)                                                      |
| ethnicity_display                | [Hispanic or Latino](http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity)                                          |

<br>

---
_Number of encounters with **Sepsis**_ during study period

<br>

| **opioid__count_sepsis_week** | [Sepsis ValueSet](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1029.353/expansion/Latest)                             |
|-------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| cnt                           | count number of encounters                                                                                                       |
| cond_week (or cond_month)     | Week of sepsis diagnosis (ICD10CM or SNOMED)                                                                                     |
| category_code                 | [Condition category](http://hl7.org/fhir/ValueSet/condition-category) encounter-diagnosis or problem-list-item                   | 
| cond_display                  | sepsis diagnosis display                                                                                                         |
| cond_system_display           | ICD10CM or SNOMED                                                                                                                |
| enc_class_code                | [Encounter class](https://terminology.hl7.org/5.1.0/ValueSet-encounter-class.html) ambulatory, emergency, impatient, observation | 
| gender                        | [female or male sex](http://hl7.org/fhir/ValueSet/administrative-gender)                                                         |
| age_at_visit                  | patient age at time of visit                                                                                                     |
| race_display                  | [CDC R5 race](http://hl7.org/fhir/us/core/StructureDefinition/us-core-race)                                                      |
| ethnicity_display             | [Hispanic or Latino](http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity)                                          |

<br>

---
_Number of encounters with **Opioid Overdose Lab**_ during study period

<br>

| **opioid__count_lab_week** | See [Spreadsheet: Opioid Involved Lab Codes](cumulus_library_opioid/opioid/CodeBookOpioidOverDose.xlsx)                          |
|----------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| cnt                        | count number of encounters                                                                                                       |
| lab_week (or lab_month)    | Week of LOINC lab test involved with opioid overdose (LOINC)                                                                     |
| loinc_code_display         | LOINC test name                                                                                                                  |
| lab_result_display         | Lab result                                                                                                                       |
| enc_class_code             | [Encounter class](https://terminology.hl7.org/5.1.0/ValueSet-encounter-class.html) ambulatory, emergency, impatient, observation | 
| gender                     | [female or male sex](http://hl7.org/fhir/ValueSet/administrative-gender)                                                         |
| age_at_visit               | patient age at time of visit                                                                                                     |
| race_display               | [CDC R5 race](http://hl7.org/fhir/us/core/StructureDefinition/us-core-race)                                                      |
| ethnicity_display          | [Hispanic or Latino](http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity)                                          |
