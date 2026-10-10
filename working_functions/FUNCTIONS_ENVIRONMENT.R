##########################################################################################
# LOAD ENVIRONMENT
##########################################################################################
#' @title Load environment options
#' @keywords functions
#' @export
#' @examples
#' environment_options()
environment_options <- function() {
  options(encoding = "UTF8")
  options(digits = 4)
  options(scipen = 999)
  options(max.print = 10000)
  options(warning.length = 1000)
  options(nwarnings = 10000)
  options(verbose = FALSE)
}
##########################################################################################
# LOAD AND INSTALL MULTIPLE LIBRARIES
##########################################################################################
#' @title Install and load multiple packages
#' @description Checks whether each package in \code{package} is already
#'   installed. Missing packages are downloaded from CRAN with
#'   \code{dependencies = TRUE} and then loaded. Packages that are already
#'   installed are loaded directly without reinstalling.
#' @param package Character vector of package names to install (if needed)
#'   and load.
#' @return A named logical vector (one element per package) indicating whether
#'   each package was successfully attached: \code{TRUE} if loaded,
#'   \code{FALSE} if loading failed.
#' @importFrom utils installed.packages install.packages
#' @author Steven Worthington
#' @keywords functions
#' @export
#' @examples
#' install_load("car")
#' install_load(c("car", "ggplot2"))
install_load <- function(package) {
  new.package <- package[!(package %in% utils::installed.packages()[, "Package"])]
  if (length(new.package)) {
    utils::install.packages(new.package, dependencies = TRUE)
  }
  sapply(package, require, character.only = TRUE)
}
##########################################################################################
# INSTALL ALL PACKAGES
##########################################################################################
#' @title Install all missing CRAN packages
#' @description Compares the set of currently installed packages against the
#'   full list of packages available on CRAN and installs any that are missing.
#'   Already-installed packages are not re-downloaded or updated. Note that
#'   CRAN contains thousands of packages, so this function can take a very
#'   long time and requires a large amount of disk space.
#' @return Invisibly returns \code{NULL}. Called for its side effect of
#'   installing packages.
#' @importFrom utils installed.packages available.packages install.packages
#' @keywords functions
#' @export
install_all_packages <- function() {
  installed_packages <- data.frame(utils::installed.packages(), stringsAsFactors = FALSE)
  available_packages <- data.frame(utils::available.packages(), stringsAsFactors = FALSE)
  missing_packages <- sort(setdiff(
    sort(unique(available_packages$Package)),
    sort(unique(installed_packages$Package))
  ))
  utils::install.packages(missing_packages)
}
##########################################################################################
# REMOVE USER INSTALLED PACKAGES
##########################################################################################
#' @title Remove all user-installed packages
#' @description Uninstalls every package that is not part of the R base or
#'   recommended distribution. Packages installed in Microsoft R Open (MRO)
#'   library paths are also preserved. Only packages with no \code{Priority}
#'   field (i.e. neither \code{"base"} nor \code{"recommended"}) are removed.
#'   \strong{Warning:} this operation is irreversible. All third-party packages
#'   will need to be reinstalled afterwards.
#' @return Invisibly returns a named list with one element per removed package
#'   (the result of \code{remove.packages()}). Called primarily for its side
#'   effect of uninstalling packages.
#' @importFrom utils remove.packages
#' @keywords functions
#' @export
remove_user_packages <- function() {
  installed_packages <- data.frame(installed.packages())
  installed_packages <- subset(installed_packages, !grepl("MRO", installed_packages$LibPath))
  installed_packages <- installed_packages[!(installed_packages[, "Priority"] %in% c("base", "recommended")), ]
  path.lib <- unique(installed_packages$LibPath)
  remove_packages <- installed_packages[, 1]
  sapply(remove_packages, utils::remove.packages, lib = path.lib)
}
##########################################################################################
# UNLOAD LIBRARY
##########################################################################################
#' @title Detach and unload a package
#' @description Removes a package from the R search path and unloads its
#'   namespace. If the package was attached more than once, all instances are
#'   removed. Does nothing if the package is not currently attached.
#' @param package Character string giving the name of the package to detach
#'   (without the \code{"package:"} prefix), e.g. \code{"ggplot2"}.
#' @return Invisibly returns \code{NULL}. Called for its side effect of
#'   detaching the package.
#' @keywords functions
#' @export
detach_package <- function(package) {
  search_item <- paste("package", package, sep = ":")
  while (search_item %in% search()) {
    detach(search_item, unload = TRUE, character.only = TRUE)
  }
}
##########################################################################################
# GET WORKING FILE PATH
##########################################################################################
#' @title Get the file path of the currently running script
#' @description Returns the normalised absolute path of the R script that is
#'   currently executing. The function tries the following methods in order:
#'   \enumerate{
#'     \item The \code{--file=} command-line argument (set when running via
#'       \code{Rscript script.R}).
#'     \item The \code{fileName} variable in the first call-stack frame (set
#'       by some IDEs).
#'     \item The \code{ofile} variable in the first call-stack frame (set when
#'       the script is loaded with \code{source()}).
#'     \item The active document path from \code{rstudioapi} (RStudio only).
#'     \item The source editor path from \code{rstudioapi} as a fallback.
#'   }
#' @return A character string containing the normalised absolute path of the
#'   current script, or an empty string (\code{""}) if the path cannot be
#'   determined.
#' @keywords functions
#' @export
#' @examples
#' # getfwp()
getfwp <- function() {
  # https://stackoverflow.com/a/36777602/6247402
  # http://stackoverflow.com/a/35842176/2292993
  # http://stackoverflow.com/a/32016824/2292993
  command_arguments <- commandArgs(trailingOnly = FALSE)
  needle <- "--file="
  match <- grep(needle, command_arguments)
  if (length(match) > 0) {
    return(normalizePath(sub(needle, "", command_arguments[match])))
  } else {
    ls_vars <- ls(sys.frames()[[1]])
    if ("fileName" %in% ls_vars) {
      return(normalizePath(sys.frames()[[1]]$fileName))
    } else {
      if (!is.null(sys.frames()[[1]]$ofile)) {
        return(normalizePath(sys.frames()[[1]]$ofile))
      } else {
        # rstudioapi errors outside RStudio and may return NULL when no editor is open,
        # so every failure becomes "" instead of an error
        rstudio_path <- function(context) {
          path <- tryCatch(context()$path, error = function(e) "")
          if (length(path) == 1 && !is.na(path)) path else ""
        }
        path <- rstudio_path(rstudioapi::getActiveDocumentContext)
        if (path == "") {
          path <- rstudio_path(rstudioapi::getSourceEditorContext)
        }
        if (path == "") {
          return("")
        }
        return(normalizePath(path))
      }
    }
  }
}
##########################################################################################
# LOG FILE
##########################################################################################
#' @title Print an object and optionally save output to a log file
#' @description Prints \code{input} to the console. When \code{file} is
#'   supplied, the printed output is also captured to a \code{.log} file using
#'   \code{sink()}, and the file contents are echoed back to the console after
#'   writing, so the output is visible in both places.
#' @param input Any R object to print.
#' @param file Character string naming the output log file without extension.
#'   A \code{.log} extension is appended automatically. When \code{NULL}
#'   (default) output is printed to the console only and no file is written.
#' @return Invisibly returns \code{NULL}. Called for its side effects of
#'   printing and optionally writing to a log file.
#' @keywords functions
#' @export
#' @examples
#' write_txt(mtcars)
#' write_txt(mtcars, file = "mtcars")
write_txt <- function(input, file = NULL) {
  if (!is.null(file)) {
    results <- file(invisible(paste0(file, ".log")))
    sink(results, append = TRUE)
    sink(results, append = TRUE, type = "message")
  }
  print(input)
  if (!is.null(file)) {
    sink()
    sink(type = "message")
    cat(readLines(invisible(paste0(file, ".log"))), sep = "\n")
  }
}
##########################################################################################
# COMBINE FILES
##########################################################################################
#' @title Combine all files in a directory into a single file
#' @description Lists the files in \code{input_dir} that match \code{pattern},
#'   reads each one and writes their contents, in alphabetical order, to
#'   \code{output_file}. Each file's contents are preceded by a
#'   \code{# FILE: <path>} header block so the origin of every section is
#'   visible. If \code{output_file} lies inside \code{input_dir}, it is
#'   excluded so the file does not include itself. If no file matches,
#'   an empty \code{output_file} is written.
#' @param input_dir Character string. Directory to read files from. Default
#'   \code{"working_functions"}.
#' @param output_file Character string. Path of the combined file to write.
#'   An existing file is overwritten. Default \code{"all_functions.R"}.
#' @param pattern Regular expression passed to \code{base::list.files()}
#'   to select files. Default \code{"\\\\.[Rr]$"} selects R scripts. Use
#'   \code{NULL} to include every file.
#' @param recursive Logical. If \code{TRUE} (default), files in
#'   subdirectories of \code{input_dir} are included; if \code{FALSE}, only
#'   files directly in \code{input_dir}.
#' @return Invisibly returns a character vector with the paths of the
#'   combined files. Called for its side effect of writing
#'   \code{output_file}.
#' @keywords functions
#' @export
#' @examples
#' # input_dir <- file.path(tempdir(), "combine_files_example")
#' # dir.create(file.path(input_dir, "sub"), recursive = TRUE, showWarnings = FALSE)
#' # writeLines("a <- 1", file.path(input_dir, "a.R"))
#' # writeLines("b <- 2", file.path(input_dir, "sub", "b.R"))
#' # output_file <- file.path(tempdir(), "combined.R")
#' # combine_files(input_dir = input_dir, output_file = output_file)
#' # cat(readLines(output_file), sep = "\n")
#' # combine_files(input_dir = input_dir, output_file = output_file, recursive = FALSE)
combine_files<-function(input_dir="working_functions",
                        output_file="all_functions.R",
                        pattern="\\.[Rr]$",
                        recursive=TRUE) {
  files<-list.files(input_dir,pattern=pattern,full.names=TRUE,recursive=recursive)
  files<-files[!dir.exists(files)]
  files<-files[normalizePath(files)!=normalizePath(output_file,mustWork=FALSE)]
  contents<-lapply(files,function(f) {
    c("##########################################################################################",
      paste0("# FILE: ",f),
      "##########################################################################################",
      readLines(f,warn=FALSE,encoding="UTF-8"),
      "")
  })
  # as.character() turns NULL (no matching files) into character(0), so an empty file is written
  writeLines(as.character(unlist(contents)),output_file,useBytes=TRUE)
  cat("Combined",length(files),"files into",output_file,"\n")
  invisible(files)
}
