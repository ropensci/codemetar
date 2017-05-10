#' write_codemeta
#' @param pkg package description file, can be path or package name.
#' @param id an id for the package, such as the Zenodo DOI. a UUID will be generated if none is provided
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
                           id = NULL,
                           path = "codemeta.json",
                           pretty = TRUE,
                           auto_unbox = TRUE,
                           version = "2",
                           ...) {

  descr <- read_dcf(pkg)
  cm <- import_pkg_description(descr = descr, id = id, version = version)

  jsonlite::write_json(cm, path, pretty = pretty, auto_unbox = auto_unbox, ...)

}




## generate codemeta.json from a DESCRIPTION file
## FIXME parse and use crosswalk to reference DESCRIPTION terms?
import_pkg_description <-
  function(descr,
           id = NULL,
           codemeta = new_codemeta(),
           version = "2") {
    version <- as.character(version)



    switch(version,
           "2" = codemeta_description(descr, id = id, codemeta = codemeta),
           "1" = create_codemeta_v1(descr, id))

  }

