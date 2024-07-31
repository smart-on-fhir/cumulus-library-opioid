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

echo "########################################################################"
echo "./prepare.sh"
echo "[start]"
mysql -u root -e "show databases"
echo "########################################################################"

export CURATED='all_rxcui_str'
source env_table_schema.sh
./create_database.sh
$mysql_table_schema < common/umls/all_rxcui_str.sql

export CURATED='keywords'
source env_table_schema.sh
./create_database.sh
$mysql_table_schema < common/keywords/keywords.curated.sql

echo "########################################################################"
echo "./prepare.sh"
echo "[done]"
mysql -u root -e "show databases"
echo "########################################################################"
