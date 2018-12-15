#' Pipe operators to enhance magrittr
#'
#' These operators all return the same as magrittr's pipe operator but have
#' additional side effects.
#'
#' \describe{
#'   \item{\%W>\%}{silence warnings}
#'   \item{\%V>\%}{uses \code{View()} on the output}
#'   \item{\%L>\%}{logs the relevant call to the console}
#'   \item{\%P>\%}{uses \code{print()} on the output}
#'   \item{\%S>\%}{prints the \code{summary()} off the output}
#'   \item{\%G>\%}{uses \code{tibble::glimpse} on the output}
#'   \item{\%D>\%}{debugs the pipe chain at the relevant step}
#'   \item{\%C>\%}{clocks the relevant step}
#' }
#'
#' @inheritParams magrittr::`%>%`
#'
#' @examples
#' # silence a warning
#' data.frame(a= c(1,-1)) %W>% transform(a=sqrt(a))
#'
#' # view stepps of chain in the viewer
#' iris %V>% head(2) %V>% `[`(4:5)
#'
#' # log steps in the console
#' iris %L>% {Sys.sleep(1);head(.,2)} %L>% {Sys.sleep(2);.[4:5]}
#'
#' # use print, summary or glimpse on output
#' iris %P>% head(2) %P>% `[`(4:5)
#' iris %S>% head(2) %S>% `[`(4:5)
#' iris %G>% head(2) %G>% `[`(4:5)
#'
#' # debug the chain
#' iris %>% head(2) %D>% `[`(4:5)
#' @name pipeops
NULL


#' @rdname pipeops
#' @export
`%W>%` <- magrittr::`%>%`

#' @rdname pipeops
#' @export
`%G>%` <- magrittr::`%>%`

#' @rdname pipeops
#' @export
`%S>%` <- magrittr::`%>%`

#' @rdname pipeops
#' @export
`%P>%` <- magrittr::`%>%`

#' @rdname pipeops
#' @export
`%D>%` <- magrittr::`%>%`

#' @rdname pipeops
#' @export
`%V>%` <- magrittr::`%>%`

#' @rdname pipeops
#' @export
`%L>%` <- magrittr::`%>%`

#' @rdname pipeops
#' @export
`%C>%` <- magrittr::`%>%`
