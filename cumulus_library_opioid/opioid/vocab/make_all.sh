#!/bin/bash
set -e
source db.config
source env_table_schema.sh

export CURATED='acep'
./make.sh

export CURATED='bioportal'
./make.sh

export CURATED='CancerLinQ'
./make.sh

export CURATED='ecri'
./make.sh

export CURATED='impaq'
./make.sh

export CURATED='lantana'
./make.sh

export CURATED='math_349'
./make.sh

export CURATED='medrt'
./make.sh

export CURATED='mitre'
./make.sh

export CURATED='CancerLinQ_non'
./make.sh

export CURATED='mdpartners_non'
./make.sh

export CURATED='atc_non'
./make.sh

export CURATED='medrt_non'
./make.sh

export CURATED='cliniwiz_keywords'
./make.sh

export CURATED='keywords'
./make.sh
