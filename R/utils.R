
#' @importFrom utils installed.packages
get_root_path <- function(pkg){
  installed <- installed.packages()
  if(pkg %in% installed[,1]){
    root <- base::system.file(".", package = pkg)
  } else if(file.exists(file.path(pkg, "DESCRIPTION"))){
    root <- pkg
  } else {
    if(is.character(pkg)){
      root <- pkg # use pkg as guess anyway
#    } else {
#      root <- "." # stick with default
    }
  }
  root
}


## Like system.file, but pkg can instead be path to package root directory
get_file <- function(FILE, pkg = "."){
  f <- file.path(pkg, FILE)
  if(file.exists(f))
    f
  else {
    f <- system.file(FILE, package = pkg)
  }
}






is_IRI <- function(string){
  ## FIXME IRI can be many other things too,
  #see https://github.com/dgerber/rfc3987 for more formal implementation
  grepl("^http[s]?://", string)
}


# from usethis cf https://github.com/r-lib/usethis/blob/2abb0422a97808cc573fa5900a8efcfed4c2d5b4/R/git.R#L68
# this is GPL-3 code
uses_git <- function(path = usethis::proj_get()) {
  !is.null(git2r::discover_repository(path))
}

# from usethis cf https://github.com/r-lib/usethis/blob/4fb556788d2588facaaa8560242d2c83f2261d6e/R/helpers.R#L55
# this is GPL-3 code
render_template <- function(template, data = list(), package = "codemetar") {
  template_path <- find_template(template, package = package)
  strsplit(whisker::whisker.render(readLines(template_path), data), "\n")[[1]]
}

# from usethis cf https://github.com/r-lib/usethis/blob/4fb556788d2588facaaa8560242d2c83f2261d6e/R/helpers.R#L60
# this is GPL-3 code
find_template <- function(template_name, package = "usethis") {
  path <- system.file("templates", template_name, package = package)
  if (identical(path, "")) {
    stop(
      "Could not find template ", value(template_name),
      " in package ", value(package),
      call. = FALSE
    )
  }
  path
}
