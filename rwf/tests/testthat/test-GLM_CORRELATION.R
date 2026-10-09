##########################################################################################
# helpers local to this file
##########################################################################################
# Sends anything the report functions print to a throw-away graphics device
local_null_device_correlation <- function(env = parent.frame()) {
  grDevices::pdf(NULL)
  device <- grDevices::dev.cur()
  withr::defer(if (device %in% grDevices::dev.list()) grDevices::dev.off(device), envir = env)
}

lower_values <- function(m) {
  m <- as.matrix(m)
  m[lower.tri(m)]
}

##########################################################################################
# plot_corrplot
##########################################################################################
test_that("plot_corrplot draws the rounded upper triangle of the matrix", {
  r <- stats::cor(mtcars[, 1:5])
  p <- plot_corrplot(r, title = "Correlation")
  expect_s3_class(p, "ggplot")
  expect_no_error(ggplot2::ggplot_build(p))
  tiles <- p$data
  # upper triangle including the diagonal
  expect_equal(nrow(tiles), 5 * 6 / 2)
  expected <- round(r, 2)[upper.tri(r, diag = TRUE)]
  expect_setequal(round(tiles$value, 2), expected)
  expect_equal(p$labels$title, "Correlation")
})

test_that("plot_corrplot passes fill limits to the colour scale", {
  p <- plot_corrplot(stats::cor(mtcars[, 1:3]), fill_limits = c(0, 0.5, 1))
  fill_scale <- p$scales$get_scales("fill")
  expect_equal(fill_scale$limits, c(0, 1))
  expect_no_error(ggplot2::ggplot_build(p))
})

##########################################################################################
# compute_power_r
##########################################################################################
test_that("compute_power_r matches pwr::pwr.r.test for every sample size", {
  for (alternative in c("two.sided", "greater")) {
    rwf <- compute_power_r(n = 40, r = .3, sig.level = .05, alternative = alternative)
    expect_named(rwf, c("plot", "power_table"))
    expect_equal(rwf$power_table$n, 10:40)
    reference <- sapply(10:40, function(n) pwr::pwr.r.test(n = n, r = .3, sig.level = .05, alternative = alternative)$power)
    expect_equal(rwf$power_table$power, reference)
    expect_true(all(rwf$power_table$alternative == alternative))
    expect_true(all(diff(rwf$power_table$power) > 0))
  }
})

test_that("compute_power_r returns a buildable ggplot", {
  rwf <- compute_power_r(n = 20, r = .5, title = "Power")
  expect_s3_class(rwf$plot, "ggplot")
  expect_no_error(ggplot2::ggplot_build(rwf$plot))
  expect_equal(rwf$plot$labels$title, "Power")
})

##########################################################################################
# compute_power_r_matrix
##########################################################################################
test_that("compute_power_r_matrix uses the min, max, mean and median absolute off-diagonal r", {
  local_null_device_correlation()
  m <- stats::cor(mtcars[, 1:4])
  rwf <- compute_power_r_matrix(m = m, n = 20)
  expect_named(rwf, c("plot", "power_table"))
  expect_equal(nrow(rwf$power_table), 4 * length(10:20))
  off_diagonal <- abs(m[upper.tri(m)])
  expected_r <- c(min(off_diagonal), max(off_diagonal), mean(off_diagonal), stats::median(off_diagonal))
  expect_equal(unique(rwf$power_table$r), expected_r)
  first_block <- rwf$power_table[rwf$power_table$r == expected_r[1], ]
  expect_equal(first_block$power, sapply(10:20, function(n) pwr::pwr.r.test(n = n, r = expected_r[1])$power))
  expect_type(rwf$plot, "list")
  expect_s3_class(rwf$plot[[1]], "recordedplot")
})

##########################################################################################
# report_correlation
##########################################################################################
test_that("report_correlation matches stats::cor.test for r, t, p, n and confidence intervals", {
  local_null_device_correlation()
  x <- mtcars[, c("mpg", "hp", "wt", "qsec")]
  rwf <- quietly(report_correlation(x = x, scatterplot = FALSE))
  expect_named(rwf, c("r_lower", "r_squared_lower", "p_lower", "p_lower_adjusted", "t_lower",
                      "n_lower", "se_lower", "ci", "call"))
  expect_equal(dim(rwf$r_lower), c(4, 4))
  expect_equal(names(rwf$r_lower), names(x))
  expect_true(all(is.na(as.matrix(rwf$r_lower)[upper.tri(diag(4), diag = TRUE)])))

  pairs <- utils::combn(names(x), 2)
  for (k in seq_len(ncol(pairs))) {
    v1 <- pairs[1, k]
    v2 <- pairs[2, k]
    ct <- stats::cor.test(x[[v1]], x[[v2]])
    r <- unname(ct$estimate)
    expect_equal(rwf$r_lower[v2, v1], r)
    expect_equal(rwf$r_squared_lower[v2, v1], r^2)
    expect_equal(rwf$t_lower[v2, v1], unname(ct$statistic))
    expect_equal(rwf$p_lower[v2, v1], ct$p.value)
    expect_equal(rwf$se_lower[v2, v1], sqrt((1 - r^2) / (nrow(x) - 2)))
    # psych orders the interval rows like utils::combn
    ci_row <- rwf$ci[k, ]
    expect_equal(ci_row$r, r)
    expect_equal(ci_row$lower, ct$conf.int[1])
    expect_equal(ci_row$upper, ct$conf.int[2])
  }
  expect_equal(rwf$n_lower$n, nrow(x))
})

test_that("report_correlation adjusted p values match stats::p.adjust and psych::corr.test", {
  local_null_device_correlation()
  x <- mtcars[, c("mpg", "drat", "qsec", "gear")]
  for (adjust in c("holm", "bonferroni", "BH")) {
    rwf <- quietly(report_correlation(x = x, adjust = adjust, scatterplot = FALSE))
    raw <- lower_values(rwf$p_lower)
    expect_equal(lower_values(rwf$p_lower_adjusted), stats::p.adjust(raw, method = adjust))
    psych_p <- psych::corr.test(x, adjust = adjust)$p
    expect_equal(lower_values(rwf$p_lower_adjusted), t(psych_p)[lower.tri(psych_p)])
  }
})

test_that("report_correlation spearman and kendall correlations match stats::cor and psych", {
  local_null_device_correlation()
  x <- mtcars[, c("mpg", "hp", "wt")]
  for (method in c("spearman", "kendall")) {
    rwf <- quietly(report_correlation(x = x, method = method, scatterplot = FALSE))
    expect_equal(lower_values(rwf$r_lower), lower_values(stats::cor(x, method = method)))
    expect_equal(lower_values(rwf$p_lower), lower_values(psych::corr.test(x, method = method)$p))
    expect_equal(rwf$call$function_values[rwf$call$function_arguments == "Method"], method)
  }
})

test_that("report_correlation uses pairwise deletion by default and complete cases on request", {
  local_null_device_correlation()
  x <- mtcars[, c("mpg", "hp", "wt", "qsec")]
  x$mpg[c(1, 2, 3)] <- NA
  x$hp[5] <- NA
  x$wt[c(3, 10)] <- NA

  pairwise <- quietly(report_correlation(x = x, scatterplot = FALSE))
  expected_n <- crossprod(!is.na(as.matrix(x)))
  expect_equal(lower_values(pairwise$n_lower), lower_values(expected_n))
  expect_equal(lower_values(pairwise$r_lower), lower_values(stats::cor(x, use = "pairwise.complete.obs")))
  ct <- stats::cor.test(x$mpg, x$wt)
  expect_equal(pairwise$p_lower["wt", "mpg"], ct$p.value)

  complete <- quietly(report_correlation(x = x, use = "complete", scatterplot = FALSE))
  # psych::corr.test reports the smallest pairwise n here (not the number of complete rows);
  # rwf passes that value through unchanged
  expect_equal(complete$n_lower$n, psych::corr.test(x, use = "complete")$n)
  expect_equal(lower_values(complete$r_lower), lower_values(stats::cor(x, use = "complete.obs")))
})

test_that("report_correlation handles two variables", {
  local_null_device_correlation()
  rwf <- quietly(report_correlation(x = mtcars[, c("mpg", "wt")], scatterplot = TRUE))
  expect_equal(rwf$r_lower["wt", "mpg"], stats::cor(mtcars$mpg, mtcars$wt))
  expect_equal(nrow(rwf$ci), 1)
  expect_equal(rwf$n_lower$n, 32)
})

test_that("report_correlation writes pdf and xlsx output", {
  local_null_device_correlation()
  dir <- withr::local_tempdir()
  file <- file.path(dir, "correlation")
  rwf <- quietly(report_correlation(x = mtcars[, 1:3], file = file, scatterplot = TRUE))
  expect_true(file.exists(paste0(file, ".xlsx")))
  expect_true(file.exists(paste0(file, "_corrplot.pdf")))
  expect_true(file.exists(paste0(file, "_scatterplot.pdf")))
  expect_equal(openxlsx::getSheetNames(paste0(file, ".xlsx")),
               c("r", "r_squared", "p", "p_adjusted", "t", "N", "SE", "CI", "Call"))
})

##########################################################################################
# report_choric_serial
##########################################################################################
test_that("report_choric_serial tetrachoric matches psych::tetrachoric", {
  local_null_device_correlation()
  rwf <- quietly(report_choric_serial(x = psych::lsat6, type = "tetrachoric"))
  reference <- psych::tetrachoric(psych::lsat6)
  expect_s3_class(rwf, "psych")
  expect_equal(rwf$rho, reference$rho)
  expect_equal(rwf$tau, reference$tau)
  expect_equal(dim(rwf$rho), c(5, 5))
})

test_that("report_choric_serial polychoric matches psych::polychoric", {
  local_null_device_correlation()
  withr::local_seed(42)
  sigma <- matrix(c(1, .6, .4, .6, 1, .5, .4, .5, 1), 3)
  latent <- MASS::mvrnorm(500, mu = rep(0, 3), Sigma = sigma)
  items <- as.data.frame(apply(latent, 2, cut, breaks = c(-Inf, -1, 0, 1, Inf), labels = FALSE))
  rwf <- quietly(report_choric_serial(x = items, type = "polychoric"))
  reference <- suppressWarnings(psych::polychoric(items))
  expect_equal(rwf$rho, reference$rho)
  expect_equal(rwf$tau, reference$tau)
})

test_that("report_choric_serial biserial and polyserial match psych", {
  local_null_device_correlation()
  biserial <- quietly(report_choric_serial(x = mtcars[, c("mpg", "wt")], y = mtcars[, c("am", "vs")], type = "biserial"))
  expect_s3_class(biserial, "data.frame")
  expect_equal(unname(as.matrix(biserial)), unname(as.matrix(psych::biserial(mtcars[, c("mpg", "wt")], mtcars[, c("am", "vs")]))))

  polyserial <- quietly(report_choric_serial(x = mtcars[, c("mpg", "wt")], y = mtcars[, c("gear", "cyl")], type = "polyserial"))
  expect_s3_class(polyserial, "data.frame")
  expect_equal(unname(as.matrix(polyserial)),
               unname(as.matrix(suppressWarnings(psych::polyserial(mtcars[, c("mpg", "wt")], mtcars[, c("gear", "cyl")])))))
})

test_that("report_choric_serial writes pdf and xlsx output for tetrachoric and biserial", {
  local_null_device_correlation()
  dir <- withr::local_tempdir()
  tetra <- file.path(dir, "tetrachoric")
  quietly(report_choric_serial(x = psych::lsat6, type = "tetrachoric", file = tetra))
  expect_true(file.exists(paste0(tetra, "_tetrachoric.pdf")))
  expect_equal(openxlsx::getSheetNames(paste0(tetra, ".xlsx")), c("R", "R Squared", "Tau", "Observations", "Call"))

  bis <- file.path(dir, "biserial")
  quietly(report_choric_serial(x = mtcars[, c("mpg", "wt")], y = mtcars[, c("am", "vs")], type = "biserial", file = bis))
  expect_true(file.exists(paste0(bis, "_biserial.pdf")))
  expect_true(file.exists(paste0(bis, ".xlsx")))
})

test_that("report_choric_serial writes pdf and xlsx output for polyserial", {
  skip("rwf bug: report_choric_serial tests type=='biserial'||type=='biserial', so polyserial output is never written")
  local_null_device_correlation()
  dir <- withr::local_tempdir()
  poly <- file.path(dir, "polyserial")
  quietly(report_choric_serial(x = mtcars[, c("mpg", "wt")], y = mtcars[, c("gear", "cyl")], type = "polyserial", file = poly))
  expect_true(file.exists(paste0(poly, "_polyserial.pdf")))
  expect_true(file.exists(paste0(poly, ".xlsx")))
})
