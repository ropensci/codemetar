testthat::context("guess_metadata")

testthat::test_that("guess_provider",{

  skip_on_cran()
  skip_if_offline()
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

 f <- system.file("examples/README_fakepackage.md", package="codemetar")
 a3 <- guess_ci(f)
 testthat::expect_equal(length(a3), 3)
 testthat::expect_equal(a3[1], "https://travis-ci.org/fakeorg/fakepackage")

})

testthat::test_that("guess_devStatus",{
  f <- system.file("examples/README_ex.md", package="codemetar")
  a <- guess_devStatus(f)
  expect_equal(a, "http://www.repostatus.org/#wip")

  f <- system.file("examples/README_fakepackage.md", package="codemetar")
  a <- guess_devStatus(f)
  expect_equal(a, "https://www.tidyverse.org/lifecycle/#stable")

  f <- system.file("examples/README_codemetar_bad.md", package="codemetar")
  a <- guess_devStatus(f)
  expect_null(a)

  f2 <- system.file("examples/README_ex2.md", package="codemetar")
  a2 <- guess_devStatus(f2)
  expect_null(a2)

  f <- system.file("examples/README_fakepackage6.md", package="codemetar")
  status <- guess_devStatus(f)
  expect_equal(length(status), 2)

  f <- system.file("examples/README_fakepackage7.md", package="codemetar")
  status <- guess_devStatus(f)
  expect_equal(status, "https://www.tidyverse.org/lifecycle/#maturing")
})

test_that("git utils", {


  x <- uses_git(".")
  testthat::expect_is(x, "logical")
  x <- guess_github(".")

  ## needs to be a git repo
  #x <- github_path(".", "README.md")

})

test_that("guess_readme", {
  testthat::skip_if_not(nzchar(Sys.getenv("GITHUB_PAT")))
  testthat::expect_is(guess_readme(find.package("codemetar")), "list")
  testthat::expect_is(guess_readme(find.package("jsonlite")), "list")
})

test_that("guess_readme() matches a single README file", {
  testthat::skip_if_not(nzchar(Sys.getenv("GITHUB_PAT")))
  candidates <- c("README.Rmd", "readme.md", "README.Rmd~", "DO_NOT_README.md")
  dir.create(tempdir <- tempfile("README"))
  file.create(file.path(tempdir, candidates))
  ## match README.Rmd then readme.md (use non-memoised function here)
  for (i in 1:2) {
    matched_README <- .guess_readme(tempdir)$readme_path
    expect_length(matched_README, 1)
    expect_identical(matched_README, file.path(tempdir, candidates[i]))
    unlink(matched_README)
  }
  ## match none of the remaining candidates
  matched_README <- .guess_readme(tempdir)$readme_path
  expect_null(matched_README)
  unlink(tempdir)
})

test_that("guess_releaseNotes", {

  guess_releaseNotes(".")

  f <- system.file(".", package="codemetar")
  guess_releaseNotes(f)
})

test_that("fileSize", {
  skip_on_cran()
  skip_if_offline()

  ## should be NULL if root == NULL
  expect_null(guess_fileSize(NULL))

  ## this should just work fine
  expect_is(guess_fileSize("."), "character")

  ## test argument .ignore
  expect_is(guess_fileSize(".", .ignore = " "), "character")

})

test_that("add_github_topics",{
  testthat::skip_if_not(nzchar(Sys.getenv("GITHUB_PAT")))

  cm <- NULL
  cm$codeRepository <- "https://github.com/ropensci/codemetar"
  cm <- add_github_topics(cm)
  testthat::expect_is(cm$keywords, "character")

  cm <- NULL
  cm$codeRepository <- "https://github.com/ropensci/codemetar#readme"
  cm <- add_github_topics(cm)
  testthat::expect_is(cm$keywords, "character")

  cm <- NULL
  cm$codeRepository <- "https://github.com/maelle/notarepo"
  cm <- add_github_topics(cm)
  testthat::expect_null(cm$keywords)
})

testthat::test_that("rOpenSci peer-review", {
  skip_on_cran()
  skip_if_offline()

  f <- system.file("examples/README_fakepackage5.md", package="codemetar")
  testthat::expect_null(guess_ropensci_review(f))

  f <- system.file("examples/README_fakepackage3.md", package="codemetar")
  testthat::expect_null(guess_ropensci_review(f))

  f <- system.file("examples/README_fakepackage4.md", package="codemetar")
  review_info <- guess_ropensci_review(f)
  testthat::expect_is(review_info, "list")
  testthat::expect_equal(review_info$`@type`, "Review")
  testthat::expect_equal(review_info$url, "https://github.com/ropensci/onboarding/issues/24")
  testthat::expect_equal(review_info$provider, "http://ropensci.org")

})
