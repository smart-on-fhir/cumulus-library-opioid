#!/bin/bash
set -e

echo "########################################################################"
echo "./medrt.sh"
echo "[start]"
echo "########################################################################"

###############################################################################
## MEDRT sources

export CURATED='medrt'
source env_table_schema.sh
./create_database.sh
$mysql_table_schema < medrt/generated/medrt_drop.sql
$mysql_table_schema < medrt/generated/medrt_umls_init.sql
$mysql_table_schema < medrt/generated/medrt_opioid.sql
$mysql_table_schema < medrt/medrt_rxcui.sql
 ./backup_database.sh
 mv mysqldump/medrt.mysqldump mysqldump/medrt.prepared.mysqldump

./export_tsv.sh curated
./export_tsv.sh curated_cui
./export_tsv.sh curated_cui_rxcui
./export_tsv.sh curated_cui_stat
cp $TSV/medrt.curated*.tsv data/.

$mysql_table_schema -e "create table medrt.prepared select * from curated"
./export_tsv.sh prepared
cp $TSV/medrt.prepared.tsv data/medrt.prepared.tsv

$mysql_table_schema -e "call mem"
echo "########################################################################"

export CURATED='medrt_non'
source env_table_schema.sh
./create_database.sh
$mysql_table_schema < medrt/generated/medrt_drop.sql
$mysql_table_schema < medrt/generated/medrt_umls_init.sql
$mysql_table_schema < medrt/generated/medrt_non.sql
$mysql_table_schema < medrt/medrt_rxcui.sql
 ./backup_database.sh
 mv mysqldump/medrt_non.mysqldump mysqldump/medrt_non.prepared.mysqldump

./export_tsv.sh curated
./export_tsv.sh curated_cui
./export_tsv.sh curated_cui_rxcui
./export_tsv.sh curated_cui_stat
cp $TSV/medrt_non.curated*.tsv data/.

$mysql_table_schema -e "create table medrt_non.prepared select * from curated"
./export_tsv.sh prepared
cp $TSV/medrt_non.prepared.tsv data/medrt_non.prepared.tsv

$mysql_table_schema -e "call mem"
echo "########################################################################"
echo "./medrt.sh"
echo "[done]"
echo "########################################################################"
