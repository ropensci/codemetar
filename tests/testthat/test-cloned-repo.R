## Check out the repo from github and run check in root directory to test.

testthat::test_that("we can generate codemeta
                    from the root directory of R source code on github",
  {
    git2r::clone("https://github.com/codemeta/codemetar", "codemetar_copy")
    write_codemeta("codemetar_copy/", "test.json")
    expect_true(codemeta_validate("test.json"))

    f <- "codemetar_copy"

    test_that("git utils", {
      x <- uses_git(f)
      testthat::expect_true(x)
      x <- guess_github(f)


      x <- github_path(".", "README.md")

    })

      guess_ci(file.path(f, "README.md"))
      guess_devStatus(file.path(f, "README.md"))

      guess_readme(f)
      guess_releaseNotes(f)
      guess_fileSize(f)
      unlink("codemetar-*.tar.gz")

    unlink("test.json")
    system("rm -rf codemetar_copy")
    #file.remove(list.files("codemetar_copy", recursive = TRUE))
    #unlink("codemetar_copy")
  })
