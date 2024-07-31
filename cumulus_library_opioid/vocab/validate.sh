#!/bin/bash
export TSV="/Users/andy/code/medgen-umls/opioid/tsv"

export CURATED='opioid'
source env_table_schema.sh

$mysql_dataset < data/validate/validate_drop.sql
$mysql_dataset < data/validate/validate_create.sql

./export_tsv.sh invalid_RXCUI;
./export_tsv.sh missed_RXCUI;
./export_tsv.sh missed_ucdavis;
./export_tsv.sh missed_acep;
./export_tsv.sh missed_bwh;
./export_tsv.sh missed_CancerLinQ;
./export_tsv.sh missed_ecri;
./export_tsv.sh missed_impaq;
./export_tsv.sh missed_lantana;
./export_tsv.sh missed_mitre;
./export_tsv.sh missed_keywords;
./export_tsv.sh falsepos_atc_non;
./export_tsv.sh falsepos_CancerLinQ_non;
./export_tsv.sh falsepos_mdpartners_non;
./export_tsv.sh falsepos_medrt_non;

cp $TSV/opioid.invalid_*.tsv data/validate/.
cp $TSV/opioid.missed_*.tsv data/validate/.
cp $TSV/opioid.falsepos_*.tsv data/validate/.