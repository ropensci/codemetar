




#' write_codemeta
#' @param pkg package description file, can be path or package name.
#' @param id an id for the package, such as the Zenodo DOI. a UUID will be generated if none is provided
#' @param path file name of the output, leave at default "codemeta.json"
#' @param pretty formatting option to \code{\link{write_json}}
#' @param auto_unbox formatting  option to \code{\link{write_json}}
#' @param ...  additional arguments to \code{\link{write_json}}
#'
#' @return writes out the codemeta.json file
#' @export
#'
#' @importFrom jsonlite write_json
#' @importFrom uuid UUIDgenerate
#' @examples
#' write_codemeta("codemetar")
write_codemeta <- function(pkg = ".",
                           id = uuid::UUIDgenerate(),
                           path = "codemeta.json",
                           pretty = TRUE,
                           auto_unbox = TRUE,
                           ...) {

  x <-create_codemeta(pkg = pkg, id = id)
  jsonlite::write_json(x, path, pretty = pretty, auto_unbox = auto_unbox, ...)

  }




## based on devtools::read_dcf
read_dcf <- function(path) {
  fields <- colnames(read.dcf(path))
  as.list(read.dcf(path, keep.white = fields)[1, ])
}



## generate codemeta.json from a DESCRIPTION file

## FIXME parse and use crosswalk to reference DESCRIPTION terms?
create_codemeta <- function(pkg = ".", id = uuid::UUIDgenerate()){

  ## Takes path to DESCRIPTION, to package root, or the package name as an argument
  path <- paste(pkg, "DESCRIPTION", sep="/")
  if(basename(pkg) == "DESCRIPTION")
    descr <- read_dcf(pkg)
  else if(file.exists(path)){
    descr <- read_dcf(path)
  } else {
    descr <- read_dcf(system.file("DESCRIPTION", package = pkg))
  }

  ## Alternate approach:
  ## utils::packageDescription assumes package is installed, takes pkg name not path.
  ## Advantages: Handles encoding, a little handling of Authors@R (actually done by install.packages step)
  ##descr <- utils::packageDescription(pkg)

  ## FIXME define an S3 class based on the codemeta list of lists?

  ## Just use example template for now.
  # ex <- "https://raw.githubusercontent.com/codemeta/codemeta/master/examples/example-codemeta-full.json"
  # codemeta <- jsonlite::read_json(ex)

  codemeta <- list(
    identifier = id,
    `@context` = "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta.jsonld",
    `@type` = "SoftwareSourceCode")

  ## FIXME generate using a canonical form (e.g. frames, flattened).  NOTE: flattened means we can use a data.frame as our object
  ## NO, this is terribly confusing
  ## codemeta <- jsonlite::fromJSON(jsonld::jsonld_flatten(ex))
  ## codemeta <- jsonlite::fromJSON(jsonld::jsonld_compact(ex))



  ## Fill in basic info from description -- FIXME Confirm this obeys crosswalk!
  codemeta$title <- descr$Title
  codemeta$description <- descr$Description
  codemeta$name <- descr$Package
  codemeta$codeRepository <- descr$URL # Not necessarily -- check CrossWalk
  codemeta$issueTracker <- descr$BugReports

  ## Better to choose just one?  Use published only if on CRAN? Or published to zenodo counts?
  codemeta$datePublished <- descr$Date # probably not avaialable as descr$Date. check CrossWalk
  codemeta$dateCreated <- descr$Date # probably not avaialable as descr$Date.
  codemeta$dateModified <- descr$Date


  codemeta$licenseId <- as.character(descr$License)
  codemeta$version <- descr$Version
  codemeta$programmingLanguage <- list(name = R.version$language,
                                       version = paste(R.version$major, R.version$minor, sep = "."), # R.version.string?
                                       URL = "https://r-project.org")

  ## Need to deal with: descr$Author, descr$Maintainer, and descr$Authors@R
  codemeta$agents <- parse_agents(descr)


  codemeta$suggests <- parse_depends(descr$Suggests)
  codemeta$depends <- c(parse_depends(descr$Imports), parse_depends(descr$Depends))

  codemeta
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

