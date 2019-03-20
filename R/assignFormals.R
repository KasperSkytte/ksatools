#' @title Extract and assign the default values of arguments (formals) of a function
#'
#' @description ...and assign them to objects with the same names in an environment (global is default).
#' This is useful for testing and developing a function by running its source code line by line.
#'
#' @param fun Function from which to extract defaults
#' @param envir Environment in which to assign the default values of the arguments
#'
#' @return Invisibly returns a list with 3 elements; The function formals, assigned formals, and unassigned formals
#' @export
#' @author Kasper Skytte Andersen
assignFormals <- function(fun, envir = .GlobalEnv) {
  formals <- unlist(formals(fun))
  if (is.null(formals)) {
    stop("Function has no formals", call. = FALSE)
  }
  noDefaults <- character()
  assignedFormals <- character()
  for (i in seq_along(formals)) {
    if (formals[[i]] != "") {
      assign(names(formals[i]),
        formals[[i]],
        envir = envir
      )
      assignedFormals <- c(assignedFormals, names(formals[i]))
    } else {
      noDefaults <- c(noDefaults, names(formals[i]))
    }
  }
  message(paste0(
    "* ",
    length(assignedFormals),
    " formal",
    if (length(assignedFormals) == 1) {
      " was"
    } else {
      "s were"
    },
    " assigned in the environment \"",
    environmentName(envir),
    "\":\n",
    paste0(assignedFormals, collapse = ", ")
  ))
  if (length(noDefaults) > 0) {
    message(paste0(
      "* ",
      length(noDefaults),
      " formal",
      if (length(noDefaults) > 1) {
        "s"
      },
      " had no default:\n",
      paste0(noDefaults, collapse = ", ")
    ))
  }
  invisible(list(
    formals = formals,
    assignedFormals = assignedFormals,
    noDefaults = noDefaults
  ))
}
