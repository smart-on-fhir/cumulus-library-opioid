#!/bin/bash
set -e

# TODO: check requirements are present :
  # curated sources (usually VSAC downloads) in TSV tab formatted  "RXCUI STR"

  # SQL databases
    # umls.MRCONSO
    # umls.MRREL
    # rxnorm.RXNCONSO
    # rxnorm.RXNREL

###############################################################################
#
# These are "expensive" operations so doing 1X is better than for each VSAC

export CURATED='all_rxcui_str'
source env_table_schema.sh
./create_database.sh
$mysql_table_schema < common/umls/all_rxcui_str.sql

export CURATED='keywords'
source env_table_schema.sh
./create_database.sh
$mysql_table_schema < common/keywords/keywords.curated.sql

###############################################################################
# Validation: UCDAVIS Epic EHR real world data of prescriptions

export CURATED='ucdavis'
source env_table_schema.sh
./create_database.sh
$mysql_table_schema < analyze/curate.sql

###############################################################################
## MEDRT sources

./create_database.sh medrt
./create_database.sh medrt_non
cd medrt
./medrt.sh

