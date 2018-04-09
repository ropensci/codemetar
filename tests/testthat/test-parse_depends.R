testthat::context("parse_depends.R")

testthat::test_that("Test the various cases for dependencies", {

  testthat::expect_error(format_depend(NULL))
  a <- format_depend(package = "a4",
                     version = "*")  # BIOC provider
  testthat::expect_equal(a$provider$`@id`, "https://www.bioconductor.org")
  a <- format_depend(package = "httr",
                     version = "*") # CRAN provider
  testthat::expect_equal(a$provider$`@id`, "https://cran.r-project.org")
  a <- format_depend(package = "R",
                     version = ">= 3.0.0")
  testthat::expect_equal(a$name, "R")

})

testthat::test_that("Test the various cases for ids (NOT used currently)", {

  # a <- guess_dep_id(parse_depends("a4")[[1]])  # BIOC provider
  # a <- guess_dep_id(parse_depends("httr")[[1]]) # CRAN provider
  # a <- guess_dep_id(parse_depends("R")[[1]])
  # a <- guess_dep_id(parse_depends("not-a-package")[[1]])

})
