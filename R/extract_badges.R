# parse_md_badge ---------------------------------------------------------------
parse_md_badge <- function(badge) {

  image <- get_image_from_badge(badge, name = "image")

  get_destination <- function(x) xml2::xml_attr(x, "destination")

  df(
    text = xml2::xml_text(image),
    link = get_destination(badge),
    image_link = get_destination(image)
  )
}

# get_image_from_badge ---------------------------------------------------------
get_image_from_badge <- function(badge, name) {

  xml2::xml_contents(badge) %>% .[xml2::xml_name(.) == name]
}

# extract_md_badges ------------------------------------------------------------
extract_md_badges <- function(path) {

  path %>%
    readLines(encoding = "UTF-8") %>%
    commonmark::markdown_xml(extensions = TRUE)  %>%
    gsub("[^\u0009\u000a\u000d\u0020-\uD7FF\uE000-\uFFFD]", "", .) %>%
    xml2::read_xml() %>%
    xml2::xml_find_all(".//d1:link[d1:image]", xml2::xml_ns(.)) %>%
    purrr::map(parse_md_badge) %>%
    bind_df()
}



# parse_html_badge -------------------------------------------------------------
parse_html_badge <- function(badge) {

  image <- get_image_from_badge(badge, name = "img")

  df(
    text = xml2::xml_attr(image, "alt"),
    link = xml2::xml_attr(badge, "href"),
    image_link = xml2::xml_attr(image, "src")
  )
}

# extract_html_badges ----------------------------------------------------------
extract_html_badges <- function(path) {

  doc <- readLines(path, encoding = "UTF-8")

  # helper function assuming the badge table is the 1st one
  find_first <- function(p) which(grepl(p, doc))[1]

  table_start <- find_first('\\<table class=\\"table\\">')
  table_end <- find_first('<\\/table>')

  if (is.na(table_start) || is.na(table_end)) {

    return(NULL)
  }

  badges <- doc[table_start:table_end] %>%
    paste0(collapse = "") %>%
    xml2::read_html() %>%
    xml2::xml_find_all("//a")

  if (length(badges)) {

    purrr::map(badges, parse_html_badge) %>%
      bind_df()

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
#' @return A data.frame with for each badge its text, link and link to
#' its image.
#' @export
#'
#' @examples
#' \dontrun{
#' extract_badges(system.file("examples/README_fakepackage.md", package="codemetar"))
#' }
extract_badges <- memoise::memoise(.extract_badges)

globalVariables(".")
