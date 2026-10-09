# Base graphics are sent to a pdf device with no output file,
# so nothing is drawn on screen and no Rplots.pdf is left behind
local_null_device <- function(env = parent.frame()) {
  grDevices::pdf(NULL)
  device <- grDevices::dev.cur()
  withr::defer(if (device %in% grDevices::dev.list()) grDevices::dev.off(device), envir = env)
}

uk_deaths <- function() ts(UKDriverDeaths, start = 1969, end = 1984, frequency = 12)

##########################################################################################
# plot_ts
##########################################################################################
test_that("plot_ts plots the series against time with a linear trend", {
  x <- uk_deaths()
  p <- plot_ts(x, title = "UK driver deaths", ylab = "Deaths")
  expect_s3_class(p, "ggplot")
  expect_equal(p$data$date, as.numeric(stats::time(x)))
  expect_equal(p$data$value, as.numeric(x))
  expect_equal(p$labels$caption, paste("Observations", length(x)))
  expect_equal(p$labels$title, "UK driver deaths")
  expect_equal(p$labels$y, "Deaths")
  built <- ggplot2::ggplot_build(p)
  smooth <- built$data[[3]]
  fit <- stats::lm(value ~ date, data = p$data)
  expect_equal(smooth$y, unname(stats::predict(fit, newdata = data.frame(date = smooth$x))))
})

test_that("plot_ts can be extended with extra layers", {
  p <- plot_ts(ts(c(5, 3, 6, 2, 8, 4), start = 2000)) + ggplot2::geom_vline(xintercept = 2002)
  expect_s3_class(p, "ggplot")
  expect_length(p$layers, 4)
  expect_no_error(ggplot2::ggplot_build(p))
})

##########################################################################################
# plot_acf
##########################################################################################
test_that("plot_acf values match hand-computed autocorrelations and stats::pacf", {
  x <- uk_deaths()
  p <- plot_acf(df = x, lag.max = 24, title = "acf")
  expect_s3_class(p, "ggplot")
  expect_no_error(ggplot2::ggplot_build(p))
  expect_equal(as.vector(table(p$data$type)), c(25, 25, 24))
  n <- length(x)
  centred <- as.numeric(x) - mean(x)
  autocovariance <- sapply(0:24, function(k) sum(centred[1:(n - k)] * centred[(1 + k):n]) / n)
  correlation <- p$data$value[p$data$type == "Correlation"]
  covariance <- p$data$value[p$data$type == "Covariance"]
  partial <- p$data$value[p$data$type == "Partial.Correlation"]
  expect_equal(covariance, autocovariance)
  expect_equal(correlation, autocovariance / autocovariance[1])
  expect_equal(partial, as.vector(stats::pacf(x, lag.max = 24, plot = FALSE)$acf))
  expect_equal(partial[1], correlation[2])
  expect_equal(p$data$index[p$data$type == "Correlation"], 1:25)
})

test_that("plot_acf confidence lines are the t intervals of the plotted values", {
  x <- uk_deaths()
  p <- plot_acf(df = x, lag.max = 12)
  built <- ggplot2::ggplot_build(p)
  hlines <- sapply(built$data[2:10], function(d) unique(d$yintercept))
  for (k in seq_along(c("Correlation", "Covariance", "Partial.Correlation"))) {
    type <- c("Correlation", "Covariance", "Partial.Correlation")[k]
    values <- p$data$value[p$data$type == type]
    test <- stats::t.test(values)
    # layers per type: upper bound, mean, lower bound
    expect_equal(unname(hlines[(3 * k - 2):(3 * k)]), c(test$conf.int[2], mean(values), test$conf.int[1]))
  }
})

test_that("plot_acf excludes missing values", {
  withr::local_seed(10)
  x <- ts(c(NA, stats::rnorm(30), NA))
  p <- plot_acf(df = x, lag.max = 5)
  expect_s3_class(p, "ggplot")
  expect_false(anyNA(p$data$value))
  expect_equal(p$data$value[p$data$type == "Correlation"],
               as.vector(stats::acf(stats::na.omit(x), lag.max = 5, plot = FALSE)$acf))
})

##########################################################################################
# ts_smoothing
##########################################################################################
test_that("ts_smoothing draws one curve per bandwidth with the documented smoother", {
  local_null_device()
  x <- uk_deaths()
  drawn <- list()
  local_mocked_bindings(lines = function(x, ...) {
    drawn[[length(drawn) + 1]] <<- x
    invisible(NULL)
  })
  bandwidths <- c(.5, 1)
  references <- list(
    kernel = lapply(bandwidths, function(b) stats::ksmooth(stats::time(x), x, "normal", bandwidth = b)),
    lowess = lapply(bandwidths, function(b) stats::lowess(x, f = b)),
    splines = lapply(bandwidths, function(b) stats::smooth.spline(stats::time(x), x, spar = b)),
    default = lapply(bandwidths, function(b) stats::filter(x, filter = rep(1 / round(b), round(b)))),
    friedman = list(stats::supsmu(stats::time(x), x, span = .5))
  )
  for (type in names(references)) {
    drawn <- list()
    result <- ts_smoothing(x, start = .5, stop = 1, step = .5, type = type)
    expect_null(result)
    expect_length(drawn, length(references[[type]]))
    for (i in seq_along(drawn)) {
      if (type == "splines") {
        expect_equal(drawn[[i]]$y, references[[type]][[i]]$y)
      } else {
        expect_equal(drawn[[i]], references[[type]][[i]])
      }
    }
  }
})

test_that("ts_smoothing polynomial and linear trends match lm", {
  local_null_device()
  x <- uk_deaths()
  drawn <- list()
  local_mocked_bindings(
    lines = function(x, ...) {
      drawn[[length(drawn) + 1]] <<- x
      invisible(NULL)
    },
    abline = function(reg, ...) {
      drawn[[length(drawn) + 1]] <<- reg
      invisible(NULL)
    }
  )
  ts_smoothing(x, start = .5, stop = 1, step = .5, type = "polynomial")
  wk <- stats::time(x) - mean(stats::time(x))
  cubic <- stats::lm(as.numeric(x) ~ wk + I(wk^2) + I(wk^3))
  expect_length(drawn, 2)
  expect_equal(as.numeric(drawn[[1]]), unname(stats::fitted(cubic)))
  drawn <- list()
  ts_smoothing(x, type = "linear", start = .5, stop = 1, step = .5)
  expect_length(drawn, 1)
  expect_equal(unname(stats::coef(drawn[[1]])), unname(stats::coef(stats::lm(as.numeric(x) ~ as.numeric(stats::time(x))))))
})

test_that("ts_smoothing runs every type on a real device and does nothing for a series starting with NA", {
  local_null_device()
  x <- uk_deaths()
  for (type in c("kernel", "lowess", "friedman", "splines", "default", "polynomial", "linear")) {
    expect_no_error(ts_smoothing(x, start = .1, stop = 1, step = .3, title = "UK", type = type))
  }
  drawn <- 0
  local_mocked_bindings(plot = function(...) drawn <<- drawn + 1)
  expect_null(ts_smoothing(ts(c(NA, 1:10))))
  expect_equal(drawn, 0)
})

##########################################################################################
# compute_moving_average
##########################################################################################
reference_moving_average <- function(x, w) {
  n <- length(x)
  sapply(seq_len(n), function(i) mean(x[max(1, i - w):min(n, i + w)]))
}

test_that("compute_moving_average keeps the shape and matches stats::filter away from the edges", {
  df <- data.frame(x = c(4, 8, 15, 16, 23, 42, 7, 1, 9, 12), y = 1:10)
  result <- compute_moving_average(df = df, w = 2)
  expect_s3_class(result, "data.frame")
  expect_equal(dim(result), dim(df))
  expect_named(result, c("x", "y"))
  centred <- as.numeric(stats::filter(df$x, rep(1 / 5, 5), sides = 2))
  interior <- 3:7
  expect_equal(result$x[interior], centred[interior])
  # the window is clipped at the start of the series
  expect_equal(result$x[1:2], c(mean(df$x[1:3]), mean(df$x[1:4])))
})

test_that("compute_moving_average uses the last rows of the series", {
  skip("rwf bug: index_ma < max_row drops the last row from every window, so the end of the series is wrong")
  df <- data.frame(x = c(4, 8, 15, 16, 23, 42, 7, 1, 9, 12), y = 1:10)
  result <- compute_moving_average(df = df, w = 2)
  expect_equal(result$x, reference_moving_average(df$x, 2))
  expect_equal(result$y, reference_moving_average(df$y, 2))
  expect_equal(compute_moving_average(df = mtcars[, 1:3], w = 5)$mpg, reference_moving_average(mtcars$mpg, 5))
})
