#' build a new pipe in one command
#'
#' The argument `new_body` will often be a `substitute` call, the variable `.`
#' contains the output of the previous operation while the variable body
#' contains the call that would be executed by a regular `%>%` pipe and modify
#' it to get the new behavior.
#'
#' @param new_pipe A name
#' @param new_body A call
#'
#' @return the operator is created and *magrittr*'s namespace is modified to
#'   make the new operator compatible. NULL is returned.
#' @export
#'
#' @examples
#' # create a pipe that prints the dimensions before executing the relevant step
#' add_pipe(`%dim1>%`, substitute({print(dim(.)); . <- b; cat("\n"); .}, list(b = body)))
#' iris %dim1>% head(2)
#' # create a pipe that prints the dimensions after executing the relevant step
#' add_pipe(`%dim2>%`, substitute({. <- b; print(dim(.)); cat("\n"); .}, list(b = body)))
#' iris %dim2>% head(2)
#' # if we wanted to recreate existing operators
#' add_pipe(`%T2>%`, call("{", body, quote(.)))
#' iris %T2>% {message("side effect")} %>% head(2)
#' add_pipe(`%W2>%`, substitute(
#'     {options(warn = -1); on.exit(options(warn = w)); b},
#'     list(w = options()$warn, b = body)))
#' data.frame(a = c(1,-1)) %W2>% transform(a = sqrt(a))
#' add_pipe(`%P2>%`, substitute({. <- print(b);cat("\n");.}, list(b = body)))
#' iris %P2>% head(3) %>% head(2)

add_pipe <- function(new_pipe, new_body){
  new_pipe_chr <- as.character(substitute(new_pipe))
  if (new_pipe_chr %in% protected_pipes)
    stop("`",new_pipe_chr, "` is a predefined pipe, you can't overwrite it")
  else if (new_pipe_chr %in% list_pipes()) {
    message("`",new_pipe_chr, "` will be overwritten")
    eval(substitute(rm_pipe(new_pipe)))
  }

  new_is_pipe <- magrittr:::is_pipe
  # body(x)[[2]] is the real body, after the `{` element
  body(new_is_pipe)[[2]] <- substitute(b || identical(pipe, quote(new_pipe)),
                                       list(b = body(new_is_pipe)[[2]],
                                            new_pipe = substitute(new_pipe)))
  assignInNamespace("is_pipe", new_is_pipe, ns = "magrittr", pos = "package:magrittr")

  new_wrap_function <- magrittr:::wrap_function
  b <- body(new_wrap_function)[[2]]
  ind <- c(2)
  while (length(b) == 4) {
    ind <- c(ind,4)
    b <- body(new_wrap_function)[[ind]]
  }

  body(new_wrap_function)[[c(ind,4)]] <-
    substitute(if (identical(pipe, quote(new_pipe))) body <- new_body,
               list(b = body(new_wrap_function)[[2]],
                    new_body = substitute(new_body),
                    new_pipe = substitute(new_pipe)))
  assignInNamespace("wrap_function", new_wrap_function,
                    ns = "magrittr", pos = "package:magrittr")
  assign(as.character(substitute(new_pipe)),magrittr::`%>%`,envir = .GlobalEnv)
  invisible(NULL)
}
