## internal method for parsing a list of package dependencies into pkg URLs



parse_depends <- function(deps) {
  if (!is.null(deps))
    str <- strsplit(deps, ",\n*")[[1]]
  else
    str <- NULL

  lapply(str, function(str) {
    if (length(str) > 1) {
      warning(paste0("package depends", str, "may be multiple packages?"))
    }

    pkg <- gsub("\\s*(\\w+)\\s.*", "\\1", str)
    pkg <- gsub("\\s+", "", pkg)

    dep <- list("@type" = "SoftwareApplication",
                identifier = pkg,
                ## FIXME technically the name includes the title
                name = pkg)

    ## Add Version if available
    pattern <- "\\s*\\w+\\s+\\([><=]+\\s([1-9.\\-]*)\\)*"
    version <-  gsub(pattern, "\\1", str)
    version <-
      gsub("\\)$", "", version)  ## hack, avoid extraneous ending )
    has_version  <- grepl(pattern, str)
    if (has_version)
      dep$version <- version

    dep$provider <- guess_provider(pkg)

    ## implemention could be better, e.g. support versioning
    #  dep$`@id` <- guess_dep_id(dep)
    dep
  })
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
