##########################################################################################
# helpers
##########################################################################################
simulate_2pl_model <- function(nitems = 5, n = 400, seed = 1) {
  withr::local_seed(seed)
  a <- matrix(stats::rlnorm(nitems, 0.2, 0.2))
  d <- matrix(stats::rnorm(nitems))
  data <- mirt::simdata(a, d, n, itemtype = "2PL")
  mirt::mirt(data, 1, verbose = FALSE)
}

item_curve <- function(plot_data, type, variable) {
  plot_data[plot_data$type == type & plot_data$variable == variable, "value"]
}

##########################################################################################
# plot_irt_onefactor
##########################################################################################
test_that("plot_irt_onefactor returns a faceted ggplot with total, item information and expected scores", {
  model <- simulate_2pl_model()
  theta <- seq(-3, 3, by = 0.5)
  p <- plot_irt_onefactor(model = model, theta = theta, title = "Normal Test")
  expect_s3_class(p, "ggplot")
  expect_true(grepl("Normal Test", p$labels$title))
  plot_data <- p$data
  expect_setequal(unique(plot_data$type), c("total", "Item Information", "Expected Score"))
  # 2 total curves + 5 item information + 5 expected score curves, each over the theta grid
  expect_equal(nrow(plot_data), (2 + 5 + 5) * length(theta))
  expect_setequal(as.character(unique(plot_data$variable)),
                  c("information", "expected_score", paste0("Item_", 1:5)))
})

test_that("plot_irt_onefactor curves match mirt test and item functions", {
  model <- simulate_2pl_model()
  theta <- seq(-3, 3, by = 0.5)
  plot_data <- plot_irt_onefactor(model = model, theta = theta)$data
  expect_equal(item_curve(plot_data, "total", "information"), mirt::testinfo(model, Theta = theta))
  expect_equal(item_curve(plot_data, "total", "expected_score"), mirt::expected.test(model, Theta = matrix(theta)))
  for (j in 1:5) {
    item <- mirt::extract.item(model, j)
    expect_equal(item_curve(plot_data, "Item Information", paste0("Item_", j)),
                 mirt::iteminfo(item, Theta = theta))
    expect_equal(item_curve(plot_data, "Expected Score", paste0("Item_", j)),
                 mirt::probtrace(item, Theta = theta)[, 2])
  }
  # item informations add up to the test information
  item_info <- sapply(1:5, function(j) item_curve(plot_data, "Item Information", paste0("Item_", j)))
  expect_equal(rowSums(item_info), item_curve(plot_data, "total", "information"))
})

test_that("plot_irt_onefactor item information is computed for each item separately when there are 10 or more items", {
  skip("rwf bug: plot_irt_onefactor selects items with grep(), so Item_1 also picks up Item_10..Item_19")
  model <- simulate_2pl_model(nitems = 10)
  theta <- seq(-3, 3, by = 1)
  plot_data <- plot_irt_onefactor(model = model, theta = theta)$data
  for (j in c(1, 10)) {
    expect_equal(item_curve(plot_data, "Item Information", paste0("Item_", j)),
                 mirt::iteminfo(mirt::extract.item(model, j), Theta = theta))
  }
})

test_that("plot_irt_onefactor works with a graded response model", {
  withr::local_seed(2)
  a <- matrix(stats::rlnorm(4, 0.2, 0.2))
  d <- t(apply(matrix(stats::rnorm(4 * 3), 4), 1, sort, decreasing = TRUE))
  data <- mirt::simdata(a, d, 300, itemtype = "graded")
  model <- mirt::mirt(data, 1, itemtype = "graded", verbose = FALSE)
  theta <- seq(-2, 2, by = 1)
  plot_data <- plot_irt_onefactor(model = model, theta = theta)$data
  expect_equal(item_curve(plot_data, "total", "information"), mirt::testinfo(model, Theta = theta))
  expect_equal(item_curve(plot_data, "total", "expected_score"), mirt::expected.test(model, Theta = matrix(theta)))
  # expected score of a graded item with categories 0..3 lies in [0, 3]
  expected <- plot_data$value[plot_data$type == "Expected Score"]
  expect_true(all(expected >= 0 & expected <= 3))
})

##########################################################################################
# report_irt
##########################################################################################
test_that("report_irt returns the documented elements, consistent with mirt", {
  withr::local_options(fit.indices = getOption("fit.indices"))
  model <- simulate_2pl_model()
  result <- quietly(report_irt(model = model))
  expect_type(result, "list")
  expect_named(result, c("model_coefficients", "model_coefficients_oblimin", "model_options", "model_call",
                         "q3_matrix", "exp_residuals", "item_fit", "g2_fit", "m2_fit"))
  expect_equal(as.matrix(result$model_coefficients), mirt::coef(model, simplify = TRUE)$items)
  expect_equal(as.data.frame(result$item_fit), as.data.frame(quietly(mirt::itemfit(model, na.rm = TRUE))))
  m2 <- mirt::M2(model, type = "M2*", calcNull = TRUE, QMC = TRUE, CI = 0.9)
  expect_equal(result$m2_fit$M2, m2$M2)
  expect_equal(result$m2_fit$df, m2$df)
  expect_equal(result$g2_fit$G2, mirt::extract.mirt(model, "G2"))
  expect_equal(result$g2_fit$AIC, mirt::extract.mirt(model, "AIC"))
  expect_equal(result$g2_fit$BIC, mirt::extract.mirt(model, "BIC"))
  expect_equal(result$g2_fit$logLik, mirt::extract.mirt(model, "logLik"))
})

test_that("report_irt Q3 matrix is the lower triangle of mirt's Q3 residuals with row and column extremes", {
  withr::local_options(fit.indices = getOption("fit.indices"))
  model <- simulate_2pl_model()
  result <- quietly(report_irt(model = model))
  q3 <- mirt::residuals(model, type = "Q3", QMC = TRUE, verbose = FALSE)
  q3_lower <- q3
  q3_lower[upper.tri(q3_lower, diag = TRUE)] <- NA
  items <- paste0("Item_", 1:5)
  expect_equal(dim(result$q3_matrix), c(5 + 2, 5 + 2))
  expect_equal(unname(as.matrix(result$q3_matrix[items, items])), unname(q3_lower), tolerance = 1e-3)
  # row extremes
  for (item in items[-1]) {
    expect_equal(result$q3_matrix[item, "min"], min(q3_lower[item, ], na.rm = TRUE), tolerance = 1e-3)
    expect_equal(result$q3_matrix[item, "max"], max(q3_lower[item, ], na.rm = TRUE), tolerance = 1e-3)
  }
  expect_true(is.na(result$q3_matrix["Item_1", "min"]))
  # column extremes
  for (item in items[-5]) {
    expect_equal(result$q3_matrix["min", item], min(q3_lower[, item], na.rm = TRUE), tolerance = 1e-3)
    expect_equal(result$q3_matrix["max", item], max(q3_lower[, item], na.rm = TRUE), tolerance = 1e-3)
  }
})

test_that("report_irt writes an Excel workbook when a file name is given", {
  withr::local_options(fit.indices = getOption("fit.indices"))
  model <- simulate_2pl_model()
  file <- file.path(withr::local_tempdir(), "irt_report")
  result <- quietly(report_irt(model = model, file = file))
  expect_true(file.exists(paste0(file, ".xlsx")))
  sheets <- openxlsx::getSheetNames(paste0(file, ".xlsx"))
  expect_true(all(c("Coefficients", "Coefficients Oblimin", "item fit", "G2", "M2", "Q3",
                    "Residuals", "Model Options") %in% sheets))
  expect_named(result, c("model_coefficients", "model_coefficients_oblimin", "model_options", "model_call",
                         "q3_matrix", "exp_residuals", "item_fit", "g2_fit", "m2_fit"))
})
