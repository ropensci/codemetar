context("codemeta v2")

testthat::test_that("we can write a codemeta v2 document", {
  write_codemeta("codemetar", version = "2")
})



context("test codemeta parse_people utility")

testthat::test_that("We can parse author lists that use Authors@R, Authors, or both", {

  dcf <- system.file("examples/example.dcf", package="codemetar")
  descr <- as.list(read.dcf(dcf)[1,])
  codemeta <- new_codemeta()
  codemeta <- parse_people(eval(parse(text=descr$`Authors@R`)), codemeta)

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
