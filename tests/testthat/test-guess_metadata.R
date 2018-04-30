testthat::context("guess_metadata")

testthat::test_that("guess_provider",{

  testthat::expect_null(guess_provider(NULL))

  ## A BIOC package
  a <- guess_provider("a4")
  expect_equal(a$name, "BioConductor")
  ## An R package
  a <- guess_provider("Matrix")
  expect_equal(a$name, "Comprehensive R Archive Network (CRAN)")
})



testthat::test_that("guess_ci",{
 f <- system.file("examples/README_ex.md", package="codemetar")
 a <- guess_ci(f)
 testthat::expect_equal(a[1], "https://travis-ci.org/codemeta/codemetar")
 testthat::expect_equal(a[2], "https://codecov.io/github/codemeta/codemetar?branch=master")

 f2 <- system.file("examples/README_ex2.md", package="codemetar")
 a2 <- guess_ci(f2)
 expect_null(a2)

 f <- system.file("examples/README_usethis.md", package="codemetar")
 a3 <- guess_ci(f)
 testthat::expect_equal(length(a3), 3)
 testthat::expect_equal(a3[1], "https://travis-ci.org/r-lib/usethis")

})




testthat::test_that("guess_devStatus",{
  f <- system.file("examples/README_ex.md", package="codemetar")
  a <- guess_devStatus(f)
  expect_equal(a, "http://www.repostatus.org/#wip")

  f <- system.file("examples/README_usethis.md", package="codemetar")
  a <- guess_devStatus(f)
  expect_equal(a, "https://www.tidyverse.org/lifecycle/#stable")

  f <- system.file("examples/README_codemetar_bad.md", package="codemetar")
  a <- guess_devStatus(f)
  expect_null(a)

  f2 <- system.file("examples/README_ex2.md", package="codemetar")
  a2 <- guess_devStatus(f2)
  expect_null(a2)


})

testthat::test_that("guess_devStatus", {
  ## function not implemented yet
  f <- system.file("examples/codemeta.json", package="codemetar")
  guess_orcids(f)
})


test_that("git utils", {


  x <- uses_git(".")
  testthat::expect_is(x, "logical")
  x <- guess_github(".")

  ## needs to be a git repo
  #x <- github_path(".", "README.md")

})



test_that("guess_readme", {
  testthat::expect_is(guess_readme(find.package("codemetar")), "list")
  testthat::expect_is(guess_readme(find.package("jsonlite")), "list")
})

test_that("guess_releaseNotes", {

  guess_releaseNotes(".")

  f <- system.file(".", package="codemetar")
  guess_releaseNotes(f)
})


test_that("fileSize", {
  guess_fileSize(NULL)
  guess_fileSize(".")
  ## expect_null?
  f <- system.file(".", package="codemetar")
  guess_fileSize(f)
})
