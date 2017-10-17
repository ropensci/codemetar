#' write_codemeta
#'
#' write out a codemeta.json file for a given package.  This function
#' is basically a wrapper around create_codemeta() to both create the
#' codemeta object and write it out to a JSON-LD-formatted file in one command.
#' It can also be used simply to write out to JSON-LD any existing object
#' created with create_codemeta().
#'
#' @param pkg package path to package root, or package name, or
#' description file (character), or a codemeta object (list)
#' @param path file name of the output, leave at default "codemeta.json"
#' @param root if pkg is a codemeta object, optionally give the path
#'  to package root. Default guess is current dir.
#' @param id identifier for the package, e.g. a DOI (or other resolvable URL)
#' @param force_update Update guessed fields even if they are defined in an existing codemeta.json file
#' @param ...  additional arguments to \code{\link{write_json}}
#' @details If pkg is a codemeta object, the function will attempt to
#'  update any fields it can guess (i.e. from the DESRIPTION file),
#'  overwriting any existing data in that block. In this case, the package
#'  root directory should be the current working directory.
#' @return writes out the codemeta.json file
#' @export
#'
#' @importFrom jsonlite write_json
#' @importFrom devtools use_build_ignore
# upcoming devtools release will switch this to:
# @importFrom usethis use_build_ignore
#' @examples
#' write_codemeta("codemeta")
write_codemeta <- function(pkg = ".",
                           path = "codemeta.json",
                           root = ".",
                           id = NULL,
                           force_update =
                             getOption("codemeta_force_update", TRUE),
                           ...) {

  if(length(pkg) <= 1 && file.exists(file.path(pkg, "DESCRIPTION"))){
    devtools::use_build_ignore("codemeta.json", pkg = pkg)
    ## usethis::use_build_ignore("codemeta.json", base_path = pkg)
  }
  cm <- create_codemeta(pkg = pkg, root = root)
  jsonlite::write_json(cm, path, pretty=TRUE, auto_unbox = TRUE, ...)

}

