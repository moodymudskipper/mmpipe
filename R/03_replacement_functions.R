# function defined to replace original magrittr:::is_pipe
new_is_pipe <- function (pipe)
{
  identical(pipe, quote(`%>%`)) || identical(pipe, quote(`%T>%`)) ||
    identical(pipe, quote(`%<>%`)) || identical(pipe, quote(`%$%`)) ||
    identical(pipe, quote(`%W>%`)) || identical(pipe, quote(`%P>%`)) ||
    identical(pipe, quote(`%V>%`)) || identical(pipe, quote(`%L>%`)) ||
    identical(pipe, quote(`%D>%`)) || identical(pipe, quote(`%S>%`)) ||
    identical(pipe, quote(`%G>%`))
}

# function defined to replace original magrittr:::wrap_function
new_wrap_function <- function(body, pipe, env) {
  if (magrittr:::is_tee(pipe)) {
    body <- call("{", body, quote(.))
  }
  else if (magrittr:::is_dollar(pipe)) {
    body <- substitute(with(., b), list(b = body))
  }
  else if (identical(pipe, quote(`%W>%`))) {
    body <- substitute(
      {options(warn = -1); on.exit(options(warn = w)); b},
      list(w = options()$warn, b = body))
  }
  else if (identical(pipe, quote(`%P>%`))) {
    body <- substitute({. <- print(b);cat("\n");.}, list(b = body))
  }
  else if (identical(pipe, quote(`%L>%`))) {
    body <- substitute({print(quote(b)); b}, list(b = body))
  }
  else if (identical(pipe, quote(`%V>%`))) {
    body <- substitute(
      {. <- b; View(., b_chr); .},
      list(b = body, b_chr = paste(as.character(body), collapse = "\n")))
  }
  else if (identical(pipe, quote(`%D>%`))) {
    body <-  call(
      "{",
      substitute(
        pipe_browse <- as.function(alist(b)), #, envir = new.env(parent = .GlobalEnv)
                 list(b = body)),
      quote(debugonce(pipe_browse)),
      quote(pipe_browse()))
  }
  else if (identical(pipe, quote(`%S>%`))) {
    body <- substitute({. <- b; print(summary(.)); cat("\n"); .}, list(b = body))
  }
  else if (identical(pipe, quote(`%G>%`))) {
    body <- substitute({. <- b; dplyr::glimpse(.);cat("\n"); .}, list(b = body))
  }
  eval(call("function", as.pairlist(alist(. = )), body), env, env)
}
