
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
                            version = "2",
                            ...){

  ## looks like we got a package name/path or Description file in pkg.  Can use this as root path.
  if(is.character(pkg)){
    root <- pkg

    ## no cm provided, but codemeta.json found in pkg
    if(file.exists(get_file("codemeta.json", root))){  ## Our package has an existing codemeta.json to update
      cm <- jsonlite::read_json(get_file("codemeta.json", root))

    ## no cm, no existing codemeta.json found, start fresh
    } else {
      cm <- new_codemeta()
    }

  ## we got an existing codemeta object as pkg
  } else if(is.list(pkg)){
    cm <- pkg
    ## root should be set already, we might check that root has a DESCRIPTION,
    ## but if not, methods below should return NULLs rather than error anyhow
  }


  descr <- read_dcf(root)
  cm <- import_pkg_description(descr = descr, cm = cm, version = version)

  ## legacy support only
  if(version == "1") return(cm)

  readme <- get_file("README.md", root)

  cm$contIntegration <- guess_ci(readme)
  cm$developmentStatus <- guess_devStatus(readme)
  cm$provider <- guess_provider(cm$name)


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

