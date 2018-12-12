testthat::context("codemeta_description.R")

testthat::test_that("We can use a preset id", {
  f <- package_file("codemetar", "DESCRIPTION")
  codemeta_description(f, id = "https://doi.org/10.looks.like/doi")
})

testthat::test_that("several URLs", {
  cm <- codemeta_description(example_file("DESCRIPTION_two_URLs"))
  expect_equal(cm$codeRepository, "https://github.com/ropensci/essurvey")
  expect_true("https://ropensci.github.io/essurvey/" %in%
                cm$relatedLink)
})

testthat::test_that("no direct link to README", {
  cm <- codemeta_description(example_file("DESCRIPTION_good_readmeinurl"))
  expect_equal(cm$codeRepository, "https://github.com/ropensci/codemetar")
  expect_true("https://ropensci.github.io/codemetar" %in%
                cm$relatedLink)
  expect_true("https://github.com/ropensci/codemetar#codemetar" %in%
                cm$relatedLink)
})

testthat::test_that("We can parse additional terms", {
  cm <- codemeta_description(example_file("DESCRIPTION_ex1.dcf"))
  testthat::expect_equal(length(cm$keywords), 6)
  testthat::expect_equal(cm$isPartOf, "https://ropensci.org")
})

testthat::test_that("We can parse plain Authors: & Maintainers: entries", {

  authors <- codemeta_description(example_file("DESCRIPTION_ex1.dcf"))
  expect_true(authors$maintainer[[1]]$familyName == "Boettiger")
  expect_equal(length(authors$author), 0)

  authors <- codemeta_description(example_file("example.dcf"))
  expect_true(authors$maintainer[[1]]$familyName == "Developer")
  expect_equal(length(authors$author), 2)

  authors <- codemeta_description(example_file("DESCRIPTION_plainauthors"))
  expect_true(authors$maintainer[[1]]$familyName == "Ok")
  expect_equal(length(authors$author), 2)

  authors <- codemeta_description(example_file("DESCRIPTION_twomaintainers"))
  expect_equal(length(authors$author), 1)
  expect_equal(length(authors$maintainer), 2)
})

testthat::test_that("Helper functions work correctly", {

  # Provide testdata
  codemeta <- new_codemeta()
  codemeta$package <- "abc"
  descr <- desc::desc(example_file("DESCRIPTION_good"))

  # test add_repository_terms()
  expect_error(add_repository_terms())
  result <- add_repository_terms(codemeta, descr)
  expect_true(all(c("codeRepository", "relatedLink") %in% names(result)))

  # test add_language_terms()
  expect_error(add_language_terms())
  result <- add_language_terms(codemeta)
  expect_true(all(
    c("programmingLanguage", "runtimePlatform") %in%
      names(result)
  ))

  # test add_person_terms()
  expect_error(add_person_terms())
  result <- add_person_terms(codemeta, descr)
  expect_true(all(
    c("author", "contributor", "copyrightHolder", "funder", "maintainer") %in%
      names(result)))

  # test add_software_terms
  expect_error(add_software_terms())
  result <- add_software_terms(codemeta, descr)
  expect_true(all(
    c("softwareSuggestions", "softwareRequirements") %in% names(result)
  ))

  # test add_remote_provider()
  expect_error(add_remote_provider())
  expect_error(add_remote_provider(codemeta))
  remotes <- sprintf("provider%d/abc", 1:2)
  result <- add_remote_provider(codemeta, remotes)
  expect_identical(result$remote_provider, remotes)

  # test add_additional_terms()
  expect_error(add_additional_terms())
  result <- add_additional_terms(codemeta, descr)
  expect_true(all(c("isPartOf", "keywords") %in% names(result)))
})
