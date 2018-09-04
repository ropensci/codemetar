parse_md_badge <- function(badge){
  xml2::xml_contents(badge) %>%
    .[xml2::xml_name(.) == "image"] -> image

  tibble::tibble(text = xml2::xml_text(image),
                 link = xml2::xml_attr(badge, "destination"),
                 image_link = xml2::xml_attr(image, "destination"))
}

extract_md_badges <- function(file_xml){
  file_xml %>%
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

extract_html_badges <- function(file_xml){
  file_xml %>%
    xml2::xml_find_all(".//d1:html_block", xml2::xml_ns(.)) -> nodeset

  if(length(nodeset) == 0){
    return(NULL)
  }

  nodeset %>%
    xml2::xml_text() %>%
    xml2::read_html() -> html

  if(is(html, "xml_node")){
    html %>%
      xml2::xml_find_all(".//table") %>%
      xml2::xml_find_all(".//tbody") %>%
      xml2::xml_find_all("//a") %>%
      purrr::map_df(parse_html_badge)
  }else{
    NULL
  }
}

.extract_badges <- function(path) {
  file_xml <- path %>%
    readLines() %>%
    commonmark::markdown_xml(extensions = TRUE) %>%
    xml2::read_xml()

  md_badges <- extract_md_badges(file_xml)

  html_badges <- extract_html_badges(file_xml)

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


