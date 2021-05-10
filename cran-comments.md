## Test environments
* local Windows install
* ubuntu 12.04 (on travis-ci, oldrel, devel and release)
* win-builder (on appveyor-ci, stable, patch, oldrel and devel)

## R CMD check results

0 errors | 0 warnings | 1 note

We think the URL errors below are false positives.

```
  URL: https://docs.r-hub.io/#badges
    From: inst/doc/codemetar.html
          README.md
    Status: Error
    Message: libcurl error code 35:
      	schannel: next InitializeSecurityContext failed: SEC_E_ILLEGAL_MESSAGE (0x80090326) - This error usually occurs when a fatal SSL/TLS alert is received (e.g. handshake failed).
  URL: https://docs.r-hub.io/#sysreqs
    From: inst/doc/codemetar.html
          README.md
    Status: Error
    Message: libcurl error code 35:
      	schannel: next InitializeSecurityContext failed: SEC_E_ILLEGAL_MESSAGE (0x80090326) - This error usually occurs when a fatal SSL/TLS alert is received (e.g. handshake failed).
```

## Release summary

We addressed the tests failing on Solaris.

Other changes 

* `write_codemetar()` can now be called from anywhere within a package directory structure. (#305, @mpadge)
* Breaking change: `write_codemeta()` writes the JSON file at `path` relative to `pkg`, not the current directory. (#303, @ThierryO)
* Added  documentation for changing the default branch (#302, @jonkeane)
* Breaking change: Relatedly, it is no longer possible to use `write_codemeta()` on an installed packages, in that case one would have to use `create_codemeta()` together with `jsonlite::write_json()`.
* Use R.Version() instead of R.version to allow mocking in tests.
* Bug fix: now able to parse a README where badges are in a table with non badges links.
* Bug fix: `guess_fileSize()` properly handles `.Rbuildignore` (#299, @ThierryO).
* Bug fix: `create_codemetar()` handles minimal packages (#298, @ThierryO).

## Reverse dependencies

The two reverse dependencies of codemetar do not actually use codemetar in their code.
