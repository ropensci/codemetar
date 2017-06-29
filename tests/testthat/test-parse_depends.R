testthat::context("parse_depends.R")

testthat::test_that("Test the various cases for dependencies", {

  a <- parse_depends(NULL)
  expect_length(a, 0)
  a <- parse_depends(deps = "a4")  # BIOC provider
  expect_gt(length(a[[1]]), 1)
  a <- parse_depends(deps = "httr") # CRAN provider
  expect_gt(length(a[[1]]), 1)
  a <- parse_depends(deps = "R")
  expect_equal(a[[1]]$name, "R")
  a <- parse_depends(deps = "not-a-package")

})

testthat::test_that("Test the various cases for ids (NOT used currently)", {

  a <- guess_dep_id(NULL)
  expect_length(a, 0)
  a <- guess_dep_id(deps = "a4")  # BIOC provider
  expect_gt(length(a[[1]]), 1)
  a <- guess_dep_id(deps = "httr") # CRAN provider
  expect_gt(length(a[[1]]), 1)
  a <- guess_dep_id(deps = "R")
  expect_equal(a[[1]]$name, "R")
  a <- guess_dep_id(deps = "not-a-package")

})
