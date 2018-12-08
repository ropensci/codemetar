# get_message ------------------------------------------------------------------
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
    )
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
