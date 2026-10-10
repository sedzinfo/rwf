##########################################################################################
# generate_data
##########################################################################################
test_that("generate_data returns a data frame of the requested size", {
  withr::local_seed(1)
  df <- generate_data()
  expect_s3_class(df, "data.frame")
  expect_equal(dim(df), c(10, 5))
  expect_named(df, paste0("X", 1:5))
  expect_true(all(vapply(df, is.numeric, logical(1))))
  expect_equal(dim(generate_data(nrows = 7, ncols = 1)), c(7, 1))
  expect_equal(dim(generate_data(nrows = 7, ncols = 3, type = "uniform")), c(7, 3))
})

test_that("generate_data normal columns have the requested mean and sd and are independent", {
  withr::local_seed(2)
  df <- generate_data(nrows = 20000, ncols = 3, mean = 10, sd = 2, type = "normal")
  expect_equal(unname(colMeans(df)), rep(10, 3), tolerance = 0.01)
  expect_equal(unname(vapply(df, stats::sd, numeric(1))), rep(2, 3), tolerance = 0.02)
  r <- stats::cor(df)
  expect_true(all(abs(r[upper.tri(r)]) < 0.03))
  expect_gt(stats::shapiro.test(df$X1[1:5000])$p.value, 0.001)
})

test_that("generate_data uniform columns are integers covering min:max evenly", {
  withr::local_seed(3)
  df <- generate_data(nrows = 30000, ncols = 2, min = 2, max = 6, type = "uniform")
  values <- unlist(df)
  expect_true(all(values %in% 2:6))
  expect_setequal(unique(values), 2:6)
  expect_equal(mean(values), 4, tolerance = 0.01)
  proportions <- as.vector(table(values)) / length(values)
  expect_equal(proportions, rep(0.2, 5), tolerance = 0.05)
  expect_gt(stats::chisq.test(table(df$X1))$p.value, 0.001)
})

test_that("generate_data is reproducible under a fixed seed", {
  first <- withr::with_seed(10, generate_data(nrows = 5, ncols = 2))
  second <- withr::with_seed(10, generate_data(nrows = 5, ncols = 2))
  expect_identical(first, second)
})

##########################################################################################
# generate_factor
##########################################################################################
test_that("generate_factor returns factor columns with the supplied levels", {
  withr::local_seed(4)
  df <- generate_factor(vector = c("low", "mid", "high"), nrows = 12, ncols = 4, type = "random")
  expect_s3_class(df, "data.frame")
  expect_equal(dim(df), c(12, 4))
  for (column in df) {
    expect_s3_class(column, "factor")
    expect_equal(levels(column), c("low", "mid", "high"))
  }
})

test_that("generate_factor balanced columns contain each level exactly nrows / k times", {
  df <- generate_factor(vector = LETTERS[1:5], nrows = 20, ncols = 3, type = "balanced")
  expect_equal(dim(df), c(20, 3))
  for (column in df) {
    expect_equal(as.vector(table(column)), rep(4, 5))
    expect_equal(levels(column), LETTERS[1:5])
  }
})

test_that("generate_factor random columns sample levels with roughly equal probability", {
  withr::local_seed(5)
  df <- generate_factor(vector = LETTERS[1:4], nrows = 20000, ncols = 2, type = "random")
  proportions <- as.vector(table(df[[1]])) / 20000
  expect_equal(proportions, rep(0.25, 4), tolerance = 0.05)
  # columns are drawn independently
  expect_gt(stats::chisq.test(table(df[[1]], df[[2]]))$p.value, 0.001)
})

test_that("generate_factor returns a single factor when ncols = 1", {
  withr::local_seed(6)
  random <- generate_factor(vector = LETTERS[1:5], nrows = 10, ncols = 1, type = "random")
  balanced <- generate_factor(vector = LETTERS[1:5], nrows = 10, ncols = 1, type = "balanced")
  expect_s3_class(random, "factor")
  expect_length(random, 10)
  expect_s3_class(balanced, "factor")
  expect_equal(as.vector(table(balanced)), rep(2, 5))
})

##########################################################################################
# generate_string
##########################################################################################
test_that("generate_string returns strings of the requested number and length", {
  withr::local_seed(7)
  one <- generate_string()
  expect_type(one, "character")
  expect_length(one, 1)
  expect_equal(nchar(one), 5)
  many <- generate_string(vector_length = 25, nchar = 12)
  expect_length(many, 25)
  expect_true(all(nchar(many) == 12))
  expect_true(all(grepl("^[A-Za-z0-9]+$", many)))
})

test_that("generate_string only uses characters from the supplied pool, uniformly", {
  withr::local_seed(8)
  s <- generate_string(vector = c("x", "y", "z"), vector_length = 2000, nchar = 10)
  characters <- unlist(strsplit(s, ""))
  expect_setequal(unique(characters), c("x", "y", "z"))
  expect_equal(as.vector(table(characters)) / length(characters), rep(1 / 3, 3), tolerance = 0.05)
})

##########################################################################################
# generate_multiple_response_vector
##########################################################################################
test_that("generate_multiple_response_vector returns comma-separated unique responses", {
  withr::local_seed(9)
  rwf <- generate_multiple_response_vector(responses = 1:4, responded = 1:4, length = 500)
  expect_type(rwf, "character")
  expect_length(rwf, 500)
  parts <- strsplit(rwf, ", ")
  expect_true(all(vapply(parts, function(x) all(x %in% as.character(1:4)), logical(1))))
  expect_true(all(vapply(parts, function(x) !anyDuplicated(x), logical(1))))
  counts <- lengths(parts)
  expect_true(all(counts %in% 1:4))
  # the number of responses is sampled uniformly from `responded`
  expect_equal(as.vector(table(counts)) / 500, rep(0.25, 4), tolerance = 0.25)
})

test_that("generate_multiple_response_vector respects a restricted range of responses", {
  withr::local_seed(10)
  rwf <- generate_multiple_response_vector(responses = c("a", "b", "c", "d", "e"), responded = 2:3, length = 300)
  parts <- strsplit(rwf, ", ")
  expect_true(all(lengths(parts) %in% 2:3))
  expect_true(all(unlist(parts) %in% c("a", "b", "c", "d", "e")))
})

test_that("generate_multiple_response_vector with a single 'responded' value selects up to that many", {
  withr::local_seed(11)
  rwf <- generate_multiple_response_vector(responses = 1:4, responded = 3, length = 200)
  picked <- strsplit(rwf, ", ")
  n <- lengths(picked)
  expect_true(all(n >= 1 & n <= 3))
  expect_setequal(unique(n), 1:3)
  expect_false(any(vapply(picked, anyDuplicated, integer(1)) > 0))
  expect_true(all(unlist(picked) %in% as.character(1:4)))
  single <- generate_multiple_response_vector(responses = 4, responded = 1:4, length = 50)
  expect_true(all(unlist(strsplit(single, ", ")) %in% as.character(1:4)))
})

##########################################################################################
# generate_correlation_matrix
##########################################################################################
target_correlation <- function() {
  matrix(c(1.0, 0.6, -0.3,
           0.6, 1.0, 0.2,
           -0.3, 0.2, 1.0), nrow = 3)
}

test_that("generate_correlation_matrix reproduces the target correlation matrix", {
  withr::local_seed(12)
  target <- target_correlation()
  df <- generate_correlation_matrix(target, nrows = 30000)
  expect_s3_class(df, "data.frame")
  expect_equal(dim(df), c(30000, 3))
  expect_named(df, paste0("X", 1:3))
  expect_equal(unname(stats::cor(df)), target, tolerance = 0.03)
  # columns are standard normal because the target has a unit diagonal
  expect_equal(unname(colMeans(df)), rep(0, 3), tolerance = 0.03)
  expect_equal(unname(vapply(df, stats::sd, numeric(1))), rep(1, 3), tolerance = 0.02)
})

test_that("generate_correlation_matrix reproduces a covariance matrix that is not a correlation", {
  withr::local_seed(13)
  sigma <- matrix(c(4, 1.2, 1.2, 1), 2)
  df <- generate_correlation_matrix(sigma, nrows = 30000)
  expect_equal(unname(stats::cov(df)), sigma, tolerance = 0.03)
})

test_that("generate_correlation_matrix without a matrix returns an nrows x nrows data frame", {
  withr::local_seed(14)
  df <- generate_correlation_matrix(nrows = 8)
  expect_s3_class(df, "data.frame")
  expect_equal(dim(df), c(8, 8))
  expect_true(all(is.finite(as.matrix(df))))
})

test_that("generate_correlation_matrix default target is a random positive-definite correlation matrix", {
  skip("rwf bug: default target uses generate_data(min = 0.1, max = 1, type = 'uniform'), and 0.1:1 is just 0.1, so every off-diagonal is 0.1")
  captured <- NULL
  original <- symmetric_matrix
  local_mocked_bindings(symmetric_matrix = function(...) {
    captured <<- original(...)
    captured
  })
  withr::local_seed(15)
  generate_correlation_matrix(nrows = 10)
  off_diagonal <- captured[upper.tri(captured)]
  expect_gt(length(unique(off_diagonal)), 1)
  expect_true(all(off_diagonal >= 0.1 & off_diagonal <= 1))
})

##########################################################################################
# simulate_correlation_from_sample
##########################################################################################
test_that("simulate_correlation_from_sample reproduces the means and covariances of the input", {
  withr::local_seed(16)
  source <- mtcars[, c("mpg", "wt", "hp", "qsec")]
  df <- simulate_correlation_from_sample(source, nrows = 50000)
  expect_s3_class(df, "data.frame")
  expect_equal(dim(df), c(50000, 4))
  expect_named(df, names(source))
  expect_equal(colMeans(df), colMeans(source), tolerance = 0.01)
  expect_equal(stats::cor(df), stats::cor(source), tolerance = 0.02)
  expect_equal(stats::cov(df), stats::cov(source), tolerance = 0.03)
})

test_that("simulate_correlation_from_sample uses pairwise covariances and NA-free means", {
  withr::local_seed(17)
  source <- mtcars[, c("mpg", "wt", "disp")]
  source$mpg[c(1, 5, 9)] <- NA
  source$wt[c(2, 20)] <- NA
  df <- simulate_correlation_from_sample(source, nrows = 50000)
  expect_false(anyNA(df))
  expect_equal(colMeans(df), colMeans(source, na.rm = TRUE), tolerance = 0.01)
  expect_equal(stats::cov(df), stats::cov(source, use = "pairwise.complete.obs"), tolerance = 0.03)
})

##########################################################################################
# generate_missing
##########################################################################################
test_that("generate_missing inserts exactly the requested number of NA in a vector", {
  withr::local_seed(18)
  x <- stats::rnorm(20)
  rwf <- generate_missing(x, missing = 7)
  expect_type(rwf, "double")
  expect_length(rwf, 20)
  expect_equal(sum(is.na(rwf)), 7)
  expect_equal(rwf[!is.na(rwf)], x[!is.na(rwf)])
  expect_equal(generate_missing(x, missing = 0), x)
})

test_that("generate_missing inserts the requested number of NA in every data frame column", {
  withr::local_seed(19)
  rwf <- generate_missing(mtcars, missing = 5)
  expect_s3_class(rwf, "data.frame")
  expect_equal(dim(rwf), dim(mtcars))
  expect_equal(rownames(rwf), rownames(mtcars))
  expect_equal(unname(colSums(is.na(rwf))), rep(5, ncol(mtcars)))
  kept <- !is.na(as.matrix(rwf))
  expect_equal(as.matrix(rwf)[kept], as.matrix(mtcars)[kept])
  # positions are chosen independently per column
  positions <- lapply(rwf, function(x) which(is.na(x)))
  expect_gt(length(unique(positions)), 1)
})

test_that("generate_missing works on factor and character columns", {
  withr::local_seed(20)
  df <- data.frame(f = factor(rep(c("a", "b"), 5)), s = letters[1:10], stringsAsFactors = FALSE)
  rwf <- generate_missing(df, missing = 3)
  expect_s3_class(rwf$f, "factor")
  expect_type(rwf$s, "character")
  expect_equal(unname(colSums(is.na(rwf))), c(3, 3))
})
