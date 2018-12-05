# guess_ci ---------------------------------------------------------------------

## Based on CI badges, not config files
# only Travis, Appveyor and Circle CI
# also uses code coverage
guess_ci <- function(readme) {

  get_badge_links_matching(readme, "travis|appveyor|circleci|codecov|coveralls")
}

# guess_devStatus --------------------------------------------------------------

## Either repostatus.org or lifecycle badge
guess_devStatus <- function(readme) {

  get_badge_links_matching(readme, "repostatus\\.org|lifecycle")
}

# get_badge_links_matching -----------------------------------------------------
get_badge_links_matching <- function(readme, pattern) {

  badges <- extract_badges(readme)

  if (length(links <- grep(pattern, badges$link, value = TRUE))) {

    links
  }
  # else NULL implicitly
}

# get_pkg_name -----------------------------------------------------------------
get_pkg_name <- function(entry) {

  if (is.null(result <- entry$pkgname)) "" else result
}

# .ropensci_reviews ------------------------------------------------------------
# looks for a rOpenSci peer review badge
.ropensci_reviews <- function() {

  url_onboarded_json <- "https://badges.ropensci.org/json/onboarded.json"

  reviews <- jsonlite::read_json(url_onboarded_json)

  tibble::tibble(
    review = purrr::map_dbl(reviews, "iss_no"),
    package = purrr::map_chr(reviews, get_pkg_name)
  )
}

ropensci_reviews <- memoise::memoise(.ropensci_reviews)

# guess_ropensci_review --------------------------------------------------------
guess_ropensci_review <- function(readme) {

  url <- "github.com/ropensci/onboarding/issues/"

  badges <- get_badge_links_matching(readme, url)

  if (is.null(badges)) {

    return(NULL)
  }

  review <- as.numeric(stringr::str_remove(badges, paste0(".*https://", url)))

  if (review %in% ropensci_reviews()$review) {

    list("@type" = "Review",
         "url" = paste0("https://", url, review),
         "provider" = "http://ropensci.org")
  }
  # else NULL implicitly
}

# guess_readme_url -------------------------------------------------------------
# find the readme
guess_readme_url <- function(root) {

  if (! uses_git(root)) {

    return(NULL)
  }

  github <- stringr::str_remove(guess_github(root), ".*com\\/")

  parts <- strsplit(github, "/")[[1]]

  readme <- try(silent = TRUE, gh::gh(
    "GET /repos/:owner/:repo/readme", owner = parts[1], repo = parts[2]
  ))

  if (! inherits(readme, "try-error")) {

    readme$html_url
  }
  # else NULL implicitly
}

# guess_readme_path ------------------------------------------------------------
guess_readme_path <- function(root) {

  readmes <- dir(root, pattern = "^README\\.R?md$", ignore.case = TRUE)

  if (length(readmes) == 0) {

    return(NULL)
  }

  readme_rmd <- grep("\\.[Rr]md$", readmes, value = TRUE)

  if (length(readme_rmd) == 0) {

    readme_file <- grep("\\.md$", readmes, value = TRUE)
  }

  readme_path <- file.path(root, readme_file)

  if (length(readme_path) > 1) {

    # README.md and ReadMe.md could both exist ...
    ## silently use the first match (locale-dependent)
    readme_path <- readme_path[1]
  }

  readme_path
}

# .guess_readme ----------------------------------------------------------------
.guess_readme <- function(root = ".") {

  list(
    readme_path = guess_readme_path(root),
    readme_url = guess_readme_url(root)
  )
}

guess_readme <- memoise::memoise(.guess_readme)

# codemeta_readme --------------------------------------------------------------
codemeta_readme <- function(readme, codemeta) {

  codemeta %>%
    set_element_if_null("contIntegration", guess_ci(readme)) %>%
    set_element_if_null("developmentStatus", guess_devStatus(readme)) %>%
    set_element_if_null("review", guess_ropensci_review(readme))
}

