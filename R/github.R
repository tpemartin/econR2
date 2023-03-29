readClipUrlDownload = function(){
  url=clipr::read_clip()
  url |> getRawUrl() -> rawUrl
  rawUrl |> setUrlInSysEnv()
  rawUrl |> download_rawUrl()
}
update_localfile = function(){
  rawUrl = Sys.getenv("classUrl")
  rawUrl |> download_rawUrl()
}
download_rawUrl = function(rawUrl){
  localfile = basename(rawUrl)
  rawUrl |>
    xfun::read_utf8() |>
    xfun::write_utf8(localfile)
  file.edit(localfile)
}
setUrlInSysEnv = function(rawUrl){
  Sys.setenv("classUrl"=rawUrl)
}
