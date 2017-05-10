context("codemeta v2")

testthat::test_that("we can write a codemeta v2 document", {
  write_codemeta("codemetar", version = "2")
})
