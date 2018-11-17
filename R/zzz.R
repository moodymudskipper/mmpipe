.onLoad <- function(libname, pkgname){
  requireNamespace("magrittr")
  assignInNamespace("is_pipe", new_is_pipe, ns = "magrittr", pos = "package:magrittr")
  assignInNamespace(
    "wrap_function", new_wrap_function,
    ns = "magrittr", pos = "package:magrittr")
}
