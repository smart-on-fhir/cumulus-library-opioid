# Umls data mock structure

All data is lightly massaged data from the relevant source tables.

It is assumed that the query string for lookup is 'opioid' for system 'MED-RT'

## mrconso.csv

Lines 2-3 should be ingored due to having a different system
Line 4 should be found in the initial search, but have no related concepts
Line 5 should be found in the initial search, and have two related concepts
Lines 6-9 should be found in the first rules expansion search
lines 10-13 should be found in the second rules expansion search
Lines 14-16 should never be found, as an unrelated concept

## mrrel.csv

Lines 2-5 should be found in the tier 0, by matching
    the cui found via word search (C2917209) to the cui1 field in this table.
Lines 6-9 should be found in the tier 2 expansion search, by looking up
    all cui1 values that match a cui2 value in our tier 0 set that themselves
    have a cui2 value that is not yet in the dataset
Lines 10-11 are unrelated relations that should not be used.
