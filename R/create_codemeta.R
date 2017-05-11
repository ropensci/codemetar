
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

  ## legacy support only
  if(version == "1") return(cm)

  readme <- get_file("README.md", pkg)

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

