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
./create_database.sh
$mysql_table_schema < common/umls/umls_cui_rxcui.sql

export CURATED='keywords'
./create_database.sh
$mysql_table_schema < common/keywords/keywords.curated.sql

###############################################################################
# MEDRT sources
./medrt/medrt.sh





