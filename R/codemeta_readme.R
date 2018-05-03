codemeta_readme <- function(readme, codemeta){
  if (is.null(codemeta$contIntegration)){
    codemeta$contIntegration <- guess_ci(readme)
  }

  if (is.null(codemeta$developmentStatus)){
    codemeta$developmentStatus <-
      guess_devStatus(readme)
  }

  if (is.null(codemeta$review)){
    codemeta$review <-
      guess_ropensci_review(readme)
  }

  codemeta
}
