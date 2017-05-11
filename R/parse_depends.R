## internal method for parsing a list of package dependencies into pkg URLs



parse_depends <- function(deps){
  if(!is.null(deps))
    str <- strsplit(deps, ",\n*")[[1]]
  else
    str <- NULL

  lapply(str, function(str){

    if(length(str) > 1){
      warning(paste0("package depends", str, "may be multiple packages?"))
      }

    pkg <- gsub("\\s*(\\w+)\\s.*", "\\1", str)
    pkg <- gsub("\\s+", "", pkg)

    out <- list("@type" = "SoftwareApplication",
                name = pkg)

    ## Add Version if available
    pattern <- "\\s*\\w+\\s+\\([><=]+\\s([1-9.\\-]*)\\)*"
    version <- gsub(pattern, "\\1", str)
    has_version  <- grepl(pattern, str)
    if(has_version)
      out$version <- version

    out$provider <- guess_provider(pkg)

    out
  })
}

