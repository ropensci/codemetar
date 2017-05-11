testthat::context("Test creation of codemeta for many packages")
## Test many installed packages

df <- as.data.frame(installed.packages(), stringsAsFactors = FALSE)
set <- df$Package[1:100]

## fixme avoid repeating context?
set_meta <- lapply(set, create_codemeta)
write_codemeta(cm = set_meta, path = "many.json")

unlink("many.json")
