#' crosswalk
#'
#' Crosswalk between different metadata fields used by different repositories,
#' registries and archives. For more details see
#' https://codemeta.github.io/crosswalk This function requires an internet
#' connection to obtain the latest crosswalk table. This function essentially
#' applies the crosswalk table shown by \code{\link{crosswalk_table}} to a given
#' JSON metadata record.
#' @param x a JSON list or file with data fields to be crosswalked
#' @param from the corresponding column name from the crosswalk table.
#' @param to the column to translate into, assumes "codemeta" by default
#' @param codemeta_context the address or contents of codemeta context. Leave at
#'   default
#'
#' @return a `json` object containing a valid codemeta.json file created by
#'   crosswalking the input JSON
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
crosswalk <- function(x, from, to = "codemeta", codemeta_context = NULL) {

  codemeta_context <- default_context_if_null(codemeta_context)

  from_context <- crosswalk_table(from) %>%
    get_crosswalk_context(codemeta_context)

  to_context <- if (to != "codemeta") {

    crosswalk_table(to) %>%
      get_crosswalk_context(codemeta_context) %>%
      toJSON(auto_unbox = TRUE, pretty = TRUE)

  } else {

    codemeta_context
  }

  # ids need to be coerced to character in order to be compacted by jsonld
  x$id <- as.character(x$id)
  x$owner$id <- as.character(x$owner$id)
  x$organization$id <- as.character(x$organization$id)

  crosswalk_transform(
    x, crosswalk_context = from_context, codemeta_context = to_context
  )
}

# default_context_if_null ------------------------------------------------------

#' Return Given Context or Default Context if NULL
#'
#' @param codemeta_context context to be checked for \code{NULL}
#' @return \describe{
#'   \item{\code{codemeta_context}}{if \code{codemeta_context} is not \code{NULL},}
#'   \item{the value of option \code{codemeta_context}}{if thisoption is set,}
#'   \item{the value returned by \code{codemetar:::url_codemeta_schema()}}{else.}
#' }
#'
default_context_if_null <- function(codemeta_context)
{
  if (is.null(codemeta_context)) {

    getOption("codemeta_context", url_codemeta_schema())

  } else {

    codemeta_context
  }
}

#' crosswalk_table
#'
#' return a subset of the crosswalk table containing codemeta properties and
#' matching column
#' @param from the name of a column in the crosswalk table to map from.
#' @param to the name of one or more columns in the crosswalk table to map into
#' @param full_crosswalk Path or URL (requires internet!) of the full crosswalk
#'   table.
#' @param trim drop rows giving properties not found in the 'from' column?
#' @importFrom readr read_csv cols
#' @return a tibble containing the trimmed crosswalk table, listing property (in
#'   CodeMeta), and the corresponding terms in both from and to columns.
#' @examples \donttest{
#' crosswalk_table(from = "GitHub", to = c("Zenodo", "Figshare"))
#' }
#' @export
crosswalk_table <- function(
  from, to = NULL, full_crosswalk = NULL, trim = TRUE) {

  if (is.null(full_crosswalk)) {

    github_path <- "codemeta/codemeta/raw/master/crosswalk.csv"

    full_crosswalk <- get_url_github(github_path)
  }

  df <- readr::read_csv(full_crosswalk, col_types = readr::cols(.default = "c"))

  df <- df[c("Property", from, to)]

  if (trim) {

    df[! is.na(df[[from]]), ] # trim to `from` argument fields

  } else {

    df
  }
}

## Use a crosswalk table subset to create a context file for the input data
## This is a JSON-LD representation of the crosswalk for the desired data.
#' @importFrom jsonlite read_json
get_crosswalk_context <- function(df, codemeta_context = NULL) {

  codemeta_context <- default_context_if_null(codemeta_context)

  context <- jsonlite::read_json(codemeta_context)[[1]]

  context[["id"]] <- NULL ## avoid collisions with @id

  # Continue with a data frame (not with a tibble) so that indexing a column
  # returns a vector
  df <- as.data.frame(df)

  # Lookup the "keys" in the names of the context
  indices <- match(df[, 1], names(context))

  # Which keys have been found?
  found <- ! is.na(indices)

  # Create a new list of key/value pairs
  additional_context <- stats::setNames(context[indices[found]], df[found, 2])

  base_context <- list(
    schema = "http://schema.org/",
    codemeta = "https://codemeta.github.io/terms/"
  )

  list("@context" = c(base_context, additional_context))
}

#' Crosswalk transform
#'
#' Perform JSON-LD expansion of input, followed by compaction into the codemeta
#' context
#' @inheritParams crosswalk
#' @param crosswalk_context Context to be added to x
#' @return a valid codemeta json description.
#' @importFrom jsonld jsonld_expand jsonld_compact
#' @importFrom jsonlite toJSON
crosswalk_transform <- function(
  x, crosswalk_context = NULL, codemeta_context = NULL
) {

  codemeta_context <- default_context_if_null(codemeta_context)

  add_context(x, context = crosswalk_context) %>%
    jsonlite::toJSON(auto_unbox = TRUE, pretty = TRUE) %>%
    jsonld::jsonld_expand() %>%
    jsonld::jsonld_compact(context = codemeta_context)
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
