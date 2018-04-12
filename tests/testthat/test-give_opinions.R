context("test-give_opinions.R")

testthat::test_that("Message if no URL", {
  f <- system.file("examples/DESCRIPTION_no_URL", package = "codemetar")
  desc_fixmes <- give_opinions_desc(f)
  expect_is(desc_fixmes, "data.frame")
  expect_equal(desc_fixmes$where, "DESCRIPTION")
  expect_true(any(grepl("URL", desc_fixmes$fixme)))
})

testthat::test_that("Message if no BugReports", {
  f <- system.file("examples/DESCRIPTION_no_bugreports", package = "codemetar")
  desc_fixmes <- give_opinions_desc(f)
  expect_is(desc_fixmes, "data.frame")
  expect_equal(desc_fixmes$where, "DESCRIPTION")
  expect_true(any(grepl("BugReports", desc_fixmes$fixme)))
})

testthat::test_that("No message if ok description",{
  f <- system.file("examples/DESCRIPTION_Rforge", package = "codemetar")
  expect_null(give_opinions_desc(f))
})

test_that("Message if bad URLS", {
  f <- system.file("examples/DESCRIPTION_wrongURLS", package = "codemetar")
  desc_fixmes <- give_opinions_desc(f)
  expect_true(any(grepl("Problematic URLs", desc_fixmes$fixme)))
})
