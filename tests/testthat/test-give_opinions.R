context("test-give_opinions.R")

testthat::test_that("Silent if ok URLs", {
  f <- example_file("DESCRIPTION_good")
  desc_fixmes <- give_opinions_desc(f)
  expect_null(desc_fixmes)
})

testthat::test_that("Message if no URL", {
  f <- example_file("DESCRIPTION_no_URL")
  desc_fixmes <- give_opinions_desc(f)
  expect_is(desc_fixmes, "data.frame")
  expect_equal(desc_fixmes$where, "DESCRIPTION")
  expect_true(any(grepl("URL", desc_fixmes$fixme)))
})

testthat::test_that("Message if no BugReports", {
  f <- example_file("DESCRIPTION_no_bugreports")
  desc_fixmes <- give_opinions_desc(f)
  expect_is(desc_fixmes, "data.frame")
  expect_equal(desc_fixmes$where[1], "DESCRIPTION")
  expect_true(any(grepl("BugReports", desc_fixmes$fixme)))
})

testthat::test_that("No message if ok description",{
  f <- example_file("DESCRIPTION_Rforge")
  expect_null(give_opinions_desc(f))
})

test_that("Message if bad URLS", {
  f <- example_file("DESCRIPTION_wrongURLS")
  desc_fixmes <- give_opinions_desc(f)
  expect_true(any(grepl("Problematic URLs", desc_fixmes$fixme)))
})

test_that("badges in README", {
  f <- example_file("README_codemetar_bad.md")
  readme_fixmes <- give_opinions_readme(f, "codemetar")
  expect_equal(nrow(readme_fixmes), 2)
  expect_true(any(grepl("status", readme_fixmes$fixme)))
  expect_true(any(grepl("CRAN", readme_fixmes$fixme)))

  readme_fixmes <- give_opinions_readme(f, "a4")
  expect_true(any(grepl("BioConductor", readme_fixmes$fixme)))
})
