#!/bin/bash
set -e
source db.config
source env_table_schema.sh

export CURATED='acep'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

export CURATED='bioportal'
cd data; rm -f curated.tsv; ln -s bioportal.curated.tsv curated.tsv; cd ..
./make.sh

export CURATED='CancerLinQ'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

export CURATED='ecri'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

export CURATED='impaq'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

export CURATED='lantana'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

export CURATED='math_349'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

#export CURATED='medrt'
#./make.sh

export CURATED='mitre'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

export CURATED='CancerLinQ_non'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

export CURATED='mdpartners_non'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

export CURATED='atc_non'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

#export CURATED='medrt_non'
#./make.sh

export CURATED='cliniwiz_keywords'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

#export CURATED='keywords'
#./make.sh