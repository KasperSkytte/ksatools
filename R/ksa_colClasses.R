#' @title Get the column classes of a dataframe
#' @description Returns a vector with the column classes of a dataframe like object, or coerces the column classes as defined by user.
#'
#' @param df Dataframe like object
#' @note Cannot handle columns with more than one class.
#' @return A dataframe containing the column classes of the provided dataframe
#' @export
#'
#' @examples
#' df <- iris[1:10,]
#' ksa_colClasses(df)
#' ksa_colClasses(df) <- "nncfc"
#' ksa_colClasses(df)

ksa_colClasses <- function(df) {
  class <- unlist(lapply(unclass(df), class))
  return(as.data.frame(class))
}
