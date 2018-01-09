#' @title Column classes
#' @description Returns a vector with the column classes of a data frame like object.
#'
#' @param df A data frame like object
#' @param value A character vector with the column classes of the provided data frame.
#' @export
#'
#' @example ksa_colClasses(iris)

ksa_colClasses <- function(df) {
  unlist(lapply(unclass(df), class))
  }
