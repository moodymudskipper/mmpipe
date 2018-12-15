#' Pipe friendly conditional operation
#'
#' Apply a transformation on the data only if a condition is met,
#' by default if condition is not met the input is returned unchanged.
#'
#' The use of formula or functions is recommended over the use of expressions
#' for the following reasons :
#'
#' \itemize{
#'   \item If \code{true} and/or \code{false} are provided as expressions they
#'   will be evaluated wether the condition is \code{TRUE} or \code{FALSE}.
#'   Functions or formulas on the other hand will be applied on the data only if
#'   the relevant condition is met
#'   \item Formulas support calling directly a column of the data by its name
#'   without \code{x$foo} notation.
#'   \item Dot notation will work in expressions only if `pif` is used in a pipe
#'   chain
#' }
#'
#' @param x An object
#' @param p A predicate function, a formula describing such a predicate function, or an expression.
#' @param true,false Functions to apply to the data, formulas describing such functions, or expressions.
#'
#' @return The output of \code{true} or \code{false}, either as expressions or applied on data as functions
#' @export
#'
#' @examples
#' # using functions
#' iris %>% pif(is.data.frame, dim, nrow)
#' # using formulas
#' iris %>% pif(~is.numeric(Species), ~"numeric :)",~paste(class(Species)[1],":("))
#' # using expressions
#' iris %>% pif(nrow(iris) > 2, head(iris,2))
#' # careful with expressions
#' iris %>% pif(TRUE, dim,  warning("this will be evaluated"))
#'  iris %>% pif(TRUE, dim, ~warning("this won't be evaluated"))
pif <- function(x, p, true, false = identity){
  if (inherits(p,     "formula"))
    p     <- rlang::as_function(
      if (!is.list(x)) p else update(p,~with(...,.)))
  if (inherits(true,  "formula"))
    true  <- rlang::as_function(
      if (!is.list(x)) true else update(true,~with(...,.)))
  if (inherits(false, "formula"))
    false <- rlang::as_function(
      if (!is.list(x)) false else update(false,~with(...,.)))

  if ( (is.function(p) && p(x)) || (!is.function(p) && p)) {
    if (is.function(true)) true(x) else true
  }  else {
    if (is.function(false)) false(x) else false
  }
}
