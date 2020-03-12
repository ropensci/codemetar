test_that("add_repository_terms works", {
  # Provide testdata
  codemeta <- new_codemeta()
  codemeta$package <- "abc"
  descr <- desc::desc(example_file("DESCRIPTION_good"))

  expect_error(add_repository_terms())
  result <- add_repository_terms(codemeta, descr = descr)
  expect_true(all(c("codeRepository", "relatedLink") %in% names(result)))

})

testthat::test_that("add_repository_terms works when there are several URLs", {

  cm <- add_repository_terms(new_codemeta(),
                             desc::desc(
                               example_file(
                                 "DESCRIPTION_two_URLs")))
  expect_equal(cm$codeRepository, "https://github.com/ropensci/essurvey")
  expect_true("https://ropensci.github.io/essurvey/" %in%
                cm$relatedLink)
})

testthat::test_that("add_repository_terms works when there's a non GitHub code repository", {
  cm <- add_repository_terms(codemeta = new_codemeta(),
                             descr = desc::desc(
                               example_file(
                                 "DESCRIPTION_gitlab")))
  expect_equal(cm$codeRepository, "https://gitlab.com/ropensci/codemetar")
  expect_true("https://ropensci.github.io/codemetar" %in%
                cm$relatedLink)

  cm <- add_repository_terms(codemeta = new_codemeta(),
                             descr = desc::desc(
                               example_file(
                                 "DESCRIPTION_bitbucket")))
  expect_equal(cm$codeRepository, "https://bitbucket.org/ropensci/codemetar")
  expect_true("https://ropensci.github.io/codemetar" %in%
                cm$relatedLink)
})

testthat::test_that("add_repository_terms does not keep a direct link to README", {
  cm <- codemeta_description(example_file("DESCRIPTION_good_readmeinurl"))
  expect_equal(cm$codeRepository, "https://github.com/ropensci/codemetar")
  expect_true("https://ropensci.github.io/codemetar" %in%
                cm$relatedLink)
  expect_true("https://github.com/ropensci/codemetar#codemetar" %in%
                cm$relatedLink)
})

testthat::test_that("add_repository_terms updates the codeRepository URL", {

  cm <- new_codemeta()
  cm$codeRepository <- "lalala"

  cm <- add_repository_terms(cm,
                             desc::desc(
                               example_file(
                                 "DESCRIPTION_two_URLs")))
  expect_equal(cm$codeRepository, "https://github.com/ropensci/essurvey")
  expect_true("https://ropensci.github.io/essurvey/" %in%
                cm$relatedLink)
})
