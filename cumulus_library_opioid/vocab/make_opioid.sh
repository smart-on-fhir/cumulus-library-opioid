#!/bin/bash
export TSV="/Users/andy/code/medgen-umls/opioid/tsv"

set -e
export CURATED='opioid'
source env_table_schema.sh

./create_database.sh
$mysql_dataset < data/opioid.curated.sql
./export_tsv.sh curated
./export_tsv.sh curated_steward

cp $TSV/opioid.curated.tsv data/.
cp $TSV/opioid.curated_steward.tsv data/.

cd data; rm -f curated.tsv; ln -s opioid.curated.tsv curated.tsv; cd ..

export CURATED='opioid2'
source env_table_schema.sh
./make.sh
./export_tsv.sh curated
./export_tsv.sh expand_rxcui_str
cat $TSV/$CURATED.curated.tsv $TSV/$CURATED.expand_rxcui_str.tsv > data/$CURATED.tsv
cd data; rm -f curated.tsv; ln -s $CURATED.tsv curated.tsv; cd ..

export CURATED='opioid3'
source env_table_schema.sh
./make.sh
./export_tsv.sh curated
./export_tsv.sh expand_rxcui_str
cat $TSV/$CURATED.curated.tsv $TSV/$CURATED.expand_rxcui_str.tsv > data/$CURATED.tsv
cd data; rm -f curated.tsv; ln -s $CURATED.tsv curated.tsv; cd ..

export CURATED='opioid4'
source env_table_schema.sh
./make.sh
./export_tsv.sh curated
./export_tsv.sh expand_rxcui_str
cat $TSV/$CURATED.curated.tsv $TSV/$CURATED.expand_rxcui_str.tsv > data/$CURATED.tsv
cd data; rm -f curated.tsv; ln -s $CURATED.tsv curated.tsv; cd ..

export CURATED='opioid5'
source env_table_schema.sh
./make.sh
./export_tsv.sh curated
./export_tsv.sh expand_rxcui_str
cat $TSV/$CURATED.curated.tsv $TSV/$CURATED.expand_rxcui_str.tsv > data/$CURATED.tsv
cd data; rm -f curated.tsv; ln -s $CURATED.tsv curated.tsv; cd ..

####
export CURATED='opioid'
source env_table_schema.sh
$mysql_table_schema -e "insert into opioid.curated_steward select distinct 'opioid5', RXCUI, STR from opioid5.curated"
$mysql_table_schema -e "drop table if exists opioid.curated"
$mysql_table_schema -e "create table opioid.curated select distinct RXCUI, STR from opioid.curated_steward order by RXCUI, STR"
