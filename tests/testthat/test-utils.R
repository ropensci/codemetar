testthat::context("utils.R")

testthat::test_that("get_root_path is covered", {

  x <- get_root_path("jsonld")
  testthat::expect_true(file.exists(x))
  x <- get_root_path("not_a_package")
  testthat::expect_equal(x, "not_a_package")

  ## test

})

testthat::test_that("example_file works", {

  expect_match(example_file(), "/examples")
  expect_match(example_file("abc"), "^$")
  expect_true(file.exists(example_file("codemeta.json")))

})
