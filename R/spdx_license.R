
#' @importFrom utils read.csv
spdx_license <- function(x){

  ##license <-  gsub("(.*) \\+ file (LICENSE|LICENCE)$", "\\1", tools:::analyze_license(x)$expansions[[1]])

  components <- trimws(unlist(strsplit(x, "|", fixed = TRUE)))

  ## Basic attempt to normalize >= or == VERSION statements
  components <- gsub("\\([=>]= (\\d+\\.*\\d*)\\)", "\\1", components)

  license <- gsub("(.*) \\+ file (LICENSE|LICENCE)$", "\\1", components[[1]])

  cran_to_spdx <- read.csv(system.file("extdata/cran-to-spdx.csv", package="codemetar"))
  spdx <- cran_to_spdx$SPDX[ cran_to_spdx$CRAN == license ]

  ## Stick with parsed term if we failed to match
  if(length(spdx) == 0){
    spdx <- license
  }

  ## Use URL format, as that is the expected type
  paste0("https://spdx.org/licenses/", spdx)

}


# Translate CRAN to SPDX License
#
# @description A map of CRAN licenses to SPDX license IDs
# @source \url{https://spdx.org/licenses}
## "cran_to_spdx"




## R recognizes certain strings like:
#"Creative Commons Attribution 3.0 Unported License" and expansions for them: "CC BY 3.0"

## Can have multiple alternate licenses using "|"
#  components <- trimws(unlist(strsplit(x, "|", fixed = TRUE)))

#ok <- grepl(components, tools:::R_license_db_vars()$re_component)


