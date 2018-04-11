#' Function giving opinions about a package
#'
#' @param pkg_path
#'
#' @return A data.frame of opinions
#' @export
#'
give_opinions <- function(pkg_path = .){
  descr_path <- file.path(pkg_path, "DESCRIPTION")
  # opinions about DESCRIPTION
  descr_issues <- give_opinions_desc(descr_path)


  fixmes <- rbind(descr_issues, NULL)

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
    url_fixme <- NULL
  }

  # BugReports
  if(is.na(descr$get("BugReports"))){
    bugreports_fixme <- "BugReports field. Indicate where to report bugs, e.g. GitHub issue tracker."
  }else{
    bugreports_fixme <- NULL
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
