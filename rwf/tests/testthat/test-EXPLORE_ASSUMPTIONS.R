# Base graphics and printed ggplots are sent to a pdf device with no output file,
# so nothing is drawn on screen and no Rplots.pdf is left behind
local_null_device <- function(env = parent.frame()) {
  grDevices::pdf(NULL)
  device <- grDevices::dev.cur()
  withr::defer(if (device %in% grDevices::dev.list()) grDevices::dev.off(device), envir = env)
}

##########################################################################################
# plot_normality_diagnostics
##########################################################################################
test_that("plot_normality_diagnostics returns one recorded plot per numeric column", {
  local_null_device()
  df <- data.frame(mpg = mtcars$mpg, hp = mtcars$hp, name = rownames(mtcars))
  plots <- quietly(plot_normality_diagnostics(df = df, title = "mtcars"))
  expect_type(plots, "list")
  expect_named(plots, c("mpg", "hp"))
  for (p in plots) expect_s3_class(p, "recordedplot")
})

test_that("plot_normality_diagnostics names a single vector after the argument and accepts integer breaks", {
  local_null_device()
  withr::local_seed(1)
  vec <- c(stats::rnorm(40), NA, NA)
  plots <- quietly(plot_normality_diagnostics(df = vec, breaks = 5))
  expect_named(plots, "vec")
  expect_s3_class(plots[[1]], "recordedplot")
})

test_that("plot_normality_diagnostics skips constant and too-short columns", {
  local_null_device()
  df <- data.frame(constant = rep(3, 10), short = c(1, 2, rep(NA, 8)), ok = 1:10)
  expect_output(plots <- plot_normality_diagnostics(df = df), "Graph not produced for constant")
  expect_named(plots, "ok")
})

test_that("plot_normality_diagnostics writes a pdf when file is given", {
  local_null_device()
  dir <- withr::local_tempdir()
  quietly(plot_normality_diagnostics(df = mtcars[, 1:2], title = "cars", file = file.path(dir, "diag")))
  pdf_file <- file.path(dir, "diag_cars.pdf")
  expect_true(file.exists(pdf_file))
  expect_gt(file.size(pdf_file), 0)
})

##########################################################################################
# plot_outlier
##########################################################################################
test_that("plot_outlier flags the same observations as the documented rules", {
  local_null_device()
  withr::local_seed(2)
  x <- c(stats::rnorm(40), 6, -5, NA)
  m <- mean(x, na.rm = TRUE)
  s <- stats::sd(x, na.rm = TRUE)
  med <- stats::median(x, na.rm = TRUE)
  raw_mad <- stats::mad(x, constant = 1, na.rm = TRUE)
  q <- stats::quantile(x, c(.25, .75), na.rm = TRUE)
  iqr <- stats::IQR(x, na.rm = TRUE)
  expected <- list(
    mean = list(flag = abs(x - m) > 2 * s, lines = c(m, m - 2 * s, m + 2 * s)),
    median = list(flag = abs(x - med) > 2 * raw_mad / 0.6745,
                  lines = c(med, med - 2 * raw_mad / 0.6745, med + 2 * raw_mad / 0.6745)),
    boxplot = list(flag = x < q[1] - 1.5 * iqr | x > q[2] + 1.5 * iqr,
                   lines = unname(c(med, q[1] - 1.5 * iqr, q[2] + 1.5 * iqr)))
  )
  for (method in names(expected)) {
    plots <- quietly(plot_outlier(df = x, method = method))
    expect_named(plots, "x")
    p <- plots$x
    expect_s3_class(p, "ggplot")
    expect_no_error(ggplot2::ggplot_build(p))
    keep <- !is.na(x)
    expect_equal(p$data$obs, x[keep])
    expect_equal(p$data$Outlier, expected[[method]]$flag[keep])
    expect_equal(p$labels$x, paste("Observation ID \n Outliers:", sum(expected[[method]]$flag, na.rm = TRUE)))
    hlines <- vapply(p$layers[3:5], function(l) unname(l$data$yintercept), numeric(1))
    expect_equal(unname(hlines), unname(expected[[method]]$lines))
  }
})

test_that("plot_outlier handles a vector, drops non-numeric columns and prints a progress bar", {
  local_null_device()
  vec <- c(1:20, 100)
  plots <- quietly(plot_outlier(df = vec))
  expect_named(plots, "vec")
  expect_equal(plots$vec$data$id[plots$vec$data$Outlier], "21")
  df <- data.frame(a = mtcars$mpg, b = mtcars$hp, label = rownames(mtcars))
  expect_output(plots <- plot_outlier(df = df, pb = TRUE), "100%")
  expect_named(plots, c("a", "b"))
})

##########################################################################################
# plot_histogram
##########################################################################################
test_that("plot_histogram returns one histogram per numeric column with correct counts and caption", {
  local_null_device()
  df <- mtcars[, c("mpg", "hp")]
  df$mpg[1:3] <- NA
  df$type <- rownames(mtcars)
  plots <- quietly(plot_histogram(df = df, bins = 10))
  expect_named(plots, c("mpg", "hp"))
  for (v in c("mpg", "hp")) {
    p <- plots[[v]]
    expect_s3_class(p, "ggplot")
    built <- ggplot2::ggplot_build(p)
    x <- stats::na.omit(df[[v]])
    expect_equal(nrow(built$data[[1]]), 10)
    expect_equal(sum(built$data[[1]]$count), length(x))
    expect_equal(p$labels$x, v)
    expect_equal(p$labels$caption, paste0("\nObservations=", length(x), "\nMean=", round(mean(x), 2),
                                          "\nSD=", round(stats::sd(x), 2), "\nMedian=", round(stats::median(x), 2)))
  }
})

test_that("plot_histogram applies xlims and accepts a single vector", {
  local_null_device()
  plots <- quietly(plot_histogram(df = mtcars[, 1:2], xlims = c(0, 50)))
  built <- ggplot2::ggplot_build(plots$mpg)
  expect_equal(built$layout$panel_scales_x[[1]]$limits, c(0, 50))
  single <- quietly(plot_histogram(df = c(stats::rnorm(20), NA)))
  expect_length(single, 1)
  expect_s3_class(single[[1]], "ggplot")
  expect_no_error(ggplot2::ggplot_build(single[[1]]))
})

##########################################################################################
# plot_qq
##########################################################################################
test_that("plot_qq reference line matches stats::qqline and non-numeric columns are skipped", {
  local_null_device()
  withr::local_seed(3)
  df <- data.frame(a = c(stats::rexp(30), NA), b = letters[1:31], c = stats::rnorm(31))
  plots <- quietly(plot_qq(df = df))
  expect_named(plots, c("a", "c"))
  for (v in c("a", "c")) {
    x <- df[[v]][is.finite(df[[v]])]
    y <- stats::quantile(x, c(.25, .75))
    z <- stats::qnorm(c(.25, .75))
    slope <- diff(y) / diff(z)
    p <- plots[[v]]
    expect_s3_class(p, "ggplot")
    built <- ggplot2::ggplot_build(p)
    expect_equal(unname(built$data[[2]]$slope), unname(slope))
    expect_equal(unname(built$data[[2]]$intercept), unname(y[1] - slope * z[1]))
    expect_equal(sort(built$data[[1]]$sample), sort(x))
    expect_equal(sort(built$data[[1]]$theoretical), sort(stats::qnorm(stats::ppoints(length(x)))))
  }
})

test_that("plot_qq names a single vector after the argument", {
  local_null_device()
  vec <- c(1, 4, 2, 8, 5, 7)
  plots <- quietly(plot_qq(df = vec))
  expect_named(plots, "vec")
  expect_match(plots$vec$labels$caption, "Observations=6")
})

##########################################################################################
# plot_boxplot
##########################################################################################
test_that("plot_boxplot draws one box per numeric column with the correct quartiles", {
  df <- mtcars[, c("mpg", "hp", "wt")]
  df$mpg[2] <- NA
  df$name <- rownames(mtcars)
  p <- plot_boxplot(df = df, title = "cars")
  expect_s3_class(p, "ggplot")
  built <- ggplot2::ggplot_build(p)$data[[1]]
  expect_equal(nrow(built), 3)
  expect_equal(levels(p$data$variable), c("mpg", "hp", "wt"))
  for (i in 1:3) {
    x <- stats::na.omit(df[[i]])
    expect_equal(built$middle[i], stats::median(x))
    expect_equal(built$lower[i], unname(stats::quantile(x, .25)))
    expect_equal(built$upper[i], unname(stats::quantile(x, .75)))
  }
  expect_equal(p$labels$title, "cars")
})

test_that("plot_boxplot accepts a single vector", {
  vec <- c(3, 1, 4, 1, 5, 9, 2, 6, NA)
  p <- plot_boxplot(df = vec)
  expect_s3_class(p, "ggplot")
  expect_equal(levels(p$data$variable), "vec")
  expect_equal(ggplot2::ggplot_build(p)$data[[1]]$middle, stats::median(vec, na.rm = TRUE))
})

##########################################################################################
# report_normality_tests
##########################################################################################
test_that("report_normality_tests statistics match stats and DescTools", {
  dir <- withr::local_tempdir()
  withr::local_seed(4)
  df <- data.frame(a = c(stats::rnorm(40), NA), b = c(stats::rexp(41)))
  quietly(report_normality_tests(df = df, file = file.path(dir, "normality")))
  expect_true(file.exists(file.path(dir, "normality.xlsx")))
  expect_true(file.exists(file.path(dir, "normality.log")))
  expect_true(any(grepl("NORMALITY TESTS", readLines(file.path(dir, "normality.log")))))
  result <- openxlsx::read.xlsx(file.path(dir, "normality.xlsx"))
  expect_equal(nrow(result), 16)
  expect_true(all(c("variable", "n", "statistic", "df", "p", "method") %in% names(result)))
  for (v in c("a", "b")) {
    x <- stats::na.omit(df[[v]])
    z <- (x - mean(x)) / stats::sd(x)
    r <- result[result$variable == v, ]
    expect_equal(unique(r$n), length(x))
    sw <- stats::shapiro.test(x)
    expect_equal(r$statistic[1], unname(sw$statistic))
    expect_equal(r$p[1], sw$p.value)
    ks <- stats::ks.test(z, "pnorm", mean = mean(z), sd = stats::sd(z))
    expect_equal(r$statistic[7], unname(ks$statistic))
    expect_equal(r$p[7], ks$p.value)
    jb <- DescTools::JarqueBeraTest(z)
    expect_equal(r$statistic[5], unname(jb$statistic))
    expect_equal(r$p[5], jb$p.value)
  }
})

test_that("report_normality_tests composite tests match nortest", {
  skip_if_not_installed("nortest")
  dir <- withr::local_tempdir()
  withr::local_seed(5)
  x <- stats::rgamma(60, shape = 3)
  quietly(report_normality_tests(df = data.frame(x = x), file = file.path(dir, "nt")))
  r <- openxlsx::read.xlsx(file.path(dir, "nt.xlsx"))
  z <- (x - mean(x)) / stats::sd(x)
  # Anderson-Darling against N(0, 1) on standardised data has the same statistic as the composite test
  expect_equal(r$statistic[2], unname(nortest::ad.test(x)$statistic))
  cvm <- nortest::cvm.test(z)
  expect_equal(r$statistic[3], unname(cvm$statistic))
  expect_equal(r$p[3], cvm$p.value)
  sf <- nortest::sf.test(z)
  expect_equal(r$statistic[4], unname(sf$statistic))
  expect_equal(r$p[4], sf$p.value)
  lillie <- nortest::lillie.test(z)
  expect_equal(r$statistic[6], unname(lillie$statistic))
  expect_equal(r$p[6], lillie$p.value)
  pearson <- nortest::pearson.test(z, n.classes = ceiling(2 * (60^(2 / 5))), adjust = TRUE)
  expect_equal(r$statistic[8], unname(pearson$statistic))
  expect_equal(r$p[8], pearson$p.value)
})

test_that("report_normality_tests skips columns with out of bounds sample size", {
  expect_output(result <- report_normality_tests(df = data.frame(a = 1:5)), "OUT OF BOUNDS SAMPLE SIZE FOR a")
  expect_null(result)
})

test_that("report_normality_tests skips a constant column instead of failing", {
  df <- data.frame(constant = rep(1, 20), x = c(2, 5, 1, 8, 3, 9, 4, 7, 6, 10, 12, 11, 15, 13, 14, 16, 18, 17, 20, 19))
  expect_output(report_normality_tests(df = df), "OUT OF BOUNDS SAMPLE SIZE FOR constant")
})

##########################################################################################
# outlier_summary
##########################################################################################
test_that("outlier_summary percentages match a hand computation", {
  x <- c(mtcars$hp, NA)
  result <- outlier_summary(x)
  expect_s3_class(result, "data.frame")
  expect_equal(dim(result), c(1, 3))
  expect_named(result, c("abs_z_1.96", "abs_z_2.58", "abs_z_3.29"))
  z <- as.numeric(scale(stats::na.omit(x)))
  expected <- paste(round(100 * c(mean(abs(z) >= 1.96), mean(abs(z) >= 2.58), mean(abs(z) >= 3.29)), 2), "%")
  expect_equal(unname(unlist(result)), expected)
})

test_that("outlier_summary works across columns with sapply", {
  result <- data.frame(sapply(mtcars, outlier_summary))
  expect_equal(dim(result), c(3, 11))
  expect_equal(result$wt[[1]], outlier_summary(mtcars$wt)$abs_z_1.96)
  expect_equal(unlist(outlier_summary(1:10)), c(abs_z_1.96 = "0 %", abs_z_2.58 = "0 %", abs_z_3.29 = "0 %"))
})

##########################################################################################
# remove_outliers
##########################################################################################
test_that("remove_outliers replaces values outside the boxplot fences with NA", {
  x <- c(-50, 1:20, 90, NA)
  q <- stats::quantile(x, c(.25, .75), na.rm = TRUE)
  fence <- 1.5 * stats::IQR(x, na.rm = TRUE)
  expected <- x
  expected[!is.na(x) & (x < q[1] - fence | x > q[2] + fence)] <- NA
  result <- remove_outliers(x)
  expect_equal(result, expected)
  expect_length(result, length(x))
  expect_true(all(is.na(result[c(1, 22)])))
  # the same values are flagged as by grDevices::boxplot.stats when hinges and quartiles agree
  y <- c(1:11, 40)
  expect_equal(which(is.na(remove_outliers(y))), which(y %in% grDevices::boxplot.stats(y)$out))
})

test_that("remove_outliers works on a data frame with sapply and leaves clean data untouched", {
  result <- data.frame(sapply(mtcars[, c("hp", "wt")], remove_outliers))
  expect_equal(dim(result), c(32, 2))
  expect_equal(which(is.na(result$hp)), which(mtcars$hp > 305.25))
  expect_equal(remove_outliers(1:10), 1:10)
})
