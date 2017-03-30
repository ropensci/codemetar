testthat::context("validate_codemeta")

testthat::test_that("We can write and validate a codemeta file given an R package DESCRIPTION", {

  write_codemeta("codemetar")
  schema <- system.file("schema/codemeta_schema.json", package = "codemetar")
  v <- jsonvalidate::json_validate("codemeta.json", schema, verbose = TRUE)

  ## equivalently, with C++ based validator:
  #v <- validatejsonr::validate_jsonfile_with_schemafile("codemeta.json", schema)$value == 0

  testthat::expect_true(v)
  unlink("codemeta.json")
})


testthat::context("write codemeta")

testthat::test_that("We can use either a path or pkg name in writing", {
  write_codemeta("codemetar")
  testthat::expect_true(file.exists("codemeta.json"))
  write_codemeta(system.file("DESCRIPTION", package = "codemetar"))
  testthat::expect_true(file.exists("codemeta.json"))
  unlink("codemeta.json")

})
