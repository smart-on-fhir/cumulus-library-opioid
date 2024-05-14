#!/bin/bash
set -e
source db.config
source env_table_schema.sh

./create_database.sh
./analyze/analyze.sh
./backup_database.sh
