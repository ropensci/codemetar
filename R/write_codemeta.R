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


#' create_codemeta
#'
#' create a codemeta list object in R for further manipulation
#' @inheritParams write_codemeta
#' @return a codemeta list object
#' @export
#' @examples
#' cm <- create_codemeta("jsonlite")
#' cm$keywords <- list("metadata", "ropensci")
#' write_codemeta(cm = cm)
create_codemeta <- function(pkg = ".",
                            path = "codemeta.json",
                            version = "2",
                            ...){

  cm <- new_codemeta()
  descr <- read_dcf(pkg)
  cm <- import_pkg_description(descr = descr, cm = cm, version = version)

  if(version != "1"){
    #cm <- guess_ci(cm, pkg)
    cm <- guess_published(cm)
  }

  ## Add blank slots as placeholders? and declare as an S3 class?

  cm
}


## generate codemeta.json from a DESCRIPTION file
## FIXME parse and use crosswalk to reference DESCRIPTION terms?
import_pkg_description <-
  function(descr,
           id = NULL,
           cm = new_codemeta(),
           version = "2") {
    version <- as.character(version)



    switch(version,
           "2" = codemeta_description(descr, id, cm),
           "1" = create_codemeta_v1(descr, id))

  }

