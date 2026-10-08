##########################################################################################
# KRUSKAL WALLIS TEST WITH EFFECT SIZE
##########################################################################################
#' @title Kruskal-Wallis Test with Effect Sizes
#' @description Runs a one-way Kruskal-Wallis rank-sum test and returns the test
#' statistic, p-value, and two effect sizes:
#' \itemize{
#'   \item \code{etasq}: eta-squared for Kruskal-Wallis (\eqn{\eta_H^2})
#'   \item \code{epsilonsq}: epsilon-squared (\eqn{\epsilon^2})
#' }
#'
#' In simple terms, this tests whether groups differ in their distributions,
#' and quantifies how large that group effect is.
#'
#' @param formula A one-way formula in the form \code{y ~ group}.
#' @param df A data frame containing the variables in \code{formula}.
#' @param ci If TRUE, adds percentile bootstrap confidence intervals for
#' \code{etasq} and \code{epsilonsq}.
#' @param conf.level Confidence level of the intervals.
#' @param nboot Number of bootstrap resamples.
#'
#' @return A one-row data frame with:
#' \itemize{
#'   \item \code{formula}: model formula used
#'   \item \code{method}: test name
#'   \item \code{etasq}: Kruskal-Wallis eta-squared, \eqn{(H-k+1)/(n-k)}
#'   \item \code{etasq_lower}, \code{etasq_upper}: confidence interval of \code{etasq} (only if \code{ci = TRUE})
#'   \item \code{epsilonsq}: epsilon-squared, \eqn{H/(n-1)}
#'   \item \code{epsilonsq_lower}, \code{epsilonsq_upper}: confidence interval of \code{epsilonsq} (only if \code{ci = TRUE})
#'   \item \code{H}: Kruskal-Wallis chi-squared statistic
#'   \item \code{df}: degrees of freedom (\eqn{k-1})
#'   \item \code{p}: p-value
#' }
#'
#' @details
#' \code{epsilonsq} is in [0, 1]. \code{etasq} is at most 1 and is negative
#' when \eqn{H < k-1}, that is when the groups differ less than expected by chance.
#' Multiplying by 100 gives an approximate percentage-style interpretation
#' of explained rank variance.
#'
#' Rules of thumb for \code{etasq} and \code{epsilonsq}. Small, medium and large
#' are the \eqn{\eta^2} benchmarks of Cohen (1988); tiny, very large and huge
#' convert the Cohen's d benchmarks of Sawilowsky (2009) with \eqn{\eta^2=d^2/(d^2+4)}:
#' \itemize{
#'   \item tiny: < 0.01 (d < 0.2)
#'   \item small: 0.01 to < 0.06 (d = 0.2)
#'   \item medium: 0.06 to < 0.14 (d = 0.5)
#'   \item large: 0.14 to < 0.26 (d = 0.8)
#'   \item very large: 0.26 to < 0.50 (d = 1.2)
#'   \item huge: >= 0.50 (d = 2.0)
#' }
#' These are rough guides; what counts as a meaningful effect depends on the field.
#' \code{epsilonsq} is biased upwards by about \eqn{(k-1)/(n-1)} in small samples.
#'
#' Rows with a missing value in the outcome or the grouping variable are
#' removed before the test, as in \code{stats::kruskal.test}.
#'
#' The confidence intervals resample rows with replacement \code{nboot} times,
#' recompute both effect sizes in each resample and take the
#' \eqn{(1-conf.level)/2} and \eqn{1-(1-conf.level)/2} quantiles. Use
#' \code{set.seed} for reproducible intervals.
#'
#' @source The computation of \code{H}, including the correction for ties, is
#' adapted from \code{stats::kruskal.test} (R Core Team, R package \code{stats},
#' licensed GPL-2 | GPL-3). \code{etasq} and \code{epsilonsq} use the same
#' formulas as \code{rstatix::kruskal_effsize} and
#' \code{effectsize::rank_epsilon_squared}.
#'
#' @importFrom stats pchisq quantile na.omit
#' @references
#' Ben-Shachar, M. S., \enc{Lüdecke}{Ludecke}, D., & Makowski, D. (2020). effectsize: Estimation of effect size indices and standardized parameters. Journal of Open Source Software, 5(56), 2815. \doi{10.21105/joss.02815}
#'
#' Cohen, J. (1988). Statistical power analysis for the behavioral sciences (2nd ed.). Lawrence Erlbaum Associates.
#'
#' Kassambara, A. (2026). rstatix: Pipe-friendly framework for basic statistical tests (R package version 1.1.0). \doi{10.32614/CRAN.package.rstatix}
#'
#' R Core Team (2026). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. \doi{10.32614/R.manuals}
#'
#' Sawilowsky, S. S. (2009). New effect size rules of thumb. Journal of Modern Applied Statistical Methods, 8(2), 597-599. \doi{10.22237/jmasm/1257035100}
#'
#' Tomczak, M., & Tomczak, E. (2014). The need to report effect size estimates revisited. An overview of some recommended measures of effect size. Trends in Sport Sciences, 1(21), 19-25.
#' @keywords ANOVA nonparametric kruskal
#' @export
#'
#' @examples
#' form <- formula(bp_before ~ agegrp)
#' kruskal.test(formula = form, data = df_blood_pressure)
#' rcompanion::epsilonSquared(
#'   x = df_blood_pressure$bp_before,
#'   g = df_blood_pressure$agegrp,
#'   group = "row",
#'   ci = TRUE,
#'   conf = 0.95,
#'   type = "perc",
#'   R = 1000,
#'   digits = 3
#' )
#' rstatix::kruskal_effsize(df_blood_pressure, form, ci = TRUE, conf.level = 0.95, ci.type = "perc", nboot = 100)
#' compute_kruskal_wallis_test(formula = form, df = df_blood_pressure)
#' set.seed(1)
#' compute_kruskal_wallis_test(formula = form, df = df_blood_pressure, ci = TRUE)
compute_kruskal_wallis_test <- function(formula, df, ci = FALSE, conf.level = 0.95, nboot = 1000) {
  df <- stats::na.omit(df[, all.vars(formula)])
  x <- df[, all.vars(formula)[1]]
  g <- factor(df[, all.vars(formula)[2]])
  kruskal_h <- function(x, g) {
    n <- length(x)
    r <- rank(x)
    ties <- table(x)
    h <- sum(tapply(r, g, "sum")^2 / tapply(r, g, "length"))
    ((12 * h / (n * (n + 1)) - 3 * (n + 1)) / (1 - sum(ties^3 - ties) / (n^3 - n)))
  }
  k <- nlevels(g)
  n <- length(x)
  H <- kruskal_h(x, g)
  df <- (k - 1)
  p <- stats::pchisq(H, df, lower.tail = FALSE)
  etasq <- (H - k + 1) / (n - k)
  epsilonsq <- H / ((n^2 - 1) / (n + 1))
  method <- "Kruskal-Wallis rank sum test"
  if (!ci) {
    result <- data.frame(formula = deparse(formula), method, etasq, epsilonsq, H = H, df = df, p = p, check.names = FALSE)
    return(result)
  }
  boot_effects <- t(replicate(nboot, {
    i <- sample.int(n, replace = TRUE)
    g_boot <- droplevels(g[i])
    k_boot <- nlevels(g_boot)
    H_boot <- kruskal_h(x[i], g_boot)
    c(etasq = (H_boot - k_boot + 1) / (n - k_boot), epsilonsq = H_boot / (n - 1))
  }))
  probs <- c((1 - conf.level) / 2, 1 - (1 - conf.level) / 2)
  etasq_ci <- stats::quantile(boot_effects[, "etasq"], probs, na.rm = TRUE, names = FALSE)
  epsilonsq_ci <- stats::quantile(boot_effects[, "epsilonsq"], probs, na.rm = TRUE, names = FALSE)
  result <- data.frame(formula = deparse(formula), method,
                       etasq, etasq_lower = etasq_ci[1], etasq_upper = etasq_ci[2],
                       epsilonsq, epsilonsq_lower = epsilonsq_ci[1], epsilonsq_upper = epsilonsq_ci[2],
                       H = H, df = df, p = p, check.names = FALSE)
  return(result)
}
##########################################################################################
# FRIEDMAN TEST WITH EFFECT SIZE
##########################################################################################
#' @title Friedman Test with Effect Size
#' @description Runs the Friedman rank-sum test for a complete block design
#' (repeated measures) and returns the test statistic, p-value, and Kendall's W
#' (\code{kendall_w}) as the effect size.
#'
#' In simple terms, this tests whether the same subjects (blocks) respond
#' differently across conditions (groups), and quantifies how consistently the
#' subjects rank the conditions in the same order.
#'
#' @param formula A formula in the form \code{y ~ group | block}, where
#' \code{group} is the repeated condition and \code{block} identifies the subject.
#' @param df A data frame in long format containing the variables in \code{formula},
#' with one row per block and group.
#' @param ci If TRUE, adds a percentile bootstrap confidence interval for \code{kendall_w}.
#' @param conf.level Confidence level of the interval.
#' @param nboot Number of bootstrap resamples.
#'
#' @return A one-row data frame with:
#' \itemize{
#'   \item \code{formula}: model formula used
#'   \item \code{method}: test name
#'   \item \code{kendall_w}: Kendall's coefficient of concordance, \eqn{Q/(n(k-1))}
#'   \item \code{kendall_w_lower}, \code{kendall_w_upper}: confidence interval of \code{kendall_w} (only if \code{ci = TRUE})
#'   \item \code{Q}: Friedman chi-squared statistic, corrected for ties
#'   \item \code{df}: degrees of freedom (\eqn{k-1})
#'   \item \code{n}: number of complete blocks used
#'   \item \code{p}: p-value
#' }
#'
#' @details
#' The observations are ranked within each block. With \eqn{n} blocks, \eqn{k}
#' groups, \eqn{R_j} the rank sum of group \eqn{j} and \eqn{t} the sizes of the
#' groups of tied values within blocks,
#' \deqn{Q=\frac{12\sum_{j=1}^{k}\left(R_j-n(k+1)/2\right)^2}{nk(k+1)-\sum(t^3-t)/(k-1)}}
#' Under the null hypothesis \eqn{Q} approximately follows a chi-squared
#' distribution with \eqn{k-1} degrees of freedom.
#'
#' \code{kendall_w} is in [0, 1]. 0 means the blocks rank the groups in no consistent
#' order; 1 means every block ranks the groups in the same order.
#'
#' Rules of thumb for \code{kendall_w}, the Cohen (1988) benchmarks for correlations
#' that \code{rstatix::friedman_effsize} also uses:
#' \itemize{
#'   \item tiny: < 0.1
#'   \item small: 0.1 to < 0.3
#'   \item medium: 0.3 to < 0.5
#'   \item large: >= 0.5
#' }
#' These are rough guides; what counts as a meaningful effect depends on the field.
#'
#' Rows with a missing group or block are removed. Blocks with a missing value
#' in any group are removed, as in the default method of \code{stats::friedman.test};
#' \code{n} reports how many blocks remain. A block with more than one observation
#' for the same group is an error.
#'
#' The confidence interval resamples blocks with replacement \code{nboot} times,
#' recomputes \code{kendall_w} in each resample and takes the
#' \eqn{(1-conf.level)/2} and \eqn{1-(1-conf.level)/2} quantiles. Use
#' \code{set.seed} for reproducible intervals.
#'
#' @source \code{Q} is computed with the same tie-corrected formula as
#' \code{stats::friedman.test} (R Core Team, R package \code{stats}, licensed
#' GPL-2 | GPL-3).
#'
#' @importFrom stats pchisq quantile complete.cases
#' @references
#' Cohen, J. (1988). Statistical power analysis for the behavioral sciences (2nd ed.). Lawrence Erlbaum Associates.
#'
#' Friedman, M. (1937). The use of ranks to avoid the assumption of normality implicit in the analysis of variance. Journal of the American Statistical Association, 32(200), 675-701. \doi{10.1080/01621459.1937.10503522}
#'
#' Kendall, M. G., & Babington Smith, B. (1939). The problem of m rankings. The Annals of Mathematical Statistics, 10(3), 275-287. \doi{10.1214/aoms/1177732186}
#'
#' R Core Team (2026). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. \doi{10.32614/R.manuals}
#' @keywords ANOVA nonparametric friedman
#' @export
#'
#' @examples
#' form <- formula(uptake ~ conc | Plant)
#' friedman.test(formula = form, data = df_co2)
#' rstatix::friedman_effsize(df_co2, form, ci = TRUE, conf.level = 0.95, ci.type = "perc", nboot = 100)
#' effectsize::kendalls_w(form, data = df_co2)
#' compute_friedman_test(formula = form, df = df_co2)
#' set.seed(1)
#' compute_friedman_test(formula = form, df = df_co2, ci = TRUE)
compute_friedman_test <- function(formula, df, ci = FALSE, conf.level = 0.95, nboot = 1000) {
  vars <- all.vars(formula)
  df <- df[stats::complete.cases(df[, vars[2:3]]), vars]
  g <- factor(df[, vars[2]])
  b <- factor(df[, vars[3]])
  if (any(table(b, g) > 1)) stop("each block must have at most one observation per group")
  y <- matrix(NA, nrow = nlevels(b), ncol = nlevels(g))
  y[cbind(as.integer(b), as.integer(g))] <- df[, vars[1]]
  y <- y[stats::complete.cases(y), , drop = FALSE]
  friedman_q <- function(y) {
    n <- nrow(y)
    k <- ncol(y)
    r <- t(apply(y, 1, rank))
    ties <- sum(apply(y, 1, function(u) {
      t <- table(u)
      sum(t^3 - t)
    }))
    12 * sum((colSums(r) - n * (k + 1) / 2)^2) / (n * k * (k + 1) - ties / (k - 1))
  }
  n <- nrow(y)
  k <- ncol(y)
  Q <- friedman_q(y)
  df <- (k - 1)
  p <- stats::pchisq(Q, df, lower.tail = FALSE)
  kendall_w <- Q / (n * (k - 1))
  method <- "Friedman rank sum test"
  if (!ci) {
    result <- data.frame(formula = deparse(formula), method, kendall_w, Q = Q, df = df, n = n, p = p, check.names = FALSE)
    return(result)
  }
  boot_kendall_w <- replicate(nboot, friedman_q(y[sample.int(n, replace = TRUE), , drop = FALSE]) / (n * (k - 1)))
  probs <- c((1 - conf.level) / 2, 1 - (1 - conf.level) / 2)
  kendall_w_ci <- stats::quantile(boot_kendall_w, probs, na.rm = TRUE, names = FALSE)
  result <- data.frame(formula = deparse(formula), method,
                       kendall_w, kendall_w_lower = kendall_w_ci[1], kendall_w_upper = kendall_w_ci[2],
                       Q = Q, df = df, n = n, p = p, check.names = FALSE)
  return(result)
}
##########################################################################################
# ONE WAY TEST WITH SS AND MS
##########################################################################################
#' @title One-Way ANOVA with Effect Sizes and Power
#' @description Runs a one-way analysis of variance for two or more independent
#' groups, assuming equal variances (Fisher's F test) or not (Welch's F test),
#' and returns the sums of squares, mean squares, F statistic, p-value, observed
#' power, and five effect sizes:
#' \itemize{
#'   \item \code{etasq}: eta-squared (\eqn{\eta^2})
#'   \item \code{partial.etasq}: partial eta-squared (\eqn{\eta^2_p})
#'   \item \code{omegasq}: omega-squared (\eqn{\omega^2})
#'   \item \code{partial.omegasq}: partial omega-squared (\eqn{\omega^2_p})
#'   \item \code{cohens.f}: Cohen's f
#' }
#'
#' In simple terms, this tests whether the group means differ, and quantifies
#' how much of the variance in the outcome the groups explain.
#'
#' @param formula A one-way formula in the form \code{y ~ group}.
#' @param df A data frame containing the variables in \code{formula}.
#' @param var.equal If TRUE, assumes equal variances (Fisher's F test). If FALSE,
#' uses Welch's F test.
#'
#' @return A one-row data frame with:
#' \itemize{
#'   \item \code{formula}: model formula used
#'   \item \code{method}: "Assuming homoscedasticity" (Fisher) or "Assuming heteroscedasticity" (Welch)
#'   \item \code{ss_effect}, \code{ss_error}: sums of squares between and within groups
#'   \item \code{ms_effect}, \code{ms_error}: mean squares, \eqn{SS/df}
#'   \item \code{etasq}: eta-squared, \eqn{SS_{effect}/SS_{total}}
#'   \item \code{partial.etasq}: partial eta-squared, \eqn{SS_{effect}/(SS_{effect}+SS_{error})}
#'   \item \code{omegasq}: omega-squared, \eqn{(SS_{effect}-df_{effect} MS_{error})/(SS_{total}+MS_{error})}
#'   \item \code{partial.omegasq}: partial omega-squared, \eqn{df_{effect}(MS_{effect}-MS_{error})/(df_{effect} MS_{effect}+(df_{error}+1) MS_{error})}
#'   \item \code{cohens.f}: Cohen's f, \eqn{\sqrt{\eta^2/(1-\eta^2)}}
#'   \item \code{power}: observed power of the F test at \eqn{\alpha = 0.05}
#'   \item \code{statistic}: F statistic, \eqn{MS_{effect}/MS_{error}}
#'   \item \code{df_effect}: degrees of freedom of the effect (\eqn{k-1})
#'   \item \code{df_error}: degrees of freedom of the error (\eqn{N-k}, or the Welch degrees of freedom)
#'   \item \code{p}: p-value
#' }
#'
#' @details
#' In a one-way design \code{partial.etasq} equals \code{etasq} and
#' \code{partial.omegasq} equals \code{omegasq}. \code{etasq} and
#' \code{partial.etasq} are in [0, 1] and are biased upwards in small samples, by
#' about \eqn{(k-1)/(N-1)} when there is no effect. \code{omegasq} and
#' \code{partial.omegasq} remove most of that bias and are negative when \eqn{F < 1}.
#' Multiplying \code{etasq} or \code{omegasq} by 100 gives the percentage of
#' variance explained by the groups.
#'
#' Rules of thumb for \code{etasq}, \code{omegasq} and \code{cohens.f}. Small,
#' medium and large are the benchmarks of Cohen (1988); tiny, very large and huge
#' convert the Cohen's d benchmarks of Sawilowsky (2009) with
#' \eqn{\eta^2=d^2/(d^2+4)} and \eqn{f=d/2}:
#' \itemize{
#'   \item tiny: \eqn{\eta^2} < 0.01, f < 0.10 (d < 0.2)
#'   \item small: \eqn{\eta^2} 0.01 to < 0.06, f 0.10 to < 0.25 (d = 0.2)
#'   \item medium: \eqn{\eta^2} 0.06 to < 0.14, f 0.25 to < 0.40 (d = 0.5)
#'   \item large: \eqn{\eta^2} 0.14 to < 0.26, f 0.40 to < 0.60 (d = 0.8)
#'   \item very large: \eqn{\eta^2} 0.26 to < 0.50, f 0.60 to < 1.00 (d = 1.2)
#'   \item huge: \eqn{\eta^2} >= 0.50, f >= 1.00 (d = 2.0)
#' }
#' These are rough guides; what counts as a meaningful effect depends on the field.
#'
#' \code{power} uses the noncentral F distribution with noncentrality parameter
#' \eqn{\lambda = f^2 N} (Cohen, 1988), evaluated at the observed \code{cohens.f}.
#' Observed power is a function of the p-value and adds no information to it
#' (Hoenig & Heisey, 2001); use power analysis with an expected effect size to
#' plan a study, for example with \code{pwr::pwr.anova.test}.
#'
#' Welch's test (Welch, 1951) has no sums of squares. With \code{var.equal = FALSE},
#' \code{ms_effect} and \code{ms_error} are the numerator and denominator of the
#' Welch F statistic and \code{ss_effect} and \code{ss_error} are \eqn{MS \times df}.
#' The resulting \code{etasq}, \code{omegasq}, \code{partial.omegasq} and
#' \code{cohens.f} equal the conversions of the Welch F statistic in
#' \code{effectsize::F_to_eta2}, \code{effectsize::F_to_omega2} and
#' \code{effectsize::F_to_f}. Treat the Welch effect sizes as approximations.
#'
#' Rows with a missing value in the outcome or the grouping variable are
#' removed before the test, as in \code{stats::oneway.test}.
#'
#' @source The group statistics and the Welch test (the weights, the Welch F
#' statistic and its degrees of freedom) are adapted from \code{stats::oneway.test}
#' (R Core Team, R package \code{stats}, licensed GPL-2 | GPL-3). The sums of
#' squares, effect sizes and power are added in rwf.
#'
#' @importFrom stats pf qf na.omit
#' @references
#' Cohen, J. (1988). Statistical power analysis for the behavioral sciences (2nd ed.). Lawrence Erlbaum Associates.
#'
#' Hoenig, J. M., & Heisey, D. M. (2001). The abuse of power: The pervasive fallacy of power calculations for data analysis. The American Statistician, 55(1), 19-24. \doi{10.1198/000313001300339897}
#'
#' Olejnik, S., & Algina, J. (2003). Generalized eta and omega squared statistics: Measures of effect size for some common research designs. Psychological Methods, 8(4), 434-447. \doi{10.1037/1082-989X.8.4.434}
#'
#' R Core Team (2026). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. \doi{10.32614/R.manuals}
#'
#' Sawilowsky, S. S. (2009). New effect size rules of thumb. Journal of Modern Applied Statistical Methods, 8(2), 597-599. \doi{10.22237/jmasm/1257035100}
#'
#' Welch, B. L. (1951). On the comparison of several mean values: An alternative approach. Biometrika, 38(3/4), 330-336. \doi{10.2307/2332579}
#' @keywords ANOVA
#' @export
#'
#' @examples
#' form <- formula(bp_before ~ agegrp)
#' oneway.test(formula = form, data = df_blood_pressure, var.equal = TRUE)
#' oneway.test(formula = form, data = df_blood_pressure, var.equal = FALSE)
#' car::Anova(aov(form, data = df_blood_pressure), type = 2)
#' lsr::etaSquared(aov(form, data = df_blood_pressure), type = 3, anova = TRUE)
#' effectsize::omega_squared(aov(form, data = df_blood_pressure), partial = FALSE)
#' sjstats::anova_stats(lm(form, data = df_blood_pressure), digits = 22)
#' compute_one_way_test(formula = form, df = df_blood_pressure, var.equal = TRUE)
#' compute_one_way_test(formula = form, df = df_blood_pressure, var.equal = FALSE)
compute_one_way_test <- function(formula, df, var.equal = TRUE) {
  df <- stats::na.omit(df[, all.vars(formula)])
  y <- df[, all.vars(formula)[1]]
  g <- factor(df[, all.vars(formula)[2]])
  k <- nlevels(g)
  n.i <- tapply(y, g, length)
  m.i <- tapply(y, g, mean)
  v.i <- tapply(y, g, var)
  w.i <- n.i / v.i
  sum.w.i <- sum(w.i)
  n <- sum(n.i)
  df_effect <- k - 1
  if (var.equal) {
    df_error <- n - k
    ss_effect <- sum(n.i * (m.i - mean(y))^2)
    ss_error <- sum((n.i - 1) * v.i)
    ms_effect <- ss_effect / df_effect
    ms_error <- ss_error / df_error
    method <- "Assuming homoscedasticity"
  } else {
    tmp <- sum((1 - w.i / sum.w.i)^2 / (n.i - 1)) / (k^2 - 1)
    df_error <- 1 / (3 * tmp)
    m <- sum(w.i * m.i) / sum.w.i
    ms_effect <- sum(w.i * (m.i - m)^2)
    ms_error <- df_effect * (1 + 2 * (k - 2) * tmp)
    ss_effect <- ms_effect * df_effect
    ss_error <- ms_error * df_error
    method <- "Assuming heteroscedasticity"
  }

  ss_total <- sum(ss_effect + ss_error)
  statistic <- ms_effect / ms_error
  p <- stats::pf(q = statistic, df1 = df_effect, df2 = df_error, lower.tail = FALSE)

  etasq <- ss_effect / ss_total
  partial.etasq <- ss_effect / (ss_effect + ss_error)
  omegasq <- (ss_effect - df_effect * ms_error) / (ss_total + ms_error)
  partial.omegasq <- (df_effect * (ms_effect - ms_error)) / (df_effect * ms_effect + (df_error + 1) * ms_error)
  cohens.f <- sqrt(etasq / (1 - etasq))
  lambda <- cohens.f^2 * n
  power <- stats::pf(stats::qf(0.05, df_effect, df_error, lower.tail = FALSE), df_effect, df_error, lambda, lower.tail = FALSE)
  result <- data.frame(
    formula = deparse(formula), method, ss_effect, ss_error, ms_effect, ms_error,
    etasq, partial.etasq, omegasq, partial.omegasq, cohens.f, power,
    statistic, df_effect, df_error, p, check.names = FALSE
  )
  return(result)
}
##########################################################################################
# REPORT ONEWAY
##########################################################################################
#' @title One-Way ANOVA Report for Several Variables
#' @description For every combination of a dependent variable (\code{dv}) and a
#' grouping variable (\code{iv}), runs and collects in one report:
#' \itemize{
#'   \item Fisher's F test, assuming equal variances (\code{compute_one_way_test})
#'   \item Welch's F test, not assuming equal variances (\code{compute_one_way_test})
#'   \item the Kruskal-Wallis test (\code{compute_kruskal_wallis_test})
#'   \item Levene's and Bartlett's tests of equal variances
#'   \item Tukey and Games-Howell post hoc comparisons (\code{compute_posthoc})
#' }
#' with effect sizes, and a Bonferroni adjustment for the number of combinations.
#' The report can also be written to an Excel workbook, with optional PDF plots.
#'
#' In simple terms, this compares the group means of several outcomes across
#' several grouping variables at once, checks whether the groups have equal
#' variances, and shows which groups differ from which.
#'
#' @param df A data frame.
#' @param dv Integer vector with the column indices of the numeric dependent
#' variables.
#' @param iv Integer vector with the column indices of the grouping variables.
#' @param file Name of the output file, without the extension. If \code{NULL}
#' (default), nothing is written.
#' @param w Width of the PDF pages, in inches.
#' @param h Height of the PDF pages, in inches.
#' @param base_size Base font size of the plots.
#' @param note Text for the footnote of the mean plots.
#' @param title Title of the mean plots.
#' @param type Error bars of the mean plots: \code{"ci"} (95\% confidence
#' interval, default), \code{"se"} (standard error), \code{"sd"} (standard
#' deviation) or \code{""} (none).
#' @param plot_means If TRUE, writes plots of the group means to a PDF file.
#' @param plot_diagnostics If TRUE, writes ANOVA diagnostic plots to a PDF file.
#' @param pb Logical; whether to display a progress bar in the console.
#'
#' @return A list with:
#' \itemize{
#'   \item \code{instructions}: short notes on when to use each test
#'   \item \code{fisher}, \code{welch}: one row per combination, with the output of
#'   \code{compute_one_way_test} (sums of squares, F, degrees of freedom, p-value,
#'   effect sizes and power)
#'   \item \code{kruskal_wallis}: one row per combination, with the output of
#'   \code{compute_kruskal_wallis_test}
#'   \item \code{tukey}, \code{games_howell}: one row per pair of groups in each
#'   combination, with the output of \code{compute_posthoc} (\code{LEVEL} names the
#'   pair)
#'   \item \code{homogeneity}: Levene's and Bartlett's tests for every combination
#' }
#' Every table has the columns \code{DV} and \code{IV}, \code{bonferroni_p} (the
#' Bonferroni-adjusted critical p-value) and \code{significant} (whether
#' \code{p < bonferroni_p}).
#'
#' @details
#' For each combination, rows with a missing value in the dependent or the
#' grouping variable are removed, and groups with a single observation are dropped,
#' because their variance cannot be estimated. Combinations left with fewer than
#' two groups are skipped.
#'
#' The Bonferroni adjustment divides 0.05 by the number of combinations of
#' \code{dv} and \code{iv}; \code{significant} compares each p-value with that
#' critical value. The post hoc p-values are already adjusted for the pairs within
#' each combination.
#'
#' Levene's test uses the deviations from the group means. Bartlett's test is more
#' powerful when the data are normal but sensitive to non-normality. A significant
#' result in either suggests unequal variances.
#'
#' Which test to read:
#' \itemize{
#'   \item Fisher's F assumes equal variances (homoscedasticity); use it with the
#'   Tukey post hoc test.
#'   \item Welch's F does not assume equal variances; use it with the Games-Howell
#'   post hoc test. It is the safer default when the variances or the group sizes
#'   differ.
#'   \item The Kruskal-Wallis test does not assume normality and suits ordinal or
#'   skewed outcomes, but it is not a remedy for unequal variances.
#'   \item The Tukey test (Tukey-Kramer) handles unequal group sizes but assumes
#'   equal variances.
#'   \item The Games-Howell test handles unequal group sizes and unequal variances.
#' }
#'
#' The Excel workbook has the sheets "Fisher", "Welch", "Kruskal", "Homogeneity",
#' "Tukey", "Games-Howell" and "Descriptives". The plots are written to PDF files
#' named after \code{file}. With \code{pb = TRUE}, a progress bar is printed
#' to the console while the tests run.
#'
#' @seealso \code{\link{compute_one_way_test}}, \code{\link{compute_kruskal_wallis_test}},
#' \code{\link{compute_posthoc}}
#' @references
#' Bartlett, M. S. (1937). Properties of sufficiency and statistical tests. Proceedings of the Royal Society of London. Series A, 160(901), 268-282. \doi{10.1098/rspa.1937.0109}
#'
#' Dunn, O. J. (1961). Multiple comparisons among means. Journal of the American Statistical Association, 56(293), 52-64. \doi{10.1080/01621459.1961.10482090}
#'
#' Games, P. A., & Howell, J. F. (1976). Pairwise multiple comparison procedures with unequal n's and/or variances: A Monte Carlo study. Journal of Educational Statistics, 1(2), 113-125. \doi{10.3102/10769986001002113}
#'
#' Kramer, C. Y. (1956). Extension of multiple range tests to group means with unequal numbers of replications. Biometrics, 12(3), 307-310. \doi{10.2307/3001469}
#'
#' Kruskal, W. H., & Wallis, W. A. (1952). Use of ranks in one-criterion variance analysis. Journal of the American Statistical Association, 47(260), 583-621. \doi{10.1080/01621459.1952.10483441}
#'
#' Levene, H. (1960). Robust tests for equality of variances. In I. Olkin (Ed.), Contributions to probability and statistics: Essays in honor of Harold Hotelling (pp. 278-292). Stanford University Press.
#'
#' Welch, B. L. (1951). On the comparison of several mean values: An alternative approach. Biometrika, 38(3/4), 330-336. \doi{10.2307/2332579}
#' @importFrom car leveneTest
#' @importFrom stats bartlett.test
#' @importFrom utils txtProgressBar setTxtProgressBar
#' @importFrom plyr rbind.fill
#' @importFrom openxlsx createWorkbook saveWorkbook
#' @keywords ANOVA
#' @export
#' @examples
#' report_oneway(
#'   df = df_blood_pressure,
#'   dv = c(
#'     which("bp_before" == names(df_blood_pressure)),
#'     which("bp_after" == names(df_blood_pressure))
#'   ),
#'   iv = c(
#'     which("sex" == names(df_blood_pressure)),
#'     which("agegrp" == names(df_blood_pressure))
#'   ),
#'   file = "anova",
#'   plot_diagnostics = FALSE,
#'   plot_means = FALSE
#' )
#' report_oneway(df = mtcars, dv = 2:4, iv = 9:10, file = "anova_oneway_two_factor")
#' report_oneway(df = mtcars, dv = 2:4, iv = 9, file = "anova_oneway_one_factor")
#' report_oneway(
#'   df = mtcars, dv = 2:4, iv = 9, file = "anova_oneway_one_factor",
#'   plot_means = TRUE, plot_diagnostics = TRUE
#' )
report_oneway <- function(df, dv, iv, file = NULL, w = 10, h = 10, base_size = 10, note = "", title = "", type = "ci", plot_means = FALSE, plot_diagnostics = FALSE, pb = FALSE) {
  instruction <- list(
    fisher = "Fisher assumes homoscedasticity (equal variances)",
    welch = "Welch does not assume homoscedasticity (it allows unequal variances)",
    kruskal = "Kruskal Wallis procedure does not assume normality but it is not an alternative for violations of heteroscedasticity",
    tukey = "Posthoc Tukey (Tukey-Kramer): handles unequal sample sizes but assumes equal variances",
    games_howell = "Posthoc Games Howell: good for unequal sample sizes and heteroscedasticity",
    homogeneity_instruction = "significant tests show heteroscedasticity and suggest the use of Welch or alternative procedures. Levene test depends on normality: Non normal distributions may result in false significant results. Sample size may affect test results"
  )

  df_fisher <- df_welch <- df_kruskal <- df_tukey <- df_games_howell <- df_levene <- df_bartlett <- data.frame()

  combinations <- expand.grid(names(df)[iv], names(df)[dv])
  names(combinations) <- c("iv", "dv")
  row.names(combinations) <- paste0(combinations$iv, "_", combinations$dv)
  combinations <- change_data_type(combinations, type = "character")
  if (pb) progress <- txtProgressBar(min = 0, max = length(iv) * length(dv), style = 3)

  for (i in 1:nrow(combinations)) {
    if (pb) setTxtProgressBar(progress, i)
    factors <- combinations$iv[i]
    cors <- combinations$dv[i]

    tempdata <- df[complete.cases(df[, c(factors, cors)]), ]
    tempdata <- tempdata[tempdata[, factors] %in% names(table(tempdata[, factors]))[table(tempdata[, factors]) > 1], ]
    tempdata[, factors] <- factor(tempdata[, factors])
    if (length(unique(tempdata[, factors])) > 1) {
      form <- formula(paste0(cors, "~", factors))
      fisher <- compute_one_way_test(form, df = tempdata, var.equal = TRUE)
      welch <- compute_one_way_test(form, df = tempdata, var.equal = FALSE)
      kruskal <- compute_kruskal_wallis_test(form, df = tempdata)
      levene.test <- car::leveneTest(form, data = tempdata, center = mean)
      bartlett.test <- stats::bartlett.test(form, data = tempdata)

      df_fisher <- rbind(df_fisher, data.frame(DV = cors, IV = factors, fisher, check.names = FALSE))
      df_welch <- rbind(df_welch, data.frame(DV = cors, IV = factors, welch, check.names = FALSE))
      df_kruskal <- rbind(df_kruskal, data.frame(IV = factors, DV = cors, kruskal, check.names = FALSE))
      df_levene <- rbind(df_levene, data.frame(
        Test = "Levene", DV = cors, IV = factors,
        Statistic = levene.test$`F value`[1],
        df_1 = levene.test$Df[1],
        df_2 = levene.test$Df[2],
        p = levene.test$`Pr(>F)`[1],
        check.names = FALSE
      ))
      df_bartlett <- rbind(df_bartlett, data.frame(
        Test = "Bartlett", DV = cors, IV = factors,
        Statistic = bartlett.test$statistic[[1]],
        df_1 = bartlett.test$parameter[[1]],
        p = bartlett.test$p.value,
        check.names = FALSE
      ))

      post_hoc <- compute_posthoc(tempdata[, cors], tempdata[, factors])
      tukey <- data.frame(Method = "Tukey", IV = factors, DV = cors, LEVEL = rownames(post_hoc$output$tukey), post_hoc$output$tukey, row.names = NULL)
      games.howell <- data.frame(method = "Games Howell", IV = factors, DV = cors, LEVEL = rownames(post_hoc$output$games.howell), post_hoc$output$games.howell, row.names = NULL)
      df_tukey <- rbind(df_tukey, tukey)
      df_games_howell <- rbind(df_games_howell, games.howell)
    }
  }
  if (pb) close(progress)

  adjustment <- compute_adjustment(0.05, i)$bonferroni
  df_fisher$bonferroni_p <- df_welch$bonferroni_p <- df_kruskal$bonferroni_p <- df_levene$bonferroni_p <- df_bartlett$bonferroni_p <- adjustment
  df_tukey$bonferroni_p <- df_games_howell$bonferroni_p <- adjustment

  df_fisher$significant <- as.character(df_fisher$p < adjustment)
  df_welch$significant <- as.character(df_welch$p < adjustment)
  df_kruskal$significant <- as.character(df_kruskal$p < adjustment)
  df_tukey$significant <- as.character(df_tukey$p < adjustment)
  df_games_howell$significant <- as.character(df_games_howell$p < adjustment)

  homogeneity <- plyr::rbind.fill(df_levene, df_bartlett)
  homogeneity$significant <- as.character(homogeneity$p < adjustment)

  result <- list(
    instructions = instruction,
    fisher = df_fisher, welch = df_welch, kruskal_wallis = df_kruskal, games_howell = df_games_howell, tukey = df_tukey,
    homogeneity = homogeneity
  )

  descriptives <- compute_descriptives(df = df, dv = dv, iv = iv, file = NULL)
  if (plot_diagnostics) {
    diagnostics <- plot_oneway_diagnostics(df, dv, iv, base_size = base_size)
    report_pdf(plotlist = diagnostics, file = file, title = "diagnostics", w = w, h = h, print_plot = FALSE)
  }
  if (plot_means) {
    oneway_means <- plot_oneway(df, dv = dv, iv = iv, base_size = base_size, note = note, title = title, type = type)
    report_pdf(plotlist = oneway_means$plots, file = file, title = "means", w = w, h = h, print_plot = FALSE)
  }

  comment_text <- list(
    DV = "Dependent Variable",
    IV = "Independent Variable",
    bonferroni_p = "Bonferroni adjustment\nadjusted critical value of p for familywise error",
    significant = "Significant test after familywise error (Bonferroni) adjustment"
  )

  comment_fisher_welch <- c(comment_text, list(
    formula = "Model specification",
    ss_effect = "Sum of Squares\nfor Effect",
    ss_error = "Sum of Squares\nfor Error",
    ms_effect = "Mean Sum of Squares\nfor Effect",
    ms_error = "Mean Sum of Squares\nfor Error",
    df_effect = "Degrees of Freedom\nfor Effect",
    df_error = "Degrees of Freedom\nfor Error",
    etasq = "Effect size\neta squared\n0.01 ~ small\n0.06 ~ medium\n0.14 ~ large",
    partial.etasq = "Effect size\npartial eta squared\n0.01 ~ small\n0.06 ~ medium\n0.14 ~ large",
    omegasq = "Effect size\nomega squared\n0.01 ~ small\n0.06 ~ medium\n0.14 ~ large",
    partial.omegasq = "Effect size\npartial omega squared",
    cohens.f = "Effect size\nCohen's f\n0.10 ~ small\n0.25 ~ medium\n0.40 ~ large",
    statistic = "F"
  ))

  if (!is.null(file)) {
    filename <- paste0(file, ".xlsx")
    if (file.exists(filename)) file.remove(filename)
    wb <- openxlsx::createWorkbook()
    excel_critical_value(result$fisher, wb, "Fisher",
      critical = list(p = "<0.05"),
      title = instruction$fisher, comment = comment_fisher_welch
    )
    excel_critical_value(result$welch, wb, "Welch",
      critical = list(p = "<0.05"),
      title = instruction$welch, comment = comment_fisher_welch
    )
    excel_critical_value(result$kruskal_wallis, wb, "Kruskal",
      critical = list(p = "<0.05"),
      title = instruction$kruskal,
      comment = c(comment_text, list(
        formula = "Model specification",
        etasq = "Effect size\neta squared\n0.01 ~ small\n0.06 ~ medium\n0.14 ~ large",
        df = "Degrees of Freedom"
      ))
    )
    excel_critical_value(result$homogeneity, wb, "Homogeneity",
      critical = list(p = "<0.05"),
      title = instruction$homogeneity, comment = comment_text
    )
    excel_critical_value(result$tukey, wb, "Tukey",
      critical = list(p = "<0.05"),
      title = instruction$tukey, comment = comment_text
    )
    excel_critical_value(result$games_howell, wb, "Games-Howell",
      critical = list(p = "<0.05"),
      title = instruction$games_howell, comment = comment_text
    )
    excel_critical_value(descriptives, wb, "Descriptives")
    openxlsx::saveWorkbook(wb = wb, file = filename, overwrite = TRUE)
  }
  return(result)
}
##########################################################################################
# FACTORIAL ANOVA
##########################################################################################
#' @title Factorial, Repeated Measures and Mixed ANOVA Report
#' @description Runs a factorial ANOVA for one or more dependent variables with
#' \code{ez::ezANOVA}, for between-subjects, within-subjects (repeated measures)
#' and mixed designs, and collects in one report:
#' \itemize{
#'   \item the ANOVA table with the assumption tests: Levene's test for
#'   between-subjects designs, Mauchly's test and the Greenhouse-Geisser and
#'   Huynh-Feldt corrections for within-subjects designs
#'   \item effect sizes for every term from \code{sjstats::anova_stats}
#'   \item pairwise post hoc comparisons for every main effect and interaction
#'   from \code{emmeans}
#' }
#' The report can also be written to an Excel workbook.
#'
#' In simple terms, this tests whether the means differ across the levels of
#' several factors and their combinations, checks the assumptions of the test and
#' shows which conditions differ from which.
#'
#' @param df A data frame in long format, with one row per observation.
#' @param dv Character vector with the names of the dependent variables. Each one
#' is analysed separately.
#' @param wid Name of the column that identifies the participant (subject). Each
#' participant needs a unique value.
#' @param within Character vector with the names of the within-subjects factors.
#' @param within_full Character vector with the names of all the within-subjects
#' factors of the full design, when \code{within} lists only a subset of them and
#' the data have not been averaged per condition yet.
#' @param between Character vector with the names of the between-subjects factors.
#' @param within_covariates Character vector with the names of within-subjects
#' covariates.
#' @param between_covariates Character vector with the names of between-subjects
#' covariates.
#' @param observed Character vector with the names of factors, already listed in
#' \code{within} or \code{between}, that are observed rather than manipulated
#' (for example sex). They change the generalized eta-squared that
#' \code{ez::ezANOVA} reports.
#' @param diff Character vector with the names of factors to collapse into a
#' difference score.
#' @param reverse_diff If TRUE, reverses the direction of the difference score
#' requested by \code{diff}.
#' @param type Type of sums of squares, 1, 2 or 3 (default 3).
#' @param white.adjust If TRUE (default), uses heteroscedasticity-corrected F tests
#' (HC3). It affects only designs with between-subjects factors alone.
#' @param detailed If TRUE (default), adds the sums of squares and the intercept to
#' the ANOVA table.
#' @param return_aov Must be TRUE (default): the effect sizes and the post hoc
#' comparisons are computed from the \code{aov} object that \code{ez::ezANOVA}
#' returns.
#' @param file Name of the Excel file to write, without the extension. If
#' \code{NULL} (default), nothing is written.
#' @param post_hoc_test If TRUE (default), writes the post hoc comparisons to the
#' Excel file.
#'
#' @return A list with:
#' \itemize{
#'   \item \code{omnibus}: the ANOVA table of every dependent variable (\code{dv}),
#'   with \code{DFn} and \code{DFd} (degrees of freedom of the effect and the
#'   error), \code{SSn} and \code{SSd} (sums of squares, when reported), \code{F},
#'   \code{p} and \code{ges} (generalized eta-squared, when reported). Levene's
#'   test is added with the suffix \code{[L]}, Mauchly's test with \code{[M]}, and
#'   the sphericity corrections as \code{GGe}, \code{p[GG]}, \code{HFe} and
#'   \code{p[HF]}.
#'   \item \code{omnibus_effect_size}: eta-squared, partial eta-squared,
#'   omega-squared, partial omega-squared, epsilon-squared, Cohen's f and power
#'   for every term, from \code{sjstats::anova_stats}
#'   \item \code{post_hoc}: pairwise comparisons for every main effect and
#'   interaction, with the estimate, standard error, degrees of freedom,
#'   t ratio and p-value
#'   \item \code{object}: the full output of \code{ez::ezANOVA} for every
#'   dependent variable, including the \code{aov} object
#' }
#'
#' @details
#' Before the analysis, the columns in \code{wid}, \code{within},
#' \code{within_full}, \code{between} and the covariates are converted to factors,
#' and the data are averaged per participant and condition. If a participant has
#' several observations in a condition, the ANOVA uses their mean.
#'
#' The models are fitted with sum-to-zero contrasts (\code{contr.sum}), which
#' Type III sums of squares need. The previous \code{contrasts} option is restored
#' when the function returns.
#'
#' Assumption tests:
#' \itemize{
#'   \item Levene's test (between-subjects designs): a significant result means
#'   that the variances differ across groups.
#'   \item Mauchly's test (within-subjects factors with more than two levels): a
#'   significant result means that sphericity is violated; then use the
#'   Greenhouse-Geisser (\code{p[GG]}) or Huynh-Feldt (\code{p[HF]}) corrected
#'   p-values.
#' }
#'
#' The effect sizes in \code{omnibus_effect_size} are computed by
#' \code{sjstats::anova_stats} from the \code{aov} object, rounded to three
#' decimals. They use sequential (Type I) sums of squares and no
#' heteroscedasticity correction, whatever \code{type} and \code{white.adjust}
#' are, so their F values can differ from those in \code{omnibus} when the design
#' is unbalanced or \code{white.adjust = TRUE}.
#'
#' The post hoc comparisons are the \code{emmeans} pairwise comparisons for every
#' main effect and every interaction, with the p-values adjusted (Tukey) within
#' each effect.
#'
#' The Excel workbook has a sheet for the ANOVA table ("ANOVA within", "ANOVA
#' between" or "ANOVA"), "effect size", "post hoc" (if \code{post_hoc_test = TRUE}),
#' "descriptives" and "call".
#'
#' @source A wrapper around \code{ez::ezANOVA} (Lawrence, 2026), with effect
#' sizes from \code{sjstats::anova_stats} (\enc{Lüdecke}{Ludecke}, 2025) and post
#' hoc comparisons from \code{emmeans} (Lenth & Piaskowski, 2026).
#'
#' @references
#' Bakeman, R. (2005). Recommended effect size statistics for repeated measures designs. Behavior Research Methods, 37(3), 379-384. \doi{10.3758/BF03192707}
#'
#' Greenhouse, S. W., & Geisser, S. (1959). On methods in the analysis of profile data. Psychometrika, 24(2), 95-112. \doi{10.1007/BF02289823}
#'
#' Huynh, H., & Feldt, L. S. (1976). Estimation of the Box correction for degrees of freedom from sample data in randomized block and split-plot designs. Journal of Educational Statistics, 1(1), 69-82. \doi{10.3102/10769986001001069}
#'
#' Lawrence, M. A. (2026). ez: Easy analysis and visualization of factorial experiments (R package version 4.5-0). \doi{10.32614/CRAN.package.ez}
#'
#' Lenth, R., & Piaskowski, J. (2026). emmeans: Estimated marginal means, aka least-squares means (R package version 2.0.4). \doi{10.32614/CRAN.package.emmeans}
#'
#' Long, J. S., & Ervin, L. H. (2000). Using heteroscedasticity consistent standard errors in the linear regression model. The American Statistician, 54(3), 217-224. \doi{10.1080/00031305.2000.10474549}
#'
#' \enc{Lüdecke}{Ludecke}, D. (2025). sjstats: Statistical functions for regression models (R package version 0.19.1). \doi{10.5281/zenodo.1284472}
#'
#' Mauchly, J. W. (1940). Significance test for sphericity of a normal n-variate distribution. The Annals of Mathematical Statistics, 11(2), 204-209. \doi{10.1214/aoms/1177731915}
#' @importFrom ez ezANOVA
#' @keywords ANOVA
#' @export
#' @examples
#' # 36 participants: B1 and B2 vary between participants (4 per cell),
#' # W1 and W2 vary within participants (every participant has all 9 conditions)
#' set.seed(12345)
#' df <- expand.grid(W1 = c("A", "B", "C"), W2 = c("D", "E", "F"), id = 1:36, stringsAsFactors = FALSE)
#' df$B1 <- c("G", "H", "I")[(df$id - 1) %% 3 + 1]
#' df$B2 <- c("J", "K", "L")[(df$id - 1) %/% 3 %% 3 + 1]
#' df <- df[, c("id", "B1", "B2", "W1", "W2")]
#' correlation_matrix <- matrix(0.01, ncol = 4, nrow = 4)
#' diag(correlation_matrix) <- 1
#' dvs <- generate_correlation_matrix(correlation_matrix, nrows = nrow(df)) + 10
#' names(dvs) <- paste0("DV", 1:4)
#' df <- data.frame(df, dvs)
#' # DV1 differs across the levels of W1 and B1
#' df$DV1 <- df$DV1 + match(df$W1, c("A", "B", "C")) + match(df$B1, c("G", "H", "I"))
#' # within-subjects design
#' r1 <- report_factorial_anova(
#'   df = df, wid = "id", dv = c("DV1", "DV2"),
#'   within = c("W1", "W2"), within_full = c("W1", "W2"),
#'   file = file.path(tempdir(), "anova_within")
#' )
#' # between-subjects design
#' r2 <- report_factorial_anova(
#'   df = df, wid = "id", dv = c("DV1", "DV2"),
#'   between = c("B1", "B2"),
#'   file = file.path(tempdir(), "anova_between")
#' )
#' # mixed design
#' r3 <- report_factorial_anova(
#'   df = df, wid = "id", dv = c("DV1", "DV2"),
#'   within = c("W1", "W2"), within_full = c("W1", "W2"),
#'   between = c("B1", "B2"),
#'   file = file.path(tempdir(), "anova_mixed"),
#'   post_hoc_test = FALSE
#' )
#' # within-subjects design with within-subjects covariates
#' r4 <- report_factorial_anova(
#'   df = df, wid = "id", dv = c("DV1", "DV2"),
#'   within = c("W1", "W2"), within_full = c("W1", "W2"),
#'   within_covariates = c("DV3", "DV4"),
#'   file = file.path(tempdir(), "anova_within_cov")
#' )
report_factorial_anova <- function(df, dv, wid, within = NULL, within_full = NULL, between = NULL, within_covariates = NULL, between_covariates = NULL,
                                   observed = NULL, diff = NULL, reverse_diff = FALSE, type = 3, white.adjust = TRUE, detailed = TRUE, return_aov = TRUE,
                                   file = NULL, post_hoc_test = TRUE) {
  comment <- list(
    DFn = "Degrees of Freedom\nfor numerator",
    DFd = "Degrees of Freedom\nfor denominator",
    SSn = "Sum of Squares\nfor numerator",
    SSd = "Sum of Squares\nfor denominator",
    dv = "Dependent Variable",
    df = "Degrees of Freedom",
    sumsq = "Sum of squares",
    meansq = "Mean sum of squares",
    statistic = "F value",
    p.value = "p for F value",
    etasq = "Effect size\neta squared\n0.01 ~ small\n0.06 ~ medium\n0.14 ~ large",
    partial.etasq = "Effect size\npartial eta squared",
    omegasq = "Effect size\nomega squared\n0.01 ~ small\n0.06 ~ medium\n0.14 ~ large",
    partial.omegasq = "Effect size\npartial omega squared",
    epsilonsq = "Effect size\nepsilon squared",
    cohens.f = "Effect size\nCohen's f\n0.10 ~ small\n0.25 ~ medium\n0.40 ~ large",
    power = "power",
    "DFn[L]" = "Levene test\nDegrees of Freedom\nfor numerator",
    "DFd[L]" = "Levene test\nDegrees of Freedom\nfor denominator",
    "SSn[L]" = "Levene test\nSum of squares\nfor numerator",
    "SSd[L]" = "Levene test\nSum of squares\nfor denominator",
    "F[L]" = "Levene test\nF",
    "p[L]" = "Levene test\np\nif significant, the assumption of homoscedasticity is violated",
    "W[M]" = "Mauchly's Test\nW",
    "p[M]" = "Mauchly's Test\np\nIf significant, the assumption of sphericity is violated",
    "GGe" = "Greenhouse-Geisser\nepsilon",
    "p[GG]" = "Greenhouse-Geisser\np adjusted for violated sphericity",
    "HFe" = "Huynh-Feldt\n epsilon",
    "p[HF]" = "Huynh-Feldt\np adjusted for violated sphericity"
  )
  testdata <- df
  call_arguments <- match.call()
  call_string <- gsub(" ", "", gsub("\"", " ", gsub(", ,", ",", toString(unlist(deparse(call_arguments))))))
  old_options <- options(contrasts = c("contr.sum", "contr.poly"))
  on.exit(options(old_options), add = TRUE)
  result <- emf <- list()
  post_hoc <- omnibus <- omnibus_effect_size <- data.frame()
  collumn_design <- unique(c(wid, within, within_full, between, within_covariates, between_covariates))
  testdata[, collumn_design] <- lapply(testdata[, collumn_design], as.factor)

  testdata <- plyr::ddply(testdata, collumn_design, plyr::numcolwise(mean, na.rm = TRUE))
  factor_index <- which(names(testdata) %in% unique(c(within, within_full, between)))
  descriptives <- compute_aggregate(df = testdata, iv = factor_index, file = NULL)

  for (dependent in dv) {
    ea_argument <- function(argument) {
      result <- argument
      if (isTRUE(argument)) {
        result <- "TRUE"
      }
      if (isFALSE(argument)) {
        result <- "FALSE"
      }
      if (is.null(argument)) {
        result <- "NULL"
      }
      if (length(argument) > 1) {
        result <- toString(argument)
        result <- paste0(c(".(", result, ")"), collapse = " ")
      }
      return(result)
    }

    ez_text <- paste(
      "ez::ezANOVA(\tdata=testdata,\n",
      "\t\tdv=", ea_argument(dependent), ",\n",
      "\t\twid=", ea_argument(wid), ",\n",
      "\t\twithin=", ea_argument(within), ",\n",
      "\t\twithin_full=", ea_argument(within_full), ",\n",
      "\t\tbetween=", ea_argument(between), ",\n",
      "\t\twithin_covariates=", ea_argument(within_covariates), ",\n",
      "\t\tbetween_covariates=", ea_argument(between_covariates), ",\n",
      "\t\tobserved=", ea_argument(observed), ",\n",
      "\t\tdiff=", ea_argument(diff), ",\n",
      "\t\treverse_diff=", ea_argument(reverse_diff), ",\n",
      "\t\ttype=", ea_argument(type), ",\n",
      "\t\twhite.adjust=", ea_argument(white.adjust), ",\n",
      "\t\tdetailed=", ea_argument(detailed), ",\n",
      "\t\treturn_aov=", ea_argument(return_aov), ")"
    )
    ez <- eval(parse(text = ez_text))

    if (!is.null(ez$`Levene's Test for Homogeneity of Variance`)) {
      ez[[grep("Levene", names(ez))]] <- data.frame(Effect = ez$ANOVA$Effect, ez[[grep("Levene", names(ez))]], check.names = FALSE)
      levene_names <- names(ez[[grep("Levene", names(ez))]])
      names(ez[[grep("Levene", names(ez))]])[2:length(levene_names)] <- paste0(levene_names[2:length(levene_names)], "[L]")
    }
    if (!is.null(ez$`Mauchly's Test for Sphericity`)) {
      mauchly_names <- names(ez[[grep("Mauchly", names(ez))]])
      names(ez[[grep("Mauchly", names(ez))]])[2:length(mauchly_names)] <- paste0(mauchly_names[2:length(mauchly_names)], "[M]")
    }

    result_omnibus <- data.frame(dv = dependent, Reduce(function(x, y) merge(x, y, all = TRUE, sort = FALSE, suffixes = "", no.dups = FALSE), ez[names(ez) != "aov"]), check.names = FALSE, stringsAsFactors = FALSE)
    result_omnibus[, grep("<.05", names(result_omnibus))] <- NULL
    ez$effect_size <- data.frame(dv = dependent, sjstats::anova_stats(ez$aov), check.names = FALSE)
    omnibus <- plyr::rbind.fill(omnibus, result_omnibus)
    omnibus_effect_size <- plyr::rbind.fill(omnibus_effect_size, ez$effect_size)
    iv <- unique(c(within, within_full, between))
    for (i in 1:length(iv)) {
      emf[[i]] <- combn(iv, i)
    }
    for (cf in emf) {
      for (rcf in 1:ncol(cf)) {
        means <- emmeans::emmeans(ez$aov, formula(paste("~", paste(as.character(cf[, rcf]), collapse = "*"))))
        paired_comparison <- data.frame(dv = dependent, graphics::pairs(means), check.names = FALSE)
        post_hoc <- plyr::rbind.fill(post_hoc, paired_comparison)
      }
    }
    result[[dependent]] <- ez
    # if(!is.null(between)&is.null(within)&is.null(within_full))
    #   plot_diagnostic<-autoplot(ez$aov,which=1:6,ncol=2,label.size=3)+
    #   labs(caption=paste0(deparse(ez$aov$terms),"\nobservations=",nrow(ez$aov$model)))+
    #   theme_bw(base_size=base_size)+
    #   theme(axis.text.x=element_text(angle=45,hjust=1))
  }
  result <- list(omnibus = omnibus, omnibus_effect_size = omnibus_effect_size, post_hoc = post_hoc, object = result)

  if (!is.null(file)) {
    filename <- paste0(file, ".xlsx")
    if (file.exists(filename)) file.remove(filename)
    wb <- openxlsx::createWorkbook()
    if (length(omnibus$"p[GG]") > 0) {
      excel_critical_value(omnibus,
        workbook = wb, sheet = "ANOVA within", numFmt = "#0.00", title = paste("Sum of Squares type:", type),
        critical = list(p = "<0.05", "p[M]" = "<0.05", "p[GG]" = "<0.05", "p[HF]" = "<0.05"),
        comment = comment
      )
    }
    if (length(omnibus$"p[L]") > 0) {
      excel_critical_value(omnibus,
        workbook = wb, sheet = "ANOVA between", numFmt = "#0.00", title = paste("Sum of Squares type:", type),
        critical = list(p = "<0.05", "p[L]" = "<0.05"),
        comment = comment
      )
    }
    if (length(omnibus$"p[L]") == 0 & length(omnibus$"p[GG]") == 0) {
      excel_critical_value(omnibus, workbook = wb, sheet = "ANOVA", critical = list(p = "<0.05"), numFmt = "#0.00", title = paste("Sum of Squares type:", type), comment = comment)
    }
    excel_critical_value(omnibus_effect_size, workbook = wb, sheet = "effect size", critical = list("p.value" = "<0.05"), comment = comment, numFmt = "#0.00")
    if (nrow(post_hoc) > 0 & post_hoc_test) {
      excel_critical_value(post_hoc, workbook = wb, sheet = "post hoc", critical = list("p.value" = "<0.05"), numFmt = "#0.00")
    }
    excel_critical_value(descriptives, workbook = wb, sheet = "descriptives", numFmt = "#0.00")
    excel_critical_value(data.frame(call = call_string), workbook = wb, sheet = "call", numFmt = "#0.00")
    openxlsx::saveWorkbook(wb = wb, file = filename, overwrite = TRUE)
  }
  return(result)
}
##########################################################################################
# MANOVA RESULT
##########################################################################################
#' @title MANOVA Report
#' @description Reports the four multivariate test statistics (Pillai's trace,
#' Wilks' lambda, the Hotelling-Lawley trace and Roy's largest root) with their
#' approximate F tests for every term of a \code{manova} model, and the Type III
#' MANOVA table from \code{car::Anova}. The tables are printed and can also be
#' written to an Excel workbook.
#'
#' In simple terms, this tests whether groups differ on several outcomes considered
#' together, rather than on each outcome separately.
#'
#' @param model A model fitted with \code{stats::manova}.
#' @param file Name of the Excel file to write, without the extension. If
#' \code{NULL} (default), nothing is written.
#'
#' @return Invisibly, a list with:
#' \itemize{
#'   \item \code{multivariate}: data frame with the Pillai, Wilks, Hotelling-Lawley and Roy
#'   statistics, their approximate F tests and p-values (column \code{type} names the test)
#'   \item \code{type_three}: Type III MANOVA table from \code{car::Anova}
#'   \item \code{call}: the model call
#' }
#'
#' @details
#' With \eqn{\lambda_1, \dots, \lambda_s} the eigenvalues of \eqn{HE^{-1}}, where
#' \eqn{H} is the hypothesis and \eqn{E} the error sums of squares and
#' cross-products matrix of a term:
#' \itemize{
#'   \item Pillai's trace, \eqn{V=\sum \lambda_i/(1+\lambda_i)}: the sum of the
#'   proportions of variance explained on the discriminant functions. It is the
#'   most robust of the four to violations of the assumptions and a good default.
#'   \item Wilks' lambda, \eqn{\Lambda=\prod 1/(1+\lambda_i)}: the proportion of
#'   variance not explained; smaller values mean larger effects.
#'   \item Hotelling-Lawley trace, \eqn{T=\sum \lambda_i}: the sum of the ratios of
#'   explained to unexplained variance.
#'   \item Roy's largest root, \eqn{\lambda_1}: uses only the first discriminant
#'   function. Its F statistic is an upper bound, so its p-value is a lower bound
#'   and the test is liberal.
#' }
#' The four tests agree when the term has one degree of freedom. The table also
#' includes the intercept.
#'
#' The Type III table tests each term adjusted for all the others, so it needs
#' sum-to-zero contrasts such as \code{contr.sum} or \code{contr.helmert}. Set them
#' with \code{options(contrasts = c("contr.sum", "contr.poly"))} before fitting the
#' model with \code{manova}; \code{report_manova} does not change them.
#'
#' Assumptions of MANOVA:
#' \itemize{
#'   \item independent observations, randomly sampled
#'   \item dependent variables measured on an interval scale
#'   \item multivariate normality of the dependent variables within each group
#'   \item equal variance-covariance matrices across groups: equal variances of
#'   each dependent variable and equal correlations between them in every group
#' }
#'
#' The Excel workbook has the sheets "critical" (the four tests) and "call".
#'
#' @references
#' Fox, J., & Weisberg, S. (2019). An R companion to applied regression (3rd ed.). Sage. \url{https://www.john-fox.ca/Companion/}
#'
#' Hotelling, H. (1951). A generalized T test and measure of multivariate dispersion. In J. Neyman (Ed.), Proceedings of the Second Berkeley Symposium on Mathematical Statistics and Probability (pp. 23-41). University of California Press.
#'
#' Olson, C. L. (1976). On choosing a test statistic in multivariate analysis of variance. Psychological Bulletin, 83(4), 579-586. \doi{10.1037/0033-2909.83.4.579}
#'
#' Pillai, K. C. S. (1955). Some new test criteria in multivariate analysis. The Annals of Mathematical Statistics, 26(1), 117-121. \doi{10.1214/aoms/1177728599}
#'
#' Roy, S. N. (1953). On a heuristic method of test construction and its use in multivariate analysis. The Annals of Mathematical Statistics, 24(2), 220-238. \doi{10.1214/aoms/1177729029}
#'
#' Wilks, S. S. (1932). Certain generalizations in the analysis of variance. Biometrika, 24(3/4), 471-494. \doi{10.2307/2331979}
#' @keywords ANOVA
#' @importFrom car Anova
#' @importFrom openxlsx createWorkbook saveWorkbook
#' @export
#' @examples
#' ## Set orthogonal contrasts.
#' op <- options(contrasts = c("contr.helmert", "contr.poly"))
#' model_mixed <- manova(cbind(yield, foo) ~ N * P * K, within(npk, foo <- rnorm(24)))
#' model_between <- manova(cbind(rnorm(24), rnorm(24)) ~ round(rnorm(24), 0) * round(rnorm(24), 0))
#' report_manova(model = model_mixed)
#' result <- report_manova(model = model_between)
#' result$multivariate
#' ## Restore the previous contrasts.
#' options(op)
report_manova <- function(model, file = NULL) {
  pillai <- data.frame(Group = row.names(summary(model, intercept = TRUE, test = c("Pillai"))$stats), summary(model, intercept = TRUE, test = c("Pillai"))$stats, check.names = FALSE)
  wilks <- data.frame(Group = row.names(summary(model, intercept = TRUE, test = c("Wilks"))$stats), summary(model, intercept = TRUE, test = c("Wilks"))$stats, check.names = FALSE)
  hotelling <- data.frame(Group = row.names(summary(model, intercept = TRUE, test = c("Hotelling-Lawley"))$stats), summary(model, intercept = TRUE, test = c("Hotelling-Lawley"))$stats, check.names = FALSE)
  roy <- data.frame(Group = row.names(summary(model, intercept = TRUE, test = c("Roy"))$stats), summary(model, intercept = TRUE, test = c("Roy"))$stats, check.names = FALSE)
  type_three <- car::Anova(model, type = "III")
  pillai$type <- "Pillai"
  wilks$type <- "Wilks"
  hotelling$type <- "Hotelling-Lawley"
  roy$type <- "Roy"
  names(pillai)[3] <- names(wilks)[3] <- names(hotelling)[3] <- names(roy)[3] <- "Statistic"
  pwhr <- rbind(pillai, wilks, hotelling, roy)
  row.names(pwhr) <- NULL
  output_separator("Pillai,Wilks,Hotelling-Lawley,Roy Statistics", output = pwhr)
  output_separator("type Three", output = type_three)
  call <- data.frame(toString(deparse(model$call)))
  if (!is.null(file)) {
    filename <- paste0(file, ".xlsx")
    if (file.exists(filename)) file.remove(filename)
    wb <- openxlsx::createWorkbook()
    excel_critical_value(pwhr, wb, "critical", critical = list("Pr(>F)" = "<0.05"), numFmt = "#0.00")
    excel_critical_value(call, wb, "call", numFmt = "#0.00")
    openxlsx::saveWorkbook(wb = wb, file = filename, overwrite = TRUE)
  }
  result <- list(multivariate = pwhr, type_three = type_three, call = call)
  return(invisible(result))
}
##########################################################################################
# ETA PARTIAL ETA OMEGA PARTIAL OMEGA FOR AOV
##########################################################################################
#' @title Effect Sizes for ANOVA Models
#' @description Builds the ANOVA table of a between-subjects \code{aov} model with
#' Type I, II or III sums of squares and adds six effect sizes for every term:
#' \itemize{
#'   \item \code{etasq}: eta-squared (\eqn{\eta^2})
#'   \item \code{partial_etasq}: partial eta-squared (\eqn{\eta^2_p})
#'   \item \code{omegasq}: omega-squared (\eqn{\omega^2})
#'   \item \code{partial_omegasq}: partial omega-squared (\eqn{\omega^2_p})
#'   \item \code{epsilonsq}: epsilon-squared (\eqn{\epsilon^2})
#'   \item \code{cohens_f}: Cohen's f, computed from \eqn{\eta^2_p}
#' }
#'
#' In simple terms, this shows for every factor and interaction of an ANOVA how
#' much of the variance in the outcome it explains.
#'
#' @param model An \code{aov} model of a between-subjects design (without an
#' \code{Error()} term).
#' @param ss Type of sums of squares: \code{"I"} (sequential, the default),
#' \code{"II"} or \code{"III"}.
#'
#' @return A data frame with one row per term, one for the residuals and, with
#' \code{ss = "III"}, one for the intercept:
#' \itemize{
#'   \item \code{call}: model formula
#'   \item \code{ss}: type of sums of squares
#'   \item \code{comparisons}: term
#'   \item \code{Df}, \code{Sum Sq}, \code{Mean Sq}, \code{F value}, \code{Pr(>F)}: the ANOVA table
#'   \item \code{etasq}: \eqn{SS_{effect}/SS_{total}}
#'   \item \code{partial_etasq}: \eqn{SS_{effect}/(SS_{effect}+SS_{error})}
#'   \item \code{omegasq}: \eqn{(SS_{effect}-df_{effect} MS_{error})/(SS_{total}+MS_{error})}
#'   \item \code{partial_omegasq}: \eqn{df_{effect}(MS_{effect}-MS_{error})/(SS_{effect}+(N-df_{effect}) MS_{error})}
#'   \item \code{epsilonsq}: \eqn{(SS_{effect}-df_{effect} MS_{error})/SS_{total}}
#'   \item \code{cohens_f}: \eqn{\sqrt{\eta^2_p/(1-\eta^2_p)}}
#' }
#' The effect sizes are \code{NA} for the residuals and the intercept.
#'
#' @details
#' \eqn{SS_{total}} is the sum of the sums of squares of all the terms and the
#' residuals in the table, \eqn{MS_{error}} the residual mean square and \eqn{N}
#' the number of observations used by the model.
#'
#' The non-partial measures (\code{etasq}, \code{omegasq}, \code{epsilonsq}) divide
#' by the total variance, so they depend on the other factors in the design. The
#' partial measures (\code{partial_etasq}, \code{partial_omegasq}, \code{cohens_f})
#' divide by the variance of the term and the error only, which makes them easier
#' to compare across designs. In a one-way design the two are the same.
#' \code{etasq} and \code{partial_etasq} are biased upwards in small samples;
#' \code{omegasq}, \code{partial_omegasq} and \code{epsilonsq} correct for that and
#' are negative when \eqn{F < 1}. Negative values are returned as they are, as in
#' \code{sjstats::anova_stats}; \code{effectsize} reports them as 0.
#'
#' Types of sums of squares:
#' \itemize{
#'   \item \code{"I"}: sequential; each term is adjusted for the terms before it,
#'   so the result depends on the order of the terms in the formula.
#'   \item \code{"II"}: each term is adjusted for all the other terms that do not
#'   contain it (main effects are not adjusted for their interactions).
#'   \item \code{"III"}: each term is adjusted for all the other terms. It needs
#'   sum-to-zero contrasts, set with
#'   \code{options(contrasts = c("contr.sum", "contr.poly"))} before the model is
#'   fitted; with the default treatment contrasts the Type III sums of squares of
#'   main effects are not meaningful.
#' }
#' In a balanced design the three types give the same results. In an unbalanced
#' design Type II and III sums of squares do not add up to the total variance of
#' the outcome; \eqn{SS_{total}} is then the sum of the table, as in
#' \code{effectsize}.
#'
#' Rules of thumb for \code{etasq}, \code{omegasq}, \code{epsilonsq} and
#' \code{cohens_f}. Small, medium and large are the benchmarks of Cohen (1988);
#' tiny, very large and huge convert the Cohen's d benchmarks of Sawilowsky (2009)
#' with \eqn{\eta^2=d^2/(d^2+4)} and \eqn{f=d/2}:
#' \itemize{
#'   \item tiny: \eqn{\eta^2} < 0.01, f < 0.10 (d < 0.2)
#'   \item small: \eqn{\eta^2} 0.01 to < 0.06, f 0.10 to < 0.25 (d = 0.2)
#'   \item medium: \eqn{\eta^2} 0.06 to < 0.14, f 0.25 to < 0.40 (d = 0.5)
#'   \item large: \eqn{\eta^2} 0.14 to < 0.26, f 0.40 to < 0.60 (d = 0.8)
#'   \item very large: \eqn{\eta^2} 0.26 to < 0.50, f 0.60 to < 1.00 (d = 1.2)
#'   \item huge: \eqn{\eta^2} >= 0.50, f >= 1.00 (d = 2.0)
#' }
#' These are rough guides; what counts as a meaningful effect depends on the field.
#'
#' The effect sizes match \code{effectsize::eta_squared},
#' \code{effectsize::omega_squared}, \code{effectsize::epsilon_squared} and
#' \code{effectsize::cohens_f} (apart from the truncation of negative values) and
#' \code{sjstats::anova_stats}.
#'
#' @source The computation of \code{partial_omegasq} is adapted from the answer
#' of Stephen Martin (2014) to the question "Omega squared for measure of effect
#' in R?" on Cross Validated, \url{https://stats.stackexchange.com/a/126520},
#' licensed CC BY-SA 3.0. The Type II and III sums of squares come from
#' \code{car::Anova} (Fox & Weisberg, 2019).
#'
#' @importFrom car Anova
#' @importFrom stats model.frame formula
#' @references
#' Ben-Shachar, M. S., \enc{Lüdecke}{Ludecke}, D., & Makowski, D. (2020). effectsize: Estimation of effect size indices and standardized parameters. Journal of Open Source Software, 5(56), 2815. \doi{10.21105/joss.02815}
#'
#' Cohen, J. (1988). Statistical power analysis for the behavioral sciences (2nd ed.). Lawrence Erlbaum Associates.
#'
#' Fox, J., & Weisberg, S. (2019). An R companion to applied regression (3rd ed.). Sage. \url{https://www.john-fox.ca/Companion/}
#'
#' Hays, W. L. (1963). Statistics for psychologists. Holt, Rinehart and Winston.
#'
#' Kelley, T. L. (1935). An unbiased correlation ratio measure. Proceedings of the National Academy of Sciences, 21(9), 554-559. \doi{10.1073/pnas.21.9.554}
#'
#' Martin, S. (2014, December 3). Answer to "Omega squared for measure of effect in R?" Cross Validated. \url{https://stats.stackexchange.com/a/126520}
#'
#' Olejnik, S., & Algina, J. (2003). Generalized eta and omega squared statistics: Measures of effect size for some common research designs. Psychological Methods, 8(4), 434-447. \doi{10.1037/1082-989X.8.4.434}
#'
#' Sawilowsky, S. S. (2009). New effect size rules of thumb. Journal of Modern Applied Statistical Methods, 8(2), 597-599. \doi{10.22237/jmasm/1257035100}
#' @keywords ANOVA
#' @export
#' @examples
#' one_way_between <- aov(uptake ~ Treatment, data = CO2)
#' compute_aov_es(model = one_way_between, ss = "I")
#' sjstats::anova_stats(one_way_between, digits = 10)
#' effectsize::omega_squared(one_way_between, partial = FALSE)
#'
#' # Type III sums of squares need sum-to-zero contrasts
#' old_contrasts <- options(contrasts = c("contr.sum", "contr.poly"))
#' factorial_between <- aov(uptake ~ Treatment * Type, data = CO2)
#' compute_aov_es(model = factorial_between, ss = "I")
#' compute_aov_es(model = factorial_between, ss = "II")
#' compute_aov_es(model = factorial_between, ss = "III")
#' sjstats::anova_stats(car::Anova(factorial_between, type = 3), digits = 10)
#' effectsize::omega_squared(car::Anova(factorial_between, type = 3), partial = TRUE)
#' options(old_contrasts)
compute_aov_es <- function(model, ss = "I") {
  ss <- match.arg(ss, c("I", "II", "III"))
  n_total <- nrow(stats::model.frame(model))
  if (ss == "I") {
    summary_aov <- data.frame(summary(model)[[1]], check.names = FALSE)
  } else {
    summary_aov <- data.frame(car::Anova(model, type = ss), check.names = FALSE)
    summary_aov$`Mean Sq` <- summary_aov$`Sum Sq` / summary_aov$Df
    summary_aov <- summary_aov[, c("Df", "Sum Sq", "Mean Sq", "F value", "Pr(>F)")]
  }
  if (ss == "III") {
    intercept <- summary_aov[1, ]
    summary_aov <- summary_aov[2:nrow(summary_aov), ]
  }

  residual_row <- nrow(summary_aov)
  ms_effect <- summary_aov[1:(residual_row - 1), 3]
  ms_error <- summary_aov[residual_row, 3]
  df_effect <- summary_aov[1:(residual_row - 1), 1]
  df_error <- summary_aov[residual_row, 1]
  ss_effect <- summary_aov[1:(residual_row - 1), 2]
  ss_error <- summary_aov[residual_row, 2]
  ss_total <- rep(sum(summary_aov[1:residual_row, 2]), residual_row - 1)

  omega <- (ss_effect - df_effect * ms_error) / (ss_total + ms_error)
  partial_omega <- (df_effect * (ms_effect - ms_error)) / (ss_effect + (n_total - df_effect) * ms_error)
  names(omega) <- names(partial_omega) <- trimws(rownames(summary_aov)[1:(residual_row - 1)])
  eta <- ss_effect / ss_total
  partial_eta <- ss_effect / (ss_effect + ss_error)
  cohens_f <- sqrt(partial_eta / (1 - partial_eta))
  epsilon <- (ss_effect - df_effect * ms_error) / ss_total

  if (ss == "III") {
    summary_aov <- rbind_all(intercept, summary_aov)
  }

  summary_aov <- data.frame(
    call = paste(deparse(stats::formula(model)), collapse = ""),
    ss = ss,
    comparisons = trimws(row.names(summary_aov)),
    summary_aov,
    check.names = FALSE
  )

  result <- data.frame(
    call = paste(deparse(stats::formula(model)), collapse = ""),
    ss = ss,
    comparisons = names(omega),
    etasq = eta,
    partial_etasq = partial_eta,
    omegasq = omega,
    partial_omegasq = partial_omega,
    epsilonsq = epsilon,
    cohens_f = cohens_f
  )

  result <- merge(summary_aov, result, all = TRUE, sort = FALSE)
  return(result)
}
##########################################################################################
# POST HOC
##########################################################################################
#' @title Tukey and Games-Howell Post Hoc Tests
#' @description Compares every pair of group means after a one-way ANOVA with two
#' post hoc tests:
#' \itemize{
#'   \item \code{tukey}: the Tukey-Kramer test, which pools the variances of all
#'   groups and assumes they are equal
#'   \item \code{games.howell}: the Games-Howell test, which uses the variances of
#'   the two groups being compared and does not assume equal variances
#' }
#'
#' In simple terms, after an ANOVA shows that the group means differ, this shows
#' which pairs of groups differ, while keeping the chance of any false positive
#' across all the pairs at 5\%.
#'
#' @param y A numeric vector with the outcome.
#' @param x A vector with the group of each value of \code{y}, a factor or a vector
#' that can be converted to one.
#'
#' @return A list with:
#' \itemize{
#'   \item \code{input}: list with the \code{x} and \code{y} supplied
#'   \item \code{output}: list with two matrices, \code{tukey} and
#'   \code{games.howell}, each with one row per pair of groups (named
#'   \code{"group1:group2"} in the order of the factor levels) and the columns:
#'   \itemize{
#'     \item \code{t}: absolute t statistic of the pair
#'     \item \code{df}: degrees of freedom
#'     \item \code{p}: p-value, adjusted for all the pairwise comparisons
#'   }
#' }
#'
#' @details
#' For groups \eqn{i} and \eqn{j} with means \eqn{\bar{y}}, variances \eqn{s^2} and
#' sizes \eqn{n}, out of \eqn{k} groups and \eqn{N} observations:
#'
#' Tukey-Kramer (Tukey, 1953; Kramer, 1956) uses the pooled error variance
#' \eqn{MS_{error}=\sum (n_j-1)s_j^2/(N-k)}:
#' \deqn{t_{ij}=\frac{|\bar{y}_i-\bar{y}_j|}{\sqrt{MS_{error}(1/n_i+1/n_j)}},\qquad df=N-k}
#'
#' Games-Howell (Games & Howell, 1976) uses the two group variances and the
#' Welch-Satterthwaite degrees of freedom for each pair:
#' \deqn{t_{ij}=\frac{|\bar{y}_i-\bar{y}_j|}{\sqrt{s_i^2/n_i+s_j^2/n_j}},\qquad
#' df_{ij}=\frac{(s_i^2/n_i+s_j^2/n_j)^2}{\frac{(s_i^2/n_i)^2}{n_i-1}+\frac{(s_j^2/n_j)^2}{n_j-1}}}
#'
#' In both tests the p-value comes from the studentized range distribution,
#' \eqn{p=P(q_{k,df}\ge\sqrt{2}\,t_{ij})}, which already accounts for the number of
#' groups. Do not adjust these p-values again.
#'
#' Use Tukey after Fisher's F test (\code{compute_one_way_test(var.equal = TRUE)})
#' and Games-Howell after Welch's F test (\code{var.equal = FALSE}). Games-Howell
#' is the safer choice when the group variances or sizes differ.
#'
#' \code{t} is an absolute value; the direction of a difference comes from the
#' group means. The p-values match \code{stats::TukeyHSD} and
#' \code{rstatix::games_howell_test}.
#'
#' Missing values are not removed: a missing value in \code{y} makes every
#' result \code{NA}. Remove incomplete cases before calling the function, as
#' \code{report_oneway} does.
#'
#' @source Adapted from \code{posthocTGH()} in the \code{userfriendlyscience}
#' package by Gjalt-Jorn Peters (Open University of the Netherlands) and Jeff
#' Baggett (University of Wisconsin - La Crosse), licensed GPL (>= 3),
#' \url{https://github.com/Matherion/userfriendlyscience}. \code{posthocTGH()} was
#' in turn based on \code{games_howell.R}, a script hosted on the course page of
#' Robert Cribbie (York University) at
#' \code{http://www.psych.yorku.ca/cribbie/6130/games_howell.R}, which is no
#' longer available.
#'
#' @references
#' Games, P. A., & Howell, J. F. (1976). Pairwise multiple comparison procedures with unequal n's and/or variances: A Monte Carlo study. Journal of Educational Statistics, 1(2), 113-125. \doi{10.3102/10769986001002113}
#'
#' Kramer, C. Y. (1956). Extension of multiple range tests to group means with unequal numbers of replications. Biometrics, 12(3), 307-310. \doi{10.2307/3001469}
#'
#' Peters, G.-J. Y. userfriendlyscience: Quantitative analysis made accessible (R package version 0.7.2). \url{https://github.com/Matherion/userfriendlyscience}
#'
#' Tukey, J. W. (1953). The problem of multiple comparisons. Unpublished manuscript, Princeton University.
#' @importFrom utils combn
#' @importFrom stats ptukey complete.cases
#' @keywords ANOVA
#' @export
#' @examples
#' TukeyHSD(aov(bp_before ~ agegrp, data = df_blood_pressure))
#' rstatix::games_howell_test(df_blood_pressure, bp_before ~ agegrp)
#' compute_posthoc(y = df_blood_pressure$bp_before, x = df_blood_pressure$agegrp)
#' compute_posthoc(y = df_blood_pressure$bp_after, x = df_blood_pressure$agegrp)
compute_posthoc <- function(y, x) {
  res <- list(input = list(x = x, y = y))
  res$intermediate <- list(x = factor(x[complete.cases(x, y)]), y = y[complete.cases(x, y)])
  res$intermediate$n <- tapply(y, x, length)
  res$intermediate$groups <- length(res$intermediate$n)
  res$intermediate$df <- sum(res$intermediate$n) - res$intermediate$groups
  res$intermediate$means <- tapply(y, x, mean)
  res$intermediate$variances <- tapply(y, x, var)
  res$intermediate$pairNames <- utils::combn(levels(res$intermediate$x), 2, paste0, collapse = ":")
  res$intermediate$descriptives <- cbind(res$intermediate$n, res$intermediate$means, res$intermediate$variances)
  rownames(res$intermediate$descriptives) <- levels(res$intermediate$x)
  colnames(res$intermediate$descriptives) <- c("n", "means", "variances")
  # Tukey
  res$intermediate$errorVariance <- sum((res$intermediate$n - 1) * res$intermediate$variances) / res$intermediate$df
  res$intermediate$t <- utils::combn(res$intermediate$groups, 2, function(ij) {
    abs(diff(res$intermediate$means[ij])) / sqrt(res$intermediate$errorVariance * sum(1 / res$intermediate$n[ij]))
  })
  res$intermediate$p.tukey <- stats::ptukey(res$intermediate$t * sqrt(2), res$intermediate$groups, res$intermediate$df, lower.tail = FALSE)
  res$output <- list()
  res$output$tukey <- cbind(res$intermediate$t, res$intermediate$df, res$intermediate$p.tukey)
  rownames(res$output$tukey) <- res$intermediate$pairNames
  colnames(res$output$tukey) <- c("t", "df", "p")
  # Games-Howell
  res$intermediate$df.corrected <- utils::combn(res$intermediate$groups, 2, function(ij) {
    sum(res$intermediate$variances[ij] / res$intermediate$n[ij])^2 / sum((res$intermediate$variances[ij] / res$intermediate$n[ij])^2 / (res$intermediate$n[ij] - 1))
  })
  res$intermediate$t.corrected <- utils::combn(res$intermediate$groups, 2, function(ij) {
    abs(diff(res$intermediate$means[ij])) / sqrt(sum(res$intermediate$variances[ij] / res$intermediate$n[ij]))
  })
  res$intermediate$p.gameshowell <- stats::ptukey(res$intermediate$t.corrected * sqrt(2), res$intermediate$groups, res$intermediate$df.corrected, lower.tail = FALSE)
  res$output$games.howell <- cbind(res$intermediate$t.corrected, res$intermediate$df.corrected, res$intermediate$p.gameshowell)
  rownames(res$output$games.howell) <- res$intermediate$pairNames
  colnames(res$output$games.howell) <- c("t", "df", "p")
  res$intermediate <- NULL
  return(res)
}
##########################################################################################
# NOTES
##########################################################################################
# ASSUMPTIONS: 1 interval data of the dependent variable,2 normality,3 homoscedasticity,and 4 no multicollinearity
##########################################################################################
# ANCOVA
# Assumptions: 1 Independence of the covariate and the treatment effect,2 homogeneity of regression slopes
##########################################################################################
# REPEATED MEASURES
# Assumptions: 1 Sphericity
