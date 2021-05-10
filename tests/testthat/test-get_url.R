test_that("get_url_github() works", {

  expect_identical(get_url_github(), "https://github.com")
  expect_identical(get_url_github("a/b"), "https://github.com/a/b")
  expect_identical(get_url_github("a", "b"), "https://github.com/a/b")
})
