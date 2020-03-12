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

# which_url_matches_badge_link -------------------------------------------------
which_url_matches_badge_link <- function(readme, patterns) {
  badges <- extract_badges(readme)
  z <- vapply(patterns, function(z) any(grepl(z, x = badges$link)), logical(1))
  names(which(z))
}

# get_pkg_name -----------------------------------------------------------------
get_pkg_name <- function(entry) {

  if (is.null(result <- entry$pkgname)) "" else result
}

# .ropensci_reviews ------------------------------------------------------------
# looks for a rOpenSci peer review badge
.ropensci_reviews <- function() {

  url_onboarded_json <- "https://badges.ropensci.org/json/onboarded.json"

  reviews <- suppressWarnings(
    try(jsonlite::read_json(url_onboarded_json),
                 silent = TRUE))

  if (is(reviews, "try-error")) {
    return(tibble::tibble(
      review = 0,
      package = "Nope"
    ))
  }

  tibble::tibble(
    review = purrr::map_dbl(reviews, "iss_no"),
    package = purrr::map_chr(reviews, get_pkg_name)
  )
}

ropensci_reviews <- memoise::memoise(.ropensci_reviews)

# guess_ropensci_review --------------------------------------------------------
guess_ropensci_review <- function(readme) {

  url <- "github.com/ropensci/onboarding/issues/"
  url2 <- "github.com/ropensci/software-review/issues/"

  badges <- get_badge_links_matching(readme, paste0(url, "|", url2))

  if (is.null(badges)) {

    return(NULL)
  }

  url_m <- which_url_matches_badge_link(readme, c(url, url2))
  review <- as.numeric(gsub(paste0(".*https://", url_m), "", badges))

  if (review %in% ropensci_reviews()$review) {

    list("@type" = "Review",
         "url" = paste0("https://", url2, review),
         "provider" = "https://ropensci.org")
  }
  # else NULL implicitly
}

# guess_readme_url -------------------------------------------------------------
# find the readme
.guess_readme_url <- function(root, verbose = FALSE, cm) {

  if (!urltools::domain(cm$codeRepository) %in%
      github_domains()) {
      return(NULL)
  }

  github <- remotes::parse_github_url(cm$codeRepository)

  if (verbose) {
    cli::cat_bullet("Asking README URL from GitHub API", bullet = "continue")
  }
  readme <- try(silent = TRUE, gh::gh(
    "GET /repos/:owner/:repo/readme",
    owner = github$username,
    repo = github$repo
  ))

  if (! inherits(readme, "try-error")) {

    if (verbose) {
      cli::cat_bullet("Got README URL!", bullet = "tick")
    }

    return(readme$html_url)

  } else {
    if (verbose) {
      cli::cat_bullet("Did not get README URL.", bullet = "cross")
    }
    return(NULL)
  }


  # else NULL implicitly
}

guess_readme_url <- memoise::memoise(.guess_readme_url)
# guess_readme_path ------------------------------------------------------------
.guess_readme_path <- function(root) {
browser()
  readmes <- dir(root, pattern = "^README\\.R?md$", ignore.case = TRUE)

  if (length(readmes) == 0) {

    return(NULL)
  }

  # Filter for Rmd files
  readme_rmd <- grep("\\.[Rr]md$", readmes, value = TRUE)

  # If there is a Rmd file, use this one, else filter for md files
  readme_file <- if (length(readme_rmd)) {

    readme_rmd

  } else {

    grep("\\.md$", readmes, value = TRUE)
  }

  # README.md and ReadMe.md could both exist, therefore silently use the first
  # match (locale-dependent). Prepend the root path.
  file.path(root, readme_file[1])
}
guess_readme_path <- memoise::memoise(.guess_readme_path)
# .guess_readme ----------------------------------------------------------------
.guess_readme <- function(root = ".", verbose = FALSE, cm) {

  list(
    readme_path = guess_readme_path(root),
    readme_url = guess_readme_url(root, verbose, cm)
  )
}



# codemeta_readme --------------------------------------------------------------
codemeta_readme <- function(readme, codemeta) {

  codemeta %>%
    set_element("contIntegration", guess_ci(readme)) %>%
    set_element("developmentStatus", guess_devStatus(readme)) %>%
    set_element("review", guess_ropensci_review(readme))
}

