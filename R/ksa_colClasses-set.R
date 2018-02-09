#' @title Set (coerce) the column classes of a dataframe
#'
#' @param df Dataframe like object
#' @param value Character vector containing elements of: \code{"c"} (character), \code{"n"} (numeric), \code{"f"} (factor), \code{"l"} (logical)" to set the column classes of \code{df}.
#'
#' @return A dataframe with coerced columns
#' @export
#'
#' @examples
#' df <- iris[1:10,]
#' df
#' ksa_colClasses(df)
#' ksa_colClasses(df) <- "nncfc"
#' ksa_colClasses(df)
`ksa_colClasses<-` <- function(df, value) {
  if(nchar(value) != ncol(df))
    stop("The number of columns in the dataframe does not match the number of characters in the vector of classes.")
  if(!is.character(value))
    stop("The classes must be provided as a character vector containing elements of: \"c\" (character), \"n\" (numeric), \"f\" (factor), \"l\" (logical)")
  value <- unlist(strsplit(value, ""))
  allowedClasses <- c("c", "n", "f", "l")
  for(i in 1:ncol(df)) {
    if(!any(value[[i]] %in% allowedClasses))
      stop(paste0("Unknown class \"", value[[i]], "\". Allowed classes are: \"c\", \"n\", \"f\", or \"l\""))
    if(value[[i]] == "c") {
      df[[i]] <- as.character(df[[i]])
    } else if(value[[i]] == "n") {
      df[[i]] <- as.numeric(df[[i]])
    } else if(value[[i]] == "f") {
      df[[i]] <- as.factor(df[[i]])
    } else if(value[[i]] == "l") {
      df[[i]] <- as.logical(df[[i]])
    }
  }
  return(df)
}
