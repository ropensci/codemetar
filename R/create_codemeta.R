
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
#' cm <- create_codemeta("jsonlite")
#' cm$keywords <- list("metadata", "ropensci")
#' @importFrom jsonlite read_json
create_codemeta <- function(pkg = ".",
                            root = ".",
                            id = NULL,
                            force_update =
                              getOption("codemeta_force_update", TRUE),
                            verbose = TRUE,
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

  if(verbose){
    opinions <- give_opinions(root)
    if(!is.null(opinions))
    message(paste0("Some elements could be improved, see our opinions via give_opinions('", root, "')"))
  }

  cm <-
    codemeta_description(file.path(root, "DESCRIPTION"), id = id, cm)

  ## Guess these only if not set in current codemeta:
  if ((is.null(cm$codeRepository) & force_update)){
    cm$codeRepository <- guess_github(root)
  }

  if ((is.null(cm$contIntegration) | force_update)){
    cm$contIntegration <- guess_ci(file.path(root, "README.md"))
  }

  if ((is.null(cm$developmentStatus) | force_update)){
    cm$developmentStatus <-
    guess_devStatus(file.path(root, "README.md"))
  }

  if ((is.null(cm$review) | force_update)){
    cm$review <-
      guess_ropensci_review(file.path(root, "README.md"))
  }

  if ((is.null(cm$releaseNotes) | force_update)){
    cm$releaseNotes <- guess_releaseNotes(root)
  }

  if ((is.null(cm$readme) | force_update)){
    cm$readme <- guess_readme(root)
  }

  if ((is.null(cm$fileSize) | force_update)){
    cm$fileSize <- guess_fileSize(root)
  }

  ## Citation metadata
  if(is.character(pkg)){  ## Doesn't apply if pkg is a list (codemeta object)
    cm$citation <- guess_citation(pkg)
    ## citations need schema.org context!
    ## see https://github.com/codemeta/codemeta/issues/155
    if(!any(grepl("http://schema.org", cm$`@context`))){
      cm$`@context` <- c(cm$`@context`, "http://schema.org")
    }
  }

  # Add provider link as relatedLink
  if(is.character(pkg)){
    pkg_info <- sessioninfo::package_info(cm$identifier)
    pkg_info <- pkg_info[pkg_info$package == cm$identifier,]
    provider_name <- pkg_info$source
    if(grepl("CRAN", provider_name)){
      cm$relatedLink <- unique(c(cm$relatedLink,
                                 paste0("https://CRAN.R-project.org/package=",
                                        cm$identifier)))
    }else{
      if(grepl("Bioconductor", provider_name)){
        cm$relatedLink <- unique(c(cm$relatedLink,
                                   paste0("https://bioconductor.org/packages/release/bioc/html/",
                                          cm$identifier, ".html")))
      }else{
        # if GitHub try to build the URL to commit or to repo in general
        if(grepl("Github", provider_name)){
          if(grepl("@", provider_name)){
            commit <- gsub(".*@", "", provider_name)
            commit <- gsub("\\)", "", commit)
            link <- gsub(".*\\(", "", provider_name)
            link <- gsub("@.*", "", link)
            cm$relatedLink <- unique(c(cm$relatedLink,
                                       paste0("https://github.com/", link,
                           "/commit/", commit)))
          }
        }
      }
    }
  }else{
    provider <- guess_provider(cm$identifier)

    readme <- guess_readme(root)
    if(!is.null(readme)){
      badges <- extract_badges(readme)
      if(!is.null(provider) &
         whether_provider_badge(badges,
                                provider$name)){
        if(provider$name == "Comprehensive R Archive Network (CRAN)"){
          cm$relatedLink <- unique(c(cm$relatedLink,
                                     paste0("https://CRAN.R-project.org/package=",
                                            cm$identifier)))
        }else{
          if(provider$name == "BioConductor"){
            cm$relatedLink <- unique(c(cm$relatedLink,
                                       paste0("https://bioconductor.org/packages/release/bioc/html/",
                                              cm$identifier, ".html")))
          }
        }
      }
    }
  }


  ## Add blank slots as placeholders? and declare as an S3 class?

  cm
}
