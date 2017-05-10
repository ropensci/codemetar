

## Supporting old versions will be a nuciance
new_codemeta <- function(){
  ## FIXME context should be DOI
  list(`@context` = "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta.jsonld",
       `@type` = "SoftwareSourceCode")

}


is_IRI <- function(string){
  ## FIXME IRI can be many other things too
  grepl("^http[s]?://", string)
}


# Can add to an existing codemeta document
create_codemeta_v2 <-  function(pkg = ".", id = NULL, codemeta = new_codemeta()){

  descr <- read_dcf(pkg)
  ## FIXME define an S3 class based on the codemeta list of lists?
  if(is.null(id)){
    id <- descr$Package
  }

  if(is_IRI(id)){
    codemeta$`@id` <- id
  } else {
    codemeta$identifier <- id
  }


  codemeta$title <- descr$Title
  codemeta$description <- descr$Description
  codemeta$name <- descr$Package
  codemeta$codeRepository <- descr$URL # descr$URL isn't necessarily a code repository, but crosswalk says this
  codemeta$issueTracker <- descr$BugReports

  ## According to crosswalk, codemeta$dateModified and codemeta$dateCreated are not crosswalked in R
  codemeta$datePublished <- descr$Date # probably not avaialable as descr$Date.

  ## license is a URL in schema.org, assume SPDX ID (though not all recognized CRAN abbreviations are valid SPDX strings)
  codemeta$license <- paste0("https://spdx.org/licenses/", as.character(descr$License))
  codemeta$version <- descr$Version
  codemeta$programmingLanguage <- list(name = R.version$language,
                                       version = paste(R.version$major, R.version$minor, sep = "."), # According to Crosswalk, we just want numvers and not R.version.string
                                       URL = "https://r-project.org")
  ## According to schema.org, programmingLanguage doesn't have a version; but runtimePlatform, a plain string, does.  Of course this is less computable/structured:
  codemeta$runtimePlatform <- R.version.string

  ## FIXME Need to deal with: descr$Author, descr$Maintainer, and descr$Authors@R
  if("Authors@R" %in% names(descr))
    codemeta <- parse_authors_at_R(codemeta, descr)

  #codemeta$author <- descr$Author
#  codemeta$maintainer <- descr$Maintainer
  codemeta$suggests <- parse_depends_v2(descr$Suggests)
  codemeta$depends <- c(parse_depends_v2(descr$Imports), parse_depends_v2(descr$Depends))

  codemeta

}

parse_authors_at_R <- function(codemeta, descr){
  person_string <- descr$`Authors@R`
  people <- eval(parse(text = person_string))

  codemeta$author <- lapply(people[ locate_role(people, "aut") ], person_to_schema)
  codemeta$copyrightHolder <- lapply(people[ locate_role(people, "cph") ], person_to_schema)
  codemeta$maintainer <- person_to_schema(people[ locate_role(people, "cre") ])
  codemeta
}

locate_role <- function(people, role = "aut"){
  vapply(people, function(p) any(grepl(role, p$role)), logical(1))
}

person_to_schema <- function(p){
  list(givenName = p$given,
       familyName = p$family,
       email = p$email)
}


#' @importFrom utils available.packages contrib.url
parse_depends_v2 <- function(deps){
  if(!is.null(deps))
    str <- strsplit(deps, ",\n*")[[1]]
  else
    str <- NULL

  out <- lapply(str, function(str){

    ## this is vectorized, though we apply it pkg by pkg anyhow

    pkgs <- gsub("\\s*(\\w+)\\s.*", "\\1", str)
    pattern <- "\\s*\\w+\\s+\\([><=]+\\s([1-9.\\-]*)\\)*"
    versions <- gsub(pattern, "\\1", str)
    ## We want a NULL, not the full string, if no match is found
    nomatch  <- !grepl(pattern, str)
    versions[nomatch] <- NA

    pkgs <- gsub("\\s+", "", pkgs)

    ## Check if pkg is on CRAN
    avail <- utils::available.packages(utils::contrib.url("https://cran.rstudio.com", "source"))
    if(all(pkgs %in% avail[,"Package"]))
      paste0("https://cran.r-project.org/package=", pkgs)
    else{
      message(paste("could not find URL for package", pkgs, "since it is not available on CRAN."))
    }
      pkgs
  })

  out
}

