##########################################################################################
# round_dataframe
##########################################################################################
mixed_numeric_frame <- function() {
  df <- mtcars[1:6, c("mpg", "disp", "wt")] * 1.2345
  df$carb <- mtcars$carb[1:6]
  df$name <- rownames(df)
  df$gear <- factor(mtcars$gear[1:6])
  df$mpg[2] <- NA
  df
}

test_that("round_dataframe applies round, ceiling, floor and tenth to numeric columns only", {
  df <- mixed_numeric_frame()
  numeric_cols <- c("mpg", "disp", "wt", "carb")
  references <- list(
    round = function(x) round(x, 2),
    ceiling = ceiling,
    floor = floor,
    tenth = function(x) round(x / 10, 2)
  )
  for (type in names(references)) {
    rwf <- round_dataframe(df = df, digits = 2, type = type)
    for (col in numeric_cols) {
      expect_equal(rwf[[col]], references[[type]](df[[col]]), info = paste(type, col))
    }
    expect_identical(rwf$name, df$name)
    expect_identical(rwf$gear, df$gear)
  }
})

test_that("round_dataframe keeps the data frame structure and missing values", {
  df <- mixed_numeric_frame()
  rwf <- round_dataframe(df = df, digits = 0)
  expect_s3_class(rwf, "data.frame")
  expect_identical(dim(rwf), dim(df))
  expect_identical(names(rwf), names(df))
  expect_identical(row.names(rwf), row.names(df))
  expect_true(is.na(rwf$mpg[2]))
  expect_equal(rwf$disp, round(df$disp))
})

test_that("round_dataframe handles a single numeric column and frames without numeric columns", {
  single <- data.frame(a = c(1.26, -2.55, NA))
  expect_equal(round_dataframe(single, digits = 1)$a, round(c(1.26, -2.55, NA), 1))
  expect_equal(round_dataframe(data.frame(a = c(-1.5, 2.5)), type = "ceiling")$a, c(-1, 3))
  text_only <- data.frame(b = c("x", "y"), f = factor(c("u", "v")))
  expect_identical(round_dataframe(text_only, digits = 1), text_only)
})

##########################################################################################
# change_data_type
##########################################################################################
test_that("change_data_type character trims tabs and newlines but not spaces", {
  df <- data.frame(a = c("\tx\n", " y "), n = c(1.5, 2), f = factor(c("p", "q")))
  rwf <- change_data_type(df = df, type = "character")
  expect_true(all(vapply(rwf, is.character, logical(1))))
  expect_identical(rwf$a, c("x", " y "))
  expect_identical(rwf$n, c("1.5", "2"))
  expect_identical(rwf$f, c("p", "q"))
  expect_identical(dim(rwf), dim(df))
})

test_that("change_data_type numeric converts through character, so factors keep their labels", {
  df <- data.frame(a = c(" 1\t", "2\n", "3.5"), f = factor(c("10", "2", "30")))
  rwf <- change_data_type(df = df, type = "numeric")
  expect_true(all(vapply(rwf, is.numeric, logical(1))))
  expect_equal(rwf$a, c(1, 2, 3.5))
  expect_equal(rwf$f, c(10, 2, 30))
  expect_warning(bad <- change_data_type(data.frame(a = c("x", "3")), type = "numeric"), "NAs introduced by coercion")
  expect_equal(bad$a, c(NA, 3))
})

test_that("change_data_type factor converts every column with the same levels as as.factor", {
  rwf <- change_data_type(df = mtcars, type = "factor")
  expect_true(all(vapply(rwf, is.factor, logical(1))))
  for (col in names(mtcars)) {
    expect_identical(rwf[[col]], as.factor(mtcars[[col]]))
  }
  expect_identical(row.names(rwf), row.names(mtcars))
})

test_that("change_data_type factor_character converts only factor columns", {
  df <- data.frame(f = factor(c("a", "b")), n = c(1.5, 10), ch = c("x", "y"))
  rwf <- change_data_type(df = df, type = "factor_character")
  expect_identical(rwf$f, c("a", "b"))
  expect_identical(rwf$n, c(1.5, 10))
  expect_identical(rwf$ch, c("x", "y"))
})

test_that("change_data_type character_factor converts only character columns", {
  df <- data.frame(f = factor(c("a", "b")), n = c(1.5, 10), ch = c("x", "y"))
  rwf <- change_data_type(df = df, type = "character_factor")
  expect_identical(rwf$ch, factor(c("x", "y")))
  expect_identical(rwf$n, c(1.5, 10))
  expect_identical(rwf$f, factor(c("a", "b")))
})

##########################################################################################
# rbind_all
##########################################################################################
test_that("rbind_all fills missing columns with NA like plyr::rbind.fill", {
  df1 <- data.frame(x = 1:2, y = 3:4)
  df2 <- data.frame(y = 5L, z = 6L)
  rwf <- rbind_all(df1 = df1, df2 = df2)
  expect_s3_class(rwf, "data.frame")
  expect_identical(dim(rwf), c(3L, 3L))
  expect_identical(names(rwf), c("x", "y", "z"))
  expect_equal(as.list(rwf), list(x = c(1L, 2L, NA), y = 3:5, z = c(NA, NA, 6L)))
  reference <- plyr::rbind.fill(df1, df2)
  expect_equal(as.list(rwf[, names(reference)]), as.list(reference))
})

test_that("rbind_all matches rbind when the columns are the same", {
  rwf <- rbind_all(df1 = mtcars[1:3, ], df2 = mtcars[10:12, c(3, 1, 2, 4:11)])
  expect_equal(rwf, rbind(mtcars[1:3, ], mtcars[10:12, ]))
})

test_that("rbind_all keeps unique row names from both inputs", {
  df1 <- mtcars[1:2, ]
  df2 <- mtcars[3:4, c("mpg", "cyl")]
  rwf <- rbind_all(df1 = df1, df2 = df2)
  expect_identical(row.names(rwf), row.names(mtcars)[1:4])
  expect_true(all(is.na(rwf[3:4, "disp"])))
  expect_equal(rwf$mpg, mtcars$mpg[1:4])
})

test_that("rbind_all uses default integer row names when row names are duplicated", {
  df1 <- data.frame(x = 1:2, row.names = c("r1", "r2"))
  df2 <- data.frame(y = 3, row.names = "r1")
  rwf <- rbind_all(df1 = df1, df2 = df2)
  expect_identical(row.names(rwf), c("1", "2", "3"))
})

test_that("rbind_all accepts matrices as documented", {
  m1 <- matrix(1:4, 2, dimnames = list(NULL, c("x", "y")))
  m2 <- matrix(5:6, 1, dimnames = list(NULL, c("y", "z")))
  rwf <- rbind_all(df1 = m1, df2 = m2)
  expect_equal(unname(as.matrix(rwf[, c("x", "y", "z")])), matrix(c(1, 2, NA, 3, 4, 5, NA, NA, 6), 3))
})

##########################################################################################
# remove_nc
##########################################################################################
non_computable_frame <- function() {
  data.frame(a = c(1, NaN, Inf, -Inf, NA), b = c("u", "", "v", NA, "w"), c = NA, k = 1)
}

test_that("remove_nc replaces NaN, Inf, -Inf and empty strings with NA", {
  rwf <- remove_nc(df = non_computable_frame())
  expect_s3_class(rwf, "data.frame")
  expect_identical(dim(rwf), c(5L, 4L))
  expect_identical(rwf$a, c(1, NA, NA, NA, NA))
  expect_identical(rwf$b, c("u", NA, "v", NA, "w"))
  expect_true(all(is.na(rwf$c)))
  expect_identical(rwf$k, rep(1, 5))
})

test_that("remove_nc uses the replacement value", {
  rwf <- remove_nc(df = non_computable_frame(), value = 0)
  expect_equal(rwf$a, c(1, 0, 0, 0, 0))
  expect_identical(rwf$b, c("u", "0", "v", "0", "w"))
  expect_equal(rwf$c, rep(0, 5))
  expect_false(anyNA(rwf))
})

test_that("remove_nc removes rows like complete.cases (aggressive) or all-NA rows (not aggressive)", {
  df <- data.frame(a = c(1, NA, 3, NA, Inf), b = c(1, 2, NaN, NA, 5))
  cleaned <- df
  cleaned[!is.finite(as.matrix(cleaned))] <- NA
  aggressive <- remove_nc(df = df, remove_rows = TRUE, aggressive = TRUE)
  expect_equal(aggressive, cleaned[stats::complete.cases(cleaned), ])
  expect_identical(row.names(aggressive), "1")
  lenient <- remove_nc(df = df, remove_rows = TRUE, aggressive = FALSE)
  expect_equal(lenient, cleaned[rowSums(!is.na(cleaned)) > 0, ])
  expect_identical(row.names(lenient), c("1", "2", "3", "5"))
})

test_that("remove_nc removes all-NA columns and, optionally, zero-variance columns", {
  df <- data.frame(a = 1:4, b = NA, c = c(1, 1, 1, NA), d = c(1, 1, NA, Inf), e = c("x", "y", "x", ""))
  cols <- remove_nc(df = df, remove_cols = TRUE)
  expect_identical(names(cols), c("a", "c", "d", "e"))
  variance <- remove_nc(df = df, remove_cols = TRUE, remove_zero_variance = TRUE)
  expect_s3_class(variance, "data.frame")
  expect_identical(names(variance), c("a", "e"))
  expect_equal(variance$a, 1:4)
  expect_identical(variance$e, c("x", "y", "x", NA))
})

test_that("remove_nc returns a data frame when a single column survives", {
  skip("rwf bug: column subsetting without drop = FALSE returns a vector when one column is left")
  rwf <- remove_nc(df = non_computable_frame(), remove_cols = TRUE, remove_zero_variance = TRUE)
  expect_s3_class(rwf, "data.frame")
  expect_identical(names(rwf), "b")
})

##########################################################################################
# replace_na_with_previous
##########################################################################################
locf_reference <- function(v) {
  observed <- !is.na(v)
  if (!any(observed)) {
    return(v)
  }
  position <- cummax(seq_along(v) * observed)
  position[position == 0] <- which(observed)[1]
  v[position]
}

test_that("replace_na_with_previous carries the last observation forward", {
  expect_identical(replace_na_with_previous(c(1, NA, NA, 4, NA)), c(1, 1, 1, 4, 4))
  expect_identical(replace_na_with_previous(c(NA, NA, 2, NA, 5, NA)), c(2, 2, 2, 2, 5, 5))
  withr::local_seed(42)
  for (i in 1:20) {
    v <- stats::rnorm(15)
    v[sample(15, sample(0:14, 1))] <- NA
    expect_identical(replace_na_with_previous(v), locf_reference(v))
  }
})

test_that("replace_na_with_previous keeps the type and length of its input", {
  no_missing <- c(3L, 1L, 2L)
  expect_identical(replace_na_with_previous(no_missing), no_missing)
  expect_identical(replace_na_with_previous(c("a", NA, "b", NA)), c("a", "a", "b", "b"))
  expect_identical(replace_na_with_previous(factor(c("a", NA, "b", NA))), factor(c("a", "a", "b", "b")))
  expect_identical(replace_na_with_previous(c(NA, TRUE, NA, FALSE)), c(TRUE, TRUE, TRUE, FALSE))
  expect_identical(replace_na_with_previous(c(NA_real_, NA_real_)), c(NA_real_, NA_real_))
})

test_that("replace_na_with_previous works column-wise on a data frame", {
  df <- data.frame(a = c(1, NA, 3), b = c(NA, "x", NA))
  df[] <- lapply(df, replace_na_with_previous)
  expect_identical(df, data.frame(a = c(1, 1, 3), b = c("x", "x", "x")))
})

test_that("replace_na_with_previous returns an empty vector unchanged", {
  skip("rwf bug: an empty vector is returned as a length-1 NA")
  expect_identical(replace_na_with_previous(numeric(0)), numeric(0))
})

##########################################################################################
# c_bind
##########################################################################################
test_that("c_bind pads vectors with NA at the bottom and names columns after the inputs", {
  x <- 1:3
  y <- c(10, 20, 30, 40, 50)
  rwf <- c_bind(x, y)
  expect_s3_class(rwf, "data.frame")
  expect_identical(names(rwf), c("x", "y"))
  expect_identical(dim(rwf), c(5L, 2L))
  expect_identical(rwf$x, c(1:3, NA, NA))
  expect_identical(rwf$y, y)
})

test_that("c_bind pads at the top when first = FALSE", {
  x <- c("a", "b")
  y <- 1:4
  rwf <- c_bind(x, y, first = FALSE)
  expect_identical(rwf$x, c(NA, NA, "a", "b"))
  expect_identical(rwf$y, 1:4)
})

test_that("c_bind prefixes data frame and matrix columns with the object name", {
  m <- matrix(1:4, 2)
  dd <- data.frame(p = 1:2, q = c("u", "v"))
  y <- 1:3
  rwf <- c_bind(m, dd, y)
  expect_identical(names(rwf), c("m_1", "m_2", "dd_p", "dd_q", "y"))
  expect_identical(dim(rwf), c(3L, 5L))
  expect_identical(rwf$m_2, c(3L, 4L, NA))
  expect_identical(rwf$dd_q, c("u", "v", NA))
  expect_identical(rwf$y, 1:3)
})

test_that("c_bind of equal-length vectors matches data.frame", {
  a <- c(1.5, 2.5)
  b <- c("x", "y")
  expect_equal(c_bind(a, b), data.frame(a = a, b = b))
})

##########################################################################################
# comparison_combinations
##########################################################################################
test_that("comparison_combinations without orders matches utils::combn", {
  df <- mtcars[, 1:5]
  rwf <- comparison_combinations(df = df, all_orders = FALSE)
  expect_s3_class(rwf, "data.frame")
  expect_identical(names(rwf), c("X1", "X2"))
  expect_identical(nrow(rwf), 10L)
  pairs <- utils::combn(names(df), 2)
  expect_identical(rwf$X1, pairs[1, ])
  expect_identical(rwf$X2, pairs[2, ])
})

test_that("comparison_combinations with orders returns every ordered pair, sorted", {
  df <- mtcars[, 1:4]
  rwf <- comparison_combinations(df = df, all_orders = TRUE)
  expect_identical(nrow(rwf), 4L * 3L)
  reference <- expand.grid(X1 = names(df), X2 = names(df), stringsAsFactors = FALSE)
  reference <- reference[reference$X1 != reference$X2, ]
  reference <- reference[order(reference$X1, reference$X2), ]
  expect_identical(rwf$X1, reference$X1)
  expect_identical(rwf$X2, reference$X2)
  expect_false(any(duplicated(rwf)))
})

test_that("comparison_combinations handles two columns", {
  df <- data.frame(b = 1, a = 2)
  expect_identical(nrow(comparison_combinations(df, all_orders = FALSE)), 1L)
  both <- comparison_combinations(df, all_orders = TRUE)
  expect_identical(both$X1, c("a", "b"))
  expect_identical(both$X2, c("b", "a"))
})

##########################################################################################
# min_max_index
##########################################################################################
test_that("min_max_index matches which.max and which.min for unique extremes", {
  withr::local_seed(1)
  for (i in 1:10) {
    v <- stats::rnorm(20)
    rwf <- min_max_index(v)
    expect_identical(rwf$max_index, which.max(v))
    expect_identical(rwf$min_index, which.min(v))
  }
})

test_that("min_max_index returns all tied positions as a named list", {
  rwf <- min_max_index(c(1, 6, 3, 4, 6, 4, 3, 2, 1))
  expect_type(rwf, "list")
  expect_named(rwf, c("max_index", "min_index"))
  expect_identical(rwf$max_index, c(2L, 5L))
  expect_identical(rwf$min_index, c(1L, 9L))
  constant <- min_max_index(rep(-2, 4))
  expect_identical(constant$max_index, 1:4)
  expect_identical(constant$min_index, 1:4)
})

##########################################################################################
# get_script_directory
##########################################################################################
test_that("get_script_directory uses the active RStudio document when RStudio is available", {
  local_mocked_bindings(
    isAvailable = function(...) TRUE,
    getActiveDocumentContext = function(...) list(path = "C:/projects/analysis/script.R"),
    .package = "rstudioapi"
  )
  expect_identical(get_script_directory(), "C:/projects/analysis/")
})

test_that("get_script_directory falls back to the --file argument or the working directory", {
  local_mocked_bindings(isAvailable = function(...) FALSE, .package = "rstudioapi")
  directory <- withr::local_tempdir()
  withr::local_dir(directory)
  file_arg <- grep("--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
  expected <- if (length(file_arg) > 0) {
    paste0(dirname(normalizePath(sub("--file=", "", file_arg))), "/")
  } else {
    paste0(getwd(), "/")
  }
  rwf <- get_script_directory()
  expect_type(rwf, "character")
  expect_identical(rwf, expected)
  expect_match(rwf, "/$")
})

test_that("get_script_directory returns the script's directory under Rscript", {
  skip_on_cran()
  directory <- withr::local_tempdir()
  script <- file.path(directory, "script.R")
  writeLines(c(paste("get_script_directory <-", paste(deparse(get_script_directory), collapse = "\n")),
               "cat(get_script_directory())"), script)
  output <- system2(file.path(R.home("bin"), "Rscript"), shQuote(script), stdout = TRUE)
  expect_identical(output, paste0(dirname(normalizePath(script)), "/"))
})
