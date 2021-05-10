test_that("get_message() works", {

  expect_error(get_message(), "is missing, with no default")
  expect_error(get_message("no_such_key"), "No such message_id")
  expect_error(get_message("hint_package_exists"), "too few arguments")
  expect_match(get_message("hint_package_exists", "abc", "def"), "abc on def")
})

