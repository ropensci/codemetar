## Methods that guess additional metadata fields based on README badges and realted information


guess_published <- function(codemeta){

  ## Currently only considers if published to CRAN
  cran_published(codemeta)
}

cran_published <- function(codemeta){
  if(codemeta$name %in% avail[,"Package"]){
    codemeta$publisher <-
      list("@type" = "Organization",
           "name" = "CRAN",
           "url" = "https://cran.r-project.org")
  }
  codemeta

}

## Do not run if we're not in the working directory of the package!
at_pkg_root <- function(cm, path){
  if(file.exists(paste0(path, "/DESCRIPTION"))){
    descr <- read_dcf(path)
    cm$name == descr$Package
  } else {
    FALSE
  }

}


## look for .travis.yml ? GREP .travis badge so we can guess repo name.
guess_ci <- function(codemeta, pkg = "."){
  link <- NULL
  if(at_pkg_root(codemeta, ".") && file.exists("README.md")){
    txt <- readLines("README.md")
    badge <- txt[grepl("travis-ci", txt)]
    link <- gsub(".*(https://travis-ci.org/\\w+/\\w+).*", "\\1", badge)
  }
  codemeta$contIntegration <- link[[1]]

  codemeta
}

guess_devStatus <- function(codemeta, pkg = "."){

  link <- NULL
  if(at_pkg_root(codemeta, ".") && file.exists("README.md")){
    txt <- readLines("README.md")
    badge <- txt[grepl("Project Status", txt)]
    status <- gsub(".*\\[!\\[(Project Status: .*)\\.\\].*", "\\1", badge)
  }
  codemeta$developmentStatus <- status
  codemeta
}


## use rorcid / ORCID API to infer ORCID ID from name?
## (Can't use email since only 2% of ORCID users expose email)
## Also can get Affiliation from ORCID search
guess_orcids <- function(codemeta){
  NULL
}

### Consider: guess_releastNotes()
