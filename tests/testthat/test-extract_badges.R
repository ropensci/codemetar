context("test-extract_badges.R")

test_that("we can parse md and html badges", {
  f <- system.file("examples/README_fakepackage.md", package="codemetar")
  badges <- extract_badges(f)
  testthat::expect_equal(nrow(badges), 5)


  f <- system.file("examples/README_fakepackage2.md", package="codemetar")
  badges <- extract_badges(f)
  testthat::expect_equal(nrow(badges), 11)

  f <- system.file("examples/README_fakepackage3.md", package="codemetar")
  badges <- extract_badges(f)
  testthat::expect_equal(nrow(badges), 5)
})
