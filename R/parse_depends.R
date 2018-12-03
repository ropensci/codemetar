## internal method for parsing a list of package dependencies into pkg URLs

format_depend <- function(package, version, remote_provider){
  dep <- list("@type" = "SoftwareApplication",
              identifier = package,
              ## FIXME technically the name includes the title
              name = package)

  ## Add Version if available
  if (version != "*"){
    dep$version <- version
  }

  dep$provider <- guess_provider(package)

  ## implemention could be better, e.g. support versioning
  #  dep$`@id` <- guess_dep_id(dep)

  # CRAN canonical URL
  if(!is.null(dep$provider)){
    if(dep$provider$name == "Comprehensive R Archive Network (CRAN)"){
      dep$sameAs <- paste0("https://CRAN.R-project.org/package=",
                           dep$identifier)
    }else{
      if(dep$provider$name == "BioConductor"){
        dep$sameAs <- paste0("https://bioconductor.org/packages/release/bioc/html/",
                             dep$identifier, ".html")
      }
    }
  }

  if(remote_provider != ""){
    dep$sameAs <- paste0("https://github.com/",
                         stringr::str_remove(remote_provider, "github::"))
  }

  return(dep)

}

parse_depends <- function(deps) {

  purrr::pmap(list(deps$package, deps$version,
                deps$remote_provider),
  format_depend)
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

add_remote_to_dep <- function(package, remotes){
  remote_provider <- remotes[grepl(paste0("/", package, "$"),
                                   remotes)]
  if(length(remote_provider) == 0){
    ""
  }else{
    remote_provider
  }
}


# helper to get system dependencies
get_sys_links <- function(pkg, description = ""){
  out1 <- jsonlite::fromJSON(sprintf("https://sysreqs.r-hub.io/pkg/%s", pkg), simplifyVector = FALSE)
  out2 <- jsonlite::fromJSON(sprintf("https://sysreqs.r-hub.io/map/%s", curl::curl_escape(description)), simplifyVector = FALSE)
  sysreqs <- unique(c(sapply(out1, names), sapply(out2, names)))
  sprintf("https://sysreqs.r-hub.io/get/%s", sysreqs)
}

format_sys_req <- function(url){
  list("@type" = "SoftwareApplication",
       identifier = url)
}

parse_sys_reqs <- function(pkg, sys_reqs){
  urls <- get_sys_links(pkg, description = sys_reqs)
  purrr::map(urls, format_sys_req)
}
