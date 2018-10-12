## Methods that guess additional metadata fields based on README badges and related information



## cache avail packages
.CRAN <- function(){
  utils::available.packages(
    utils::contrib.url("https://cran.rstudio.com", "source"))
}

CRAN <- memoise::memoise(.CRAN)

.BIOC <- function(){
  utils::available.packages(
    utils::contrib.url(
      "https://www.bioconductor.org/packages/release/bioc",
      "source"
    )
  )
}

BIOC <- memoise::memoise(.BIOC)

guess_provider <- function(pkg) {
  if (is.null(pkg)) {
    return(NULL)
  }
  ## Assumes a single provider

  if (pkg %in% CRAN()[, "Package"]) {
    list(
      "@id" = "https://cran.r-project.org",
      "@type" = "Organization",
      "name" = "Comprehensive R Archive Network (CRAN)",
      "url" = "https://cran.r-project.org"
    )



  } else if (pkg %in% BIOC()[, "Package"]) {
    list(
      "@id" = "https://www.bioconductor.org",
      "@type" = "Organization",
      "name" = "BioConductor",
      "url" = "https://www.bioconductor.org"
    )

  } else {
    NULL
  }

}

## Based on CI badges, not config files
# only Travis, Appveyor and Circle CI
# also uses code coverage
guess_ci <- function(readme) {

  badges <- extract_badges(readme)
  ci_badge <- badges[grepl("travis", badges$link)|
                       grepl("appveyor", badges$link)|
                       grepl("circleci", badges$link)|
                       grepl("codecov", badges$link)|
                       grepl("coveralls", badges$link),]
  if (!is.null(ci_badge)) {
    ci_badge$link
  } else {
    NULL
  }

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
guess_ropensci_review <- function(readme) {
    badges <- extract_badges(readme)
    badge <- badges[grepl("github.com/ropensci/onboarding/issues/", badges$link),]$link
    if (length(badge) >= 1) {
      review <-
        gsub(".*https://github.com/ropensci/onboarding/issues/", "", badge)
      review <- as.numeric(review)
      issue <- try(gh::gh("GET /repos/:owner/:repo/issues/:number",
                      owner = "ropensci",
                      repo = "onboarding",
                      number = review),
                   silent = TRUE)
      if(inherits(issue, "try-error")){
        stop("Invalid link to issue in rOpenSci peer-review badge.",
             call. = FALSE)
      }

      if(issue$state == "closed"){
        list("@type" = "Review",
             "url" = paste0("https://github.com/ropensci/onboarding/issues/",
                            review),
             "provider" = "http://ropensci.org")
      }else{
        NULL
      }
    } else {
      NULL
    }


}


## use rorcid / ORCID API to infer ORCID ID from name?
## (Can't use email since only 2% of ORCID users expose email)
## Also can get Affiliation from ORCID search
guess_orcids <- function(codemeta) {
  NULL
}

# from devtools https://github.com/r-lib/devtools/blob/21fe55a912ca4eaa49ef5b7d891ff3e2aae7a370/R/git.R#L1
# GPL>=2 code
uses_git <- function(root) {
  !is.null(git2r::discover_repository(root, ceiling = 0))
}

guess_github <- function(root = ".") {
  ## from devtools
  # https://github.com/r-lib/devtools/blob/21fe55a912ca4eaa49ef5b7d891ff3e2aae7a370/R/git.R#L130
  # GPL>=2 code
  remote_urls <- function (r) {
    remotes <- git2r::remotes(r)
    stats::setNames(git2r::remote_url(r, remotes), remotes)
  }

  if (uses_git(root)) {
    r <- git2r::repository(root, discover = TRUE)
    r_remote_urls <- grep("github", remote_urls(r), value = TRUE)
    out <- r_remote_urls[[1]]
    gsub("\\.git$", "", gsub("git@github.com:", "https://github.com/", out))
  } else {
    NULL
  }
}

### Consider: guess_releastNotes() (NEWS), guess_readme()

.guess_readme <- function(root = ".") {
  ## point to GitHub page
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
      readme_url <- readme$html_url
    }


  } else{
    readme_url <- NULL
  }

  readmes <- dir(root, pattern = "^README\\.R?md$", ignore.case = TRUE)
  if(length(readmes) == 0){
    readme_path <- NULL
  }else{
    readme_rmd <- readmes[grepl("\\.Rmd", readmes)]
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

  return(list(readme_path = readme_path,
              readme_url = readme_url))

}


guess_readme <- memoise::memoise(.guess_readme)


#' @importFrom git2r repository branches
github_path <- function(root, path) {
  base <- guess_github(root)
  r <- git2r::repository(root, discover = TRUE)
  branch <- getOption("codemeta_branch", "master")
  paste0(base, "/blob/", branch, "/", path)
}

guess_releaseNotes <- function(root = ".") {
  ## First look for a local NEWS.md or NEWS, otherwise, give up
  if (file.exists(file.path(root, "NEWS.md"))) {
    releaseNotes <- "NEWS.md"
  } else if (file.exists(file.path(root, "NEWS"))) {
    releaseNotes <- "NEWS"
  } else {
    return(NULL)
  }

  ## point to GitHub page
  if (uses_git(root)) {
    github_path(root, releaseNotes)
  } else {
    NULL
  }



  ## Consider pointing to CRAN NEWS, BIOC NEWS?

}

guess_fileSize <- function(root = ".") {
  if (is.null(root)) {
    return(NULL)
  } else if (file.exists(file.path(root, "Meta"))) {
    ## cannot build (or read file size?) on an already installed package
    return(NULL)
  } else if (!file.exists(file.path(root, "DESCRIPTION"))) {
    return(NULL)
  } else {
    f <-
      pkgbuild::build(root,
                      vignettes = FALSE,
                      manual = FALSE,
                      quiet = TRUE)
    paste0(file.size(f) / 1e3, "KB")
  }
}

# add GitHub topics
add_github_topics <- function(cm){
  github <- stringr::str_remove(cm$codeRepository, ".*github\\.com\\/")
  github <- stringr::str_remove(github, "#.*")
  github <- stringr::str_split(github, "/")[[1]]
  owner <- github[1]
  repo <- github[2]

  topics <- try(gh::gh("GET /repos/:owner/:repo/topics",
                   repo = repo, owner = owner,
                   .send_headers = c(Accept = "application/vnd.github.mercy-preview+json")),
                silent = TRUE)
  if(!inherits(topics, "try-error")){
    topics <- unlist(topics$names)

    cm$keywords <- unique(c(cm$keywords, topics))}
  cm
}
