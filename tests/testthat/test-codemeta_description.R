testthat::context("codemeta_description.R")

testthat::test_that("We can use a preset id", {
  f <- system.file("DESCRIPTION", package = "codemetar")
  codemeta_description(f, id = "https://doi.org/10.looks.like/doi")
})



testthat::test_that("Works R-forge", {
  f <- system.file("examples/DESCRIPTION_two_URLs", package = "codemetar")
  cm <- codemeta_description(f)
  expect_equal(cm$codeRepository, "https://github.com/ropensci/essurvey")
})

testthat::test_that("We can parse plain Authors: & Maintainers: entries", {
  f <- system.file("examples/DESCRIPTION_ex1.dcf", package = "codemetar")
  codemeta_description(f)
})


testthat::test_that("Choose GitHub", {
  f <- system.file("examples/DESCRIPTION_ex1.dcf", package = "codemetar")
  expect_error(codemeta_description(f))
})
