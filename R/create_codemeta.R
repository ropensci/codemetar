
#' create_codemeta
#'
#' create a codemeta list object in R for further manipulation. Similar
#' to \code{\link{write_codemeta}}, but returns an R list object rather
#' than writing directly to a file.  See examples.
#'
#' @inheritParams write_codemeta
#' @return a codemeta list object
#' @export
#' @examples
#' \donttest{
#' cm <- create_codemeta("jsonlite")
#' cm$keywords <- list("metadata", "ropensci")
#' }
#' @importFrom jsonlite read_json
create_codemeta <- function(
  pkg = ".",
  root = ".",
  id = NULL,
  use_filesize = TRUE,
  force_update =
    getOption("codemeta_force_update", TRUE),
  verbose = TRUE,
  ...
) {

  ## looks like we got a package name/path or Description file
  if (is.character(pkg)) {

    root <- get_root_path(pkg)

    # Set string constants
    json_file <- get_file("codemeta.json", root)

    ## no cm provided, but codemeta.json found in pkg
    cm <- if (file.exists(json_file)) {

      ## Our package has an existing codemeta.json to update
      jsonlite::read_json(json_file)

      ## no cm, no existing codemeta.json found, start fresh
    } else {

      new_codemeta()
    }

    ## we got an existing codemeta object as pkg
  } else if (is.list(pkg)) {

    cm <- pkg

    ## root should be set already, we might check that root has a DESCRIPTION,
    ## but if not, methods below should return NULLs rather than error anyhow
    root <- get_root_path(root)
  }

  if (verbose) {

    root <- get_root_path(pkg)
    opinions <- give_opinions(root)

    if (! is.null(opinions)) {

      message(
        "Some elements could be improved, see our opinions via give_opinions('",
        root, "')"
      )
    }
  }

  ## get information from DESCRIPTION
  cm <- codemeta_description(file.path(root, "DESCRIPTION"), id = id, cm)

  ## Guess these only if not set in current codemeta
  if ((is.null(cm$codeRepository) && force_update)) {

    cm$codeRepository <- guess_github(root)
  }

  if ((is.null(cm$releaseNotes) || force_update)) {

    cm$releaseNotes <- guess_releaseNotes(root)
  }

  if ((is.null(cm$readme) || force_update)) {

    cm$readme <- guess_readme(root)$readme_url
  }

  if (use_filesize) {

    if ((is.null(cm$fileSize) || force_update)) {

      cm$fileSize <- guess_fileSize(root)
    }
  }

  # and if there's a readme
  readme <- guess_readme(root)$readme_path

  if (! is.null(readme) && force_update) {

    cm <- codemeta_readme(readme, codemeta = cm)
  }

  ## If code repo is GitHub
  if (grepl("github.com\\/.*\\/.*", cm$codeRepository)) {

    cm <- add_github_topics(cm)
  }

  ## Citation metadata
  if (is.character(pkg)) {  ## Doesn't apply if pkg is a list (codemeta object)

    cm$citation <- guess_citation(pkg)

    # set string constant
    url_schema <- "http://schema.org"

    ## citations need schema.org context!
    ## see https://github.com/codemeta/codemeta/issues/155
    if (! any(grepl(url_schema, cm$`@context`))) {

      cm$`@context` <- c(cm$`@context`, url_schema)
    }
  }

  ## Add provider link as relatedLink
  # Priority is given to the README
  # alternatively to installed packages

  provider <- guess_provider(cm$identifier)

  if (! is.null(provider)) {

    readme <- guess_readme(root)$readme_path

    if (! is.null(readme)) {

      badges <- extract_badges(readme)

      if (! is.null(provider) &&
          whether_provider_badge(badges, provider$name)) {

        cm <- set_relatedLink_1(cm, provider)
      }
    } else if (cm$identifier %in% installed_package_names()) {

      pkg_info <- sessioninfo::package_info(cm$identifier)
      pkg_info <- pkg_info[pkg_info$package == cm$identifier, ]
      provider_name <- pkg_info$source

      if (cm$version == pkg_info$ondiskversion) {

        cm <- set_relatedLink_2(cm, provider_name)
      }
    }
  }

  ## Add blank slots as placeholders? and declare as an S3 class?
  cm
}

# set_relatedLink_1 ------------------------------------------------------------
set_relatedLink_1 <- function(codemeta, provider) {

  if (provider$name == "Comprehensive R Archive Network (CRAN)") {

    codemeta$relatedLink <- unique(c(
      codemeta$relatedLink, get_url_cran_package(codemeta$identifier)
    ))

  } else if (provider$name == "BioConductor") {

    codemeta$relatedLink <- unique(c(
      codemeta$relatedLink, get_url_bioconductor_package(codemeta$identifier)
    ))
  }

  codemeta
}

# set_relatedLink_2 ------------------------------------------------------------
set_relatedLink_2 <- function(codemeta, provider_name) {

  if (grepl("CRAN", provider_name)) {

    codemeta$relatedLink <- unique(c(
      codemeta$relatedLink, get_url_cran_package(codemeta$identifier)
    ))

  } else if (grepl("Bioconductor", provider_name)) {

    codemeta$relatedLink <- unique(c(
      codemeta$relatedLink, get_url_bioconductor_package(codemeta$identifier)
    ))

  } else if (grepl("Github", provider_name)) {

    # if GitHub try to build the URL to commit or to repo in general
    if (grepl("@", provider_name)) {

      codemeta$relatedLink <- unique(c(
        codemeta$relatedLink, get_url_github_package(provider_name)
      ))
    }
  }

  codemeta
}
