#' codemetar: generate codemeta metadata for R packages
#'
#' The 'CodeMeta' Project defines a JSON-LD format for describing software metadata,
#' as detailed at https://codemeta.github.io.
#' This package provides utilities to generate, parse, and modify codemeta.jsonld
#' files automatically for R packages, as well as tools and examples for working
#' with codemeta JSON-LD more generally.
#'
#' It has three main goals:
#'
#' \itemize{
#' \item Quickly generate a valid codemeta.json file from any valid R package
#'   To do so, we automatically extract as much metadata as possible using
#'   the DESCRIPTION file, as well as extracting metadata from other common
#'   best-practices such as the presence of Travis and other badges in README, etc.
#' \item Facilitate the addition of further metadata fields into a codemeta.json
#'   file, as well as general manipulation of codemeta files.
#' \item Support the ability to crosswalk between terms used in other metadata standards,
#'   as identified by the CodeMeta Project Community, see https://codemeta.github.io/crosswalk
#' }
#'
#' To learn more about codemetar, start with the vignettes:
#' `browseVignettes(package = "codemetar")`
#'
#' For more general information about the CodeMeta Project for defining software metadata,
#' see https://codemeta.github.io.  In particular, new users might want to start with
#' the User Guide (https://codemeta.github.io/user-guide/), while those looking to learn
#' more about JSON-LD and consuming existing codemeta files should see the
#' Developer Guide (https://codemeta.github.io/developer-guide/).
#'
"_PACKAGE"

## JSON-LD needs content negotiation
options("jsonld_use_accept" = TRUE)
