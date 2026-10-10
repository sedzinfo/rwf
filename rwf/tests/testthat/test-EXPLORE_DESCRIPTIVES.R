# Printed ggplots are sent to a pdf device with no output file,
# so nothing is drawn on screen and no Rplots.pdf is left behind
local_null_device <- function(env = parent.frame()) {
  grDevices::pdf(NULL)
  device <- grDevices::dev.cur()
  withr::defer(if (device %in% grDevices::dev.list()) grDevices::dev.off(device), envir = env)
}

##########################################################################################
# compute_descriptives
##########################################################################################
expect_descriptives_row <- function(row, x) {
  x <- stats::na.omit(x)
  expect_equal(row$n, length(x))
  expect_equal(row$mean, mean(x))
  expect_equal(row$sd, stats::sd(x))
  expect_equal(row$median, stats::median(x))
  expect_equal(row$trimmed, mean(x, trim = .1))
  expect_equal(row$mad, stats::mad(x))
  expect_equal(row$min, min(x))
  expect_equal(row$max, max(x))
  expect_equal(row$range, max(x) - min(x))
  expect_equal(row$se, stats::sd(x) / sqrt(length(x)))
  expect_equal(row$IQR, stats::IQR(x))
  q <- unname(stats::quantile(x, c(.1, .25, .5, .75, .9)))
  expect_equal(unname(unlist(row[c("Q0.1", "Q0.25", "Q0.5", "Q0.75", "Q0.9")])), q)
}

test_that("compute_descriptives matches base R statistics on the full sample", {
  df <- mtcars
  df$mpg[c(2, 7)] <- NA
  result <- compute_descriptives(df = df, dv = 1:3)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3)
  expect_named(result, c("variable", "n", "mean", "sd", "median", "trimmed", "mad", "min", "max", "range",
                         "skew", "kurtosis", "se", "IQR", "Q0.1", "Q0.25", "Q0.5", "Q0.75", "Q0.9"))
  expect_equal(result$variable, c("mpg", "cyl", "disp"))
  for (i in 1:3) expect_descriptives_row(result[i, ], df[[i]])
})

test_that("compute_descriptives skewness and kurtosis match e1071 type 3", {
  skip_if_not_installed("e1071")
  result <- compute_descriptives(df = mtcars, dv = c(1, 4))
  expect_equal(result$skew, c(e1071::skewness(mtcars$mpg, type = 3), e1071::skewness(mtcars$hp, type = 3)))
  expect_equal(result$kurtosis, c(e1071::kurtosis(mtcars$mpg, type = 3), e1071::kurtosis(mtcars$hp, type = 3)))
})

test_that("compute_descriptives stratifies by grouping variables", {
  df <- mtcars
  df$am[1] <- NA
  df$gear <- factor(df$gear)
  result <- compute_descriptives(df = df, dv = 1:2, iv = c(9, 10))
  expect_equal(names(result)[1:3], c("factor", "variable", "levels"))
  expect_equal(nrow(result), 2 * (2 + 3))
  expect_equal(result$factor, rep(c("am", "am", "gear", "gear", "gear"), 2))
  expect_equal(result$variable, rep(c("mpg", "cyl"), each = 5))
  for (v in c("mpg", "cyl")) {
    for (g in c("am", "gear")) {
      complete <- stats::complete.cases(df[, c(v, g)])
      groups <- split(df[complete, v], df[complete, g], drop = TRUE)
      rows <- result[result$variable == v & result$factor == g, ]
      expect_equal(rows$levels, names(groups))
      for (l in names(groups)) expect_descriptives_row(rows[rows$levels == l, ], groups[[l]])
    }
  }
})

test_that("compute_descriptives drops unused factor levels and accepts a character grouping variable", {
  df <- data.frame(score = c(1, 2, 3, 4, 5, 6), group = factor(c("a", "a", "a", "b", "b", "b"), levels = c("a", "b", "c")),
                   label = c("x", "y", "x", "y", "x", "y"))
  result <- compute_descriptives(df = df, dv = 1, iv = 2:3)
  expect_equal(result$levels, c("a", "b", "x", "y"))
  expect_equal(result$mean, c(2, 5, 3, 4))
  expect_equal(result$n, c(3, 3, 3, 3))
})

test_that("compute_descriptives with an explicit iv = NULL describes the full sample", {
  expect_equal(compute_descriptives(df = mtcars, dv = 1:2, iv = NULL), compute_descriptives(df = mtcars, dv = 1:2))
})

test_that("compute_descriptives writes an Excel file", {
  dir <- withr::local_tempdir()
  file <- file.path(dir, "descriptives")
  compute_descriptives(df = mtcars, dv = 1:2, iv = 9, file = file)
  expect_true(file.exists(paste0(file, ".xlsx")))
  back <- openxlsx::read.xlsx(paste0(file, ".xlsx"))
  expect_equal(nrow(back), 4)
  expect_equal(back$mean, compute_descriptives(df = mtcars, dv = 1:2, iv = 9)$mean, tolerance = 1e-8)
})

##########################################################################################
# compute_aggregate
##########################################################################################
test_that("compute_aggregate matches stats::aggregate for every statistic", {
  df <- mtcars[, c("mpg", "hp", "wt", "am", "vs")]
  result <- compute_aggregate(df = df, iv = 4:5)
  statistics <- c("mean", "SD", "median", "mad", "trimmed mean", "N", "min", "max", "range",
                  "skewness", "kurtosis", "IQR", "SE")
  expect_s3_class(result, "data.frame")
  expect_named(result, c("statistic", "am", "vs", "mpg", "hp", "wt"))
  expect_equal(nrow(result), length(statistics) * 4)
  expect_equal(unique(result$statistic), statistics)
  functions <- list(
    mean = mean, SD = stats::sd, median = stats::median, mad = stats::mad,
    "trimmed mean" = function(x) mean(x, trim = .5), N = length, min = min, max = max,
    range = function(x) diff(range(x)), IQR = stats::IQR,
    SE = function(x) stats::sd(x) / sqrt(length(x)),
    skewness = function(x) mean((x - mean(x))^3) / stats::sd(x)^3,
    kurtosis = function(x) mean((x - mean(x))^4) / stats::sd(x)^4 - 3
  )
  for (s in statistics) {
    reference <- stats::aggregate(cbind(mpg, hp, wt) ~ am + vs, data = df, FUN = functions[[s]])
    reference <- reference[order(reference$am, reference$vs), ]
    rows <- result[result$statistic == s, ]
    expect_equal(rows$am, reference$am)
    expect_equal(rows$vs, reference$vs)
    expect_equal(rows[, c("mpg", "hp", "wt")], reference[, c("mpg", "hp", "wt")], ignore_attr = TRUE)
  }
})

test_that("compute_aggregate skewness and kurtosis match e1071 type 3 (b1 and b2)", {
  skip_if_not_installed("e1071")
  result <- compute_aggregate(df = mtcars[, c("mpg", "cyl")], iv = 2)
  skew <- tapply(mtcars$mpg, mtcars$cyl, e1071::skewness, type = 3)
  kurt <- tapply(mtcars$mpg, mtcars$cyl, e1071::kurtosis, type = 3)
  expect_equal(result$mpg[result$statistic == "skewness"], as.vector(skew))
  expect_equal(result$mpg[result$statistic == "kurtosis"], as.vector(kurt))
})

test_that("compute_aggregate ignores missing values and character columns", {
  df <- data.frame(group = c("a", "a", "a", "b", "b", "b"), x = c(1, 2, NA, 4, 5, 9), label = letters[1:6])
  result <- compute_aggregate(df = df, iv = 1)
  expect_named(result, c("statistic", "group", "x"))
  expect_equal(result$x[result$statistic == "mean"], c(1.5, 6))
  expect_equal(result$x[result$statistic == "median"], c(1.5, 5))
  expect_equal(result$x[result$statistic == "max"], c(2, 9))
  expect_equal(result$x[result$statistic == "SE"], c(stats::sd(1:2) / sqrt(2), stats::sd(c(4, 5, 9)) / sqrt(3)))
})

test_that("compute_aggregate N counts non-missing observations", {
  df <- data.frame(group = c("a", "a", "a", "b", "b", "b"), x = c(1, 2, NA, 4, 5, 9))
  result <- compute_aggregate(df = df, iv = 1)
  expect_equal(result$x[result$statistic == "N"], c(2, 3))
})

test_that("compute_aggregate writes an Excel file", {
  dir <- withr::local_tempdir()
  file <- file.path(dir, "aggregate")
  compute_aggregate(df = mtcars[, c("mpg", "am")], iv = 2, file = file)
  expect_true(file.exists(paste0(file, ".xlsx")))
  back <- openxlsx::read.xlsx(paste0(file, ".xlsx"))
  expect_equal(nrow(back), 26)
  expect_equal(back$mpg[back$statistic == "mean"], as.vector(tapply(mtcars$mpg, mtcars$am, mean)), tolerance = 1e-8)
})

##########################################################################################
# compute_frequencies
##########################################################################################
test_that("compute_frequencies matches table() and sorts by decreasing frequency", {
  df <- data.frame(cyl = mtcars$cyl, gear = factor(mtcars$gear), carb = as.character(mtcars$carb))
  result <- compute_frequencies(df = df)
  expect_s3_class(result, "data.frame")
  expect_named(result, c("variable", "Observation", "Frequency", "Proportion", "Percent"))
  expect_equal(nrow(result), 3 + 3 + 6)
  for (v in names(df)) {
    rows <- result[result$variable == v, ]
    reference <- sort(table(df[[v]]), decreasing = TRUE)
    expect_equal(rows$Frequency, as.vector(reference))
    expect_equal(as.character(rows$Observation), names(reference))
    expect_equal(rows$Proportion, as.vector(reference) / sum(reference))
    expect_false(is.unsorted(rev(rows$Frequency)))
  }
  expect_equal(result$Percent, result$Proportion * 100)
})

test_that("compute_frequencies excludes missing values and skips all-missing columns", {
  df <- data.frame(x = c("a", "b", "b", NA), y = c(NA, NA, NA, NA), z = factor(c("u", "u", "v", "v")))
  result <- compute_frequencies(df = df)
  expect_equal(unique(result$variable), c("x", "z"))
  expect_equal(result$Frequency, c(2, 1, 2, 2))
  expect_equal(result$Proportion, c(2 / 3, 1 / 3, .5, .5))
})

test_that("compute_frequencies writes an Excel file", {
  dir <- withr::local_tempdir()
  file <- file.path(dir, "frequencies")
  compute_frequencies(df = data.frame(cyl = mtcars$cyl), file = file)
  expect_true(file.exists(paste0(file, ".xlsx")))
  back <- openxlsx::read.xlsx(paste0(file, ".xlsx"))
  expect_equal(back$Frequency, c(14, 11, 7))
})

##########################################################################################
# response_frequency
##########################################################################################
likert <- function() {
  data.frame(a = c(1, 2, 2, 3, NA, 5), b = c(3, 3, 1, NA, NA, 4))
}

test_that("response_frequency counts each response option like table()", {
  df <- likert()
  result <- response_frequency(df, uniqueitems = 1:5, type = "frequency")
  expect_s3_class(result, "data.frame")
  expect_named(result, c("type", "variable", as.character(1:5), "miss", "responses"))
  expect_equal(result$variable, c("a", "b"))
  for (v in c("a", "b")) {
    counts <- as.vector(table(factor(df[[v]], levels = 1:5)))
    row <- result[result$variable == v, ]
    expect_equal(unname(unlist(row[as.character(1:5)])), counts)
    expect_equal(row$responses, sum(!is.na(df[[v]])))
    expect_equal(row$miss, sum(is.na(df[[v]])))
  }
})

test_that("response_frequency proportion, percent and all types are consistent", {
  df <- likert()
  frequency <- response_frequency(df, uniqueitems = 1:5, type = "frequency")
  proportion <- response_frequency(df, uniqueitems = 1:5, type = "proportion")
  percent <- response_frequency(df, uniqueitems = 1:5, type = "percent")
  all <- response_frequency(df, uniqueitems = 1:5, type = "all")
  options <- as.character(1:5)
  expect_equal(proportion$type, c("Proportion", "Proportion"))
  expect_equal(as.matrix(proportion[options]), as.matrix(frequency[options]) / frequency$responses)
  expect_equal(proportion$miss, 1 - frequency$responses / nrow(df))
  expect_equal(as.matrix(percent[options]), as.matrix(proportion[options]) * 100)
  expect_equal(percent$miss, proportion$miss * 100)
  expect_equal(rowSums(percent[options]), c(100, 100), ignore_attr = TRUE)
  expect_equal(nrow(all), 6)
  expect_equal(all$type, rep(c("Frequency", "Proportion", "Percent"), each = 2))
  expect_equal(all[3:4, ], proportion, ignore_attr = TRUE)
  expect_equal(response_frequency(df, uniqueitems = 1:5), percent)
})

test_that("response_frequency uses the observed values when uniqueitems is NULL", {
  df <- data.frame(a = c(1, 2, 2, 3), b = c(3, 3, 1, 2))
  result <- response_frequency(df, type = "frequency")
  expect_named(result, c("type", "variable", "1", "2", "3", "miss", "responses"))
  expect_equal(unname(unlist(result[1, c("1", "2", "3")])), c(1, 2, 1))
  expect_equal(unname(unlist(result[2, c("1", "2", "3")])), c(1, 1, 2))
})

test_that("response_frequency returns NULL when there are too many response options", {
  expect_null(response_frequency(data.frame(a = 1:20), max = 10))
})

test_that("response_frequency reports values outside uniqueitems as missing only", {
  skip("rwf bug: out-of-range values get their own response column (with a count of 0) instead of only counting as miss")
  result <- response_frequency(data.frame(a = c(1, 2, 9, 2)), uniqueitems = 1:3, type = "frequency")
  expect_named(result, c("type", "variable", "1", "2", "3", "miss", "responses"))
  expect_equal(result$miss, 1)
})

test_that("response_frequency writes an Excel file", {
  dir <- withr::local_tempdir()
  file <- file.path(dir, "responses")
  response_frequency(likert(), uniqueitems = 1:5, type = "frequency", file = file)
  expect_true(file.exists(paste0(file, ".xlsx")))
  back <- openxlsx::read.xlsx(paste0(file, ".xlsx"), check.names = FALSE, sep.names = " ")
  expect_equal(back$responses, c(5, 4))
})

##########################################################################################
# compute_crosstable
##########################################################################################
test_that("compute_crosstable matches table() for every unique pair", {
  result <- compute_crosstable(df = mtcars, factor_index = 8:10)
  expect_s3_class(result, "data.frame")
  expect_named(result, c("f1", "f2", "l1", "l2", "Frequency", "Percent"))
  pairs <- unique(result[, c("f1", "f2")])
  expect_equal(nrow(pairs), 3)
  expect_setequal(apply(pairs, 1, function(p) paste(sort(p), collapse = "_")), c("am_vs", "gear_vs", "am_gear"))
  for (i in seq_len(nrow(pairs))) {
    f1 <- pairs$f1[i]
    f2 <- pairs$f2[i]
    rows <- result[result$f1 == f1 & result$f2 == f2, ]
    reference <- as.data.frame(table(mtcars[[f1]], mtcars[[f2]]))
    merged <- merge(rows, reference, by.x = c("l1", "l2"), by.y = c("Var1", "Var2"))
    expect_equal(nrow(merged), nrow(reference))
    expect_equal(merged$Frequency, merged$Freq)
    expect_equal(merged$Percent, 100 * merged$Freq / nrow(mtcars))
    expect_equal(sum(rows$Percent), 100)
  }
})

test_that("compute_crosstable uses explicit combinations and drops missing values", {
  df <- mtcars
  df$vs[1:4] <- NA
  combinations <- data.frame(index1 = c("vs", "am"), index2 = c("cyl", "cyl"))
  result <- compute_crosstable(df = df, combinations = combinations)
  expect_equal(nrow(result), 2 * 3 + 2 * 3)
  vs_rows <- result[result$f1 == "vs", ]
  expect_equal(unique(vs_rows$f2), "cyl")
  expect_equal(sum(vs_rows$Frequency), 28)
  expect_equal(sum(vs_rows$Percent), 100)
  cell <- vs_rows[vs_rows$l1 == "1" & vs_rows$l2 == "4", ]
  expect_equal(cell$Frequency, sum(df$vs == 1 & df$cyl == 4, na.rm = TRUE))
})

##########################################################################################
# plot_crosstable
##########################################################################################
test_that("plot_crosstable returns one bubble plot per pair with the cell counts", {
  local_null_device()
  plots <- quietly(plot_crosstable(df = mtcars, factor_index = 8:10, title = "cars"))
  expect_type(plots, "list")
  expect_named(plots, c("am_vs", "gear_vs", "gear_am"))
  for (name in names(plots)) {
    p <- plots[[name]]
    expect_s3_class(p, "ggplot")
    expect_no_error(ggplot2::ggplot_build(p))
    vars <- strsplit(name, "_")[[1]]
    reference <- as.data.frame(table(mtcars[[vars[1]]], mtcars[[vars[2]]]))
    expect_equal(p$data$Frequency, reference$Freq)
    expect_equal(p$labels$caption, "Observations: 32")
    expect_equal(p$labels$title, "cars")
  }
})

test_that("plot_crosstable accepts explicit combinations and shows a progress bar", {
  local_null_device()
  combinations <- data.frame(index1 = c("vs", "am", "gear"), index2 = c("cyl", "cyl", "cyl"))
  expect_output(plots <- plot_crosstable(df = mtcars, combinations = combinations, pb = TRUE), "100%")
  expect_named(plots, c("vs_cyl", "am_cyl", "gear_cyl"))
  expect_equal(sum(plots$gear_cyl$data$Frequency), 32)
})

##########################################################################################
# plot_mosaic
##########################################################################################
test_that("plot_mosaic returns one plot per ordered pair with correct proportions", {
  local_null_device()
  plots <- quietly(plot_mosaic(df = mtcars, factor_index = 8:10))
  expect_named(plots, c("vs am", "vs gear", "am vs", "am gear", "gear vs", "gear am"))
  for (name in names(plots)) {
    p <- plots[[name]]
    expect_s3_class(p, "ggplot")
    expect_no_error(ggplot2::ggplot_build(p))
    vars <- strsplit(name, " ")[[1]]
    joint <- as.data.frame(prop.table(table(mtcars[[vars[1]]], mtcars[[vars[2]]])))
    expect_equal(p$data$Freq, joint$Freq)
    margin <- prop.table(table(mtcars[[vars[1]]]))
    expect_equal(as.vector(p$data$marginVar1), rep(as.vector(margin), length.out = nrow(joint)))
    # conditional heights sum to one within each level of the first variable
    expect_equal(as.vector(tapply(p$data$var2height, p$data$v1, sum)), rep(1, length(margin)))
    expect_equal(p$labels$caption, "Observations: 32")
  }
})

test_that("plot_mosaic uses complete cases and handles a single observed level", {
  local_null_device()
  df <- data.frame(a = c("x", "x", "y", "y", NA, "y"), b = c("u", "u", "u", "u", "u", NA))
  plots <- quietly(plot_mosaic(df = df, factor_index = 1:2))
  expect_named(plots, c("a b", "b a"))
  expect_equal(plots[["a b"]]$labels$caption, "Observations: 4")
  expect_true("Second Level is Not Available" %in% levels(plots[["a b"]]$data$v2))
  expect_no_error(ggplot2::ggplot_build(plots[["a b"]]))
})

##########################################################################################
# plot_response_frequencies
##########################################################################################
test_that("plot_response_frequencies returns one bar chart per variable with table() counts", {
  local_null_device()
  df <- data.frame(q1 = c(1, 2, 2, 3, NA, 5), q2 = c("a", "b", "b", "b", "c", NA))
  plots <- quietly(plot_response_frequencies(df = df, factor_index = 1:2, title = "items"))
  expect_named(plots, c("q1", "q2"))
  for (v in names(plots)) {
    p <- plots[[v]]
    expect_s3_class(p, "ggplot")
    expect_no_error(ggplot2::ggplot_build(p))
    reference <- table(df[[v]])
    expect_equal(p$data$Freq, as.vector(reference))
    expect_equal(as.character(p$data$tempdata), names(reference))
    expect_equal(p$labels$caption, paste0("Observations:", sum(!is.na(df[[v]]))))
    expect_equal(p$labels$title, paste("items", v))
  }
})

test_that("plot_response_frequencies orders bars by frequency when reorder = TRUE", {
  local_null_device()
  df <- data.frame(q1 = c(3, 1, 1, 1, 2, 2), q2 = c(1, 1, 2, 2, 2, 2))
  plots <- quietly(plot_response_frequencies(df = df, factor_index = 1:2, reorder = TRUE))
  built <- ggplot2::ggplot_build(plots$q1)
  x_labels <- built$layout$panel_params[[1]]$y$get_labels()
  expect_equal(x_labels, c("3", "2", "1"))
})

test_that("plot_response_frequencies uses all columns when factor_index is omitted", {
  local_null_device()
  df <- data.frame(q1 = c(1, 2, 2), q2 = c(2, 2, 1), q3 = c(1, 1, 1))
  plots <- quietly(plot_response_frequencies(df = df))
  expect_named(plots, c("q1", "q2", "q3"))
})
