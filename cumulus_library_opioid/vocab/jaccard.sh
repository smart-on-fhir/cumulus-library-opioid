#!/bin/bash
set -e

export CURATED='opioid'
source env_table_schema.sh

$mysql_table_schema < jaccard/jaccard_drop.sql
$mysql_table_schema < jaccard/jaccard_schema.sql
$mysql_table_schema < jaccard/generated/jaccard_insert.sql
$mysql_table_schema < jaccard/jaccard_score.sql

$mysql_table_schema -e "call mem"

./export_tsv.sh jaccard_valueset
./export_tsv.sh jaccard_recall
./export_tsv.sh jaccard_superset_non_size_dist
./export_tsv.sh jaccard_superset_rwd_size_dist
./export_tsv.sh jaccard_superset_opioid_size_dist
./export_tsv.sh jaccard_superset_opioid_avg_score

cp $TSV/opioid.jaccard*.tsv jaccard/supplement/.
ls -lah jaccard/supplement/.

