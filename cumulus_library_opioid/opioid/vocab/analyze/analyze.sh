#!/bin/bash
set -e
source db.config
source env_table_schema.sh

$mysql_table_schema -e "call log('results.sh', 'begin')"

if [ -z "$CURATED" ]; then
  echo "CURATED is not set. Exiting..."
  exit 1
fi

echo "Using $CURATED.tsv"
$mysql_table_schema -e "call version('${CURATED}', 'results.sh:begin')"

# TODO: links with (ln -s) should be replaced with Matt's true VSAC downloader.
# Each "curated" source is a TSV file with two cols, RXCUI and STR
rm -f curated.tsv
ln -s infile/$CURATED.tsv curated.tsv

$mysql_table_schema < curate.sql
$mysql_table_schema < expand.sql
$mysql_table_schema < filter.sql
$mysql_table_schema < stats.sql

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
