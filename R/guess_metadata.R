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



## look for .travis.yml ? GREP .travis badge so we can guess repo name.
guess_ci <- function(readme) {
  if (file.exists(readme)) {
    badges <- extract_badges(readme)
    ci_badge <- badges[grepl("travis", badges$link)|
                         grepl("appveyor", badges$link)|
                         grepl("circleci", badges$link),]
    if (!is.null(ci_badge)) {
      ci_badge$link
    } else {
      NULL
    }
  }else{
    NULL
  }
}

## Currently looks for a repostatus.org link and returns the abbreviation.
guess_devStatus <- function(readme) {
  status <- NULL
  if (file.exists(readme)) {
    badges <- extract_badges(readme)
    status_badge <- badges[grepl("Project Status", badges$text)|
                             grepl("lifecycle", badges$text),]
    if (!is.null(status_badge)) {
      if(nrow(status_badge) >0){
        status_badge$link[1]
      }
    } else {
      NULL
    }
  }else{
        NULL
      }


}

# looks for a rOpenSci peer review badge
guess_ropensci_review <- function(readme) {
  status <- NULL
  if (file.exists(readme)) {
    txt <- readLines(readme)
    badge <- txt[grepl("badges\\.ropensci\\.org", txt)]
    if (length(badge) >= 1) {
      review <-
        gsub(".*https://github.com/ropensci/onboarding/issues/", "", badge)
      review <- gsub(").*", "", review)
      review <- as.numeric(review)
      issue <- gh::gh("GET /repos/:owner/:repo/issues/:number",
                      owner = "ropensci",
                      repo = "onboarding",
                      number = review)
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
  }else{
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

guess_readme <- function(root = ".") {
  ## If no local README.md at package root, give up
  contents <- dir(root)
  readmes <- contents[grepl("[Rr][Ee][Aa][Dd][Mm][Ee]\\.R?md", contents)]
  if(length(readmes) == 0){
    NULL
  }else{
    readme_rmd <- readmes[grepl("\\.Rmd", readmes)]
    if(is.null(readme_rmd)){
      file.path(root, readmes[grepl("\\.md", readmes)])
    }else{
      file.path(root, readme_rmd)
    }
  }

  ## point to GitHub page
  if (uses_git(root)) {
    github_path(root, "README.md")
  } else {
    NULL
  }
}

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
      devtools::build(root,
                      vignettes = FALSE,
                      manual = FALSE,
                      quiet = TRUE)
    paste0(file.size(f) / 1e3, "KB")
  }
}
