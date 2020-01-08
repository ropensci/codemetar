# url_codemeta_schema ----------------------------------------------------------
url_codemeta_schema <- function() {

  "https://doi.org/10.5063/schema/codemeta-2.0"
}

# Set codemeta schema as an option ---------------------------------------------
options(codemeta_context = url_codemeta_schema())

# new_codemeta -----------------------------------------------------------------
## Supporting old versions will be a nuciance
new_codemeta <- function() {

  list(`@context` = getOption("codemeta_context", url_codemeta_schema()),
       `@type` = "SoftwareSourceCode")
}

# additional_codemeta_terms ----------------------------------------------------
additional_codemeta_terms <- function() {

  c("affiliation",
    "applicationCategory",
    "applicationSubCategory",
    "copyrightYear",
    "dateCreated",
    "dateModified",
    "downloadUrl",
    "editor",
    "fileSize",
    "funder",
    "identifier",
    "installUrl",
    "isAccessibleForFree",
    "isPartOf",
    "keywords",
    "memoryRequirements",
    "operatingSystem",
    "permissions",
    "processorRequirements",
    "producer",
    "provider",
    "publisher",
    "funding",
    "relatedLink",
    "releaseNotes",
    "sameAs",
    "softwareHelp",
    "sponsor",
    "storageRequirements",
    "supportingData",
    "targetProduct",
    "contIntegration",
    "buildInstructions",
    "developmentStatus",
    "embargoDate",
    "readme",
    "issueTracker",
    "referencePublication"
  )
}

# codemeta_description ---------------------------------------------------------
# Can add to an existing codemeta document
codemeta_description <- function(file, id = NULL, codemeta = new_codemeta(),
                                 verbose = FALSE) {

  if (! file.exists(file)) {

    return(codemeta)
  }

  descr <- desc::desc(file)

  # Store the package name in its own variable as it is used more than once
  package_name <- descr$get("Package")

  ## FIXME define an S3 class based on the codemeta list of lists?

  if (is.null(id)) {
    id <- package_name
  }

  if (is_IRI(id)) {
    codemeta$`@id` <- id
  }

  codemeta$identifier <- package_name
  codemeta$description <- descr$get("Description")
  codemeta$name <- paste0(package_name, ": ", descr$get("Title"))

  ## add repository related terms
  codemeta <- add_repository_terms(codemeta, descr)

  if (! is.na(issue_tracker <- descr$get("BugReports"))) {
    codemeta$issueTracker <- issue_tracker
  }

  ## According to crosswalk, codemeta$dateModified and
  ## codemeta$dateCreated are not crosswalked in DESCRIPTION
  codemeta$datePublished <- NULL

  codemeta$license <- spdx_license(descr$get("License"))

  codemeta$version <- as.character(descr$get_version())

  ## add progr. language related terms: programmingLanguage, runtimePlatform
  codemeta <- add_language_terms(codemeta)

  if (is.null(codemeta$provider)) {
    codemeta$provider <- guess_provider(package_name, verbose)
  }

  ## add person related terms
  codemeta <- add_person_terms(codemeta, descr)

  ## add software related terms: softwareSuggestions, softwareRequirements
  codemeta <- add_software_terms(codemeta, descr, verbose)

  ## add any additional codemeta terms found in the DESCRIPTION metadata
  codemeta <- add_additional_terms(codemeta, descr)

  # return codemeta
  codemeta
}

# add_repository_terms ---------------------------------------------------------
add_repository_terms <- function(codemeta, descr) {

  ## Get URLs
  code_repo <- descr$get_urls()

  if (! is.na(code_repo[1])) {

    if (length(code_repo) == 1) {

      # only one, easy
      codemeta$codeRepository <- code_repo

    } else {

      # try to identify a code repo
      actual_code_repo <- code_repo[urltools::domain(code_repo) %in%
                                      source_code_domains()][1]

      # otherwise take the first URL arbitrarily
      if (is.na(actual_code_repo)) {
        codemeta$codeRepository <- code_repo[1]
      } else {
        # no direct link to README please
        urltools::fragment(actual_code_repo) <- NULL

        codemeta$codeRepository <- actual_code_repo

      }

      # add other URLs as related links
      codemeta$relatedLink <- unique(c(
        codemeta$relatedLink,
        code_repo[code_repo != actual_code_repo]
      ))
    }
  }

  codemeta
}

# add_language_terms -----------------------------------------------------------
add_language_terms <- function(codemeta) {

  codemeta$programmingLanguage <- list(
    "@type" = "ComputerLanguage",
    name = R.version$language,
    version = paste(R.version$major, R.version$minor, sep = "."),
    # According to Crosswalk, we just want numvers and not R.version.string
    url = "https://r-project.org"
  )

  ## According to schema.org, programmingLanguage doesn't have a version;
  ## but runtimePlatform, a plain string, does.
  codemeta$runtimePlatform <- R.version.string

  codemeta
}

# add_person_terms -------------------------------------------------------------
add_person_terms <- function(codemeta, descr) {

  author <- try(descr$get_authors(), silent = TRUE)

  if (inherits(author, 'try-error')) {

    # get author and maintainer from their fields
    # and don't get maintainer twice!
    author <- as.person(descr$get("Author"))

    maintainer <- descr$get_maintainer()
    maintainer <- as.person(paste(maintainer))
    maintainer$role <- "cre"

    author_strings <- paste(author$given, author$family)
    maintainer_strings <- paste(maintainer$given, maintainer$family)

    author <- author[! author_strings %in% maintainer_strings]

    author <- c(author, maintainer)
  }

  codemeta <- parse_people(author, codemeta)

  codemeta
}

# add_software_terms -----------------------------------------------------------
add_software_terms <- function(codemeta, descr, verbose = FALSE) {

  dependencies <- descr$get_deps()

  remotes <- descr$get_remotes()

  suggests <- add_remote_provider(
    dependencies[dependencies$type == "Suggests", ],
    remotes = remotes
  )

  requirements <- add_remote_provider(
    dependencies[dependencies$type %in% c("Imports", "Depends"), ],
    remotes = remotes
  )

  codemeta$softwareSuggestions <- parse_depends(suggests, verbose)

  codemeta$softwareRequirements <- c(
    parse_depends(requirements, verbose = verbose),
    parse_sys_reqs(descr$get("Package"), descr$get("SystemRequirements"),
                   verbose)
  )

  codemeta
}

# add_remote_provider ----------------------------------------------------------
add_remote_provider <- function(x, remotes) {

  x$remote_provider <- unlist(lapply(
    x$package, add_remote_to_dep, remotes = remotes
  ))

  x
}

# add_additional_terms ---------------------------------------------------------
add_additional_terms <- function(codemeta, descr) {

  ## in DESCRIPTION, these terms must be *prefixed*:
  x_terms <- paste0("X-schema.org-", (terms <- additional_codemeta_terms()))

  ## Which terms are given in DESCRIPTION, which are not?
  is_given <- sapply(x_terms, function(x) ! is.na(descr$get(x)))

  ## Get the first elements of the given x-terms and set the corresponding
  ## elements in codemeta
  codemeta[terms[is_given]] <- lapply(x_terms[is_given], function(x_term) {

    gsub("\\s+", "", strsplit(descr$get(x_term), ",")[[1]])
  })

  codemeta
}

github_domains <- function() {
  c("github.com", "www.github.com")
}

source_code_domains <- function() {
  c(github_domains(),
    "gitlab.com",
    "r-forge.r-project.org",
    "bitbucket.org")
}
