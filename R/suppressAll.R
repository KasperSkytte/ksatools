#' @title Suppress all types of diagnostic messages, error messages, and/or outputs
#' @description Simply wraps the given expression in \code{\link{tryCatch}}, \code{\link{invisible}}, \code{\link{capture.output}}, \code{\link{suppressMessages}}, \code{\link{suppressWarnings}}, and \code{\link{suppressPackageStartupMessages}} to suppress any possible console output.
#'
#' @param expr Expression to be evaluated.
#' @importFrom utils capture.output
#' @export
#'
#' @examples
#' suppressAll({
#'   stop("Some error")
#'   print("Some print")
#'   message("Some message")
#'   warning("Some warning")
#'   some_variable <- "test"
#'   return(some_variable)
#' })
suppressAll <- function(expr) {
  tryCatch(
    {
      invisible(utils::capture.output(suppressMessages(suppressWarnings(suppressPackageStartupMessages(expr)))))
    },
    error = function(e) invisible()
  )
}
