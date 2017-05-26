testthat::context("test-many-packages")


testthat::test_that("Test the creation of codemeta for many packages", {

  ## Really only want to run this locally
  testthat::skip_on_travis()
  testthat::skip_on_cran()
  testthat::skip_on_appveyor()
  testthat::skip_on_bioc()

  ##
  testthat::skip()
## Test many installed packages



  df <- as.data.frame(installed.packages(), stringsAsFactors = FALSE)
  set <- df$Package[1:100]

  ## fixme avoid repeating context?
  set_meta <- lapply(set, create_codemeta)
  write_codemeta(set_meta, path = "many.json")

  unlink("many.json")

})
