# setup general
usethis::use_gpl3_license(name = usethis:::find_name())
usethis::use_git()
usethis::use_usethis()
usethis::use_description(
  list(Title = "Pipe operators and related functions",
       Description = "This package proposes new pipe operators, a function to define custom operators easily, and a couple helper functions")
)
usethis::use_directory("exclude", ignore = TRUE)

devtools::use_build_ignore("exclude")
usethis::use_git_ignore("exclude")
usethis::use_news_md()


#addin
usethis::use_directory("inst/rstudio/")


# document
devtools::use_vignette("cutr")
devtools::use_readme_rmd()

usethis::use_package_doc()
devtools::document()
#devtools::build_vignettes()
pkg_path  <- devtools::build()
install.packages(pkg_path, repos = NULL, type = "source",clean = TRUE)
#devtools::use_vignette("vignette")


usethis::use_version()
#$ increments the "Version" field in DESCRIPTION, adds a new heading to NEWS.md
#$ (if it exists), and commits those changes (if package uses Git).
usethis::use_dev_version() # increments to a development version

shell("git remote add origin https://github.com/moodymudskipper/mmpipe.git")
shell("git push -u origin master")

# in case of strange merge error:
shell('git push -f')



shell('git remote rm origin')


#

usethis::use_github(auth_token = "e87d09b6415cf9c475531a7f00d8e93ef3a24ed4")

usethis::browse_github_pat()

dtch <- function(x) {
  x <- as.character(substitute(x))
  detach(paste0("package:",x),unload = TRUE,character.only = TRUE)
}
dtch(mmmd)
search()

devtools::install_github("moodymudskipper/dotdot")
