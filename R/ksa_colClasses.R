#' @title Column classes of a data frame
#' @description Returns a vector with the column classes of a data frame like object.
#'
#' @param df A data frame like object
#' @note Cannot handle columns with more than one class.
#' @return A data frame containing the column classes of the provided data frame.
#' @export
#'
#' @examples
#' ksa_colClasses(iris)

ksa_colClasses <- function(df) {
  class <- unlist(lapply(unclass(df), class))
  return(as.data.frame(class))
  }
