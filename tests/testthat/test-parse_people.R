testthat::context("parse_people.R")

testthat::test_that("parse_people person_to_schema method",{

  p <- person_to_schema("Carl Boettiger")
  expect_gt(length(p), 1)
  p <- person_to_schema("")
  expect_null(p)
})

testthat::test_that("parse_people",{
  cm <- new_codemeta()
  p <- parse_people("Carl Boettiger", cm)
  expect_gt(length(p$author), 0)

  p <- parse_people("", cm)
  expect_null(p$author)
})

testthat::test_that("person_has_no_role works", {

  expect_error(person_has_no_role())
  expect_error(person_has_no_role("Maria"))

  expect_true(person_has_no_role(person("Maria")))
  expect_false(person_has_no_role(person("Maria", role = "aut")))
})

testthat::test_that("person_has_role works", {

  expect_error(person_has_role())
  expect_error(person_has_role("Maria"))
  expect_error(person_has_role(person("Maria")))

  expect_true(person_has_role(person("Maria", role = "aut"), "aut"))
  expect_false(person_has_role(person("Maria", role = "aut"), "abc"))
})
