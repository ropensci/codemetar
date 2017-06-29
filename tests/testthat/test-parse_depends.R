testthat::context("parse_depends.R")

testthat::test_that("Test the various cases for dependencies", {

  a <- parse_depends(NULL)
  testthat::expect_length(a, 0)
  a <- parse_depends(deps = "a4")  # BIOC provider
  testthat::expect_gt(length(a[[1]]), 1)
  a <- parse_depends(deps = "httr") # CRAN provider
  testthat::expect_gt(length(a[[1]]), 1)
  a <- parse_depends(deps = "R")
  testthat::expect_equal(a[[1]]$name, "R")
  a <- parse_depends(deps = "not-a-package")

})

testthat::test_that("Test the various cases for ids (NOT used currently)", {

  a <- guess_dep_id(parse_depends("a4")[[1]])  # BIOC provider
  a <- guess_dep_id(parse_depends("httr")[[1]]) # CRAN provider
  a <- guess_dep_id(parse_depends("R")[[1]])
  a <- guess_dep_id(parse_depends("not-a-package")[[1]])

})
