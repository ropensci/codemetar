# give_opinions ----------------------------------------------------------------

#' Function giving opinions about a package
#'
#' @param pkg_path Path to the package root
#' @param verbose Whether to print message related to internet download progress.
#'
#' @return A data.frame of opinions
#' @export
#'
give_opinions <- function(pkg_path = getwd(), verbose = FALSE) {

  # set the path to the description file
  description_file <- file.path(pkg_path, "DESCRIPTION")

  # read the description file
  description <- read_description_if_null(NULL, description_file)

  # create a list of issues, each element is a vector of character or NULL
  fixmes <- do.call(rbind, list(

    # opinions about DESCRIPTION
    give_opinions_desc(description = description),

    # opinions about README
    try_to_give_opinions_readme(description_file, verbose)
  ))

  if (! is.null(fixmes)) {

    fixmes$package <- as.character(description$get("Package"))
  }

  fixmes
}

# read_description_if_null -----------------------------------------------------

#' Read Description from File If Not Given
#'
#' @param description object to be checked for `NULL` and to be returned if
#'   not being `NULL`.
#' @param description_file path to `DESCRIPTION` file to be read with
#'   [desc::desc()] if `description` is `NULL`.
#' @return `description` if not `NULL` or the content of
#'   `description_file` read with [desc::desc()].
#' @noRd
read_description_if_null <- function(description, description_file) {

  if (is.null(description)) {

    desc::desc(description_file)

  } else {

    description
  }
}

# give_opinions_desc -----------------------------------------------------------

#' Give Opinions about DESCRIPTION File
#'
#' You may either pass the path to a DESCRIPTION file or a description object
#' as read with [desc::desc()].
#'
#' @param description_file path do a DESCRIPTION file. Will not be considered if
#'   a description object is given in `description`.
#' @param description Description object as read with
#'   [desc::desc()]. If not provided, the path to a DESCRIPTION file
#'   must be given in `description_file`.
#' @return `data.frame` with columns `where`, `fixme` or `NULL`
#'   if there are no opionions about the DESCRIPTION file.
#' @noRd
give_opinions_desc <- function(description_file, description = NULL) {

  # read description from description_file if description is NULL
  description <- read_description_if_null(description, description_file)

  # Start with an empty vector of "fixme" messages
  fixmes <- character()

  # Authors
  if (fails(description$get_authors())) {

    fixmes <- c(fixmes, get_message(message_id = "hint_use_authors_r"))
  }

  # URL
  fixmes <- add_url_fixmes(
    fixmes = fixmes,
    main_url = description$get("URL"),
    message_id = "hint_add_repo_url",
    further_urls = description$descr$get_urls
  )

  # BugReports
  fixmes <- add_url_fixmes(
    fixmes = fixmes,
    main_url = description$get("BugReports"),
    message_id = "hint_add_bug_report_url"
  )

  fixmes_as_df_or_message(fixmes, where = "DESCRIPTION")
}

# add_url_fixmes ---------------------------------------------------------------
add_url_fixmes <- function(
  fixmes, main_url, message_id, further_urls = main_url
) {

  if (is.na(main_url)) {

    fixmes <- c(fixmes, get_message(message_id))

  } else if ((failing_urls <- check_urls(further_urls)) != "") {

    fixmes <- c(fixmes, failing_urls)
  }

  fixmes
}

# fixmes_as_df_or_message ---------------------------------------------------
fixmes_as_df_or_message <- function(fixmes, where, message_id = NULL) {

  if (length(fixmes)) {

    df(where = where, fixme = fixmes)

  } else if (! is.null(message_id)) {

    message(get_message(message_id))
  }
}

# try_to_give_opinions_readme --------------------------------------------------
try_to_give_opinions_readme <- function(description_file, verbose = FALSE) {

  readme_path <- guess_readme_path(dirname(description_file))

  if (is.null(readme_path)) {

    return(NULL)
  }

  give_opinions_readme(readme_path,
                       pkg_name = desc::desc_get_field("Package",
                                                       file = description_file),
                       verbose)
}

# give_opinions_readme ---------------------------------------------------------
give_opinions_readme <- function(readme_path, pkg_name, verbose = FALSE) {

  # start with an empty vector of "fixme" messages
  fixmes <- character()

  # status
  if (is.null(guess_devStatus(readme_path))) {

    fixmes <- c(fixmes, get_message("hint_add_status_badge"))
  }

  # provider
  provider <- guess_provider(pkg_name, verbose)

  if (has_provider_but_no_badge(provider, readme_path)) {

    fixmes <- c(fixmes, get_message(
      "hint_package_exists", pkg_name, provider$name
    ))
  }

  fixmes_as_df_or_message(fixmes, "README", "hint_highest_opinion")
}

# has_provider_but_no_badge ----------------------------------------------------
has_provider_but_no_badge <- function(provider, readme_path) {

  if (is.null(provider)) {

    FALSE

  } else {

    ! whether_provider_badge(extract_badges(readme_path), provider$name)
  }
}
