#' List all available pipes
#'
#' @export
list_pipes <- function(){
  dpth <- depth.call(body(magrittr:::is_pipe)[[2]])
  c("%>%",
    sapply(rev(seq(dpth - 2)),
           function(x) as.character(body(magrittr:::is_pipe)[[c(rep(2,x),3,3,2)]])))
}

depth.call <- function(x){
  if (length(x) == 3) max(sapply(x,depth.call)) + 1 else 1
}
