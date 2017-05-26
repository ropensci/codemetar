#' @importFrom jsonld jsonld_compact jsonld_expand
codemeta_validate <- function(example){
  context <- "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta.jsonld"

  ## Expand and Compact
  writeLines(jsonld_compact(jsonld_expand(example), context), "test.json")

  ## Same properties in each
  A <- read_json(example)
  B <- read_json("test.json")

  unlink("test.json")

  ## drop context, we don't care if one is literal and one the URL of context, what matters is content
  A$`@context` <- NULL
  B$`@context`  <- NULL

  ## Same number of properties as we started with?
  same_n_properties <- identical(length(unlist(A)), length(unlist(B)))

  ## Did any properties fail to compact back?
  compaction_fail <- any(grepl(names(unlist(B)) , pattern = ":"))
  same_n_properties && !compaction_fail

}



