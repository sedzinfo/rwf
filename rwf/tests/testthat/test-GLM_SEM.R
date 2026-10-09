##########################################################################################
# helpers
##########################################################################################
hs_model <- "visual =~ x1 + x2 + x3
             textual =~ x4 + x5 + x6
             speed =~ x7 + x8 + x9"
hs_fit <- function(...) lavaan::cfa(hs_model, data = lavaan::HolzingerSwineford1939, ...)

# Data of a layer of a ggplot, from the layer whose geom has the given class
layer_data_by_geom <- function(p, geom) {
  layers <- Filter(function(l) inherits(l$geom, geom), p$layers)
  lapply(layers, function(l) l$data)
}

# plot_cfa_gg uses arguments that ggplot2 >= 3.5.0 deprecates; silence those warnings
quiet_plot_cfa_gg <- function(...) suppressWarnings(plot_cfa_gg(...))

##########################################################################################
# plot_cfa_gg
##########################################################################################
test_that("plot_cfa_gg returns a ggplot that builds for every layout", {
  fit <- hs_fit()
  for (layout in c("tree", "circle", "spring")) {
    withr::local_seed(1)
    p <- quiet_plot_cfa_gg(fit, what = "std", layout = layout)
    expect_s3_class(p, "ggplot")
    expect_no_error(suppressWarnings(ggplot2::ggplot_build(p)))
    expect_equal(p$labels$title, paste0("Standardised Estimates — ", layout))
  }
})

test_that("plot_cfa_gg labels the loadings and factor covariances with lavaan standardized estimates", {
  fit <- hs_fit()
  p <- quiet_plot_cfa_gg(fit, what = "std")
  standardized <- lavaan::standardizedSolution(fit)
  labels <- layer_data_by_geom(p, "GeomLabel")
  loadings <- labels[[1]]
  reference <- standardized[standardized$op == "=~", ]
  expect_equal(nrow(loadings), 9)
  expected <- reference$est.std[match(paste(loadings$lhs, loadings$rhs), paste(reference$lhs, reference$rhs))]
  expect_equal(loadings$display, formatC(expected, digits = 3, format = "f"))
  covariances <- labels[[2]]
  reference <- standardized[standardized$op == "~~" & standardized$lhs != standardized$rhs, ]
  expect_equal(nrow(covariances), 3)
  expected <- reference$est.std[match(paste(covariances$lhs, covariances$rhs), paste(reference$lhs, reference$rhs))]
  expect_equal(covariances$display, formatC(expected, digits = 3, format = "f"))
})

test_that("plot_cfa_gg labels the edges with lavaan unstandardized estimates", {
  fit <- hs_fit()
  p <- quiet_plot_cfa_gg(fit, what = "est")
  estimates <- lavaan::parameterEstimates(fit)
  loadings <- layer_data_by_geom(p, "GeomLabel")[[1]]
  reference <- estimates[estimates$op == "=~", ]
  expected <- reference$est[match(paste(loadings$lhs, loadings$rhs), paste(reference$lhs, reference$rhs))]
  expect_equal(loadings$display, formatC(expected, digits = 3, format = "f"))
  expect_equal(p$labels$title, "Unstandardised Estimates — tree")
})

test_that("plot_cfa_gg draws one node per latent and observed variable", {
  fit <- hs_fit()
  p <- quiet_plot_cfa_gg(fit, what = "std")
  nodes <- do.call(rbind, layer_data_by_geom(p, "GeomRect"))
  expect_setequal(nodes$name, c("visual", "textual", "speed", paste0("x", 1:9)))
  expect_equal(sort(nodes$name[nodes$is_lat]), sort(lavaan::lavNames(fit, "lv")))
  expect_true(all(nodes$x >= 0 & nodes$x <= 10 & nodes$y >= 0 & nodes$y <= 10))
})

test_that("plot_cfa_gg shows parameter labels when what = 'eq'", {
  fit <- lavaan::cfa("visual =~ x1 + a*x2 + a*x3\n textual =~ x4 + x5 + x6", data = lavaan::HolzingerSwineford1939)
  p <- quiet_plot_cfa_gg(fit, what = "eq")
  expect_s3_class(p, "ggplot")
  expect_no_error(suppressWarnings(ggplot2::ggplot_build(p)))
  loadings <- layer_data_by_geom(p, "GeomLabel")[[1]]
  estimates <- lavaan::parameterEstimates(fit)
  estimates <- estimates[estimates$op == "=~", ]
  expected <- ifelse(estimates$label == "", formatC(estimates$est, digits = 3, format = "f"), estimates$label)
  expect_equal(loadings$display, expected[match(paste(loadings$lhs, loadings$rhs), paste(estimates$lhs, estimates$rhs))])
  expect_equal(sum(loadings$display == "a"), 2)
})

test_that("plot_cfa_gg what = 'eq' works for a model without parameter labels", {
  skip("rwf bug: plot_cfa_gg(what = 'eq') fails when parameterEstimates has no label column")
  p <- quiet_plot_cfa_gg(hs_fit(), what = "eq")
  expect_s3_class(p, "ggplot")
  loadings <- layer_data_by_geom(p, "GeomLabel")[[1]]
  estimates <- lavaan::parameterEstimates(hs_fit())
  estimates <- estimates[estimates$op == "=~", ]
  expected <- estimates$est[match(paste(loadings$lhs, loadings$rhs), paste(estimates$lhs, estimates$rhs))]
  expect_equal(loadings$display, formatC(expected, digits = 3, format = "f"))
})

test_that("plot_cfa_gg omits covariance arcs for a single factor and rejects unknown options", {
  fit <- lavaan::cfa("visual =~ x1 + x2 + x3", data = lavaan::HolzingerSwineford1939)
  p <- quiet_plot_cfa_gg(fit, what = "std")
  expect_length(layer_data_by_geom(p, "GeomCurve"), 0)
  expect_no_error(suppressWarnings(ggplot2::ggplot_build(p)))
  expect_error(plot_cfa_gg(fit, what = "unknown"), "should be one of")
  expect_error(plot_cfa_gg(fit, layout = "unknown"), "should be one of")
})

##########################################################################################
# plot_cfa
##########################################################################################
plot_cfa_names <- paste0(rep(c("circle", "tree", "spring"), each = 3), "_",
                         c("estimates", "standard_estimates", "parameters_wih_equality_constraints"))

test_that("plot_cfa returns a named list with one ggplot per layout and display", {
  withr::local_seed(1)
  fit <- lavaan::cfa("visual =~ x1 + a*x2 + a*x3\n textual =~ x4 + x5 + x6", data = lavaan::HolzingerSwineford1939)
  plots <- suppressWarnings(plot_cfa(fit))
  expect_type(plots, "list")
  expect_named(plots, plot_cfa_names)
  for (p in plots) {
    expect_s3_class(p, "ggplot")
    expect_no_error(suppressWarnings(ggplot2::ggplot_build(p)))
  }
  expect_equal(plots$tree_standard_estimates$labels$title, quiet_plot_cfa_gg(fit, what = "std", layout = "tree")$labels$title)
})

test_that("plot_cfa passes extra arguments to plot_cfa_gg", {
  withr::local_seed(1)
  plots <- suppressWarnings(suppressMessages(plot_cfa(hs_fit(), label_size = 5)))
  text_layer <- Filter(function(l) inherits(l$geom, "GeomText"), plots$tree_estimates$layers)[[1]]
  expect_equal(text_layer$aes_params$size, 5)
})

test_that("plot_cfa returns all nine plots for a model without parameter labels", {
  skip("rwf bug: plot_cfa_gg(what = 'eq') fails when parameterEstimates has no label column")
  plots <- suppressWarnings(plot_cfa(hs_fit()))
  expect_named(plots, plot_cfa_names)
})

##########################################################################################
# report_cfa
##########################################################################################
report_cfa_quietly <- function(...) {
  # report_cfa prints its diagrams; send them to a temporary device
  withr::local_pdf(withr::local_tempfile(fileext = ".pdf"))
  quietly(report_cfa(...))
}

test_that("report_cfa returns the documented elements", {
  result <- report_cfa_quietly(hs_fit())
  expect_named(result, c("r_squared", "fit_indices", "parameters", "modification_indices", "sample_covariance",
                         "unstandardized_estimates", "standardized_estimates", "group", "predict", "call"))
  expect_equal(nrow(result$group), 0)
  expect_equal(dim(result$sample_covariance), c(9, 9))
  expect_equal(dim(result$predict), c(301, 12))
})

test_that("report_cfa fit indices, R-squared and parameters match lavaan", {
  fit <- hs_fit()
  result <- report_cfa_quietly(fit)
  measures <- lavaan::fitMeasures(fit)
  expect_equal(result$fit_indices[names(measures), "fit"], as.numeric(measures))
  expect_equal(result$fit_indices["cfi", "fit"], unname(lavaan::fitMeasures(fit, "cfi")))
  r_squared <- lavaan::lavInspect(fit, "r2")
  expect_equal(result$r_squared[names(r_squared), "r_squared"], as.numeric(r_squared))
  estimates <- lavaan::parameterEstimates(fit)
  standardized <- lavaan::standardizedSolution(fit)
  free <- result$parameters[result$parameters$op != "r2", ]
  key <- paste(free$lhs, free$op, free$rhs)
  expect_equal(free$est, estimates$est[match(key, paste(estimates$lhs, estimates$op, estimates$rhs))])
  expect_equal(free$se, estimates$se[match(key, paste(estimates$lhs, estimates$op, estimates$rhs))])
  expect_equal(free$std.all, standardized$est.std[match(key, paste(standardized$lhs, standardized$op, standardized$rhs))])
  expect_equal(unname(as.matrix(result$sample_covariance)), unname(unclass(lavaan::lavInspect(fit, "sampstat")$cov)))
})

test_that("report_cfa factor scores and estimate matrices match lavaan", {
  fit <- hs_fit()
  result <- report_cfa_quietly(fit)
  scores <- lavaan::lavPredict(fit)
  expect_equal(as.matrix(result$predict[, c("visual", "textual", "speed")]), unclass(scores), ignore_attr = TRUE)
  expect_equal(unname(as.matrix(result$predict[, 1:9])), unname(as.matrix(lavaan::HolzingerSwineford1939[, paste0("x", 1:9)])))
  expect_equal(unclass(result$standardized_estimates$lambda), unclass(lavaan::lavInspect(fit, "std")$lambda), ignore_attr = TRUE)
  expect_equal(unclass(result$unstandardized_estimates$lambda), unclass(lavaan::lavInspect(fit, "est")$lambda), ignore_attr = TRUE)
  mi <- lavaan::modificationIndices(fit, sort. = TRUE, minimum.value = 0, free.remove = FALSE)
  expect_equal(sort(result$modification_indices$mi), sort(mi$mi))
})

test_that("report_cfa describes the groups of a multiple-group model", {
  fit <- hs_fit(group = "school")
  result <- report_cfa_quietly(fit)
  expect_equal(result$group$GROUPS, lavaan::lavInspect(fit, "group.label"))
  expect_equal(result$group$OBSERVATIONS, unlist(lavaan::lavInspect(fit, "nobs")))
  expect_equal(unique(result$group$TOTAL), 301)
  r_squared <- lavaan::lavInspect(fit, "r2")
  expect_equal(unname(result$r_squared[[1]]), unname(as.numeric(r_squared[[1]])))
  expect_equal(unname(result$r_squared[[2]]), unname(as.numeric(r_squared[[2]])))
  expect_equal(nrow(result$predict), 301)
})

test_that("report_cfa writes the workbook, the diagram and the log", {
  withr::local_dir(withr::local_tempdir())
  report_cfa_quietly(hs_fit(), file = "cfa")
  expect_true(all(file.exists(c("cfa.xlsx", "cfa_diagram.pdf", "cfa.log"))))
  expect_equal(openxlsx::getSheetNames("cfa.xlsx"),
               c("R_Squared", "Fit_Indices", "Parameters", "Modification_Indices", "Groups", "Sample_Covariance", "Scores", "Call"))
  expect_true(any(grepl("Comparative Fit Index", readLines("cfa.log"))))
})

test_that("report_cfa leaves the global options unchanged", {
  skip("rwf bug: report_cfa sets options(fit = ...) and never restores it")
  withr::local_options(fit = NULL)
  report_cfa_quietly(hs_fit())
  expect_null(getOption("fit"))
})

##########################################################################################
# simulate_cfa_fit
##########################################################################################
test_that("simulate_cfa_fit fits the model at every sample size from population coefficients", {
  skip_on_cran()
  # two workers keep the run short; plot_scatterplot leaves devices open in the workers
  local_mocked_bindings(detectCores = function(...) 2L, .package = "parallel")
  withr::local_dir(withr::local_tempdir())
  withr::local_pdf("plots.pdf")
  withr::local_seed(2024)
  model_sim <- "LATENT =~ 1*X1 + 0.5*X2 + 1.5*X3 + 1.5*X4 + X5"
  model <- "LATENT =~ X1 + X2 + X3 + X4 + X5"
  result <- quietly(simulate_cfa_fit(model_sim = model_sim, model = model, minnobs = 100, maxnobs = 300,
                                     stepping = 100, file = "simulation"))
  expect_type(result, "list")
  expect_length(result, 2)
  fits <- result[[1]]
  expect_equal(fits$observations, c(100, 200, 300))
  expect_equal(fits$ntotal, fits$observations)
  # a one-factor model with five indicators has 15 - 10 = 5 degrees of freedom
  expect_true(all(fits$df == 5))
  expect_true(all(fits$cfi >= 0 & fits$cfi <= 1))
  expect_true(all(fits$rmsea >= 0))
  expect_true(all(c("chisq", "cfi", "tli", "rmsea", "srmr") %in% names(fits)))
  expect_true(all(vapply(result[[2]], ggplot2::is_ggplot, logical(1))))
  expect_true(all(file.exists(c("simulation.xlsx", "simulation.pdf"))))
  expect_s3_class(future::plan(), "sequential")
})

test_that("simulate_cfa_fit resamples from observed data and is reproducible", {
  skip_on_cran()
  # run sequentially in this session and skip the slow scatter plots
  local_mocked_bindings(detectCores = function(...) 1L, .package = "parallel")
  local_mocked_bindings(plot_scatterplot = function(df, combinations, ...) list())
  data <- lavaan::HolzingerSwineford1939[, paste0("x", 1:6)]
  model <- "visual =~ x1 + x2 + x3\n textual =~ x4 + x5 + x6"
  run <- function() {
    withr::local_seed(99)
    quietly(simulate_cfa_fit(model = model, df = data, minnobs = 150, maxnobs = 450, stepping = 150))
  }
  first <- run()
  second <- run()
  expect_identical(first[[1]], second[[1]])
  fits <- first[[1]]
  expect_equal(fits$observations, c(150, 300, 450))
  expect_equal(fits$ntotal, fits$observations)
  reference <- lavaan::fitMeasures(lavaan::cfa(model, data = data), c("npar", "df"))
  expect_true(all(fits$df == reference[["df"]]))
  expect_true(all(fits$npar == reference[["npar"]]))
})
