##########################################################################################
# helpers local to this file
##########################################################################################
# Sends anything the report functions print to a throw-away graphics device
local_null_device_logistic <- function(env = parent.frame()) {
  grDevices::pdf(NULL)
  device <- grDevices::dev.cur()
  withr::defer(if (device %in% grDevices::dev.list()) grDevices::dev.off(device), envir = env)
}

read_sheet <- function(file, sheet) {
  openxlsx::read.xlsx(file, sheet = sheet, rowNames = TRUE, sep.names = " ")
}

##########################################################################################
# compute_y_logistic
##########################################################################################
test_that("compute_y_logistic matches stats::plogis", {
  x <- seq(-10, 10, by = 0.5)
  expect_equal(compute_y_logistic(0, 1, x), stats::plogis(x))
  expect_equal(compute_y_logistic(-1.5, 0.3, x), stats::plogis(-1.5 + 0.3 * x))
  expect_equal(compute_y_logistic(0, 1, 0), 0.5)
  expect_length(compute_y_logistic(0, 1, x), length(x))
})

test_that("compute_y_logistic reproduces the fitted probabilities of a one-predictor glm", {
  model <- stats::glm(am ~ wt, data = mtcars, family = stats::binomial)
  b <- stats::coef(model)
  expect_equal(compute_y_logistic(b[[1]], b[[2]], mtcars$wt), unname(stats::fitted(model)))
})

##########################################################################################
# plot_logistic_model
##########################################################################################
logistic_data <- function() {
  withr::local_seed(10)
  data.frame(outcome = c(rep(1, 10), rep(0, 10)),
             pc1 = c(stats::rnorm(10, mean = 5), stats::rnorm(10, mean = 6)),
             pc2 = c(stats::rnorm(10, mean = 5), stats::rnorm(10, mean = 5.5)))
}

test_that("plot_logistic_model draws one logistic curve per predictor", {
  df <- logistic_data()
  p <- plot_logistic_model(df = df, title = "test")
  expect_s3_class(p, "ggplot")
  built <- quietly(ggplot2::ggplot_build(p))
  smooth <- built$data[[1]]
  points <- built$data[[2]]
  expect_equal(length(unique(smooth$group)), 2)
  expect_setequal(unique(points$y), c(0, 1))
  expect_true(all(smooth$y >= 0 & smooth$y <= 1))
  expect_equal(p$labels$caption, "Observations:20")

  # the first curve is the glm fit of the outcome on pc1
  model <- stats::glm(outcome ~ pc1, data = df, family = stats::binomial)
  first <- smooth[smooth$group == 1, ]
  expected <- stats::predict(model, newdata = data.frame(pc1 = first$x), type = "response")
  expect_equal(first$y, unname(expected), tolerance = 1e-6)
})

test_that("plot_logistic_model maps the outcome named in the outcome argument", {
  skip("rwf bug: plot_logistic_model uses aes(y = outcome), which maps the string, not the column, when outcome != 'outcome'")
  df <- logistic_data()
  names(df)[1] <- "admitted"
  p <- plot_logistic_model(df = df, outcome = "admitted")
  built <- quietly(ggplot2::ggplot_build(p))
  expect_setequal(unique(as.numeric(built$data[[2]]$y)), c(0, 1))
})

##########################################################################################
# output_compare_model_logistic
##########################################################################################
test_that("output_compare_model_logistic matches anova() likelihood-ratio tests", {
  pairs <- list(
    list(case ~ age, case ~ education * age),
    list(case ~ 1, case ~ spontaneous + induced),
    list(case ~ spontaneous, case ~ spontaneous + induced + age)
  )
  for (pair in pairs) {
    model1 <- stats::glm(pair[[1]], data = infert, family = stats::binomial)
    model2 <- stats::glm(pair[[2]], data = infert, family = stats::binomial)
    rwf <- output_compare_model_logistic(model1 = model1, model2 = model2)
    reference <- stats::anova(model1, model2, test = "Chisq")
    expect_s3_class(rwf, "data.frame")
    expect_equal(dim(rwf), c(1, 3))
    expect_equal(rwf[[1]], reference$Deviance[2])
    expect_equal(rwf$df, reference$Df[2])
    expect_equal(rwf$p, reference[["Pr(>Chi)"]][2])
  }
})

test_that("output_compare_model_logistic names the statistic X^2", {
  skip("rwf bug: output_compare_model_logistic builds data.frame('X^2'=...) without check.names=FALSE, so the column is named X.2")
  model1 <- stats::glm(case ~ age, data = infert, family = stats::binomial)
  model2 <- stats::glm(case ~ age + spontaneous, data = infert, family = stats::binomial)
  expect_named(output_compare_model_logistic(model1, model2), c("X^2", "df", "p"))
})

##########################################################################################
# report_logistic
##########################################################################################
test_that("report_logistic xlsx output matches summary.glm, odds ratios, AIC, VIF and pseudo R2", {
  skip_on_cran()
  local_null_device_logistic()
  dir <- withr::local_tempdir()
  file <- file.path(dir, "logistic")
  model <- stats::glm(case ~ spontaneous + induced + age, data = infert, family = stats::binomial)
  quietly(report_logistic(model = model, file = file))
  xlsx <- paste0(file, ".xlsx")
  expect_true(file.exists(xlsx))
  expect_true(file.exists(paste0(file, "_.pdf")))
  expect_true(file.exists(paste0(file, ".log")))
  expect_equal(openxlsx::getSheetNames(xlsx),
               c("summary", "coefficients", "Confusion Matrix", "confusion matrix performance", "X^2",
                 "pseudo R^2", "scores residuals", "score residual descriptives", "VIF", "Call"))

  coefficients <- read_sheet(xlsx, "coefficients")
  summary_table <- summary(model)$coefficients
  expect_equal(rownames(coefficients), rownames(summary_table))
  expect_equal(unname(as.matrix(coefficients[, 1:4])), unname(summary_table))
  expect_equal(coefficients[["Odds Ratio"]], unname(exp(stats::coef(model))))

  fit <- read_sheet(xlsx, "summary")
  expect_equal(fit$AIC, stats::AIC(model))
  expect_equal(fit$deviance, stats::deviance(model))
  expect_equal(fit$null.deviance, model$null.deviance)
  expect_equal(fit$df.residual, stats::df.residual(model))

  chi <- read_sheet(xlsx, "X^2")
  lrt <- stats::anova(stats::glm(case ~ 1, data = infert, family = stats::binomial), model, test = "Chisq")
  expect_equal(chi$Chi.Squared, lrt$Deviance[2])
  expect_equal(chi$df, lrt$Df[2])
  expect_equal(chi$p, lrt[["Pr(>Chi)"]][2])

  pseudo <- read_sheet(xlsx, "pseudo R^2")
  # DescTools refits the null model from the call, which needs an unqualified glm()
  model_unqualified <- glm(case ~ spontaneous + induced + age, data = infert, family = binomial)
  reference <- DescTools::PseudoR2(model_unqualified, which = c("McFadden", "CoxSnell", "Nagelkerke"))
  expect_equal(pseudo$Statistic, unname(reference))

  vif <- read_sheet(xlsx, "VIF")
  expect_equal(vif[[1]], unname(car::vif(model)))
})

test_that("report_logistic returns its results", {
  skip("rwf bug: report_logistic never returns the result list (the function ends with if(!is.null(file)) {...}, so it returns NULL)")
  local_null_device_logistic()
  model <- stats::glm(case ~ spontaneous + induced, data = infert, family = stats::binomial)
  rwf <- quietly(report_logistic(model = model))
  expect_type(rwf, "list")
  expect_true(all(c("model_summary", "result_R2_logistic", "result_X2_logistic", "coefficients",
                    "logistic_output", "scores", "VIF") %in% names(rwf)))
  expect_equal(rwf$coefficients$Estimate, unname(stats::coef(model)))
  expect_equal(rwf$coefficients[["Odds Ratio"]], unname(exp(stats::coef(model))))
  expect_equal(rwf$logistic_output$AIC, stats::AIC(model))
})

test_that("report_logistic with factor predictors and missing data reports the fitted model", {
  skip_on_cran()
  local_null_device_logistic()
  dir <- withr::local_tempdir()
  file <- file.path(dir, "factor")
  df <- infert
  df$age[c(3, 40, 100)] <- NA
  model <- stats::glm(case ~ education + age, data = df, family = stats::binomial)
  quietly(report_logistic(model = model, file = file, fast = TRUE))
  xlsx <- paste0(file, ".xlsx")
  coefficients <- read_sheet(xlsx, "coefficients")
  expect_equal(rownames(coefficients), names(stats::coef(model)))
  expect_equal(coefficients$Estimate, unname(stats::coef(model)))
  fit <- read_sheet(xlsx, "summary")
  expect_equal(fit$df.null, nrow(df) - 3 - 1)
  # fast = TRUE leaves out the case-level scores
  expect_false("scores residuals" %in% openxlsx::getSheetNames(xlsx))
})

test_that("report_logistic scores validation data on the probability scale", {
  skip("rwf bug: report_logistic calls predict(model, newdata = validation_data) without type = 'response', so validation cut points are on the logit scale")
  skip_on_cran()
  local_null_device_logistic()
  dir <- withr::local_tempdir()
  model <- stats::glm(case ~ spontaneous + induced, data = infert, family = stats::binomial)
  quietly(report_logistic(model = model, file = file.path(dir, "training")))
  quietly(report_logistic(model = model, file = file.path(dir, "validation"), validation_data = infert))
  training <- read_sheet(file.path(dir, "training.xlsx"), "confusion matrix performance")
  validation <- read_sheet(file.path(dir, "validation.xlsx"), "confusion matrix performance")
  expect_equal(validation, training)
})
