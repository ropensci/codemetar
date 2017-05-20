
testthat::context("Use the schema/frame_schema.json to standardize and test the metadata")

library("jsonld")
frame <- system.file("schema/frame_schema.json", package="codemetar")
write_codemeta("codemetar", "test.json")
out <- jsonld_frame("test.json", frame)
writeLines(out, "framed.json")

library("jsonlite")
## Standardized codemeta object via framing
codemeta <-read_json("framed.json")
meta <- codemeta[["@graph"]][[1]]

## Ugh, why has this not been compacted fully?:
meta$`codemeta:maintainer`$email
meta$maintainer$email

## Frame should result in missing fields being returned with explicit NULLs
testthat::expect_true("memoryRequirements" %in% names(meta))
testthat::expect_null(meta$memoryRequirements)


unlink("test.json")
