#!/bin/bash
set -e
source db.config
source env_table_schema.sh

mysql -u root -e "drop database if exists ${TABLE_SCHEMA}"
mysql -u root -e "create database ${TABLE_SCHEMA} character set utf8 COLLATE utf8_unicode_ci"
mysql -u root -e "show databases"

# Log and versioning info  (currently specific to MySQL)
$mysql_table_schema < common/logging/logging.sql
$mysql_table_schema < common/logging/version.sql

$mysql_table_schema < common/umls/uml_abbreviations.sql
$mysql_table_schema < common/keywords/keywords.sql
$mysql_table_schema < common/expand_rules/expand_rules.sql

echo '#############################################'
$mysql_table_schema -e "call mem"
echo '#############################################'




