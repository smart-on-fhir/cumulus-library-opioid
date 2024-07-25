#!/bin/bash
set -e

echo ### PWD
pwd

# Opioid
export CURATED='medrt'
source ../env_table_schema.sh
$mysql_table_schema < generated/medrt_drop.sql
$mysql_table_schema < generated/medrt_umls_init.sql
$mysql_table_schema < generated/medrt_opioid.sql

# Non-opioid
export CURATED='medrt_non'
source ../env_table_schema.sh
$mysql_table_schema < generated/medrt_drop.sql
$mysql_table_schema < generated/medrt_umls_init.sql
$mysql_table_schema < generated/medrt_non.sql
