##########################################################################################
# helpers local to this file
##########################################################################################
# Sends the plots these functions print to a throw-away graphics device
local_null_device_anova_plot <- function(env = parent.frame()) {
  grDevices::pdf(NULL)
  device <- grDevices::dev.cur()
  withr::defer(if (device %in% grDevices::dev.list()) grDevices::dev.off(device), envir = env)
}

# Group summaries computed with base R, in the form Rmisc::summarySE returns them
reference_summary <- function(df, dv, groups) {
  df <- df[stats::complete.cases(df[, c(groups, dv)]), ]
  cells <- split(df[[dv]], df[groups], drop = TRUE)
  out <- data.frame(N = sapply(cells, length), mean = sapply(cells, mean), sd = sapply(cells, stats::sd))
  out$se <- out$sd / sqrt(out$N)
  out$ci <- stats::qt(0.975, out$N - 1) * out$se
  out
}

##########################################################################################
# plot_oneway
##########################################################################################
test_that("plot_oneway group summaries match base R means, sds, standard errors and t intervals", {
  local_null_device_anova_plot()
  rwf <- quietly(plot_oneway(df = mtcars, dv = c(1, 3), iv = c(2, 9)))
  expect_named(rwf, c("plot_data", "plot_data_df", "plots"))
  expect_named(rwf$plot_data, c("cyl_mpg", "am_mpg", "cyl_disp", "am_disp"))
  expect_named(rwf$plots, names(rwf$plot_data))

  for (combination in list(c("cyl", "mpg"), c("am", "mpg"), c("cyl", "disp"), c("am", "disp"))) {
    summary_table <- rwf$plot_data[[paste(combination, collapse = "_")]]
    reference <- reference_summary(mtcars, combination[2], combination[1])
    expect_equal(as.character(summary_table[[combination[1]]]), rownames(reference))
    expect_equal(summary_table$N, unname(reference$N))
    expect_equal(summary_table[[combination[2]]], unname(reference$mean))
    expect_equal(summary_table$sd, unname(reference$sd))
    expect_equal(summary_table$se, unname(reference$se))
    expect_equal(summary_table$ci, unname(reference$ci))
  }
  expect_equal(names(rwf$plot_data_df), c("cyl", "am", "mpg", "disp", "N", "sd", "se", "ci"))
  expect_equal(nrow(rwf$plot_data_df), 3 + 2 + 3 + 2)
})

test_that("plot_oneway returns buildable ggplots for every error-bar type", {
  local_null_device_anova_plot()
  for (type in c("se", "ci", "sd", "")) {
    for (order_factor in c(TRUE, FALSE)) {
      rwf <- quietly(plot_oneway(df = mtcars, dv = 1, iv = 2, type = type, order_factor = order_factor, title = "t", note = "n"))
      expect_s3_class(rwf$plots$cyl_mpg, "ggplot")
      expect_no_error(ggplot2::ggplot_build(rwf$plots$cyl_mpg))
    }
  }
})

test_that("plot_oneway drops missing values and skips IVs with a single level", {
  local_null_device_anova_plot()
  df <- mtcars
  df$mpg[1:3] <- NA
  df$constant <- "a"
  rwf <- quietly(plot_oneway(df = df, dv = 1, iv = c(2, 12)))
  reference <- reference_summary(df, "mpg", "cyl")
  expect_equal(rwf$plot_data$cyl_mpg$N, unname(reference$N))
  expect_equal(rwf$plot_data$cyl_mpg$mpg, unname(reference$mean))
  expect_null(rwf$plot_data$constant_mpg)
  expect_null(rwf$plots$constant_mpg)
  expect_equal(sum(rwf$plot_data_df$N), sum(!is.na(df$mpg)))
})

##########################################################################################
# plot_interaction
##########################################################################################
test_that("plot_interaction cell summaries match base R", {
  local_null_device_anova_plot()
  rwf <- quietly(plot_interaction(df = mtcars, dv = 1, iv = c(2, 9)))
  expect_named(rwf, c("plot_data", "plot_data_df", "plots"))
  expect_named(rwf$plot_data, c("am_cyl_mpg", "cyl_am_mpg"))
  summary_table <- rwf$plot_data$am_cyl_mpg
  reference <- reference_summary(mtcars, "mpg", c("am", "cyl"))
  reference <- reference[order(rownames(reference)), ]
  summary_table <- summary_table[order(paste(summary_table$am, summary_table$cyl, sep = ".")), ]
  expect_equal(summary_table$N, unname(reference$N))
  expect_equal(summary_table$mpg, unname(reference$mean))
  expect_equal(summary_table$sd, unname(reference$sd))
  expect_equal(summary_table$se, unname(reference$se))
  expect_equal(summary_table$ci, unname(reference$ci))
  expect_equal(names(rwf$plot_data_df), c("cyl", "am", "mpg", "N", "sd", "se", "ci"))
})

test_that("plot_interaction builds one plot per ordered IV pair and DV", {
  local_null_device_anova_plot()
  rwf <- quietly(plot_interaction(df = mtcars, dv = c(1, 3), iv = c(2, 9, 10), type = "ci"))
  expect_length(rwf$plots, 3 * 2 * 2)
  expect_true(all(c("am_cyl_mpg", "cyl_am_mpg", "gear_am_disp") %in% names(rwf$plots)))
  for (type in c("se", "sd", "")) {
    for (order_factor in c(TRUE, FALSE)) {
      single <- quietly(plot_interaction(df = mtcars, dv = 1, iv = c(9, 10), type = type, order_factor = order_factor))
      for (p in single$plots) {
        expect_s3_class(p, "ggplot")
        expect_no_error(ggplot2::ggplot_build(p))
      }
    }
  }
})

test_that("plot_interaction drops incomplete rows", {
  local_null_device_anova_plot()
  df <- mtcars
  df$mpg[c(1, 3)] <- NA
  df$am[5] <- NA
  rwf <- quietly(plot_interaction(df = df, dv = 1, iv = c(2, 9)))
  expect_equal(sum(rwf$plot_data$am_cyl_mpg$N), sum(stats::complete.cases(df[, c("mpg", "cyl", "am")])))
})

##########################################################################################
# plot_oneway_diagnostics
##########################################################################################
test_that("plot_oneway_diagnostics returns a diagnostic plot per IV-DV pair built from lm()", {
  local_null_device_anova_plot()
  rwf <- quietly(plot_oneway_diagnostics(df = mtcars, dv = 1:2, iv = 9:10))
  expect_type(rwf, "list")
  expect_named(rwf, c("am_mpg", "gear_mpg", "am_cyl", "gear_cyl"))
  expect_s4_class(rwf$am_mpg, "ggmultiplot")
  expect_length(rwf$am_mpg@plots, 6)
  for (p in rwf$am_mpg@plots) {
    expect_s3_class(p, "ggplot")
    expect_no_error(quietly(ggplot2::ggplot_build(p)))
  }
  model <- stats::lm(mpg ~ factor(am), data = mtcars)
  residual_data <- rwf$am_mpg@plots[[1]]$data
  expect_equal(residual_data$.resid, unname(stats::residuals(model)))
  expect_equal(residual_data$.fitted, unname(stats::fitted(model)))
})

test_that("plot_oneway_diagnostics drops singleton groups and missing values", {
  local_null_device_anova_plot()
  df <- mtcars
  df$mpg[c(1, 2)] <- NA
  # carb has two levels with a single observation (6 and 8)
  rwf <- quietly(plot_oneway_diagnostics(df = df, dv = 1, iv = 11))
  kept <- df[!is.na(df$mpg) & !df$carb %in% c(6, 8), ]
  model <- stats::lm(mpg ~ factor(carb), data = kept)
  residual_data <- rwf$carb_mpg@plots[[1]]$data
  expect_equal(nrow(residual_data), nrow(kept))
  expect_equal(residual_data$.resid, unname(stats::residuals(model)))
})
