testthat::context("parse_depends.R")

testthat::test_that("Test the various cases for dependencies", {

  testthat::expect_error(format_depend(NULL))
  a <- format_depend(package = "a4",
                     version = "*",
                     remote_provider = "")  # BIOC provider
  testthat::expect_equal(a$sameAs, "https://bioconductor.org/packages/release/bioc/html/a4.html")


  testthat::expect_equal(a$provider$`@id`, "https://www.bioconductor.org")

  a <- format_depend(package = "httr",
                     version = "*",
                     remote_provider = "") # CRAN provider
  testthat::expect_equal(a$sameAs, "https://CRAN.R-project.org/package=httr")

  a <- format_depend(package = "desc",
                     version = "*",
                     remote_provider = "r-lib/desc") # CRAN provider
  testthat::expect_equal(a$sameAs, "https://github.com/r-lib/desc")

  f <- system.file("examples/DESCRIPTION_with_remote", package = "codemetar")
  descr <- codemeta_description(f)
  testthat::expect_equal(descr$softwareRequirements[[3]]$sameAs,
                         "https://github.com/lala/jsonld")

  testthat::expect_equal(a$provider$`@id`, "https://cran.r-project.org")
  a <- format_depend(package = "R",
                     version = ">= 3.0.0",
                     remote_provider = "")
  testthat::expect_equal(a$name, "R")

})

testthat::test_that("Test the various cases for ids (NOT used currently)", {

  # a <- guess_dep_id(parse_depends("a4")[[1]])  # BIOC provider
  # a <- guess_dep_id(parse_depends("httr")[[1]]) # CRAN provider
  # a <- guess_dep_id(parse_depends("R")[[1]])
  # a <- guess_dep_id(parse_depends("not-a-package")[[1]])

})

testthat::test_that("Sys requirements", {
  f <- system.file("examples/DESCRIPTION_sysreqs", package = "codemetar")
  descr <- codemeta_description(f)
  testthat::expect_equal(descr$softwareRequirements[[22]]$identifier,
                         "https://sysreqs.r-hub.io/get/imagemagick")
})
