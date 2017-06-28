

#' create_codemeta
#'
#' create a codemeta list object in R for further manipulation
#' @inheritParams write_codemeta
#' @return a codemeta list object
#' @export
#' @examples
#' cm <- create_codemeta("jsonlite")
#' cm$keywords <- list("metadata", "ropensci")
#' write_codemeta(cm)
#' @importFrom jsonlite read_json
create_codemeta <- function(pkg = ".",
                            root = ".",
                            id = NULL,
                            ...) {
  ## looks like we got a package name/path or Description file
  if (is.character(pkg)) {
    root <- get_root_path(pkg)


    ## no cm provided, but codemeta.json found in pkg
    if (file.exists(get_file("codemeta.json", root))) {
      ## Our package has an existing codemeta.json to update
      cm <- jsonlite::read_json(get_file("codemeta.json", root))

      ## no cm, no existing codemeta.json found, start fresh
    } else {
      cm <- new_codemeta()
    }

    ## we got an existing codemeta object as pkg
  } else if (is.list(pkg)) {
    cm <- pkg

    ## root should be set already, we might check that root has a DESCRIPTION,
    ## but if not, methods below should return NULLs rather than error anyhow
    root <- get_root_path(root)

  }

  cm <-
    codemeta_description(file.path(root, "DESCRIPTION"), id = id, cm)

  ## Guess these if not set in description:
  if (is.null(cm$codeRepository))
    cm$codeRepository <- guess_github(root)
  if (is.null(cm$issuesTracker) && isTRUE(grepl("github", cm$URL)))
    cm$issuesTracker <- paste(cm$URL, "issues", sep = "/")
  if (is.null(cm$contIntegration))
    cm$contIntegration <- guess_ci(file.path(root, "README.md"))
  if (is.null(cm$developmentStatus))
    cm$developmentStatus <-
    guess_devStatus(file.path(root, "README.md"))
  if (is.null(cm$releaseNotes))
    cm$releaseNotes <- guess_releaseNotes(root)
  if (is.null(cm$readme))
    cm$readme <- guess_readme(root)
  if (is.null(cm$fileSize))
    cm$fileSize <- guess_fileSize(root)

  ## Add blank slots as placeholders? and declare as an S3 class?

  cm
}
