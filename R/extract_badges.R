parse_md_badge <- function(badge){

  xml2::xml_contents(badge) %>%
    .[xml2::xml_name(.) == "image"] -> image

  tibble::tibble(text = xml2::xml_text(image),
                 link = xml2::xml_attr(badge, "destination"),
                 image_link = xml2::xml_attr(image, "destination"))
}

extract_md_badges <- function(path){
  path %>%
    readLines() %>%
    commonmark::markdown_xml(extensions = TRUE)  %>%
    gsub("[^\u0009\u000a\u000d\u0020-\uD7FF\uE000-\uFFFD]", "", .) %>%
    xml2::read_xml() %>%
    xml2::xml_find_all(".//d1:link[d1:image]", xml2::xml_ns(.)) %>%
    purrr::map_df(parse_md_badge)
}

parse_html_badge <- function(badge){
  xml2::xml_contents(badge) %>%
    .[xml2::xml_name(.) == "img"] -> image

  tibble::tibble(text = xml2::xml_attr(image, "alt"),
                 link = xml2::xml_attr(badge, "href"),
                 image_link = xml2::xml_attr(image, "src"))
}

extract_html_badges <- function(path){
  path %>%
    readLines() -> doc

  # assuming the badge tables is the 1st one
  table_start <- which(stringr::str_detect(doc,
                                           '\\<table class\\=\\"table\\"\\>'))[1]
  table_end <- which(stringr::str_detect(doc,'\\<\\/table\\>'))[1]

  if(all(!is.na(c(table_start,
                  table_end)))){
    doc[table_start:table_end] %>%
      glue::glue_collapse() %>%
      xml2::read_html() %>%
      xml2::xml_find_all("//a") -> badges
    if(length(badges) > 0){
      purrr::map_df(badges, parse_html_badge)
    }else{
      NULL
    }

  }else{
    NULL
  }


}

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


