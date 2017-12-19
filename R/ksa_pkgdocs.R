#' @title Generate package webpage
#' @description Just runs \code{roxygen2::roxygenize(); pkgdown::clean_site(); pkgdown::build_site()}
#'
#' @import roxygen2
#' @import pkgdown
#' @export

ksa_pkgdocs <- function() {
  roxygen2::roxygenize()
  pkgdown::clean_site()
  pkgdown::build_site()
}
