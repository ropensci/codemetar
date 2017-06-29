

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
                            force_update =
                              getOption("codemeta_force_update", TRUE),
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

  ## Guess these only if not set in current codemeta:
  if (is.null(cm$codeRepository) | force_update)
    cm$codeRepository <- guess_github(root)
  if (is.null(cm$contIntegration) | force_update)
    cm$contIntegration <- guess_ci(file.path(root, "README.md"))
  if (is.null(cm$developmentStatus) | force_update)
    cm$developmentStatus <-
    guess_devStatus(file.path(root, "README.md"))
  if (is.null(cm$releaseNotes) | force_update)
    cm$releaseNotes <- guess_releaseNotes(root)
  if (is.null(cm$readme) | force_update)
    cm$readme <- guess_readme(root)
  if (is.null(cm$fileSize) | force_update)
    cm$fileSize <- guess_fileSize(root)


  ## Citation metadata
  if(is.character(pkg)){  ## Doesn't apply if pkg is a list (codemeta object)
    cm$citation <- guess_citation(pkg)
    ## citations need schema.org context!
    ## see https://github.com/codemeta/codemeta/issues/155
    cm$`@context` <- c(cm$`@context`, "http://schema.org")
  }
  ## Add blank slots as placeholders? and declare as an S3 class?

  cm
}
