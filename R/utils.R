# drop_null --------------------------------------------------------------------
drop_null <- function(x) {

  x[lengths(x) != 0]
}

# get_root_path ----------------------------------------------------------------
get_root_path <- function(pkg) {

  if (pkg %in% installed_package_names()) {

    package_file(pkg, ".")

  } else if (is_package(file.path(pkg))) {

    pkg

  } else if (is.character(pkg)) {

    pkg # use pkg as guess anyway

# } else {
#
#   "." # stick with default
  }
}

# package_file -----------------------------------------------------------------
# Just a shortcut to system.file(..., package = pkg)
package_file <- function(pkg, ...) {

  system.file(..., package = pkg)
}

# installed_package_names: names of installed packages -------------------------
#' @importFrom utils installed.packages
installed_package_names <- function() {

  row.names(installed.packages())
}

# get_file ---------------------------------------------------------------------
## Like system.file, but pkg can instead be path to package root directory
get_file <- function(FILE, pkg = ".") {

  path <- file.path(pkg, FILE)

  if (file.exists(path)) {

    path

  } else {

    package_file(pkg, FILE)
  }
}

# is_IRI -----------------------------------------------------------------------
is_IRI <- function(string) {

  ## FIXME IRI can be many other things too,
  #see https://github.com/dgerber/rfc3987 for more formal implementation
  grepl("^http[s]?://", string)
}

# uses_git ---------------------------------------------------------------------
# from usethis cf https://github.com/r-lib/usethis/blob/2abb0422a97808cc573fa5900a8efcfed4c2d5b4/R/git.R#L68
# this is GPL-3 code
uses_git <- function(path = usethis::proj_get()) {

  ! is.null(git2r::discover_repository(path))
}

# from usethis cf https://github.com/r-lib/usethis/blob/4fb556788d2588facaaa8560242d2c83f2261d6e/R/helpers.R#L55
# this is GPL-3 code
render_template <- function(template, data = list(), package = "codemetar") {

  template_path <- find_template(template, package = package)

  strsplit(whisker::whisker.render(readLines(template_path), data), "\n")[[1]]
}

# find_template-----------------------------------------------------------------
# from usethis cf https://github.com/r-lib/usethis/blob/4fb556788d2588facaaa8560242d2c83f2261d6e/R/helpers.R#L60
# this is GPL-3 code
find_template <- function(template_name, package = "usethis") {

  package_file(package, "templates", template_name)
}

# get_url_status_code ----------------------------------------------------------
get_url_status_code <- function(url) {

  if (is.null(url) || is.na(url)) {

    return(NULL)
  }

  result <- try(crul::HttpClient$new(url)$get(), silent = TRUE)

  message <- if (inherits(result,'try-error')) {

    "No connection was possible"

  } else if ((code <- result$status_code) == 200) {

    "All good"

  } else {

    paste("Error code:", code)
  }

  data.frame(message = message, url = url)
}

# check_urls -------------------------------------------------------------------
check_urls <- function(urls) {

  messages <- do.call(rbind, lapply(urls, get_url_status_code))

  failed <- (messages$message != "All good")

  if (any(failed)) {

    paste("Problematic URLs\n", apply(messages[failed, ], 1, toString))

  } else {

    ""
  }
}

# whether_provider_badge -------------------------------------------------------
whether_provider_badge <- function(badges, provider_name) {

  ! is.null(provider_name) && (
    (
      provider_name == "Comprehensive R Archive Network (CRAN)" &&
        any(grepl("CRAN", badges$text))
    ) || (
      provider_name == "BioConductor" &&
        any(grepl("bioconductor", badges$link))
    )
  )
}

# is_package: helper to find whether a path is a package project ---------------
is_package <- function(path) {

  all(c("DESCRIPTION", "NAMESPACE", "man", "R") %in% dir(path))
}

# set_element_if_null ----------------------------------------------------------
set_element_if_null <- function(x, element, value) {

  stopifnot(is.list(x))

  if (is.null(x[[element]])) {

    x[[element]] <- value
  }

  x
}

# fails ------------------------------------------------------------------------
#' Does the Evaluation of an Expression Fail?
#'
#' @param expr expression to be evaluated within \code{try(\dots)}
#' @param silent passed to \code{\link{try}}, see there.
#' @return \code{TRUE} if evaluating \code{expr} failed and \code{FALSE} if
#'   the evalutation of \code{expr} succeeded.
fails <- function(expr, silent = TRUE) {

  inherits(try(expr, silent = silent), "try-error")
}

