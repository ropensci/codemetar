testthat::context("validate")

testthat::test_that("we can validate this file", {
  skip_on_cran()
  skip_if_offline()
  write_codemeta("codemetar", "codemeta_test.json")
  testthat::expect_true(codemeta_validate("codemeta_test.json"))
  unlink("codemeta_test.json")

})


testthat::test_that("we can create & validate codemeta for usethis package", {
  skip_on_cran()
  skip_if_offline()
  write_codemeta("usethis")
  testthat::expect_true(codemeta_validate("codemeta.json"))
  unlink("codemeta.json")

})
