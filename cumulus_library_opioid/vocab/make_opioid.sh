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
