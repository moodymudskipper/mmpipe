#' Pipe friendly printing
#'
#' \code{pprint} makes it easy to print information about the pipe chain's status.
#'
#' @param .data An object
#' @param .fun A function to apply on \code{.data} so the output can be printed,
#'   supports formula notation through \code{purrr::as_mapper}.
#' @param ... Additional parameters passed to .fun
#'
#' @export
#'
#' @examples
#' iris %>%
#' pprint(~"hello")           %>%
#' head(2)                    %>%
#' transform(Species = NULL)  %>%
#' pprint(rowSums,na.rm=TRUE) %>%
#' pprint(~rename_all(.[1:2],toupper)) %>%
#' pprint(dim)
pprint <- function(.data,.fun,...){
  if(!requireNamespace("purrr"))
    stop("package purrr must be installed to use `pprint`")
  .fun <- purrr::as_mapper(.fun)
  print(.fun(.data,...))
  invisible(.data)
}
