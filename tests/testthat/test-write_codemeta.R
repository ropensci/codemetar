testthat::test_that("we can create a codemeta document given a package name", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  dir <- withr::local_tempdir()
  dir.create(file.path(dir, "mypkg"))
  usethis::create_package(file.path(dir, "mypkg"), open = FALSE)
  write_codemeta(file.path(dir, "mypkg"))
 #  expect_snapshot_file(file.path(dir, "mypkg", "codemeta.json"))

})
