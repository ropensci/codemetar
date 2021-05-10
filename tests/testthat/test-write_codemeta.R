testthat::context("write_codemeta")

testthat::test_that("we can create a codemeta document given a package name", {
  skip_on_cran()
  skip_if_offline()
  dir <- withr::local_tempdir()
  usethis::create_package(dir, open = FALSE)
  write_codemeta(dir)
  expect_snapshot_file(file.path(dir, "codemeta.json"))

})
