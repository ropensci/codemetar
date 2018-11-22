
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
