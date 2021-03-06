% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/05_pif.R
\name{pif}
\alias{pif}
\title{Pipe friendly conditional operation}
\usage{
pif(x, p, true, false = identity)
}
\arguments{
\item{x}{An object}

\item{p}{A predicate function, a formula describing such a predicate function, or an expression.}

\item{true, false}{Functions to apply to the data, formulas describing such functions, or expressions.}
}
\value{
The output of \code{true} or \code{false}, either as expressions or applied on data as functions
}
\description{
Apply a transformation on the data only if a condition is met,
by default if condition is not met the input is returned unchanged.
}
\details{
The use of formula or functions is recommended over the use of expressions
for the following reasons :

\itemize{
  \item If \code{true} and/or \code{false} are provided as expressions they
  will be evaluated wether the condition is \code{TRUE} or \code{FALSE}.
  Functions or formulas on the other hand will be applied on the data only if
  the relevant condition is met
  \item Formulas support calling directly a column of the data by its name
  without \code{x$foo} notation.
  \item Dot notation will work in expressions only if `pif` is used in a pipe
  chain
}
}
\examples{
# using functions
iris \%>\% pif(is.data.frame, dim, nrow)
# using formulas
iris \%>\% pif(~is.numeric(Species), ~"numeric :)",~paste(class(Species)[1],":("))
# using expressions
iris \%>\% pif(nrow(.) > 2, head(.,2))
# careful with expressions
iris \%>\% pif(TRUE, dim,  warning("this will be evaluated"))
 iris \%>\% pif(TRUE, dim, ~warning("this won't be evaluated"))
}
