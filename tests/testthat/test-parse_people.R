testthat::context("parse_people.R")

testthat::testthat("parse_people person_to_schema method",{

  p <- person_to_schema("Carl Boettiger")
  expect_gt(length(p), 1)
  p <- person_to_schema("")
  expect_null(p)
})



testthat::testthat("parse_people",{
  cm <- new_codemeta()
  p <- parse_people("Carl Boettiger", cm)
  expect_gt(length(p$author), 0)

  p <- parse_people("", cm)
  expect_null(p$author)
})
