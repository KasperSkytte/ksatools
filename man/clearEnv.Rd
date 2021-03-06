% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clearEnv.R
\name{clearEnv}
\alias{clearEnv}
\title{Clear (global) environment and free up memory}
\usage{
clearEnv(envir = .GlobalEnv, hidden = TRUE)
}
\arguments{
\item{envir}{\emph{(optional)} The environment to clear. \emph{default:} \code{.GlobalEnv}}

\item{hidden}{\emph{(optional)} Include hidden objects (those starting with a dot "."). \emph{default:} \code{TRUE}}
}
\value{
Prints the removed objects, their classes, and the output from garbage collector.
}
\description{
Removes all objects in the global environment including hidden objects, and afterwards runs the garbage collector to free up memory.
}
\examples{
assign("test", "test", envir = .GlobalEnv)
clearEnv()
}
