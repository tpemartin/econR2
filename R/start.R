Visit <- function(){
  visit <- list()
  visit$anaconda <- function(){
    browseURL("https://www.anaconda.com/products/individual")
  }

  return(visit)
}
update_package <- function(){
  if(!require(devtools)){
    install.packages("devtools")
  }
  devtools::install_github(
    "tpemartin/econPy", force=T
  )
}
setup_rprofile <- function(){
  # create project if necessary
  create_project_if_necessary() -> projectFolder

  # setup rprofile
  create_Rprofile4py(projectFolder, envname)

  # restart project
  rstudioapi::openProject(
    projectFolder
  )

}

installPkg_conda <- function(pip=F){

  rstudioapi::showPrompt(
    "Python",
    "Package names (separated by ,)"
  ) -> pkgnames
  pkgnames |>
    stringr::str_split(",\\s*") |>
    unlist() -> pkgnames
  reticulate::conda_install(Sys.getenv("conda_environment"),
    packages=pkgnames,
    pip = pip)
}
installPkg_pip <- function(){
  installPkg_conda(pip=T)
}

create_Rprofile4py <- function(projectFolder, envname){
  glue::glue('library(reticulate)

# create a new environment
reticulate::use_condaenv("{envname}")
Sys.setenv("conda_environment"="{envname}")
    ') |>
    write_Rprofile(path=projectFolder)
}
