testthat::test_that("we can create a codemeta document given a package name", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  dir <- withr::local_tempdir()
  dir.create(file.path(dir, "mypkg"))
  usethis::create_package(file.path(dir, "mypkg"), open = FALSE)
  write_codemeta(file.path(dir, "mypkg"))
  
  # Test that the codemeta.json file was created
  testthat::expect_true(file.exists(file.path(dir, "mypkg", "codemeta.json")))
  
  # Test that the file contains valid JSON
  codemeta_content <- jsonlite::read_json(file.path(dir, "mypkg", "codemeta.json"))
  testthat::expect_true(is.list(codemeta_content))
})
