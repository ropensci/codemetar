
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![Travis-CI Build Status](https://travis-ci.org/codemeta/codemetar.svg?branch=master)](https://travis-ci.org/codemeta/codemetar) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/codemeta/codemetar?branch=master&svg=true)](https://ci.appveyor.com/project/cboettig/codemetar) [![Coverage Status](https://img.shields.io/codecov/c/github/codemeta/codemetar/master.svg)](https://codecov.io/github/codemeta/codemetar?branch=master) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/codemetar)](https://cran.r-project.org/package=codemetar)

<!-- README.md is generated from README.Rmd. Please edit that file -->
codemetar
=========

The goal of codemetar is to generate the JSON-LD file, `codemeta.json` containing software metadata describing an R package. For more general information about the CodeMeta Project for defining software metadata, see <https://codemeta.github.io>. In particular, new users might want to start with the [User Guide](https://codemeta.github.io/user-guide/), while those looking to learn more about JSON-LD and consuming existing codemeta files should see the [Developer Guide](https://codemeta.github.io/developer-guide/).

Installation
------------

You can install codemetar from github with:

``` r
# install.packages("devtools")
devtools::install_github("codemeta/codemetar")
```

``` r
library("codemetar")
```

Example
-------

This is a basic example which shows you how to generate a `codemeta.json` for an R package (e.g. for `testthat`):

``` r
write_codemeta("testthat")
```

`codemetar` can take the path to the package root instead. This may allow `codemetar` to glean some additional information that is not available from the description file alone.

``` r
write_codemeta(".")
```

    {
      "@context": [
        "https://doi.org/doi:10.5063/schema/codemeta-2.0",
        "http://schema.org"
      ],
      "@type": "SoftwareSourceCode",
      "identifier": "codemetar",
      "description": "Codemeta defines a 'JSON-LD' format for describing software metadata.\n    This package provides utilities to generate, parse, and modify codemeta.jsonld\n    files automatically for R packages.",
      "name": "codemetar: Generate CodeMeta Metadata for R Packages",
      "issueTracker": "https://github.com/codemeta/codemetar/issues",
      "license": "https://spdx.org/licenses/MIT",
      "version": "0.1.0",
      "programmingLanguage": {
        "@type": "ComputerLanguage",
        "name": "R",
        "version": "3.4.0",
        "url": "https://r-project.org"
      },
      "runtimePlatform": "R version 3.4.0 (2017-04-21)",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Central R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "author": [
        {
          "@type": "Person",
          "givenName": "Carl",
          "familyName": "Boettiger",
          "email": "cboettig@gmail.com",
          "@id": "http://orcid.org/0000-0002-1642-628X"
        }
      ],
      "copyrightHolder": [
        {
          "@type": "Person",
          "givenName": "Carl",
          "familyName": "Boettiger",
          "email": "cboettig@gmail.com",
          "@id": "http://orcid.org/0000-0002-1642-628X"
        }
      ],
      "maintainer": {
        "@type": "Person",
        "givenName": "Carl",
        "familyName": "Boettiger",
        "email": "cboettig@gmail.com",
        "@id": "http://orcid.org/0000-0002-1642-628X"
      },
      "softwareSuggestions": [
        {
          "@type": "SoftwareApplication",
          "identifier": "testthat",
          "name": "testthat",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "jsonvalidate",
          "name": "jsonvalidate",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "covr",
          "name": "covr",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "knitr",
          "name": "knitr",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "rmarkdown",
          "name": "rmarkdown",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "httr",
          "name": "httr",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "magrittr",
          "name": "magrittr",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "readr",
          "name": "readr",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "xml2",
          "name": "xml2",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "dplyr",
          "name": "dplyr",
          "version": "0.7.0",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "purrr",
          "name": "purrr",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "printr",
          "name": "printr",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        }
      ],
      "softwareRequirements": [
        {
          "@type": "SoftwareApplication",
          "identifier": "jsonlite",
          "name": "jsonlite",
          "version": "1.3",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "jsonld",
          "name": "jsonld",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "git2r",
          "name": "git2r",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "devtools",
          "name": "devtools",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "methods",
          "name": "methods"
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "stringi",
          "name": "stringi",
          "provider": {
            "@id": "https://cran.r-project.org",
            "@type": "Organization",
            "name": "Central R Archive Network (CRAN)",
            "url": "https://cran.r-project.org"
          }
        },
        {
          "@type": "SoftwareApplication",
          "identifier": "R",
          "name": "R",
          "version": "3.0.0"
        }
      ],
      "codeRepository": "https://github.com/codemeta/codemetar",
      "affiliation": "https://ropensci.org",
      "keywords": ["metadata", "codemeta", "ropensci", "citation", "credit"],
      "relatedLink": "https://codemeta.github.io/codemetar",
      "contIntegration": "https://travis-ci.org/codemeta/codemetar",
      "developmentStatus": "active",
      "releaseNotes": "https://github.com/codemeta/codemetar/blob/master/NEWS.md",
      "readme": "https://github.com/codemeta/codemetar/blob/master/README.md",
      "fileSize": "335.535KB"
    }

Modifying or enriching CodeMeta metadata
----------------------------------------

The best way to ensure `codemeta.json` is as complete as possible is to begin by making full use of the fields that can be set in an R package DESCRIPTION file, such as `BugReports` and `URL`. Using the `Authors@R` notation allows a much richer specification of author roles, correct parsing of given vs family names, and email addresses.

In the current implementation, developers may specify an ORCID url for an author in the optional `comment` field of `Authors@R`, e.g.

    Authors@R: person("Carl", "Boettiger", role=c("aut", "cre", "cph"), email="cboettig@gmail.com", comment="http://orcid.org/0000-0002-1642-628X")

which will allow `codemetar` to associate an identifier with the person. This is clearly something of a hack since R's `person` object lacks an explicit notion of `id`, and may be frowned upon.

### Using the DESCRIPTION file

The DESCRIPTION file is the natural place to specify any metadata for an R package. The `codemetar` package can detect certain additional terms in the [CodeMeta context](https://codemeta.github.io/terms). Almost any additional codemeta field (see `codemetar:::additional_codemeta_terms` for a list) and can be added to and read from the DESCRIPTION into a `codemeta.json` file. Where applicable, these will override values otherwise guessed from the source repository. Use comma-separated lists to separate multiple values to a property, e.g. keywords.

See the DESCRIPTION file of the `codemetar` package for an example.

Going further
-------------

Check out all the [codemetar vignettes](https://codemeta.github.io/codemetar/articles/index.html) for tutorials on other cool stuff you can do with codemeta and json-ld.
