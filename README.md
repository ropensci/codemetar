
[![Travis-CI Build Status](https://travis-ci.org/codemeta/codemetar.svg?branch=master)](https://travis-ci.org/codemeta/codemetar) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/codemeta/codemetar?branch=master&svg=true)](https://ci.appveyor.com/project/codemeta/codemetar) [![Coverage Status](https://img.shields.io/codecov/c/github/codemeta/codemetar/master.svg)](https://codecov.io/github/codemeta/codemetar?branch=master) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/codemetar)](https://cran.r-project.org/package=codemetar)

<!-- README.md is generated from README.Rmd. Please edit that file -->
codemetar
=========

The goal of codemetar is to generate the JSON-LD file, `codemeta.json` containing software metadata describing an R package

Installation
------------

You can install codemetar from github with:

``` r
# install.packages("devtools")
devtools::install_github("codemeta/codemetar")
```

Example
-------

This is a basic example which shows you how to generate a `codemeta.json` for your R package:

``` r
codemetar::write_codemeta("testthat")
```

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
