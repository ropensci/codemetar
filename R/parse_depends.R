## internal method for parsing a list of package dependencies into pkg URLs

format_depend <- function(package, version, remote_provider,
                          verbose = FALSE) {

  dep <- list(
    "@type" = "SoftwareApplication",
    identifier = package,
    ## FIXME technically the name includes the title
    name = package
  )

  ## Add Version if available
  if (version != "*") {

    dep$version <- version
  }

  dep$provider <- guess_provider(package, verbose)

  ## implemention could be better, e.g. support versioning
  #  dep$`@id` <- guess_dep_id(dep)

  sameAs <- get_sameAs(dep$provider, remote_provider, dep$identifier)

  if (! is.null(sameAs)) {

    dep$sameAs <- sameAs
  }

  return(dep)
}

## Get sameAs element for dep or NULL if not applicable
get_sameAs <- function(provider, remote_provider, identifier) {

  # assign each keyword a function that returns the URL to a given package name
  url_generators <- list(
    "Comprehensive R Archive Network (CRAN)" = get_url_cran_package,
    "BioConductor" = get_url_bioconductor_package
  )

  # The remote provider takes precedence over the non-remote provider
  if (remote_provider != "") {

    get_url_github(gsub("github::", "", remote_provider))

  } else if (! is.null(provider) && provider$name %in% names(url_generators)) {

    url_generators[[provider$name]](identifier)

  } # else NULL implicitly
}


parse_depends <- function(deps, verbose = FALSE) {

  purrr::pmap(
    list(deps$package, deps$version, deps$remote_provider),
    format_depend,
    verbose = verbose
  )
}


## FIXME these are not version-specific. That's often not accurate, though does
## reflect the CRAN assumption that you must be compatible with the latest
## version...
guess_dep_id <- function(dep) {

  if (dep$name == "R") {

    ## FIXME No good identifier for R, particularly none for specific version
    return("https://www.r-project.org")
  }

  # mapping between base URL patterns and functions generating full URLs
  url_generators <- list(
    "cran.r-project.org" = get_url_cran_package_2,
    "www.bioconductor.org" = get_url_bioconductor_package_2
  )

 if (! is.null(dep$provider)) {

    provider_url <- dep$provider$url

    # Try to find a matching URL generator function
    is_matching <- sapply(names(url_generators), grepl, x = provider_url)

    if (any(is_matching)) {

      url_generators[[which(is_matching)[1]]](provider_url, dep$identifier)

    } # else NULL implicitly

  } # else NULL implicitly
}


add_remote_to_dep <- function(package, remotes) {

  remote_providers <- grep(paste0("/", package, "$"), remotes, value = TRUE)

  if (length(remote_providers)) remote_providers else ""
}


# helper to get system dependencies
get_sys_links <- function(pkg, description = "", verbose = FALSE) {
  if (verbose) {
    cli::cat_bullet("Getting sysreqs URL from sysreqs API", bullet = "continue")
  }

  get_url_rhub("get", unique(c(
    get_rhub_json_names("pkg", pkg),
    get_rhub_json_names("map", curl::curl_escape(description))
  )))

  if (verbose) {
    cli::cat_bullet("Got sysreqs URL from sysreqs API!", bullet = "tick")
  }
}

get_rhub_json_names <- function(a, b) {

  sapply(
    X = jsonlite::fromJSON(get_url_rhub(a, b), simplifyVector = FALSE),
    FUN = names
  )
}

format_sys_req <- function(url) {

  list("@type" = "SoftwareApplication", identifier = url)
}

#' @importFrom pingr is_online
parse_sys_reqs <- function(pkg, sys_reqs, verbose = FALSE) {

  if(!pingr::is_online()) return(NULL)

  urls <- get_sys_links(pkg, description = sys_reqs, verbose)
  purrr::map(urls, format_sys_req)
}
