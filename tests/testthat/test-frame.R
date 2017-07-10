
testthat::context("test frame")

library("jsonld")
frame <- system.file("schema/frame_schema.json", package="codemetar")
test <- system.file("examples/codemeta.json", package="codemetar")

out <- jsonld_frame(test, frame)
writeLines(out, "framed.json")

library("jsonlite")
## Standardized codemeta object via framing
codemeta <-read_json("framed.json")
meta <- codemeta[["@graph"]][[1]]


testthat::test_that(
  "we have fully compacted non-schema.org terms:", {

  testthat::expect_null(meta$`codemeta:maintainer`$email)
  testthat::expect_match(meta$maintainer$email, ".*@gmail.com")
})

testthat::test_that(
  "Frame should result in missing fields being returned with explicit NULLs", {

  testthat::expect_true("memoryRequirements" %in% names(meta))
  testthat::expect_null(meta$memoryRequirements)
})

unlink("framed.json")
