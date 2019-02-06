#' @title Clear (global) environment and free up memory
#' @description Removes all objects in the global environment including hidden objects, and afterwards runs the garbage collector to free up memory.
#'
#' @param envir \emph{(optional)} The environment to clear. \emph{default:} \code{.GlobalEnv}
#' @param hidden \emph{(optional)} Include hidden objects (those starting with a dot "."). \emph{default:} \code{TRUE}
#'
#' @return Prints the removed objects, their classes, and the output from garbage collector.
#' @export
#'
#' @importFrom crayon underline
#'
#' @examples
#' assign("test", "test", envir = .GlobalEnv)
#' clearEnv()
clearEnv <- function(envir = .GlobalEnv,
                     hidden = TRUE) {
  objects <- ls(envir = envir, all.names = hidden)
  classes <- c()
  for (i in 1:length(objects)) {
    classes <- append(classes, paste0(class(get(objects[[i]])), collapse = ", "))
  }
  if (length(objects) > 0) {
    rm(list = objects, envir = envir)
    cat(crayon::underline("The following", length(objects), "objects were removed:\n"))
    print.data.frame(data.frame("*object*" = objects, "*class*" = classes, check.names = FALSE), row.names = FALSE, right = FALSE)
  } else if (length(objects) == 0) {
    cat("0 objects were removed")
  }
  cat(crayon::underline("\nGarbage collector:\n"))
  gc(verbose = FALSE, reset = TRUE)
}
