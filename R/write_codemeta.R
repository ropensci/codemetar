




write_codemeta <- function(pkg = ".", x = NULL, path, ...) {

  jsonlite::write_json(x, path, ...)
}


create_codemeta <- function(pkg){
  #path <- paste(pkg, "DESCRIPTION", sep = "/")
  #descr <- as.data.frame(read.dcf(path))


  ## Assumes package is installed, pkg is Character string naming a single package.  Handles encoding, a little handling of Authors@R (actually done by install.packages step)
  ##descr <- utils::packageDescription(pkg)
}



## Use example as a template for now.
ex <- "https://raw.githubusercontent.com/codemeta/codemeta/master/examples/example-codemeta-full.json"
#codemeta <- jsonlite::read_json(ex)
codemeta <- jsonlite::fromJSON(jsonld::jsonld_flatten(ex))

codemeta <- jsonlite::fromJSON(jsonld::jsonld_compact(ex))


## FIXME define an S3 class based on the codemeta list of lists?

## FIXME generate using a canonical form (e.g. frames, flattened).  NOTE: flattened means we can use a data.frame as our object

## FIXME parsing of codemeta.jsonld into the standard, predictable object should always pass through a standardized jsonld transformation first



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
codemeta$suggests
## Need to deal with: descr$Author, descr$Maintainer, and descr$Authors@R
# codemeta$agents <- parse_agents(descr)


codemeta$suggests <- parse_depends(descr$Suggests)
codemeta$depends <- c(parse_depends(descr$Imports), parse_depends(descr$Depends))

parse_depends <- function(descr)

  imports
  depends
  suggests

list(identifier = NULL,
     name = ,
     version =  ,
     packageSystem = "http://cran.r-project.org",
     operatingSystems = NULL)
