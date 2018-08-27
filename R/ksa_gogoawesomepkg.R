#' @title Document, check, and install a package
#' @description Everything I do before commiting changes to GitHub. Generates package man pages, checks, installs, and builds package documentation website etc.
#'
#' @param install Install the package (\code{TRUE}) using \code{\link[devtools]{install}} or just load it in memory (\code{FALSE}) using \code{\link[devtools]{load_all}}. (Default: \code{TRUE})
#' @param pkgdown Build package documentation website or not. (Default: \code{TRUE})
#' @param verbose Print status messages during the process or not. (Default: \code{TRUE})
#' @param check Check the package using \code{\link[devtools]{check}} or not. (Default: \code{TRUE})
#'
#' @importFrom pkgdown clean_site build_site
#' @importFrom devtools build document install check load_all
#' @importFrom cli cat_line cat_rule cat_boxx
#' @export
#' @return Invisibly returns a list with the output of all steps run.
ksa_gogoawesomepkg <- function(check = FALSE,
                               install = TRUE,
                               pkgdown = TRUE,
                               verbose = TRUE) {
  outlist <- list()
  #generate package documentation
  if(isTRUE(verbose))
    cli::cat_rule(center = "Generating package documentation and namespace")
  outlist$devtools_document <- devtools::document()

  #R CMD CHECK
  if(isTRUE(check)) {
    if(isTRUE(verbose))
      cli::cat_rule(center = "Building and checking package")
    outlist$devtools_check <- devtools::check(document = FALSE)
  }

  #install or just load
  if(isTRUE(install)) {
    if(isTRUE(verbose))
      cli::cat_rule(center = "Installing package")
    outlist$devtools_install <- devtools::install()
  } else {
    if(isTRUE(verbose))
      cli::cat_rule(center = "Loading package directly into memory skipping installation")
    outlist$devtools_load_all <- devtools::load_all()
  }

  #generate package documentation website
  if(isTRUE(pkgdown)) {
    if(isTRUE(verbose))
      cli::cat_rule(center = "Generating package documentation website (pkgdown)")
    #clean pkgdown documentation website if any
    outlist$pkgdown_clean_site <- pkgdown::clean_site()
    #generate pkgdown documentation website
    outlist$pkgdown_build_site <- pkgdown::build_site()
  }
  cli::cat_boxx("Done! Did you remember to uptick the version in the DESCRIPTION file?")
  invisible(outlist)
}
