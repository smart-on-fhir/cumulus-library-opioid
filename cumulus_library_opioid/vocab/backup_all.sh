#!/bin/bash
set -e
source db.config
source env_table_schema.sh

export CURATED='acep'
./backup_database.sh

export CURATED='atc_non'
./backup_database.sh

export CURATED='bioportal'
./backup_database.sh

export CURATED='bwh'
./backup_database.sh

export CURATED='CancerLinQ'
./backup_database.sh

export CURATED='CancerLinQ_non'
./backup_database.sh

export CURATED='ecri'
./backup_database.sh

export CURATED='impaq'
./backup_database.sh

export CURATED='lantana'
./backup_database.sh

export CURATED='math_349'
./backup_database.sh

export CURATED='medrt'
./backup_database.sh

export CURATED='medrt_non'
./backup_database.sh

export CURATED='mitre'
./backup_database.sh

export CURATED='mdpartners_non'
./backup_database.sh

export CURATED='cliniwiz_keywords'
./backup_database.sh

export CURATED='keywords'
./backup_database.sh

export CURATED='opioid'
./backup_database.sh

export CURATED='ucdavis'
./backup_database.sh


