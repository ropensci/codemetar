Dear CRAN team,

Our previous fixes were not enough, which we missed on the test platforms we used, we are sorry about that.


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

## Reverse dependencies

The two reverse dependencies of codemetar do not actually use codemetar in their code.
