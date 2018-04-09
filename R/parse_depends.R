## internal method for parsing a list of package dependencies into pkg URLs

format_depend <- function(package, version){
  dep <- list("@type" = "SoftwareApplication",
              identifier = package,
              ## FIXME technically the name includes the title
              name = package)

  ## Add Version if available
  if (version != "*"){
    dep$version <- version
  }

  dep$provider <- guess_provider(package)

  ## implemention could be better, e.g. support versioning
  #  dep$`@id` <- guess_dep_id(dep)
  dep
}

parse_depends <- function(deps) {

  unname(mapply(format_depend, deps$package, deps$version))
}


## FIXME these are not version-specific. That's often not accurate, though does reflect the CRAN assumption that you must be compatible with the latest version...
guess_dep_id <- function(dep) {
  if (dep$name == "R") {
    ## FIXME No good identifier for R, particularly none for specific version
    id <- "https://www.r-project.org"
  } else if (is.null(dep$provider)) {
    id <- NULL
  } else if (grepl("cran.r-project.org", dep$provider$url)) {
    id <- paste0(dep$provider$url, "/web/packages/", dep$identifier)
  } else if (grepl("www.bioconductor.org", dep$provider$url)) {
    id <-
      paste0(dep$provider$url,
             "/packages/release/bioc/html/",
             dep$identifier,
             ".html")
  } else {
    id <- NULL
  }

  id

}
