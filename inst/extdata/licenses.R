

cran <- tools:::R_license_db()
resp <- httr::GET(paste0("https://github.com/spdx/license-list/",
                         "blob/master/spdx_licenselist_v2.6.xls?raw=true"))
writeBin(httr::content(resp,as="raw"), "spdx.xls")
spdx <- readxl::read_excel("spdx.xls")

## Manual synthesis happens here ##

cran_to_spdx <- readr::read_csv("data-raw/cran-to-spdx.csv")
usethis::use_data(cran_to_spdx, overwrite = TRUE)
