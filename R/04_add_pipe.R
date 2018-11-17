#' build a new pipe in one command
#'
#' @param new_pipe name
#' @param new_body call, the variable body used in this call holds the initial
#'   call
#'
#' @return the operator is created and *magrittr*'s namespace is modified to
#'   make the new operator compatible. NULL is returned.
#' @export
#'
#' @examples
#' # if we wanted to recreate existing operators
#' add_pipe(`%T2>%`, call("{", body, quote(.)))
#' iris %T2>% {message("side effect")} %>% head(2)
#' add_pipe(`%W2>%`, substitute(
#'     {options(warn = -1); on.exit(options(warn = w)); b},
#'     list(w = options()$warn, b = body)))
#' data.frame(a = c(1,-1)) %W2>% transform(a = sqrt(a))
#' add_pipe(`%P2>%`, substitute({. <- print(b);cat("\n");.}, list(b = body)))
#' iris %P>% head(3) %>% head(2)
add_pipe <- function(new_pipe, new_body){
  new_is_pipe <- magrittr:::is_pipe
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