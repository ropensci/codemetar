testthat::context("write_codemeta")

testthat::test_that("we can write a codemeta document given a package name", {
  write_codemeta("codemetar")
  testthat::expect_true(file.exists("codemeta.json"))
  unlink("codemeta.json")

})


testthat::test_that("we can write a codemeta document from a non-root dir", {
  cur <- getwd()
  setwd(tempdir())
  write_codemeta("codemetar")
  testthat::expect_true(file.exists("codemeta.json"))
  unlink("codemeta.json")

  setwd(cur)
})


testthat::test_that("We can use either a path or pkg name in writing", {

  write_codemeta(system.file("DESCRIPTION", package = "codemetar"))
  testthat::expect_true(file.exists("codemeta.json"))
  unlink("codemeta.json")

})

## Test that we can write codemeta from a temp working dir (e.g. non-root dir)
testthat::test_that("we can write codemeta given a codemeta object", {
  codemeta <- new_codemeta()
  create_codemeta(codemeta)
})

##(author test below includes such a step already)



testthat::test_that("We can parse author lists that use Authors@R, Authors, or both", {

  dcf <- system.file("examples/example.dcf", package="codemetar")
  descr <- as.list(read.dcf(dcf)[1,])
  codemeta <- new_codemeta()
  codemeta <- parse_people(eval(parse(text=descr$`Authors@R`)), codemeta)

  ## Tests that we can write codemeta given an existing codemeta object, expects a warning
  write_codemeta(codemeta, path = "test.json")

  testthat::expect_true(file.exists("test.json"))

  codemeta2 <- codemeta
  descr2 <- descr
  descr2$`Authors@R` <- NULL

  ## parse without Authors@R:
  codemeta2 <- parse_people(as.person(descr2$Author), codemeta2)
  codemeta2$maintainer <- person_to_schema(as.person(descr2$Maintainer))

  write_codemeta(codemeta2, path = "test2.json")
  testthat::expect_true(file.exists("test2.json"))


  unlink("test.json")
  unlink("test2.json")


})
