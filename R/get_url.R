# get_url_bioconductor_package -------------------------------------------------
get_url_bioconductor_package <- function(package) {

  paste0(
    "https://bioconductor.org/packages/release/bioc/html/", package, ".html"
  )
}

# get_url_cran_package ---------------------------------------------------------
# CRAN canonical URL
get_url_cran_package <- function(package) {

  paste0("https://CRAN.R-project.org/package=", package)
}

# get_url_github_package -------------------------------------------------------
get_url_github_package <- function(provider_name) {

  commit <- gsub(".*@", "", provider_name)
  commit <- gsub("\\)", "", commit)

  link <- gsub(".*\\(", "", provider_name)
  link <- gsub("@.*", "", link)

  paste0("https://github.com/", link, "/commit/", commit)
}

# get_url_github_account -------------------------------------------------------
get_url_github_account <- function(user) {

  paste0("https://github.com/", user)
}

# get_url_rhub -----------------------------------------------------------------
get_url_rhub <- function(a, b) {

  sprintf("https://sysreqs.r-hub.io/%s/%s", a, b)
}
