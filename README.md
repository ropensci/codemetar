
<!-- README.md is generated from README.Rmd. Please edit that file -->

# codemetar

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![R build
status](https://github.com/ropensci/codemetar/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci/codemetar/actions)
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

## Why create a codemeta.json for your package?

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

`codemetar` can take the path to the source package root to glean as
much information as possible.

``` r
codemetar::write_codemeta(find.package("codemetar"))
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting Bioconductor metadata
✓ Got Bioconductor metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting Bioconductor metadata
✓ Got Bioconductor metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting Bioconductor metadata
✓ Got Bioconductor metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting Bioconductor metadata
✓ Got Bioconductor metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting sysreqs URL from sysreqs API
✓ Got sysreqs URL from sysreqs API!
… Asking README URL from GitHub API
x Did not get README URL.
… Asking README URL from GitHub API
x Did not get README URL.
… Getting repo topics from GitHub API
x Did not get repo topics.
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting Bioconductor metadata
✓ Got Bioconductor metadata!
```

<details closed>

<summary> <span title="Click to Expand"> codemetar’s codemeta.json
</span> </summary>

``` json

{
  "@context": ["https://doi.org/10.5063/schema/codemeta-2.0", "http://schema.org"],
  "@type": "SoftwareSourceCode",
  "identifier": "codemetar",
  "description": "The 'Codemeta' Project defines a 'JSON-LD' format\n    for describing software metadata, as detailed at\n    <https://codemeta.github.io>. This package provides utilities to\n    generate, parse, and modify 'codemeta.json' files automatically for R\n    packages, as well as tools and examples for working with\n    'codemeta.json' 'JSON-LD' more generally.",
  "name": "codemetar: Generate 'CodeMeta' Metadata for R Packages",
  "codeRepository": "https://github.com/ropensci/codemetar",
  "relatedLink": "https://docs.ropensci.org/codemetar",
  "issueTracker": "https://github.com/ropensci/codemetar/issues",
  "license": "https://spdx.org/licenses/GPL-3.0",
  "version": "0.1.8.9000",
  "programmingLanguage": {
    "@type": "ComputerLanguage",
    "name": "R",
    "url": "https://r-project.org"
  },
  "runtimePlatform": "R version 4.0.0 (2020-04-24)",
  "author": [
    {
      "@type": "Person",
      "givenName": "Carl",
      "familyName": "Boettiger",
      "email": "cboettig@gmail.com",
      "@id": "https://orcid.org/0000-0002-1642-628X"
    },
    {
      "@type": "Person",
      "givenName": "Maëlle",
      "familyName": "Salmon",
      "@id": "https://orcid.org/0000-0002-2815-0399"
    }
  ],
  "contributor": [
    {
      "@type": "Person",
      "givenName": "Anna",
      "familyName": "Krystalli",
      "@id": "https://orcid.org/0000-0002-2378-4915"
    },
    {
      "@type": "Person",
      "givenName": "Maëlle",
      "familyName": "Salmon",
      "@id": "https://orcid.org/0000-0002-2815-0399"
    },
    {
      "@type": "Person",
      "givenName": "Katrin",
      "familyName": "Leinweber",
      "@id": "https://orcid.org/0000-0001-5135-5758"
    },
    {
      "@type": "Person",
      "givenName": "Noam",
      "familyName": "Ross",
      "@id": "https://orcid.org/0000-0002-2136-0000"
    },
    {
      "@type": "Person",
      "givenName": "Arfon",
      "familyName": "Smith"
    },
    {
      "@type": "Person",
      "givenName": "Jeroen",
      "familyName": "Ooms",
      "@id": "https://orcid.org/0000-0002-4035-0289"
    },
    {
      "@type": "Person",
      "givenName": "Sebastian",
      "familyName": "Meyer",
      "@id": "https://orcid.org/0000-0002-1791-9449"
    },
    {
      "@type": "Person",
      "givenName": "Michael",
      "familyName": "Rustler",
      "@id": "https://orcid.org/0000-0003-0647-7726"
    },
    {
      "@type": "Person",
      "givenName": "Hauke",
      "familyName": "Sonnenberg",
      "@id": "https://orcid.org/0000-0001-9134-2871"
    },
    {
      "@type": "Person",
      "givenName": "Sebastian",
      "familyName": "Kreutzer",
      "@id": "https://orcid.org/0000-0002-0734-2199"
    }
  ],
  "copyrightHolder": [
    {
      "@type": "Person",
      "givenName": "Carl",
      "familyName": "Boettiger",
      "email": "cboettig@gmail.com",
      "@id": "https://orcid.org/0000-0002-1642-628X"
    }
  ],
  "funder": [
    {
      "@type": "Organization",
      "name": "rOpenSci"
    }
  ],
  "maintainer": [
    {
      "@type": "Person",
      "givenName": "Carl",
      "familyName": "Boettiger",
      "email": "cboettig@gmail.com",
      "@id": "https://orcid.org/0000-0002-1642-628X"
    }
  ],
  "softwareSuggestions": [
    {
      "@type": "SoftwareApplication",
      "identifier": "covr",
      "name": "covr",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=covr"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "details",
      "name": "details",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=details"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "dplyr",
      "name": "dplyr",
      "version": ">= 0.7.0",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=dplyr"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "jsonld",
      "name": "jsonld",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=jsonld"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "jsonvalidate",
      "name": "jsonvalidate",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=jsonvalidate"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "knitr",
      "name": "knitr",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=knitr"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "printr",
      "name": "printr",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=printr"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "rmarkdown",
      "name": "rmarkdown",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=rmarkdown"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "testthat",
      "name": "testthat",
      "version": ">= 2.1.0",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=testthat"
    }
  ],
  "softwareRequirements": [
    {
      "@type": "SoftwareApplication",
      "identifier": "R",
      "name": "R",
      "version": ">= 3.2.0"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "commonmark",
      "name": "commonmark",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=commonmark"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "crul",
      "name": "crul",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=crul"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "desc",
      "name": "desc",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=desc"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "gert",
      "name": "gert",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=gert"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "gh",
      "name": "gh",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=gh"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "jsonlite",
      "name": "jsonlite",
      "version": ">= 1.6",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=jsonlite"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "magrittr",
      "name": "magrittr",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=magrittr"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "memoise",
      "name": "memoise",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=memoise"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "methods",
      "name": "methods"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "pingr",
      "name": "pingr",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=pingr"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "pkgbuild",
      "name": "pkgbuild",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=pkgbuild"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "purrr",
      "name": "purrr",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=purrr"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "remotes",
      "name": "remotes",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=remotes"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "sessioninfo",
      "name": "sessioninfo",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=sessioninfo"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "stats",
      "name": "stats"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "urltools",
      "name": "urltools",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=urltools"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "xml2",
      "name": "xml2",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=xml2"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "cli",
      "name": "cli",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=cli"
    }
  ],
  "isPartOf": "https://ropensci.org",
  "keywords": ["metadata", "codemeta", "ropensci", "citation", "credit", "linked-data"],
  "fileSize": "2429.096KB"
}
```

</details>

<br>

By default most often from within your package folder you’ll simply run
`codemetar::write_codemeta()`.

You could also create a basic `codemeta.json` for an installed R
package, e.g. for `testthat`. That will use information from
`DESCRIPTION` only.

``` r
codemetar::write_codemeta("testthat", path = "example-codemeta.json")
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting Bioconductor metadata
✓ Got Bioconductor metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting Bioconductor metadata
✓ Got Bioconductor metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
… Getting sysreqs URL from sysreqs API
✓ Got sysreqs URL from sysreqs API!
… Asking README URL from GitHub API
x Did not get README URL.
… Asking README URL from GitHub API
x Did not get README URL.
… Getting repo topics from GitHub API
x Did not get repo topics.
… Getting CRAN metadata from RStudio CRAN mirror
✓ Got CRAN metadata!
```

<details closed>

<summary> <span title="Click to Expand"> testthat’s basic codemeta.json
</span> </summary>

``` json

{
  "@context": ["https://doi.org/10.5063/schema/codemeta-2.0", "http://schema.org"],
  "@type": "SoftwareSourceCode",
  "identifier": "testthat",
  "description": "Software testing is important, but, in part because it is \n    frustrating and boring, many of us avoid it. 'testthat' is a testing framework \n    for R that is easy to learn and use, and integrates with your existing 'workflow'.",
  "name": "testthat: Unit Testing for R",
  "codeRepository": "https://github.com/r-lib/testthat",
  "relatedLink": ["http://testthat.r-lib.org", "https://CRAN.R-project.org/package=testthat"],
  "issueTracker": "https://github.com/r-lib/testthat/issues",
  "license": "https://spdx.org/licenses/MIT",
  "version": "2.3.2",
  "programmingLanguage": {
    "@type": "ComputerLanguage",
    "name": "R",
    "url": "https://r-project.org"
  },
  "runtimePlatform": "R version 4.0.0 (2020-04-24)",
  "provider": {
    "@id": "https://cran.r-project.org",
    "@type": "Organization",
    "name": "Comprehensive R Archive Network (CRAN)",
    "url": "https://cran.r-project.org"
  },
  "author": [
    {
      "@type": "Person",
      "givenName": "Hadley",
      "familyName": "Wickham",
      "email": "hadley@rstudio.com"
    }
  ],
  "contributor": [
    {
      "@type": "Organization",
      "name": "R Core team"
    }
  ],
  "copyrightHolder": [
    {
      "@type": "Organization",
      "name": "RStudio"
    }
  ],
  "funder": [
    {
      "@type": "Organization",
      "name": "RStudio"
    }
  ],
  "maintainer": [
    {
      "@type": "Person",
      "givenName": "Hadley",
      "familyName": "Wickham",
      "email": "hadley@rstudio.com"
    }
  ],
  "softwareSuggestions": [
    {
      "@type": "SoftwareApplication",
      "identifier": "covr",
      "name": "covr",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=covr"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "curl",
      "name": "curl",
      "version": ">= 0.9.5",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=curl"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "devtools",
      "name": "devtools",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=devtools"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "knitr",
      "name": "knitr",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=knitr"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "rmarkdown",
      "name": "rmarkdown",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=rmarkdown"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "usethis",
      "name": "usethis",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=usethis"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "vctrs",
      "name": "vctrs",
      "version": ">= 0.1.0",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=vctrs"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "xml2",
      "name": "xml2",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=xml2"
    }
  ],
  "softwareRequirements": [
    {
      "@type": "SoftwareApplication",
      "identifier": "R",
      "name": "R",
      "version": ">= 3.1"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "cli",
      "name": "cli",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=cli"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "crayon",
      "name": "crayon",
      "version": ">= 1.3.4",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=crayon"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "digest",
      "name": "digest",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=digest"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "ellipsis",
      "name": "ellipsis",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=ellipsis"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "evaluate",
      "name": "evaluate",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=evaluate"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "magrittr",
      "name": "magrittr",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=magrittr"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "methods",
      "name": "methods"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "pkgload",
      "name": "pkgload",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=pkgload"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "praise",
      "name": "praise",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=praise"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "R6",
      "name": "R6",
      "version": ">= 2.2.0",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=R6"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "rlang",
      "name": "rlang",
      "version": ">= 0.4.1",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=rlang"
    },
    {
      "@type": "SoftwareApplication",
      "identifier": "withr",
      "name": "withr",
      "version": ">= 2.0.0",
      "provider": {
        "@id": "https://cran.r-project.org",
        "@type": "Organization",
        "name": "Comprehensive R Archive Network (CRAN)",
        "url": "https://cran.r-project.org"
      },
      "sameAs": "https://CRAN.R-project.org/package=withr"
    }
  ],
  "fileSize": "9546.886KB",
  "citation": [
    {
      "@type": "ScholarlyArticle",
      "datePublished": "2011",
      "author": [
        {
          "@type": "Person",
          "givenName": "Hadley",
          "familyName": "Wickham"
        }
      ],
      "name": "testthat: Get Started with Testing",
      "url": "https://journal.r-project.org/archive/2011-1/RJournal_2011-1_Wickham.pdf",
      "pagination": "5--10",
      "isPartOf": {
        "@type": "PublicationIssue",
        "datePublished": "2011",
        "isPartOf": {
          "@type": ["PublicationVolume", "Periodical"],
          "volumeNumber": "3",
          "name": "The R Journal"
        }
      }
    }
  ]
}
```

</details>

<br>

## Keep codemeta.json up-to-date

**How to keep codemeta.json up-to-date?** In particular, how to keep it
up to date with `DESCRIPTION`? `codemetar` itself no longer supports
automatic sync, but there are quite a few methods available out there.
Choose one that fits well into your workflow\!

  - You could rely on `devtools::release()` since it will ask you
    whether you updated codemeta.json when such a file exists.

  - You could use a git pre-commit hook that prevents a commit from
    being done if DESCRIPTION is newer than codemeta.json.
    
      - You can use the [precommit
        package](https://github.com/lorenzwalthert/precommit) in which
        there’s a “codemeta-description-updated” hook.
    
      - If that’s your only pre-commit hook (i.e. you don’t have one
        created by e.g. `usethis::use_readme_rmd()`), then you can
        create it using

<!-- end list -->

``` r
script = readLines(system.file("templates", "description-codemetajson-pre-commit.sh", package = "codemetar"))
usethis::use_git_hook("pre-commit",
                     script = script)
```

  - You could use GitHub actions. Refer to GitHub actions docs
    <https://github.com/features/actions>, and to the example workflow
    provided in this package (type `system.file("templates",
    "codemeta-github-actions.yml", package = "codemetar")`). You can use
    the `cm-skip` keyword in your commit message if you don’t want this
    to run on a specific commit. The example workflow provided is setup
    to only run when a push is made to the master branch. This setup is
    designed for if you’re using a [git
    flow](https://nvie.com/posts/a-successful-git-branching-model/#the-main-branches)
    setup where the master branch is only committed and pushed to via
    pull requests. After each PR merge (and the completion of this
    GitHub action), your master branch will always be up to date and so
    long as you don’t make manual changes to the codemeta.json file, you
    won’t have merge conflicts.

Alternatively, you can have GitHub actions route run `codemetar` on each
commit. If you do this you should try to remember to run `git pull`
before making any new changes on your local project. However, if you
forgot to pull and already committed new changes, fret not, you can use
([`git pull
--rebase`](https://stackoverflow.com/questions/18930527/difference-between-git-pull-and-git-pull-rebase/38139843#38139843))
to rewind you local changes on top of the current upstream `HEAD`.

<details closed>

<summary> <span title="Click to Expand"> click here to see the workflow
</span> </summary>

``` yaml

on:
  push:
    branches: master
    paths:
      - DESCRIPTION
      - .github/workflows/main.yml

name: Render codemeta
jobs:
  render:
    name: Render codemeta
    runs-on: macOS-latest
    if: "!contains(github.event.head_commit.message, 'cm-skip')"
    steps:
      - uses: actions/checkout@v1
      - uses: r-lib/actions/setup-r@v1
      - name: Install codemetar
        run: Rscript -e 'install.packages("codemetar")'
      - name: Render codemeta
        run: Rscript -e 'codemetar::write_codemeta()'
      - name: Commit results
        run: |
          git commit codemeta.json -m 'Re-build codemeta.json' || echo "No changes to commit"
          git push https://${{github.actor}}:${{secrets.GITHUB_TOKEN}}@github.com/${{github.repository}}.git HEAD:${{ github.ref }} || echo "No changes to commit"
```

</details>

<br>

## How to improve your package’s codemeta.json?

The best way to ensure `codemeta.json` is as complete as possible is to
set metadata in all the usual places, and then if needed add more
metadata.

To ensure you have metadata in the usual places, you can run
`codemetar::give_opinions()`.

### Usual terms in DESCRIPTION

  - Fill `BugReports` and `URL`.

  - Using the `Authors@R` notation allows a much richer specification of
    author roles, correct parsing of given vs family names, and email
    addresses.

In the current implementation, developers may specify an ORCID url for
an author in the optional `comment` field of `Authors@R`, e.g.

    Authors@R: c(person(given = "Carl",
                 family = "Boettiger",
                 role = c("aut", "cre", "cph"),
                 email = "cboettig@gmail.com",
                 comment = c(ORCID = "0000-0002-1642-628X")))

which will allow `codemetar` to associate an identifier with the person.
This is clearly something of a hack since R’s `person` object lacks an
explicit notion of `id`, and may be frowned upon.

### Usual terms in the README

In the README, you can use badges for continuous integration, repo
development status (repostatus.org or lifecycle.org), provider
([e.g. for CRAN](https://docs.r-hub.io/#badges)).

### GitHub repo topics

If your package source is hosted on GitHub and there’s a way for
codemetar to determine that (URL in DESCRIPTION, or git remote URL)
codemetar will use [GitHub repo
topics](https://help.github.com/en/github/administering-a-repository/classifying-your-repository-with-topics)
as keywords in codemeta.json. If you also set keywords in DESCRIPTION
(see next section), codemetar will merge the two lists.

### Set even more terms via DESCRIPTION

In general, setting metadata via the places stated earlier is the best
solution because that metadata is used by other tools (e.g. the URLs in
DESCRIPTION can help the package users, not only codemetar).

The DESCRIPTION file is the natural place to specify any metadata for an
R package. The `codemetar` package can detect certain additional terms
in the [CodeMeta context](https://codemeta.github.io/terms). Almost any
additional codemeta field can be added to and read from the DESCRIPTION
into a `codemeta.json` file (see `codemetar:::additional_codemeta_terms`
for a list).

CRAN requires that you prefix any additional such terms to indicate the
use of `schema.org` explicitly, e.g. `keywords` would be specified in a
DESCRIPTION file as:

    X-schema.org-keywords: metadata, codemeta, ropensci, citation, credit, linked-data

Where applicable, these will override values otherwise guessed from the
source repository. Use comma-separated lists to separate multiple values
to a property, e.g. keywords.

See the
[DESCRIPTION](https://github.com/codemeta/codemetar/blob/master/DESCRIPTION)
file of the `codemetar` package for an example.

## Installation and usage requirements

You can install the latest version from CRAN using:

``` r
install.packages("codemetar")
```

You can also install the development version of `codemetar` from GitHub
with:

``` r
# install.packages("remotes")
remotes::install_github("ropensci/codemetar", ref = "dev")
```

For optimal results you need a good internet connection.

The package queries

  - `utils::available.packages()` for CRAN and Bioconductor packages;

  - GitHub API via the [`gh` package](https://github.com/r-lib/gh), if
    it finds a GitHub repo URL in DESCRIPTION or as git remote. GitHub
    API is queried to find the [preferred
    README](https://developer.github.com/v3/repos/contents/#get-the-readme),
    and the [repo
    topics](https://developer.github.com/v3/repos/#list-all-topics-for-a-repository).
    If you use codemetar for many packages having a
    [GITHUB\_PAT](https://github.com/r-lib/gh#environment-variables) is
    better;

  - [R-hub sysreqs API](https://docs.r-hub.io/#sysreqs) to parse
    SystemRequirements.

If your machine is offline, a more minimal codemeta.json will be
created. If your internet connection is poor or there are firewalls, the
codemeta creation might indefinitely hang.

## Going further

Check out all the [codemetar
man](https://docs.ropensci.org/codemetar/articles/index.html) for
tutorials on other cool stuff you can do with codemeta and json-ld.

A new feature is the creation of a minimal schemaorg.json for insertion
on your website’s webpage for Search Engine Optimization, when the
`write_minimeta` argument of `write_codemeta()` is `TRUE`.

You could e.g. use the code below in a chunk in README.Rmd with
`results="asis"`.

``` r
glue::glue('<script type="application/ld+json">
      {glue::glue_collapse(readLines("schemaorg.json"), sep = "\n")}
    </script>')
```

Refer to [Google
documentation](https://developers.google.com/search/reference/overview)
for more guidance.

<script type="application/ld+json">
      {
  "@context": "https://schema.org",
  "type": "SoftwareSourceCode",
  "author": [
    {
      "id": "https://orcid.org/0000-0002-2815-0399"
    },
    {
      "id": "https://orcid.org/0000-0002-1642-628X"
    }
  ],
  "codeRepository": "https://github.com/ropensci/codemetar",
  "contributor": [
    {
      "id": "https://orcid.org/0000-0002-2378-4915",
      "type": "Person",
      "familyName": "Krystalli",
      "givenName": "Anna"
    },
    {
      "id": "https://orcid.org/0000-0002-2815-0399",
      "type": "Person",
      "familyName": "Salmon",
      "givenName": "Maëlle"
    },
    {
      "id": "https://orcid.org/0000-0001-5135-5758",
      "type": "Person",
      "familyName": "Leinweber",
      "givenName": "Katrin"
    },
    {
      "id": "https://orcid.org/0000-0002-2136-0000",
      "type": "Person",
      "familyName": "Ross",
      "givenName": "Noam"
    },
    {
      "type": "Person",
      "familyName": "Smith",
      "givenName": "Arfon"
    },
    {
      "id": "https://orcid.org/0000-0002-4035-0289",
      "type": "Person",
      "familyName": "Ooms",
      "givenName": "Jeroen"
    },
    {
      "id": "https://orcid.org/0000-0002-1791-9449",
      "type": "Person",
      "familyName": "Meyer",
      "givenName": "Sebastian"
    },
    {
      "id": "https://orcid.org/0000-0003-0647-7726",
      "type": "Person",
      "familyName": "Rustler",
      "givenName": "Michael"
    },
    {
      "id": "https://orcid.org/0000-0001-9134-2871",
      "type": "Person",
      "familyName": "Sonnenberg",
      "givenName": "Hauke"
    },
    {
      "id": "https://orcid.org/0000-0002-0734-2199",
      "type": "Person",
      "familyName": "Kreutzer",
      "givenName": "Sebastian"
    }
  ],
  "copyrightHolder": {
    "id": "https://orcid.org/0000-0002-1642-628X",
    "type": "Person",
    "email": "cboettig@gmail.com",
    "familyName": "Boettiger",
    "givenName": "Carl"
  },
  "description": "The 'Codemeta' Project defines a 'JSON-LD' format\n    for describing software metadata, as detailed at\n    <https://codemeta.github.io>. This package provides utilities to\n    generate, parse, and modify 'codemeta.json' files automatically for R\n    packages, as well as tools and examples for working with\n    'codemeta.json' 'JSON-LD' more generally.",
  "funder": {
    "type": "Organization",
    "name": "rOpenSci"
  },
  "license": "https://spdx.org/licenses/GPL-3.0",
  "name": "codemetar: Generate 'CodeMeta' Metadata for R Packages",
  "programmingLanguage": {
    "type": "ComputerLanguage",
    "name": "R",
    "url": "https://r-project.org"
  },
  "provider": {
    "id": "https://cran.r-project.org",
    "type": "Organization",
    "name": "Comprehensive R Archive Network (CRAN)",
    "url": "https://cran.r-project.org"
  },
  "runtimePlatform": "R version 3.6.1 (2019-07-05)",
  "version": "0.1.8.9000"
}
    </script>

[![ropensci\_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
