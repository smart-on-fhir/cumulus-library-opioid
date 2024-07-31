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
# ./backup_database.sh
./export_tsv.sh curated
cp $TSV/medrt.curated.tsv data/.

export CURATED='medrt_non'
source env_table_schema.sh
./create_database.sh
$mysql_table_schema < medrt/generated/medrt_drop.sql
$mysql_table_schema < medrt/generated/medrt_umls_init.sql
$mysql_table_schema < medrt/generated/medrt_non.sql
$mysql_table_schema < medrt/medrt_rxcui.sql
# ./backup_database.sh
./export_tsv.sh curated

cp $TSV/medrt_non.curated.tsv data/.

echo "########################################################################"
echo "./medrt.sh"
echo "[done]"
mysql -u root -e "call medrt_non.mem"
echo "########################################################################"
