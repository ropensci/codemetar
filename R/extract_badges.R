

.extract_badges <- function(path){
  txt <- readLines(path)
  badges1 <- unlist(stringr::str_match_all(txt, "\\[!\\[\\]\\(.*?\\)\\]\\(.*?\\)"))
  badges2 <- unlist(stringr::str_match_all(txt, "\\[!\\[.*?\\]\\(.*?\\)\\]\\(.*?\\)"))

  md_badges <- c(badges1, badges2)

  md_badges <- unique(do.call(rbind,
                 lapply(md_badges[!is.na(md_badges)], parse_md_badge)))

  html_badges <- unlist(stringr::str_match_all(txt,
                                               '<a href.*?><img.*?>'))

  html_badges <- unique(do.call(rbind,
                                lapply(html_badges[!is.na(html_badges)],
                                       parse_html_badge)))

  rbind(md_badges, html_badges)
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

parse_md_badge <- function(badge){
  text <- stringr::str_match(badge, "\\[!\\[(.*?)\\]")[,2]
  link <- stringr::str_match(badge, "\\)\\]\\((.*?)\\)")[,2]
  image_link <- stringr::str_match(badge, "\\]\\((.*?)\\)\\]")[,2]
  tibble::tibble(text = text,
                 link = link,
                 image_link = image_link)
}

parse_html_badge <- function(badge){
  text <- stringr::str_match(badge, 'alt=\\\"(.*?)\\\"')[,2]
  link <- stringr::str_match(badge, 'href=\\\"(.*?)\\\"')[,2]
  image_link <- stringr::str_match(badge, 'src=\\\"(.*?)\\\"')[,2]
  tibble::tibble(text = text,
                 link = link,
                 image_link = image_link)
}
