#!/bin/bash
set -e
source db.config
source env_table_schema.sh

$mysql_table_schema -e "call log('results.sh', 'begin')"

if [ -z "$CURATED" ]; then
  echo "CURATED is not set. Exiting..."
  exit 1
fi

echo "analyze.sh CURATED = $CURATED"
$mysql_table_schema -e "call version('${CURATED}', 'results.sh:begin')"

#python vsac.py $CURATED
#rm -f curated.tsv
#ln -s ../data/$CURATED.tsv curated.tsv

$mysql_table_schema < analyze/curate.sql
$mysql_table_schema < analyze/expand.sql
$mysql_table_schema < analyze/filter.sql
$mysql_table_schema < analyze/stats.sql

./export_tsv.sh version
./export_tsv.sh curated
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh expand_strict
./export_tsv.sh expand_strict_rxcui_str
./export_tsv.sh expand_keywords
./export_tsv.sh expand_keywords_rxcui_str
./export_tsv.sh filter

$mysql_table_schema -e "call version('${CURATED}', 'results.sh:done')"
$mysql_table_schema -e "call log('results.sh', 'done')"
$mysql_table_schema -e "call mem"
