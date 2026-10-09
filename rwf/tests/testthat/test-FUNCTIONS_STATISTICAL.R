##########################################################################################
# compute_adjustment
##########################################################################################
test_that("compute_adjustment returns the Bonferroni and Sidak thresholds", {
  for (k in c(1, 2, 5, 20, 100)) {
    for (a in c(0.01, 0.05, 0.10)) {
      rwf <- compute_adjustment(a, k)
      expect_type(rwf, "list")
      expect_named(rwf, c("sidak", "bonferroni"))
      expect_equal(rwf$bonferroni, a / k)
      expect_equal(rwf$sidak, 1 - (1 - a)^(1 / k))
    }
  }
})

test_that("compute_adjustment thresholds keep the family-wise error rate at alpha", {
  a <- 0.05
  k <- 12
  rwf <- compute_adjustment(a, k)
  # Sidak is exact for k independent tests
  expect_equal(1 - (1 - rwf$sidak)^k, a)
  # A p-value at the Bonferroni threshold adjusts back to alpha with stats::p.adjust
  expect_equal(stats::p.adjust(rep(rwf$bonferroni, k), method = "bonferroni")[1], a)
  # Sidak is always slightly less conservative than Bonferroni
  expect_gt(rwf$sidak, rwf$bonferroni)
  # A single test needs no adjustment
  expect_equal(compute_adjustment(a, 1), list(sidak = a, bonferroni = a))
})

##########################################################################################
# compute_standard
##########################################################################################
standard_vector <- function() {
  withr::with_seed(11, c(stats::rnorm(15, mean = 20, sd = 4), NA, stats::rnorm(14, mean = 20, sd = 4)))
}

test_that("compute_standard z-scores match base::scale and handle NA", {
  x <- standard_vector()
  z <- compute_standard(x, type = "z")
  expect_equal(z, as.vector(scale(x)))
  expect_length(z, length(x))
  expect_true(is.na(z[16]))
  expect_equal(mean(z, na.rm = TRUE), 0)
  expect_equal(stats::sd(z, na.rm = TRUE), 1)
})

test_that("compute_standard derived scores follow their textbook definitions", {
  x <- standard_vector()
  z <- as.vector(scale(x))
  expect_equal(compute_standard(x, type = "t"), 50 + 10 * z)
  sten <- pmin(pmax(round(2 * z + 5.5), 1), 10)
  expect_equal(compute_standard(x, type = "sten"), sten)
  stanine <- round(pmin(pmax(2 * z + 5, 1), 9))
  expect_equal(compute_standard(x, type = "stanine"), stanine)
  expect_equal(compute_standard(x, type = "center"), x - mean(x, na.rm = TRUE))
  expect_equal(compute_standard(x, type = "center_reversed"), mean(x, na.rm = TRUE) - x)
  expect_equal(compute_standard(x, type = "percent"), 100 * x / max(x, na.rm = TRUE))
  expect_equal(compute_standard(x, type = "percentile"), 100 * stats::pnorm(z))
  rng <- range(x, na.rm = TRUE)
  expect_equal(compute_standard(x, type = "scale_zero_one"), (x - rng[1]) / (rng[2] - rng[1]))
  expect_equal(range(compute_standard(x, type = "scale_zero_one"), na.rm = TRUE), c(0, 1))
  expect_equal(compute_standard(x, type = "cumulative_density"), cumsum(x))
})

test_that("compute_standard sten and stanine scores stay within their bounds", {
  x <- c(-100, seq(-3, 3, by = 0.25), 100)
  sten <- compute_standard(x, type = "sten", input = "standard")
  stanine <- compute_standard(x, type = "stanine", input = "standard")
  expect_true(all(sten >= 1 & sten <= 10))
  expect_true(all(stanine >= 1 & stanine <= 9))
  expect_equal(sten[c(1, length(x))], c(1, 10))
  expect_equal(stanine[c(1, length(x))], c(1, 9))
  expect_true(all(sten == round(sten)))
  expect_true(all(stanine == round(stanine)))
})

test_that("compute_standard with input = 'standard' treats the vector as z-scores", {
  z <- c(-2, -1, 0, 1, 2)
  expect_equal(compute_standard(z, type = "z", input = "standard"), z)
  expect_equal(compute_standard(z, type = "t", input = "standard"), c(30, 40, 50, 60, 70))
  expect_equal(compute_standard(z, type = "percentile", input = "standard"), 100 * stats::pnorm(z))
})

test_that("compute_standard 'uz' inverts a z transformation with the supplied mean and sd", {
  x <- standard_vector()
  m <- mean(x, na.rm = TRUE)
  s <- stats::sd(x, na.rm = TRUE)
  z <- compute_standard(x, type = "z")
  expect_equal(compute_standard(z, mean = m, sd = s, type = "uz"), x)
  expect_equal(compute_standard(c(-1, 0, 1), mean = 100, sd = 15, type = "uz"), c(85, 100, 115))
})

test_that("compute_standard 'normal_density' matches stats::dnorm", {
  x <- seq(-4, 4, by = 0.1)
  expect_equal(compute_standard(x, type = "normal_density"), stats::dnorm(x))
  expect_equal(compute_standard(x, mean = 1, sd = 2, type = "normal_density"), stats::dnorm(x, mean = 1, sd = 2))
})

test_that("compute_standard 'all' returns every score type sorted by z", {
  x <- standard_vector()
  rwf <- compute_standard(x, type = "all")
  expect_s3_class(rwf, "data.frame")
  expect_named(rwf, c("score", "z", "sten", "t", "stanine", "percent", "percentile", "scale_0_1"))
  expect_equal(nrow(rwf), length(x))
  expect_false(is.unsorted(rwf$z, na.rm = TRUE))
  expect_true(is.na(rwf$z[nrow(rwf)]))
  ordered <- order(as.vector(scale(x)))
  expect_equal(rwf$score, x[ordered])
  expect_equal(rwf$t, compute_standard(x, type = "t")[ordered])
  expect_equal(rwf$scale_0_1, compute_standard(x, type = "scale_zero_one")[ordered])

  standard <- compute_standard(seq(-3, 3, by = 0.5), type = "all", input = "standard")
  expect_equal(standard$z, standard$score)
})

##########################################################################################
# compute_dissatenuation
##########################################################################################
test_that("compute_dissatenuation matches the correction for attenuation formula", {
  withr::local_seed(5)
  v1 <- stats::rnorm(50)
  e1 <- stats::rnorm(50, sd = 0.5)
  v2 <- 0.5 * v1 + stats::rnorm(50)
  e2 <- stats::rnorm(50, sd = 0.7)
  r_obs <- stats::cor(v1 + e1, v2 + e2)
  r1 <- stats::var(v1) / (stats::var(v1) + stats::var(e1))
  r2 <- stats::var(v2) / (stats::var(v2) + stats::var(e2))
  rwf <- compute_dissatenuation(v1, e1, v2, e2)
  expect_type(rwf, "double")
  expect_length(rwf, 1)
  expect_equal(rwf, r_obs / sqrt(r1 * r2))
  # psych::correct.cor returns the corrected correlation above the diagonal
  rmat <- matrix(c(r1, r_obs, r_obs, r2), 2)
  expect_equal(rwf, psych::correct.cor(rmat, c(r1, r2))[1, 2])
})

test_that("compute_dissatenuation recovers the true-score correlation in large samples", {
  withr::local_seed(7)
  n <- 100000
  true <- MASS::mvrnorm(n, mu = c(0, 0), Sigma = matrix(c(1, 0.6, 0.6, 1), 2))
  e1 <- stats::rnorm(n)
  e2 <- stats::rnorm(n, sd = 0.8)
  observed <- stats::cor(true[, 1] + e1, true[, 2] + e2)
  rwf <- compute_dissatenuation(true[, 1], e1, true[, 2], e2)
  expect_lt(observed, 0.4)
  expect_equal(rwf, 0.6, tolerance = 0.03)
})

test_that("compute_dissatenuation equals the observed correlation when there is no error", {
  withr::local_seed(8)
  v1 <- stats::rnorm(30)
  v2 <- v1 + stats::rnorm(30)
  zero <- rep(0, 30)
  expect_equal(compute_dissatenuation(v1, zero, v2, zero), stats::cor(v1, v2))
})

##########################################################################################
# compute_skewness / compute_kurtosis
##########################################################################################
test_that("compute_skewness equals the b1 = m3 / s^3 estimator", {
  vectors <- list(mtcars$mpg, mtcars$hp, PlantGrowth$weight, precip, c(1, 2, 3, 10, 50))
  for (x in vectors) {
    n <- length(x)
    m3 <- mean((x - mean(x))^3)
    expect_equal(compute_skewness(x), m3 / stats::sd(x)^3)
    expect_equal(compute_skewness(x), psych::skew(x, type = 3))
  }
})

test_that("compute_skewness matches e1071::skewness type 3 (b1)", {
  skip_if_not_installed("e1071")
  for (x in list(mtcars$mpg, mtcars$hp, precip)) {
    expect_equal(compute_skewness(x), e1071::skewness(x, type = 3))
  }
})

test_that("compute_skewness removes NA, is zero for symmetric data and changes sign on reflection", {
  x <- c(mtcars$hp, NA, NA)
  expect_equal(compute_skewness(x), compute_skewness(mtcars$hp))
  expect_equal(compute_skewness(c(1, 2, 3, 4, 5)), 0)
  expect_equal(compute_skewness(-mtcars$hp), -compute_skewness(mtcars$hp))
  expect_gt(compute_skewness(mtcars$hp), 0)
})

test_that("compute_kurtosis equals the b2 = m4 / s^4 - 3 estimator", {
  vectors <- list(mtcars$mpg, mtcars$hp, PlantGrowth$weight, precip, c(1, 2, 3, 10, 50))
  for (x in vectors) {
    m4 <- mean((x - mean(x))^4)
    expect_equal(compute_kurtosis(x), m4 / stats::sd(x)^4 - 3)
    expect_equal(compute_kurtosis(x), psych::kurtosi(x, type = 3))
  }
})

test_that("compute_kurtosis matches e1071::kurtosis type 3 (b2)", {
  skip_if_not_installed("e1071")
  for (x in list(mtcars$mpg, mtcars$hp, precip)) {
    expect_equal(compute_kurtosis(x), e1071::kurtosis(x, type = 3))
  }
})

test_that("compute_kurtosis removes NA and is near zero for large normal samples", {
  expect_equal(compute_kurtosis(c(mtcars$mpg, NA)), compute_kurtosis(mtcars$mpg))
  withr::local_seed(3)
  x <- stats::rnorm(200000)
  expect_equal(compute_kurtosis(x), 0, tolerance = 0.05)
  expect_equal(compute_skewness(x), 0, tolerance = 0.05)
  # uniform excess kurtosis is -1.2
  expect_equal(compute_kurtosis(stats::runif(200000)), -1.2, tolerance = 0.02)
})

##########################################################################################
# compute_standard_error / compute_confidence_inteval
##########################################################################################
test_that("compute_standard_error equals sd / sqrt(n) and matches psych::describe", {
  for (x in list(mtcars$mpg, PlantGrowth$weight, precip)) {
    expect_equal(compute_standard_error(x), stats::sd(x) / sqrt(length(x)))
    expect_equal(compute_standard_error(x), psych::describe(x)$se)
  }
})

test_that("compute_standard_error ignores missing values", {
  x <- c(mtcars$mpg, NA, NA, NA)
  expect_equal(compute_standard_error(x), stats::sd(mtcars$mpg) / sqrt(32))
  expect_length(compute_standard_error(x), 1)
})

test_that("compute_confidence_inteval returns the 95% normal-theory half-width", {
  for (x in list(mtcars$mpg, PlantGrowth$weight, precip)) {
    half <- stats::qnorm(0.975) * stats::sd(x) / sqrt(length(x))
    expect_equal(compute_confidence_inteval(x), half)
    expect_equal(compute_confidence_inteval(x), stats::qnorm(0.975) * compute_standard_error(x))
  }
  expect_equal(compute_confidence_inteval(c(mtcars$mpg, NA)), compute_confidence_inteval(mtcars$mpg))
})

test_that("compute_confidence_inteval converges to the t-test interval in large samples", {
  withr::local_seed(4)
  x <- stats::rnorm(5000, mean = 10, sd = 3)
  ci <- stats::t.test(x)$conf.int
  expect_equal(compute_confidence_inteval(x), unname(diff(ci) / 2), tolerance = 1e-3)
})
