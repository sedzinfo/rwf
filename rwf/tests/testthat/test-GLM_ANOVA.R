##########################################################################################
# compute_kruskal_wallis_test
##########################################################################################
test_that("compute_kruskal_wallis_test matches stats::kruskal.test", {
  datasets <- list(
    list(bp_before ~ agegrp, df_blood_pressure),
    list(qsec ~ cyl, mtcars),
    list(weight ~ group, PlantGrowth),
    list(count ~ spray, InsectSprays),
    list(weight ~ feed, chickwts)
  )
  for (d in datasets) {
    rwf <- compute_kruskal_wallis_test(formula = d[[1]], df = d[[2]])
    kw <- stats::kruskal.test(d[[1]], data = d[[2]])
    expect_equal(rwf$H, unname(kw$statistic))
    expect_equal(rwf$df, unname(kw$parameter))
    expect_equal(rwf$p, kw$p.value)
  }
})

test_that("compute_kruskal_wallis_test epsilon-squared is the R-squared of an ANOVA on ranks", {
  rwf <- compute_kruskal_wallis_test(formula = bp_before ~ agegrp, df = df_blood_pressure)
  r_squared <- summary(stats::lm(rank(bp_before) ~ agegrp, data = df_blood_pressure))$r.squared
  expect_equal(rwf$epsilonsq, r_squared)
})

test_that("compute_kruskal_wallis_test effect sizes match rstatix, effectsize and rcompanion", {
  skip_if_not_installed("rstatix")
  skip_if_not_installed("effectsize")
  skip_if_not_installed("rcompanion")
  form <- bp_before ~ agegrp
  rwf <- compute_kruskal_wallis_test(formula = form, df = df_blood_pressure)
  expect_equal(rwf$etasq, rstatix::kruskal_effsize(df_blood_pressure, form)$effsize)
  expect_equal(rwf$epsilonsq, rstatix::kruskal_effsize(df_blood_pressure, form, method = "epsilon2")$effsize, ignore_attr = TRUE)
  expect_equal(rwf$etasq, effectsize::rank_eta_squared(form, data = df_blood_pressure, ci = NULL)$rank_eta_squared)
  expect_equal(rwf$epsilonsq, effectsize::rank_epsilon_squared(form, data = df_blood_pressure, ci = NULL)$rank_epsilon_squared)
  expect_equal(rwf$epsilonsq, unname(rcompanion::epsilonSquared(x = df_blood_pressure$bp_before, g = df_blood_pressure$agegrp, digits = 15)))
})

test_that("compute_kruskal_wallis_test removes missing values like stats::kruskal.test", {
  df_missing <- df_blood_pressure
  df_missing$bp_before[c(1, 50)] <- NA
  df_missing$bp_after[2] <- NA
  rwf <- compute_kruskal_wallis_test(formula = bp_before ~ agegrp, df = df_missing)
  kw <- stats::kruskal.test(bp_before ~ agegrp, data = df_missing)
  expect_equal(rwf$H, unname(kw$statistic))
  expect_equal(rwf$p, kw$p.value)
})

test_that("compute_kruskal_wallis_test returns a negative eta-squared when H < k - 1", {
  identical_groups <- data.frame(group = rep(c("a", "b", "c"), each = 5), score = rep(1:5, times = 3))
  rwf <- compute_kruskal_wallis_test(formula = score ~ group, df = identical_groups)
  expect_equal(rwf$H, 0)
  expect_equal(rwf$etasq, (0 - 3 + 1) / (15 - 3))
})

test_that("compute_kruskal_wallis_test bootstrap intervals are reproducible and contain the estimates", {
  set.seed(1)
  first <- compute_kruskal_wallis_test(formula = bp_before ~ agegrp, df = df_blood_pressure, ci = TRUE, nboot = 200)
  set.seed(1)
  second <- compute_kruskal_wallis_test(formula = bp_before ~ agegrp, df = df_blood_pressure, ci = TRUE, nboot = 200)
  expect_identical(first, second)
  expect_named(first, c("formula", "method", "etasq", "etasq_lower", "etasq_upper",
                        "epsilonsq", "epsilonsq_lower", "epsilonsq_upper", "H", "df", "p"))
  expect_true(first$etasq_lower <= first$etasq && first$etasq <= first$etasq_upper)
  expect_true(first$epsilonsq_lower <= first$epsilonsq && first$epsilonsq <= first$epsilonsq_upper)
})

##########################################################################################
# compute_friedman_test
##########################################################################################
rounding_times <- function() {
  times <- matrix(c(5.40, 5.50, 5.55, 5.85, 5.70, 5.75, 5.20, 5.60, 5.50, 5.55, 5.50, 5.40,
                    5.90, 5.85, 5.70, 5.45, 5.55, 5.60, 5.40, 5.40, 5.35, 5.45, 5.50, 5.35,
                    5.25, 5.15, 5.00, 5.85, 5.80, 5.70, 5.25, 5.20, 5.10, 5.65, 5.55, 5.45,
                    5.60, 5.35, 5.45, 5.05, 5.00, 4.95, 5.50, 5.50, 5.40, 5.45, 5.55, 5.50,
                    5.55, 5.55, 5.35, 5.45, 5.50, 5.55, 5.50, 5.45, 5.25, 5.65, 5.60, 5.40,
                    5.70, 5.65, 5.55, 6.30, 6.30, 6.25),
                  nrow = 22, byrow = TRUE)
  data.frame(time = c(times),
             method = rep(c("Round Out", "Narrow Angle", "Wide Angle"), each = 22),
             player = rep(1:22, times = 3))
}

test_that("compute_friedman_test matches stats::friedman.test, with and without ties", {
  datasets <- list(
    list(uptake ~ conc | Plant, df_co2),
    list(time ~ method | player, rounding_times()),
    list(decrease ~ treatment | rowpos, OrchardSprays),
    list(circumference ~ age | Tree, as.data.frame(Orange))
  )
  for (d in datasets) {
    rwf <- compute_friedman_test(formula = d[[1]], df = d[[2]])
    fr <- stats::friedman.test(d[[1]], data = d[[2]])
    expect_equal(rwf$Q, unname(fr$statistic))
    expect_equal(rwf$df, unname(fr$parameter))
    expect_equal(rwf$p, fr$p.value)
  }
})

test_that("compute_friedman_test Kendall's W matches rstatix and effectsize", {
  skip_if_not_installed("rstatix")
  skip_if_not_installed("effectsize")
  form <- uptake ~ conc | Plant
  rwf <- compute_friedman_test(formula = form, df = df_co2)
  expect_equal(rwf$kendall_w, rwf$Q / (rwf$n * rwf$df))
  expect_equal(rwf$kendall_w, rstatix::friedman_effsize(df_co2, form)$effsize, ignore_attr = TRUE)
  # effectsize::kendalls_w needs the rows sorted by block
  sorted <- df_co2[order(df_co2$Plant, df_co2$conc), ]
  expect_equal(rwf$kendall_w, suppressWarnings(effectsize::kendalls_w(form, data = sorted, ci = NULL)$Kendalls_W))
})

test_that("compute_friedman_test does not depend on the row order", {
  shuffled <- OrchardSprays[c(64:1), ]
  expect_equal(compute_friedman_test(decrease ~ treatment | rowpos, df = shuffled),
               compute_friedman_test(decrease ~ treatment | rowpos, df = OrchardSprays))
})

test_that("compute_friedman_test drops incomplete blocks", {
  df_missing <- df_co2
  df_missing$uptake[1] <- NA
  rwf <- compute_friedman_test(formula = uptake ~ conc | Plant, df = df_missing)
  complete_blocks <- df_co2[df_co2$Plant != df_co2$Plant[1], ]
  fr <- stats::friedman.test(uptake ~ conc | Plant, data = complete_blocks)
  expect_equal(rwf$n, 11)
  expect_equal(rwf$Q, unname(fr$statistic))
})

test_that("compute_friedman_test rejects replicated designs", {
  expect_error(compute_friedman_test(formula = uptake ~ conc | Plant, df = rbind(df_co2, df_co2[1, ])),
               "at most one observation per group")
})

test_that("compute_friedman_test bootstrap interval is reproducible and contains the estimate", {
  set.seed(1)
  first <- compute_friedman_test(formula = uptake ~ conc | Plant, df = df_co2, ci = TRUE, nboot = 200)
  set.seed(1)
  second <- compute_friedman_test(formula = uptake ~ conc | Plant, df = df_co2, ci = TRUE, nboot = 200)
  expect_identical(first, second)
  expect_true(first$kendall_w_lower <= first$kendall_w && first$kendall_w <= first$kendall_w_upper)
})

##########################################################################################
# compute_one_way_test
##########################################################################################
test_that("compute_one_way_test matches stats::oneway.test and aov", {
  form <- bp_before ~ agegrp
  for (var_equal in c(TRUE, FALSE)) {
    rwf <- compute_one_way_test(formula = form, df = df_blood_pressure, var.equal = var_equal)
    ow <- stats::oneway.test(form, data = df_blood_pressure, var.equal = var_equal)
    expect_equal(rwf$statistic, unname(ow$statistic))
    expect_equal(rwf$df_error, unname(ow$parameter[2]))
    expect_equal(rwf$p, ow$p.value)
  }
  fisher <- compute_one_way_test(formula = form, df = df_blood_pressure, var.equal = TRUE)
  anova_table <- summary(stats::aov(form, data = df_blood_pressure))[[1]]
  expect_equal(fisher$ss_effect, anova_table[1, "Sum Sq"])
  expect_equal(fisher$ss_error, anova_table[2, "Sum Sq"])
})

test_that("compute_one_way_test effect sizes match effectsize", {
  skip_if_not_installed("effectsize")
  model <- stats::aov(weight ~ feed, data = chickwts)
  fisher <- compute_one_way_test(formula = weight ~ feed, df = chickwts, var.equal = TRUE)
  expect_equal(fisher$etasq, effectsize::eta_squared(model, partial = FALSE, ci = NULL)$Eta2)
  expect_equal(fisher$omegasq, effectsize::omega_squared(model, partial = FALSE, ci = NULL)$Omega2)
  expect_equal(fisher$cohens.f, effectsize::cohens_f(model, ci = NULL, verbose = FALSE)$Cohens_f)
  welch <- compute_one_way_test(formula = weight ~ feed, df = chickwts, var.equal = FALSE)
  expect_equal(welch$etasq, effectsize::F_to_eta2(welch$statistic, welch$df_effect, welch$df_error, ci = NULL)$Eta2_partial)
  expect_equal(welch$omegasq, effectsize::F_to_omega2(welch$statistic, welch$df_effect, welch$df_error, ci = NULL)$Omega2_partial)
  expect_equal(welch$cohens.f, effectsize::F_to_f(welch$statistic, welch$df_effect, welch$df_error, ci = NULL)$Cohens_f_partial)
})

test_that("compute_one_way_test power matches pwr and sjstats", {
  fisher <- compute_one_way_test(formula = bp_before ~ agegrp, df = df_blood_pressure, var.equal = TRUE)
  expect_equal(fisher$power, pwr::pwr.anova.test(k = 3, n = 40, f = fisher$cohens.f)$power)
  sjstats_table <- as.data.frame(sjstats::anova_stats(stats::lm(bp_before ~ agegrp, data = df_blood_pressure), digits = 22))
  expect_equal(fisher$power, sjstats_table$power[1])
})

test_that("compute_one_way_test with two groups gives F = t^2", {
  for (var_equal in c(TRUE, FALSE)) {
    rwf <- compute_one_way_test(formula = bp_before ~ sex, df = df_blood_pressure, var.equal = var_equal)
    t_test <- stats::t.test(bp_before ~ sex, data = df_blood_pressure, var.equal = var_equal)
    expect_equal(rwf$statistic, unname(t_test$statistic^2))
    expect_equal(rwf$df_error, unname(t_test$parameter))
  }
})

test_that("compute_one_way_test removes missing values like stats::oneway.test", {
  df_missing <- df_blood_pressure
  df_missing$bp_before[c(1, 50)] <- NA
  df_missing$bp_after[2] <- NA
  rwf <- compute_one_way_test(formula = bp_before ~ agegrp, df = df_missing, var.equal = TRUE)
  ow <- stats::oneway.test(bp_before ~ agegrp, data = df_missing, var.equal = TRUE)
  expect_equal(rwf$statistic, unname(ow$statistic))
  expect_equal(rwf$df_error, 115)
})

##########################################################################################
# compute_posthoc
##########################################################################################
test_that("compute_posthoc Tukey matches stats::TukeyHSD and emmeans", {
  for (d in list(list(df_blood_pressure$bp_before, df_blood_pressure$agegrp), list(chickwts$weight, chickwts$feed))) {
    y <- d[[1]]
    x <- factor(d[[2]])
    rwf <- compute_posthoc(y = y, x = x)$output$tukey
    model <- stats::aov(y ~ x)
    expect_equal(unname(rwf[, "p"]), unname(stats::TukeyHSD(model)$x[, "p adj"]))
    contrasts_tukey <- as.data.frame(summary(graphics::pairs(emmeans::emmeans(model, ~x), adjust = "tukey")))
    expect_equal(unname(rwf[, "t"]), abs(contrasts_tukey$t.ratio))
    expect_equal(unname(rwf[, "p"]), contrasts_tukey$p.value)
  }
})

test_that("compute_posthoc Games-Howell matches rstatix and Welch t tests", {
  skip_if_not_installed("rstatix")
  x <- factor(chickwts$feed)
  y <- chickwts$weight
  rwf <- compute_posthoc(y = y, x = x)$output$games.howell
  rstatix_gh <- as.data.frame(rstatix::games_howell_test(data.frame(y = y, x = x), y ~ x))
  expect_equal(unname(rwf[, "p"]), rstatix_gh$p.adj)
  pairs <- utils::combn(levels(x), 2)
  welch <- apply(pairs, 2, function(p) {
    welch_t <- stats::t.test(y[x == p[1]], y[x == p[2]], var.equal = FALSE)
    c(abs(unname(welch_t$statistic)), unname(welch_t$parameter))
  })
  expect_equal(unname(rwf[, "t"]), welch[1, ])
  expect_equal(unname(rwf[, "df"]), welch[2, ])
})

test_that("compute_posthoc names the pairs in the order of the factor levels", {
  rwf <- compute_posthoc(y = df_blood_pressure$bp_before, x = df_blood_pressure$agegrp)$output
  expect_equal(rownames(rwf$tukey), c("30-45:46-59", "30-45:60+", "46-59:60+"), ignore_attr = TRUE)
  expect_equal(rownames(rwf$games.howell), rownames(rwf$tukey))
})

##########################################################################################
# compute_aov_es
##########################################################################################
test_that("compute_aov_es matches effectsize for Type I, II and III sums of squares", {
  skip_if_not_installed("effectsize")
  withr::local_options(contrasts = c("contr.sum", "contr.poly"))
  cars <- transform(mtcars, cyl = factor(cyl), am = factor(am))
  model <- stats::aov(mpg ~ cyl * am, data = cars)
  for (ss in c("I", "II", "III")) {
    rwf <- compute_aov_es(model = model, ss = ss)
    rwf <- rwf[!is.na(rwf$etasq), ]
    table <- if (ss == "I") model else car::Anova(model, type = ss)
    effectsize_value <- function(fun, ...) {
      values <- as.data.frame(suppressMessages(fun(table, ci = NULL, ...)))
      values[match(rwf$comparisons, values$Parameter), 2]
    }
    expect_equal(rwf$etasq, effectsize_value(effectsize::eta_squared, partial = FALSE))
    expect_equal(rwf$partial_etasq, effectsize_value(effectsize::eta_squared, partial = TRUE))
    expect_equal(pmax(0, rwf$omegasq), effectsize_value(effectsize::omega_squared, partial = FALSE))
    expect_equal(pmax(0, rwf$partial_omegasq), effectsize_value(effectsize::omega_squared, partial = TRUE))
    expect_equal(pmax(0, rwf$epsilonsq), effectsize_value(effectsize::epsilon_squared, partial = FALSE))
    expect_equal(rwf$cohens_f, effectsize_value(effectsize::cohens_f, partial = TRUE))
  }
})

test_that("compute_aov_es keeps negative omega-squared, as sjstats does", {
  withr::local_seed(5)
  tooth <- transform(ToothGrowth, dose = factor(dose), noise = factor(sample(c("a", "b"), 60, replace = TRUE)))
  model <- stats::aov(len ~ dose + noise, data = tooth)
  rwf <- compute_aov_es(model = model)
  sjstats_table <- as.data.frame(sjstats::anova_stats(model, digits = 22))
  expect_lt(rwf$omegasq[2], 0)
  expect_equal(rwf$omegasq[1:2], sjstats_table$omegasq[1:2])
  expect_equal(rwf$partial_omegasq[1:2], sjstats_table$partial.omegasq[1:2])
  expect_equal(rwf$epsilonsq[1:2], sjstats_table$epsilonsq[1:2])
})

test_that("compute_aov_es agrees with compute_one_way_test in a one-way design", {
  one_way <- compute_one_way_test(formula = weight ~ feed, df = chickwts, var.equal = TRUE)
  aov_es <- compute_aov_es(model = stats::aov(weight ~ feed, data = chickwts))
  expect_equal(aov_es$etasq[1], one_way$etasq)
  expect_equal(aov_es$omegasq[1], one_way$omegasq)
  expect_equal(aov_es$cohens_f[1], one_way$cohens.f)
})

test_that("compute_aov_es works with a model fitted inside a function", {
  fit <- function() {
    fm <- uptake ~ Treatment * Type
    compute_aov_es(model = stats::aov(fm, data = CO2))
  }
  expect_equal(fit()$call[1], "uptake ~ Treatment * Type")
})

test_that("compute_aov_es rejects an unknown type of sums of squares", {
  expect_error(compute_aov_es(model = stats::aov(uptake ~ Treatment, data = CO2), ss = "3"), "should be one of")
})

test_that("compute_aov_es computes Type I for models with aliased terms", {
  model <- stats::aov(yield ~ block + N * P * K, data = npk)
  rwf <- compute_aov_es(model = model, ss = "I")
  expect_equal(rwf$`Sum Sq`, unname(summary(model)[[1]][, "Sum Sq"]))
})

##########################################################################################
# report_oneway
##########################################################################################
test_that("report_oneway returns one row per combination, matching the compute functions", {
  result <- quietly(report_oneway(df = df_blood_pressure, dv = 4:5, iv = 2:3, file = NULL))
  expect_named(result, c("instructions", "fisher", "welch", "kruskal_wallis", "games_howell", "tukey", "homogeneity"))
  expect_equal(nrow(result$fisher), 4)
  for (dv in c("bp_before", "bp_after")) {
    for (iv in c("sex", "agegrp")) {
      form <- stats::formula(paste(dv, "~", iv))
      fisher <- result$fisher[result$fisher$DV == dv & result$fisher$IV == iv, ]
      welch <- result$welch[result$welch$DV == dv & result$welch$IV == iv, ]
      kruskal <- result$kruskal_wallis[result$kruskal_wallis$DV == dv & result$kruskal_wallis$IV == iv, ]
      expect_equal(fisher$statistic, compute_one_way_test(formula = form, df = df_blood_pressure, var.equal = TRUE)$statistic)
      expect_equal(welch$statistic, compute_one_way_test(formula = form, df = df_blood_pressure, var.equal = FALSE)$statistic)
      expect_equal(kruskal$H, compute_kruskal_wallis_test(formula = form, df = df_blood_pressure)$H)
      posthoc <- compute_posthoc(y = df_blood_pressure[[dv]], x = factor(df_blood_pressure[[iv]]))$output
      tukey <- result$tukey[result$tukey$DV == dv & result$tukey$IV == iv, ]
      games_howell <- result$games_howell[result$games_howell$DV == dv & result$games_howell$IV == iv, ]
      expect_equal(tukey$p, unname(posthoc$tukey[, "p"]))
      expect_equal(games_howell$p, unname(posthoc$games.howell[, "p"]))
    }
  }
})

test_that("report_oneway homogeneity tests match car::leveneTest and stats::bartlett.test", {
  result <- quietly(report_oneway(df = df_blood_pressure, dv = 4, iv = 3, file = NULL))
  levene <- car::leveneTest(bp_before ~ factor(agegrp), data = df_blood_pressure, center = mean)
  bartlett <- stats::bartlett.test(bp_before ~ agegrp, data = df_blood_pressure)
  expect_equal(result$homogeneity$Statistic[result$homogeneity$Test == "Levene"], levene$`F value`[1])
  expect_equal(result$homogeneity$p[result$homogeneity$Test == "Levene"], levene$`Pr(>F)`[1])
  expect_equal(result$homogeneity$Statistic[result$homogeneity$Test == "Bartlett"], unname(bartlett$statistic))
  expect_equal(result$homogeneity$p[result$homogeneity$Test == "Bartlett"], bartlett$p.value)
})

test_that("report_oneway applies a Bonferroni adjustment across the combinations", {
  result <- quietly(report_oneway(df = df_blood_pressure, dv = 4:5, iv = 2:3, file = NULL))
  expect_true(all(result$fisher$bonferroni_p == 0.05 / 4))
  expect_equal(result$fisher$significant, as.character(result$fisher$p < 0.05 / 4))
  expect_equal(result$kruskal_wallis$significant, as.character(result$kruskal_wallis$p < 0.05 / 4))
})

test_that("report_oneway drops groups with a single observation and missing values", {
  # carb levels 6 and 8 have one car each, leaving 4 groups and 6 pairs
  result <- quietly(report_oneway(df = mtcars, dv = 1, iv = 11, file = NULL))
  kept <- mtcars[mtcars$carb %in% c(1, 2, 3, 4), ]
  expect_equal(nrow(result$tukey), 6)
  expect_equal(result$fisher$statistic, compute_one_way_test(formula = mpg ~ carb, df = kept)$statistic)
  df_missing <- df_blood_pressure
  df_missing$bp_before[1:3] <- NA
  result_missing <- quietly(report_oneway(df = df_missing, dv = 4, iv = 3, file = NULL))
  expect_equal(result_missing$fisher$df_error, 114)
  expect_false(anyNA(result_missing$tukey$p))
})

test_that("report_oneway writes an Excel workbook", {
  withr::local_dir(withr::local_tempdir())
  quietly(report_oneway(df = df_blood_pressure, dv = 4:5, iv = 2:3, file = "anova"))
  expect_true(file.exists("anova.xlsx"))
  expect_setequal(openxlsx::getSheetNames("anova.xlsx"),
                  c("Fisher", "Welch", "Kruskal", "Homogeneity", "Tukey", "Games-Howell", "Descriptives"))
})

test_that("report_oneway writes the Tukey comparisons to the workbook", {
  withr::local_dir(withr::local_tempdir())
  result <- quietly(report_oneway(df = df_blood_pressure, dv = 4:5, iv = 2:3, file = "anova"))
  sheet <- openxlsx::read.xlsx("anova.xlsx", sheet = "Tukey", colNames = FALSE)
  values <- suppressWarnings(as.numeric(unlist(sheet)))
  expect_true(all(signif(result$tukey$p, 6) %in% signif(values, 6)))
})

##########################################################################################
# report_factorial_anova
##########################################################################################
test_that("report_factorial_anova passes a between-subjects design to ez::ezANOVA", {
  tooth <- transform(ToothGrowth, id = factor(seq_len(nrow(ToothGrowth))), dose = factor(dose))
  result <- quietly(report_factorial_anova(df = tooth, dv = "len", wid = "id", between = c("supp", "dose")))
  ez <- quietly(ez::ezANOVA(data = tooth, dv = len, wid = id, between = .(supp, dose), type = 3,
                            white.adjust = TRUE, detailed = TRUE))
  omnibus <- result$omnibus[match(ez$ANOVA$Effect, result$omnibus$Effect), ]
  expect_equal(omnibus$F, ez$ANOVA$F)
  expect_equal(omnibus$p, ez$ANOVA$p)
  expect_equal(unique(result$omnibus$`F[L]`), ez$`Levene's Test for Homogeneity of Variance`$F)
  expect_equal(unique(result$omnibus$`p[L]`), ez$`Levene's Test for Homogeneity of Variance`$p)
})

test_that("report_factorial_anova effect sizes agree with compute_aov_es", {
  tooth <- transform(ToothGrowth, id = factor(seq_len(nrow(ToothGrowth))), dose = factor(dose))
  result <- quietly(report_factorial_anova(df = tooth, dv = "len", wid = "id", between = c("supp", "dose")))
  aov_es <- compute_aov_es(model = result$object$len$aov, ss = "I")
  effect_size <- result$omnibus_effect_size[match(aov_es$comparisons[1:3], result$omnibus_effect_size$term), ]
  # sjstats rounds to 3 decimals
  expect_lte(max(abs(effect_size$etasq - aov_es$etasq[1:3])), 0.0005 + 1e-12)
  expect_lte(max(abs(effect_size$partial.omegasq - aov_es$partial_omegasq[1:3])), 0.0005 + 1e-12)
})

test_that("report_factorial_anova post hoc comparisons match emmeans", {
  tooth <- transform(ToothGrowth, id = factor(seq_len(nrow(ToothGrowth))), dose = factor(dose))
  result <- quietly(report_factorial_anova(df = tooth, dv = "len", wid = "id", between = c("supp", "dose")))
  # supp: 1 pair, dose: 3 pairs, supp by dose: 15 pairs
  expect_equal(nrow(result$post_hoc), 1 + 3 + 15)
  dose_pairs <- as.data.frame(graphics::pairs(emmeans::emmeans(result$object$len$aov, ~dose)))
  expect_equal(result$post_hoc$p.value[2:4], dose_pairs$p.value)
  expect_equal(result$post_hoc$contrast[2:4], as.character(dose_pairs$contrast))
})

test_that("report_factorial_anova post hoc covers every main effect and interaction of three factors", {
  withr::local_seed(1)
  design <- expand.grid(a = c("a1", "a2"), b = c("b1", "b2"), c = c("c1", "c2"), replicate = 1:5)
  design$id <- factor(seq_len(nrow(design)))
  design$y <- stats::rnorm(nrow(design))
  result <- quietly(report_factorial_anova(df = design, dv = "y", wid = "id", between = c("a", "b", "c")))
  # a, b, c: 1 pair each; a*b, a*c, b*c: 6 pairs each; a*b*c: 28 pairs
  expect_equal(nrow(result$post_hoc), 3 * 1 + 3 * 6 + 28)
})

test_that("report_factorial_anova passes within-subjects and mixed designs to ez::ezANOVA", {
  co2 <- transform(df_co2, conc = factor(conc), Plant = factor(Plant))
  within <- quietly(report_factorial_anova(df = co2, dv = "uptake", wid = "Plant", within = "conc", within_full = "conc"))
  ez_within <- quietly(ez::ezANOVA(data = co2, dv = uptake, wid = Plant, within = conc, type = 3, detailed = TRUE))
  conc <- within$omnibus[within$omnibus$Effect == "conc", ]
  expect_equal(conc$F, ez_within$ANOVA$F[ez_within$ANOVA$Effect == "conc"])
  expect_equal(conc$`p[GG]`, ez_within$`Sphericity Corrections`$`p[GG]`)
  mixed <- quietly(report_factorial_anova(df = co2, dv = "uptake", wid = "Plant", within = "conc", within_full = "conc",
                                          between = c("Type", "Treatment")))
  ez_mixed <- quietly(ez::ezANOVA(data = co2, dv = uptake, wid = Plant, within = conc, between = .(Type, Treatment),
                                  type = 3, detailed = TRUE))
  omnibus <- mixed$omnibus[match(ez_mixed$ANOVA$Effect, mixed$omnibus$Effect), ]
  expect_equal(omnibus$F, ez_mixed$ANOVA$F)
})

test_that("report_factorial_anova restores the contrasts option", {
  withr::local_options(contrasts = c("contr.treatment", "contr.poly"))
  tooth <- transform(ToothGrowth, id = factor(seq_len(nrow(ToothGrowth))), dose = factor(dose))
  quietly(report_factorial_anova(df = tooth, dv = "len", wid = "id", between = c("supp", "dose")))
  expect_equal(getOption("contrasts"), c("contr.treatment", "contr.poly"))
  expect_error(quietly(report_factorial_anova(df = tooth, dv = "missing_column", wid = "id", between = "supp")))
  expect_equal(getOption("contrasts"), c("contr.treatment", "contr.poly"))
})

test_that("report_factorial_anova writes an Excel workbook", {
  withr::local_dir(withr::local_tempdir())
  tooth <- transform(ToothGrowth, id = factor(seq_len(nrow(ToothGrowth))), dose = factor(dose))
  quietly(report_factorial_anova(df = tooth, dv = "len", wid = "id", between = c("supp", "dose"), file = "anova"))
  expect_true(file.exists("anova.xlsx"))
  expect_true(all(c("ANOVA between", "effect size", "post hoc", "descriptives", "call") %in% openxlsx::getSheetNames("anova.xlsx")))
})

##########################################################################################
# report_manova
##########################################################################################
test_that("report_manova prints and writes the four multivariate tests", {
  withr::local_options(contrasts = c("contr.helmert", "contr.poly"))
  withr::local_dir(withr::local_tempdir())
  model <- stats::manova(cbind(Sepal.Length, Petal.Length) ~ Species, data = iris)
  expect_output(report_manova(model = model), "Pillai,Wilks,Hotelling-Lawley,Roy Statistics")
  quietly(report_manova(model = model, file = "manova"))
  expect_true(file.exists("manova.xlsx"))
  written <- openxlsx::read.xlsx("manova.xlsx", sheet = "critical")
  for (test in c("Pillai", "Wilks", "Hotelling-Lawley", "Roy")) {
    expected <- summary(model, intercept = TRUE, test = test)$stats
    rows <- written[written$type == test & written$Group == "Species", ]
    expect_equal(rows$Statistic, unname(expected["Species", 2]))
    expect_equal(rows$`Pr(>F)`, unname(expected["Species", "Pr(>F)"]))
  }
})

test_that("report_manova returns the multivariate tests invisibly", {
  withr::local_options(contrasts = c("contr.helmert", "contr.poly"))
  model <- stats::manova(cbind(Sepal.Length, Petal.Length) ~ Species, data = iris)
  utils::capture.output(visibility <- withVisible(report_manova(model = model)))
  expect_false(visibility$visible)
  result <- visibility$value
  expect_named(result, c("multivariate", "type_three", "call"))
  for (test in c("Pillai", "Wilks", "Hotelling-Lawley", "Roy")) {
    expected <- summary(model, intercept = TRUE, test = test)$stats
    rows <- result$multivariate[result$multivariate$type == test, ]
    expect_equal(rows$Statistic, unname(expected[, 2]))
    expect_equal(rows$`Pr(>F)`, unname(expected[, "Pr(>F)"]))
  }
  expect_s3_class(result$type_three, "Anova.mlm")
})
