testthat::context("validate")

testthat::test_that("we can validate this file", {
  write_codemeta("codemetar", "codemeta_test.json")
  testthat::expect_true(codemeta_validate("codemeta_test.json"))
  unlink("codemeta_test.json")

})


testthat::test_that("we can create & validate codemeta for testthat package", {
  skip_on_cran()
  write_codemeta("testthat")
  testthat::expect_true(codemeta_validate("codemeta.json"))
  unlink("codemeta.json")

})
