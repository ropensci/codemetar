testthat::context("crosswalk.R")

testthat::test_that("we can call crosswalk", {

  skip_on_os("windows")
  f <- read_json(system.file("examples/github_format.json",
                             package = "codemetar"))
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

  ## Test add and drop context
  b <- drop_context(a)
  add_context(b, getOption("codemeta_context", "http://purl.org/codemeta/2.0"))


  ## Test transforms between columns
  f <- read_json(system.file("examples/github_format.json",
                             package = "codemetar"))
  crosswalk(f, "GitHub", "Zenodo")


  crosswalk_table(from = "GitHub", to = c("Zenodo", "Figshare"))

})
