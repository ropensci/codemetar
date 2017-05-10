create_codemeta_v1 <- function(pkg = ".", id = NULL){

  descr <- read_dcf(pkg)
  ## FIXME define an S3 class based on the codemeta list of lists?
  if(is.null(id))
    id <- descr$Package

  codemeta <- list(
    identifier = id,
    `@context` = "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta.jsonld",
    `@type` = "SoftwareSourceCode")

  codemeta$title <- descr$Title
  codemeta$description <- descr$Description
  codemeta$name <- descr$Package
  codemeta$codeRepository <- descr$URL # descr$URL isn't necessarily a code repository, but crosswalk says this
  codemeta$issueTracker <- descr$BugReports

  ## According to crosswalk, codemeta$dateModified and codemeta$dateCreated are not crosswalked in R
  codemeta$datePublished <- descr$Date # probably not avaialable as descr$Date.
  codemeta$licenseId <- as.character(descr$License)
  codemeta$version <- descr$Version
  codemeta$programmingLanguage <- list(name = R.version$language,
                                       version = paste(R.version$major, R.version$minor, sep = "."), # According to Crosswalk, we just want numvers and not R.version.string
                                       URL = "https://r-project.org")

  ## FIXME Need to deal with: descr$Author, descr$Maintainer, and descr$Authors@R
  codemeta$agents <- parse_agents(descr)
  codemeta$suggests <- parse_depends(descr$Suggests)
  codemeta$depends <- c(parse_depends(descr$Imports), parse_depends(descr$Depends))

  codemeta
}

######### Helper functions #########


## based on devtools::read_dcf
read_dcf <- function(pkg) {

  ## Takes path to DESCRIPTION, to package root, or the package name as an argument
  path <- paste(pkg, "DESCRIPTION", sep="/")
  if(basename(pkg) == "DESCRIPTION")
    dcf <- pkg
  else if(file.exists(path)){
    dcf <- path
  } else {
    dcf <- system.file("DESCRIPTION", package = pkg)
  }

  fields <- colnames(read.dcf(dcf))
  as.list(read.dcf(dcf, keep.white = fields)[1, ])

  ## Alternate approach:
  ## utils::packageDescription assumes package is installed, takes pkg name not path.
  ## Advantages: Handles encoding, a little handling of Authors@R (actually done by install.packages step)
  ##descr <- utils::packageDescription(pkg)

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
    ## We want a NULL, not the full string, if no match is found
    nomatch  <- !grepl(pattern, str)
    versions[nomatch] <- NA

    ## one list item for each
    list(identifier = NULL,
         name = pkgs,
         version =  versions,
         packageSystem = "http://cran.r-project.org")
  })
}

## FIXME Parse generic Authors
parse_agents <- function(descr){

  if(!is.null( descr$`Authors@R`))
    authors <- eval(parse(text = descr$`Authors@R`))

  lapply(authors, function(p){
    list(`@id` = NULL,
         `@type` = "person",
         name = format(p, include=c("given", "family")),
         email = p$email,
         isMaintainer = "cre" %in% p$role,
         role = p$role)
  })
}

