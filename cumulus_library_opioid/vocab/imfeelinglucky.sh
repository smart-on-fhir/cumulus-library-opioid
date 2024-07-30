#!/bin/bash
set -e
source db.config
source env_table_schema.sh

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "./imfeelinglucky.sh"
echo "@start"

./drop_all.sh
# ./prepare.sh
./make_all.sh
./make_opioid.sh
./jaccard.sh

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "./imfeelinglucky.sh"
echo "@done"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"


