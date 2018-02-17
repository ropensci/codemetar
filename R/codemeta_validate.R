#' codemeta validate
#'
#' Checks that a round-trip of expanding and compacting json-ld matches the
#' original document.  Incorrect schema terms or types (or spelling errors of properties)
#' will cause this round-trip to fail by not fully compacting.
#'
#' @param codemeta path/filename to a codemeta.json file, or json-ld text string
#' @param context URL (or path or json string) for the codemeta context.
#' Leave as default or use appropriate DOI for the version; see details.
#' @details by default, validation will use the original context from the import file.
#' @importFrom jsonld jsonld_compact jsonld_expand
#' @importFrom jsonlite toJSON read_json fromJSON
#' @export
#' @examples
#' ex <- system.file("examples/codemeta.json", package="codemetar")
#' codemeta_validate(ex)
#'
codemeta_validate <-
  function(codemeta = "codemeta.json", context = NULL) {


    if(file.exists(codemeta)){
      A <- read_json(codemeta)
    } else if(is(codemeta, "json")){
      A <- fromJSON(codemeta)
    }
    if(is.null(context)){
      context <- A$`@context`
      if(length(context) > 1){
        context <- jsonlite::toJSON(list("@context" = context),
                                    auto_unbox = TRUE)
      }
    }
    ## Expand and Compact
    test <- tempfile(fileext = ".json")
    writeLines(jsonld::jsonld_compact(
      jsonld::jsonld_expand(codemeta), context),
      test)

    ## Same properties in each

    B <- jsonlite::read_json(test)

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
