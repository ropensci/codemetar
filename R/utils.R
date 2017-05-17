




## based on devtools::read_dcf
read_dcf <- function(pkg) {

  ## Takes path to DESCRIPTION, to package root, or the package name as an argument


  dcf <- get_file("DESCRIPTION", pkg)

  if(dcf == ""){
    if(basename(pkg) == "DESCRIPTION"){ #so read_dcf can take a dcf file as argument, instead of just a path.
      dcf <- pkg
    } else {
      return(NULL)
    }
  }

  fields <- colnames(read.dcf(dcf))
  as.list(read.dcf(dcf, keep.white = fields)[1, ])

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
  ## FIXME IRI can be many other things too, see https://github.com/dgerber/rfc3987 for more formal implementation
  grepl("^http[s]?://", string)
}

