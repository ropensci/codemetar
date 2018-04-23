testthat::context("guess_metadata")

testthat::test_that("guess_provider",{

  testthat::expect_null(guess_provider(NULL))

  ## A BIOC package
  a <- guess_provider("a4")
  expect_equal(a$name, "BioConductor")
  ## An R package
  a <- guess_provider("Matrix")
  expect_equal(a$name, "Central R Archive Network (CRAN)")
})



testthat::test_that("guess_ci",{
 f <- system.file("examples/README_ex.md", package="codemetar")
 a <- guess_ci(f)
 expect_gt(length(a), 0)

 f2 <- system.file("examples/README_ex2.md", package="codemetar")
 a2 <- guess_ci(f2)
 expect_null(a2)


})




testthat::test_that("guess_devStatus",{
  f <- system.file("examples/README_ex.md", package="codemetar")
  a <- guess_devStatus(f)
  expect_equal(a, "http://www.repostatus.org/#wip")

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

  guess_readme(".")

  ## expect_null?
  f <- system.file(".", package="codemetar")
  a <- guess_readme(f)
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
