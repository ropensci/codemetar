
fetch_package_sources <- function(packages) {
  for (p in rownames(packages)) {
    fetch_package(packages[p, ])
  }
}

fetch_package <- function(p) {
  dp <- package_repo_dir(p)
  if (file.exists(dp)) {
    git_fetch_all(package_repo_dir(p))
  } else {
    git_clone(package_github_url(p), dp, "--mirror")
  }
}

read_packages <- function(package_list="packages.txt") {
  packages <- readLines(package_list)
  ## This trims blank lines and "comments"
  packages <- sub("\\s*#.*$", "", packages)
  packages <- parse_packages(packages[!grepl("^\\s*$", packages)])

  packages <- cbind(packages, repo_dir=sprintf("%s/%s",
                                               packages[, "user"],
                                               packages[, "repo"]))

  ## TODO: Would be nice to check that there were no duplicate package
  ## names, bit not done for now.
  path <- dirname(package_list)
  packages_path <- file.path(path, "packages", packages[, "repo"])

  ## This bit of horribleness allows multiple packages within one
  ## repository that will be cloned independently (e.g., if requiring
  ## different refrences).
  i <- !is.na(packages[, "subdir"])
  if (any(i)) {
    packages_path[i] <- paste(packages_path[i],
                              packages[i, "subdir"], sep="__")
  }
  packages_path_pkg <- packages_path
  packages_path_pkg[i] <- file.path(packages_path_pkg[i], packages[i, "subdir"])

  packages <- cbind(packages,
                    path=unname(packages_path),
                    path_pkg=unname(packages_path_pkg),
                    path_repo=file.path("packages_src", packages[, "repo_dir"]))

  attr(packages, "path") <- path
  attr(packages, "name") <- package_list

  packages
}

parse_packages <- function(x) {
  ## The format is:
  ##   <username>/<repo>[/subdir][@ref]
  ## I think we're going to support additional things, including
  ## recursive, alt hosters, etc.
  re <- "^([^/]+)/([^/@#[:space:]]+)(.*)$"
  if (!all(grepl(re, x))) {
    stop("Invalid package line")
  }

  user <- sub(re, "\\1", x)
  repo <- sub(re, "\\2", x)
  rest <- sub(re, "\\3", x)

  re_subdir <- "^(/[^@#[:space:]]*)(.*)"
  i <- grepl(re_subdir, rest)
  subdir <- rep(NA_character_, length(x))
  subdir[i] <- sub("^/", "", sub(re_subdir, "\\1", rest[i]))
  rest[i]   <- sub(re_subdir, "\\2", rest[i])

  ## Either pull request or reference allowed, but let's just not
  ## support PRs yet.
  re_ref <- "^(@[^#[:space:]]*)(.*)"
  i <- grepl(re_ref, rest)
  ref <- rep(NA_character_, length(x))
  ref[i]  <- sub("^@", "", sub(re_ref, "\\1", rest[i]))
  rest[i] <- sub(re_ref, "\\2", rest[i])

  subdir[nchar(subdir) == 0L] <- NA_character_
  ref0 <- !nzchar(ref, FALSE)
  if (any(ref0)) {
    stop("Invalid reference: ", paste(x[ref0], collapse=", "))
  }

  rest <- trimws(rest)
  rest[nchar(rest) == 0L] <- NA_character_

  ## Check that everything left over is valid JSON:
  i <- !is.na(rest)
  check_parse <- function(x) {
    res <- tryCatch(jsonlite::fromJSON(x),
                    error=function(e) {
                      e$message <- sprintf("Error processing json '%s'\n%s",
                                           x, e$message)
                      stop(e)
                    })
    valid <- c(manual=logical(1), vignettes=logical(1))
    extra <- setdiff(names(res), names(valid))
    if (length(extra) > 0L) {
      warning("Extra options ignored: ", paste(extra, collapse=", "),
              immediate.=TRUE)
    }
    ok <- vapply(res, function(x) is.logical(x) && length(x) == 1,
                 logical(1))
    if (!all(ok)) {
      stop(sprintf("All options must be logical scalars (error on %s)",
                   paste(names(ok[!ok]), collapse=", ")))
    }
  }
  lapply(rest[i], check_parse)

  ret <- cbind(user=user, repo=repo, subdir=subdir, ref=ref,
               opts=rest, str=x)
  rownames(ret) <- x
  ret
}

package_repo_dir <- function(p) {
  p[["path_repo"]]
}
package_github_url <- function(p) {
  prefix <- "git@github.com:"
  prefix <- "https://github.com/"
  paste0(prefix, paste(p[["user"]], p[["repo"]], sep="/"), ".git")
}



####### git utils #######


call_git <- function(args, ..., workdir=NULL) {
  if (!is.null(workdir)) {
    args <- c("-C", workdir, args)
  }
  call_system(Sys_which("git"), args, ...)
}

git_fetch_all <- function(path) {
  call_git(c("remote", "update"), workdir=path)
}

git_clone <- function(url, dest=NULL, opts=character()) {
  call_git(c("clone", opts, "--", url, dest))
}



### system utils (for git) #######

call_system <- function(command, args, env=character(), max_lines=20,
                        p=0.8) {
  res <- suppressWarnings(system2(command, args,
                                  env=env, stdout=TRUE, stderr=TRUE))
  ok <- attr(res, "status")
  if (!is.null(ok) && ok != 0) {
    max_nc <- getOption("warning.length")

    cmd <- paste(c(env, shQuote(command), args), collapse = " ")
    msg <- sprintf("Running command:\n  %s\nhad status %d", cmd, ok)
    errmsg <- attr(cmd, "errmsg")
    if (!is.null(errmsg)) {
      msg <- c(msg, sprintf("%s\nerrmsg: %s", errmsg))
    }
    sep <- paste(rep("-", getOption("width")), collapse="")

    ## Truncate message:
    if (length(res) > max_lines) {
      n <- ceiling(max_lines * p)
      res <- c(head(res, ceiling(max_lines - n)),
               sprintf("[[... %d lines dropped ...]]", length(res) - max_lines),
               tail(res, ceiling(n)))
    }

    ## compute the number of characters so far, including three new lines:
    nc <- (nchar(msg) + nchar(sep) * 2) + 3
    i <- max(1, which(cumsum(rev(nchar(res) + 1L)) < (max_nc - nc)))
    res <- res[(length(res) - i + 1L):length(res)]
    msg <- c(msg, "Program output:", sep, res, sep)
    stop(paste(msg, collapse="\n"))
  }
  invisible(res)
}

Sys_which <- function(x) {
  ret <- Sys.which(x)
  if (ret == "") {
    stop(sprintf("%s not found in $PATH", x))
  }
  ret
}
