#' @title Document, check, and install a package
#' @description Everything I do before committing changes to an R package on GitHub. First restart R, then generates man pages, checks, installs, and builds package documentation website etc.
#'
#' @param install Install the package (\code{TRUE}) using \code{\link[devtools]{install}} or just load it in memory (\code{FALSE}) using \code{\link[devtools]{load_all}}. (Default: \code{TRUE})
#' @param pkgdown Build package documentation website using \code{\link[pkgdown]{build_site}} or not. (Default: \code{TRUE})
#' @param verbose Print status messages during the process or not. (Default: \code{TRUE})
#' @param test Run unit tests with \code{\link[devtools]{test}}. (Default: \code{FALSE})
#' @param check Check the package using \code{\link[devtools]{check}} or not. (Default: \code{TRUE})
#' @param style Style the source files found in the \code{"R/"} directory using \code{\link[styler]{style_file}}. This is performed in parallel by default on the individual files as it is much faster than simply using \code{\link[styler]{style_dir}}. Set \code{num_threads} to 1 to instead run \code{\link[styler]{style_dir}}. (Default: \code{TRUE})
#' @param num_threads The number of threads to be used if \code{style} is set to \code{TRUE}. (Default: \code{parallel::detectCores() - 2L})
#'
#' @export
#' @return Invisibly returns a list with the output of all steps run.
gogoawesomepkg <- function(style = TRUE,
                           check = TRUE,
                           test = FALSE,
                           install = TRUE,
                           pkgdown = TRUE,
                           verbose = TRUE,
                           num_threads = parallel::detectCores() - 2L) {
  if (!isTRUE(Sys.getenv("RSTUDIO") == "1")) {
    stop("Only works when using RStudio interactively", call. = FALSE)
  }
  afterRestartCmd <- paste0(
    "ksatools:::theactualgogoawesomepkgfunction(\n",
    "  style = ", style, ",\n",
    "  check = ", check, ",\n",
    "  test = ", test, ",\n",
    "  install = ", install, ",\n",
    "  pkgdown = ", pkgdown, ",\n",
    "  verbose = ", verbose, ",\n",
    "  num_threads = ", num_threads, "\n",
    ")"
  )
  .rs.restartR(afterRestartCmd)
  invisible()
}

#' gogo
#'
#' @description See \code{\link{gogoawesomepkg}}
#'
#' @param style Passed on from \code{\link{gogoawesomepkg}}
#' @param check Passed on from \code{\link{gogoawesomepkg}}
#' @param test Passed on from \code{\link{gogoawesomepkg}}
#' @param install Passed on from \code{\link{gogoawesomepkg}}
#' @param pkgdown Passed on from \code{\link{gogoawesomepkg}}
#' @param verbose Passed on from \code{\link{gogoawesomepkg}}
#' @param num_threads Passed on from \code{\link{gogoawesomepkg}}
#'
#' @return See \code{\link{gogoawesomepkg}}
#' @importFrom pkgdown clean_site build_site
#' @importFrom devtools build document install check load_all
#' @importFrom cli cat_line cat_rule cat_boxx
#' @importFrom styler style_file style_dir
#' @importFrom foreach foreach %dopar%
#' @importFrom parallel detectCores
#' @importFrom doParallel registerDoParallel
#' @importFrom rprojroot find_package_root_file
#' @keywords internal
theactualgogoawesomepkgfunction <- function(style = TRUE,
                                            check = TRUE,
                                            test = FALSE,
                                            install = TRUE,
                                            pkgdown = TRUE,
                                            verbose = TRUE,
                                            num_threads = parallel::detectCores() - 2L) {
  t1 <- Sys.time() # track time used
  # list with output from each step
  outlist <- list()

  ######## style source files with styler ########
  if (isTRUE(style)) {
    # find R files in R/ dir of package root
    sourceDir <- paste0(rprojroot::find_package_root_file(), "/R")
    files <- list.files(
      path = sourceDir,
      full.names = T,
      recursive = F,
      pattern = "*.R"
    )

    if (isTRUE(verbose)) {
      cli::cat_rule(center = paste0("Styling all ", length(files), " source files found in R/ using styler", if (num_threads > 1L) paste0(" (using ", num_threads, " threads)")))
    }

    # make cluster for parallel backend
    if (num_threads > 1L) {
      doParallel::registerDoParallel(num_threads)

      # style each file separately (faster than styler::style_pkg())
      outlist$styler <- foreach(i = seq_along(files), .combine = "rbind") %dopar% {
        styler::style_file(files[i])
      }

      # print the results from styler
      if (interactive()) {
        print(outlist$styler)
      }
    } else {
      outlist$styler <- styler::style_dir(sourceDir)
    }
  }

  ######## generate package documentation ########
  if (isTRUE(verbose)) {
    cli::cat_rule(center = "Generating package documentation and namespace")
  }
  outlist$devtools_document <- devtools::document()

  ######## R CMD CHECK ########
  if (isTRUE(check)) {
    if (isTRUE(verbose)) {
      cli::cat_rule(center = "Building and checking package")
    }
    outlist$devtools_check <- devtools::check(document = FALSE)
  }

  ######## unit tests ########
  if (isTRUE(test)) {
    if (isTRUE(verbose)) {
      cli::cat_rule(center = "Running unit tests")
    }
    outlist$devtools_test <- devtools::test()
  }

  ######## install or load ########
  if (isTRUE(install)) {
    if (isTRUE(verbose)) {
      cli::cat_rule(center = "Installing package")
    }
    outlist$devtools_install <- devtools::install()
  } else {
    if (isTRUE(verbose)) {
      cli::cat_rule(center = "Loading package directly into memory skipping installation")
    }
    outlist$devtools_load_all <- devtools::load_all()
  }

  ######## generate package documentation website ########
  if (isTRUE(pkgdown)) {
    if (isTRUE(verbose)) {
      cli::cat_rule(center = "Generating package documentation website (pkgdown)")
    }

    # clean pkgdown documentation website if any
    outlist$pkgdown_clean_site <- pkgdown::clean_site()

    # generate pkgdown documentation website
    outlist$pkgdown_build_site <- pkgdown::build_site()
  }

  ######## DONE ########
  t2 <- Sys.time()
  time <- t2 - t1
  cli::cat_boxx(paste0(
    "Done in ",
    round(as.numeric(time), 1),
    " ",
    attributes(time)$units,
    "! Did you remember to uptick the version in the DESCRIPTION file?"
  ))

  if (!exists("awesomepkgresults", envir = .GlobalEnv)) {
    assign("awesomepkgresults", outlist, envir = .GlobalEnv)
  }
  invisible(outlist)
}
