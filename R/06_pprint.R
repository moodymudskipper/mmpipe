#' Pipe friendly printing
#'
#' \code{pprint} makes it easy to print information about the pipe chain's status.
#'
#' @param .data An object
#' @param .fun An expression or a function to apply on \code{.data} so the output can be printed,
#'   supports formula notation through \code{purrr::as_mapper}.
#' @param ... Additional parameters passed to .fun
#'
#' @export
#'
#' @examples
#' iris %>%
#' pprint(~"hello")           %>%
#' pprint("hi")               %>% # simple expressions work as well
#' head(2)                    %>%
#' transform(Species = NULL)  %>%
#' pprint(rowSums,na.rm=TRUE) %>%
#' pprint(~dplyr::rename_all(.[1:2],toupper)) %>%
#' pprint(dim)
pprint <- function(.data,.fun,...){
  if (inherits(.fun, "formula"))
    .fun <- rlang::as_function(.fun)
  if (is.function(.fun)) .fun <- .fun(.data,...)
  print(.fun)
  invisible(.data)
}
