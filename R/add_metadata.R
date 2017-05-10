
## Some preliminary helper functions to add additional metadata


## simple, top-level items
add_metadata <- function(codemeta, keywords, developmentStatus, dateModified, datePublished, embargoDate, publisher, funding){}




## look for .travis.yml ? GREP .travis badge so we can guess repo name.
guess_ci <- function(codemeta){
  link <- NULL
  if(file.exists("README.md")){
    txt <- readLines("README.md")
    badge <- txt[grepl("travis-ci", txt)]
    link <- gsub(".*(https://travis-ci.org/\\w+/\\w+).*", "\\1", badge)
  }
  codemeta$contIntegration <- link

  codemeta
}

## use rorcid / ORCID API to infer ORCID ID from name?
guess_orcids <- function(codemeta){
  NULL
}

codemeta_template <- function(){
  ## Load a template from inst/

  #  json <- jsonlite::read_json("https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta-v2.jsonld")
  #  context <- json$`@context`
}
