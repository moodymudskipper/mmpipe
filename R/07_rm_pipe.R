#' Remove custom pipe
#'
#' used to remove pipes created with \code{add_pipe}, it's not allowed to remove
#' a predefined pipe
#'
#' @param x pipe to remove, as a raw name
#'
#' @export
#'
#' @examples
rm_pipe <- function(x){
  x <- as.character(substitute(x))
  if(x %in% protected_pipes) stop("`", x, "` is a predefined pipe and can't be removed")
  else if(!x %in% list_pipes())  stop("pipe `", x, "` doesn't exist")

  # remove from is_pipe
  new_is_pipe <- magrittr:::is_pipe
  body_chr <- as.character(body(new_is_pipe))[[2]]
  body_chr <- gsub(sprintf(" || identical(pipe, quote(`%s`))",x),"", body_chr,fixed = TRUE)
  body(new_is_pipe)[[2]] <- parse(text = body_chr)[[1]]
  assignInNamespace("is_pipe", new_is_pipe, ns = "magrittr", pos = "package:magrittr")

  # remove from wrap_function
  new_wrap_function <- magrittr:::wrap_function
  body_chr <- as.character(body(new_wrap_function))[[2]]
  pattern1 <- sprintf(
    "else if \\(identical\\(pipe, quote\\(`%s`\\)\\)\\).*?else", x)
  pattern2 <- sprintf(
    "else if \\(identical\\(pipe, quote\\(`%s`\\)\\)\\).*", x)
  body_chr <- if(grepl(pattern1, body_chr))
    gsub(pattern1, "else", body_chr) else gsub(pattern2, "", body_chr)
  body(new_wrap_function)[[2]] <- parse(text = body_chr)[[1]]
  assignInNamespace("wrap_function", new_wrap_function, ns = "magrittr", pos = "package:magrittr")
  invisible(NULL)
}


protected_pipes <-
  c("%>%", "%<>%", "%T>%", "%$%", "%D>%", "%V>%", "%L>%", "%C>%") # "-.gg")
