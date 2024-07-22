# Opioid RxNorm Vocab

This document attempts to lay out, explicitly, what all of the various tables in the vocab rules generation do. It will reference them by builder name, and reference the original bash/raw sql implementation, until such time as the latter is removed when this is committed to trunk.

Part of the reason for this existing is to straighten out naming so we're not overloading terms. If a name is not clear, please throw darts at it.

## Third Party Nomenclature

The following terms are defined by external parties:
  - *RxNorm*: A medical coding system, and 
    [the set](https://www.nlm.nih.gov/research/umls/rxnorm/index.html)  
    of Unified Medical Language System (UMLS)data tables hosted by NIH
    describing the relationships of items using this system. 
    Many of the names of elements are holdovers from earlier eras in computing,
    so they are not the most descriptive - see the
    [overview](https://www.nlm.nih.gov/research/umls/rxnorm/overview.html)
    for more information. We'll outline some of them here.
      - *RXNCONSO*: The list of drugs and their identifiers. This is the source
      of truth for codes for individual drugs. *RXCUI* is the primary ID column
      in this dataset, and *TTY* (term type) is often used as parts of lookups.
      - *RXNREL*: A list of relationships between different drugs in RXNCONSO.
      This is the table we are using to drive the discovery of additional drugs
      from an initial set - this handles things like 'Narcan is a brand name
      for a drug containing Naloxone'.
      - *RXNSTY*: A mapping of items in the RxNorm system to broad categories.
      'clinical drug' is the most common.
  - *VSAC*: The 
    [Value Set Authority Center](https://www.nlm.nih.gov/vsac/support/index.html), 
    which provides a repository for the creation of related sets of values
    by parties outside of NIH of related terms. For the purposes of this study,
    this is medications considered to be opiates, and the sets we are using are
    specific to the RxNorm coding system.
      - *Steward*: A valueset steward is the entity managing a specific
      valueset. The generated SQL in this study uses `acep` for this,
      which is first alphabetically in the list of available stewards related
      to this use case.
      - A steward is usually an organization, which may have several
      *authors* who manage the data.
      - In some cases, a valueset created by a steward is referred to as a
      *curated* dataset
      - A valueset is given an *oid* as a globally unique identifier
      - VSAC has an API which you can hit to get the members of a valueset.
      The API provides this data with the medical system coding in a field
      named *code*.

## Prerequisites

It is assumed you have both the 
[UMLS Study](https://github.com/smart-on-fhir/cumulus-library-umls)
and the 
[RxNorm Study](https://github.com/smart-on-fhir/cumulus-library-rxnorm)
loaded into your database.

## Static Builder

The static builder handles all tables that are built from standalone data files,
rather than derived from other data in the database.

### `keywords` (prev keywords, keywords_str_in_str)

A list of substrings of the display names in RxNorm of medications. This will be
the primary artifact provided by a study author, and is used for filtering of 
other tables, and tracking the original source of discovered related medications.

### `rxn_curated` (prev RXNCONSO_curated)

A to be replaced/renamed list of codes and identifiers RXNCONSO, which has the
keywords left joined to it by a substring match. We will eventually do this join
directly from a copy of RXNCONSO in the database.

This table needs to be renamed.

### `expansion_rules` (prev expand_rules)

A human curated mapping of TTY relation types that are relevant to our specific
task of identifying other medications from an initial list. An example is
'BN (Brand name) is a trade name of IN (ingredient)'. These are annotated
with a rule identifier ternary (Yes/No/Keyword) which is used to decide
how to apply these rules later.

### `umls_tty`

A mapping of abbreviations for TTY codes to human readable display names.

### `[steward]_vsac` (prev curated)

A list of codes and display names derived by looking up a specific value set
OID via the VSAC API. It should be of the same format as `rxn_curated`

## RxNorm-VSAC Builder

This file handles combining the curated dataset with RxNorm tables to
produce a relationship, derived from `RXNREL`, of drugs identified by
keywords to other potential drugs, with the goal of generating a more
comprehensive list.

### `[steward]_rxnconso` (prev RXNCONSO_curated)

This generates a list by selecting all the values from `RXNCONSO` which
have a matching code in the data downloaded from the VSAC API.

### `[steward]_rxnconso_keywords` (prev RXNCONSO_curated w/ update)

This adds a column to `[steward]_rxnconso`, derived from the `keywords`
table, by searching for a given keyword as part of the name of
the particular drug

### `[steward]_rxnconso_keywords_annotated`

This was an attempt to generate something like `rxn_curated`. It should
be fixed to do so, or removed.

### `[steward]_rxnsty` (prev RXNSTY_curated)
A list of category types from `RXNSTY`, filtered by the codes from the 
VSAC API.

### `[steward]_rxnrel` (prev RXNREL_curated)
A list of relationships from `RXNREL`, filtered by the codes from the
VSAC API

### `[steward]_rela` (prev RXNCONSO_curated_rela)
a mapping of the medications in `[steward]_rxnconso_keywords` to the
related terms in `[steward]_rxnrel`, based on the rxcui of the former
matching the first of two rxcuis found in the latter

## Rules expansion builder

This file uses the steward-specific annotations, and the expansion rules
defined by the user, to select additional medications to add to the 
potential medications related to the keywords.

### `expansion_rules_descriptions` (prev expand_rules_readme)

This uses the `umls_tty` table to get user-friendly descriptions of the
TTY categories for the expansion rules tables, mostly as a convenience
for an analysts reviewing the rules

This was originally in the static builder, and could go back there.

### `[steward]_relaxed_expansion` (prev expand_relax)

Using `rxn_curated` as the RXNCONSO source, `[steward]_rela` as the
relationship, and `[vendor]_rxnconso_keywords` as the source of
RXCUIs, get every medication from the RXNCONSO source that is defined
by the relationship that is not already in the list of RXCUIs.

### `[steward]_strict_expansion` (prev expand_strict)

Using `[steward]_relaxed_expansion`, and the user defined `expansion_rules`,
get every relationship where the rule inclusion is defined as 'Yes',
excluding relationships of two specific types.

### `[steward]_expanded_keywords` (prev expand_keywords)

Using `[steward]_relaxed_expansion`, and the user defined `expansion_rules`,
get every relationship where the rule inclusion is defined as 'Keyword',
excluding relationships of two specific types.

### `[steward]_expanded_ruleset` (prev expand)

This is the union of `[steward]_expanded_keywords` and `[steward]_expanded_ruleset`