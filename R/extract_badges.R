# parse_md_badge ---------------------------------------------------------------
parse_md_badge <- function(badge) {

  image <- xml2::xml_contents(badge) %>%
    .[xml2::xml_name(.) == "image"]

  get_destination <- function(x) xml2::xml_attr(x, "destination")

  tibble::tibble(
    text = xml2::xml_text(image),
    link = get_destination(badge),
    image_link = get_destination(image)
  )
}

# extract_md_badges ------------------------------------------------------------
extract_md_badges <- function(path) {

  path %>%
    readLines(encoding = "UTF-8") %>%
    commonmark::markdown_xml(extensions = TRUE)  %>%
    gsub("[^\u0009\u000a\u000d\u0020-\uD7FF\uE000-\uFFFD]", "", .) %>%
    xml2::read_xml() %>%
    xml2::xml_find_all(".//d1:link[d1:image]", xml2::xml_ns(.)) %>%
    purrr::map_df(parse_md_badge)
}

# parse_html_badge -------------------------------------------------------------
parse_html_badge <- function(badge) {

  image <- xml2::xml_contents(badge) %>%
    .[xml2::xml_name(.) == "img"]

  tibble::tibble(
    text = xml2::xml_attr(image, "alt"),
    link = xml2::xml_attr(badge, "href"),
    image_link = xml2::xml_attr(image, "src")
  )
}

# extract_html_badges ----------------------------------------------------------
extract_html_badges <- function(path) {

  doc <- readLines(path, encoding = "UTF-8")

  # helper function assuming the badge table is the 1st one
  which_detect <- function(p) which(stringr::str_detect(doc, p))[1]

  table_start <- which_detect('\\<table class\\=\\"table\\"\\>')
  table_end <- which_detect('\\<\\/table\\>')

  if (any(is.na(c(table_start, table_end)))) {

    return(NULL)
  }

  badges <- doc[table_start:table_end] %>%
    glue::glue_collapse() %>%
    xml2::read_html() %>%
    xml2::xml_find_all("//a")

  if (length(badges)) {

    purrr::map_df(badges, parse_html_badge)

  } else {

    NULL
  }
}

# .extract_badges --------------------------------------------------------------
.extract_badges <- function(path) {

  md_badges <- extract_md_badges(path)

  html_badges <- extract_html_badges(path)

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
#' \dontrun{
#' extract_badges(system.file("examples/README_fakepackage.md", package="codemetar"))
#' }
extract_badges <- memoise::memoise(.extract_badges)

globalVariables(".")
