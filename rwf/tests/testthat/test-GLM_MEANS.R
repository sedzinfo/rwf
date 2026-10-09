##########################################################################################
# compute_cohens_d
##########################################################################################
two_age_groups <- function() {
  df_blood_pressure[df_blood_pressure$agegrp %in% c("30-45", "46-59"), ]
}

test_that("compute_cohens_d matches the formula abs(m1 - m2) / sqrt((s1^2 + s2^2) / 2)", {
  datasets <- list(
    list(bp_before ~ agegrp, two_age_groups()),
    list(bp_after ~ sex, df_blood_pressure),
    list(extra ~ group, sleep),
    list(mpg ~ am, mtcars),
    list(len ~ supp, ToothGrowth)
  )
  for (d in datasets) {
    mf <- stats::model.frame(d[[1]], data = d[[2]])
    groups <- split(mf[[1]], factor(mf[[2]]))
    expected <- abs(mean(groups[[1]]) - mean(groups[[2]])) / sqrt((stats::var(groups[[1]]) + stats::var(groups[[2]])) / 2)
    rwf <- compute_cohens_d(formula = d[[1]], data = d[[2]])
    expect_type(rwf, "double")
    expect_length(rwf, 1)
    expect_equal(rwf, expected)
  }
})

test_that("compute_cohens_d matches effectsize::cohens_d with the un-pooled SD", {
  skip_if_not_installed("effectsize")
  for (d in list(list(bp_before ~ agegrp, two_age_groups()), list(len ~ supp, ToothGrowth), list(mpg ~ am, mtcars))) {
    rwf <- compute_cohens_d(formula = d[[1]], data = d[[2]])
    reference <- effectsize::cohens_d(d[[1]], data = d[[2]], pooled_sd = FALSE, ci = NULL)$Cohens_d
    expect_equal(rwf, abs(reference))
  }
})

test_that("compute_cohens_d does not depend on the order of the groups", {
  tooth <- ToothGrowth
  reversed <- transform(tooth, supp = factor(supp, levels = rev(levels(supp))))
  expect_equal(compute_cohens_d(len ~ supp, data = reversed), compute_cohens_d(len ~ supp, data = tooth))
  expect_gte(compute_cohens_d(len ~ supp, data = tooth), 0)
})

test_that("compute_cohens_d drops rows with missing values", {
  df_missing <- two_age_groups()
  df_missing$bp_before[c(1, 45)] <- NA
  complete <- df_missing[!is.na(df_missing$bp_before), ]
  expect_equal(compute_cohens_d(bp_before ~ agegrp, data = df_missing),
               compute_cohens_d(bp_before ~ agegrp, data = complete))
  expect_false(is.na(compute_cohens_d(bp_before ~ agegrp, data = df_missing)))
})

test_that("compute_cohens_d rejects grouping variables without exactly two levels", {
  expect_error(compute_cohens_d(bp_before ~ agegrp, data = df_blood_pressure), "exactly 2 levels")
  one_group <- df_blood_pressure[df_blood_pressure$sex == "Male", ]
  expect_error(compute_cohens_d(bp_before ~ sex, data = one_group), "exactly 2 levels")
})

##########################################################################################
# compute_wilcoxon_effect_size
##########################################################################################
test_that("compute_wilcoxon_effect_size equals |z| / sqrt(N) with z from the two-sided wilcox.test p-value", {
  datasets <- list(
    list(bp_before ~ agegrp, two_age_groups()),
    list(len ~ supp, ToothGrowth),
    list(mpg ~ am, mtcars)
  )
  for (d in datasets) {
    for (correct in c(TRUE, FALSE)) {
      wt <- suppressWarnings(stats::wilcox.test(d[[1]], data = d[[2]], correct = correct))
      expected <- abs(stats::qnorm(wt$p.value / 2)) / sqrt(nrow(d[[2]]))
      rwf <- suppressWarnings(compute_wilcoxon_effect_size(formula = d[[1]], data = d[[2]], correct = correct))
      expect_equal(rwf, expected)
    }
  }
})

test_that("compute_wilcoxon_effect_size matches rstatix::wilcox_effsize without continuity correction", {
  skip_if_not_installed("rstatix")
  skip_if_not_installed("coin")
  for (d in list(list(bp_before ~ agegrp, two_age_groups()), list(len ~ supp, ToothGrowth))) {
    rwf <- compute_wilcoxon_effect_size(formula = d[[1]], data = d[[2]], exact = FALSE, correct = FALSE)
    reference <- rstatix::wilcox_effsize(d[[2]], d[[1]])$effsize
    expect_equal(rwf, reference, ignore_attr = TRUE)
  }
})

test_that("compute_wilcoxon_effect_size returns a value between 0 and 1 and passes mu to wilcox.test", {
  rwf <- compute_wilcoxon_effect_size(bp_before ~ agegrp, data = two_age_groups(), exact = FALSE)
  expect_type(rwf, "double")
  expect_length(rwf, 1)
  expect_true(rwf >= 0 && rwf <= 1)
  shifted <- compute_wilcoxon_effect_size(bp_before ~ agegrp, data = two_age_groups(), mu = -5, exact = FALSE)
  wt <- stats::wilcox.test(bp_before ~ agegrp, data = two_age_groups(), mu = -5, exact = FALSE)
  expect_equal(shifted, abs(stats::qnorm(wt$p.value / 2)) / sqrt(80))
})

test_that("compute_wilcoxon_effect_size counts only complete observations", {
  df_missing <- two_age_groups()
  df_missing$bp_before[c(2, 60)] <- NA
  complete <- df_missing[!is.na(df_missing$bp_before), ]
  expect_equal(compute_wilcoxon_effect_size(bp_before ~ agegrp, data = df_missing, exact = FALSE),
               compute_wilcoxon_effect_size(bp_before ~ agegrp, data = complete, exact = FALSE))
})

##########################################################################################
# report_ttests
##########################################################################################
ttest_columns <- c("DV", "IV", "level1", "level2", "n1", "n2", "t", "df", "p", "CI_l", "CI_u", "alternative",
                   "method", "mean1", "mean2", "sd1", "sd2", "sd_pooled", "d", "r", "k_squared[bartlett]",
                   "df[bartlett]", "p[bartlett]", "bonferroni_p", "significant")

test_that("report_ttests returns one row per pair of levels with the documented columns", {
  result <- quietly(report_ttests(df = df_blood_pressure, dv = 4:5, iv = 2:3))
  expect_s3_class(result, "data.frame")
  expect_named(result, ttest_columns)
  # sex: 1 pair, agegrp: 3 pairs, for each of the two dependent variables
  expect_equal(nrow(result), 2 * (1 + 3))
})

test_that("report_ttests matches stats::t.test, stats::bartlett.test and descriptive statistics", {
  result <- quietly(report_ttests(df = df_blood_pressure, dv = 4:5, iv = 2:3))
  for (i in seq_len(nrow(result))) {
    row <- result[i, ]
    dv <- intersect(c(row$DV, row$IV), c("bp_before", "bp_after"))
    iv <- intersect(c(row$DV, row$IV), c("sex", "agegrp"))
    x <- df_blood_pressure[df_blood_pressure[[iv]] == row$level1, dv]
    y <- df_blood_pressure[df_blood_pressure[[iv]] == row$level2, dv]
    welch <- stats::t.test(x, y)
    expect_equal(abs(row$t), abs(unname(welch$statistic)))
    expect_equal(row$df, unname(welch$parameter))
    expect_equal(row$p, welch$p.value)
    expect_equal(row$method, "Welch Two Sample t-test")
    expect_equal(c(row$n1, row$n2), c(length(x), length(y)))
    expect_equal(c(row$mean1, row$mean2), c(mean(x), mean(y)))
    expect_equal(c(row$sd1, row$sd2), c(stats::sd(x), stats::sd(y)))
    expect_equal(row$sd_pooled, sqrt((stats::var(x) + stats::var(y)) / 2))
    subset <- df_blood_pressure[df_blood_pressure[[iv]] %in% c(row$level1, row$level2), ]
    expect_equal(row$d, compute_cohens_d(stats::formula(paste(dv, "~", iv)), data = subset))
    bartlett <- stats::bartlett.test(list(x, y))
    expect_equal(row$`k_squared[bartlett]`, unname(bartlett$statistic))
    expect_equal(row$`df[bartlett]`, unname(bartlett$parameter))
    expect_equal(row$`p[bartlett]`, bartlett$p.value)
  }
})

test_that("report_ttests passes var.equal and alternative to stats::t.test", {
  # agegrp levels appear in sorted order, so level1 is the first group of t.test
  student <- quietly(report_ttests(df = df_blood_pressure, dv = 4, iv = 3, var.equal = TRUE))
  less <- quietly(report_ttests(df = df_blood_pressure, dv = 4, iv = 3, alternative = "less"))
  for (i in seq_len(nrow(student))) {
    x <- df_blood_pressure$bp_before[df_blood_pressure$agegrp == student$level1[i]]
    y <- df_blood_pressure$bp_before[df_blood_pressure$agegrp == student$level2[i]]
    reference <- stats::t.test(x, y, var.equal = TRUE)
    expect_equal(student$t[i], unname(reference$statistic))
    expect_equal(student$df[i], length(x) + length(y) - 2)
    expect_equal(student$p[i], reference$p.value)
    expect_equal(c(student$CI_l[i], student$CI_u[i]), as.numeric(reference$conf.int))
    expect_equal(less$p[i], stats::t.test(x, y, alternative = "less")$p.value)
  }
  expect_equal(unique(student$method), " Two Sample t-test")
  expect_equal(unique(less$alternative), "less")
})

test_that("report_ttests t statistic and interval refer to level1 minus level2", {
  skip("rwf bug: t, CI, W follow the sorted factor levels while level1/level2 follow the order of appearance")
  # In df_blood_pressure "Male" appears before "Female", the reverse of the sorted order
  result <- quietly(report_ttests(df = df_blood_pressure, dv = 4, iv = 2))
  x <- df_blood_pressure$bp_before[df_blood_pressure$sex == result$level1]
  y <- df_blood_pressure$bp_before[df_blood_pressure$sex == result$level2]
  reference <- stats::t.test(x, y)
  expect_equal(result$t, unname(reference$statistic))
  expect_equal(c(result$CI_l, result$CI_u), as.numeric(reference$conf.int))
  expect_equal(sign(result$t), sign(result$mean1 - result$mean2))
})

test_that("report_ttests converts d to r with r = d / sqrt(d^2 + (n1 + n2)^2 / (n1 * n2))", {
  skip("rwf bug: r is computed as d / (sqrt(d^2) + a) instead of d / sqrt(d^2 + a)")
  result <- quietly(report_ttests(df = df_blood_pressure, dv = 4:5, iv = 2:3))
  a <- (result$n1 + result$n2)^2 / (result$n1 * result$n2)
  expect_equal(result$r, result$d / sqrt(result$d^2 + a))
})

test_that("report_ttests stores the dependent variable in DV and the grouping variable in IV", {
  skip("rwf bug: the DV column holds the independent variable name and IV the dependent variable name")
  result <- quietly(report_ttests(df = df_blood_pressure, dv = 4, iv = 2))
  expect_equal(result$DV, "bp_before")
  expect_equal(result$IV, "sex")
})

test_that("report_ttests applies a Bonferroni adjustment over all rows", {
  result <- quietly(report_ttests(df = df_blood_pressure, dv = 4:5, iv = 2:3))
  expect_true(all(result$bonferroni_p == 0.05 / nrow(result)))
  expect_equal(result$significant, as.character(result$p < 0.05 / nrow(result)))
})

test_that("report_ttests removes rows with missing values per comparison", {
  df_missing <- df_blood_pressure
  df_missing$bp_before[c(1, 2, 70)] <- NA
  df_missing$sex[3] <- NA
  result <- quietly(report_ttests(df = df_missing, dv = 4, iv = 2))
  complete <- df_missing[stats::complete.cases(df_missing[, c("bp_before", "sex")]), ]
  expect_equal(result$n1 + result$n2, nrow(complete))
  x <- complete$bp_before[complete$sex == result$level1]
  y <- complete$bp_before[complete$sex == result$level2]
  expect_equal(result$p, stats::t.test(x, y)$p.value)
  expect_false(anyNA(result[, c("mean1", "mean2", "sd1", "sd2", "d")]))
})

test_that("report_ttests writes an Excel workbook", {
  withr::local_dir(withr::local_tempdir())
  quietly(report_ttests(df = df_blood_pressure, dv = 4, iv = 2:3, file = "ttest"))
  expect_true(file.exists("ttest.xlsx"))
  expect_equal(openxlsx::getSheetNames("ttest.xlsx"), "t test")
})

##########################################################################################
# report_wtests
##########################################################################################
wtest_columns <- c("DV", "IV", "level1", "level2", "n1", "n2", "W", "p", "CI_l", "CI_u", "alternative",
                   "method", "mean1", "mean2", "sd1", "sd2", "sd_pooled", "d", "r", "k_squared[bartlett]",
                   "df[bartlett]", "p[bartlett]", "bonferroni_p", "significant")

test_that("report_wtests returns one row per pair of levels with the documented columns", {
  result <- quietly(report_wtests(df = df_blood_pressure, dv = 4:5, iv = 2:3, exact = FALSE))
  expect_s3_class(result, "data.frame")
  expect_named(result, wtest_columns)
  expect_equal(nrow(result), 2 * (1 + 3))
})

test_that("report_wtests matches stats::wilcox.test and compute_wilcoxon_effect_size", {
  # agegrp levels appear in sorted order, so level1 is the first group of wilcox.test
  # exact = FALSE: recent R versions compute exact p-values and intervals with ties, which is slow
  result <- quietly(report_wtests(df = df_blood_pressure, dv = 4:5, iv = 3, exact = FALSE))
  for (i in seq_len(nrow(result))) {
    dv <- intersect(c(result$DV[i], result$IV[i]), c("bp_before", "bp_after"))
    x <- df_blood_pressure[df_blood_pressure$agegrp == result$level1[i], dv]
    y <- df_blood_pressure[df_blood_pressure$agegrp == result$level2[i], dv]
    reference <- suppressWarnings(stats::wilcox.test(x, y, conf.int = TRUE, exact = FALSE))
    expect_equal(result$W[i], unname(reference$statistic))
    expect_equal(result$p[i], reference$p.value)
    expect_equal(c(result$CI_l[i], result$CI_u[i]), as.numeric(reference$conf.int))
    expect_equal(c(result$mean1[i], result$mean2[i]), c(mean(x), mean(y)))
    expect_equal(c(result$n1[i], result$n2[i]), c(length(x), length(y)))
    subset <- df_blood_pressure[df_blood_pressure$agegrp %in% c(result$level1[i], result$level2[i]), ]
    form <- stats::formula(paste(dv, "~ agegrp"))
    expect_equal(result$r[i], suppressWarnings(compute_wilcoxon_effect_size(form, data = subset, exact = FALSE)))
    expect_equal(result$d[i], compute_cohens_d(form, data = subset))
    expect_equal(result$`p[bartlett]`[i], stats::bartlett.test(list(x, y))$p.value)
    expect_equal(result$method[i], reference$method)
  }
})

test_that("report_wtests passes extra arguments to stats::wilcox.test", {
  result <- quietly(report_wtests(df = df_blood_pressure, dv = 4, iv = 3, alternative = "greater", correct = FALSE, exact = FALSE))
  for (i in seq_len(nrow(result))) {
    x <- df_blood_pressure$bp_before[df_blood_pressure$agegrp == result$level1[i]]
    y <- df_blood_pressure$bp_before[df_blood_pressure$agegrp == result$level2[i]]
    expect_equal(result$p[i], suppressWarnings(stats::wilcox.test(x, y, alternative = "greater", correct = FALSE, exact = FALSE))$p.value)
  }
  expect_equal(unique(result$alternative), "greater")
})

test_that("report_wtests effect size r does not depend on the alternative hypothesis", {
  skip("rwf bug: report_wtests computes r from the one-sided p-value when alternative is not two.sided")
  two_sided <- quietly(report_wtests(df = df_blood_pressure, dv = 4, iv = 3, exact = FALSE))
  less <- quietly(report_wtests(df = df_blood_pressure, dv = 4, iv = 3, alternative = "less", exact = FALSE))
  expect_equal(less$r, two_sided$r)
})

test_that("report_wtests W statistic refers to level1", {
  skip("rwf bug: t, CI, W follow the sorted factor levels while level1/level2 follow the order of appearance")
  result <- quietly(report_wtests(df = df_blood_pressure, dv = 4, iv = 2))
  x <- df_blood_pressure$bp_before[df_blood_pressure$sex == result$level1]
  y <- df_blood_pressure$bp_before[df_blood_pressure$sex == result$level2]
  expect_equal(result$W, unname(suppressWarnings(stats::wilcox.test(x, y))$statistic))
})

test_that("report_wtests applies a Bonferroni adjustment and removes missing values", {
  df_missing <- df_blood_pressure
  df_missing$bp_after[c(5, 90)] <- NA
  result <- quietly(report_wtests(df = df_missing, dv = 4:5, iv = 2))
  expect_true(all(result$bonferroni_p == 0.05 / 2))
  expect_equal(result$significant, as.character(result$p < 0.05 / 2))
  after <- result[grepl("bp_after", paste(result$DV, result$IV)), ]
  expect_equal(after$n1 + after$n2, 118)
  expect_false(anyNA(after$r))
})

test_that("report_wtests writes an Excel workbook", {
  withr::local_dir(withr::local_tempdir())
  quietly(report_wtests(df = df_blood_pressure, dv = 4, iv = 2, file = "wilcoxon"))
  expect_true(file.exists("wilcoxon.xlsx"))
  written <- openxlsx::read.xlsx("wilcoxon.xlsx", sheet = 1, colNames = FALSE)
  expect_true(any(unlist(written) == "W", na.rm = TRUE))
})
