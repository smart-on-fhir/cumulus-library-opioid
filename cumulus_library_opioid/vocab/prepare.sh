#!/bin/bash
set -e

# TODO: check requirements are present :
  # curated sources (usually VSAC_orig downloads) in TSV tab formatted  "RXCUI STR"

  # SQL databases
    # umls.MRCONSO
    # umls.MRREL
    # rxnorm.RXNCONSO
    # rxnorm.RXNREL

###############################################################################
#
# These are "expensive" operations so doing 1X is better than for each VSAC_orig

export CURATED='all_rxcui_str'
source env_table_schema.sh
./create_database.sh
$mysql_table_schema < common/umls/all_rxcui_str.sql

#  export CURATED='keywords'
#  source env_table_schema.sh
#  ./create_database.sh
#  $mysql_table_schema < common/keywords/keywords.curated.sql

###############################################################################
## MEDRT sources

export CURATED='medrt'
source env_table_schema.sh
./create_database.sh
$mysql_table_schema < medrt/generated/medrt_drop.sql
$mysql_table_schema < medrt/generated/medrt_umls_init.sql
$mysql_table_schema < medrt/generated/medrt_opioid.sql
$mysql_table_schema < medrt/generated/medrt_rxcui.sql
./backup_database.sh
./export_tsv.sh curated

export CURATED='medrt_non'
source env_table_schema.sh
$mysql_table_schema < generated/medrt_drop.sql
$mysql_table_schema < generated/medrt_umls_init.sql
$mysql_table_schema < generated/medrt_non.sql
$mysql_table_schema < generated/medrt_rxcui.sql
./backup_database.sh
./export_tsv.sh curated
