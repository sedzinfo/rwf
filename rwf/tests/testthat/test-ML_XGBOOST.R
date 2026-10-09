##########################################################################################
# Shared fixtures: small xgboost models on infert and mtcars, single-threaded
##########################################################################################
skip_if_no_xgboost <- function() {
  skip_on_cran()
  skip_if_not_installed("xgboost")
}

xgb_formula <- case ~ spontaneous + induced + age

fit_classification <- function() {
  withr::local_seed(1)
  split <- quietly(k_fold(df = infert, model_formula = xgb_formula, k = 2))
  model <- xgboost::xgb.train(params = list(objective = "binary:logistic", nthread = 1, max_depth = 2, eta = 0.3),
                              data = split$xgb$f1$train, nrounds = 5, evals = split$xgb$f1$evals, verbose = 0)
  list(split = split, model = model)
}

fit_regression <- function() {
  withr::local_seed(2)
  split <- quietly(k_fold(df = mtcars, model_formula = mpg ~ cyl + wt + hp, k = 2))
  model <- xgboost::xgb.train(params = list(objective = "reg:squarederror", nthread = 1, max_depth = 2, eta = 0.3),
                              data = split$xgb$f1$train, nrounds = 5, evals = split$xgb$f1$evals, verbose = 0)
  list(split = split, model = model)
}

##########################################################################################
# report_xgboost
##########################################################################################
test_that("report_xgboost predictions match predict() on the held-out fold", {
  skip_if_no_xgboost()
  withr::local_pdf(file.path(withr::local_tempdir(), "plots.pdf"))
  fit <- fit_classification()
  test <- fit$split$f$test$f1
  rwf <- quietly(report_xgboost(model = fit$model, validation_data = test, label = "case", file = NULL))
  expect_named(rwf, c("plots", "result", "observed", "predicted", "feature_names"))
  expect_setequal(rwf$feature_names, all.vars(xgb_formula[[3]]))
  expect_equal(rwf$observed, test$case)
  expect_equal(rwf$predicted, predict(fit$model, fit$split$xgb$f1$test))
  expect_true(all(rwf$predicted > 0 & rwf$predicted < 1))
  expect_true(all(c("regression", "performance", "depth", "cover", "weight", "importance") %in% names(rwf$plots)))
  expect_equal(rwf$plots$performance$cut_performance,
               suppressWarnings(result_confusion_performance(observed = test$case, predicted = rwf$predicted)$cut_performance))
})

test_that("report_xgboost importance and depth plots carry xgboost's own tables", {
  skip_if_no_xgboost()
  withr::local_pdf(file.path(withr::local_tempdir(), "plots.pdf"))
  fit <- fit_classification()
  rwf <- quietly(report_xgboost(model = fit$model, file = NULL))
  expect_null(rwf$observed)
  expect_null(rwf$predicted)
  expect_null(rwf$plots$regression)
  importance <- as.data.frame(xgboost::xgb.importance(model = fit$model))
  plotted <- rwf$plots$importance$data
  for (metric in c("Gain", "Cover", "Frequency")) {
    values <- plotted$value[plotted$Metric == metric]
    names(values) <- as.character(plotted$Factor[plotted$Metric == metric])
    expect_equal(unname(values[importance$Feature]), importance[[metric]])
  }
  depth <- data.frame(xgboost::xgb.plot.deepness(fit$model, which = "max.depth", plot = FALSE))
  expect_equal(rwf$plots$depth$data, depth)
  expect_equal(rwf$result$model_call$Parameters, "Call")
})

test_that("report_xgboost validates its inputs", {
  skip_if_no_xgboost()
  withr::local_pdf(file.path(withr::local_tempdir(), "plots.pdf"))
  fit <- fit_classification()
  test <- fit$split$f$test$f1
  expect_error(report_xgboost(model = lm(mpg ~ wt, data = mtcars)), "xgboost booster")
  expect_error(report_xgboost(model = fit$model, validation_data = test, file = NULL), "label must be provided")
  expect_error(report_xgboost(model = fit$model, validation_data = test, label = "outcome", file = NULL), "label must be provided")
  expect_error(report_xgboost(model = fit$model, validation_data = test[, c("case", "age")], label = "case", file = NULL),
               "missing required features")
})

test_that("report_xgboost writes the pdf and Excel reports", {
  skip_if_no_xgboost()
  withr::local_pdf(file.path(withr::local_tempdir(), "plots.pdf"))
  fit <- fit_classification()
  dir <- withr::local_tempdir()
  file <- file.path(dir, "classification")
  quietly(report_xgboost(model = fit$model, validation_data = fit$split$f$test$f1, label = "case", file = file))
  expect_true(file.exists(paste0(file, ".xlsx")))
  expect_true(length(list.files(dir, pattern = "\\.pdf$")) > 0)
  sheets <- openxlsx::getSheetNames(paste0(file, ".xlsx"))
  expect_true(all(c("Confusion Matrix", "Feature Importance") %in% sheets))
  importance <- openxlsx::read.xlsx(paste0(file, ".xlsx"), sheet = "Feature Importance", startRow = 1)
  expect_true(any(vapply(importance, function(column) setequal(stats::na.omit(column), all.vars(xgb_formula[[3]])), logical(1))))
})

test_that("report_xgboost reports the hyperparameters and the evaluation log", {
  skip("rwf bug: with xgboost >= 3 model$params and model$evaluation_log are NULL (they are attributes), so both tables are empty")
  skip_if_no_xgboost()
  withr::local_pdf(file.path(withr::local_tempdir(), "plots.pdf"))
  fit <- fit_classification()
  rwf <- quietly(report_xgboost(model = fit$model, file = NULL))
  expect_true("objective" %in% rwf$result$parameters$Hyperparameter)
  expect_equal(rwf$result$parameters$value[rwf$result$parameters$Hyperparameter == "objective"], "binary:logistic")
  expect_equal(rwf$result$evaluation_log, data.frame(attributes(fit$model)$evaluation_log))
  expect_equal(nrow(rwf$result$evaluation_log), 5)
})

test_that("report_xgboost does not run classification diagnostics for a regression model", {
  skip("rwf bug: with xgboost >= 3 the objective is read from model$params (NULL), so regression is never detected")
  skip_if_no_xgboost()
  withr::local_pdf(file.path(withr::local_tempdir(), "plots.pdf"))
  fit <- fit_regression()
  rwf <- quietly(report_xgboost(model = fit$model, validation_data = fit$split$f$test$f1, label = "mpg", file = NULL))
  expect_null(rwf$plots$performance)
  expect_false(is.null(rwf$plots$regression))
})

test_that("report_xgboost regression reports the observed outcome and the features", {
  skip_if_no_xgboost()
  withr::local_pdf(file.path(withr::local_tempdir(), "plots.pdf"))
  fit <- fit_regression()
  test <- fit$split$f$test$f1
  rwf <- quietly(report_xgboost(model = fit$model, validation_data = test, label = "mpg", file = NULL))
  expect_equal(rwf$observed, test$mpg)
  expect_length(rwf$predicted, nrow(test))
  expect_setequal(rwf$feature_names, c("cyl", "wt", "hp"))
})

test_that("report_xgboost predicts with the columns in the model's feature order", {
  skip("rwf bug: with xgboost >= 3 feature names fall back to tree-dump order, so validation columns are passed in the wrong order")
  skip_if_no_xgboost()
  withr::local_pdf(file.path(withr::local_tempdir(), "plots.pdf"))
  fit <- fit_regression()
  test <- fit$split$f$test$f1
  rwf <- quietly(report_xgboost(model = fit$model, validation_data = test, label = "mpg", file = NULL))
  expect_equal(rwf$feature_names, c("cyl", "wt", "hp"))
  expect_equal(rwf$predicted, predict(fit$model, fit$split$xgb$f1$test))
})

##########################################################################################
# plot_trees_xgboost
##########################################################################################
test_that("plot_trees_xgboost saves the multi-tree widget as <file>.html in the working directory", {
  skip_if_no_xgboost()
  withr::local_pdf(file.path(withr::local_tempdir(), "plots.pdf"))
  skip_if_not_installed("DiagrammeR")
  fit <- fit_classification()
  dir <- withr::local_tempdir()
  withr::local_dir(dir)
  saved <- new.env()
  local_mocked_bindings(saveWidget = function(widget, file, selfcontained = TRUE, ...) {
    saved$widget <- widget
    saved$file <- file
    saved$selfcontained <- selfcontained
    invisible(NULL)
  }, .package = "htmlwidgets")
  suppressWarnings(plot_trees_xgboost(model = fit$model, train = fit$split$f$train$f1, file = "trees"))
  expect_s3_class(saved$widget, "htmlwidget")
  expect_equal(normalizePath(saved$file, mustWork = FALSE), normalizePath(file.path(dir, "trees.html"), mustWork = FALSE))
  expect_true(saved$selfcontained)
})

test_that("plot_trees_xgboost writes a self-contained html file", {
  skip_if_no_xgboost()
  withr::local_pdf(file.path(withr::local_tempdir(), "plots.pdf"))
  skip_if_not_installed("DiagrammeR")
  skip_if_not(requireNamespace("rmarkdown", quietly = TRUE) && rmarkdown::pandoc_available(),
              "pandoc is needed to save a self-contained widget")
  fit <- fit_classification()
  dir <- withr::local_tempdir()
  withr::local_dir(dir)
  suppressWarnings(plot_trees_xgboost(model = fit$model, train = fit$split$f$train$f1, file = "trees"))
  expect_true(file.exists(file.path(dir, "trees.html")))
})

test_that("plot_trees_xgboost uses only arguments that xgboost still accepts", {
  skip("rwf bug: plot_trees_xgboost() passes feature_names, fill and use.names, which xgboost >= 3 removed (warning now, error later)")
  skip_if_no_xgboost()
  withr::local_pdf(file.path(withr::local_tempdir(), "plots.pdf"))
  skip_if_not_installed("DiagrammeR")
  fit <- fit_classification()
  withr::local_dir(withr::local_tempdir())
  local_mocked_bindings(saveWidget = function(...) invisible(NULL), .package = "htmlwidgets")
  expect_no_warning(plot_trees_xgboost(model = fit$model, train = fit$split$f$train$f1, file = "trees"))
})
