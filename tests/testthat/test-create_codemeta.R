
test_that("We can deduce relatedLink from installed pkg", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  xml2_cm <- create_codemeta(find.package("xml2"), verbose = FALSE)
  # Test that relatedLink exists and contains at least one URL
  testthat::expect_true(length(xml2_cm$relatedLink) > 0)
  # Test that at least one relatedLink contains xml2 in the URL
  testthat::expect_true(any(grepl("xml2", xml2_cm$relatedLink, ignore.case = TRUE)))

})

