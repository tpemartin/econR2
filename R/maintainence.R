update_package <- function(){
  if(!require(remotes)){
    install.packages("remotes", dependencies = T)
  }
  remotes::install_github(
    "tpemartin/econR2", force=T
  )
}
