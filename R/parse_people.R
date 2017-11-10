## internal method, takes R person object and turns to codemeta / json-ld

## FIXME if @id is available, avoid replicate listing of node?

#' @importFrom utils as.person
#' @importFrom methods is
parse_people <- function(people, codemeta) {
  if (!is(people, "person")) {
    people <- as.person(people)
  }
  if (length(people) == 0) {
    return(codemeta)
  }

  ## people with no role are assumed to be "Author" role
  codemeta$author <-
    c(people_with_role(people, "aut"),
      people_without_role(people))
  codemeta$contributor <- people_with_role(people, "ctb")
  codemeta$copyrightHolder <- people_with_role(people, "cph")
  codemeta$maintainer <- people_with_role(people, "cre")
  codemeta
}

people_without_role <- function(people) {
  index <- vapply(people, function(p)
    is.null(p$role), logical(1))
  lapply(people[index], person_to_schema)
}

people_with_role <- function(people, role = "aut") {
  has_role <- locate_role(people, role)
  if (any(has_role)) {
    out <- lapply(people[has_role], person_to_schema)
  } else {
    out <- NULL
  }
  if (role == "cre") {
    # Can have only single maintainer, not list
    out <- out[[1]]
  }
  out
}

locate_role <- function(people, role = "aut") {
  vapply(people, function(p)
    any(grepl(role, p$role)), logical(1))
}

person_to_schema <- function(p) {
  if (!is(p, "person")) {
    p <- as.person(p)
  }
  if (length(p) == 0) {
    return(NULL)
  }

  ## Store ORCID id in comment?
  id <- NULL
  if (!is.null(p$comment)) {
    if (grepl("orcid", p$comment)) {
      id <- p$comment
    } else if("ORCID" %in% names(p$comment)){
      id <- p$comment[["ORCID"]]
      if(!grepl("^http", id))
        id <- paste0("http://orcid.org/", id)
    }
  }

  ## assume type is Organization if family name is null
  if (is.null(p$family) || is.null(p$given))
    type <- "Organization"
  else
    type <- "Person"

  out <- switch(
    type,
    "Person" =   list(
      "@type" = type,
      givenName = p$given,
      familyName = p$family
    ),
    "Organization" = list("@type" = type,
                          name = c(p$given, p$family))
  )

  ## we don't want `{}` if none is found
  if (!is.null(p$email)) {
    out$email <- p$email
  }
  if (!is.null(id)) {
    out$`@id` <- id
  }

  out

}
