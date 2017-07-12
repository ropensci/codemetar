testthat::context("crosswalk.R")

testthat::test_that("we can call crosswalk", {


  f <- read_json(system.file("examples/github_format.json", package = "codemetar"))
  a <- crosswalk(f, "GitHub")
  testthat::expect_is(a, "json")
  writeLines(a, "test.json")
  v <- codemeta_validate("test.json")
  testthat::expect_true(v)
  unlink("test.json")

  f <- read_json(system.file("examples/package.json", package = "codemetar"))
  a <- crosswalk(f, "NodeJS")
  testthat::expect_is(a, "json")
  writeLines(a, "nodejs.json")
  v <- codemeta_validate("nodejs.json")
  testthat::expect_true(v)
  unlink("nodejs.json")

  b <- drop_context(a)
  add_context(b, "https://doi.org/doi:10.5063/schema/codemeta-2.0")

})
