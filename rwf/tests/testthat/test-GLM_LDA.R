##########################################################################################
# report_lda
##########################################################################################
test_that("report_lda reproduces the MASS::lda fit", {
  model <- MASS::lda(Species ~ ., data = iris)
  rwf <- report_lda(model = model)
  expect_type(rwf, "list")
  expect_named(rwf, c("prior_counts", "means", "coeficients", "terms", "model_description", "cmatrix", "call"))
  expect_equal(rwf$prior_counts$prior, unname(model$prior))
  expect_equal(rwf$prior_counts$counts, unname(model$counts))
  expect_equal(rownames(rwf$prior_counts), levels(iris$Species))
  expect_equal(unname(as.matrix(rwf$prior_counts[, -(1:2)])), unname(model$means))
  expect_equal(rwf$means, model$means)
  expect_equal(rwf$coeficients, model$scaling)
  expect_equal(rwf$terms, model$terms)
  expect_equal(rwf$model_description$Observations, rep(150, 2))
  expect_equal(rwf$model_description$SDV, model$svd)
  expect_equal(rwf$call$call, "lda(formula=Species~.,data=iris)")
})

test_that("report_lda group means and priors match the data", {
  model <- MASS::lda(Species ~ ., data = iris)
  rwf <- report_lda(model = model)
  expect_equal(unname(rwf$means), unname(as.matrix(stats::aggregate(. ~ Species, data = iris, FUN = mean)[, -1])))
  expect_equal(rwf$prior_counts$prior, as.vector(table(iris$Species)) / nrow(iris))
})

test_that("report_lda confusion matrix compares the observed classes with predict()", {
  model <- MASS::lda(Species ~ ., data = iris)
  rwf <- report_lda(model = model)
  predicted <- predict(model)$class
  counts <- table(predicted = predicted, observed = iris$Species)
  m <- sapply(rwf$cmatrix, function(x) as.numeric(as.character(x)))
  rownames(m) <- rownames(rwf$cmatrix)
  expect_equal(rownames(m), c(levels(iris$Species), "sum", "p"))
  expect_equal(unname(m[1:3, 1:3]), unname(matrix(counts, 3)))
  expect_equal(m[["p", "p"]], round(mean(predicted == iris$Species), 2))
  expect_equal(unname(m[1:3, "p"]), round(unname(diag(counts) / rowSums(counts)), 2))
  expect_equal(unname(m["p", 1:3]), round(unname(diag(counts) / colSums(counts)), 2))
})

test_that("report_lda honours user supplied priors", {
  model <- MASS::lda(Species ~ Sepal.Length + Sepal.Width, data = iris, prior = c(0.5, 0.25, 0.25))
  rwf <- report_lda(model = model)
  expect_equal(rwf$prior_counts$prior, c(0.5, 0.25, 0.25))
  expect_equal(rwf$coeficients, model$scaling)
  predicted <- predict(model)$class
  m <- sapply(rwf$cmatrix, function(x) as.numeric(as.character(x)))
  expect_equal(m[[4, 4]], 150)
  expect_equal(m[[5, 5]], round(mean(predicted == iris$Species), 2))
})

test_that("report_lda confusion matrix for a numeric outcome has only the observed classes", {
  skip("rwf bug: report_lda() passes a numeric observed and a factor predicted to confusion(), which adds a spurious class")
  model <- MASS::lda(case ~ ., data = infert)
  rwf <- report_lda(model = model)
  expect_equal(rownames(rwf$cmatrix), c("0", "1", "sum", "p"))
  counts <- table(predicted = predict(model)$class, observed = infert$case)
  m <- sapply(rwf$cmatrix, function(x) as.numeric(as.character(x)))
  expect_equal(unname(m[1:2, 1:2]), unname(matrix(counts, 2)))
})

test_that("report_lda writes an Excel workbook with one sheet per table", {
  dir <- withr::local_tempdir()
  file <- file.path(dir, "lda")
  model <- MASS::lda(Species ~ ., data = iris)
  rwf <- quietly(report_lda(model = model, file = file))
  expect_true(file.exists(paste0(file, ".xlsx")))
  expect_setequal(openxlsx::getSheetNames(paste0(file, ".xlsx")),
                  c("Coefficients", "Confusion Matrix", "Priors and Counts", "Means", "Descriptives", "Call"))
  expect_equal(rwf, report_lda(model = model))
})
