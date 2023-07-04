# Opioid Overdose and Opioid Use Disorder (OUD) 

This study is part of the [Cumulus Library](https://github.com/smart-on-fhir/cumulus-library).

**REFERENCES**
* [Buprenorphine Quick Start Guide](BuprenorphineQuickStartGuideIndicationsMatrixCOWS.pdf)
* [Enhancing Identification of Opioid-involved Health Outcomes Using National Hospital Care Survey Data](CDC_EnhancingIdentificationOpioidOutcomesNationalHospitalCareSurveyData.pdf)
* [Linked Data on Hospitalizations, Mortality, and Drugs: Data from the National Hospital Care Survey 2016, National Death Index 2016-2017, and the Drug-Involved Mortality 2016-2017](CDC_LinkedDataHospitalizationsMortality&DrugsNatHospCareSurvey2016-17.pdf)

-----
**COUNT TABLES**

| **opioid__count_study_period_month** | Cohort Summary                                                                                                                   |
|--------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| cnt                                  | count number of encounters                                                                                                       |
| enc_class_code                       | [Encounter class](https://terminology.hl7.org/5.1.0/ValueSet-encounter-class.html) ambulatory, emergency, impatient, observation | 
| gender                               | [female or male sex](http://hl7.org/fhir/ValueSet/administrative-gender)                                                         |
| age_at_visit                         | patient age at time of visit                                                                                                     |
| race_display                         | [CDC R5 race](http://hl7.org/fhir/us/core/StructureDefinition/us-core-race)                                                      |
| ethnicity_display                    | [Hispanic or Latino](http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity)                                          |


| **opioid__count_sepsis_month** | [Sepsis ValueSet](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1029.353/expansion/Latest)                             |
|---------------------|----------------------------------------------------------------------------------------------------------------------------------|
| cnt                 | count number of encounters                                                                                                       |
| cond_month          | Month of sepsis diagnosis (ICD10CM or SNOMED)                                                                                    |
| category_code       | [Condition category](http://hl7.org/fhir/ValueSet/condition-category) problem-list or encounter dx                               | 
| cond_display        | sepsis diagnosis display                                                                                                         |
| cond_system_display | ICD10CM or SNOMED                                                                                                                |
| enc_class_code      | [Encounter class](https://terminology.hl7.org/5.1.0/ValueSet-encounter-class.html) ambulatory, emergency, impatient, observation | 
| gender              | [female or male sex](http://hl7.org/fhir/ValueSet/administrative-gender)                                                         |
| age_at_visit        | patient age at time of visit                                                                                                     |
| race_display        | [CDC R5 race](http://hl7.org/fhir/us/core/StructureDefinition/us-core-race)                                                      |
| ethnicity_display   | [Hispanic or Latino](http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity)                                          |
