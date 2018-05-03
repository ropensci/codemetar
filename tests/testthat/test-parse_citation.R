testthat::context("parse citation")


testthat::test_that("We can parse bibentry citations into schema.org",{

  bib <- citation("knitr") # Manual, Book, Incollection
  schema <- lapply(bib, parse_citation)

  f <- system.file("examples/CITATION_ex", package="codemetar")
  bib <- readCitationFile(f)
  schema <- lapply(bib, parse_citation)
  ## Convert to JSON and check expansion / compaction

})

testthat::test_that("We can parse citations", {

  ## installed package
  a <- guess_citation("knitr")

  ## not a package returns null
  a <- guess_citation("not-a-package")
  testthat::expect_null(a)


})

testthat::test_that("We can use encoding", {
  f <- system.file("examples/CITATION_osmdata", package = "codemetar")
  bib <- utils::readCitationFile(f,
                                 meta = list(Encoding = "UTF-8"))
  testthat::expect_silent(parse_citation(bib))
})
