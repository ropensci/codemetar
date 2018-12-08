testthat::context("crosswalk.R")

# Define helper function that tests a json object
test_json <- function(x, basename) {
  testthat::expect_is(x, "json")
  writeLines(x, (testfile <- paste0(basename, ".json")))
  testthat::expect_true(codemeta_validate(testfile))
  unlink(testfile)
}

# Define helper function that reads a json example file
read_example_json <- function(file) read_json(example_file(file))

testthat::test_that("we can call crosswalk", {

  skip_on_os("windows")

  read_example_json("github_format.json") %>%
    crosswalk("GitHub") %>%
    test_json("test")

  a <- read_example_json("package.json") %>%
    crosswalk("NodeJS")

  test_json(a, "nodejs")

  ## Test add and drop context
  drop_context(a) %>%
    add_context(getOption("codemeta_context", "http://purl.org/codemeta/2.0"))

  ## Test transforms between columns
  read_example_json("github_format.json") %>%
    crosswalk("GitHub", "Zenodo")

  crosswalk_table(from = "GitHub", to = c("Zenodo", "Figshare"))
})
