testthat::test_that("We can use a preset id", {
  skip_on_cran()
  skip_if_offline()
  f <- package_file("codemetar", "DESCRIPTION")
  id <- "https://doi.org/10.looks.like/doi"
  cm <- codemeta_description(f, id = id)
  expect_equal(cm$`@id`, id)
})

testthat::test_that("We can parse additional terms", {
  skip_on_cran()
  skip_if_offline()
  cm <- codemeta_description(example_file("DESCRIPTION_ex1.dcf"))
  testthat::expect_equal(length(cm$keywords), 6)
  testthat::expect_equal(cm$isPartOf, "https://ropensci.org")
})

testthat::test_that("We can parse plain Authors: & Maintainers: entries", {
  skip_on_cran()
  skip_if_offline()
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

testthat::test_that("Clean line control on description", {
  skip_on_cran()
  skip_if_offline()

  f <- example_file("DESCRIPTION_ex1.dcf")

  # Pure description
  raw <- desc::desc(f)


  # Should have several lines
  testthat::expect_length(unlist(strsplit(raw$get("Description"), "\n")), 3)

  cm <- codemeta_description(f)
  # We should expect a single line
  testthat::expect_length(unlist(strsplit(cm$description, "\n")), 1)

  # It should be the same
  testthat::expect_identical(
    clean_str(raw$get("Description")),
    cm$description
  )


  # Snapshot
  testthat::expect_snapshot_output(cm$description)
})
