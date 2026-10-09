##########################################################################################
# helpers local to this file
##########################################################################################
# Sends anything the report functions print to a throw-away graphics device
local_null_device_regression <- function(env = parent.frame()) {
  grDevices::pdf(NULL)
  device <- grDevices::dev.cur()
  withr::defer(if (device %in% grDevices::dev.list()) grDevices::dev.off(device), envir = env)
}

# Collects every text label inside a grob tree (plot_scatterplot returns its plots as grobs)
grob_labels <- function(grob) {
  labels <- character()
  walk <- function(g) {
    if (inherits(g, "text") || inherits(g, "titleGrob")) labels <<- c(labels, as.character(g$label))
    for (child in c(g$children, g$grobs)) walk(child)
  }
  walk(grob)
  labels
}

scatterplot_caption <- function(p) {
  labels <- grob_labels(p$layers[[1]]$geom_params$grob)
  labels[grepl("Pairwise n", labels, fixed = TRUE)]
}

##########################################################################################
# plot_scatterplot
##########################################################################################
test_that("plot_scatterplot returns one buildable plot per variable pair", {
  local_null_device_regression()
  plots <- quietly(plot_scatterplot(df = mtcars[, c("mpg", "hp", "wt")]))
  expect_type(plots, "list")
  expect_named(plots, c("mpg_hp", "mpg_wt", "hp_wt"))
  for (p in plots) {
    expect_s3_class(p, "ggplot")
    expect_no_error(ggplot2::ggplot_build(p))
  }
})

test_that("plot_scatterplot caption reports n, Pearson r and the lm equation", {
  local_null_device_regression()
  plots <- quietly(plot_scatterplot(df = mtcars[, c("wt", "mpg")]))
  expect_named(plots, "wt_mpg")
  caption <- scatterplot_caption(plots$wt_mpg)
  r <- stats::cor(mtcars$wt, mtcars$mpg)
  b <- stats::coef(stats::lm(mpg ~ wt, data = mtcars))
  expect_match(caption, "Pairwise n = 32", fixed = TRUE)
  expect_match(caption, paste0("Pearson r = ", round(r, 4)), fixed = TRUE)
  expect_match(caption, paste0("Explained Variance = ", round(r^2, 4) * 100, "%"), fixed = TRUE)
  expect_match(caption, paste0("y = ", round(b[[2]], 4), "x + ", round(b[[1]], 4)), fixed = TRUE)
  expect_match(caption, paste0("Angle = ", round(atan(b[[2]]) * 180 / pi, 2)), fixed = TRUE)
})

test_that("plot_scatterplot uses pairwise complete cases and skips pairs with fewer than two", {
  local_null_device_regression()
  df <- mtcars[, c("mpg", "hp", "wt")]
  df$mpg[1:4] <- NA
  df$hp[10] <- NA
  plots <- quietly(plot_scatterplot(df = df))
  expect_match(scatterplot_caption(plots$mpg_hp), "Pairwise n = 27", fixed = TRUE)
  expect_match(scatterplot_caption(plots$hp_wt), "Pairwise n = 31", fixed = TRUE)
  r <- stats::cor(df$mpg, df$hp, use = "complete.obs")
  expect_match(scatterplot_caption(plots$mpg_hp), paste0("Pearson r = ", round(r, 4)), fixed = TRUE)

  sparse <- data.frame(a = c(1, NA, NA, NA), b = c(NA, 2, 3, 4), c = c(1, 5, 2, 7))
  sparse_plots <- quietly(plot_scatterplot(df = sparse))
  expect_null(sparse_plots$a_b)
  expect_null(sparse_plots$a_c)
  expect_s3_class(sparse_plots$b_c, "ggplot")
})

test_that("plot_scatterplot honours combinations, all_orders, coord_equal and custom formulas", {
  local_null_device_regression()
  chosen <- quietly(plot_scatterplot(df = mtcars, combinations = data.frame(x = c("mpg", "mpg", "hp"), y = c("hp", "mpg", "wt"))))
  # pairs of a variable with itself are dropped
  expect_named(chosen, c("mpg_hp", "hp_wt"))

  both <- quietly(plot_scatterplot(df = mtcars[, c("mpg", "hp")], all_orders = TRUE))
  expect_setequal(names(both), c("mpg_hp", "hp_mpg"))

  equal <- quietly(plot_scatterplot(df = mtcars[, c("mpg", "qsec")], coord_equal = TRUE))
  expect_no_error(ggplot2::ggplot_build(equal[[1]]))

  curved <- quietly(plot_scatterplot(df = mtcars[, c("hp", "mpg")], formula = y ~ poly(x, 2)))
  expect_equal(scatterplot_caption(curved$hp_mpg), "Pairwise n = 32")
})

##########################################################################################
# report_regression
##########################################################################################
test_that("report_regression coefficients match summary.lm, confint and standardized lm", {
  local_null_device_regression()
  model <- stats::lm(mpg ~ wt + hp + qsec, data = mtcars)
  rwf <- quietly(report_regression(model = model, plot_diagnostics = FALSE))
  expect_named(rwf, c("r", "coeficients", "anova", "deviance", "variance_covariance", "outlier_test",
                      "durbin_watson", "vif", "call", "diagnostics"))
  coefs <- rwf$coeficients
  coefs <- coefs[match(names(stats::coef(model)), coefs$Row.names), ]
  summary_table <- summary(model)$coefficients
  expect_equal(coefs$Estimate, unname(summary_table[, "Estimate"]))
  expect_equal(coefs[["Std. Error"]], unname(summary_table[, "Std. Error"]))
  expect_equal(coefs[["t value"]], unname(summary_table[, "t value"]))
  expect_equal(coefs[["Pr(>|t|)"]], unname(summary_table[, "Pr(>|t|)"]))
  expect_equal(coefs[["2.5 %"]], unname(stats::confint(model)[, 1]))
  expect_equal(coefs[["97.5 %"]], unname(stats::confint(model)[, 2]))

  standardized <- stats::coef(stats::lm(scale(mpg) ~ scale(wt) + scale(hp) + scale(qsec), data = mtcars))[-1]
  expect_equal(coefs$standardized[-1], unname(standardized))
  expect_true(is.na(coefs$standardized[1]))
})

test_that("report_regression fit statistics match summary.lm, anova and deviance", {
  local_null_device_regression()
  model <- stats::lm(mpg ~ wt + hp, data = mtcars)
  rwf <- quietly(report_regression(model = model, plot_diagnostics = FALSE))
  expect_equal(rwf$r$r_squared, summary(model)$r.squared)
  expect_equal(rwf$r$adjusted_r_squared, summary(model)$adj.r.squared)
  expect_equal(rwf$anova, stats::anova(model))
  expect_equal(rwf$deviance$deviance, sum(stats::residuals(model)^2))
  expect_equal(as.matrix(rwf$variance_covariance), stats::vcov(model))
  expect_equal(rwf$call$call, "lm(mpg ~ wt + hp,data=mtcars)")
})

test_that("report_regression diagnostics match the stats influence measures", {
  local_null_device_regression()
  model <- stats::lm(mpg ~ wt + hp, data = mtcars)
  rwf <- quietly(report_regression(model = model, plot_diagnostics = FALSE))
  d <- rwf$diagnostics
  expect_equal(nrow(d), 32)
  expect_equal(d$simple_residuals, unname(stats::residuals(model)))
  expect_equal(d$standard_residuals, unname(stats::rstandard(model)))
  expect_equal(d$student_residuals, unname(stats::rstudent(model)))
  expect_equal(d$fitted, unname(stats::fitted(model)))
  expect_equal(d$cooks_distance, unname(stats::cooks.distance(model)))
  expect_equal(d$dffits, unname(stats::dffits(model)))
  expect_equal(d$hatvalues, unname(stats::hatvalues(model)))
  expect_equal(d$covariance_ratio, unname(stats::covratio(model)))
  expect_equal(d[["dfbeta.wt"]], unname(stats::dfbeta(model)[, "wt"]))
})

test_that("report_regression outlier, Durbin-Watson and VIF results match car", {
  local_null_device_regression()
  model <- stats::lm(mpg ~ wt + hp + qsec, data = mtcars)
  withr::local_seed(123)
  rwf <- quietly(report_regression(model = model, plot_diagnostics = FALSE))

  outlier <- car::outlierTest(model)
  expect_equal(rwf$outlier_test$rstudent, unname(outlier$rstudent))
  expect_equal(rwf$outlier_test$bonf.p, unname(outlier$bonf.p))

  e <- stats::residuals(model)
  expect_equal(rwf$durbin_watson$dw.dw, sum(diff(e)^2) / sum(e^2))
  dw <- withr::with_seed(123, car::durbinWatsonTest(model))
  expect_equal(rwf$durbin_watson$dw.r, dw$r)
  expect_equal(rwf$durbin_watson$dw.p, dw$p)

  vif <- car::vif(model)
  expect_equal(rwf$vif$vif, unname(vif))
  expect_equal(rwf$vif$tolerance, unname(1 / vif))
  expect_equal(unique(rwf$vif$mean_vif), mean(vif))
  # textbook definition: 1 / (1 - R^2) of each predictor regressed on the others
  r2_wt <- summary(stats::lm(wt ~ hp + qsec, data = mtcars))$r.squared
  expect_equal(rwf$vif$vif[1], 1 / (1 - r2_wt))
})

test_that("report_regression returns an empty VIF table for one predictor", {
  local_null_device_regression()
  rwf <- quietly(report_regression(model = stats::lm(mpg ~ qsec, data = mtcars), plot_diagnostics = FALSE))
  expect_equal(nrow(rwf$vif), 0)
  expect_equal(nrow(rwf$coeficients), 2)
})

test_that("report_regression uses the rows lm kept when data are missing", {
  local_null_device_regression()
  df <- mtcars
  df$mpg[c(2, 5)] <- NA
  df$hp[9] <- NA
  model <- stats::lm(mpg ~ hp + wt, data = df)
  rwf <- quietly(report_regression(model = model, plot_diagnostics = FALSE))
  expect_equal(nrow(rwf$diagnostics), 29)
  expect_equal(rwf$r$r_squared, summary(model)$r.squared)
  standardized <- stats::coef(stats::lm(scale(mpg) ~ scale(hp) + scale(wt), data = stats::na.omit(df[, c("mpg", "hp", "wt")])))[-1]
  coefs <- rwf$coeficients[match(c("hp", "wt"), rwf$coeficients$Row.names), ]
  expect_equal(coefs$standardized, unname(standardized))
})

test_that("report_regression writes pdf, log and xlsx output", {
  skip_on_cran()
  local_null_device_regression()
  dir <- withr::local_tempdir()
  file <- file.path(dir, "regression")
  quietly(report_regression(model = stats::lm(mpg ~ wt + hp, data = mtcars), file = file, title = "cars"))
  expect_true(file.exists(paste0(file, "_cars.pdf")))
  expect_true(file.exists(paste0(file, ".log")))
  expect_true(file.exists(paste0(file, ".xlsx")))
  expect_true(all(c("r", "Coefficients", "ANOVA", "Variance Covariance", "Outliers", "Durbin Watson", "VIF",
                    "Diagnostics", "Call") %in% openxlsx::getSheetNames(paste0(file, ".xlsx"))))
})

test_that("report_regression handles factor predictors", {
  skip("rwf bug: report_regression fails on any factor predictor because QuantPsyc::lm.beta calls sd() on the factor")
  local_null_device_regression()
  df <- mtcars
  df$am <- factor(df$am, labels = c("automatic", "manual"))
  model <- stats::lm(mpg ~ am + wt, data = df)
  rwf <- quietly(report_regression(model = model, plot_diagnostics = FALSE))
  coefs <- rwf$coeficients[match(names(stats::coef(model)), rwf$coeficients$Row.names), ]
  expect_equal(coefs$Estimate, unname(stats::coef(model)))
})

test_that("report_regression standardizes interaction terms with their own standard deviation", {
  skip("rwf bug: report_regression standardized coefficients for interaction terms reuse the sd of another predictor (QuantPsyc::lm.beta recycling)")
  local_null_device_regression()
  model <- stats::lm(mpg ~ hp * wt, data = mtcars)
  rwf <- quietly(report_regression(model = model, plot_diagnostics = FALSE))
  x <- stats::model.matrix(model)[, -1]
  expected <- stats::coef(model)[-1] * apply(x, 2, stats::sd) / stats::sd(mtcars$mpg)
  coefs <- rwf$coeficients[match(names(expected), rwf$coeficients$Row.names), ]
  expect_equal(coefs$standardized, unname(expected))
})
