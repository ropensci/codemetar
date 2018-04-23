testthat::context("codemeta_description.R")

testthat::test_that("We can use a preset id", {
  f <- system.file("DESCRIPTION", package = "codemetar")
  codemeta_description(f, id = "https://doi.org/10.looks.like/doi")
})


testthat::test_that("several URLs", {
  f <- system.file("examples/DESCRIPTION_two_URLs", package = "codemetar")
  cm <- codemeta_description(f)
  expect_equal(cm$codeRepository, "https://github.com/ropensci/essurvey")
  expect_true("https://ropensci.github.io/essurvey/" %in%
                cm$relatedLink)
})

testthat::test_that("We can parse additional terms", {
  f <- system.file("examples/DESCRIPTION_ex1.dcf", package = "codemetar")
  cm <- codemeta_description(f)
  testthat::expect_true(length(cm$keywords), 6)
  testthat::expect_equal(cm$isPartOf, "https://ropensci.org")
  })

testthat::test_that("We can parse plain Authors: & Maintainers: entries", {
  f <- system.file("examples/DESCRIPTION_ex1.dcf", package = "codemetar")
  authors <- codemeta_description(f)
  expect_true(authors$maintainer$familyName == "Boettiger")
  expect_equal(length(authors$author), 0)
  f <- system.file("examples/example.dcf", package = "codemetar")
  authors <- codemeta_description(f)
  expect_true(authors$maintainer$familyName == "Developer")
  expect_equal(length(authors$author), 2)

  f <- system.file("examples/DESCRIPTION_jsonlite", package = "codemetar")
  authors <- codemeta_description(f)
  expect_true(authors$maintainer$familyName == "Ooms")
  expect_equal(length(authors$author), 2)


})

