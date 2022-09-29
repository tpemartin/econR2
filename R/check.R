check_path <- function(path=NULL){
  wd <- ifelse(is.null(path), getwd(), path)
  wd |> split_path() -> wd
  flag_space <- any(stringr::str_detect(wd, "\\s"))
  flag_nonascii <- any(stringr::str_detect(wd, "[^ -~]"))
  if(flag_space || flag_nonascii){
    message("A goog working path should NOT have\n",
      ifelse(flag_space, "  * space\n", ""),
      ifelse(flag_nonascii, "  * Non-ASCII character (such as non-English character\n", "")
    )
  } else {
    message("Working path is fine.")
  }

}
split_path <- function(x) if (dirname(x)==x) x else c(basename(x),split_path(dirname(x)))
