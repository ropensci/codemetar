## Methods that guess additional metadata fields based on README badges and realted information



## cache avail packages
CRAN <- utils::available.packages(utils::contrib.url("https://cran.rstudio.com", "source"))
BIOC <- utils::available.packages(utils::contrib.url("https://www.bioconductor.org/packages/release/bioc", "source"))


guess_provider <- function(pkg){
  if(is.null(pkg)){
    return(NULL)
  }
  ## Assumes a single provider

  if(pkg %in% CRAN[,"Package"]){
    list("@id" = "https://cran.r-project.org",
         "@type" = "Organization",
         "name" = "Central R Archive Network (CRAN)",
         "url" = "https://cran.r-project.org")



  } else if(pkg %in% BIOC[,"Package"]){
    list("@id" = "https://www.bioconductor.org/",
         "@type" = "Organization",
         "name" = "BioConductor",
         "url" = "https://www.bioconductor.org/packages/")

  } else {
    NULL
  }

}



## look for .travis.yml ? GREP .travis badge so we can guess repo name.
guess_ci <- function(readme){
  link <- NULL
  if(file.exists(readme)){
    txt <- readLines(readme)
    badge <- txt[grepl("travis-ci", txt)]
    link <- gsub(".*(https://travis-ci.org/\\w+/\\w+).*", "\\1", badge)
  }
  if(length(link) >= 1){
    link[[1]]
  } else {
    NULL
  }
}

## Currently looks for a repostatus.org link and returns the abbreviation.
guess_devStatus <- function(readme){
  status <- NULL
  if(file.exists(readme)){
    txt <- readLines(readme)
    badge <- txt[grepl("Project Status", txt)]
    ## Text-based status line
    # status <- gsub(".*\\[!\\[(Project Status: .*)\\.\\].*", "\\1", badge)
    ## use \\2 for repostatus.org term, \\1 for repostatus.org term link
    status <- gsub(".*(http://www.repostatus.org/#(\\w+)).*", "\\2", badge)
  }
  if(length(status) >= 1){
    status[[1]]
  } else {
    NULL
  }

}


## use rorcid / ORCID API to infer ORCID ID from name?
## (Can't use email since only 2% of ORCID users expose email)
## Also can get Affiliation from ORCID search
guess_orcids <- function(codemeta){
  NULL
}

### Consider: guess_releastNotes()
