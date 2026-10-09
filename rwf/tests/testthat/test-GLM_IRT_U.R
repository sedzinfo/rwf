##########################################################################################
# helpers
##########################################################################################
# A mirt model whose 4PL item parameters are fixed to known values (no estimation).
# The rwf parameterisation P = g + (i - g) / (1 + exp(-D a (theta - b))) maps to the
# mirt slope-intercept form with a1 = D a and d = -D a b.
fixed_mirt_4pl <- function(a, b, g = rep(0, length(a)), u = rep(1, length(a)), D = 1) {
  withr::local_seed(1)
  dat <- as.data.frame(matrix(stats::rbinom(100 * length(a), 1, 0.5), 100, length(a)))
  sv <- mirt::mirt(dat, 1, itemtype = "4PL", pars = "values")
  for (j in seq_along(a)) {
    item <- names(dat)[j]
    sv$value[sv$item == item & sv$name == "a1"] <- D * a[j]
    sv$value[sv$item == item & sv$name == "d"] <- -D * a[j] * b[j]
    sv$value[sv$item == item & sv$name == "g"] <- g[j]
    sv$value[sv$item == item & sv$name == "u"] <- u[j]
  }
  sv$est <- FALSE
  mirt::mirt(dat, 1, itemtype = "4PL", pars = sv, verbose = FALSE)
}

# Independent 3PL log-likelihood used as the reference for the ability estimates
loglik_3pl <- function(theta, a, b, g, d, u) {
  p <- g + (1 - g) / (1 + exp(-d * a * (theta - b)))
  sum(u * log(p) + (1 - u) * log(1 - p))
}

mle_reference <- function(a, b, g, d, u) {
  stats::optimize(loglik_3pl, c(-6, 6), a = a, b = b, g = g, d = d, u = u,
                  maximum = TRUE, tol = 1e-12)$maximum
}

numeric_derivative <- function(f, x, h = 1e-5) (f(x + h) - f(x - h)) / (2 * h)

##########################################################################################
# compute_unidimensional_theta
##########################################################################################
test_that("compute_unidimensional_theta matches mirt::probtrace for the 4PL model", {
  a <- c(1.2, 0.7, 2); b <- c(0.5, -1, 1.5); g <- c(0.2, 0, 0.1); u <- c(0.9, 1, 0.95)
  D <- 1.702
  model <- fixed_mirt_4pl(a, b, g, u, D = D)
  theta <- seq(-4, 4, by = 0.25)
  for (j in seq_along(a)) {
    mirt_p <- mirt::probtrace(mirt::extract.item(model, j), Theta = theta)[, 2]
    expect_equal(compute_unidimensional_theta(a = a[j], b = b[j], g = g[j], i = u[j], d = D, theta = theta),
                 mirt_p)
  }
})

test_that("compute_unidimensional_theta reduces to the logistic 2PL and Rasch curves", {
  theta <- seq(-3, 3, by = 0.1)
  expect_equal(compute_unidimensional_theta(a = 1.3, b = 0.4, theta = theta),
               stats::plogis(1.702 * 1.3 * (theta - 0.4)))
  expect_equal(compute_unidimensional_theta(a = 1, b = -1, d = 1, theta = theta),
               stats::plogis(theta + 1))
  expect_equal(compute_unidimensional_theta(a = 0.8, b = 0, g = 0.25, d = 1.7, theta = theta),
               0.25 + 0.75 * stats::plogis(1.7 * 0.8 * theta))
})

test_that("compute_unidimensional_theta has the documented asymptotes and midpoint", {
  # at theta = b the curve is half way between the guessing and inattentiveness asymptotes
  expect_equal(compute_unidimensional_theta(a = 2, b = 1, g = 0.2, i = 0.9, theta = 1), (0.2 + 0.9) / 2)
  expect_equal(compute_unidimensional_theta(a = 2, b = 1, g = 0.2, i = 0.9, theta = -50), 0.2)
  expect_equal(compute_unidimensional_theta(a = 2, b = 1, g = 0.2, i = 0.9, theta = 50), 0.9)
  # zero discrimination gives a flat curve
  expect_equal(compute_unidimensional_theta(a = 0, b = 0, theta = c(-3, 0, 3)), rep(0.5, 3))
  # the default theta is 0
  expect_equal(compute_unidimensional_theta(a = 10, b = 0), 0.5)
  out <- compute_unidimensional_theta(a = 1, b = 0, theta = seq(-2, 2, by = 0.5))
  expect_type(out, "double")
  expect_length(out, 9)
  expect_true(all(diff(out) > 0))
})

##########################################################################################
# compute_unidimensional_ability
##########################################################################################
test_that("compute_unidimensional_ability returns the maximum likelihood estimate (documented examples)", {
  examples <- list(
    list(a = c(0.39, 0.45, 0.52, 0.3, 0.35, 0.43, 0.42, 0.44, 0.34, 0.42),
         b = c(-1.96, -1.9, -1.38, -0.58, 0.48, -0.81, -0.35, 1.59, 1.33, 2.93),
         u = c(1, 1, 1, 1, 0, 0, 1, 0, 1, 0), documented = 0.48402574251176),
    list(a = c(1.27, 0.9, 0.94, 0.95, 0.55, 0.6, 0.44, 0.4),
         b = c(-0.54, 0.18, 0.21, 1.26, 1.73, -0.87, 1.72, 2.67),
         u = c(1, 1, 1, 1, 0, 0, 0, 0), documented = 1.04621621510192),
    list(a = c(0.41, 0.32, 0.33, 1.2, 0.63, 0.62, 0.7, 0.61, 0.38, 0.53, 0.6, 1.16),
         b = c(-1.4, -1.3, -1.17, 0.2, 0.71, 0.86, -0.12, 0.12, 2.06, 1.38, 1.18, -0.33),
         u = c(1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 0), documented = 0.0860506282671103)
  )
  for (e in examples) {
    rwf <- compute_unidimensional_ability(a = e$a, b = e$b, u = e$u, d = 1.7, g = NULL)
    reference <- mle_reference(e$a, e$b, rep(0, length(e$u)), 1.7, e$u)
    # Newton-Raphson stops when the step is below 1e-4
    expect_lt(abs(rwf - reference), 1e-4)
    expect_lt(abs(rwf - e$documented), 1e-4)
    # the score function is (close to) zero at the estimate
    score <- numeric_derivative(function(t) loglik_3pl(t, e$a, e$b, 0, 1.7, e$u), rwf)
    expect_lt(abs(score), 1e-3)
  }
})

test_that("compute_unidimensional_ability handles the 3PL model with guessing", {
  a <- c(0.39, 0.45, 0.52, 0.3, 0.35, 0.43, 0.42, 0.44, 0.34, 0.42)
  b <- c(-1.96, -1.9, -1.38, -0.58, 0.48, -0.81, -0.35, 1.59, 1.33, 2.93)
  u <- c(1, 1, 1, 1, 0, 0, 1, 0, 1, 0)
  g <- rep(0.2, 10)
  rwf <- compute_unidimensional_ability(a = a, b = b, g = g, u = u, d = 1.7)
  expect_lt(abs(rwf - mle_reference(a, b, g, 1.7, u)), 1e-4)
  # the default scaling constant is 1.702
  expect_lt(abs(compute_unidimensional_ability(a = a, b = b, g = g, u = u) - mle_reference(a, b, g, 1.702, u)), 1e-4)
})

test_that("compute_unidimensional_ability is monotone in the number correct and respects lim_theta", {
  a <- rep(1, 6); b <- seq(-1.5, 1.5, length.out = 6)
  patterns <- list(c(1, 0, 0, 0, 0, 0), c(1, 1, 0, 0, 0, 0), c(1, 1, 1, 0, 0, 0),
                   c(1, 1, 1, 1, 0, 0), c(1, 1, 1, 1, 1, 0))
  estimates <- vapply(patterns, function(u) compute_unidimensional_ability(a = a, b = b, u = u), numeric(1))
  expect_true(all(diff(estimates) > 0))
  # perfect and zero scores have an infinite MLE; the estimate is clamped to lim_theta
  a <- c(0.39, 0.45, 0.52, 0.3, 0.35, 0.43, 0.42, 0.44, 0.34, 0.42)
  b <- c(-1.96, -1.9, -1.38, -0.58, 0.48, -0.81, -0.35, 1.59, 1.33, 2.93)
  expect_equal(compute_unidimensional_ability(a = a, b = b, u = rep(1, 10), d = 1.7), 6)
  expect_equal(compute_unidimensional_ability(a = a, b = b, u = rep(0, 10), d = 1.7), -6)
  expect_equal(compute_unidimensional_ability(a = a, b = b, u = rep(1, 10), d = 1.7, lim_theta = c(-2, 2)), 2)
  expect_equal(compute_unidimensional_ability(a = a, b = b, u = rep(0, 10), d = 1.7, lim_theta = c(-2, 2)), -2)
})

##########################################################################################
# compute_info_1pl
##########################################################################################
test_that("compute_info_1pl matches P(1 - P) and mirt::iteminfo for a Rasch item", {
  theta <- seq(-6, 6, by = 0.5)
  for (b in c(-2, 0, 1)) {
    p <- stats::plogis(theta - b)
    expect_equal(compute_info_1pl(b = b, theta = theta), p * (1 - p))
  }
  model <- fixed_mirt_4pl(a = c(1, 1), b = c(1, -0.5))
  expect_equal(compute_info_1pl(b = 1, theta = theta), mirt::iteminfo(mirt::extract.item(model, 1), Theta = theta))
  expect_equal(compute_info_1pl(b = -0.5, theta = theta), mirt::iteminfo(mirt::extract.item(model, 2), Theta = theta))
})

test_that("compute_info_1pl peaks at 0.25 at theta = b and vanishes at extreme thetas", {
  expect_equal(compute_info_1pl(b = 1, theta = 1), 0.25)
  expect_lt(compute_info_1pl(b = 1, theta = 40), 1e-15)
  expect_lt(compute_info_1pl(b = 1, theta = -40), 1e-15)
  theta <- seq(-3, 3, by = 0.01)
  expect_equal(theta[which.max(compute_info_1pl(b = 0.5, theta = theta))], 0.5)
})

##########################################################################################
# compute_info_2pl
##########################################################################################
test_that("compute_info_2pl matches a^2 P(1 - P) and mirt::iteminfo", {
  theta <- seq(-6, 6, by = 0.5)
  a <- c(1.5, 1, 2, 3); b <- c(1, -2, 0, 2)
  model <- fixed_mirt_4pl(a = a, b = b)
  for (j in seq_along(a)) {
    p <- stats::plogis(a[j] * (theta - b[j]))
    expect_equal(compute_info_2pl(a = a[j], b = b[j], theta = theta), a[j]^2 * p * (1 - p))
    expect_equal(compute_info_2pl(a = a[j], b = b[j], theta = theta),
                 mirt::iteminfo(mirt::extract.item(model, j), Theta = theta))
  }
})

test_that("compute_info_2pl equals the Fisher information P'^2 / (P Q) and peaks at a^2 / 4", {
  a <- 1.7; b <- 0.3
  prob <- function(t) stats::plogis(a * (t - b))
  theta <- c(-2, -0.5, 0.3, 1, 2.5)
  fisher <- numeric_derivative(prob, theta)^2 / (prob(theta) * (1 - prob(theta)))
  expect_equal(compute_info_2pl(a = a, b = b, theta = theta), fisher, tolerance = 1e-7)
  expect_equal(compute_info_2pl(a = a, b = b, theta = b), a^2 / 4)
  expect_equal(compute_info_2pl(a = 1, b = 0.7, theta = theta), compute_info_1pl(b = 0.7, theta = theta))
})

##########################################################################################
# compute_info_3pl
##########################################################################################
test_that("compute_info_3pl matches mirt::iteminfo for 3PL items", {
  theta <- seq(-4, 4, by = 0.25)
  a <- c(1.5, 0.8, 2.2); b <- c(1, -0.5, 0.3); g <- c(0.2, 0.1, 0.25)
  model <- fixed_mirt_4pl(a = a, b = b, g = g)
  for (j in seq_along(a)) {
    expect_equal(compute_info_3pl(a = a[j], b = b[j], g = g[j], theta = theta),
                 mirt::iteminfo(mirt::extract.item(model, j), Theta = theta))
  }
})

test_that("compute_info_3pl equals the Fisher information and reduces to the 2PL when g = 0", {
  a <- 1.5; b <- 1; g <- 0.2
  prob <- function(t) g + (1 - g) * stats::plogis(a * (t - b))
  theta <- c(-3, -1, 0, 1, 2, 3)
  fisher <- numeric_derivative(prob, theta)^2 / (prob(theta) * (1 - prob(theta)))
  expect_equal(compute_info_3pl(a = a, b = b, g = g, theta = theta), fisher, tolerance = 1e-7)
  expect_equal(compute_info_3pl(a = a, b = b, g = 0, theta = theta), compute_info_2pl(a = a, b = b, theta = theta))
  # guessing always lowers the information
  expect_true(all(compute_info_3pl(a = a, b = b, g = g, theta = theta) < compute_info_2pl(a = a, b = b, theta = theta)))
})

##########################################################################################
# compute_se_theta
##########################################################################################
test_that("compute_se_theta is the inverse square root of the information", {
  expect_equal(compute_se_theta(1), 1)
  expect_equal(compute_se_theta(4), 0.5)
  info <- compute_info_2pl(a = 2, b = 0, theta = seq(-3, 3, by = 0.5))
  expect_equal(compute_se_theta(info), 1 / sqrt(info))
  expect_length(compute_se_theta(info), length(info))
  # test information is the sum of item informations
  model <- fixed_mirt_4pl(a = c(1, 1.5, 2), b = c(-1, 0, 1))
  theta <- seq(-2, 2, by = 0.5)
  test_info <- compute_info_2pl(1, -1, theta) + compute_info_2pl(1.5, 0, theta) + compute_info_2pl(2, 1, theta)
  expect_equal(compute_se_theta(test_info), 1 / sqrt(mirt::testinfo(model, Theta = theta)))
  expect_equal(compute_se_theta(0), Inf)
})
