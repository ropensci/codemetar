testthat::context("utils.R")

testthat::test_that("get_root_path is covered", {

  x <- get_root_path("jsonld")
  testthat::expect_true(file.exists(x))
  x <- get_root_path("not_a_package")
  testthat::expect_equal(x, "not_a_package")

  ## test

})
