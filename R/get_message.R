# get_message ------------------------------------------------------------------
#' Get Message String
#'
#' @param message_id keyword used to lookup a message string from the list
#'   of messages defined in this function.
#' @param \dots further arguments passed to \code{\link{sprintf}} that are used
#'   to replace possible percent sign placeholders in the message string. As
#'   many additional arguments as there are percent sign placeholders (so called
#'   conversion specifiers, see \code{\link{sprintf}}) are required.
#' @return message string defined for the given \code{keyword} as returned by
#'   \code{\link{sprintf}} with possible placeholders replaced with the
#'   formatted values given in \dots. If there is no message string defined for
#'   the given keyword, an error is raised and a hint about available keywords
#'   is given.
#' @noRd
get_message <- function(message_id, ...) {

  messages <- list(

    hint_use_authors_r = paste(
      "The syntax Authors@R instead of plain Author and Maintainer is",
      "recommended in particular because it allows richer metadata" # no lint
    ),
    hint_add_repo_url = paste(
      "URL field. Indicate the URL to your code repository."
    ),
    hint_add_bug_report_url = paste(
      "BugReports field. Indicate where to report bugs, e.g. GitHub issue",
      "tracker."
    ),
    hint_add_status_badge = paste(
      "Add a status badge cf e.g repostatus.org"
    ),
    hint_package_exists = paste(
      "There is a package called %s on %s, add a badge to show it is yours",
      "or rename your package."
    ),
    hint_highest_opinion = paste(
      "codemetar has the highest opinion of this R package :-)"
    ),
    adding_hook = paste(
      "* Adding a pre-commit git hook ensuring that codemeta.json will be",
      "synchronized with DESCRIPTION"
    ) # nolint
  )

  if (message_id %in% names(messages)) {

    sprintf(messages[[message_id]], ...)

  } else {

    stop(call. = FALSE, sprintf(
      "No such message_id: %s.\nAvailable ids: %s",
      message_id, paste(names(messages), collapse = ", ")
    ))
  }
}
