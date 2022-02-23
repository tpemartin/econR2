update_package <- function(){
  if(!require(devtools)){
    install.packages("remotes", dependencies = T)
  }
  remotes::install_github(
    "tpemartin/econR2", force=T
  )
}
