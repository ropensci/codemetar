testthat::test_that("we can create a codemeta document given a package name", {
  skip_on_cran()
  skip_if_offline()
  testthat::expect_silent(
    create_codemeta("utils", path = path, verbose = FALSE)
  )

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
