#' @title Extract and assign the default values of arguments (formals) of a function
#'
#' @description ...and assign them to objects with the same names in an environment (global is default).
#' This is useful for testing and developing a function by running its source code line by line.
#'
#' @param fun Function from which to extract defaults
#' @param envir Environment in which to assign the default values of the arguments
#'
#' @return Nothing (\code{invisible()}). The function is only used for its side-effects.
#' @export
#' @author Kasper Skytte Andersen
assignFormals <- function(fun, envir = .GlobalEnv) {
  if (!is.function(fun)) {
    stop("Argument must be a function or the name of a function in quotes", call. = FALSE)
  }
  formals <- formals(fun)
  if (is.null(formals)) {
    stop("Function has no formals", call. = FALSE)
  }
  for (i in seq_along(formals)) {
    assign(names(formals[i]),
      formals[[i]],
      envir = envir
    )
  }
  invisible()
}
