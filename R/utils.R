# drop_null --------------------------------------------------------------------
drop_null <- function(x) {

  x[lengths(x) != 0]
}

# get_root_path ----------------------------------------------------------------
get_root_path <- function(pkg) {

  if (is_installed(pkg)) {

    find.package(pkg)

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

# is_installed: is the package installed -------------------------
is_installed <- function(pkg) {

  length(
    find.package(
      package = pkg,
      quiet = TRUE
      )
    ) > 0
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
# now with gert not git2r
uses_git <- function(path) {

  !is.null(tryCatch(gert::git_find(path), error = function(e){NULL}))
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

  if (!pingr::is_online()) {

    return("")
  }

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

# dot_to_package: convert pkg = "." to proper package path ------------------
dot_to_package <- function(pkg = ".") {

    # https://github.com/r-lib/rprojroot/blob/master/R/root.R#L115:
    .max_depth <- 10L

    files <- c("DESCRIPTION", "NAMESPACE", "man", "R")

    if (pkg == "." | !all(files %in% list.files(pkg))) {

        pkg <- normalizePath(pkg)

        if (!all(files %in% list.files(pkg))) {

            for (i in seq_len(.max_depth)) {

                pkg <- normalizePath(file.path(pkg, ".."))

                if (all(files %in% list.files(pkg)))
                    return(pkg)
            }
        }
    }

    if (!all(files %in% list.files(pkg)))
        stop("Unable to find root directory of an R package")

    return(pkg)
}

# is_package: helper to find whether a path is a package project ---------------
is_package <- function(path) {

  all(c("DESCRIPTION", "NAMESPACE", "man", "R") %in% dir(path))
}

# set_element ----------------------------------------------
set_element <- function(x, element, value) {

  stopifnot(is.list(x))

  x[[element]] <- value

  x

}


# fails ------------------------------------------------------------------------
#' Does the Evaluation of an Expression Fail?
#'
#' @param expr expression to be evaluated within `try(\dots)`
#' @param silent passed to [try()], see there.
#' @return `TRUE` if evaluating `expr` failed and `FALSE` if
#'   the evalutation of `expr` succeeded.
#' @noRd
fails <- function(expr, silent = TRUE) {

  inherits(try(expr, silent = silent), "try-error")
}

# example_file -----------------------------------------------------------------
example_file <- function(...) {

  package_file("codemetar", "examples", ...)
}


#' Check for Class "json" or Character
#'
#' @param x object to be checked for its class and mode
#' @return `TRUE` if `x` inherits from "json" or is of mode character,
#'   otherwise `FALSE`
#' @noRd
is_json_or_character <- function(x) {

  is(x, "json") || is.character(x)
}

# to_json_if -------------------------------------------------------------------

#' Convert to JSON if Condition is Met
#'
#' @param condition expression to be evaluated
#' @param x object to be converted to JSON
#' @param \dots further arguments passed to [jsonlite::toJSON()]
#' @importFrom jsonlite toJSON
#' @noRd
to_json_if <- function(condition, x, ...) {

  call_if(condition, x, FUN = jsonlite::toJSON, ...)
}

# from_json_if -----------------------------------------------------------------

#' Convert from JSON if Condition is Met
#'
#' @param condition expression to be evaluated
#' @param x object passed to [jsonlite::fromJSON()] if
#'   `condition` is met
#' @param \dots further arguments passed to [jsonlite::fromJSON()]
#' @importFrom jsonlite fromJSON
#' @noRd
from_json_if <- function(condition, x, ...) {

  call_if(condition, x, jsonlite::fromJSON, ...)
}

# call_if ----------------------------------------------------------------------

#' Call Function if Condition is Met
#'
#' @param condition expression to be evaluated
#' @param FUN function to be called if `condition` is met
#' @param x first argument to be passed to `FUN` or not
#' @param \dots further arguments passed to `FUN`
#' @noRd
call_if <- function(condition, x, FUN, ...) {

  if (condition) {

    FUN(x, ...)

  } else {

    x
  }
}

# bind df -----------------------
bind_df <- function(dfs) {
  do.call("rbind", dfs)
}

# df -----------------------
df <- function(...) {
  data.frame(
    ...,
    stringsAsFactors = FALSE
    )
}

# use_build_ignore -----------------------
# Adapted from https://github.com/r-lib/usethis/blob/85327feeec22ab2f6f46efcd2d3d0a4b010f132b/R/ignore.R#L23
use_build_ignore <- function(thing, path) {
  thing <- escape_path(thing)
  write_union(
    file.path(
      path,
      ".Rbuildignore"
      ),
    thing
    )
}

# write_union --------------------
# from https://github.com/r-lib/usethis/blob/368714a4f487dce4719ac8a002383d719f73cd64/R/write.R#L45
write_union <- function(path, lines) {

  if (file.exists(path)) {
    existing_lines <- readLines(path, encoding = "UTF-8", warn = FALSE)
  } else {
    existing_lines <- character()
  }

  new <- setdiff(lines, existing_lines)
  if (length(new) == 0) {
    return(invisible(FALSE))
  }

  all <- c(existing_lines, new)
  base::writeLines(
    all,
    con = path,
    useBytes = TRUE
    )

}

# escape_path ------------------
# from https://github.com/r-lib/usethis/blob/85327feeec22ab2f6f46efcd2d3d0a4b010f132b/R/ignore.R#L31
escape_path <- function(x) {
  x <- gsub("\\.", "\\\\.", x)
  x <- gsub("/$", "", x)
  paste0("^", x, "$")
}
