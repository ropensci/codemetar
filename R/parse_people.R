## internal method, takes R person object and turns to codemeta / json-ld

## FIXME if @id is available, avoid replicate listing of node?

#' @importFrom utils as.person
parse_people <- function(people, codemeta){

  ## listing same person under multiple fields is inelegant?
  codemeta$author <- people_with_role(people, "aut")
  codemeta$contributor <- people_with_role(people, "ctb")
  codemeta$copyrightHolder <- people_with_role(people, "cph")
  codemeta$maintainer <- people_with_role(people, "cre")
  codemeta
}

people_with_role <- function(people, role = "aut"){
  has_role <- locate_role(people, role)
  if(any(has_role)){
    out <- lapply(people[has_role], person_to_schema)
  } else {
    out <- NULL
  }
  if(role == "cre"){ # Can have only single maintainer, not list
    out <- out[[1]]
  }
  out
}

locate_role <- function(people, role = "aut"){
  vapply(people, function(p) any(grepl(role, p$role)), logical(1))
}

person_to_schema <- function(p){

  ## Store ORCID id in comment?
  id <- NULL
  if(!is.null(p$comment)){
    if(grepl("orcid", p$comment)){
      id <- p$comment
    }
  }

  ## assume type is Organization if family name is null
  if(is.null(p$family) || is.null(p$given))
    type <- "Organization"
  else
    type <- "Person"

  out <- switch(type,
         "Person" =   list("@type" = type,
                           givenName = p$given,
                           familyName = p$family),
         "Organization" = list("@type" = type,
                               name = c(p$given,p$family))
  )

  ## we don't want `{}` if none is found
  if(!is.null(p$email)){
    out$email <- p$email
  }
  if(!is.null(id)){
    out$`@id` <- id
  }

  out

}
