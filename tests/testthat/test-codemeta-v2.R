context("codemeta v2")

testthat::test_that("we can write a codemeta v2 document", {
  write_codemeta("codemetar", version = "2")
})



context("test codemeta parse_people utility")

testthat::test_that("We can parse author lists that use Authors@R, Authors, or both", {

  dcf <- system.file("examples/example.dcf", package="codemetar")
  descr <- as.list(read.dcf(dcf)[1,])
  codemeta <- new_codemeta()

  if("Authors@R" %in% names(descr)){
    codemeta <- parse_people(eval(parse(text=descr$`Authors@R`)), codemeta)
  } else {
    codemeta <- parse_people(as.person(descr$Maintainer), codemeta)
    codemeta <- parse_people(as.person(descr$Author), codemeta)
  }

  write_codemeta(cm = codemeta, path = "test.json")

  testthat::expect_true(file.exists("test.json"))

  unlink("test.json")

})
