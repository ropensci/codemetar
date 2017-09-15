#' crosswalk
#'
#' Crosswalk between different metadata fields used by different repositories,
#' registries and archives. For more details see https://codemeta.github.io/crosswalk
#' This function requires an internet connection to obtain the latest crosswalk table.
#'
#' @param x a JSON list of data fields to be crosswalked
#' @param from the corresponding column name from the crosswalk table.
#' @param to the column to translate into, assumes "codemeta" by default
#' @param codemeta_context the address or contents of codemeta context. Leave at default
#'
#' @return a `json` object containing a valid codemeta.json file created by crosswalking the input JSON
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ## Crosswalk data returned by the GitHub API into CodeMeta format
#' r <- gh::gh("/repos/:owner/:repo", owner = "ropensci", repo = "EML")
#' crosswalk(r, "GitHub")
#' }
#'
crosswalk <- function(x,
                      from,
                      to = "codemeta",
                      codemeta_context =
                        "https://doi.org/10.5063/schema/codemeta-2.0"
){

  from_context <- crosswalk_context(crosswalk_table(from), codemeta_context)
  if(to != "codemeta"){
    to_context <- crosswalk_context(crosswalk_table(to),  codemeta_context)
    to_context <- toJSON(to_context, auto_unbox = TRUE, pretty = TRUE)
  } else {
    to_context <- codemeta_context
  }
  crosswalk_transform(x,
                      crosswalk_context = from_context,
                      codemeta_context = to_context)

}

# return a subset of the crosswalk table containing codemeta properties and matching column
#' @importFrom readr read_csv cols
crosswalk_table <- function(column,
                            full_crosswalk =
  "https://github.com/codemeta/codemeta/raw/master/crosswalk.csv"){
  df <-
    readr::read_csv(full_crosswalk,
             col_types = cols(.default = "c"))
  df <- df[c("Property", column)]
  stats::na.omit(df)
}

## Use a crosswalk table subset to create a context file for the input data
## This is a JSON-LD representation of the crosswalk for the desired data.
#' @importFrom jsonlite read_json
crosswalk_context <-
  function(df,
           codemeta_context =
             "https://doi.org/10.5063/schema/codemeta-2.0"){

    context <- jsonlite::read_json(codemeta_context)
    context[[1]][["id"]] <- NULL ## avoid collisions with @id
    properties <- names(context[[1]])

    new_context <- list("@context" =
                        list(schema = "http://schema.org/",
                             codemeta = "https://codemeta.github.io/terms/"))

    for(i in 1:dim(df)[1]){
      original_term <- properties[properties == df[[i, 1]] ]
      new_context[["@context"]][[ df[[i,2]] ]] <- context[[1]][[original_term]]
    }
  new_context
  }

#' Crosswalk transform
#'
#' Perform JSON-LD expansion of input, followed by compaction into the codemeta context
#' @inheritParams crosswalk
#' @param crosswalk_context Context to be added to x
#' @return a valid codemeta json description.
#' @importFrom jsonld jsonld_expand jsonld_compact
#' @importFrom jsonlite toJSON
crosswalk_transform <- function(x,
                                crosswalk_context = NULL,
                                codemeta_context =
                                "https://doi.org/10.5063/schema/codemeta-2.0"){

  x <- add_context(x, crosswalk_context)
  y <- jsonlite::toJSON(x, auto_unbox = TRUE, pretty = TRUE)
  y <- jsonld::jsonld_expand(y)
  y <- jsonld::jsonld_compact(y, context = codemeta_context)
  y
}



#' drop_context
#'
#' drop context element from json list or json string
#' @param x a JSON list (from read_json / fromJSON) or json object (from toJSON)
#' @param json_output logical, should output be a json object or a list?
#' @return a list or json object with the "@context" element removed
#' @importFrom jsonlite toJSON fromJSON
#' @export
drop_context <-function(x, json_output = FALSE){
  if(is(x, "json") || is.character(x)){
    x <- fromJSON(x)
    json_output <- TRUE
  }
  x$`@context` <- NULL


  if(json_output){
    x <- toJSON(x, auto_unbox = TRUE, pretty = TRUE)
  }
  x
}

#' add_context
#'
#' add context element to json list or json string
#'
#' @param x a JSON list (from read_json / fromJSON) or json object (from toJSON)
#' @param context context to be added, in same format as x
#' @param json_output logical, should output be a json object or a list?
#' @return a list or json object with "@context" element added
#' @export
add_context <- function(x, context, json_output = FALSE){
  if(is(x, "json") || is.character(x)){
    x <- fromJSON(x)
    json_output <- TRUE
  }
  if(is(context, "json") || is.character(context)){
    context <- fromJSON(context)
  }

  ## make sure context doesn't already have a "@context" property
  x$`@context` <- context

  if(json_output){
   x <- toJSON(x, auto_unbox = TRUE, pretty = TRUE)
  }
  x
}

