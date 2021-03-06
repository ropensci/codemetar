testthat::test_that("We can parse bibentry citations into schema.org",{

  bib <- citation("knitr") # Manual, Book, Incollection
  bibl <- lapply(bib, parse_citation)
  expect_type(bibl, "list")

  f <- system.file("examples/CITATION_ex", package="codemetar")
  bib <- readCitationFile(f)
  schema <- lapply(bib, parse_citation)
  expect_type(schema, "list")

})

testthat::test_that("We can parse citations", {
  ## installed package
  a <- guess_citation("knitr")
  expect_type(a, "list")

  ## not a package returns null
  a <- guess_citation("not-a-package")
  testthat::expect_null(a)


})

testthat::test_that("We can use encoding", {
  f <- system.file("examples/CITATION_osmdata", package = "codemetar")
  bib <- utils::readCitationFile(f,
                                 meta = list(Encoding = "UTF-8"))
  expect_type(parse_citation(bib), "list")
})

testthat::test_that("Test citation with encoding and citation line", {
  f <- system.file("examples/CITATION_ex2", package = "codemetar")
  testthat::expect_s3_class(read_citation_with_encoding(f), "citation")
})
