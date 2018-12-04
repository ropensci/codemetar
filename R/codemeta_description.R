URL_CODEMETA_SCHEMA <- "https://doi.org/10.5063/schema/codemeta-2.0"

options(codemeta_context = URL_CODEMETA_SCHEMA)

## Supporting old versions will be a nuciance
new_codemeta <- function() {

  list(`@context` = getOption("codemeta_context", URL_CODEMETA_SCHEMA),
       `@type` = "SoftwareSourceCode")
}

# Additional codemeta terms
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


# Can add to an existing codemeta document
codemeta_description <- function(f, id = NULL, codemeta = new_codemeta()) {

    if (file.exists(f)) {
      descr <- desc::desc(f)
    } else {
      return(codemeta)
    }

    ## FIXME define an S3 class based on the codemeta list of lists?
    if (is.null(id)) {
      id <- descr$get("Package")
    }

    if (is_IRI(id)) {
      codemeta$`@id` <- id
    }

    codemeta$identifier <- descr$get("Package")
    codemeta$description <- descr$get("Description")
    codemeta$name <- paste0(descr$get("Package"), ": ", descr$get("Title"))

    ## Get URLs
    code_repo <- descr$get_urls()

    if (! is.na(code_repo[1])) {

      if (length(code_repo) == 1) {

        # only one, easy
        codemeta$codeRepository <- code_repo

      } else {

        # try to identify a GitHub or Gitlab repo
        actual_code_repo <- code_repo[
          grepl("github\\.com", code_repo) |
          grepl("gitlab\\.com", code_repo)
        ][1]

        # no direct link to README please
        actual_code_repo <- gsub("#.*", "", actual_code_repo)

        # otherwise take the first URL arbitrarily
        if (is.null(codemeta$Repository)) {
          codemeta$codeRepository <- actual_code_repo
        }

        # add other URLs as related links
        codemeta$relatedLink <- unique(c(
          codemeta$relatedLink,
          code_repo[code_repo != actual_code_repo]
        ))
      }
    }

    issue_tracker <- descr$get("BugReports")

    if (! is.na(issue_tracker)) {
      codemeta$issueTracker <- issue_tracker
    }

    ## According to crosswalk, codemeta$dateModified and
    ## codemeta$dateCreated are not crosswalked in DESCRIPTION
    codemeta$datePublished <- NULL

    codemeta$license <- spdx_license(descr$get("License"))

    codemeta$version <- as.character(descr$get_version())

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

    if (is.null(codemeta$provider)) {
      codemeta$provider <- guess_provider(descr$get("Package"))
    }

    author <- try(descr$get_authors(), silent = TRUE)

    if (! inherits(author,'try-error')) {

      codemeta <- parse_people(author, codemeta)

    } else {

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
      codemeta <- parse_people(author, codemeta)
    }

    dependencies <- descr$get_deps()

    type <- dependencies$type
    suggests <- dependencies[type == "Suggests",]
    requirements <- dependencies[type %in% c("Imports", "Depends"), ]

    remotes <- descr$get_remotes()

    suggests$remote_provider <- unlist(lapply(
      suggests$package, add_remote_to_dep, remotes = remotes
    ))

    requirements$remote_provider <- unlist(lapply(
      requirements$package, add_remote_to_dep, remotes = remotes
    ))

    codemeta$softwareSuggestions <- parse_depends(suggests)

    codemeta$softwareRequirements <- parse_depends(requirements)

    codemeta$softwareRequirements <- c(
      codemeta$softwareRequirements,
      parse_sys_reqs(descr$get("Package"), descr$get("SystemRequirements"))
    )

    ## add any additional codemeta terms found in the DESCRIPTION metadata

    for (term in additional_codemeta_terms()) {

      ## in DESCRIPTION, these terms must be *prefixed*:
      X_term <- paste0("X-schema.org-", term)

      if (! is.na(descr$get(X_term))) {

        codemeta[[term]] <- gsub("\\s+", "", strsplit(descr$get(X_term), ",")[[1]])
      }
    }

    codemeta
  }
