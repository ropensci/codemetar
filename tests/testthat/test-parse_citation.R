testthat::context("parse citation")


testthat::test_that("We can parse bibentry citations into schema.org",{

  bib <- citation("knitr")
  lapply(bib, parse_citation)

  ## Convert to JSON and check expansion / compaction

})
