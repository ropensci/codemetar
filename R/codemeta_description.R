## Internal functions


## this appears not to be portable to devtools::check?
#options(codemeta_context =
#  "https://raw.githubusercontent.com/codemeta/codemeta/master/codemeta.jsonld")

options(codemeta_context = "https://doi.org/10.5063/schema/codemeta-2.0")
## Supporting old versions will be a nuciance
new_codemeta <- function() {
  list(`@context` = getOption("codemeta_context","https://doi.org/10.5063/schema/codemeta-2.0"),
       `@type` = "SoftwareSourceCode")
}


# Can add to an existing codemeta document
codemeta_description <-
  function(f, id = NULL, codemeta = new_codemeta()) {
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
    codemeta$name <- paste0(descr$get("Package"), ": ",
                            descr$get("Title"))


    ## Enforce good practice
    code_repo <- descr$get_urls()
    if (!is.na(code_repo[1])){
      if(length(code_repo) == 1){
        codemeta$codeRepository <- code_repo
      }else{
        codemeta$codeRepository <- code_repo[grepl("github\\.com", code_repo)|
                                 grepl("gitlab\\.com", code_repo)][1]
      }
    }

    issue_tracker <- descr$get("BugReports")
    if (!is.na(issue_tracker)){
      codemeta$issueTracker <- issue_tracker
    }



    ## According to crosswalk, codemeta$dateModified and
    ## codemeta$dateCreated are not crosswalked in DESCRIPTION
    codemeta$datePublished <- NULL

    codemeta$license <- spdx_license(descr$get("License"))

    codemeta$version <- as.character(descr$get_version())
    codemeta$programmingLanguage <-
      list(
        "@type" = "ComputerLanguage",
        name = R.version$language,
        version = paste(R.version$major, R.version$minor, sep = "."),
        # According to Crosswalk, we just want numvers and not R.version.string
        url = "https://r-project.org"
      )
    ## According to schema.org, programmingLanguage doesn't have a version;
    ## but runtimePlatform, a plain string, does.
    codemeta$runtimePlatform <- R.version.string

    if (is.null(codemeta$provider))
      codemeta$provider <- guess_provider(descr$get("Package"))
      authors <- try(descr$get_authors(), silent = TRUE)
    if (!inherits(authors,'try-error')) {
      codemeta <-
        parse_people(authors, codemeta)
    } else {
      # get authors and maintainer from their fields
      # and don't get maintainer twice!
      authors <- as.person(descr$get("Author"))
      maintainer <- descr$get_maintainer()
      maintainer <- as.person(paste(maintainer, "[cre]"))
      authors <- authors[!(authors$given == maintainer$given & authors$family == maintainer$family)]
      authors <- c(authors, maintainer)
      codemeta <-
        parse_people(authors, codemeta)
    }

    dependencies <- descr$get_deps()
    suggests <- dependencies[dependencies$type == "Suggests",]
    requirements <- dependencies[dependencies$type %in%
                                   c("Imports", "Depends"),]

    codemeta$softwareSuggestions <- parse_depends(suggests)
    codemeta$softwareRequirements <- parse_depends(requirements)



    ## add any additional codemeta terms found in the DESCRIPTION metadata
    for(term in additional_codemeta_terms){
      ## in DESCRIPTION, these terms must be *prefixed*:
      X_term <- paste0("X-schema.org-", term)
      if(!is.null(descr[[X_term]])){
        codemeta[[term]] <- gsub("\\s+", "",
                                 strsplit(descr[[X_term]], ",")[[1]])
      }
    }

    codemeta

  }



additional_codemeta_terms <-
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



