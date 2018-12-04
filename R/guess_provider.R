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
