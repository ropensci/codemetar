# remote_urls ------------------------------------------------------------------
remote_urls <- function (r) {

  remotes <- git2r::remotes(r)

  stats::setNames(git2r::remote_url(r, remotes), remotes)
}

# guess_github -----------------------------------------------------------------
guess_github <- function(root = ".") {

  ## from devtools
  # https://github.com/r-lib/devtools/blob/21fe55a912ca4eaa49ef5b7d891ff3e2aae7a370/R/git.R#L130
  # GPL>=2 code

  if (! uses_git(root)) {

    return(NULL)
  }

  remote_urls <- root %>%
    git2r::repository(discover = TRUE) %>%
    remote_urls()

  is_github <- function(url){
    info <- try(remotes::parse_github_url(url),
                silent = TRUE)

    !is(info, "try-error")
  }

  whether_github <- unlist(
    lapply(remote_urls, is_github))

  github <- remote_urls[whether_github][1]

  if (is.na(github)) {
    return(NULL)
  } else {
    return(github)
  }

}

# github_path ------------------------------------------------------------------

#' @importFrom git2r repository branches
github_path <- function(root, path) {

  if (is.null(base <- guess_github(root))) {

    return(NULL)
  }

  branch <- getOption("codemeta_branch", "master")

  paste(base, "blob", branch, path, sep = "/")
}

# add_github_topics ------------------------------------------------------------
add_github_topics <- function(codemeta) {

  github <- remotes::parse_github_url(codemeta$codeRepository)

  topics <- try(silent = TRUE, gh::gh(
    endpoint = "GET /repos/:owner/:repo/topics",
    repo = github$repo,
    owner = github$username,
    .send_headers = c(Accept = "application/vnd.github.mercy-preview+json")
  ))

  if (! inherits(topics, "try-error")) {

    topics <- unlist(topics$names)

    codemeta$keywords <- unique(c(codemeta$keywords, topics))
  }

  codemeta
}
