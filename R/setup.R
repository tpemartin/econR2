#' Setup your R environment
#'
#' @return
#' @export
#'
#' @examples none
setup <- function(){
  assertthat::assert_that(
    check_installation_path(),
    msg="Please fix your R/RStudio installation path then do check_fix() again."
  )
  check_fix_libraryPath()
  fix_language2english()

  message("Don't forget to check your encoding setting.")
  create_project_if_necessary() -> projectPath

  rstudioapi::openProject(projectPath)

}
check_fix_language <- function(){
  flag_ok <- (stringr::str_detect(Sys.getenv("LANG"), "en") ||
    stringr::str_detect(Sys.getenv("LANGUAGE"), "en"))
  if(flag_ok) {
    fix_language2english()
  }
  message("Language is English now.")

}
fix_libPath <- function(){

  if(isTRUE(Sys.getenv("R_PROFILE_USER") !="")){
    re_filepath = Sys.getenv("R_PROFILE_USER")
  } else
    if(file.exists("./.Rprofile")){
      re_filepath = "./.Rprofile"
    } else
      if(file.exists("~/.Rprofile")){
        re_filepath = "~/.Rprofile"
      } else {
        re_filepath = "./.Rprofile"
        file.create(re_filepath)
      }
  xfun::read_utf8(
    re_filepath
  )  -> lines

  rstudioapi::showDialog(
    "Setup package library path",
    "Choose directory to save packages to."
  )
  rstudioapi::selectDirectory(
    getwd()
  ) -> libPath
  c(lines,
  glue::glue('Sys.setenv("R_LIBS_USER"="{libPath}")'))|>
    xfun::write_utf8(re_filepath)
}
fix_language2english <- function(){

  if(isTRUE(Sys.getenv("R_ENVIRON_USER") !="")){
    re_filepath = Sys.getenv("R_ENVIRON_USER")
  } else
    if(file.exists("./.Renviron")){
      re_filepath = "./.Renviron"
    } else
      if(file.exists("~/.Renviron")){
        re_filepath = "~/.Renviron"
      } else {
        re_filepath = "./.Renviron"
        file.create(re_filepath)
      }
  xfun::read_utf8(
    re_filepath
  )  -> lines
  stringr::str_detect(lines, "LANGUAGE|LANG\\s*=") -> pick_same
  stringr::str_detect(lines, "^#") ->
    pick_comment
  which2comment <- which(pick_same && !pick_comment)
  paste("#", lines[which2comment]) -> lines[which2comment]
  c("LANGUAGE=en", lines) |>
    xfun::write_utf8(re_filepath)

}

check_installation_path <- function(){
  currentPath = R.home()
  message("Current R path: ", currentPath)
  flag_nonASCII <- stringr::str_detect(R.home(), "[^\\x00-\\x7F]+")
  if(flag_nonASCII) warning("R should not be installed at a path with `non-English` characters.")

  flag_onedrive <- stringr::str_detect(R.home(), "OneDrive")
  if(flag_onedrive) warning("R should not be installed under OneDrive")

  message("No problem found.")
  return(!flag_nonASCII && !flag_onedrive)
}

check_fix_libraryPath <- function(){
  flag_accessible <- file.access(.libPaths(),2)==0
  if(!flag_accessible) fix_libPath()
  message("Lib path check fix done")
}
