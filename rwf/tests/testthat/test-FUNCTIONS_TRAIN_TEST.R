##########################################################################################
# Reference implementations used by the tests below
##########################################################################################
# Confusion counts with rows = predicted and columns = observed, counted one case at a time
reference_counts <- function(observed, predicted, levels) {
  counts <- matrix(0, length(levels), length(levels), dimnames = list(predicted = levels, observed = levels))
  for (i in seq_along(observed)) {
    if (is.na(observed[i]) || is.na(predicted[i])) next
    row <- as.character(predicted[i])
    col <- as.character(observed[i])
    counts[row, col] <- counts[row, col] + 1
  }
  counts
}

# Cohen's kappa from its definition, with the category order given by `levels`
reference_kappa <- function(observed, predicted, levels, weight = c("unweighted", "linear", "squared")) {
  weight <- match.arg(weight)
  k <- length(levels)
  o <- match(as.character(observed), levels)
  p <- match(as.character(predicted), levels)
  keep <- !is.na(o) & !is.na(p)
  proportions <- table(factor(o[keep], levels = 1:k), factor(p[keep], levels = 1:k)) / sum(keep)
  distance <- abs(outer(1:k, 1:k, "-"))
  w <- switch(weight,
              unweighted = (distance == 0) * 1,
              linear = 1 - distance / (k - 1),
              squared = 1 - distance^2 / (k - 1)^2)
  po <- sum(w * proportions)
  pe <- sum(w * outer(rowSums(proportions), colSums(proportions)))
  (po - pe) / (1 - pe)
}

# Area under the ROC curve as the Mann-Whitney probability P(case score > control score)
reference_auc <- function(observed, predicted, case) {
  cases <- predicted[observed == case]
  controls <- predicted[observed != case]
  mean(outer(cases, controls, ">") + 0.5 * outer(cases, controls, "=="))
}

# confusion_matrix_percent() returns formatted text; turn it back into a numeric matrix
as_numeric_matrix <- function(cmp) {
  m <- sapply(cmp, function(x) as.numeric(as.character(x)))
  rownames(m) <- rownames(cmp)
  m
}

observed_3 <- c(1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 3, 3)
predicted_3 <- c(1, 2, 3, 2, 2, 1, 1, 3, 3, 1, 2, 2, 3, 3)

##########################################################################################
# confusion
##########################################################################################
test_that("confusion counts every case and puts predicted in rows and observed in columns", {
  rwf <- confusion(observed = observed_3, predicted = predicted_3)
  expect_s3_class(rwf, "table")
  expect_named(dimnames(rwf), c("predicted", "observed"))
  expect_equal(unclass(rwf), reference_counts(observed_3, predicted_3, c("1", "2", "3")), ignore_attr = "class")
  expect_equal(sum(rwf), length(observed_3))
  # an asymmetric case pins the orientation: observed 3 predicted as 1 sits in row 1, column 3
  expect_equal(rwf["1", "3"], 1)
  expect_equal(rwf["3", "1"], 0)
})

test_that("confusion matches the table of caret::confusionMatrix", {
  skip_if_not_installed("caret")
  levels <- c("1", "2", "3")
  cm <- caret::confusionMatrix(data = factor(predicted_3, levels = levels),
                               reference = factor(observed_3, levels = levels))
  rwf <- confusion(observed = observed_3, predicted = predicted_3)
  expect_equal(dimnames(rwf), list(predicted = levels, observed = levels))
  expect_equal(unname(matrix(rwf, 3)), unname(matrix(cm$table, 3)))
})

test_that("confusion uses the union of observed and predicted classes", {
  rwf <- confusion(observed = c(1, 2, 3, 4, 5, 10), predicted = c(1, 2, 3, 4, 5, 11))
  expect_equal(rownames(rwf), c("1", "2", "3", "4", "5", "10", "11"))
  expect_equal(colnames(rwf), rownames(rwf))
  expect_equal(rwf["11", "10"], 1)
  expect_equal(sum(rwf["10", ]), 0)
  expect_equal(sum(rwf[, "11"]), 0)
})

test_that("confusion sorts string labels like '10' and '11' naturally", {
  rwf <- confusion(observed = c("10", "2", "11", "2"), predicted = c("2", "10", "11", "2"))
  expect_equal(rownames(rwf), c("2", "10", "11"))
  expect_equal(colnames(rwf), c("2", "10", "11"))
  expect_equal(unclass(rwf), reference_counts(c("10", "2", "11", "2"), c("2", "10", "11", "2"), c("2", "10", "11")),
               ignore_attr = "class")
})

test_that("confusion gives the same table for factor, character and numeric labels", {
  numeric_table <- confusion(observed = observed_3, predicted = predicted_3)
  expect_equal(confusion(observed = factor(observed_3), predicted = factor(predicted_3)), numeric_table)
  expect_equal(confusion(observed = as.character(observed_3), predicted = as.character(predicted_3)), numeric_table)
})

test_that("confusion with mixed numeric and factor inputs has no spurious extra level", {
  skip("rwf bug: confusion() builds levels from c(observed, predicted), which turns a factor into its integer codes")
  rwf <- confusion(observed = c(0, 0, 1, 1, 0), predicted = factor(c(0, 1, 1, 1, 0)))
  expect_equal(rownames(rwf), c("0", "1"))
  expect_equal(colnames(rwf), c("0", "1"))
  expect_equal(unclass(rwf), reference_counts(c(0, 0, 1, 1, 0), c(0, 1, 1, 1, 0), c("0", "1")), ignore_attr = "class")
  rwf <- confusion(observed = factor(c(0, 0, 1, 1, 0)), predicted = c(0, 1, 1, 1, 0))
  expect_equal(rownames(rwf), c("0", "1"))
})

test_that("confusion with a single class present is a 1 x 1 table", {
  rwf <- confusion(observed = c("a", "a", "a"), predicted = c("a", "a", "a"))
  expect_equal(dim(rwf), c(1L, 1L))
  expect_equal(rwf[["a", "a"]], 3L)
})

test_that("confusion drops pairs with a missing value", {
  observed <- c(0, NA, 1, 1, 0, 1)
  predicted <- c(0, 1, NA, 1, 1, 1)
  complete <- !is.na(observed) & !is.na(predicted)
  rwf <- confusion(observed = observed, predicted = predicted)
  expect_equal(rownames(rwf), c("0", "1"))
  expect_equal(rwf, confusion(observed = observed[complete], predicted = predicted[complete]))
  expect_equal(sum(rwf), 4)
})

##########################################################################################
# confusion_matrix_percent
##########################################################################################
test_that("confusion_matrix_percent matches hand-computed counts, precision, recall and accuracy", {
  # 2 x 2 example: TN = 3, FN = 1, FP = 1, TP = 2
  observed <- c(1, 1, 1, 0, 0, 0, 0)
  predicted <- c(1, 1, 0, 0, 0, 1, 0)
  rwf <- confusion_matrix_percent(observed = observed, predicted = predicted)
  expect_s3_class(rwf, "data.frame")
  expect_equal(dim(rwf), c(4L, 4L))
  expect_equal(rownames(rwf), c("0", "1", "sum", "p"))
  expect_equal(colnames(rwf), c("0", "1", "sum", "p"))
  m <- as_numeric_matrix(rwf)
  expect_equal(unname(m[1:2, 1:2]), matrix(c(3, 1, 1, 2), 2))
  expect_equal(unname(m["sum", 1:3]), c(4, 3, 7))
  expect_equal(unname(m[1:3, "sum"]), c(4, 3, 7))
  # "p" column = precision of each predicted class, "p" row = recall of each observed class
  expect_equal(unname(m[1:2, "p"]), round(c(3 / 4, 2 / 3), 2))
  expect_equal(unname(m["p", 1:2]), round(c(3 / 4, 2 / 3), 2))
  expect_equal(m[["p", "p"]], round(5 / 7, 2))
})

test_that("confusion_matrix_percent precision and recall match caret", {
  skip_if_not_installed("caret")
  levels <- c("1", "2", "3")
  cm <- caret::confusionMatrix(data = factor(predicted_3, levels = levels),
                               reference = factor(observed_3, levels = levels))
  m <- as_numeric_matrix(confusion_matrix_percent(observed = observed_3, predicted = predicted_3))
  expect_equal(unname(m[levels, "p"]), round(unname(cm$byClass[, "Precision"]), 2))
  expect_equal(unname(m["p", levels]), round(unname(cm$byClass[, "Recall"]), 2))
  expect_equal(m[["p", "p"]], round(unname(cm$overall["Accuracy"]), 2))
  expect_equal(unname(m[levels, levels]), unname(matrix(cm$table, 3)))
})

test_that("confusion_matrix_percent reports zero precision for a class that is never predicted", {
  m <- as_numeric_matrix(confusion_matrix_percent(observed = c("a", "b", "b", "a"), predicted = c("a", "a", "a", "a")))
  expect_equal(m[["b", "p"]], 0)
  expect_equal(m[["a", "p"]], 0.5)
  expect_equal(m[["p", "a"]], 1)
  expect_equal(m[["p", "b"]], 0)
})

test_that("confusion_matrix_percent keeps the natural order of string labels", {
  rwf <- confusion_matrix_percent(observed = c("10", "2", "11"), predicted = c("2", "10", "11"))
  expect_equal(rownames(rwf), c("2", "10", "11", "sum", "p"))
  expect_equal(colnames(rwf), c("2", "10", "11", "sum", "p"))
})

##########################################################################################
# proportion_accurate
##########################################################################################
test_that("proportion_accurate matches accuracy and Cohen's kappa computed from their definitions", {
  levels <- c("1", "2", "3")
  rwf <- proportion_accurate(observed = observed_3, predicted = predicted_3)
  expect_s3_class(rwf, "data.frame")
  expect_named(rwf, c("cm_diagonal", "cm_off_diagonal", "kappa_unweighted", "kappa_linear", "kappa_squared"))
  expect_equal(nrow(rwf), 1)
  expect_equal(rwf$cm_diagonal, mean(observed_3 == predicted_3))
  expect_equal(rwf$kappa_unweighted, reference_kappa(observed_3, predicted_3, levels, "unweighted"))
  expect_equal(rwf$kappa_linear, reference_kappa(observed_3, predicted_3, levels, "linear"))
  expect_equal(rwf$kappa_squared, reference_kappa(observed_3, predicted_3, levels, "squared"))
})

test_that("proportion_accurate off-diagonal accuracy counts predictions at most one class away", {
  observed <- c(1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 5)
  predicted <- c(1, 3, 3, 2, 5, 3, 2, 4, 1, 4, 5)
  rwf <- proportion_accurate(observed = observed, predicted = predicted)
  expect_equal(rwf$cm_off_diagonal, mean(abs(observed - predicted) <= 1))
  expect_equal(rwf$cm_diagonal, mean(observed == predicted))
})

test_that("proportion_accurate unweighted kappa matches psych::cohen.kappa", {
  ck <- suppressWarnings(psych::cohen.kappa(cbind(observed_3, predicted_3)))
  rwf <- proportion_accurate(observed = observed_3, predicted = predicted_3)
  expect_equal(rwf$kappa_unweighted, ck$kappa)
})

test_that("proportion_accurate is 1 everywhere for perfect agreement", {
  rwf <- proportion_accurate(observed = c(1, 2, 3, 1, 2, 3), predicted = c(1, 2, 3, 1, 2, 3))
  expect_equal(unlist(rwf), c(cm_diagonal = 1, cm_off_diagonal = 1, kappa_unweighted = 1, kappa_linear = 1, kappa_squared = 1))
})

test_that("proportion_accurate ignores pairs with a missing value", {
  observed <- c(observed_3, NA, 2)
  predicted <- c(predicted_3, 1, NA)
  expect_equal(proportion_accurate(observed = observed, predicted = predicted),
               proportion_accurate(observed = observed_3, predicted = predicted_3))
})

test_that("proportion_accurate weighted kappa orders numeric labels numerically", {
  skip("rwf bug: irr::kappa2(sort.levels = TRUE) sorts labels as text, so 10 and 11 fall between 1 and 2 in the weights")
  observed <- c(1, 2, 10, 11)
  predicted <- c(2, 2, 10, 10)
  levels <- c("1", "2", "10", "11")
  rwf <- proportion_accurate(observed = observed, predicted = predicted)
  expect_equal(rwf$kappa_linear, reference_kappa(observed, predicted, levels, "linear"))
  expect_equal(rwf$kappa_squared, reference_kappa(observed, predicted, levels, "squared"))
})

##########################################################################################
# plot_confusion
##########################################################################################
test_that("plot_confusion plots the confusion counts and reports the accuracy measures", {
  rwf <- plot_confusion(observed = observed_3, predicted = predicted_3, title = "x")
  expect_s3_class(rwf, "ggplot")
  counts <- reference_counts(observed_3, predicted_3, c("1", "2", "3"))
  for (i in seq_len(nrow(rwf$data))) {
    cell <- rwf$data[i, ]
    expect_equal(cell$value, counts[as.character(cell$predicted), as.character(cell$observed)])
  }
  expect_equal(sum(rwf$data$value), length(observed_3))
  pa <- proportion_accurate(observed = observed_3, predicted = predicted_3)
  caption <- rwf$labels$caption
  expect_match(caption, paste0("Observations:", length(observed_3)), fixed = TRUE)
  expect_match(caption, paste0("Accuracy:", round(mean(observed_3 == predicted_3), 2)), fixed = TRUE)
  expect_match(caption, paste0("Kappa unweighted:", round(pa$kappa_unweighted, 2)), fixed = TRUE)
  expect_match(rwf$labels$title, "Confusion Matrix x", fixed = TRUE)
})

test_that("plot_confusion works with string labels", {
  observed <- c(rep("male", 10), rep("female", 10), "male", "male")
  predicted <- c(rep("male", 10), rep("female", 10), "female", "female")
  rwf <- plot_confusion(observed = observed, predicted = predicted)
  expect_s3_class(rwf, "ggplot")
  male_as_female <- rwf$data$value[rwf$data$observed == "male" & rwf$data$predicted == "female"]
  expect_equal(male_as_female, 2)
  expect_match(rwf$labels$caption, "Observations:22", fixed = TRUE)
})

##########################################################################################
# plot_confusion_extended
##########################################################################################
pct <- function(x) paste0(sprintf("%.1f", x * 100), "%")

test_that("plot_confusion_extended cells hold the hand-computed counts and measures", {
  observed <- c(0, 0, 0, 0, 1, 1, 1, 1, 1, 1)
  predicted <- c(0, 0, 0, 1, 1, 1, 1, 1, 0, 0)
  # positive = 1: TP = 4, FP = 1, FN = 2, TN = 3
  rwf <- plot_confusion_extended(observed = observed, predicted = predicted)
  expect_s3_class(rwf, "ggplot")
  main <- rwf$data[rwf$data$kind == "main", ]
  expect_equal(main$n, c(4, 1, 2, 3))
  expect_true(any(grepl(paste0("Sensitivity\n", pct(4 / 6)), rwf$data$label, fixed = TRUE)))
  expect_true(any(grepl(paste0("Specificity\n", pct(3 / 4)), rwf$data$label, fixed = TRUE)))
  expect_true(any(grepl(paste0("Precision\n", pct(4 / 5)), rwf$data$label, fixed = TRUE)))
  expect_true(any(grepl(paste0("NPV\n", pct(3 / 5)), rwf$data$label, fixed = TRUE)))
  expect_true(any(grepl(paste0("Accuracy ", pct(7 / 10)), rwf$data$label, fixed = TRUE)))
  expect_true(any(grepl(paste0("Prevalence ", pct(6 / 10)), rwf$data$label, fixed = TRUE)))
  expect_equal(rwf$labels$caption, "Observations: 10")
})

test_that("plot_confusion_extended measures match caret for either positive class", {
  skip_if_not_installed("caret")
  observed <- c(0, 0, 0, 0, 1, 1, 1, 1, 1, 1)
  predicted <- c(0, 0, 0, 1, 1, 1, 1, 1, 0, 0)
  for (positive in c("0", "1")) {
    cm <- caret::confusionMatrix(data = factor(predicted), reference = factor(observed), positive = positive)
    rwf <- plot_confusion_extended(observed = observed, predicted = predicted, positive = positive)
    labels <- rwf$data$label
    expect_true(any(grepl(paste0("Sensitivity\n", pct(cm$byClass[["Sensitivity"]])), labels, fixed = TRUE)))
    expect_true(any(grepl(paste0("Specificity\n", pct(cm$byClass[["Specificity"]])), labels, fixed = TRUE)))
    expect_true(any(grepl(paste0("Precision\n", pct(cm$byClass[["Pos Pred Value"]])), labels, fixed = TRUE)))
    expect_true(any(grepl(paste0("NPV\n", pct(cm$byClass[["Neg Pred Value"]])), labels, fixed = TRUE)))
    expect_true(any(grepl(paste0("Prevalence ", pct(cm$byClass[["Prevalence"]])), labels, fixed = TRUE)))
  }
})

test_that("plot_confusion_extended swaps the cells when the positive class changes", {
  observed <- c(0, 0, 0, 1, 1, 1, 1)
  predicted <- c(0, 0, 0, 1, 1, 1, 0)
  positive_1 <- plot_confusion_extended(observed = observed, predicted = predicted, positive = 1)
  positive_0 <- plot_confusion_extended(observed = observed, predicted = predicted, positive = 0)
  # TP, FP, FN, TN
  expect_equal(positive_1$data$n[positive_1$data$kind == "main"], c(3, 0, 1, 3))
  expect_equal(positive_0$data$n[positive_0$data$kind == "main"], c(3, 1, 0, 3))
})

test_that("plot_confusion_extended rejects more than two classes", {
  expect_error(plot_confusion_extended(observed = c(1, 2, 3), predicted = c(1, 2, 3)), "binary")
  expect_error(plot_confusion_extended(observed = c(1, 1), predicted = c(1, 1)), "binary")
})

test_that("plot_confusion_extended default positive class is the second level in confusion() order", {
  skip("rwf bug: plot_confusion_extended() sorts levels as text, so for labels 9 and 10 the default positive is 9, not 10")
  observed <- c(9, 9, 9, 10, 10)
  predicted <- c(9, 10, 10, 10, 10)
  expect_equal(colnames(confusion(observed = observed, predicted = predicted))[2], "10")
  rwf <- plot_confusion_extended(observed = observed, predicted = predicted)
  # positive = 10: TP = 2, FP = 2, FN = 0, TN = 1
  expect_equal(rwf$data$n[rwf$data$kind == "main"], c(2, 2, 0, 1))
})

##########################################################################################
# plot_roc
##########################################################################################
roc_observed <- c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1)
roc_predicted <- c(0.10, 0.40, 0.35, 0.20, 0.70, 0.80, 0.30, 0.90, 0.65, 0.55, 0.50, 0.50)

test_that("plot_roc returns one ggplot per level order with the Mann-Whitney AUC", {
  withr::local_pdf(file.path(withr::local_tempdir(), "roc.pdf"))
  rwf <- quietly(plot_roc(observed = roc_observed, predicted = roc_predicted, title = "x"))
  expect_type(rwf, "list")
  expect_named(rwf, c("1, 0", "0, 1"))
  auc <- reference_auc(roc_observed, roc_predicted, case = 1)
  expect_gt(auc, 0.5)
  expect_equal(auc, as.numeric(pROC::auc(pROC::roc(roc_observed, roc_predicted, quiet = TRUE))))
  for (plot in rwf) {
    expect_s3_class(plot, "ggplot")
    caption <- paste(plot$labels$caption, collapse = "")
    expect_match(caption, paste0("Observations:", length(roc_observed)), fixed = TRUE)
    # direction is chosen automatically, so both level orders report the same AUC
    expect_match(caption, paste0("AUC:", round(auc * 100, 2), "%"), fixed = TRUE)
  }
})

test_that("plot_roc works with string labels", {
  withr::local_pdf(file.path(withr::local_tempdir(), "roc.pdf"))
  labels <- ifelse(roc_observed == 1, "yes", "no")
  rwf <- quietly(plot_roc(observed = labels, predicted = roc_predicted))
  expect_named(rwf, c("yes, no", "no, yes"))
  auc <- reference_auc(roc_observed, roc_predicted, case = 1)
  expect_match(paste(rwf[[1]]$labels$caption, collapse = ""), paste0("AUC:", round(auc * 100, 2), "%"), fixed = TRUE)
})

test_that("plot_roc caption is a single string naming the control level", {
  skip("rwf bug: plot_roc() pastes both rco$levels into the caption, giving a caption vector of length 2")
  withr::local_pdf(file.path(withr::local_tempdir(), "roc.pdf"))
  rwf <- quietly(plot_roc(observed = roc_observed, predicted = roc_predicted))
  expect_length(rwf[["1, 0"]]$labels$caption, 1)
  expect_match(rwf[["1, 0"]]$labels$caption, "Control Level:1", fixed = TRUE)
  expect_match(rwf[["0, 1"]]$labels$caption, "Control Level:0", fixed = TRUE)
})

##########################################################################################
# plot_separability
##########################################################################################
test_that("plot_separability draws one stats::density curve per observed class", {
  rwf <- plot_separability(observed = roc_observed, predicted = roc_predicted, title = "x")
  expect_s3_class(rwf, "ggplot")
  expect_s3_class(rwf$data$observed, "factor")
  expect_equal(rwf$data$predicted, roc_predicted)
  expect_equal(rwf$labels$caption, paste0("Observations:", length(roc_observed)))
  built <- ggplot2::layer_data(rwf)
  expect_equal(sort(unique(built$group)), 1:2)
  for (g in 1:2) {
    x <- roc_predicted[roc_observed == c(0, 1)[g]]
    reference <- stats::density(x, bw = stats::bw.nrd0(x), n = 512,
                                from = min(roc_predicted), to = max(roc_predicted))
    expect_equal(built$y[built$group == g], reference$y, tolerance = 1e-6)
  }
})

##########################################################################################
# result_confusion_performance
##########################################################################################
reference_cut_performance <- function(observed, predicted, step) {
  rows <- lapply(seq(min(predicted), max(predicted), by = step), function(cut) {
    binary <- as.numeric(predicted > cut)
    counts <- reference_counts(observed, binary, c("0", "1"))
    precision <- diag(counts) / rowSums(counts)
    recall <- diag(counts) / colSums(counts)
    precision[is.nan(precision)] <- 0
    recall[is.nan(recall)] <- 0
    data.frame(cut_point = cut,
               Overall = round(sum(diag(counts)) / sum(counts), 2),
               Collumn_Observed.1 = round(precision[[1]], 2),
               Collumn_Observed.2 = round(precision[[2]], 2),
               Row_Predicted.1 = round(recall[[1]], 2),
               Row_Predicted.2 = round(recall[[2]], 2))
  })
  result <- do.call(rbind, rows)
  result$Mean_proportion <- rowMeans(result[, 3:6])
  result
}

test_that("result_confusion_performance matches precision and recall recomputed at every cut point", {
  rwf <- suppressWarnings(result_confusion_performance(observed = roc_observed, predicted = roc_predicted, step = 0.1))
  expect_named(rwf, c("plot_performance", "cut_performance", "cut", "confusion_matrix"))
  expect_s3_class(rwf$plot_performance, "ggplot")
  reference <- reference_cut_performance(roc_observed, roc_predicted, step = 0.1)
  expect_equal(rwf$cut_performance, reference)
  best <- reference$cut_point[reference$Mean_proportion == max(reference$Mean_proportion)]
  expect_equal(rwf$cut, best)
  expect_equal(rwf$confusion_matrix,
               confusion_matrix_percent(observed = roc_observed, predicted = as.numeric(roc_predicted > mean(best))))
})

test_that("result_confusion_performance uses the requested step", {
  rwf <- suppressWarnings(result_confusion_performance(observed = roc_observed, predicted = roc_predicted, step = 0.05))
  expect_equal(rwf$cut_performance$cut_point, seq(min(roc_predicted), max(roc_predicted), by = 0.05))
})

test_that("result_confusion_performance caption reports the number of observations", {
  skip("rwf bug: result_confusion_performance() caption shows nrow(df_cut_performance), the number of cut points, as Observations")
  rwf <- suppressWarnings(result_confusion_performance(observed = roc_observed, predicted = roc_predicted, step = 0.1))
  expect_match(rwf$plot_performance$labels$caption, paste0("Observations:", length(roc_observed)), fixed = TRUE)
})

##########################################################################################
# k_fold
##########################################################################################
infert_formula <- case ~ education + spontaneous + induced

test_that("k_fold test folds partition the rows and each train set is the complement", {
  skip_if_not_installed("xgboost")
  withr::local_seed(1)
  k <- 5
  rwf <- quietly(k_fold(df = infert, model_formula = infert_formula, k = k))
  expect_named(rwf, c("f", "index", "model_formula", "variables", "predictors", "outcome", "xgb"))
  expect_equal(rwf$variables, c("case", "education", "spontaneous", "induced"))
  expect_equal(rwf$predictors, c("education", "spontaneous", "induced"))
  expect_equal(rwf$outcome, "case")
  expect_equal(rwf$model_formula, infert_formula)
  folds <- paste0("f", 1:k)
  expect_named(rwf$f$index, folds)
  test_rows <- rwf$f$index
  # no overlap and every row is in exactly one test fold
  expect_equal(sort(unlist(test_rows, use.names = FALSE)), seq_len(nrow(infert)))
  # balanced fold sizes
  sizes <- lengths(test_rows)
  expect_lte(max(sizes) - min(sizes), 1)
  expect_equal(unname(sizes), as.vector(table(rwf$index)))
  variables <- infert[, rwf$variables]
  for (fold in folds) {
    train_rows <- setdiff(seq_len(nrow(infert)), test_rows[[fold]])
    expect_equal(rwf$f$test[[fold]], variables[test_rows[[fold]], ])
    expect_equal(rwf$f$train[[fold]], variables[train_rows, ])
    expect_equal(rwf$f$x_test[[fold]], variables[test_rows[[fold]], rwf$predictors])
    expect_equal(rwf$f$y_test[[fold]], infert$case[test_rows[[fold]]])
  }
})

test_that("k_fold xgboost matrices carry the fold data and labels", {
  skip_if_not_installed("xgboost")
  withr::local_seed(2)
  rwf <- quietly(k_fold(df = infert, model_formula = infert_formula, k = 3))
  for (fold in paste0("f", 1:3)) {
    xgb <- rwf$xgb[[fold]]
    expect_named(xgb, c("train", "test", "evals", "watchlist", "ytrain", "ytest"))
    expect_s3_class(xgb$train, "xgb.DMatrix")
    expect_equal(nrow(xgb$train), nrow(rwf$f$train[[fold]]))
    expect_equal(nrow(xgb$test), nrow(rwf$f$test[[fold]]))
    expect_equal(xgboost::getinfo(xgb$train, "label"), rwf$f$train[[fold]]$case)
    expect_equal(xgboost::getinfo(xgb$test, "label"), rwf$f$test[[fold]]$case)
    expect_equal(xgb$ytrain, rwf$f$train[[fold]]$case)
    expect_equal(xgb$ytest, rwf$f$test[[fold]]$case)
    expect_named(xgb$evals, c("train", "test"))
  }
})

test_that("k_fold is reproducible under a fixed seed", {
  skip_if_not_installed("xgboost")
  first <- withr::with_seed(10, quietly(k_fold(df = mtcars, model_formula = mpg ~ cyl + wt, k = 4)))
  second <- withr::with_seed(10, quietly(k_fold(df = mtcars, model_formula = mpg ~ cyl + wt, k = 4)))
  expect_identical(first$index, second$index)
  expect_identical(first$f$index, second$f$index)
})

##########################################################################################
# k_sample
##########################################################################################
sample_formula <- case ~ spontaneous + induced + age

test_that("k_sample with k = 1 splits the rows into disjoint train, test and validation halves and quarters", {
  skip_if_not_installed("xgboost")
  withr::local_seed(3)
  rwf <- quietly(k_sample(df = infert, model_formula = sample_formula, k = 1))
  expect_named(rwf, c("f", "index", "model_formula", "variables", "predictors", "outcome", "xgb"))
  expect_equal(rwf$index, rep(1, nrow(infert)))
  train <- rwf$f$index$train$fold1
  test <- rwf$f$index$test$fold1
  validation <- rwf$f$index$validation$fold1
  expect_length(train, nrow(infert) / 2)
  expect_length(test, nrow(infert) / 4)
  expect_length(validation, nrow(infert) / 4)
  expect_length(intersect(train, test), 0)
  expect_length(intersect(train, validation), 0)
  expect_length(intersect(test, validation), 0)
  expect_equal(sort(c(train, test, validation)), seq_len(nrow(infert)))
  variables <- infert[, rwf$variables]
  expect_equal(rwf$f$train$fold1, variables[train, ])
  expect_equal(rwf$f$test$fold1, variables[test, ])
  expect_equal(rwf$f$validation$fold1, variables[validation, ])
  expect_equal(rwf$f$x_validation$fold1, variables[validation, rwf$predictors])
  expect_equal(rwf$f$y_validation$fold1, infert$case[validation])
  expect_equal(rwf$f$y_test$fold1, infert$case[test])
})

test_that("k_sample with k > 1 assigns every row to exactly one fold and one role", {
  skip_if_not_installed("xgboost")
  withr::local_seed(4)
  k <- 3
  rwf <- quietly(k_sample(df = infert, model_formula = sample_formula, k = k))
  folds <- paste0("fold", 1:k)
  all_rows <- c()
  for (fold in folds) {
    rows <- c(rwf$f$index$train[[fold]], rwf$f$index$test[[fold]], rwf$f$index$validation[[fold]])
    expect_equal(sort(rows), which(rwf$index == which(folds == fold)))
    expect_equal(anyDuplicated(rows), 0)
    all_rows <- c(all_rows, rows)
  }
  expect_equal(sort(all_rows), seq_len(nrow(infert)))
  sizes <- as.vector(table(rwf$index))
  expect_lte(max(sizes) - min(sizes), 1)
})

test_that("k_sample xgboost matrices carry the labels of their split", {
  skip_if_not_installed("xgboost")
  withr::local_seed(5)
  rwf <- quietly(k_sample(df = infert, model_formula = sample_formula, k = 1))
  xgb <- rwf$xgb$fold1
  expect_named(xgb, c("train", "test", "validation", "evals", "watchlist", "ytrain", "ytest", "yvalidation"))
  expect_equal(xgboost::getinfo(xgb$train, "label"), rwf$f$train$fold1$case)
  expect_equal(xgboost::getinfo(xgb$test, "label"), rwf$f$test$fold1$case)
  expect_equal(xgboost::getinfo(xgb$validation, "label"), rwf$f$validation$fold1$case)
  expect_equal(xgb$ytrain, rwf$f$train$fold1$case)
  expect_equal(xgb$ytest, rwf$f$test$fold1$case)
})

test_that("k_sample yvalidation holds the validation outcome", {
  skip("rwf bug: k_sample() sets xgb$yvalidation from fold$test instead of fold$validation")
  skip_if_not_installed("xgboost")
  withr::local_seed(5)
  rwf <- quietly(k_sample(df = infert, model_formula = sample_formula, k = 1))
  expect_equal(rwf$xgb$fold1$yvalidation, rwf$f$validation$fold1$case)
})

##########################################################################################
# recode_scale_dummy
##########################################################################################
min_max <- function(x) (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

test_that("recode_scale_dummy min-max scales numeric columns and dummy codes a single factor", {
  rwf <- recode_scale_dummy(infert)
  expect_s3_class(rwf, "data.frame")
  expect_equal(nrow(rwf), nrow(infert))
  expect_equal(row.names(rwf), row.names(infert))
  numeric_columns <- names(infert)[sapply(infert, is.numeric)]
  for (column in numeric_columns) {
    expect_equal(rwf[[column]], min_max(infert[[column]]))
    expect_equal(range(rwf[[column]]), c(0, 1))
  }
  for (level in levels(infert$education)) {
    expect_equal(rwf[[make.names(level)]], as.numeric(infert$education == level), ignore_attr = TRUE)
  }
  expect_setequal(names(rwf), c(make.names(levels(infert$education)), numeric_columns))
})

test_that("recode_scale_dummy dummy codes several categorical columns below the category limit", {
  df <- data.frame(a = 1:12, b = c(5, 3, 8, 1, 9, 2, 7, 4, 6, 10, 12, 11),
                   f = factor(rep(c("A", "B", "C"), 4)),
                   g = rep(c("x", "y"), 6),
                   id = paste0("id", 1:12))
  rwf <- recode_scale_dummy(df, categories = 10)
  expect_setequal(names(rwf), c("f.A", "f.B", "f.C", "g.x", "g.y", "a", "b"))
  for (level in c("A", "B", "C")) expect_equal(rwf[[paste0("f.", level)]], as.numeric(df$f == level), ignore_attr = TRUE)
  for (level in c("x", "y")) expect_equal(rwf[[paste0("g.", level)]], as.numeric(df$g == level), ignore_attr = TRUE)
  expect_equal(rwf$a, min_max(df$a))
  expect_equal(rwf$b, min_max(df$b))
})

test_that("recode_scale_dummy with only numeric columns just scales them", {
  rwf <- recode_scale_dummy(mtcars)
  expect_equal(names(rwf), names(mtcars))
  expect_equal(row.names(rwf), row.names(mtcars))
  for (column in names(mtcars)) expect_equal(rwf[[column]], min_max(mtcars[[column]]))
})

test_that("recode_scale_dummy keeps missing numeric values missing", {
  df <- data.frame(a = c(1, NA, 3, 5), b = c(2, 4, 6, 10))
  rwf <- recode_scale_dummy(df)
  expect_equal(rwf$a, c(0, NA, 0.5, 1))
  expect_equal(rwf$b, min_max(df$b))
})

test_that("recode_scale_dummy handles categorical columns with the same number of levels", {
  skip("rwf bug: sapply() simplifies equal-sized dummy matrices into one matrix and do.call(data.frame, ...) fails")
  df <- data.frame(a = 1:6, b = 6:1, f = rep(c("A", "B"), 3), g = rep(c("x", "y"), each = 3))
  rwf <- recode_scale_dummy(df)
  expect_setequal(names(rwf), c("f.A", "f.B", "g.x", "g.y", "a", "b"))
})

test_that("recode_scale_dummy handles one categorical column below the limit among several", {
  skip("rwf bug: with one qualifying column df[, index] drops to a vector and sapply() dummy codes each element")
  df <- data.frame(a = 1:12, b = 12:1, f = factor(letters[1:12]), g = rep(c("x", "y"), 6))
  rwf <- recode_scale_dummy(df, categories = 10)
  expect_setequal(names(rwf), c("x", "y", "a", "b"))
})

test_that("recode_scale_dummy respects the category limit for a single factor", {
  skip("rwf bug: operator precedence in `length(unique(x))<categories&&is.character(x)|is.factor(x)` dummy codes any factor")
  df <- data.frame(a = 1:12, b = 12:1, f = factor(letters[1:12]))
  rwf <- recode_scale_dummy(df, categories = 10)
  expect_equal(names(rwf), c("a", "b"))
})

test_that("recode_scale_dummy keeps a lone numeric column", {
  skip("rwf bug: df[, sapply(df, is.numeric)] drops to a vector when there is one numeric column, so it is lost")
  df <- data.frame(a = c(2, 4, 6), f = factor(c("A", "B", "A")))
  rwf <- recode_scale_dummy(df)
  expect_equal(rwf$a, c(0, 0.5, 1))
})
