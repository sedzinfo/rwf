##########################################################################################
# KRUSKALL WALLIS TEST WITH EFFECT SIZE
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
#' @importFrom stats pchisq quantile na.omit
#' @references
#' Cohen, J. (1988). Statistical power analysis for the behavioral sciences (2nd ed.). Lawrence Erlbaum Associates.
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
#' @importFrom stats pchisq quantile complete.cases
#' @references
#' Cohen, J. (1988). Statistical power analysis for the behavioral sciences (2nd ed.). Lawrence Erlbaum Associates.
#'
#' Friedman, M. (1937). The use of ranks to avoid the assumption of normality implicit in the analysis of variance. Journal of the American Statistical Association, 32(200), 675-701. \doi{10.1080/01621459.1937.10503522}
#'
#' Kendall, M. G., & Babington Smith, B. (1939). The problem of m rankings. The Annals of Mathematical Statistics, 10(3), 275-287. \doi{10.1214/aoms/1177732186}
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
#' @title one way test
#' @inheritParams compute_kruskal_wallis_test
#' @param var.equal if TRUE it assumes equal variances
#' @note eta and omega for Welch statistics are not adequately tested and they should not be consulted
#' @importFrom stats pf
#' @keywords ANOVA
#' @export
#' @examples
#' form <- formula(bp_before ~ agegrp)
#' compute_one_way_test(formula = form, df = df_blood_pressure, var.equal = TRUE)
#' compute_one_way_test(formula = form, df = df_blood_pressure, var.equal = FALSE)
#' oneway.test(formula = form, data = df_blood_pressure, var.equal = TRUE)
#' oneway.test(formula = form, data = df_blood_pressure, var.equal = FALSE)
#' car::Anova(aov(form, data = df_blood_pressure), type = 2)
#' model <- lm(form, data = df_blood_pressure)
#' lsr::etaSquared(aov(form, data = df_blood_pressure), type = 3, anova = TRUE)
#' sjstats::anova_stats(model, digits = 22)
compute_one_way_test <- function(formula, df, var.equal = TRUE) {
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
  partial.omegasq <- (df_effect * (ms_effect - ms_error)) / (df_effect * ms_effect + (n - df_effect) * ms_error)
  cohens.f <- sqrt(etasq / (1 - etasq))
  lambda <- cohens.f * (df_effect + df_error + 1)
  power <- stats::pf(stats::qf(0.05, df_effect, df_error, lower = FALSE), df_effect, df_error, lambda, lower = FALSE)
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
#' @title One way
#' @inheritParams plot_oneway_diagnostics
#' @param file output filename
#' @param w width of pdf file
#' @param h height of pdf file
#' @param base_size base font size
#' @param note text for footnote
#' @param title plot title
#' @param type type of bar to display "se" "ci" "sd" ""
#' @param plot_means if TRUE it will output mean plots and descriptives for plots
#' @param plot_diagnostics if TRUE it will output ANOVA diagnostics plots
#' @note (1) The Fisher procedure assumes heteroscedasticity \cr
#'       (2) The Welch procedure does not assume heteroscedasticity \cr
#'       (3) The Kruskal Wallis procedure does not assume normality but it is not an alternative for violations of heteroscedasticity \cr
#'       (4) Posthoc Tuckey: not good for unequal sample sizes or heteroscedasticity \cr
#'       (5) Posthoc Games Howell: good for unequal sample sizes and heteroscedasticity
#' @importFrom car leveneTest
#' @importFrom stats bartlett.test
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
report_oneway <- function(df, dv, iv, file = NULL, w = 10, h = 10, base_size = 10, note = "", title = "", type = "ci", plot_means = FALSE, plot_diagnostics = FALSE) {
  instruction <- list(
    fisher = "Fisher assumes heteroscedasticity",
    welch = "Welch does not assume heteroscedasticity",
    kruskal = "Kruskal Wallis procedure does not assume normality but it is not an alternative for violations of heteroscedasticity",
    tukey = "Posthoc Tuckey: not good for unequal sample sizes or heteroscedasticity",
    games_howell = "Posthoc Games Howell: good for unequal sample sizes and heteroscedasticity",
    homogeneity_instruction = "significant tests show heteroscedasticity and suggest the use of Welch or alternative procedures. Levene test depends on normality: Non normal distributions may result in false significant results. Sample size may affect test results"
  )

  df_fisher <- df_welch <- df_kruskal <- df_tukey <- df_games_howell <- df_levene <- df_bartlett <- data.frame()

  combinations <- expand.grid(names(df)[iv], names(df)[dv])
  names(combinations) <- c("iv", "dv")
  row.names(combinations) <- paste0(combinations$iv, "_", combinations$dv)
  combinations <- change_data_type(combinations, type = "character")
  pb <- txtProgressBar(min = 0, max = length(iv) * length(dv), style = 3)

  for (i in 1:nrow(combinations)) {
    setTxtProgressBar(pb, i)
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
  close(pb)

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
    bonferroni_p = "Bonferonni adjustment\nadjusted critical value of p for familiwise error",
    significant = "Significant test after familiwise error (Bonferonni) adjustment"
  )

  comment_fisher_welch <- c(comment_text, list(
    formula = "Model spesification",
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
    cohens.f = "Effect size\nCohen's f\n0.14 ~ small\n0.39 ~ medium\n0.59 ~ large",
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
        formula = "Model spesification",
        etasq = "Effect size\neta squared\n0.01 ~ small\n0.06 ~ medium\n0.14 ~ large",
        df = "Degrees of Freedom"
      ))
    )
    excel_critical_value(result$homogeneity, wb, "Homogeneity",
      critical = list(p = "<0.05"),
      title = instruction$homogeneity, comment = comment_text
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
#' @title Plot means with standard error for every level in a dataframe
#' @param df dataframe
#' @param dv names of dependent variables
#' @param wid names of
#' @param within names of within factors
#' @param within_full names of within factors after data are collapsed to means per condition
#' @param between names of between factors
#' @param within_covariates names of within covariates
#' @param between_covariates mames of between covariates
#' @param observed names in data that are already specified in either within or between that contain predictor variables that are observed variables (not manipulated)
#' @param diff names of variables to collapse in a different score
#' @param reverse_diff If TRUE, triggers reversal of the difference collapse requested by diff
#' @param type sum of squares 1 2 3
#' @param white.adjust if TRUE corrects for heteroscedasticity
#' @param detailed if TRUE returns detailed information
#' @param return_aov if TRUE returns aov object
#' @param post_hoc_test if TRUE outputs post hoc in file
#' @param base_size base font size
#' @param file output filename
#' @importFrom ez ezANOVA
#' @keywords ANOVA
#' @export
#' @examples
#' set.seed(12345)
#' df <- data.frame(
#'   id = rep(seq(1, 80), each = 81, 1),
#'   IV1 = rep(LETTERS[1:3], each = 1, 2160),
#'   IV2 = rep(LETTERS[4:6], each = 3, 720),
#'   IV3 = rep(LETTERS[7:9], each = 9, 240),
#'   IV4 = rep(LETTERS[10:12], each = 27, 80),
#'   stringsAsFactors = FALSE
#' )
#' cdf <- data.frame(matrix(.01, ncol = 4, nrow = 4))
#' correlation_martix <- as.matrix(cdf)
#' diag(correlation_martix) <- 1
#' cdf <- generate_correlation_matrix(correlation_martix, nrows = nrow(df)) + 10
#' names(cdf) <- paste0("DV", 1:4)
#' df <- data.frame(df, cdf)
#' df$DV2 <- df$DV2 + 10
#' df$DV3 <- df$DV3 + 20
#' df$DV4 <- df$DV4 + 30
#' df[df$IV1 %in% "A", ]$DV1 <- df[df$IV1 %in% "A", ]$DV1 + 1
#' df[df$IV1 %in% "B", ]$DV1 <- df[df$IV1 %in% "B", ]$DV1 + 2
#' df[df$IV1 %in% "C", ]$DV1 <- df[df$IV1 %in% "C", ]$DV1 + 3
#' cdf(df)
#' r1 <- report_factorial_anova(
#'   df = df, wid = "id", dv = c("DV1", "DV2"),
#'   within = c("IV1", "IV2"), within_full = c("IV1", "IV2"),
#'   between = NULL,
#'   within_covariates = NULL, between_covariates = NULL,
#'   file = "anova_within",
#'   post_hoc = TRUE
#' )
#' r2 <- report_factorial_anova(
#'   df = df, wid = "id", dv = c("DV1", "DV2"),
#'   within = NULL, within_full = NULL,
#'   between = c("IV1", "IV2"),
#'   within_covariates = NULL, between_covariates = NULL,
#'   file = "anova_between",
#'   post_hoc = TRUE
#' )
#' r3 <- report_factorial_anova(
#'   df = df, wid = "id", dv = c("DV1", "DV2"),
#'   within = c("IV3", "IV4"), within_full = c("IV3", "IV4"),
#'   between = c("IV1", "IV2"),
#'   within_covariates = NULL, between_covariates = NULL,
#'   file = "anova_mixed",
#'   post_hoc = FALSE
#' )
#' r4 <- report_factorial_anova(
#'   df = df, wid = "id", dv = c("DV1", "DV2"),
#'   within = c("IV1", "IV2"), within_full = c("IV1", "IV2"),
#'   between = NULL,
#'   within_covariates = c("DV3", "DV4"), between_covariates = NULL,
#'   file = "anova_within_cov",
#'   post_hoc = TRUE
#' )
report_factorial_anova <- function(df, dv, wid, within = NULL, within_full = NULL, between = NULL, within_covariates = NULL, between_covariates = NULL,
                                   observed = NULL, diff = NULL, reverse_diff = FALSE, type = 3, white.adjust = TRUE, detailed = TRUE, return_aov = TRUE,
                                   file = NULL, post_hoc_test = TRUE, base_size = 15) {
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
    etasq = "Effect size\neta squared\n  0.01 ~ small\n  0.06 ~ medium\n0.014 ~ large",
    partial.etasq = "Effect size\npartial eta squared",
    omegasq = "Effect size\nomega squared\n  0.01 ~ small\n  0.06 ~ medium\n0.014 ~ large",
    partial.omegasq = "Effect size\npartial omega squared",
    epsilonsq = "Effect size\nepsilon squared",
    cohens.f = "Effect size\nCohen's f\n0.14 ~ small\n0.39 ~ medium\n0.59 ~ large",
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
    "HFe" = "Huynd-Feldt\n epsilon",
    "p[HF]" = "Huynd-Feldt\np adjusted for violated sphericity"
  )
  testdata <- df
  call_arguments <- match.call()
  call_string <- gsub(" ", "", gsub("\"", " ", gsub(", ,", ",", toString(unlist(deparse(call_arguments))))))
  options(contrasts = c("contr.sum", "contr.poly"))
  bonferroni <- compute_adjustment(0.05, length(dv))$bonferroni
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
      for (rcf in 1:nrow(cf)) {
        means <- emmeans::emmeans(ez$aov, formula(paste("~", paste(as.character(cf[rcf, ]), collapse = "*"))))
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
#' @title Manova result
#' @param model object of manova model
#' @param file output filename
#' @keywords ANOVA
#' @note
#' Pillai-Bartlett trace (V): Represents the sum of the proportion of explained variance on the discriminant functions.
#' As such,it is similar to the ratio of SS M /SS T,which is known as R 2. \cr
#' Hotelling-s T 2: Represents the sum of the eigenvalues for each variate it compares directly to the F-ratio in ANOVA  \cr
#' Wilks-s lambda (L): Represents the ratio of error variance to total variance (SS R /SS T ) for each variate.  \cr
#' Roy-s largest root: Represents the proportion of explained variance to unexplained variance (SS M /SS R ) for the first discriminant function.  \cr
#' ASSUMPTIONS  \cr
#' Independence: Observations should be statistically independent.  \cr
#' Random sampling: Data should be randomly sampled from the population of interest and measured at an interval level.  \cr
#' Multivariate normality: In ANOVA,we assume that our dependent variable is normally distributed within each group.
#' In the case of MANOVA,we assume that the dependent variables (collectively) have multivariate normality within groups.  \cr
#' Homogeneity of covariance matrices: In ANOVA,it is assumed that the variances in each group are roughly equal (homogeneity of variance).
#' In MANOVA we must assume that this is true for each dependent variable,but also that the correlation between any two dependent variables is the same in all groups.
#' This assumption is examined by testing whether the population variance-covariance matrices of the different groups in the analysis are equal.
#' @importFrom car Anova
#' @importFrom openxlsx createWorkbook saveWorkbook
#' @export
#' @examples
#' ## Set orthogonal contrasts.
#' op <- options(contrasts = c("contr.helmert", "contr.poly"))
#' model_mixed <- manova(cbind(yield, foo) ~ N * P * K, within(npk, foo <- rnorm(24)))
#' model_between <- manova(cbind(rnorm(24), rnorm(24)) ~ round(rnorm(24), 0) * round(rnorm(24), 0))
#' report_manova(model = model_mixed)
#' report_manova(model = model_between)
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
}
##########################################################################################
# ETA PARTIAL ETA OMEGA PARTIAL OMEGA FOR AOV
##########################################################################################
#' @title Compute eta and omega
#' @description Computes omega using aov object. Based on http://stats.stackexchange.com/a/126520
#' @param model object aov
#' @param ss Character type of sums of squares "I" "II" "III"
#' @importFrom car Anova
#' @importFrom stats model.frame
#' @keywords ANOVA
#' @export
#' @examples
#' form <- formula(uptake ~ Treatment)
#' one_way_between <- aov(form, CO2)
#' factorial_between <- aov(uptake ~ Treatment * Type, CO2)
#' compute_aov_es(model = one_way_between, ss = "I")
#' sjstats::anova_stats(one_way_between, digits = 10)
#' compute_aov_es(model = one_way_between, ss = "II")
#' sjstats::anova_stats(one_way_between, digits = 10)
#' compute_aov_es(model = one_way_between, ss = "III")
#' sjstats::anova_stats(one_way_between, digits = 10)
#' compute_aov_es(model = factorial_between, ss = "I")
#' sjstats::anova_stats(factorial_between, digits = 10)
#' compute_aov_es(model = factorial_between, ss = "II")
#' sjstats::anova_stats(factorial_between, digits = 10)
#' compute_aov_es(model = factorial_between, ss = "III")
#' sjstats::anova_stats(car::Anova(factorial_between, Type = 3), digits = 10)
compute_aov_es <- function(model, ss = "I") {
  n_total <- nrow(stats::model.frame(model))
  ss1 <- data.frame(summary(model)[[1]], check.names = FALSE)
  ss2 <- data.frame(car::Anova(model, type = "II"), check.names = FALSE)
  ss3 <- data.frame(car::Anova(model, type = "III"), check.names = FALSE)
  ss2$`Mean Sq` <- ss2$`Sum Sq` / ss2$Df
  ss3$`Mean Sq` <- ss3$`Sum Sq` / ss3$Df
  ss2 <- ss2[, c("Df", "Sum Sq", "Mean Sq", "F value", "Pr(>F)")]
  ss3 <- ss3[, c("Df", "Sum Sq", "Mean Sq", "F value", "Pr(>F)")]

  if (ss == "I") {
    summary_aov <- ss1
  }
  if (ss == "II") {
    summary_aov <- ss2
  }
  if (ss == "III") {
    summary_aov <- ss3[2:nrow(ss3), ]
    intercept <- ss3[1, ]
  }

  residual_row <- nrow(summary_aov)
  ms_effect <- summary_aov[1:(residual_row - 1), 3]
  ms_error <- summary_aov[residual_row, 3]
  df_effect <- summary_aov[1:(residual_row - 1), 1]
  df_error <- summary_aov[residual_row, 1]
  ss_effect <- summary_aov[1:(residual_row - 1), 2]
  ss_error <- summary_aov[residual_row, 2]
  ss_total <- rep(sum(summary_aov[1:residual_row, 2]), residual_row - 1)

  omega <- abs((ss_effect - df_effect * ms_error) / (ss_total + ms_error))
  partial_omega <- abs((df_effect * (ms_effect - ms_error)) / (ss_effect + (n_total - df_effect) * ms_error))
  names(omega) <- names(partial_omega) <- trimws(rownames(summary_aov)[1:(residual_row - 1)])
  eta <- ss_effect / ss_total
  partial_eta <- ss_effect / (ss_effect + ss_error)
  cohens_f <- sqrt(partial_eta / (1 - partial_eta))
  epsilon <- (ss_effect - df_effect * ms_error) / ss_total

  if (ss == "III") {
    summary_aov <- rbind_all(intercept, summary_aov)
  }

  summary_aov <- data.frame(
    call = deparse(eval(model$call$formula)),
    ss = ss,
    comparisons = trimws(row.names(summary_aov)),
    summary_aov,
    check.names = FALSE
  )

  result <- data.frame(
    call = deparse(eval(model$call$formula)),
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
#' @title Games Howell Tukey post hoc tests
#' @description Based on http://www.psych.yorku.ca/cribbie/6130/games_howell.R
#' @param y Vector continous variable
#' @param x Vector factor
#' @importFrom utils combn
#' @importFrom stats ptukey
#' @keywords ANOVA
#' @export
#' @examples
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
