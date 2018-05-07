#' @title Build, install, and roxygenize() a package, then generate webpage
#' @description Just runs \code{roxygen2::roxygenize(); pkgdown::clean_site(); pkgdown::build_site()}. I ran this so many times now that a small function like this is actually useful.
#'
#' @importFrom roxygen2 roxygenize
#' @importFrom pkgdown clean_site build_site
#' @importFrom devtools build install
#' @export

ksa_pkgDocs <- function() {
  roxygen2::roxygenize()
  devtools::build()
  devtools::install()
  pkgdown::clean_site()
  pkgdown::build_site()
}
