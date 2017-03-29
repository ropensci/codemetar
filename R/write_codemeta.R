




write_codemeta <- function(pkg = ".", x = NULL, path, ...) {

  jsonlite::write_json(x, path, ...)
}


## based on devtools::read_dcf
read_dcf <- function(path) {
  fields <- colnames(read.dcf(path))
  as.list(read.dcf(path, keep.white = fields)[1, ])
}

create_codemeta <- function(pkg = "."){

  path <- paste(pkg, "DESCRIPTION", sep = "/")
  descr <- read_dcf(path)

  ## Assumes package is installed, pkg is Character string naming a single package.  Handles encoding, a little handling of Authors@R (actually done by install.packages step)
  ##descr <- utils::packageDescription(pkg)

    ## Use example as a template for now.
  ex <- "https://raw.githubusercontent.com/codemeta/codemeta/master/examples/example-codemeta-full.json"
  codemeta <- jsonlite::read_json(ex)

  ## FIXME generate using a canonical form (e.g. frames, flattened).  NOTE: flattened means we can use a data.frame as our object
  ## NO, this is terribly confusing
  ## codemeta <- jsonlite::fromJSON(jsonld::jsonld_flatten(ex))
  ## codemeta <- jsonlite::fromJSON(jsonld::jsonld_compact(ex))


  ## FIXME define an S3 class based on the codemeta list of lists?

  codemeta$title <- descr$Title
  codemeta$description <- descr$Description
  codemeta$name <- descr$Package
  codemeta$codeRepository <- descr$URL # Not necessarily
  codemeta$issueTracker <- descr$BugReports
  codemeta$datePublished <- descr$Date # probably not avaialable as descr$Date.
  codemeta$licenseId <- as.character(descr$License)
  codemeta$version <- descr$Version
  codemeta$programmingLanguage <- list(name = R.version$language,
                                       version = paste(R.version$major, R.version$minor, sep = "."), # R.version.string?
                                       URL = "https://r-project.org")

  ## Need to deal with: descr$Author, descr$Maintainer, and descr$Authors@R
  codemeta$agents <- parse_agents(descr)


  codemeta$suggests <- parse_depends(descr$Suggests)
  codemeta$depends <- c(parse_depends(descr$Imports), parse_depends(descr$Depends))
}


parse_depends <- function(deps){
  if(!is.null(deps))
    str <- strsplit(deps, ",\n*")[[1]]
  else
    str <- NULL

  lapply(str, function(str){

    ## this is vectorized, though we apply it pkg by pkg anyhow

    pkgs <- gsub("\\s*(\\w+)\\s.*", "\\1", str)
    pattern <- "\\s*\\w+\\s+\\([><=]+\\s([1-9.\\-]*)\\)*"
    versions <- gsub(pattern, "\\1", str)
    ## We want an empty string, not the full string, if no match is found
    nomatch  <- !grepl(pattern, str)
    versions[nomatch] <- ""

    ## one list item for each
    list(identifier = NULL,
         name = pkgs,
         version =  versions,
         packageSystem = "http://cran.r-project.org")
  })
}
