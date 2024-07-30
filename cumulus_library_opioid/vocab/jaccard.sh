#!/bin/bash
set -e

source env_table_schema.sh

$mysql_table_schema < jaccard/jaccard_drop.sql
$mysql_table_schema < jaccard/jaccard_schema.sql
$mysql_table_schema < jaccard/generated/jaccard_insert.sql
$mysql_table_schema < jaccard/jaccard_score.sql
