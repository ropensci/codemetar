


#' Crosswalk a column to return a JSON-LD context for it based on codemeta
#'
#' @param column column name from the CrossWalk table (character vector)
#' @param cw_table A CrossWalk table. call to
#' readr::read_csv("https://github.com/codemeta/codemeta/raw/master/crosswalk.csv")
#'  or use default cached copy.
#' @param to_json logical, should the result be turned into a json string?
#'  Default FALSE, which permits easier manipulation such as adding this
#'  context to an existing list before serializing to JSON
#' @return a context list, which can be converted to a json string
#' @export
#' @importFrom stats na.omit
#'
#' @examples
#' crosswalk("Zenodo")
crosswalk <- function(column,
                      cw_table = NULL,
                      to_json = FALSE) {
  if (is.null(cw_table))
    cw_table <- cw

  def <- function(r) {
    prefix <- strsplit(r[["Parent Type"]], ":")[[1]][[1]]
    if (prefix == "schema")
      out <- paste(prefix, r[["Property"]], sep = ":")
    ## Best to declare type on any property we want to explicitly
    ## type in the output version (e.g. codemeta objects)
    ## Otherwise the compaction aglorithm will not de-reference the `codemeta:` prefix
    else if (prefix == "codemeta") {
      type <- gsub("(\\w+).*", "\\1", r[["Type"]])
      out <- list(
        "@id" = paste0(prefix, ":", r[["Property"]]),
        "@type" = paste0("http://schema.org/", type)
      )
    }
    out
  }

  df <-
    stats::na.omit(cw_table[c("Parent Type", "Property", "Type", column)])

  ## apply by row
  context <- apply(df, 1, def)
  names(context) <- gsub("(\\w+).*", "\\1", df[[column]])

  context <- c(
    list(schema = "http://schema.org/",
         codemeta = "https://codemeta.github.io/terms/"),
    as.list(context)
  )
  context
  if (to_json) {
    jsonlite::toJSON(list(context = context),
                     pretty = TRUE,
                     auto_unbox = TRUE)
  } else {
    context
  }
}
