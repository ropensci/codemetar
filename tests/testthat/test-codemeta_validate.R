testthat::context("validate")

testthat::test_that("we can validate this file", {
  skip_on_cran()
  skip_if_offline()
  path <- tempfile(pattern = "codemetatest", fileext = ".json")
  write_codemeta("codemetar", path)
  testthat::expect_true(codemeta_validate(path))
  unlink(path)

})


testthat::test_that("we can create & validate codemeta for usethis package", {
  skip_on_cran()
  skip_if_offline()
  write_codemeta("usethis", path)
  testthat::expect_true(codemeta_validate(path))
  unlink(path)

})
