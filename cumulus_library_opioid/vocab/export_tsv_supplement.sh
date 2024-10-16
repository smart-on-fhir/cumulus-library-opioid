#!/bin/bash
source db.config

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "./export_tsv_supplement.sh"

echo "@start"

export CURATED='acep'

./export_tsv.sh curated_keywords
./export_tsv.sh stats_keywords
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh stats_expand
./export_tsv.sh expand_keywords_rxcui_str

export CURATED='atc_non'
./export_tsv.sh curated_keywords
./export_tsv.sh stats_keywords
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh stats_expand
./export_tsv.sh expand_keywords_rxcui_str

export CURATED='bioportal'
./export_tsv.sh curated_keywords
./export_tsv.sh stats_keywords
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh stats_expand
./export_tsv.sh expand_keywords_rxcui_str

export CURATED='bwh'
./export_tsv.sh curated_keywords
./export_tsv.sh stats_keywords
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh stats_expand
./export_tsv.sh expand_keywords_rxcui_str

export CURATED='CancerLinQ'
./export_tsv.sh curated_keywords
./export_tsv.sh stats_keywords
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh stats_expand
./export_tsv.sh expand_keywords_rxcui_str

export CURATED='CancerLinQ_non'
./export_tsv.sh curated_keywords
./export_tsv.sh stats_keywords
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh stats_expand
./export_tsv.sh expand_keywords_rxcui_str

export CURATED='cliniwiz_keywords'
./export_tsv.sh curated_keywords
./export_tsv.sh stats_keywords
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh stats_expand
./export_tsv.sh expand_keywords_rxcui_str

export CURATED='ecri'
./export_tsv.sh curated_keywords
./export_tsv.sh stats_keywords
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh stats_expand
./export_tsv.sh expand_keywords_rxcui_str

export CURATED='impaq'
./export_tsv.sh curated_keywords
./export_tsv.sh stats_keywords
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh stats_expand
./export_tsv.sh expand_keywords_rxcui_str

export CURATED='lantana'
./export_tsv.sh curated_keywords
./export_tsv.sh stats_keywords
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh stats_expand
./export_tsv.sh expand_keywords_rxcui_str

export CURATED='math_349'
./export_tsv.sh curated_keywords
./export_tsv.sh stats_keywords
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh stats_expand
./export_tsv.sh expand_keywords_rxcui_str

export CURATED='mitre'
./export_tsv.sh curated_keywords
./export_tsv.sh stats_keywords
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh stats_expand
./export_tsv.sh expand_keywords_rxcui_str

export CURATED='mdpartners_non'
./export_tsv.sh curated_keywords
./export_tsv.sh stats_keywords
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh stats_expand
./export_tsv.sh expand_keywords_rxcui_str

export CURATED='medrt'
./export_tsv.sh curated_keywords
./export_tsv.sh stats_keywords
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh stats_expand
./export_tsv.sh expand_keywords_rxcui_str

export CURATED='medrt_non'
./export_tsv.sh curated_keywords
./export_tsv.sh stats_keywords
./export_tsv.sh expand
./export_tsv.sh expand_rxcui_str
./export_tsv.sh stats_expand
./export_tsv.sh expand_keywords_rxcui_str

export CURATED='opioid'
./export_tsv.sh curated
./export_tsv.sh curated_vsac_method
./export_tsv.sh curated_vsac_method_stat
./export_tsv.sh disagreement
./export_tsv.sh disagreement_rxcui
./export_tsv.sh missed
./export_tsv.sh missed_rxcui
./export_tsv.sh human
./export_tsv.sh conflict_false_neg
./export_tsv.sh conflict_false_neg_count
./export_tsv.sh conflict_false_pos
./export_tsv.sh conflict_false_pos_count
./export_tsv.sh opioid_valueset

cp /Users/andy/code/medgen-umls/opioid/tsv/*.tsv ./tsv/
