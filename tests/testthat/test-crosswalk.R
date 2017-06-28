testthat::context("crosswalk.R")

testthat::test_that("we can call crosswalk", {

  a <- crosswalk("Zenodo")
  string <- jsonlite::toJSON(a, auto_unbox = TRUE, pretty = TRUE)
  testthat::expect_is(string, "json")

  string <- crosswalk("NodeJS", to_json = TRUE)
  testthat::expect_is(string, "json")

  string <- crosswalk("codemeta-V1", to_json = TRUE)
  testthat::expect_is(string, "json")


})
