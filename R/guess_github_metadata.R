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

  root %>%
    git2r::repository(discover = TRUE) %>%
    remote_urls() %>%
    grep(pattern = "github", value = TRUE) %>%
    getElement(1) %>%
    gsub(pattern = "git@github.com:", replacement = "https://github.com/") %>%
    gsub(pattern = "\\.git$", replacement = "")
}

#' @importFrom git2r repository branches
github_path <- function(root, path) {
  base <- guess_github(root)
  r <- git2r::repository(root, discover = TRUE)
  branch <- getOption("codemeta_branch", "master")
  paste0(base, "/blob/", branch, "/", path)
}


# add GitHub topics
add_github_topics <- function(cm){
  github <- stringr::str_remove(cm$codeRepository, ".*github\\.com\\/")
  github <- stringr::str_remove(github, "#.*")
  github <- stringr::str_split(github, "/")[[1]]
  owner <- github[1]
  repo <- github[2]

  topics <- try(gh::gh("GET /repos/:owner/:repo/topics",
                   repo = repo, owner = owner,
                   .send_headers = c(Accept = "application/vnd.github.mercy-preview+json")),
                silent = TRUE)
  if(!inherits(topics, "try-error")){
    topics <- unlist(topics$names)

    cm$keywords <- unique(c(cm$keywords, topics))
  }

  return(cm)
}
