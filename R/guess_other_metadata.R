# guess_releaseNotes -----------------------------------------------------------
guess_releaseNotes <- function(root = ".", cm) {

  ## First look for a local NEWS.md or NEWS
  news_files <- c("NEWS.md", "NEWS")

  ## Do the news files exist?
  file_exists <- file.exists(file.path(root, news_files))

  ## Give up if there is no news file or if Git is not used
  if (! any(file_exists) || ! uses_git(root)) {

    return(NULL)
  }

  ## Point to the first file that was found: NEWS.md or NEWS on the GitHub page
  github_path(root, news_files[file_exists][1], cm)

  ## Consider pointing to CRAN NEWS, BIOC NEWS?
}

# guess_fileSize ---------------------------------------------------------------
#' @title Estimate the File Size of the Software
#'
#' @description The function makes a rough estimation of the size of the
#' R package using the base R function [file.size]. Files in `.Rbuildignore` are
#' exclude. Please note that this estimation does not necessarily reflect the installed size
#' of the package.
#'
#' @param root the root file path
#'
#' @param .ignore optional vector of regular expresssions that will be ignore when the file
#' size is guessed
#'
#' @seealso [base::file.size]
#'
#' @examples
#'
#' guess_fileSize()
#'
#' @md
#' @noRd
guess_fileSize <- function(root = ".", .ignore = NULL) {
  ## no root, no file size
  if (is.null(root))
    return(NULL)

  ## check for .Rbuildignore, everything listed should be excluded since
  ## it will not become part of the final package
  rbuildignore_path <- file.path(root,".Rbuildignore")
  if (file.exists(rbuildignore_path) && is.null(.ignore)){
    .ignore <- readLines(normalizePath(rbuildignore_path), warn = FALSE)

  }else{
    .ignore <- " "

  }

  ## grep all files of interest (exclude hidden files)
  files <- normalizePath(list.files(
    path = normalizePath(root),
    recursive = TRUE,
    full.names = TRUE,
    all.files = FALSE
  ))

  ## kick-out all files that do not belong to the R package
  files <-
    files[!grepl(paste(.ignore, collapse = "|"), files, perl = TRUE)]

  ## estimate total size
  paste0(sum(file.size(files)) / 1e3, "KB")
}

