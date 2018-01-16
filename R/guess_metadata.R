## Methods that guess additional metadata fields based on README badges and realted information



## cache avail packages
CRAN <-
  utils::available.packages(
    utils::contrib.url("https://cran.rstudio.com", "source"))
BIOC <-
  utils::available.packages(
    utils::contrib.url(
      "https://www.bioconductor.org/packages/release/bioc",
      "source"
    )
  )


guess_provider <- function(pkg) {
  if (is.null(pkg)) {
    return(NULL)
  }
  ## Assumes a single provider

  if (pkg %in% CRAN[, "Package"]) {
    list(
      "@id" = "https://cran.r-project.org",
      "@type" = "Organization",
      "name" = "Central R Archive Network (CRAN)",
      "url" = "https://cran.r-project.org"
    )



  } else if (pkg %in% BIOC[, "Package"]) {
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
  link <- NULL
  if (file.exists(readme)) {
    txt <- readLines(readme)
    badge <- txt[grepl("travis-ci", txt)]
    link <-
      gsub(".*(https://travis-ci.org/\\w+/\\w+).*", "\\1", badge)
  }
  if (length(link) >= 1) {
    link[[1]]
  } else {
    NULL
  }
}

## Currently looks for a repostatus.org link and returns the abbreviation.
guess_devStatus <- function(readme) {
  status <- NULL
  if (file.exists(readme)) {
    txt <- readLines(readme)
    badge <- txt[grepl("Project Status", txt)]
    ## Text-based status line
    # status <- gsub(".*\\[!\\[(Project Status: .*)\\.\\].*", "\\1", badge)
    ## use \\2 for repostatus.org term, \\1 for repostatus.org term link
    status <-
      gsub(".*(http://www.repostatus.org/#(\\w+)).*", "\\2", badge)
  }
  if (length(status) >= 1) {
    status[[1]]
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

uses_git <- function(root) {
  !is.null(git2r::discover_repository(root, ceiling = 0))
}

guess_github <- function(root = ".") {
  ## from devtools
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
  if (!file.exists(file.path(root, "README.md"))) {
    return(NULL)
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

#' @importFrom devtools build
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
