## Methods that guess additional metadata fields based on README badges and realted information



## cache avail packages
CRAN <- utils::available.packages(utils::contrib.url("https://cran.rstudio.com", "source"))
BIOC <- utils::available.packages(utils::contrib.url("https://www.bioconductor.org/packages/release/bioc", "source"))


guess_provider <- function(pkg){

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
    if(length(link)>1) link <- link[[1]]
  }
  link
}

guess_devStatus <- function(readme){
  status <- NULL
  if(file.exists(readme)){
    txt <- readLines(readme)
    badge <- txt[grepl("Project Status", txt)]
    status <- gsub(".*\\[!\\[(Project Status: .*)\\.\\].*", "\\1", badge)
  }
  status

}


## use rorcid / ORCID API to infer ORCID ID from name?
## (Can't use email since only 2% of ORCID users expose email)
## Also can get Affiliation from ORCID search
guess_orcids <- function(codemeta){
  NULL
}

### Consider: guess_releastNotes()
