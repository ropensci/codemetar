testthat::context("parse citation")


testthat::test_that("We can parse bibentry citations into schema.org",{

  bib <- citation("knitr") # Manual, Book, Incollection
  schema <- lapply(bib, parse_citation)

  f <- system.file("examples/CITATION_ex", package="codemetar")
  bib <- readCitationFile(f)
  schema <- lapply(bib, parse_citation)
  ## Convert to JSON and check expansion / compaction

})
