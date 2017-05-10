## internal method for parsing a list of package dependencies into pkg URLs


## cache avail packages
avail <- utils::available.packages(utils::contrib.url("https://cran.rstudio.com", "source"))


## FIXME: makes a list of package URLs.  Technically we could declare a different type for these, e.g. SoftwareApplication or SoftwareSourceCode

#' @importFrom utils available.packages contrib.url
parse_depends <- function(deps){
  if(!is.null(deps))
    str <- strsplit(deps, ",\n*")[[1]]
  else
    str <- NULL

  out <- lapply(str, function(str){

    ## this is vectorized, though we apply it pkg by pkg anyhow

    pkgs <- gsub("\\s*(\\w+)\\s.*", "\\1", str)
    pattern <- "\\s*\\w+\\s+\\([><=]+\\s([1-9.\\-]*)\\)*"
    versions <- gsub(pattern, "\\1", str)
    ## We want a NULL, not the full string, if no match is found
    nomatch  <- !grepl(pattern, str)
    versions[nomatch] <- NA

    pkgs <- gsub("\\s+", "", pkgs)

    ## Check if pkg is on CRAN
    if(all(pkgs %in% avail[,"Package"]))
      pkgs <- paste0("https://cran.r-project.org/package=", pkgs)
    else{
      message(paste("could not find URL for package", pkgs, "since it is not available on CRAN."))
    }
    pkgs
  })

  out
}
