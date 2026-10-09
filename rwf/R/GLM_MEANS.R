##########################################################################################
# COHEN'S D EFFECT SIZE
##########################################################################################
#' @title Compute Cohen's D Effect Size
#' @description Computes Cohen's d effect size for a two-group comparison as
#' abs(mean1 - mean2) / sd_pooled, with
#' sd_pooled = sqrt((sd1^2 + sd2^2) / 2). This is the same formula used
#' inline by report_ttests, extracted here as a standalone, reusable
#' function so it can be called on its own.
#'
#' @param formula a formula of the form dv ~ group, same as used by
#' stats::t.test's formula method. The grouping variable must have exactly
#' two levels. Note: as with stats::t.test's formula method, paired tests
#' are not supported here; use stats::t.test(x, y, paired = TRUE) directly
#' for that case.
#' @param data data frame containing the variables in formula, same as
#' stats::t.test's data argument.
#'
#' @importFrom stats model.frame sd
#'
#' @return A single numeric value, Cohen's d effect size.
#' @keywords cohens-d parametric effect-size
#' @note
#' effect size
#' \itemize{
#'   \item Very small    0.01 Sawilowsky (2009)
#'   \item Small         0.20 Cohen (1988)
#'   \item Medium        0.50 Cohen (1988)
#'   \item Large         0.80 Cohen (1988)
#'   \item Very large    1.20 Sawilowsky (2009)
#'   \item Huge          12.0 Sawilowsky (2009)
#' }
#'  
#' @export
#' @examples
#' compute_cohens_d(
#'   formula = bp_before ~ agegrp,
#'   data = df_blood_pressure[df_blood_pressure$agegrp %in% c("30-45", "46-59"), ]
#' )
#' effectsize::cohens_d(
#'   bp_before ~ agegrp,
#'   data = df_blood_pressure[df_blood_pressure$agegrp %in% c("30-45", "46-59"), ],
#'   pooled_sd = TRUE
#' )
compute_cohens_d <- function(formula, data) {
  mf <- stats::model.frame(formula, data = data)
  outcome <- mf[[1]]
  group <- factor(mf[[2]])
  if (nlevels(group) != 2) {
    stop("grouping factor must have exactly 2 levels")
  }
  levels_group <- levels(group)
  x <- outcome[group == levels_group[1]]
  y <- outcome[group == levels_group[2]]
  sd_pooled <- sqrt((stats::sd(x)^2 + stats::sd(y)^2) / 2)
  d <- as.numeric(abs(mean(x) - mean(y)) / sd_pooled)
  return(d)
}
##########################################################################################
# T TEST
##########################################################################################
#' @title Run Pairwise t-tests and Return a Reporting Table
#' @description Performs t-tests for each selected dependent variable against
#' each selected independent variable, across all pairwise level combinations
#' of the independent variable. Also computes descriptive statistics,
#' effect sizes, Bartlett homogeneity test results, and Bonferroni adjustment.
#'
#' In simple terms:
#' this function creates a full t-test report table you can export or use in
#' downstream summaries.
#' @param file output filename
#' @inheritParams plot_oneway_diagnostics
#' @inheritDotParams stats::t.test
#' @importFrom stats t.test formula bartlett.test
#'
#' @return A data frame where each row is one pairwise group comparison for one
#' dependent-independent variable combination. Returned columns mean:
#'
#' \itemize{
#'   \item DV: Name stored in the DV column by the current implementation.
#'   Note: this currently contains the independent variable name.
#'   \item IV: Name stored in the IV column by the current implementation.
#'   Note: this currently contains the dependent variable name.
#'   \item level1: First group level being compared.
#'   \item level2: Second group level being compared.
#'   \item n1: Sample size in level1.
#'   \item n2: Sample size in level2.
#'   \item t: t statistic from t.test.
#'   \item df: Degrees of freedom for the t statistic.
#'   \item p: p-value from t.test.
#'   \item CI_l: Lower confidence interval bound for the mean difference.
#'   \item CI_u: Upper confidence interval bound for the mean difference.
#'   \item alternative: Alternative hypothesis used by t.test.
#'   \item method: Test label from t.test (for example Welch Two Sample t-test).
#'   \item mean1: Mean of the dependent variable in level1.
#'   \item mean2: Mean of the dependent variable in level2.
#'   \item sd1: Standard deviation in level1.
#'   \item sd2: Standard deviation in level2.
#'   \item sd_pooled: Pooled standard deviation,
#'   sqrt((sd1^2 + sd2^2) / 2).
#'   \item d: Cohen d effect size, abs(mean2 - mean1) / sd_pooled.
#'   \item r: Effect-size r derived from d using the function formula.
#'   \item k_squared[bartlett]: Bartlett test statistic for equal variances.
#'   \item df[bartlett]: Degrees of freedom of Bartlett test.
#'   \item p[bartlett]: p-value of Bartlett test.
#'   Small values suggest heteroscedasticity.
#'   \item bonferroni_p: Bonferroni-adjusted alpha threshold computed for the
#'   number of tests in the output table.
#'   \item significant: Logical-like character flag (TRUE/FALSE) indicating
#'   whether p is below bonferroni_p.
#' }
#'
#' @details
#' Missing values are removed per analysis pair using complete cases on the
#' current dependent and independent variables.
#'
#' For each independent variable, all pairwise level combinations are tested
#' using utils::combn.
#'
#' The function also calls report_dataframe to generate a formatted report.
#'
#' @keywords t-test pairwise inference effect-size reporting
#' @export
#' @examples
#' report_ttests(
#'   df = df_blood_pressure,
#'   dv = which("bp_before" == names(df_blood_pressure)),
#'   iv = 2
#' )
#' report_ttests(
#'   df = df_blood_pressure,
#'   dv = which("bp_before" == names(df_blood_pressure)),
#'   iv = 2:3
#' )
#' report_ttests(
#'   df = df_insurance,
#'   dv = which("charges" == names(df_insurance)),
#'   iv = c(2, 4)
#' )
#' report_ttests(
#'   df = df_blood_pressure,
#'   dv = which("bp_before" == names(df_blood_pressure)),
#'   iv = 2:3,
#'   alternative = "two.sided"
#' )
#' report_ttests(
#'   df = df_blood_pressure,
#'   dv = which("bp_before" == names(df_blood_pressure)),
#'   iv = 2:3,
#'   alternative = "less"
#' )
#' report_ttests(
#'   df = df_blood_pressure,
#'   dv = which("bp_before" == names(df_blood_pressure)),
#'   iv = 2:3,
#'   alternative = "greater"
#' )
#' report_ttests(
#'   df = df_blood_pressure,
#'   dv = which("bp_before" == names(df_blood_pressure)),
#'   iv = 2:3,
#'   var.equal = TRUE,
#'   file = "ttest"
#' )
#' effectsize::cohens_d(bp_before ~ sex, data = df_blood_pressure, pooled_sd = TRUE)
#' effectsize::cohens_d(bp_after ~ sex, data = df_blood_pressure, pooled_sd = TRUE)
#' effectsize::hedges_g(bp_before ~ sex, data = df_blood_pressure, pooled_sd = TRUE)
#' effectsize::hedges_g(bp_after ~ sex, data = df_blood_pressure, pooled_sd = TRUE)
#' report_ttests(
#'   df = df_blood_pressure,
#'   dv = which("bp_before" == names(df_blood_pressure)),
#'   iv = 2
#' )
#' report_ttests(
#'   df = df_blood_pressure,
#'   dv = which("bp_after" == names(df_blood_pressure)),
#'   iv = 2
#' )
report_ttests <- function(df, dv, iv, file = NULL, ...) {
  comment <- list(
    DV = "dependent variable",
    IV = "independent variable",
    level1 = "level 1",
    level2 = "level 2",
    n1 = "sample size for level 1",
    n2 = "sample size for level 2",
    t = "t statistic",
    df = "degrees of freedom for t statistic",
    p = "p value",
    CI_l = "confidence interval lower bound",
    CI_u = "confidence interval upper bound",
    alternative = "alternative hypothesis",
    method = "",
    mean1 = "mean for level 1",
    mean2 = "mean for level 2",
    sd1 = "standard deviation for level 1",
    sd2 = "standard deviation for level 2",
    sd_pooled = "pooled standard deviation\n\ncombined standard deviation of both levels",
    d = "measure of effect size\n\ncohen's d\n\nVery small\t0.01\t\tSawilowsky (2009)\nSmall\t\t0.20\t\tCohen (1988)\nMedium\t\t0.50\t\tCohen (1988)\nLarge\t\t0.80\t\tCohen (1988)\nVery large\t1.20\t\tSawilowsky (2009)\nHuge\t\t12.0\t\tSawilowsky (2009)",
    r = "measure of effect size\n\ncorrelation effect size",
    "k_squared[bartlett]" = "bartlett test for homogeneity of variances\n\n",
    "df[bartlett]" = "bartlett test for homogeneity of variances\n\n",
    "p[bartlett]" = "bartlett test for homogeneity of variances\n\nsignificant values indicate heteroscedasticity",
    bonferroni_p = "bonferroni adjusted critical value for a=0.05",
    significant = "if TRUE result is significant after bonferroni adjustment"
  )

  critical <- list(p = "<0.05", "p[bartlett]" = "<0.05")

  df_ttest <- data.frame()
  combinations <- expand.grid(names(df)[iv], names(df)[dv])
  names(combinations) <- c("iv", "dv")
  row.names(combinations) <- paste0(combinations$iv, "_", combinations$dv)
  combinations <- change_data_type(combinations, type = "character")
  # pb<-txtProgressBar(min=0,max=length(iv)*length(dv),style=3)
  for (i in 1:nrow(combinations)) {
    independent <- combinations$iv[i]
    dependent <- combinations$dv[i]
    # setTxtProgressBar(pb,i)
    tempdata <- df[complete.cases(df[, c(dependent, independent)]), ]
    tempdata[, independent] <- factor(tempdata[, independent])
    combinations_levels <- data.frame(t(utils::combn(unique(as.character(tempdata[, independent])), 2)), stringsAsFactors = FALSE)
    tempdata_all_levels <- df[complete.cases(df[, c(dependent, independent)]), ]
    for (l in 1:nrow(combinations_levels)) {
      f1 <- as.character(combinations_levels$X1[l])
      f2 <- as.character(combinations_levels$X2[l])
      tempdata <- tempdata_all_levels[tempdata_all_levels[, independent] %in% c(f1, f2), ]
      form <- stats::formula(paste0(dependent, "~", independent))
      # ttest <- stats::t.test(form, data = tempdata)
      ttest <- stats::t.test(form, data = tempdata, ...)
      bartlett.test <- stats::bartlett.test(form, data = tempdata)
      mean1 <- mean(tempdata[tempdata[, independent] %in% f1, dependent], na.rm = TRUE)
      mean2 <- mean(tempdata[tempdata[, independent] %in% f2, dependent], na.rm = TRUE)
      sd1 <- stats::sd(tempdata[tempdata[, independent] %in% f1, dependent], na.rm = TRUE)
      sd2 <- stats::sd(tempdata[tempdata[, independent] %in% f2, dependent], na.rm = TRUE)
      n1 <- length(tempdata[tempdata[, independent] %in% f1, dependent])
      n2 <- length(tempdata[tempdata[, independent] %in% f2, dependent])
      sd_pooled <- sqrt((sd1^2 + sd2^2) / 2)
      cohen_d <- abs(mean2 - mean1) / sd_pooled
      # J<-1-(3/(4*(n1+n2)-9))
      # hedges_g<-J*cohen_d
      # r_from_d<-cohen_d/sqrt(cohen_d^2+((n1+n2)^2/(n1*n2)))
      ttest_r <- data.frame(
        DV = dependent,
        IV = independent,
        level1 = f1,
        level2 = f2,
        n1 = n1,
        n2 = n2,
        t = ttest$statistic[[1]],
        df = ttest$parameter[[1]],
        p = ttest$p.value[[1]],
        CI_l = ttest$conf.int[[1]],
        CI_u = ttest$conf.int[[2]],
        alternative = ttest$alternative,
        method = ttest$method,
        mean1 = mean1,
        mean2 = mean2,
        sd1 = sd1,
        sd2 = sd2,
        sd_pooled = sd_pooled,
        d = cohen_d,
        r = cohen_d / sqrt(cohen_d^2 + (n1 + n2 - 2) * (1 / n1 + 1 / n2)),
        "k_squared[bartlett]" = bartlett.test$statistic,
        "df[bartlett]" = as.numeric(bartlett.test$parameter),
        "p[bartlett]" = bartlett.test$p.value,
        stringsAsFactors = FALSE,
        check.names = FALSE
      )
      df_ttest <- plyr::rbind.fill(df_ttest, ttest_r)
    }
  }
  # close(pb)
  adjustment <- compute_adjustment(0.05, nrow(df_ttest))
  df_ttest$bonferroni_p <- adjustment$bonferroni
  df_ttest$significant <- as.character(adjustment$bonferroni > df_ttest$p)
  report_dataframe(df_ttest, file = file, sheet = "t test", comment = comment, critical = critical)
  return(df_ttest)
}
##########################################################################################
# WILCOXON EFFECT SIZE
##########################################################################################
#' @title Compute Wilcoxon Effect Size
#' @description Computes the Wilcoxon rank-sum/signed-rank effect size
#' r = abs(Z) / sqrt(N), with Z derived from the p-value of
#' stats::wilcox.test (Z = qnorm(p / 2, lower.tail = FALSE)). This avoids a
#' dependency on rstatix/coin, using only stats::wilcox.test under the hood.
#' The effect size magnitude is computed from the two-sided p-value
#' regardless of the alternative used for the underlying hypothesis test.
#'
#' @param formula a formula of the form dv ~ group, same as used by
#' stats::wilcox.test's formula method. Note: as with
#' stats::wilcox.test's formula method, paired tests are not supported here;
#' use stats::wilcox.test(x, y, paired = TRUE) directly for that case.
#' @param data data frame containing the variables in formula, same as
#' stats::wilcox.test's data argument.
#' @param mu a number specifying an optional shift, same as stats::wilcox.test.
#' @param exact logical indicating whether an exact p-value should be
#' computed, same as stats::wilcox.test.
#' @param correct logical indicating whether to apply the continuity
#' correction, same as stats::wilcox.test.
#' @param ... additional arguments passed to stats::wilcox.test.
#'
#' @importFrom stats wilcox.test model.frame qnorm
#'
#' @return A single numeric value, the Wilcoxon effect size (r).
#' @keywords wilcoxon nonparametric effect-size
#' @export
#' @examples
#' compute_wilcoxon_effect_size(
#'   formula = bp_before ~ agegrp,
#'   data = df_blood_pressure[df_blood_pressure$agegrp %in% c("30-45", "46-59"), ]
#' )
#' rstatix::wilcox_effsize(bp_before ~ agegrp,
#'   data = df_blood_pressure[df_blood_pressure$agegrp %in% c("30-45", "46-59"), ]
#' )
compute_wilcoxon_effect_size <- function(formula, data,
                                          mu = 0,
                                          exact = NULL,
                                          correct = TRUE,
                                          ...) {
  wtest <- stats::wilcox.test(
    formula,
    data = data,
    alternative = "two.sided",
    mu = mu,
    exact = exact,
    correct = correct,
    ...
  )
  n <- nrow(stats::model.frame(formula, data = data))
  z <- stats::qnorm(wtest$p.value / 2, lower.tail = FALSE)
  r <- as.numeric(abs(z) / sqrt(n))
  return(r)
}
##########################################################################################
#' @title Run Pairwise Wilcoxon Tests and Return a Reporting Table
#' @description Performs Wilcoxon rank-sum tests for each selected dependent
#' variable against each selected independent variable, across all pairwise
#' level combinations of the independent variable. Also computes descriptive
#' statistics, effect sizes, Bartlett homogeneity results, and Bonferroni
#' adjustment.
#'
#' In simple terms:
#' this function builds a full nonparametric comparison table, similar to
#' report_ttests, but using wilcox.test for group differences.
#'
#' @param file output filename
#' @inheritParams plot_oneway_diagnostics
#' @inheritDotParams stats::wilcox.test
#'
#' @importFrom stats wilcox.test formula sd
#'
#' @return A data frame where each row is one pairwise level comparison for one
#' dependent-independent variable combination. Returned columns mean:
#'
#' \itemize{
#'   \item DV: Name stored in the DV column by the current implementation.
#'   Note: this currently contains the independent variable name.
#'   \item IV: Name stored in the IV column by the current implementation.
#'   Note: this currently contains the dependent variable name.
#'   \item level1: First group level being compared.
#'   \item level2: Second group level being compared.
#'   \item n1: Sample size in level1.
#'   \item n2: Sample size in level2.
#'   \item W: Wilcoxon test statistic from wilcox.test.
#'   \item p: p-value from wilcox.test.
#'   \item CI_l: Lower confidence interval bound from wilcox.test.
#'   \item CI_u: Upper confidence interval bound from wilcox.test.
#'   \item alternative: Alternative hypothesis used by wilcox.test.
#'   \item method: Test label from wilcox.test.
#'   \item mean1: Mean of the dependent variable in level1.
#'   \item mean2: Mean of the dependent variable in level2.
#'   \item sd1: Standard deviation in level1.
#'   \item sd2: Standard deviation in level2.
#'   \item sd_pooled: Pooled standard deviation,
#'   sqrt((sd1^2 + sd2^2) / 2).
#'   \item d: Cohen d effect size, abs(mean2 - mean1) / sd_pooled.
#'   \item r: Wilcoxon effect size from compute_wilcoxon_effect_size.
#'   \item k_squared[bartlett]: Bartlett test statistic for equal variances.
#'   \item df[bartlett]: Degrees of freedom of Bartlett test.
#'   \item p[bartlett]: p-value of Bartlett test.
#'   Small values suggest heteroscedasticity.
#'   \item bonferroni_p: Bonferroni-adjusted alpha threshold computed for the
#'   number of tests in the output table.
#'   \item significant: Logical-like character flag (TRUE/FALSE) indicating
#'   whether p is below bonferroni_p.
#' }
#'
#' @details
#' Missing values are removed per analysis pair using complete cases on the
#' current dependent and independent variables.
#'
#' For each independent variable, all pairwise level combinations are tested
#' using utils::combn.
#'
#' The function calls stats::wilcox.test with conf.int = TRUE and forwards
#' additional arguments through ....
#'
#' The function also calls report_dataframe to generate a formatted report.
#' @keywords wilcoxon nonparametric pairwise inference effect-size reporting
#' @export
#' @examples
#' report_wtests(
#'   df = df_blood_pressure,
#'   dv = which("bp_before" == names(df_blood_pressure)),
#'   iv = 2
#' )
#' report_wtests(
#'   df = df_blood_pressure,
#'   dv = which("bp_before" == names(df_blood_pressure)),
#'   iv = 2:3
#' )
#' report_wtests(
#'   df = df_blood_pressure,
#'   dv = which("bp_before" == names(df_blood_pressure)),
#'   iv = 2:3,
#'   alternative = "two.sided"
#' )
#' report_wtests(
#'   df = df_blood_pressure,
#'   dv = which("bp_before" == names(df_blood_pressure)),
#'   iv = 2:3,
#'   alternative = "less"
#' )
#' report_wtests(
#'   df = df_blood_pressure,
#'   dv = which("bp_before" == names(df_blood_pressure)),
#'   iv = 2:3,
#'   alternative = "greater"
#' )
#' report_wtests(
#'   df = df_blood_pressure,
#'   dv = which("bp_before" == names(df_blood_pressure)),
#'   iv = 2:3,
#'   var.equal = TRUE,
#'   file = "wilcoxontest"
#' )
report_wtests <- function(df, dv, iv, file = NULL, ...) {
  comment <- list(
    DV = "dependent variable",
    IV = "independent variable",
    level1 = "level 1",
    level2 = "level 2",
    n1 = "sample size for level 1",
    n2 = "sample size for level 2",
    W = "wilcoxon statistic",
    df = "degrees of freedom for t statistic",
    p = "p value",
    CI_l = "confidence interval lower bound",
    CI_u = "confidence interval upper bound",
    alternative = "alternative hypothesis",
    method = "",
    mean1 = "mean for level 1",
    mean2 = "mean for level 2",
    sd1 = "standard deviation for level 1",
    sd2 = "standard deviation for level 2",
    sd_pooled = "pooled standard deviation\n\ncombined standard deviation of both levels",
    d = "measure of effect size\n\ncohen's d\n\nVery small\t0.01\t\tSawilowsky (2009)\nSmall\t\t0.20\t\tCohen (1988)\nMedium\t\t0.50\t\tCohen (1988)\nLarge\t\t0.80\t\tCohen (1988)\nVery large\t1.20\t\tSawilowsky (2009)\nHuge\t\t12.0\t\tSawilowsky (2009)",
    r = "measure of effect size\n\ncorrelation effect size",
    "k_squared[bartlett]" = "bartlett test for homogeneity of variances\n\n",
    "df[bartlett]" = "bartlett test for homogeneity of variances\n\n",
    "p[bartlett]" = "bartlett test for homogeneity of variances\n\nsignificant values indicate heteroscedasticity",
    bonferroni_p = "bonferroni adjusted critical value for a=0.05",
    significant = "if TRUE result is significant after bonferroni adjustment"
  )

  critical <- list(p = "<0.05", "p[bartlett]" = "<0.05")

  df_wtest <- data.frame()
  combinations <- expand.grid(names(df)[iv], names(df)[dv])
  names(combinations) <- c("iv", "dv")
  row.names(combinations) <- paste0(combinations$iv, "_", combinations$dv)
  combinations <- change_data_type(combinations, type = "character")
  # pb<-txtProgressBar(min=0,max=length(iv)*length(dv),style=3)
  for (i in 1:nrow(combinations)) {
    independent <- combinations$iv[i]
    dependent <- combinations$dv[i]
    # setTxtProgressBar(pb,i)
    tempdata <- df[complete.cases(df[, c(dependent, independent)]), ]
    tempdata[, independent] <- factor(tempdata[, independent])
    combinations_levels <- data.frame(t(utils::combn(unique(as.character(tempdata[, independent])), 2)), stringsAsFactors = FALSE)
    tempdata_all_levels <- df[complete.cases(df[, c(dependent, independent)]), ]
    for (l in 1:nrow(combinations_levels)) {
      f1 <- as.character(combinations_levels$X1[l])
      f2 <- as.character(combinations_levels$X2[l])
      tempdata <- tempdata_all_levels[tempdata_all_levels[, independent] %in% c(f1, f2), ]
      form <- stats::formula(paste0(dependent, "~", independent))
      # wtest <- stats::wilcox.test(form, data = tempdata, conf.int = TRUE)
      wtest <- stats::wilcox.test(form, data = tempdata, conf.int = TRUE, ...)
      bartlett.test <- bartlett.test(form, data = tempdata)
      mean1 <- mean(tempdata[tempdata[, independent] %in% f1, dependent], na.rm = TRUE)
      mean2 <- mean(tempdata[tempdata[, independent] %in% f2, dependent], na.rm = TRUE)
      sd1 <- stats::sd(tempdata[tempdata[, independent] %in% f1, dependent], na.rm = TRUE)
      sd2 <- stats::sd(tempdata[tempdata[, independent] %in% f2, dependent], na.rm = TRUE)
      n1 <- length(tempdata[tempdata[, independent] %in% f1, dependent])
      n2 <- length(tempdata[tempdata[, independent] %in% f2, dependent])
      sd_pooled <- sqrt((sd1^2 + sd2^2) / 2)
      cohen_d <- abs(mean2 - mean1) / sd_pooled
      n <- nrow(stats::model.frame(form, data = tempdata))
      z <- stats::qnorm(wtest$p.value / 2, lower.tail = FALSE)
      r <- as.numeric(abs(z) / sqrt(n))
      wtest_r <- data.frame(
        DV = dependent,
        IV = independent,
        level1 = f1,
        level2 = f2,
        n1 = n1,
        n2 = n2,
        W = wtest$statistic[[1]],
        p = wtest$p.value[[1]],
        CI_l = wtest$conf.int[[1]],
        CI_u = wtest$conf.int[[2]],
        alternative = wtest$alternative,
        method = wtest$method,
        mean1 = mean1,
        mean2 = mean2,
        sd1 = sd1,
        sd2 = sd2,
        sd_pooled = sd_pooled,
        d = cohen_d,
        r = r,
        "k_squared[bartlett]" = bartlett.test$statistic,
        "df[bartlett]" = as.numeric(bartlett.test$parameter),
        "p[bartlett]" = bartlett.test$p.value,
        stringsAsFactors = FALSE,
        check.names = FALSE
      )
      df_wtest <- plyr::rbind.fill(df_wtest, wtest_r)
    }
  }
  # close(pb)
  adjustment <- compute_adjustment(0.05, nrow(df_wtest))
  df_wtest$bonferroni_p <- adjustment$bonferroni
  df_wtest$significant <- as.character(adjustment$bonferroni > df_wtest$p)
  report_dataframe(df_wtest, file = file, sheet = "t test", comment = comment, critical = critical)
  return(df_wtest)
}
