#' write_codemeta
#'
#' write out a codemeta.json file for a given package.  This function is
#' basically a wrapper around create_codemeta() to both create the codemeta
#' object and write it out to a JSON-LD-formatted file in one command. It can
#' also be used simply to write out to JSON-LD any existing object created with
#' `create_codemeta()`.
#'
#' @includeRmd man/rmdhunks/whybother.Rmd
#' @includeRmd man/rmdhunks/uptodate.Rmd
#'
#' @param pkg package path to package root, or package name, or description file
#'   (character), or a codemeta object (list)
#' @param path file name of the output, leave at default "codemeta.json"
#' @param root if pkg is a codemeta object, optionally give the path to package
#'   root. Default guess is current dir.
#' @param id identifier for the package, e.g. a DOI (or other resolvable URL)
#' @param use_filesize whether to try to estimating and adding a filesize by using
#'   \code{base::files.ize()}. Files in \code{.Rbuildignore} are ignored.
#' @param force_update Update guessed fields even if they are defined in an
#'   existing codemeta.json file
#' @param use_git_hook Deprecated argument.
#' @param verbose Whether to print messages indicating opinions e.g. when
#'   DESCRIPTION has no URL. See \code{\link{give_opinions}}.
#' @param ...  additional arguments to \code{\link{write_json}}
#' @section Technical details:
#'  If pkg is a codemeta object, the function will attempt to update any
#'   fields it can guess (i.e. from the DESCRIPTION file), overwriting any
#'   existing data in that block. In this case, the package root directory
#'   should be the current working directory.
#'
#' @return writes out the codemeta.json file
#' @export
#'
#' @examples
#' \donttest{
#' write_codemeta("codemetar", path = "example_codemetar_codemeta.json")
#' }
write_codemeta <- function(
  pkg = ".", path = "codemeta.json", root = ".", id = NULL, use_filesize = FALSE,
  force_update = getOption("codemeta_force_update", TRUE), use_git_hook = NULL,
  verbose = TRUE, ...
) {

  if (!missing(use_git_hook)) {
    warning("The use_git_hook argument is deprecated and ignored.")
  }

  codemeta_json <- "codemeta.json"

  # Things that only happen inside a package folder...
  in_package <- length(pkg) <= 1 && is_package(pkg) && pkg %in% c(getwd(), ".")

  # ... and when the output file is codemeta.json. If path is something else
  # hopefully the user know what they are doing.
  if (in_package && path == codemeta_json) {

    usethis::use_build_ignore(codemeta_json)
  }
  # Create or update codemeta and save to disk
  create_codemeta(pkg = pkg, root = root, use_filesize = use_filesize) %>%
    jsonlite::write_json(path, pretty = TRUE, auto_unbox = TRUE, ...)
}
