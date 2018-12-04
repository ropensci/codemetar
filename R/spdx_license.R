#' @importFrom utils read.csv
spdx_license <- function(x) {
  components <- trimws(unlist(strsplit(x, "|", fixed = TRUE)))

  ## Basic attempt to normalize >= or == VERSION statements
  components <-
    gsub("\\([=>]= (\\d+\\.*\\d*)\\)", "\\1", components)

  license <-
    gsub("(.*) \\+ file (LICENSE|LICENCE)$", "\\1", components[[1]])

  cran_to_spdx <-
    read.csv(system.file("extdata/cran-to-spdx.csv", package = "codemetar"))
  spdx <- cran_to_spdx$SPDX[cran_to_spdx$CRAN == license]

  ## Stick with parsed term if we failed to match
  if (length(spdx) == 0) {
    return(license)
  }

  ## Use URL format, as that is the expected type
  paste0("https://spdx.org/licenses/", spdx)

}


# Translate CRAN to SPDX License
#
# @description A map of CRAN licenses to SPDX license IDs
# @source \url{https://spdx.org/licenses}
## "cran_to_spdx"
