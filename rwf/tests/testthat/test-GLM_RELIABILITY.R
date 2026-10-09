##########################################################################################
# helpers
##########################################################################################
# Complete cases of the Agreeableness and Conscientiousness items of psych::bfi
bfi_items <- function(n = 500) {
  items <- psych::bfi[, c(paste0("A", 1:5), paste0("C", 1:5))]
  items <- items[stats::complete.cases(items), ]
  items[seq_len(n), ]
}

# The same items with the negatively keyed ones (A1, C4, C5) reversed on the 1-6 scale
bfi_reversed <- function(n = 500) {
  items <- bfi_items(n)
  for (item in c("A1", "C4", "C5")) items[[item]] <- 7 - items[[item]]
  items
}

alpha_by_hand <- function(df) {
  df <- df[stats::complete.cases(df), ]
  k <- ncol(df)
  k / (k - 1) * (1 - sum(apply(df, 2, stats::var)) / stats::var(rowSums(df)))
}

##########################################################################################
# compute_raw_alpha
##########################################################################################
test_that("compute_raw_alpha matches psych::alpha and the textbook formula", {
  items <- bfi_reversed()
  for (scale in list(paste0("A", 1:5), paste0("C", 1:5), c("A2", "A3"), names(items))) {
    rwf <- compute_raw_alpha(items[, scale])
    expect_type(rwf, "double")
    expect_length(rwf, 1)
    expect_equal(rwf, alpha_by_hand(items[, scale]))
    expect_equal(rwf, psych::alpha(items[, scale], check.keys = FALSE, warnings = FALSE)$total$raw_alpha)
  }
})

test_that("compute_raw_alpha uses pairwise complete observations like psych::alpha", {
  items <- psych::bfi[1:400, paste0("C", 1:5)]
  expect_true(anyNA(items))
  expect_equal(compute_raw_alpha(items),
               psych::alpha(items, check.keys = FALSE, warnings = FALSE)$total$raw_alpha)
})

test_that("compute_raw_alpha is 1 for parallel identical items and invariant to item shifts", {
  withr::local_seed(10)
  x <- stats::rnorm(50)
  expect_equal(compute_raw_alpha(data.frame(a = x, b = x, c = x)), 1)
  items <- bfi_reversed()[, paste0("A", 1:5)]
  expect_equal(compute_raw_alpha(items + 10), compute_raw_alpha(items))
})

##########################################################################################
# compute_alpha_diagnostics
##########################################################################################
test_that("compute_alpha_diagnostics matches psych::alpha item statistics", {
  items <- bfi_reversed()[, paste0("C", 1:5)]
  rwf <- compute_alpha_diagnostics(items)
  reference <- psych::alpha(items, check.keys = FALSE, warnings = FALSE)
  expect_equal(rwf$alpha.if.item.removed, reference$alpha.drop$raw_alpha)
  expect_equal(rwf$item.total.correlation, reference$item.stats$raw.r)
  expect_equal(rwf$item.total.correlation.r.drop, reference$item.stats$r.drop)
})

test_that("compute_alpha_diagnostics item-total correlations agree with a direct computation", {
  items <- bfi_reversed()[, paste0("A", 1:5)]
  rwf <- compute_alpha_diagnostics(items)
  for (i in seq_along(items)) {
    expect_equal(rwf$item.total.correlation[i], stats::cor(items[[i]], rowSums(items)))
    expect_equal(rwf$item.total.correlation.r.drop[i], stats::cor(items[[i]], rowSums(items[, -i])))
    expect_equal(rwf$alpha.if.item.removed[i], alpha_by_hand(items[, -i]))
  }
})

test_that("compute_alpha_diagnostics returns one row per item", {
  items <- bfi_reversed()[, paste0("A", 1:5)]
  rwf <- compute_alpha_diagnostics(items)
  expect_s3_class(rwf, "data.frame")
  expect_named(rwf, c("item", "alpha.if.item.removed", "item.total.correlation", "item.total.correlation.r.drop"))
  expect_equal(rwf$item, names(items))
  expect_equal(rownames(rwf), names(items))
})

##########################################################################################
# compute_mean_sd_alpha
##########################################################################################
test_that("compute_mean_sd_alpha returns the mean and SD of the row means", {
  items <- psych::bfi[1:300, paste0("A", 1:5)]
  rwf <- compute_mean_sd_alpha(items)
  scores <- rowMeans(items, na.rm = TRUE)
  expect_s3_class(rwf, "data.frame")
  expect_equal(dim(rwf), c(1, 2))
  expect_named(rwf, c("MEAN", "SD"))
  expect_equal(rwf$MEAN, mean(scores))
  expect_equal(rwf$SD, stats::sd(scores))
  # psych::alpha reports the same mean and SD of the average scores on complete data
  complete <- bfi_items()[, paste0("A", 2:5)]
  reference <- psych::alpha(complete, check.keys = FALSE, warnings = FALSE)$total
  expect_equal(compute_mean_sd_alpha(complete)$MEAN, reference$mean)
  expect_equal(compute_mean_sd_alpha(complete)$SD, reference$sd)
})

test_that("compute_mean_sd_alpha divides the row sums by divisor", {
  items <- psych::bfi[1:300, paste0("A", 1:5)]
  rwf <- compute_mean_sd_alpha(items, divisor = 30)
  scores <- rowSums(items, na.rm = TRUE) / 30
  expect_equal(rwf[[1]], mean(scores))
  expect_equal(rwf$SD, stats::sd(scores))
})

test_that("compute_mean_sd_alpha uses the same column names with and without divisor", {
  skip("rwf bug: with divisor the mean column is named 'Mean' instead of the documented 'MEAN'")
  items <- psych::bfi[1:300, paste0("A", 1:5)]
  expect_named(compute_mean_sd_alpha(items, divisor = 30), c("MEAN", "SD"))
})

##########################################################################################
# key_to_cfa_model
##########################################################################################
test_that("key_to_cfa_model writes one lavaan factor definition per key element", {
  model <- key_to_cfa_model(list(f1 = c("x1", "x2"), f2 = c("x3", "x4", "x5")))
  expect_type(model, "character")
  expect_length(model, 1)
  lines <- trimws(strsplit(model, "\n")[[1]])
  lines <- lines[lines != ""]
  expect_equal(gsub(" ", "", lines), c("f1=~x1+x2", "f2=~x3+x4+x5"))
})

test_that("key_to_cfa_model produces the same lavaan model as hand-written syntax", {
  key <- list(visual = paste0("x", 1:3), textual = paste0("x", 4:6), speed = paste0("x", 7:9))
  hand <- "visual =~ x1 + x2 + x3\n textual =~ x4 + x5 + x6\n speed =~ x7 + x8 + x9"
  table_rwf <- lavaan::lavaanify(key_to_cfa_model(key), auto.var = TRUE, auto.fix.first = TRUE, auto.cov.lv.x = TRUE)
  table_hand <- lavaan::lavaanify(hand, auto.var = TRUE, auto.fix.first = TRUE, auto.cov.lv.x = TRUE)
  expect_equal(table_rwf[, c("lhs", "op", "rhs", "free")], table_hand[, c("lhs", "op", "rhs", "free")])
  fit_rwf <- lavaan::cfa(key_to_cfa_model(key), data = lavaan::HolzingerSwineford1939)
  fit_hand <- lavaan::cfa(hand, data = lavaan::HolzingerSwineford1939)
  expect_equal(lavaan::fitMeasures(fit_rwf, c("chisq", "df", "cfi", "rmsea")),
               lavaan::fitMeasures(fit_hand, c("chisq", "df", "cfi", "rmsea")))
})

##########################################################################################
# report_alpha
##########################################################################################
alpha_key <- list(A = paste0("A", 1:5), C = paste0("C", 1:5))

test_that("report_alpha matches psych::alpha for every scale", {
  items <- bfi_reversed()
  result <- quietly(report_alpha(df = items, key = alpha_key, check.keys = FALSE))
  expect_named(result, c("result_total", "result_boot", "result_item_statistics", "result_dropped"))
  expect_equal(result$result_total$dimension, c("A", "C"))
  expect_equal(result$result_total$items, c(5, 5))
  for (scale in names(alpha_key)) {
    reference <- psych::alpha(items[, alpha_key[[scale]]], check.keys = FALSE, warnings = FALSE)
    total <- result$result_total[result$result_total$dimension == scale, ]
    expect_equal(total$raw_alpha, reference$total$raw_alpha)
    expect_equal(total$std_alpha, reference$total$std.alpha)
    expect_equal(total$`g6(smc)`, reference$total$`G6(smc)`)
    expect_equal(total$average_r, reference$total$average_r)
    expect_equal(total$mean, reference$total$mean)
    expect_equal(total$sd, reference$total$sd)
    expect_equal(total$raw_alpha, compute_raw_alpha(items[, alpha_key[[scale]]]))
    item_statistics <- result$result_item_statistics[result$result_item_statistics$dimension == scale, ]
    expect_equal(item_statistics$question, alpha_key[[scale]])
    expect_equal(item_statistics$r_drop, reference$item.stats$r.drop)
    expect_equal(item_statistics$raw_r, reference$item.stats$raw.r)
    dropped <- result$result_dropped[result$result_dropped$dimension == scale, ]
    expect_equal(dropped$raw_alpha, reference$alpha.drop$raw_alpha)
    expect_true(all(dropped$scale_alpha == reference$total$raw_alpha))
  }
})

test_that("report_alpha kaiser_criterion counts the eigenvalues above 1", {
  items <- bfi_reversed()
  result <- quietly(report_alpha(df = items, key = alpha_key, check.keys = FALSE))
  for (scale in names(alpha_key)) {
    eigenvalues <- eigen(stats::cor(items[, alpha_key[[scale]]]))$values
    expect_equal(result$result_total$kaiser_criterion[result$result_total$dimension == scale], sum(eigenvalues > 1))
  }
})

test_that("report_alpha reverses items with psych::reverse.code", {
  items <- bfi_items()
  reverse <- list(A = c(-1, 1, 1, 1, 1), C = c(1, 1, 1, -1, -1))
  result <- quietly(report_alpha(df = items, key = alpha_key, reverse = reverse, mini = 1, maxi = 6, check.keys = FALSE))
  reversed <- bfi_reversed()
  for (scale in names(alpha_key)) {
    reference <- psych::alpha(reversed[, alpha_key[[scale]]], check.keys = FALSE, warnings = FALSE)
    expect_equal(result$result_total$raw_alpha[result$result_total$dimension == scale], reference$total$raw_alpha)
  }
  not_reversed <- quietly(report_alpha(df = items, key = alpha_key, check.keys = FALSE))
  expect_false(isTRUE(all.equal(not_reversed$result_total$raw_alpha, result$result_total$raw_alpha)))
})

test_that("report_alpha classifies alpha values", {
  items <- bfi_reversed()
  key <- list(A = paste0("A", 1:5), C = paste0("C", 1:5), weak = c("A1", "C1"), all = names(items))
  result <- quietly(report_alpha(df = items, key = key, check.keys = FALSE))
  expected <- as.character(cut(result$result_total$raw_alpha, c(-Inf, 0.6, 0.7, 0.8, 0.9, Inf),
                               labels = c("Unacceptable", "Acceptable", "Good and Acceptable", "Good", "Excellent")))
  expect_equal(result$result_total$alpha_criterion, expected)
})

test_that("report_alpha treats all columns as one scale when key is NULL and skips single-item scales", {
  items <- bfi_reversed()[, paste0("A", 1:5)]
  result <- quietly(report_alpha(df = items, check.keys = FALSE))
  expect_equal(result$result_total$dimension, "dimension")
  expect_equal(result$result_total$raw_alpha, compute_raw_alpha(items))
  single <- quietly(report_alpha(df = bfi_reversed(), key = list(A = paste0("A", 1:5), one = "C1"), check.keys = FALSE))
  expect_equal(single$result_total$dimension, "A")
})

test_that("report_alpha appends the question labels", {
  items <- bfi_reversed()[, paste0("A", 1:3)]
  questions <- list(A = c("indifferent", "inquire", "comfort"))
  result <- quietly(report_alpha(df = items, key = list(A = paste0("A", 1:3)), questions = questions, check.keys = FALSE))
  expect_equal(result$result_item_statistics$question, c("A1 indifferent", "A2 inquire", "A3 comfort"))
})

test_that("report_alpha returns the psych::alpha bootstrap interval", {
  # psych::alpha runs the bootstrap with parallel::mclapply, which set.seed() alone
  # cannot make reproducible; a single core makes the draws depend only on the seed
  withr::local_options(mc.cores = 1)
  items <- bfi_reversed()
  withr::local_seed(42)
  result <- quietly(report_alpha(df = items, key = alpha_key["A"], check.keys = FALSE, n.iter = 20))
  withr::local_seed(42)
  reference <- suppressWarnings(psych::alpha(items[, alpha_key$A], check.keys = FALSE, n.iter = 20))
  expect_equal(nrow(result$result_boot), 20)
  expect_equal(unname(unlist(result$result_total[, grep("boot_ci", names(result$result_total))])),
               unname(reference$boot.ci))
  expect_equal(result$result_boot$raw_alpha, unname(reference$boot[, "raw_alpha"]))
})

test_that("report_alpha writes an Excel workbook", {
  withr::local_dir(withr::local_tempdir())
  quietly(report_alpha(df = bfi_reversed(), key = alpha_key, check.keys = FALSE, file = "alpha"))
  expect_true(file.exists("alpha.xlsx"))
  expect_equal(openxlsx::getSheetNames("alpha.xlsx"), c("total statistics", "item statistics", "if dropped", "call"))
})

##########################################################################################
# plot_mtmm
##########################################################################################
# Two traits measured by two methods on the same 80 subjects; the rows of each method are
# ordered by subject
mtmm_data <- function() {
  withr::local_seed(123)
  n <- 80
  trait_a <- stats::rnorm(n)
  trait_b <- stats::rnorm(n)
  make_method <- function(method_effect) {
    data.frame(x1 = trait_a + method_effect + stats::rnorm(n), x2 = trait_a + method_effect + stats::rnorm(n),
               x3 = trait_b + method_effect + stats::rnorm(n), x4 = trait_b + method_effect + stats::rnorm(n))
  }
  shared <- stats::rnorm(n, sd = 0.5)
  rbind(data.frame(make_method(shared), method = "m1", id = seq_len(n)),
        data.frame(make_method(stats::rnorm(n, sd = 0.5)), method = "m2", id = seq_len(n)))
}
mtmm_key <- list(a = c("x1", "x2"), b = c("x3", "x4"))

# Scale scores per subject, aligned by subject id, and their correlations
mtmm_reference <- function(df) {
  scores <- lapply(split(df, df$method), function(d) {
    d <- d[order(d$id), ]
    data.frame(id = d$id, a = rowMeans(d[, mtmm_key$a]), b = rowMeans(d[, mtmm_key$b]))
  })
  wide <- merge(scores$m1, scores$m2, by = "id", suffixes = c(".m1", ".m2"))
  stats::cor(wide[, c("a.m1", "b.m1", "a.m2", "b.m2")])
}

test_that("plot_mtmm returns a ggplot that builds", {
  p <- suppressWarnings(plot_mtmm(df = mtmm_data(), key = mtmm_key, method = "method", subject = "id", title = "test"))
  expect_s3_class(p, "ggplot")
  expect_no_error(suppressWarnings(ggplot2::ggplot_build(p)))
  expect_match(p$labels$title, "test")
})

test_that("plot_mtmm shows the alphas on the diagonal and the subject-aligned correlations elsewhere", {
  df <- mtmm_data()
  p <- suppressWarnings(plot_mtmm(df = df, key = mtmm_key, method = "method", subject = "id"))
  cells <- p$data
  # 4 trait-method scales: 4 alphas and 6 correlations
  expect_equal(nrow(cells), 10)
  for (scale in c("a.m1", "b.m1", "a.m2", "b.m2")) {
    parts <- strsplit(scale, ".", fixed = TRUE)[[1]]
    items <- df[df$method == parts[2], mtmm_key[[parts[1]]]]
    value <- cells$value[cells$var1 == scale & cells$var2 == scale]
    expect_equal(value, quietly(psych::alpha(items, warnings = FALSE))$total$raw_alpha)
  }
  reference <- mtmm_reference(df)
  off_diagonal <- cells[as.character(cells$var1) != as.character(cells$var2), ]
  for (i in seq_len(nrow(off_diagonal))) {
    expect_equal(off_diagonal$value[i], reference[as.character(off_diagonal$var1[i]), as.character(off_diagonal$var2[i])])
  }
})

test_that("plot_mtmm classifies every cell", {
  p <- suppressWarnings(plot_mtmm(df = mtmm_data(), key = mtmm_key, method = "method", subject = "id"))
  cells <- p$data
  same_trait <- as.character(cells$trait_x) == as.character(cells$trait_y)
  same_method <- as.character(cells$method_x) == as.character(cells$method_y)
  expected <- ifelse(same_trait & same_method, "monotrait-monomethod (reliability)",
                     ifelse(same_trait, "monotrait-heteromethod (validity)",
                            ifelse(same_method, "heterotrait-monomethod", "heterotrait-heteromethod")))
  expect_equal(cells$type, expected)
  expect_equal(as.vector(table(cells$type)[c("monotrait-monomethod (reliability)", "monotrait-heteromethod (validity)",
                                             "heterotrait-monomethod", "heterotrait-heteromethod")]), c(4, 2, 2, 2))
})

test_that("plot_mtmm aligns the scores of the methods by subject", {
  skip("rwf bug: plot_mtmm ignores the subject column and pairs rows by position within each method")
  df <- mtmm_data()
  withr::local_seed(1)
  shuffled <- df[c(sample(which(df$method == "m1")), sample(which(df$method == "m2"))), ]
  p <- suppressWarnings(plot_mtmm(df = shuffled, key = mtmm_key, method = "method", subject = "id"))
  reference <- mtmm_reference(df)
  cells <- p$data[as.character(p$data$var1) != as.character(p$data$var2), ]
  for (i in seq_len(nrow(cells))) {
    expect_equal(cells$value[i], reference[as.character(cells$var1[i]), as.character(cells$var2[i])])
  }
})

##########################################################################################
# extract_components
##########################################################################################
one_way_random <- function() {
  withr::local_seed(7)
  design <- expand.grid(replicate = 1:4, person = factor(1:15))
  design$response <- stats::rnorm(15, sd = 2)[design$person] + stats::rnorm(nrow(design))
  design
}

test_that("extract_components matches the ANOVA variance components and psych::ICC", {
  design <- one_way_random()
  model <- mixlm::lm(response ~ r(person), data = design)
  result <- quietly(extract_components(model))
  expect_named(result, c("components", "plot"))
  expect_named(result$components, c("component", "VC", "vc_percent"))
  expect_equal(result$components$component, c("person", "Residuals"))
  table <- summary(stats::aov(response ~ person, data = design))[[1]]
  ms_person <- table[1, "Mean Sq"]
  ms_error <- table[2, "Mean Sq"]
  expect_equal(result$components$VC, c((ms_person - ms_error) / 4, ms_error))
  expect_equal(sum(result$components$vc_percent), 100)
  wide <- matrix(design$response, ncol = 4, byrow = TRUE)
  icc <- suppressMessages(psych::ICC(wide))$results
  expect_equal(result$components$vc_percent[1] / 100, icc$ICC[icc$type == "ICC1"])
})

test_that("extract_components matches lme4 variance components in a balanced crossed design", {
  skip_if_not_installed("lme4")
  withr::local_seed(8)
  design <- expand.grid(time = factor(1:3), item = factor(1:4), person = factor(1:12))
  design$response <- stats::rnorm(12, sd = 2)[design$person] + stats::rnorm(3)[design$time] + stats::rnorm(4)[design$item] +
    stats::rnorm(36, sd = 0.8)[interaction(design$person, design$time)] + stats::rnorm(nrow(design), sd = 0.5)
  model <- mixlm::lm(response ~ r(time) * r(person) + r(item), data = design)
  result <- quietly(extract_components(model))
  lmer <- suppressMessages(lme4::lmer(response ~ (1 | time) + (1 | person) + (1 | time:person) + (1 | item), data = design))
  variance <- as.data.frame(lme4::VarCorr(lmer))
  # with every component positive, REML and the ANOVA estimators agree in a balanced design
  expect_true(all(result$components$VC > 0))
  reference <- stats::setNames(variance$vcov, sub("Residual", "Residuals", variance$grp))
  expect_equal(result$components$VC, unname(reference[result$components$component]), tolerance = 1e-4)
})

test_that("extract_components returns a bar chart of the percentages", {
  model <- mixlm::lm(response ~ r(person), data = one_way_random())
  result <- quietly(extract_components(model, title = "components"))
  expect_s3_class(result$plot, "ggplot")
  expect_no_error(ggplot2::ggplot_build(result$plot))
  expect_equal(result$plot$labels$title, "components")
  expect_equal(levels(result$plot$data$component), c("person", "Residuals"))
})

##########################################################################################
# compute_shrout
##########################################################################################
shrout_data <- function() {
  withr::local_seed(2)
  d <- expand.grid(id = 1:20, time = 1:4)
  person <- stats::rnorm(20, sd = 1.5)
  person_time <- matrix(stats::rnorm(80, sd = 0.7), 20)
  for (j in 1:3) d[[paste0("i", j)]] <- person[d$id] + person_time[cbind(d$id, d$time)] + j * 0.3 + stats::rnorm(80, sd = 0.6)
  d
}

test_that("compute_shrout matches the reliability coefficients of psych::mlr", {
  reference <- suppressWarnings(psych::mlr(shrout_data(), grp = "id", Time = "time", items = c("i1", "i2", "i3"),
                                           aov = TRUE, lmer = FALSE, lme = FALSE, alpha = FALSE, plot = FALSE))
  vc <- reference$components
  rwf <- compute_shrout(sperson = vc["ID", 1], spersonitem = vc["ID x items", 1], stime = vc["Time", 1],
                        spersontime = vc["ID x time", 1], serror = vc["Residual", 1], m = 3, k = 4)
  value <- stats::setNames(rwf$result, rwf$measure)
  expect_equal(unname(value["rkf"]), reference$RkF)
  expect_equal(unname(value["r1r"]), reference$R1R)
  expect_equal(unname(value["rkr"]), reference$RkR)
  expect_equal(unname(value["rc"]), reference$Rc)
})

test_that("compute_shrout follows the Shrout and Lane formulas", {
  sperson <- 2; spersonitem <- 0.4; stime <- 0.3; spersontime <- 0.6; serror <- 1.2; m <- 4; k <- 5
  rwf <- compute_shrout(sperson, spersonitem, stime, spersontime, serror, m, k)
  value <- stats::setNames(rwf$result, rwf$measure)
  between <- sperson + spersonitem / m
  expect_equal(unname(value["r1f"]), between / (between + serror / m))
  expect_equal(unname(value["rkf"]), between / (between + serror / (k * m)))
  expect_equal(unname(value["r1r"]), between / (between + stime + spersontime + serror / m))
  expect_equal(unname(value["rkr"]), between / (between + stime / k + spersontime / k + serror / (k * m)))
  expect_equal(unname(value["rc"]), spersontime / (spersontime + serror / m))
})

test_that("compute_shrout returns one described row per coefficient", {
  rwf <- compute_shrout(2, 0.4, 0.3, 0.6, 1.2, 4, 5)
  expect_s3_class(rwf, "data.frame")
  expect_named(rwf, c("measure", "result", "description"))
  expect_setequal(rwf$measure, c("r1f", "r1r", "rkf", "rkr", "rc"))
  expect_equal(rwf$description[rwf$measure == "rc"], "Reliability (within persons) of change")
  expect_true(all(rwf$result > 0 & rwf$result < 1))
  # averaging over more items and time points increases reliability
  value <- stats::setNames(rwf$result, rwf$measure)
  expect_gt(value[["rkf"]], value[["r1f"]])
  expect_gt(value[["rkr"]], value[["r1r"]])
})
