## Based on CI badges, not config files
# only Travis, Appveyor and Circle CI
# also uses code coverage
guess_ci <- function(readme) {

  badges <- extract_badges(readme)

  pattern <- "travis|appveyor|circleci|codecov|coveralls"

  if (length(badge_links <- grep(pattern, badge$link, value = TRUE))) {

    badge_links
  }
  # else NULL implicitly
}

## Either repostatus.org or lifecycle badge
guess_devStatus <- function(readme) {
  badges <- extract_badges(readme)
  status_badge <- badges[grepl("repostatus.org", badges$link)|
                           grepl("lifecycle", badges$link),]
  if (!is.null(status_badge)) {
    if(nrow(status_badge) >0){
      status_badge$link
    }
  } else {
    NULL
  }


}

# looks for a rOpenSci peer review badge

get_pkg_name <- function(entry){
  if(is.null(entry$pkgname)){
    ""
  }else{
    entry$pkgname
  }
}

.ropensci_reviews <- function(){
  reviews <-  jsonlite::read_json("https://badges.ropensci.org/json/onboarded.json")
  reviews <- tibble::tibble(review = purrr::map_dbl(reviews, "iss_no"),
                            package = purrr::map_chr(reviews, get_pkg_name))
}

ropensci_reviews <- memoise::memoise(.ropensci_reviews)

guess_ropensci_review <- function(readme) {
  badges <- extract_badges(readme)
  badge <- badges[grepl("github.com/ropensci/onboarding/issues/", badges$link),]$link
  if (length(badge) >= 1) {
    review <-
      gsub(".*https://github.com/ropensci/onboarding/issues/", "", badge)
    review <- as.numeric(review)
    reviews <- ropensci_reviews()
    if(review %in% reviews$review){
      list("@type" = "Review",
           "url" = paste0("https://github.com/ropensci/onboarding/issues/",
                          review),
           "provider" = "http://ropensci.org")
    } else{
      NULL
    }
  } else {
    NULL
  }


}

# find the readme

guess_readme_url <- function(root){
  if (uses_git(root)) {
    github <- guess_github(root)
    github <- gsub(".*com\\/", "", github)
    github <- strsplit(github, "/")[[1]]
    readme <- try(gh::gh("GET /repos/:owner/:repo/readme",
                         owner = github[1], repo = github[2]),
                  silent = TRUE)
    if(inherits(readme, "try-error")){
      readme_url <- NULL
    }else{
      readme$html_url
    }


  } else{
    NULL
  }
}

guess_readme_path <- function(root){
  readmes <- dir(root, pattern = "^README\\.R?md$", ignore.case = TRUE)
  if(length(readmes) == 0){
    readme_path <- NULL
  }else{
    readme_rmd <- readmes[grepl("\\.[Rr]md", readmes)]
    if(length(readme_rmd) == 0){
      readme_path <- file.path(root, readmes[grepl("\\.md", readmes)])
    }else{
      readme_path <- file.path(root, readme_rmd)
    }
  }

  if(length(readme_path) > 1) { # README.md and ReadMe.md could both exist ...
    ## silently use the first match (locale-dependent)
    readme_path <- readme_path[1]
  }

  return(readme_path)
}

.guess_readme <- function(root = ".") {

  readme_url <- guess_readme_url(root)

  readme_path <- guess_readme_path(root)

  return(list(readme_path = readme_path,
              readme_url = readme_url))

}


guess_readme <- memoise::memoise(.guess_readme)




codemeta_readme <- function(readme, codemeta){
  if (is.null(codemeta$contIntegration)){
    codemeta$contIntegration <- guess_ci(readme)
  }

  if (is.null(codemeta$developmentStatus)){
    codemeta$developmentStatus <-
      guess_devStatus(readme)
  }

  if (is.null(codemeta$review)){
    codemeta$review <-
      guess_ropensci_review(readme)
  }

  codemeta
}
