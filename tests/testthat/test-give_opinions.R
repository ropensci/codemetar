context("test-give_opinions.R")

# Define inline helper function to allow for short, clear tests
contains <- function(hints, pattern) any(grepl(pattern, hints$fixme))

testthat::test_that("Silent if ok URLs", {
  example_file("DESCRIPTION_good") %>%
    give_opinions_desc() %>%
    expect_null()
})

testthat::test_that("Message if no URL", {
  hints <- example_file("DESCRIPTION_no_URL") %>%
    give_opinions_desc()
  expect_is(hints, "data.frame")
  expect_equal(hints$where, "DESCRIPTION")
  expect_true(contains(hints, "URL"))
})

testthat::test_that("Message if no BugReports", {
  hints <- example_file("DESCRIPTION_no_bugreports") %>%
    give_opinions_desc()
  expect_is(hints, "data.frame")
  expect_equal(hints$where[1], "DESCRIPTION")
  expect_true(contains(hints, "BugReports"))
})

testthat::test_that("No message if ok description",{
  example_file("DESCRIPTION_Rforge") %>%
    give_opinions_desc() %>%
    expect_null()
})

test_that("Message if bad URLS", {
  hints <- example_file("DESCRIPTION_wrongURLS") %>%
    give_opinions_desc()
  expect_true(contains(hints, "Problematic URLs"))
})

test_that("badges in README", {
  hints <- example_file("README_codemetar_bad.md") %>%
    give_opinions_readme("codemetar")
  expect_equal(nrow(hints), 2)
  expect_true(contains(hints, "status"))
  expect_true(contains(hints, "CRAN"))

  hints <- give_opinions_readme(f, "a4")
  expect_true(contains(hints, "BioConductor"))
})
