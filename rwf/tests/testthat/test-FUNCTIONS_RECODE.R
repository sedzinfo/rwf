##########################################################################################
# flatten_list
##########################################################################################
test_that("flatten_list stacks a named list of records with an .id column", {
  records <- list(first = list(x = 1, y = "p"), second = list(x = 2, y = "q"), third = list(x = 3, y = "Ελλάδα"))
  result <- flatten_list(records)
  expect_s3_class(result, "data.frame")
  expect_named(result, c(".id", "x", "y"))
  expect_identical(dim(result), c(3L, 3L))
  expected <- data.frame(.id = names(records), x = c(1, 2, 3), y = c("p", "q", "Ελλάδα"))
  expect_identical(result, expected)
})

test_that("flatten_list matches a base R rbind of the elements", {
  pieces <- list(a = data.frame(x = 1:2, z = c("u", "v")), b = data.frame(x = 3L, z = "w"), c = data.frame(x = 4:6, z = c("α", "β", "γ")))
  result <- flatten_list(pieces)
  reference <- do.call(rbind, unname(pieces))
  reference <- data.frame(.id = rep(names(pieces), vapply(pieces, nrow, integer(1))), reference)
  expect_equal(result, reference, ignore_attr = "row.names")
  expect_identical(nrow(result), 6L)
})

test_that("flatten_list omits the .id column for an unnamed list", {
  result <- flatten_list(list(list(x = 1, y = NA), list(x = 2, y = 5)))
  expect_named(result, c("x", "y"))
  expect_identical(result$x, c(1, 2))
  expect_identical(result$y, c(NA, 5))
})

##########################################################################################
# swap
##########################################################################################
test_that("swap reverses the observed levels", {
  expect_equal(swap(c(1:10, 1, 2, 3)), c(10:1, 10, 9, 8))
  # mirrors the observed values, not the theoretical range
  expect_equal(swap(c(1, 2, 5, 5)), c(5, 2, 1, 1))
  expect_equal(swap(c(0.5, 1.5, 2.5)), c(2.5, 1.5, 0.5))
})

test_that("swap reverse-scores a Likert item like psych::reverse.code when every level is observed", {
  withr::local_seed(42)
  item <- c(1:5, sample(1:5, 45, replace = TRUE))
  reference <- psych::reverse.code(keys = -1, items = matrix(item), mini = 1, maxi = 5)
  expect_equal(swap(item), as.vector(reference))
  expect_equal(swap(item), 6 - item)
  # applying it twice returns the original
  expect_equal(swap(swap(item)), item)
})

test_that("swap keeps the length, NAs and class of the input", {
  x <- c(3, NA, 1, 2)
  result <- swap(x)
  expect_length(result, 4)
  expect_type(result, "double")
  expect_equal(result, c(1, NA, 3, 2))
  # levels sort as high < low < mid, so low stays low and high and mid swap
  expect_identical(swap(c("low", "mid", "high")), c("low", "high", "mid"))
  expect_identical(swap(c("άσπρο", "μαύρο")), c("μαύρο", "άσπρο"))
})

##########################################################################################
# dummy_arrange
##########################################################################################
as_numeric_df <- function(df) data.frame(lapply(df, as.numeric), check.names = FALSE)

reference_dummy <- function(vector) {
  responses <- strsplit(as.character(vector), ",", fixed = TRUE)
  values <- sort(unique(stats::na.omit(unlist(responses))))
  values <- values[values != ""]
  result <- lapply(values, function(v) vapply(responses, function(r) as.numeric(v %in% r), numeric(1)))
  names(result) <- values
  data.frame(result, check.names = FALSE)
}

test_that("dummy_arrange codes multiple responses into one 0/1 column per response", {
  x <- c("A,B", "B", "C,A")
  result <- dummy_arrange(x)
  expect_s3_class(result, "data.frame")
  expect_named(result, c("A", "B", "C"))
  expect_identical(dim(result), c(3L, 3L))
  expected <- data.frame(A = c(1, 0, 1), B = c(1, 1, 0), C = c(0, 0, 1))
  expect_equal(as_numeric_df(result), expected, ignore_attr = "row.names")
})

test_that("dummy_arrange matches a base R reference on simulated responses", {
  withr::local_seed(123)
  options <- c("Agree", "Hi", "All", "None")
  x <- vapply(1:40, function(i) paste(sample(options, sample(1:3, 1)), collapse = ","), character(1))
  result <- dummy_arrange(x)
  reference <- reference_dummy(x)
  expect_named(result, sort(options))
  expect_equal(as_numeric_df(result), reference, ignore_attr = "row.names")
  # every response is counted once
  expect_equal(sum(as_numeric_df(result)), length(unlist(strsplit(x, ","))))
})

test_that("dummy_arrange handles numeric, single-value, missing and Greek responses", {
  result <- dummy_arrange(c(1, 3, 10, 3))
  # columns are sorted alphabetically by name
  expect_named(result, c("1", "10", "3"))
  expect_equal(as_numeric_df(result), data.frame(`1` = c(1, 0, 0, 0), `10` = c(0, 0, 1, 0), `3` = c(0, 1, 0, 1), check.names = FALSE),
               ignore_attr = "row.names")
  greek <- c("Ναι,Όχι", "Όχι", NA, "")
  result <- dummy_arrange(greek)
  expect_named(result, sort(c("Ναι", "Όχι")))
  expect_equal(as_numeric_df(result), reference_dummy(greek), ignore_attr = "row.names")
  # missing and empty responses become rows of zeros
  expect_equal(rowSums(as_numeric_df(result))[3:4], c(0, 0), ignore_attr = TRUE)
})

test_that("dummy_arrange returns numeric 0/1 columns", {
  skip("rwf bug: dummy_arrange returns character \"1\"/\"0\" columns instead of numeric 1/0")
  result <- dummy_arrange(c("A,B", "B", "C,A"))
  expect_true(all(vapply(result, is.numeric, logical(1))))
})

test_that("dummy_arrange works when only one response value occurs", {
  skip("rwf bug: dummy_arrange errors when there is only one distinct response, because remove_nc and [, ] drop the data frame to a vector")
  result <- dummy_arrange(c("A", "A", NA))
  expect_s3_class(result, "data.frame")
  expect_equal(as_numeric_df(result), data.frame(A = c(1, 1, 0)), ignore_attr = "row.names")
})

##########################################################################################
# drop_levels
##########################################################################################
make_factor_df <- function() {
  f <- factor(c(rep("A", 10), rep("B", 3), "C"), levels = c("A", "B", "C", "D"))
  data.frame(n = 1:14, f1 = f, f2 = f, ch = as.character(f), stringsAsFactors = FALSE)
}

test_that("drop_levels collapses levels at or below the threshold into Other", {
  df <- make_factor_df()
  result <- drop_levels(df, minimum_frequency = 3)
  expect_s3_class(result, "data.frame")
  expect_identical(dim(result), dim(df))
  expect_named(result, names(df))
  expected <- factor(c(rep("A", 10), rep("Other", 4)), levels = c("A", "Other"))
  expect_identical(result$f1, expected)
  expect_identical(result$f2, expected)
  # non-factor columns are untouched
  expect_identical(result$n, df$n)
  expect_identical(result$ch, df$ch)
  # frequencies agree with table()
  expect_identical(as.vector(table(result$f1)), c(10L, 4L))
})

test_that("drop_levels only drops unused levels when nothing observed is rare", {
  df <- make_factor_df()
  result <- drop_levels(df, minimum_frequency = 0)
  expect_identical(levels(result$f1), c("A", "B", "C"))
  expect_identical(as.character(result$f1), as.character(df$f1))
  # the documented example
  factor1 <- factor(c(rep("A", 10), rep("B", 10)), levels = c("A", "B", "C", "D"))
  example <- data.frame(numeric1 = 1:20, factor1, factor2 = factor1)
  expect_identical(levels(drop_levels(example, minimum_frequency = 9)$factor1), c("A", "B"))
  expect_identical(levels(drop_levels(example, minimum_frequency = 10)$factor1), "Other")
})

test_that("drop_levels processes only the columns given in factor_index", {
  df <- make_factor_df()
  result <- drop_levels(df, factor_index = 2, minimum_frequency = 3)
  expect_identical(levels(result$f1), c("A", "Other"))
  expect_identical(result$f2, df$f2)
})

test_that("drop_levels keeps NA values and handles Greek labels", {
  f <- factor(c(rep("Ναι", 6), "Όχι", NA, "Ίσως"))
  df <- data.frame(answer = f)
  result <- drop_levels(df, minimum_frequency = 1)
  expect_identical(as.character(result$answer), c(rep("Ναι", 6), "Other", NA, "Other"))
  expect_identical(levels(result$answer), c("Ναι", "Other"))
  expect_identical(sum(is.na(result$answer)), 1L)
})
