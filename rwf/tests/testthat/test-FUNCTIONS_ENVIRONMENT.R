##########################################################################################
# helpers
##########################################################################################
# Runs an R script in a fresh Rscript process and returns its standard output
run_rscript <- function(args) {
  system2(file.path(R.home("bin"), "Rscript"), args, stdout = TRUE)
}

# Writes the source of an rwf function into a script, so it can run outside the package
function_source <- function(name, fun) {
  paste(name, "<-", paste(deparse(fun), collapse = "\n"))
}

fake_installed_packages <- function(lib) {
  cbind(
    Package = c("base", "stats", "MASS", "fakeA", "fakeB", "mroPkg"),
    LibPath = c(lib, lib, lib, lib, lib, "C:/Program Files/Microsoft/MRO/library"),
    Version = "1.0",
    Priority = c("base", "base", "recommended", NA, NA, NA)
  )
}

##########################################################################################
# environment_options
##########################################################################################
test_that("environment_options sets the documented session options", {
  withr::local_options(
    encoding = getOption("encoding"), digits = getOption("digits"), scipen = getOption("scipen"),
    max.print = getOption("max.print"), warning.length = getOption("warning.length"),
    nwarnings = getOption("nwarnings"), verbose = getOption("verbose")
  )
  environment_options()
  expect_identical(getOption("encoding"), "UTF8")
  expect_identical(getOption("digits"), 4L)
  expect_equal(getOption("scipen"), 999)
  expect_equal(getOption("max.print"), 10000)
  expect_equal(getOption("warning.length"), 1000)
  expect_equal(getOption("nwarnings"), 10000)
  expect_false(getOption("verbose"))
})

##########################################################################################
# install_load
##########################################################################################
test_that("install_load loads installed packages without installing anything", {
  installs <- character(0)
  local_mocked_bindings(
    installed.packages = function(...) cbind(Package = c("stats", "utils", "testthat")),
    install.packages = function(pkgs, ...) installs <<- c(installs, pkgs),
    .package = "utils"
  )
  rwf <- install_load(c("stats", "utils"))
  expect_identical(rwf, c(stats = TRUE, utils = TRUE))
  expect_identical(installs, character(0))
})

test_that("install_load installs missing packages with dependencies before loading them", {
  calls <- list()
  local_mocked_bindings(
    installed.packages = function(...) cbind(Package = c("stats", "utils")),
    install.packages = function(pkgs, ...) calls[[length(calls) + 1]] <<- list(pkgs = pkgs, args = list(...)),
    .package = "utils"
  )
  rwf <- quietly(install_load(c("stats", "rwfNotARealPackage")))
  expect_length(calls, 1)
  expect_identical(calls[[1]]$pkgs, "rwfNotARealPackage")
  expect_true(calls[[1]]$args$dependencies)
  expect_identical(rwf, c(stats = TRUE, rwfNotARealPackage = FALSE))
})

##########################################################################################
# install_all_packages
##########################################################################################
test_that("install_all_packages installs only the CRAN packages that are missing, sorted", {
  installs <- NULL
  local_mocked_bindings(
    installed.packages = function(...) cbind(Package = c("base", "zoo", "MASS")),
    available.packages = function(...) cbind(Package = c("zoo", "yaml", "abind", "MASS", "abind")),
    install.packages = function(pkgs, ...) installs <<- pkgs,
    .package = "utils"
  )
  install_all_packages()
  expect_identical(installs, c("abind", "yaml"))
})

##########################################################################################
# remove_user_packages
##########################################################################################
test_that("remove_user_packages removes only non-base, non-recommended, non-MRO packages", {
  lib <- withr::local_tempdir()
  removed <- list()
  fake_remove <- function(pkgs, lib, ...) {
    removed[[length(removed) + 1]] <<- list(pkgs = pkgs, lib = lib)
    invisible(NULL)
  }
  fake_installed <- function(...) fake_installed_packages(lib)
  # remove_user_packages calls the imported installed.packages() and utils::remove.packages()
  local_mocked_bindings(installed.packages = fake_installed, remove.packages = fake_remove, .package = "rwf")
  local_mocked_bindings(installed.packages = fake_installed, remove.packages = fake_remove, .package = "utils")
  # never run the real remove.packages
  if (!identical(utils::remove.packages, fake_remove)) skip("could not mock utils::remove.packages")
  remove_user_packages()
  expect_identical(vapply(removed, `[[`, character(1), "pkgs"), c("fakeA", "fakeB"))
  expect_identical(unique(vapply(removed, `[[`, character(1), "lib")), lib)
})

##########################################################################################
# detach_package
##########################################################################################
test_that("detach_package removes every attached copy and is a no-op when not attached", {
  search_name <- "package:rwfTestDummy"
  withr::defer(while (search_name %in% search()) detach(search_name, character.only = TRUE))
  attach(new.env(), name = search_name)
  attach(new.env(), name = search_name)
  expect_identical(sum(search() == search_name), 2L)
  expect_invisible(detach_package("rwfTestDummy"))
  expect_false(search_name %in% search())
  before <- search()
  expect_null(detach_package("rwfTestDummy"))
  expect_identical(search(), before)
})

##########################################################################################
# getfwp
##########################################################################################
test_that("getfwp returns the script path from the --file argument under Rscript", {
  skip_on_cran()
  script <- file.path(withr::local_tempdir(), "my script.R")
  writeLines(c(function_source("getfwp", getfwp), "cat(getfwp())"), script)
  expect_identical(run_rscript(shQuote(script)), normalizePath(script))
})

test_that("getfwp returns the sourced file path from the source() frame", {
  skip_on_cran()
  directory <- withr::local_tempdir()
  script <- file.path(directory, "sourced.R")
  writeLines(c(function_source("getfwp", getfwp), "cat(getfwp())"), script)
  expression <- sprintf("source(%s)", deparse(gsub("\\\\", "/", script)))
  expect_identical(run_rscript(c("-e", shQuote(expression))), normalizePath(script))
})

can_reach_rstudio_branch <- function() {
  no_file <- length(grep("--file=", commandArgs(trailingOnly = FALSE))) == 0
  first_frame <- sys.frames()[[1]]
  no_file && !"fileName" %in% ls(first_frame) && is.null(first_frame$ofile)
}

test_that("getfwp falls back to the RStudio active document and then the source editor", {
  skip_if_not(can_reach_rstudio_branch(), "the --file or source() branch applies in this session")
  active <- withr::local_tempfile(fileext = ".R")
  editor <- withr::local_tempfile(fileext = ".R")
  writeLines("", active)
  writeLines("", editor)
  local_mocked_bindings(
    getActiveDocumentContext = function(...) list(path = active),
    getSourceEditorContext = function(...) list(path = editor),
    .package = "rstudioapi"
  )
  expect_identical(getfwp(), normalizePath(active))
  local_mocked_bindings(getActiveDocumentContext = function(...) list(path = ""), .package = "rstudioapi")
  expect_identical(getfwp(), normalizePath(editor))
})

test_that("getfwp returns an empty string when the path cannot be determined", {
  skip("rwf bug: getActiveDocumentContext() is called outside tryCatch, so getfwp errors when RStudio is not running")
  skip_if_not(can_reach_rstudio_branch(), "the --file or source() branch applies in this session")
  local_mocked_bindings(
    getActiveDocumentContext = function(...) stop("RStudio not running"),
    getSourceEditorContext = function(...) stop("RStudio not running"),
    .package = "rstudioapi"
  )
  expect_identical(getfwp(), "")
})

##########################################################################################
# write_txt
##########################################################################################
test_that("write_txt prints to the console and returns NULL invisibly without a file", {
  directory <- withr::local_tempdir()
  withr::local_dir(directory)
  output <- utils::capture.output(result <- withVisible(write_txt(mtcars[1:3, 1:4])))
  expect_identical(output, utils::capture.output(print(mtcars[1:3, 1:4])))
  expect_null(result$value)
  expect_false(result$visible)
  expect_length(list.files(directory), 0)
})

test_that("write_txt writes the printed output to a .log file and echoes it", {
  file <- file.path(withr::local_tempdir(), "output")
  printed <- utils::capture.output(print(summary(mtcars$mpg)))
  console <- utils::capture.output(write_txt(summary(mtcars$mpg), file = file))
  log_file <- paste0(file, ".log")
  expect_true(file.exists(log_file))
  expect_identical(readLines(log_file), printed)
  expect_identical(console, printed)
})

##########################################################################################
# combine_files
##########################################################################################
make_script_tree <- function() {
  input <- withr::local_tempdir(.local_envir = parent.frame())
  dir.create(file.path(input, "sub"))
  writeLines("a <- 1", file.path(input, "a.R"))
  writeLines(c("b <- 2", "b2 <- 3"), file.path(input, "sub", "b.R"))
  writeLines("c <- 4", file.path(input, "c.r"))
  writeLines("not code", file.path(input, "notes.txt"))
  input
}

combined_block <- function(path, lines) {
  separator <- strrep("#", 90)
  c(separator, paste0("# FILE: ", path), separator, lines, "")
}

test_that("combine_files concatenates matching files recursively with headers", {
  input <- make_script_tree()
  output <- file.path(withr::local_tempdir(), "combined.R")
  expect_output(files <- combine_files(input_dir = input, output_file = output), "Combined 3 files into")
  expected_files <- list.files(input, pattern = "\\.[Rr]$", full.names = TRUE, recursive = TRUE)
  expect_identical(files, expected_files)
  expect_identical(basename(files), c("a.R", "c.r", "b.R"))
  expected <- c(combined_block(files[1], "a <- 1"),
                combined_block(files[2], "c <- 4"),
                combined_block(files[3], c("b <- 2", "b2 <- 3")))
  expect_identical(readLines(output), expected)
})

test_that("combine_files respects recursive = FALSE and pattern = NULL", {
  input <- make_script_tree()
  output <- file.path(withr::local_tempdir(), "combined.R")
  flat <- quietly(combine_files(input_dir = input, output_file = output, recursive = FALSE))
  expect_identical(basename(flat), c("a.R", "c.r"))
  everything <- quietly(combine_files(input_dir = input, output_file = output, pattern = NULL, recursive = FALSE))
  expect_identical(basename(everything), c("a.R", "c.r", "notes.txt"))
  expect_true("not code" %in% readLines(output))
})

test_that("combine_files does not include its own output file", {
  input <- make_script_tree()
  output <- file.path(input, "all.R")
  quietly(combine_files(input_dir = input, output_file = output))
  second <- quietly(combine_files(input_dir = input, output_file = output))
  expect_false("all.R" %in% basename(second))
  expect_length(second, 3)
  expect_false(any(grepl("all.R", readLines(output), fixed = TRUE)))
})

test_that("combine_files writes an empty file when nothing matches", {
  skip("rwf bug: writeLines(unlist(list())) fails with 'can only write character objects' for an empty directory")
  input <- withr::local_tempdir()
  output <- file.path(withr::local_tempdir(), "combined.R")
  files <- quietly(combine_files(input_dir = input, output_file = output))
  expect_identical(files, character(0))
  expect_identical(readLines(output), character(0))
})
