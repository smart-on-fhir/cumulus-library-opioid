#!/bin/bash
set -e
source db.config
source env_table_schema.sh

./drop_all.sh
./prepare.sh
./make_all.sh
./make_opioid.sh
./jaccard.sh