#' Function giving opinions about a package
#'
#' @param pkg_path Path to the package root
#'
#' @return A data.frame of opinions
#' @export
#'
give_opinions <- function(pkg_path = .){
  descr_path <- file.path(pkg_path, "DESCRIPTION")
  # opinions about DESCRIPTION
  descr_issues <- give_opinions_desc(descr_path)

  # opinions about README
  if (!file.exists(file.path(pkg_path, "README.md"))) {
    readme_issues <- NULL
  }else{
    desc_info <- codemeta_description(descr_path)
    readme_issues <- give_opinions_readme(file.path(pkg_path,
                                                    "README.md"),
                                          desc_info$identifier)
  }


  fixmes <- rbind(descr_issues, readme_issues)

  if(!is.null(fixmes)){
    descr <- desc::desc(descr_path)
    fixmes$package <- as.character(descr$get("Package"))
    return(fixmes)
  }else{
    return(NULL)
  }


}

give_opinions_desc <- function(descr_path){
  descr <- desc::desc(descr_path)
  # Authors
  if (inherits( try(descr$get_authors(), silent = TRUE),
                'try-error')){
    authors_fixme <- "The syntax Authors@R instead of plain Author and Maintainer is recommended in particular because it allows richer metadata" # no lint
  }else{
    authors_fixme <- NULL
  }

  # URL
  if(is.na(descr$get("URL"))){
    url_fixme <- "URL field. Indicate the URL to your code repository."
  }else{
    checkurls <- check_urls(descr$descr$get_urls)
    if(checkurls != ""){
      url_fixme <- checkurls
    }else{
      url_fixme <- NULL
    }

  }

  # BugReports
  if(is.na(descr$get("BugReports"))){
    bugreports_fixme <- "BugReports field. Indicate where to report bugs, e.g. GitHub issue tracker."
  }else{
    checkurls <- check_urls(descr$get("BugReports"))
    if(checkurls != ""){
      bugreports_fixme <- checkurls
    }else{
      bugreports_fixme <- NULL
    }

  }

  fixmes <- c(authors_fixme, url_fixme, bugreports_fixme)
  fixmes <- fixmes[!is.null(fixmes)]

  if(length(fixmes) >0){

    tibble::tibble(where = "DESCRIPTION",
                   fixme = fixmes)
  }else{
    NULL
  }


}

give_opinions_readme <- function(readme_path,
                                 pkg_name){

  # look for badges
  badges <- extract_badges(readme_path)
  # status
  if(!any(grepl("Project Status",
                badges$text))){
    status_fixme <- "Add a status badge cf e.g repostatus.org"
  }else{
    status_fixme <- NULL
  }

  # provider
  provider <- guess_provider(pkg_name)
  if(!is.null(provider)){
    if(provider$name == "Central R Archive Network (CRAN)"){
      provider_badge <- any(grepl("CRAN", badges$text))
    }else{
      if(provider$name == "BioConductor"){
        provider_badge <- any(grepl("bioconductor",
                                    badges$link))
      }
    }

    if(!provider_badge){
      provider_fixme <- paste0("There is a package called ",
                               pkg_name, " on ",
                               provider$name, ", add a badge to show it is yours or rename your package.")
    }else{
      provider_fixme <- NULL
    }
  }else{
    provider_fixme <- NULL
  }

  fixmes <- c(status_fixme, provider_fixme)
  fixmes <- fixmes[!is.null(fixmes)]
  if(length(fixmes) >0){

    tibble::tibble(where = "README",
                   fixme = fixmes)
  }else{
    NULL
  }

}
