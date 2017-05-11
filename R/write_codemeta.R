#' write_codemeta
#' @param pkg package description file, can be path or package name.
#' @param cm a codemeta list object, e.g. from \code{\link{create_codemeta}}
#' @param path file name of the output, leave at default "codemeta.json"
#' @param pretty formatting option to \code{\link{write_json}}
#' @param auto_unbox formatting  option to \code{\link{write_json}}
#' @param version schema version
#' @param ...  additional arguments to \code{\link{write_json}}
#'
#' @return writes out the codemeta.json file
#' @export
#'
#' @importFrom jsonlite write_json
#' @examples
#' write_codemeta("codemetar")
write_codemeta <- function(pkg = ".",
                           cm = NULL,
                           path = "codemeta.json",
                           pretty = TRUE,
                           auto_unbox = TRUE,
                           version = "2",
                           ...) {

  if(is.null(cm)){
    cm <- create_codemeta(pkg = pkg, path = path, version = version)
  }
  jsonlite::write_json(cm, path, pretty = pretty, auto_unbox = auto_unbox, ...)

}

