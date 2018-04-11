testthat::context("write_codemeta")

testthat::test_that("we can write a codemeta document given a package name", {
  write_codemeta("codemetar")
  testthat::expect_true(file.exists("codemeta.json"))
  unlink("codemeta.json")

})





## Not needed, covered by the git clone test, which also avoids the use of setwd
#testthat::test_that("we can write a codemeta document from non-root dir", {
#  cur <- getwd()
#  setwd(tempdir())
#
#  write_codemeta("codemetar")
#  testthat::expect_true(file.exists("codemeta.json"))
#  unlink("codemeta.json")
#  setwd(cur)

#})



testthat::test_that("We can read an existing codemeta.json file", {
  write_codemeta("codemetar")
  testthat::expect_true(file.exists("codemeta.json"))
  write_codemeta("codemetar")
  unlink("codemeta.json")

})


testthat::test_that("We can use either a path or pkg name in writing", {
  write_codemeta(path.package("codemetar"))
  testthat::expect_true(file.exists("codemeta.json"))
  unlink("codemeta.json")

})

## Test that we can write codemeta from a temp working dir (e.g. non-root dir)
testthat::test_that("we can write codemeta given a codemeta object", {
  codemeta <- new_codemeta()
  expect_is(create_codemeta("codemetar", codemeta), "list")
})

##(author test below includes such a step already)


