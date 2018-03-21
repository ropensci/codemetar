## Check out the repo from github and run check in root directory to test.

testthat::context("cloned repo")

testthat::test_that("we can generate codemeta
                    from the root directory of R source code on github",
  {

    skip_on_cran()
    git2r::clone("https://github.com/codemeta/codemetar",
                 "codemetar_copy", progress = FALSE)

    if(as.character(Sys.info()['sysname']) == "Windows"){
      write_codemeta("codemetar_copy", "test.json")
      expect_true(codemeta_validate("test.json"))

      f <- "codemetar_copy"

      test_that("git utils", {
        x <- uses_git(f)
        testthat::expect_true(x)
        x <- guess_github(f)
        x <- github_path(f, "README.md")

      })

      guess_ci(file.path(f, "README.md"))
      guess_devStatus(file.path(f, "README.md"))

      guess_readme(f)
      guess_releaseNotes(f)
      guess_fileSize(f)
      file.remove(dir()[grepl(".tar.gz", dir())])

      file.remove("test.json")
      file.remove(dir("codemetar_copy", recursive = TRUE,
                      full.names = TRUE))
      unlink("codemetar_copy", recursive=TRUE)
    }else{
      write_codemeta("codemetar_copy/", "test.json")
      expect_true(codemeta_validate("test.json"))

      f <- "codemetar_copy"

      test_that("git utils", {
        x <- uses_git(f)
        testthat::expect_true(x)
        x <- guess_github(f)
        x <- github_path(f, "README.md")

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
    }


  })


testthat::test_that("parse citation from source repo", {
  a <- guess_citation(".")
})
