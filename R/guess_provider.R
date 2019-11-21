#
# Helper functions below
#

# .CRAN ------------------------------------------------------------------------
## cache available packages
.CRAN <- function() {

  suppressWarnings(
    available_source_packages("https://cran.rstudio.com"))
}

# .BIOC ------------------------------------------------------------------------
.BIOC <- function() {

  suppressWarnings(
    available_source_packages("https://www.bioconductor.org/packages/release/bioc"))
}

# CRAN -------------------------------------------------------------------------
CRAN <- memoise::memoise(.CRAN)

# BIOC -------------------------------------------------------------------------
BIOC <- memoise::memoise(.BIOC)

# guess_provider ---------------------------------------------------------------
guess_provider <- function(pkg) {

  if (is.null(pkg)) {

    return(NULL)
  }

  ## Assumes a single provider
  if (is_cran_package(pkg)) {

    new_codemeta_organization(
      url = "https://cran.r-project.org",
      name = "Comprehensive R Archive Network (CRAN)"
    )

  } else if (is_bioconductor_package(pkg)) {

    new_codemeta_organization(
      url = "https://www.bioconductor.org",
      name = "BioConductor"
    )

  } else {

    NULL
  }
}

#
# Helper functions can later be moved to utils.R
#

# available_source_packages ----------------------------------------------------
available_source_packages <- function(url) {

  utils::available.packages(utils::contrib.url(url, "source"))
}

# is_cran_package --------------------------------------------------------------
is_cran_package <- function(pkg) {

  is_in_package_info(pkg, CRAN())
}

# is_bioconductor_package ------------------------------------------------------
is_bioconductor_package <- function(pkg) {

  is_in_package_info(pkg, BIOC())
}

# is_in_package_info -----------------------------------------------------------
#' @param pkg package name
#' @param package_info data frame or matrix with column \code{Package}, eg.
#'   as returned by \code{\link[utils]{available.packages}}
#' @noRd
is_in_package_info <- function(pkg, package_info) {

  pkg %in% package_info[, "Package"]
}

# new_codemeta_organization ----------------------------------------------------
new_codemeta_organization <- function(url, name) {

  list(
    "@id" = url,
    "@type" = "Organization",
    "name" = name,
    "url" = url
  )
}
