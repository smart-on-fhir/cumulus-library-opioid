#!/bin/bash
set -e
source ../env_table_schema.sh

$mysql_table_schema < jaccard_schema.sql
$mysql_table_schema < generated/jaccard_insert.sql
$mysql_table_schema < jaccard_score.sql
