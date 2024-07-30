#!/bin/bash
set -e
source db.config
source env_table_schema.sh

export CURATED='acep'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='atc_non'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='bioportal'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='bwh'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='CancerLinQ'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='cliniwiz'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='cliniwiz_keywords'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='ecri'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='impaq'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='lantana'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='math_349'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='medrt'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='medrt_non'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='mitre'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='CancerLinQ_non'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='mdpartners_non'
mysql -u root -e "drop database if exists ${CURATED}"

###############################################################################
# Validation: UCDAVIS Epic EHR real world data of prescriptions

export CURATED='ucdavis'
mysql -u root -e "drop database if exists ${CURATED}"

###############################################################################
# Cumulus Opioid Vocabulary

export CURATED='opioid'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='opioid2'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='opioid3'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='opioid4'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='opioid5'
mysql -u root -e "drop database if exists ${CURATED}"

export CURATED='opioid6'
mysql -u root -e "drop database if exists ${CURATED}"


