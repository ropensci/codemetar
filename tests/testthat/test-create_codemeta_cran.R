testthat::context("create_codemeta_cran.R")

testthat::test_that("Non-existant versions fails", {
  skip_on_cran()
  skip_if_offline()
  testthat::expect_error(
    suppressMessages(create_codemeta_cran("EML", "1.0.5"))
  )
})

testthat::test_that("Valid version returns codemeta list", {
  skip_on_cran()
  skip_if_offline()
  cm <- suppressMessages(
    create_codemeta_cran("EML", "1.0.3")
  )
  testthat::expect_equal(class(cm), "list")
})

testthat::test_that("Unspecified version defaults to newest", {
  skip_on_cran()
  skip_if_offline()
  cm <- suppressMessages(
    create_codemeta_cran("EML")
  )
  testthat::expect_equal(class(cm), "list")
})


