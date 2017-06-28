testthat::context("spdx_license.R")

testthat::test_that("spdx_license", {
  a <- spdx_license("GPL (>= 2) | file LICENCE")
  testthat::expect_equal(a, "https://spdx.org/licenses/GPL-2.0")
  b <- spdx_license("not-a-license")
  testthat::expect_equal(b, "not-a-license")
})
