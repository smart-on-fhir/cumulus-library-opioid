#!/bin/bash
set -e
source db.config
source env_table_schema.sh

echo "*************************************************"
echo "START  $CURATED"
echo "./make.sh $CURATED"
echo "*************************************************"

./create_database.sh
./analyze/analyze.sh
./backup_database.sh

echo "*************************************************"
echo "DONE  $CURATED"
echo "*************************************************"
