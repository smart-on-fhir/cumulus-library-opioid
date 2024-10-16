#!/bin/bash
set -e
source db.config
source env_table_schema.sh

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "./imfeelinglucky.sh"
echo "@start"

./drop_all.sh
./prepare.sh
./medrt.sh
./make_all.sh
./make_opioid.sh
./jaccard.sh
./backup_all.sh
./backup_database.sh keywords
./backup_database.sh all_rxcui_str

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "./imfeelinglucky.sh"
echo "@done"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"


