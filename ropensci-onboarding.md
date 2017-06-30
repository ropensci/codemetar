### Summary

-   What does this package do? (explain in 50 words or less):

Codemeta defines a 'JSON-LD' format for describing software metadata.
    This package provides utilities to generate, parse, and modify codemeta.jsonld
    files automatically for R packages.

-   Paste the full DESCRIPTION file inside a code block below:

```
Package: codemetar
Type: Package
Title: Generate CodeMeta Metadata for R Packages
Version: 0.1.0
Authors@R: person("Carl", "Boettiger", role=c("aut", "cre", "cph"), email="cboettig@gmail.com", comment="http://orcid.org/0000-0002-1642-628X")
Description: Codemeta defines a 'JSON-LD' format for describing software metadata.
    This package provides utilities to generate, parse, and modify codemeta.jsonld
    files automatically for R packages.
License: MIT + file LICENSE
URL: https://github.com/codemeta/codemetar
BugReports: https://github.com/codemeta/codemetar/issues
Encoding: UTF-8
LazyData: true
RoxygenNote: 6.0.1
Depends: R (>= 3.0.0)
Imports: jsonlite (>= 1.3),
    jsonld,
    git2r,
    devtools,
    methods,
    stringi
Suggests: testthat,
    jsonvalidate,
    covr,
    knitr,
    rmarkdown,
    httr,
    magrittr,
    readr,
    xml2
VignetteBuilder: knitr
keywords: metadata, codemeta, ropensci, citation, credit
affiliation: https://ropensci.org
relatedLink: https://codemeta.github.io/codemetar

```

-   URL for the package (the development repository, not a stylized html page): https://github.com/codemeta/codemetar

- Please indicate which category or categories from our [package fit policies](https://github.com/ropensci/onboarding/blob/master/policies.md#package-fit) this package falls under ***and why**(? (e.g., data retrieval, reproducibility. If you are unsure, we suggest you make a pre-submission inquiry.):

Package for creating and working with scientific software metadata


-   Who is the target audience?

Academic researchers looking to create metadata for their software

-   Are there other R packages that accomplish the same thing? If so, how does
yours differ or meet [our criteria for best-in-category](https://github.com/ropensci/onboarding/blob/master/policies.md#overlap)?

Nope

### Requirements

Confirm each of the following by checking the box.  This package:

- [x] does not violate the Terms of Service of any service it interacts with.
- [x] has a CRAN and OSI accepted license.
- [x] contains a README with instructions for installing the development version.
- [x] includes documentation with examples for all functions.
- [x] contains a vignette with examples of its essential functions and uses.
- [x] has a test suite.
- [x] has continuous integration, including reporting of test coverage, using services such as Travis CI, Coeveralls and/or CodeCov.
- [x] I agree to abide by [ROpenSci's Code of Conduct](https://github.com/ropensci/onboarding/blob/master/policies.md#code-of-conduct) during the review process and in maintaining my package should it be accepted.

#### Publication options

- [x] Do you intend for this package to go on CRAN?
- [x] Do you wish to automatically submit to the [Journal of Open Source Software](http://joss.theoj.org/)? If so:
    - [ ] The package contains a [`paper.md`](http://joss.theoj.org/about#paper_structure) with a high-level description in the package root or in `inst/`.
    - [ ] The package is deposited in a long-term repository with the DOI:
    - (*Do not submit your package separately to JOSS*)

### Detail

- [x] Does `R CMD check` (or `devtools::check()`) succeed?  Paste and describe any errors or warnings:

- [x] Does the package conform to [rOpenSci packaging guidelines](https://github.com/ropensci/onboarding/blob/master/packaging_guide.md)? Please describe any exceptions:

A few lines of code handle exceptional cases that are difficult to cover in unit tests.  Otherwise no there should be no outstanding `goodpractice` flags in the repo.  

- If this is a resubmission following rejection, please explain the change in circumstances:

- If possible, please provide recommendations of reviewers - those with experience with similar packages and/or likely users of your package - and their GitHub user names:

