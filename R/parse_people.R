## internal method, takes R person object and turns to codemeta / json-ld

## FIXME if @id is available, avoid replicate listing of node?
parse_people <- function(people, codemeta){

  ## listing same person under multiple fields is inelegant?
  codemeta$author <- lapply(people[ locate_role(people, "aut") ], person_to_schema)
  codemeta$contributor <- lapply(people[ locate_role(people, "ctb") ], person_to_schema)
  codemeta$copyrightHolder <- lapply(people[ locate_role(people, "cph") ], person_to_schema)
  codemeta$maintainer <- person_to_schema(people[ locate_role(people, "cre") ])
  codemeta
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
  if(is.null(p$family))
    type <- "Organization"
  else
    type <- "Person"
  list("@id" = id,
       "@type" = type,
       givenName = p$given,
       familyName = p$family,
       email = p$email)
}
