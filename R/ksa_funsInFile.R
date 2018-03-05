#' @title List all R functions used in a file
#'
#' @description Searches an .R file for function names and returns a list with the names of all functions found, grouped by package(s) that contain the functions. Only searches in the current namespace, so only attached packages will be searched for the function names.
#'
#' @param filename Path to the R script file (only the .R extension is supported)
#' @param alphabetic Sort the result alphabetically or not. (\emph{Default:} \code{TRUE})
#' @param exclude_pkgs A vector of packagenames that should be excluded from the result. Set to \code{NULL} to include all. (\emph{Default:} \code{c("base", "stats", "utils", "methods", "graphics", "grDevices")})
#'
#' @return A list of function names found in \code{filename} grouped by package
#' @export
ksa_funsInFile <- function (filename,
                            alphabetic = TRUE,
                            exclude_pkgs = c("base", "stats", "utils", "methods", "graphics", "grDevices")
                            )
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
  if (!is.null(exclude_pkgs)) {
    outlist <- outlist[which(!names(outlist) %in% paste0("package:", exclude_pkgs))]
  }
  if(any(names(outlist) == "character(0)"))
    names(outlist)[which(names(outlist) == "character(0)")] <- "unknown package(s)"
  return(outlist)
}
