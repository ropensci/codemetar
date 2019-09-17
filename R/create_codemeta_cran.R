#' Create a codemeta list object from a CRAN Package DESCRIPTION file
#'
#' @param name
#'   (character) Name of CRAN package.
#' @param version
#'   (character) Version of CRAN package. Defaults to "newest" version.
#' @return
#'   (list) A \code{codemeta} list object.
#' @export
#' @examples
#' \dontrun{
#' # Create codemeta for the newest package version
#' cm <- create_codemeta_cran("EML")
#'
#' # Create codemeta for a specific package version
#' cm <- create_codemeta_cran("EML", "1.0.3")
#' }
#'
create_codemeta_cran <- function(name, version = NULL) {

  # Create URL to package source on CRAN
  vers <- try(crandb::package(name, version)$Version, silent = TRUE)
  if (class(vers) == "try-error") {
    stop(paste0(version, " is not a valid version of the ", name, " package."))
  }
  newest_vers <- crandb::package(name)$Version
  if (vers != newest_vers) {
    src_url <- paste0(
      "https://cran.r-project.org/src/contrib/Archive/", name, "/", name, "_",
      vers, ".tar.gz"
    )
  } else {
    src_url <- paste0(
      "https://cran.r-project.org/src/contrib/", name ,"_", vers, ".tar.gz"
    )
  }

  # Download package source to tempdir(), create codemeta from the DESCRIPTION,
  # then write and validate codemeta.json.
  message("Downloading source code from CRAN to temporary directory")
  suppressMessages(
    utils::download.file(
      url = src_url,
      destfile = paste0(tempdir(), "/", name, ".tar.gz")
    )
  )
  utils::untar(
    paste0(tempdir(), "/", name, ".tar.gz"),
    exdir = paste0(tempdir(), "/", name)
  )
  message("Creating codemeta.json from DESCRIPTION file")
  suppressMessages(
    cm <- codemetar::create_codemeta(
      paste0(tempdir(), "/", name, "/", name)
    )
  )
  jsonlite::write_json(
    cm,
    path = paste0(tempdir(), "/codemeta.json"),
    pretty = TRUE,
    auto_unbox = TRUE
  )
  message("Validating codemeta.json")
  is_codemeta <- codemeta_validate(
    paste0(tempdir(), "/codemeta.json")
  )
  if (isFALSE(is_codemeta)) {
    stop(paste0("codemeta.json of ", name, ".", version, " is invalid."))
  }

  # Read codemeta.json and clean up tempdir()
  cm <- jsonlite::read_json(paste0(tempdir(), "/codemeta.json"))
  message("Cleaning up temporary directory")
  unlink(paste0(tempdir(), "/", name, ".tar.gz"), force = TRUE)
  unlink(paste0(tempdir(), "/", name), recursive = TRUE, force = TRUE)
  unlink(paste0(tempdir(), "/codemeta.json"), force = TRUE)

  message("Done")
  cm

}
