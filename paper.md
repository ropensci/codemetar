---
title: 'Generating CodeMeta Metadata for R Packages'
tags:
 - metadata
 - codemeta
 - ropensci
 - citation
 - credit
authors:
 - name: Carl Boettiger
   orcid: 0000-0002-1642-628X
   affiliation: 1
affiliations:
 - name: University of California, Berkeley
   index: 1
date: 2017-06-29
bibliography: paper.bib
---

# Summary

The CodeMeta project, <codemeta.github.io>, defines a 'JSON-LD' format for describing software
metadata, based largely on `schema.org` terms.
This metadata format is being adopted by many leading archives for scientific software, including DataCite,
Zenodo, and DataONE to address many of the needs identified in the NIH report on the need for a
"Software Discovery Index", <http://www.softwarediscoveryindex.org/>.
Many common software metadata formats have been mapped into CodeMeta by means of a crosswalk table,
<https://codemeta.github.io/crosswalk/>, also implemented in this package.
The `codemetar` package provides utilities to generate and validate these `codemeta.json`
files automatically for R packages by parsing the DESCRIPTION file
and other common locations for R metadata.
The package also includes utilities and examples for parsing and working with existing codemeta files,
and includes several vignettes which illustrate both the basic usage of the package as well as some more advanced applications.

# References
