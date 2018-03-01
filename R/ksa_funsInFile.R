#' List all R functions used in a file
#'
#' @param filename
#' @param alphabetic
#' @param include_base
#'
#' @return
#' @export
#'
#' @examples
ksa_funsInFile <- function (filename, alphabetic = TRUE, include_base = FALSE)
{
  if (!file.exists(filename)) {
    stop("couldn't find file ", filename)
  }
  if (!tools::file_ext(filename) == "R") {
    warning("expecting *.R file, will try to proceed")
  }
  tmp <- getParseData(parse(filename, keep.source = TRUE))
  nms <- tmp$text[which(tmp$token == "SYMBOL_FUNCTION_CALL")]
  funs <- unique(if (alphabetic) {
    sort(nms)
  }
  else {
    nms
  })
  src <- paste(as.vector(sapply(funs, find)))
  outlist <- tapply(funs, factor(src), c)
  if (!isTRUE(include_base)) {
    outlist <- outlist[which(names(outlist) != "package:base")]
  }
  return(outlist)
}
