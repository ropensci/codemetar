# guess_releaseNotes -----------------------------------------------------------
guess_releaseNotes <- function(root = ".") {

  ## First look for a local NEWS.md or NEWS
  news_files <- c("NEWS.md", "NEWS")

  ## Do the news files exist?
  file_exists <- file.exists(file.path(root, news_files))

  ## Give up if there is no news file or if Git is not used
  if (! any(file_exists) || ! uses_git(root)) {

    return(NULL)
  }

  ## Point to the first file that was found: NEWS.md or NEWS on the GitHub page
  github_path(root, news_files[file_exists][1])

  ## Consider pointing to CRAN NEWS, BIOC NEWS?
}

# guess_fileSize ---------------------------------------------------------------
guess_fileSize <- function(root = ".") {

  ## No root, no file size
  if (is.null(root)) {

    return(NULL)
  }

  ## Look for files 1. Meta, 2. DESCRIPTION
  file_exists <- file.exists(file.path(root, c("Meta", "DESCRIPTION")))

  ## Meta exists -> cannot build (or read file size?) on an already installed
  ## package
  if (file_exists[1] || ! file_exists[2]) {

    return(NULL)
  }

  file_path <- try(silent = TRUE, pkgbuild::build(
    root, dest_path = tempdir(), vignettes = FALSE, manual = FALSE, quiet = TRUE
  ))

  if (inherits(file_path, "try-error")) {

    NULL

  } else {

    paste0(file.size(file_path) / 1e3, "KB")
  }
}
