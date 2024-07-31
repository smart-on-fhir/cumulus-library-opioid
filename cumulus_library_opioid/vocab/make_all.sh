#!/bin/bash
set -e
source db.config
source env_table_schema.sh

echo "########################################################################"
echo "./make_all.sh"
echo "[start]"

export CURATED='acep'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

export CURATED='atc_non'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

export CURATED='bioportal'
cd data; rm -f curated.tsv; ln -s bioportal.curated.tsv curated.tsv; cd ..
./make.sh

export CURATED='bwh'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

export CURATED='CancerLinQ'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

export CURATED='CancerLinQ_non'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

export CURATED='cliniwiz_keywords'
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

export CURATED='mitre'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

export CURATED='mdpartners_non'
cd data; rm -f curated.tsv; ln -s VSAC/$CURATED.tsv curated.tsv; cd ..
./make.sh

export CURATED='medrt'
cd data; rm -f curated.tsv; ln -s medrt.curated.tsv curated.tsv; cd ..
./make.sh

export CURATED='medrt_non'
cd data; rm -f curated.tsv; ln -s medrt_non.curated.tsv curated.tsv; cd ..
./make.sh

###############################################################################
# Validation: UCDAVIS Epic EHR real world data of prescriptions

export CURATED='ucdavis'
source env_table_schema.sh
cd data; rm -f curated.tsv; ln -s ucdavis.ordered_rxcui_str.tsv curated.tsv; cd ..
./make.sh
$mysql_table_schema -e "drop table if exists ucdavis.curated"
$mysql_table_schema -e "create table ucdavis.curated select distinct RXCUI, STR from ucdavis.curated_rxcui_str order by RXCUI, STR"

echo "########################################################################"
echo "./make_all.sh"
echo "[done]"
