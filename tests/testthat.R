library(testthat)
library(codemetar)

skip_if_offline <- function() skip_if_not(pingr::is_online())
test_check("codemetar")
