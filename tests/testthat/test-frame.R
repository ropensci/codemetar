
library("jsonld")
frame <- system.file("schema/frame_schema.json", package="codemetar")
out <- jsonld_frame("codemeta.json", frame)
writeLines(out, "framed.json")

library("jsonlite")
## Standardized codemeta object via framing
codemeta <-read_json("framed.json")
meta <- codemeta[["@graph"]][[1]]

## Ugh, why has this not been compacted fully?:
meta$`codemeta:maintainer`$email
meta$maintainer$email
