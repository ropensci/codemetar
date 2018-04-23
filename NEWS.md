# codemetar 0.1.6 2018-04

* Use desc to parse DESCRIPTION files.

* Writing codemeta.json for the first time adds a git pre-commit hook and suggests adding a release question for devtools::release.

* License changed to GPL because of code borrowed from usethis

* Add give_opinion function giving opiniated advice about package metadata

* Replace httr with crul and use crul to check URLs.

* relatedLink field now include provider URL and URL(s) from DESCRIPTION that are not the code repository

* add an extract_badges function for extracting information from all badges in a Markdown file.

# codemetar 0.1.5 2018-03-21

* Default to DOI-based schema. (previous CN issues now resolved)

# codemetar 0.1.4 2018-02-12

* Allow vignettes to gracefully handle network timeout errors that
  may occur on CRAN's Windows build server.

# codemetar 0.1.3 2018-02-08

* CRAN release
* Switch to <http://purl.org> based URIs for the JSON-LD 
  Context file instead of a DOI, due to frequent failure
  of content negotiation on DataCite servers
  ([#34](https://github.com/ropensci/codemetar/issues/34))
* bugfix UTF-8 characters in CITATION files 
  ([#44](https://github.com/ropensci/codemetar/issues/44))
* bugfix to git URLs
* Use `https` on ORCID `@id` URIs

# codemetar 0.1.2

* JOSS release

# codemetar 0.1.1

* Post onboarding release

# codemetar 0.1.0

* Added a `NEWS.md` file to track changes to the package.



