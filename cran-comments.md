Dear CRAN Maintainers,

I am pleased to submit the codemetar package for generating codemeta.json files for R packages. Note that
this package uses the X-schema.org-* pattern as previously discussed and recommended by CRAN maintainers (Kurt Hornik, Aug 27),
please let me know if this needs to be revised in any way. Thanks!

This submission fixes the broken URL identified at the initial submission (my apologies!).
I have also made sure the examples now only write to a temp file.

I appreciate the attention to having a good title, but in this case I do not think the proposed
change to the title is necessary.  The title refers to CodeMeta because that is the name of the 
relevant standard that is now being adopted by many scientific repositories including DataCite, 
which is responsible for the world's data DOIs.  I appreciate that many users will not be familiar
with the term CodeMeta, but I think it is important that the package be precise about which
standard of code metadata we are talking about (e.g. one would expect this package to come up
in searches for the term CodeMeta).  I think your proposed title change "Code Metadata" would make
if far more difficult to discover this package when a user is looking for this standard.
Please compare what you get from searching for "CodeMeta" vs searching for "Code Metadata"
and I think you will see what I mean.  I hope this makes sense.  Would you accept the current title as it is?

Sincerely,
Carl


## Test environments
* local OS X install, R 3.4.1
* ubuntu 12.04 (on travis-ci), R 3.4.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.


