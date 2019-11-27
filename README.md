
<!-- README.md is generated from README.Rmd. Please edit that file -->

# codemetar

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Travis-CI Build
Status](https://travis-ci.org/ropensci/codemetar.svg?branch=master)](https://travis-ci.org/ropensci/codemetar)
[![AppVeyor Build
status](https://ci.appveyor.com/api/projects/status/csawpip238vvbd72/branch/master?svg=true)](https://ci.appveyor.com/project/cboettig/codemetar/branch/master)
[![Coverage
Status](https://img.shields.io/codecov/c/github/ropensci/codemetar/master.svg)](https://codecov.io/github/ropensci/codemetar?branch=master)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/codemetar)](https://cran.r-project.org/package=codemetar)
[![](http://badges.ropensci.org/130_status.svg)](https://github.com/ropensci/onboarding/issues/130)
[![DOI](https://zenodo.org/badge/86626030.svg)](https://zenodo.org/badge/latestdoi/86626030)
[![CRAN RStudio mirror
downloads](http://cranlogs.r-pkg.org/badges/codemetar)](https://CRAN.R-project.org/package=codemetar)

**Why codemetar?** The ‘Codemeta’ Project defines a ‘JSON-LD’ format for
describing software metadata, as detailed at
<https://codemeta.github.io>. This package provides utilities to
**generate, parse, and modify codemeta.jsonld files automatically for R
packages**, as well as tools and examples for **working with codemeta
json-ld more generally**.

It has three main goals:

  - Quickly **generate a valid codemeta.json file from any valid R
    package**. To do so, we automatically extract as much metadata as
    possible using the DESCRIPTION file, as well as extracting metadata
    from other common best-practices such as the presence of Travis and
    other badges in README, etc.
  - Facilitate the addition of further metadata fields into a
    codemeta.json file, as well as general manipulation of codemeta
    files.
  - Support the ability to crosswalk between terms used in other
    metadata standards, as identified by the Codemeta Project Community,
    see <https://codemeta.github.io/crosswalk>

## Package developers, create a codemeta.json for your package

**Why bother creating a codemeta.json for your package?** R packages
encode lots of metadata in the `DESCRIPTION` file, `README`, and other
places, telling users and developers about the package purpose, authors,
license, dependencies, and other information that facilitates discovery,
adoption, and credit for your software. Unfortunately, because each
software language records this metadata in a different format, that
information is hard for search engines, software repositories, and other
developers to find and integrate.

By generating a `codemeta.json` file, you turn your metadata into a
format that can [easily
crosswalk](https://docs.ropensci.org/codemetar/crosswalk) between
metadata in many other software languages. CodeMeta is built on
[schema.org](https://schema.org) a simple [structured
data](https://developers.google.com/search/docs/guides/intro-structured-data)
format developed by major search engines like Google and Bing to improve
discoverability in search. CodeMeta is also understood by significant
software archiving efforts such as [Software
Heritage](https://www.softwareheritage.org/) Project, which seeks to
permanently archive all open source software.

For more general information about the CodeMeta Project for defining
software metadata, see <https://codemeta.github.io>. In particular, new
users might want to start with the [User
Guide](https://codemeta.github.io/user-guide/), while those looking to
learn more about JSON-LD and consuming existing codemeta files should
see the [Developer Guide](https://codemeta.github.io/developer-guide/).

## Create a codemeta.json in one function call

**Why codemetar?** The ‘Codemeta’ Project defines a ‘JSON-LD’ format for
describing software metadata, as detailed at
<https://codemeta.github.io>. This package provides utilities to
**generate, parse, and modify codemeta.jsonld files automatically for R
packages**, as well as tools and examples for **working with codemeta
json-ld more generally**.

It has three main goals:

  - Quickly **generate a valid codemeta.json file from any valid R
    package**. To do so, we automatically extract as much metadata as
    possible using the DESCRIPTION file, as well as extracting metadata
    from other common best-practices such as the presence of Travis and
    other badges in README, etc.
  - Facilitate the addition of further metadata fields into a
    codemeta.json file, as well as general manipulation of codemeta
    files.
  - Support the ability to crosswalk between terms used in other
    metadata standards, as identified by the Codemeta Project Community,
    see <https://codemeta.github.io/crosswalk>

## Installation

You can install the latest version from CRAN using:

``` r
install.packages("codemetar")
```

You can also install the development version of `codemetar` from github
with:

``` r
# install.packages("devtools")
devtools::install_github("ropensci/codemetar")
```

``` r
library("codemetar")
```

## Modifying or enriching CodeMeta metadata

The best way to ensure `codemeta.json` is as complete as possible is to
begin by making full use of the fields that can be set in an R package
DESCRIPTION file, such as `BugReports` and `URL`. Using the `Authors@R`
notation allows a much richer specification of author roles, correct
parsing of given vs family names, and email addresses.

In the current implementation, developers may specify an ORCID url for
an author in the optional `comment` field of `Authors@R`,
    e.g.

    Authors@R: person("Carl", "Boettiger", role=c("aut", "cre", "cph"), email="cboettig@gmail.com", comment="http://orcid.org/0000-0002-1642-628X")

which will allow `codemetar` to associate an identifier with the person.
If the package is hosted on CRAN, including the ORCiD in this way will
cause an ORCiD logo and link to the ORCiD page to be added to the
package CRAN webpage.

### Using the DESCRIPTION file

The DESCRIPTION file is the natural place to specify any metadata for an
R package. The `codemetar` package can detect certain additional terms
in the [CodeMeta context](https://codemeta.github.io/terms). Almost any
additional codemeta field (see `codemetar:::additional_codemeta_terms`
for a list) and can be added to and read from the DESCRIPTION into a
`codemeta.json` file.

CRAN requires that you prefix any additional such terms to indicate the
use of `schema.org` explicitly, e.g. `keywords` would be specified in a
DESCRIPTION file
    as:

    X-schema.org-keywords: metadata, codemeta, ropensci, citation, credit, linked-data

Where applicable, these will override values otherwise guessed from the
source repository. Use comma-separated lists to separate multiple values
to a property, e.g. keywords.

See the
[DESCRIPTION](https://github.com/ropensci/codemetar/blob/master/DESCRIPTION)
file of the `codemetar` package for an example.

## Going further

Check out all the [codemetar
vignettes](https://codemeta.github.io/codemetar/articles/index.html) for
tutorials on other cool stuff you can do with codemeta and
json-ld.

[![ropensci\_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
