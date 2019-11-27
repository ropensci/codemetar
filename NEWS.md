# codemetar (development version)

## Enhancements

* Changes in the way codeRepository is guessed. codemetar can now recognize an URL from GitHub, GitLab, Bitbucket, R-Forge among several URLs in DESCRIPTION, to assign it to codeRepository. If no URL in DESCRIPTION is from any of these providers, `guess_github()` is called.

## Bug fixes

* Fix for detecting rOpenSci review badge (@sckott, #236)

* Fix extraction of ORCID when composite comment (@billy34, #231)

* Fix bug in crosswalking (#243)

* Bug fix: the codeRepository is updated if there's any URL in DESCRIPTION.

* Bug fix: the README information is now updated by codemeta_readme(). Previously if e.g. a developmentStatus had been set previously, it was never updated.

## Internals

* Code cleaning following the book Martin, Robert C. Clean code: a handbook of agile software craftsmanship. Pearson Education, 2009. (@hsonne, #201, #202, #204, #205, #206, #207, #209, #210, #211, #212, #216, #218, #219, #220, #221).


# codemetar 0.1.8 2019-05

* address internet timeout issues
* tidy source code
* update test suite to reflect newly available metadata.

# codemetar 0.1.7 2018-12

* `jsonld` that is used only in `crosswalk()` and `codemeta_validate()` is now an optional dependency (Suggests rather than Imports).

* The CodeRepository URL is now cleaned a bit (removing direct link to the README).

* `write_codemeta()` gains a new argument `use_git_hook` to make the creation of a DESCRIPTION/codemeta.json git pre-commit hook optional.

* `create_codemeta()` and `write_codemeta()` gain a new argument `use_filesize` to make the building of the package to get its size optional.

* Encoding bug fixed in `extract_badges()`.

* `extract_badges()` now uses `commonmark` and `xml2` instead of only regular expressions.

* `pkgbuild` is now used directly instead of `devtools`.

* `give_opinion()` now recognizes lifecycle badges, not only repostatus.org badges.

# codemetar 0.1.6 2018-04

* New functions

    * extract_badges for extracting information from all badges in a Markdown file.
    
    * give_opinion giving opiniated advice about package metadata
    
* Changes to the create_codemeta output

    * relatedLink field now include provider URL and URL(s) from DESCRIPTION that are not the code repository
    
    * maintainer is now a list allowing for several maintainers since e.g. the BioConductor a4 package has two maintainers.
    
    * if more than one CI service among Travis, Appveyor and Circle CI are used and shown via a README badge they're all added to the contIntegration field. URLs from codecov and coveralls badges are also added to the contIntegration field.
    
    * repo status inferred from the README now 1) is an URL instead of a word 2) recognizes either repostatus.org or Tidyverse lifecycle badges.
    
    * if present, priority is given to the Repository and BugReports fields of DESCRIPTION for filling the codeRepository and issueTracker fields of codemeta.json (which means working on a fork won't change these).
    
    * ability to parse all CRAN-allowed MARC roles.
    
    * if there is a badge for an rOpenSci onboarding review and the review issue is closed, basic review metadata is added to codemeta.json
    
    * For dependencies, if the provider guessed is CRAN or BioConductor, their canonic CRAN/BioConductor URL is added to codemeta.json as sameAs, unless there's a GitHub repo mentioned for them in Remotes in DESCRIPTION, in which case sameAs is that GitHub repo.
    
    * CRAN is now correctly translated as "Comprehensive R Archive Network"
    
    * If codeRepository is guessed to be a GitHub repo (via the URL field of DESCRIPTION or via git remote URL), the repo topics are queried via GitHub API V3 and added to the keywords (in combination with keywords stored in the X-schema.org-keywords field of DESCRIPTION)
    
    * SystemRequirements are now parsed using https://sysreqs.r-hub.io/, outputting URLs then stored in softwareRequirements

* Help to remind to update codemeta.json regularly: Writing codemeta.json for the first time adds a git pre-commit hook and suggests adding a release question for devtools::release.

* Internal changes

    * Now uses desc to parse DESCRIPTION files.

    * Package license changed to GPL because of code borrowed from usethis
    
    * Uses crul instead of httr and uses crul to check some URLs.
    
    * write_codemeta only uses Rbuildignore and a pre-commit git hook if the function is called from a package folder directly and with the path argument equal to "codemeta.json"
    
    * The calls to available.packages() for guess_provider now happen inside memoised functions.
    
    * codemeta_readme function.

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



