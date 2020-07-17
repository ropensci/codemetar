testthat::context("write_codemeta")

testthat::test_that("we can write a codemeta document given a package name", {
  skip_on_cran()
  skip_if_offline()
  path <- tempfile(pattern = "codemetatest", fileext = ".json")
  write_codemeta("codemetar", path = path, verbose = FALSE)
  testthat::expect_true(file.exists(path))
  unlink(path)

})


testthat::test_that("We can read an existing codemeta.json file", {
  skip_on_cran()
  skip_if_offline()
  path <- tempfile(pattern = "codemetatest", fileext = ".json")
  write_codemeta("codemetar", path = path, verbose = FALSE)
  testthat::expect_true(file.exists(path))
  write_codemeta("codemetar", path = path, verbose = FALSE)
  testthat::expect_true(file.exists(path))
  unlink(path)

})

testthat::test_that("We can use either a path or pkg name in writing", {
  skip_on_cran()
  skip_if_offline()

  write_codemeta(path.package("codemetar"), verbose = FALSE)
  testthat::expect_true(file.exists("codemeta.json"))
  unlink("codemeta.json")

  write_codemeta("codemetar", verbose = FALSE)
  testthat::expect_true(file.exists("codemeta.json"))
  unlink("codemeta.json")

})

testthat::test_that("We can deduce relatedLink from installed pkg", {
  skip_on_cran()
  skip_if_offline()

  xml2_cm <- create_codemeta(find.package("xml2"), verbose = FALSE)
  testthat::expect_true("https://xml2.r-lib.org/" %in%
                          xml2_cm$relatedLink)

})

## Test that we can write codemeta from a temp working dir (e.g. non-root dir)
testthat::test_that("we can write codemeta given a codemeta object", {
  skip_on_cran()
  skip_if_offline()
  codemeta <- new_codemeta()
  expect_is(create_codemeta("codemetar", codemeta, verbose = FALSE), "list")
})
