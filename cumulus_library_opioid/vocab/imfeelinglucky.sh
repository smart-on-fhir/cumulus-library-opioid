#!/bin/bash
set -e
source db.config
source env_table_schema.sh

./prepare.sh
./make_all.sh
./jaccard/jaccard.sh