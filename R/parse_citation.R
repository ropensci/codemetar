## map a "citation" or "bibentry" R object into schema.org
# bib <- citation(pkg)

#' @importFrom stringi stri_trans_general
parse_citation <- function(bib) {

  type <- bib$bibtype %>%
    stringi::stri_trans_general(id = "Title") %>%
    bibentry_to_schema_field()

  author <- parse_people(bib$author, new_codemeta())$author

  out <- drop_null(list(
    "@type" = type,
    "datePublished" = bib$year,
    "author" = author,
    "name" = bib$title,
    "identifier" = bib$doi,
    "url" = bib$url,
    "description" = bib$note,
    "paginiation" = bib$pages
  ))

  ## determine "@id" / "sameAs" from doi, converting doi to string
  doi <- bib$doi

  if (! is.null(doi)) {

    id <- if (grepl("^10.", doi)) {

      paste0("https://doi.org/", doi)

    } else if (grepl("^https://doi.org", doi)) {

      doi
    }

    out$`@id` <- id

    out$sameAs <- id
  }

  if (! is.null(bib$journal)) {

    journal_part <- list(

      "isPartOf" = drop_null(list(
        "@type" = "PublicationIssue",
        "issueNumber" = bib$number,
        "datePublished" = bib$year,
        "isPartOf" = drop_null(list(
          "@type" = c("PublicationVolume", "Periodical"),
          "volumeNumber" = bib$volume,
          "name" = bib$journal
        ))
      ))
    )

    out <- c(out, journal_part)
  }

  out
}

# bibentry_to_schema_field -----------------------------------------------------

## All recognized bibentry types:
## N.B. none of these types are in the 2.0 context,
## so would need to include schema.org context

bibentry_to_schema_field <- function(bibtype) {

  switch(
    bibtype,
    "Article" = "ScholarlyArticle", "Book" = "Book", "Booklet" = "Book",
    "Inbook" = "Chapter", "Incollection" = "CreativeWork",
    "Inproceedings" = "ScholarlyArticle", "Manual" = "SoftwareSourceCode",
    "Mastersthesis" ="Thesis", "Misc" = "CreativeWork", "Phdthesis" = "Thesis",
    "Proceedings" = "ScholarlyArticle", "Techreport" = "ScholarlyArticle",
    "Unpublished" = "CreativeWork"
  )
}

## guessCitation referencePublication or citation?

## Handle installed package by name, source pkg by path (inst/CITATION)

#' @importFrom utils readCitationFile citation
guess_citation <- function(pkg) {

  root <- get_root_path(pkg)

  installed <- installed.packages()

  if (file.exists(file.path(root, "inst/CITATION"))) {

    encoding <- desc::desc(file.path(root, "DESCRIPTION"))$get("Encoding")

    if (! is.na(encoding)) {

      bib <- utils::readCitationFile(
        file.path(root, "inst/CITATION"), meta = list(Encoding = encoding)
      )

    } else {

      bib <- utils::readCitationFile(file.path(root, "inst/CITATION"))
    }

    lapply(bib, parse_citation)

  } else if (pkg %in% installed[, 1]) {

    bib <- suppressWarnings(utils::citation(pkg)) # don't worry if no date
    lapply(bib, parse_citation)

  } else {

    NULL
  }

  ## drop self-citation file?
}
