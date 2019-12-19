# remote_urls ------------------------------------------------------------------
remote_urls <- function (path) {

  remotes <- gert::git_remote_list(path)

  stats::setNames(remotes[["url"]], remotes[["name"]])
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
    parsed <- remotes::parse_github_url(github)
    return(glue::glue("https://github.com/{parsed$username}/{parsed$repo}"))
  }

}

# github_path ------------------------------------------------------------------

github_path <- function(root, path) {

  if (is.null(base <- guess_github(root))) {

    return(NULL)
  }

  branch <- getOption("codemeta_branch", "master")

  paste(base, "blob", branch, path, sep = "/")
}

# add_github_topics ------------------------------------------------------------
add_github_topics <- function(codemeta, verbose = FALSE) {

  github <- remotes::parse_github_url(codemeta$codeRepository)

  if (verbose) {
    cli::cat_bullet("Getting repo topics from GitHub API", bullet = "continue")
  }
  topics <- try(silent = TRUE, gh::gh(
    endpoint = "GET /repos/:owner/:repo/topics",
    repo = github$repo,
    owner = github$username,
    .send_headers = c(Accept = "application/vnd.github.mercy-preview+json")
  ))

  if (! inherits(topics, "try-error")) {

    topics <- unlist(topics$names)

    codemeta$keywords <- unique(c(codemeta$keywords, topics))

    if (verbose) {
      cli::cat_bullet("Got repo topics!", bullet = "tick")
    }
  } else {
    if (verbose) {
      cli::cat_bullet("Did not get repo topics.", bullet = "cross")
    }
  }

  codemeta
}
