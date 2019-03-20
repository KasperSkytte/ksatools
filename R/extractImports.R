#' Extract all unique packages listed in a namespace file
#'
#' @param namespace Path to \code{NAMESPACE} file. (\emph{default:} \code{"NAMESPACE"})
#'
#' @return A character vector with the packages found
#' @export
#'
extractImports <- function(namespace = "NAMESPACE") {
  namespace <- readLines(namespace)
  imports <- namespace[grepl("^import", tolower(namespace))]
  pkgs <- sort(unique(gsub(".*\\(|[,\\)].*", "", imports)))
  return(pkgs)
}
