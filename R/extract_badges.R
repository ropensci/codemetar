

.extract_badges <- function(path){
  txt <- readLines(path)
  badges1 <- unlist(stringr::str_match_all(txt, "\\[!\\[\\]\\(.*?\\)\\]\\(.*?\\)"))
  badges2 <- unlist(stringr::str_match_all(txt, "\\[!\\[.*?\\]\\(.*?\\)\\]\\(.*?\\)"))
  badges <- c(badges1, badges2)
  badges[!is.na(badges)]

  unique(do.call(rbind,
                 lapply(badges, parse_badge)))
}

#' Extract all badges from Markdown file
#'
#' @param path Path to Markdown file
#'
#' @return A tibble with for each badge its text, link and link to
#' its image.
#' @export
#'
#' @examples
#' extract_badges(system.file("README.md", package = "codemetar"))
extract_badges <- memoise::memoise(.extract_badges)

parse_badge <- function(badge){
  text <- stringr::str_match(badge, "\\[!\\[(.*?)\\]")[,2]
  link <- stringr::str_match(badge, "\\)\\]\\((.*?)\\)")[,2]
  image_link <- stringr::str_match(badge, "\\]\\((.*?)\\)\\]")[,2]
  tibble::tibble(text = text,
                 link = link,
                 image_link = image_link)
}
