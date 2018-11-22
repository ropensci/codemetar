## map a "citation" or "bibentry" R object into schema.org
# bib <- citation(pkg)

#' @importFrom stringi stri_trans_general
parse_citation <- function(bib){
  cm <- parse_people(bib$author, new_codemeta())
  authors <- cm$author

  bibtype <- bib$bibtype
  bibtype <- stringi::stri_trans_general(bibtype, id = "Title")
  ## All recognized bibentry types:
  ## N.B. none of these types are in the 2.0 context,
  ## so would need to include schema.org context
  type <- switch(bibtype,
    "Article" = "ScholarlyArticle", "Book" = "Book", "Booklet" = "Book",
    "Inbook" = "Chapter", "Incollection" = "CreativeWork",
    "Inproceedings" = "ScholarlyArticle", "Manual" = "SoftwareSourceCode",
    "Mastersthesis" ="Thesis", "Misc" = "CreativeWork", "Phdthesis" = "Thesis",
    "Proceedings" = "ScholarlyArticle", "Techreport" = "ScholarlyArticle",
    "Unpublished" = "CreativeWork")


  out <-
    drop_null(list(
      "@type" = type,
      "datePublished" = bib$year,
      "author" = authors,
      "name" = bib$title,
      "identifier" = bib$doi,
      "url" = bib$url,
      "description" = bib$note,
      "paginiation" = bib$pages))


  ## determine "@id" / "sameAs" from doi, converting doi to string
  doi <- bib$doi
  if(!is.null(doi)){
    if(grepl("^10.", doi)){
      id <- paste0("https://doi.org/", doi)
    } else if(grepl("^https://doi.org", doi)){
      id <- doi
    }
    out$`@id` <- id
    out$sameAs <- id
  }


  if(!is.null(bib$journal)){
  journal_part <- list(
    "isPartOf" = drop_null(list(
      "@type" = "PublicationIssue",
      "issueNumber" = bib$number,
      "datePublished" = bib$year,
      "isPartOf" =
        drop_null(list(
        "@type" = c("PublicationVolume", "Periodical"),
        "volumeNumber" = bib$volume,
        "name" = bib$journal))
      )))
    out <- c(out, journal_part)
  }
  out
}


## guessCitation referencePublication or citation?

## Handle installed package by name, source pkg by path (inst/CITATION)

#' @importFrom utils readCitationFile citation
guess_citation <- function(pkg){
  root <- get_root_path(pkg)
  installed <- installed.packages()
  if(file.exists(file.path(root, "inst/CITATION"))){
    encoding <- desc::desc(file.path(root, "DESCRIPTION"))$get("Encoding")
    if(!is.na(encoding)){
      bib <- utils::readCitationFile(file.path(root, "inst/CITATION"),
                                     meta = list(Encoding = encoding))
    }else{
      bib <- utils::readCitationFile(file.path(root, "inst/CITATION"))
    }

    lapply(bib, parse_citation)
  } else if(pkg %in% installed[,1]){
    bib <- suppressWarnings(utils::citation(pkg)) # don't worry if no date
    lapply(bib, parse_citation)
  } else {
    NULL
  }

  ## drop self-citation file?

}

