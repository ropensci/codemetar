
test_that("We can deduce relatedLink from installed pkg", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  xml2_cm <- create_codemeta(find.package("xml2"), verbose = FALSE)
  testthat::expect_true("https://xml2.r-lib.org/" %in%
                          xml2_cm$relatedLink)

})

