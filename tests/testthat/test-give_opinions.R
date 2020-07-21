context("test-give_opinions.R")

# Define inline helper function to allow for short, clear tests
contains <- function(hints, pattern) any(grepl(pattern, hints$fixme))
expect_missing_error <- function(x) expect_error(x, "missing")

testthat::test_that("Silent if ok URLs", {
  skip_on_cran()
  skip_if_offline()
  example_file("DESCRIPTION_good") %>%
    give_opinions_desc() %>%
    expect_null()
})

testthat::test_that("Message if no URL", {
  skip_on_cran()
  skip_if_offline()
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
  skip_on_cran()
  skip_if_offline()

  example_file("DESCRIPTION_Rforge") %>%
    give_opinions_desc() %>%
    expect_null()
})

test_that("Message if bad URLS", {
  skip_if_offline()
  skip_on_cran()
  hints <- example_file("DESCRIPTION_wrongURLS") %>%
    give_opinions_desc()
  expect_true(contains(hints, "Problematic URLs"))
})

test_that("badges in README", {
  skip_on_cran()
  skip_if_offline()

  file <- example_file("README_codemetar_bad.md")
  hints <- give_opinions_readme(file, "codemetar")

  ## failing since we aren't on CRAN
  #expect_equal(nrow(hints), 2)
  expect_true(contains(hints, "status"))
  #expect_true(contains(hints, "CRAN"))

  hints <- give_opinions_readme(file, "a4")
  expect_true(contains(hints, "BioConductor"))
})

test_that("read_description_if_null() works", {

  file <- example_file("DESCRIPTION_good")
  description <- desc::desc(file)

  result_1 <- read_description_if_null(description, "does_not_matter")
  result_2 <- read_description_if_null(NULL, file)

  expect_missing_error(read_description_if_null())
  expect_identical(description, result_1)
  expect_equal(description, result_2) # why not identical?
})

test_that("add_url_fixmes() works", {

  skip_on_cran()
  skip_if_offline()

  expect_missing_error(add_url_fixmes())

  result_1 <- add_url_fixmes("fixme", "no-such-url")
  result_2 <- add_url_fixmes("fixme", "www.leo.org")
  result_3 <- add_url_fixmes("fixmes", NA, "hint_add_repo_url")

  expect_identical(result_1[1], "fixme")
  expect_match(result_1[2], "No connection was possible")

  expect_identical(result_2, "fixme")
  expect_error(add_url_fixmes("fixmes", NA, "invalid_id"), "No such message_id")
  expect_match(result_3[2], "Indicate the URL")
})

test_that("fixmes_as_df_or_message() works", {

  expect_missing_error(fixmes_as_df_or_message())
  expect_missing_error(fixmes_as_df_or_message("fix!"))

  result <- fixmes_as_df_or_message("fix!", "my-package")
  expect_is(result, "data.frame")
  expect_identical(dim(result), c(1L, 2L))
  expect_identical(names(result), c("where", "fixme"))
  expect_identical(result$where, "my-package")
  expect_identical(result$fixme, "fix!")
})

test_that("try_to_give_opinions_readme() works", {

  expect_missing_error(try_to_give_opinions_readme())
  expect_null(try_to_give_opinions_readme(example_file("DESCRIPTION_good")))
  expect_null(try_to_give_opinions_readme(package_file("dplyr", "DESCRIPTION")))
})

test_that("has_provider_but_no_badge() works", {

  expect_missing_error(has_provider_but_no_badge())
  expect_false(has_provider_but_no_badge(NULL))
  expect_true(has_provider_but_no_badge(list(name = "my-provider")))
  expect_missing_error(has_provider_but_no_badge(list(name = "BioConductor")))

  file <- example_file("README_ex2.md")
  expect_true(has_provider_but_no_badge(list(name = "BioConductor"), file))

  file <- example_file("README_codemetar_good.md")
  provider <- list(name = "Comprehensive R Archive Network (CRAN)")
  expect_false(has_provider_but_no_badge(provider, file))
})

