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
#' @param verbose Whether to print messages indicating opinions e.g. when DESCRIPTION has no URL. See \code{\link{give_opinions}}.
#' @param ...  additional arguments to \code{\link{write_json}}
#' @details If pkg is a codemeta object, the function will attempt to
#'  update any fields it can guess (i.e. from the DESRIPTION file),
#'  overwriting any existing data in that block. In this case, the package
#'  root directory should be the current working directory.
#'
#' When creating and writing a codemeta.json for the first time,
#' the function adds "codemeta.json" to .Rbuildignore and, if the
#' project uses git, adds a pre-commit hook ensuring that if DESCRIPTION changes,
#'  the codemeta.json will be updated as well unless the DESCRIPTION change is committed
#'  with 'git commit --no-verify'.
#' @return writes out the codemeta.json file
#' @export
#'
#' @examples
#' \dontrun{
#' write_codemeta("codemetar", path = "example_codemetar_codemeta.json")
#' }
write_codemeta <- function(pkg = ".",
                           path = "codemeta.json",
                           root = ".",
                           id = NULL,
                           force_update =
                             getOption("codemeta_force_update", TRUE),
                           verbose = TRUE,
                           ...) {

  # things that only happen inside a package folder
  if(length(pkg) <= 1 && is_package(pkg)){

    if(path == "codemeta.json"){
      # if path is something else hopefully the user know what they are doing
      usethis::use_build_ignore("codemeta.json")
    }

    # add the git pre-commit hook
    # https://github.com/r-lib/usethis/blob/master/inst/templates/readme-rmd-pre-commit.sh#L1
    # this is GPL-3 code
    if (uses_git() & path == "codemeta.json") {
      if(!file.exists(file.path(pkg, "codemeta.json"))){
        message("* Adding a pre-commit git hook ensuring that codemeta.json will be synchronized with DESCRIPTION") # nolint
        usethis::use_git_hook(
          "pre-commit",
          render_template("description-codemetajson-pre-commit.sh")
        )
        message(
          "* Include the following code somewhere in R/ in your package, this way devtools::release() will remind you to update codemeta.json.\n",
          '  release_questions <- function() "Have you updated codemeta.json with codemetar::write_codemeta()?"')
      }

    }
  }
  cm <- create_codemeta(pkg = pkg, root = root)
  write_json(cm, path, pretty=TRUE, auto_unbox = TRUE, ...)


}

# from https://github.com/jeroen/jsonlite/blob/1f9e609e7d0ed702ede9c82aa5482ba08d5e5ab2/R/read_json.R#L22
write_json <- function(x, path, ...) {
  json <- jsonlite::toJSON(x, ...)
  writeLines(json, path, useBytes = TRUE)
}
