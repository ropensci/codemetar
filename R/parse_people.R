# parse_people -----------------------------------------------------------------
## internal method, takes R person object and turns to codemeta / json-ld
## FIXME if @id is available, avoid replicate listing of node?
#' @importFrom utils as.person
#' @importFrom methods is
parse_people <- function(people, codemeta) {

  people <- as.person(people)

  if (length(people) == 0) {

    return(codemeta)
  }

  ## people with no role are assumed to be "Author" role
  role_mapping <- list(
    author = c("aut", NA), # NA = people without a role
    contributor = c("ctb", "com", "dtc", "ths", "trl"),
    copyrightHolder = "cph",
    funder = "fnd",
    maintainer = "cre"
  )

  # get the names of the role entries in codemeta as given in role_mapping
  roles <- names(role_mapping)

  # call people_with_role on each element of role_mapping and assign the
  # resulting lists to the corresponding entries in codemeta
  codemeta[roles] <- lapply(role_mapping, people_with_role, people = people)

  # return codemeta
  codemeta
}

# people_with_role -------------------------------------------------------------
people_with_role <- function(people, role = "aut") {

  # If there is more than one role requested, call this function recursively
  # for each role, combine the results with c() and return
  if (length(role) > 1) {

    return(do.call(c, lapply(role, people_with_role, people = people)))
  }

  # if role is NA, has_role is TRUE for all people without any role!
  has_role <- locate_role(people, role)

  # return NULL if there are no people with the required (or without any) role
  if (! any(has_role)) {

    return(NULL)
  }

  # create schema for each person with the selected (or without any) role
  lapply(people[has_role], person_to_schema)
}

# locate_role ------------------------------------------------------------------
# role = NA returns TRUE for all people without a role
#' @importFrom purrr map_lgl
locate_role <- function(people, role = "aut") {

  has_no_role <- function(p) is.null(p$role)
  has_role <- function(p, role) any(grepl(role, p$role))

  if (is.na(role)) {

    purrr::map_lgl(people, has_no_role)

  } else {

    purrr::map_lgl(people, has_role, role = role)
  }
}

# person_to_schema -------------------------------------------------------------
person_to_schema <- function(p) {

  p <- as.person(p)

  if (length(p) == 0) {

    return(NULL)
  }

  ## Store ORCID id in comment?
  id <- NULL

  if (!is.null(p$comment)) {

    if (grepl("orcid", p$comment)) {

      id <- p$comment

    } else if ("ORCID" %in% names(p$comment)) {

      id <- p$comment[["ORCID"]]

      if (! grepl("^https?", id))

        id <- paste0("https://orcid.org/", id)
    }
  }

  ## assume type is Organization if family name is null
  type <- get_type_of_person(p)

  out <- switch(
    type,
    "Person" =   list(
      "@type" = type,
      givenName = p$given,
      familyName = p$family
    ),
    "Organization" = list(
      "@type" = type,
      name = c(p$given, p$family)
    )
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

# get_type_of_person -----------------------------------------------------------
get_type_of_person <- function(p) {

  stopifnot(inherits(p, "person"))

  if (is.null(p$family) || is.null(p$given)) {

    "Organization"

  } else {

    "Person"
  }
}
