#' codemeta validate
#'
#' Perform basic check of JSON-LD expanding and compacting, verifying that the result
#'
#' @param codemeta path/filename to a codmeta.json file
#' @param context URL (or path or json string) for the codemeta context.
#' Leave as default or use appropriate DOI for the version; see details.
#' @details by default, validation will use the original context from the import file.
#' @importFrom jsonld jsonld_compact jsonld_expand
#' @export
#' @examples
#' ex <- system.file("examples/codemeta.json", package="codemetar")
#' codemeta_validate(ex)
#'

codemeta_validate <-
  function(codemeta = "codemeta.json", context = NULL) {
    A <- read_json(codemeta)
    context <- A$`@context`

    ## Expand and Compact
    test <- tempfile(fileext = ".json")
    writeLines(jsonld_compact(jsonld_expand(codemeta), context), test)

    ## Same properties in each

    B <- read_json(test)

    unlink(test)

    ## drop context, we don't care if one is literal and one the URL
    A$`@context` <- NULL
    B$`@context`  <- NULL

    ## Same number of properties as we started with?
    same_n_properties <-
      identical(length(unlist(A)), length(unlist(B)))

    ## Did any properties fail to compact back?
    compaction_fail <- any(grepl(names(unlist(B)) , pattern = ":"))
    same_n_properties && !compaction_fail

  }
