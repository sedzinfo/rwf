# Factorial, Repeated Measures and Mixed ANOVA Report

Runs a factorial ANOVA for one or more dependent variables with
[`ez::ezANOVA`](https://rdrr.io/pkg/ez/man/ezANOVA.html), for
between-subjects, within-subjects (repeated measures) and mixed designs,
and collects in one report:

- the ANOVA table with the assumption tests: Levene's test for
  between-subjects designs, Mauchly's test and the Greenhouse-Geisser
  and Huynh-Feldt corrections for within-subjects designs

- effect sizes for every term from
  [`sjstats::anova_stats`](https://strengejacke.github.io/sjstats/reference/anova_stats.html)

- pairwise post hoc comparisons for every main effect and interaction
  from `emmeans`

The report can also be written to an Excel workbook.

In simple terms, this tests whether the means differ across the levels
of several factors and their combinations, checks the assumptions of the
test and shows which conditions differ from which.

## Usage

``` r
report_factorial_anova(
  df,
  dv,
  wid,
  within = NULL,
  within_full = NULL,
  between = NULL,
  within_covariates = NULL,
  between_covariates = NULL,
  observed = NULL,
  diff = NULL,
  reverse_diff = FALSE,
  type = 3,
  white.adjust = TRUE,
  detailed = TRUE,
  return_aov = TRUE,
  file = NULL,
  post_hoc_test = TRUE
)
```

## Source

A wrapper around
[`ez::ezANOVA`](https://rdrr.io/pkg/ez/man/ezANOVA.html) (Lawrence,
2026), with effect sizes from
[`sjstats::anova_stats`](https://strengejacke.github.io/sjstats/reference/anova_stats.html)
(Lüdecke, 2025) and post hoc comparisons from `emmeans` (Lenth &
Piaskowski, 2026).

## Arguments

- df:

  A data frame in long format, with one row per observation.

- dv:

  Character vector with the names of the dependent variables. Each one
  is analysed separately.

- wid:

  Name of the column that identifies the participant (subject). Each
  participant needs a unique value.

- within:

  Character vector with the names of the within-subjects factors.

- within_full:

  Character vector with the names of all the within-subjects factors of
  the full design, when `within` lists only a subset of them and the
  data have not been averaged per condition yet.

- between:

  Character vector with the names of the between-subjects factors.

- within_covariates:

  Character vector with the names of within-subjects covariates.

- between_covariates:

  Character vector with the names of between-subjects covariates.

- observed:

  Character vector with the names of factors, already listed in `within`
  or `between`, that are observed rather than manipulated (for example
  sex). They change the generalized eta-squared that
  [`ez::ezANOVA`](https://rdrr.io/pkg/ez/man/ezANOVA.html) reports.

- diff:

  Character vector with the names of factors to collapse into a
  difference score.

- reverse_diff:

  If TRUE, reverses the direction of the difference score requested by
  `diff`.

- type:

  Type of sums of squares, 1, 2 or 3 (default 3).

- white.adjust:

  If TRUE (default), uses heteroscedasticity-corrected F tests (HC3). It
  affects only designs with between-subjects factors alone.

- detailed:

  If TRUE (default), adds the sums of squares and the intercept to the
  ANOVA table.

- return_aov:

  Must be TRUE (default): the effect sizes and the post hoc comparisons
  are computed from the `aov` object that
  [`ez::ezANOVA`](https://rdrr.io/pkg/ez/man/ezANOVA.html) returns.

- file:

  Name of the Excel file to write, without the extension. If `NULL`
  (default), nothing is written.

- post_hoc_test:

  If TRUE (default), writes the post hoc comparisons to the Excel file.

## Value

A list with:

- `omnibus`: the ANOVA table of every dependent variable (`dv`), with
  `DFn` and `DFd` (degrees of freedom of the effect and the error),
  `SSn` and `SSd` (sums of squares, when reported), `F`, `p` and `ges`
  (generalized eta-squared, when reported). Levene's test is added with
  the suffix `[L]`, Mauchly's test with `[M]`, and the sphericity
  corrections as `GGe`, `p[GG]`, `HFe` and `p[HF]`.

- `omnibus_effect_size`: eta-squared, partial eta-squared,
  omega-squared, partial omega-squared, epsilon-squared, Cohen's f and
  power for every term, from
  [`sjstats::anova_stats`](https://strengejacke.github.io/sjstats/reference/anova_stats.html)

- `post_hoc`: pairwise comparisons for every main effect and
  interaction, with the estimate, standard error, degrees of freedom, t
  ratio and p-value

- `object`: the full output of
  [`ez::ezANOVA`](https://rdrr.io/pkg/ez/man/ezANOVA.html) for every
  dependent variable, including the `aov` object

## Details

Before the analysis, the columns in `wid`, `within`, `within_full`,
`between` and the covariates are converted to factors, and the data are
averaged per participant and condition. If a participant has several
observations in a condition, the ANOVA uses their mean.

The models are fitted with sum-to-zero contrasts (`contr.sum`), which
Type III sums of squares need. The previous `contrasts` option is
restored when the function returns.

Assumption tests:

- Levene's test (between-subjects designs): a significant result means
  that the variances differ across groups.

- Mauchly's test (within-subjects factors with more than two levels): a
  significant result means that sphericity is violated; then use the
  Greenhouse-Geisser (`p[GG]`) or Huynh-Feldt (`p[HF]`) corrected
  p-values.

The effect sizes in `omnibus_effect_size` are computed by
[`sjstats::anova_stats`](https://strengejacke.github.io/sjstats/reference/anova_stats.html)
from the `aov` object, rounded to three decimals. They use sequential
(Type I) sums of squares and no heteroscedasticity correction, whatever
`type` and `white.adjust` are, so their F values can differ from those
in `omnibus` when the design is unbalanced or `white.adjust = TRUE`.

The post hoc comparisons are the `emmeans` pairwise comparisons for
every main effect and every interaction, with the p-values adjusted
(Tukey) within each effect.

The Excel workbook has a sheet for the ANOVA table ("ANOVA within",
"ANOVA between" or "ANOVA"), "effect size", "post hoc" (if
`post_hoc_test = TRUE`), "descriptives" and "call".

## References

Bakeman, R. (2005). Recommended effect size statistics for repeated
measures designs. Behavior Research Methods, 37(3), 379-384.
[doi:10.3758/BF03192707](https://doi.org/10.3758/BF03192707)

Greenhouse, S. W., & Geisser, S. (1959). On methods in the analysis of
profile data. Psychometrika, 24(2), 95-112.
[doi:10.1007/BF02289823](https://doi.org/10.1007/BF02289823)

Huynh, H., & Feldt, L. S. (1976). Estimation of the Box correction for
degrees of freedom from sample data in randomized block and split-plot
designs. Journal of Educational Statistics, 1(1), 69-82.
[doi:10.3102/10769986001001069](https://doi.org/10.3102/10769986001001069)

Lawrence, M. A. (2026). ez: Easy analysis and visualization of factorial
experiments (R package version 4.5-0).
[doi:10.32614/CRAN.package.ez](https://doi.org/10.32614/CRAN.package.ez)

Lenth, R., & Piaskowski, J. (2026). emmeans: Estimated marginal means,
aka least-squares means (R package version 2.0.4).
[doi:10.32614/CRAN.package.emmeans](https://doi.org/10.32614/CRAN.package.emmeans)

Long, J. S., & Ervin, L. H. (2000). Using heteroscedasticity consistent
standard errors in the linear regression model. The American
Statistician, 54(3), 217-224.
[doi:10.1080/00031305.2000.10474549](https://doi.org/10.1080/00031305.2000.10474549)

Lüdecke, D. (2025). sjstats: Statistical functions for regression models
(R package version 0.19.1).
[doi:10.5281/zenodo.1284472](https://doi.org/10.5281/zenodo.1284472)

Mauchly, J. W. (1940). Significance test for sphericity of a normal
n-variate distribution. The Annals of Mathematical Statistics, 11(2),
204-209.
[doi:10.1214/aoms/1177731915](https://doi.org/10.1214/aoms/1177731915)

## Examples

``` r
# 36 participants: B1 and B2 vary between participants (4 per cell),
# W1 and W2 vary within participants (every participant has all 9 conditions)
set.seed(12345)
df <- expand.grid(W1 = c("A", "B", "C"), W2 = c("D", "E", "F"), id = 1:36, stringsAsFactors = FALSE)
df$B1 <- c("G", "H", "I")[(df$id - 1) %% 3 + 1]
df$B2 <- c("J", "K", "L")[(df$id - 1) %/% 3 %% 3 + 1]
df <- df[, c("id", "B1", "B2", "W1", "W2")]
correlation_matrix <- matrix(0.01, ncol = 4, nrow = 4)
diag(correlation_matrix) <- 1
dvs <- generate_correlation_matrix(correlation_matrix, nrows = nrow(df)) + 10
names(dvs) <- paste0("DV", 1:4)
df <- data.frame(df, dvs)
# DV1 differs across the levels of W1 and B1
df$DV1 <- df$DV1 + match(df$W1, c("A", "B", "C")) + match(df$B1, c("G", "H", "I"))
# within-subjects design
r1 <- report_factorial_anova(
  df = df, wid = "id", dv = c("DV1", "DV2"),
  within = c("W1", "W2"), within_full = c("W1", "W2"),
  file = file.path(tempdir(), "anova_within")
)
#> Warning: Collapsing data to cell means first using variables supplied to "within_full", then collapsing the resulting means to means for the cells supplied to "within".
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> Warning: Collapsing data to cell means first using variables supplied to "within_full", then collapsing the resulting means to means for the cells supplied to "within".
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
# between-subjects design
r2 <- report_factorial_anova(
  df = df, wid = "id", dv = c("DV1", "DV2"),
  between = c("B1", "B2"),
  file = file.path(tempdir(), "anova_between")
)
#> Coefficient covariances computed by hccm()
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> Coefficient covariances computed by hccm()
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
# mixed design
r3 <- report_factorial_anova(
  df = df, wid = "id", dv = c("DV1", "DV2"),
  within = c("W1", "W2"), within_full = c("W1", "W2"),
  between = c("B1", "B2"),
  file = file.path(tempdir(), "anova_mixed"),
  post_hoc_test = FALSE
)
#> Warning: Collapsing data to cell means first using variables supplied to "within_full", then collapsing the resulting means to means for the cells supplied to "within".
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> Warning: Collapsing data to cell means first using variables supplied to "within_full", then collapsing the resulting means to means for the cells supplied to "within".
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
# within-subjects design with within-subjects covariates
r4 <- report_factorial_anova(
  df = df, wid = "id", dv = c("DV1", "DV2"),
  within = c("W1", "W2"), within_full = c("W1", "W2"),
  within_covariates = c("DV3", "DV4"),
  file = file.path(tempdir(), "anova_within_cov")
)
#> Warning: Implementation of ANCOVA in this version of ez is experimental and not yet fully validated. Also, note that ANCOVA is intended purely as a tool to increase statistical power; ANCOVA can not eliminate confounds in the data. Specifically, covariates should: (1) be uncorrelated with other predictors and (2) should have effects on the DV that are independent of other predictors. Failure to meet these conditions may dramatically increase the rate of false-positives.
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: Collapsing data to cell means first using variables supplied to "within_full", then collapsing the resulting means to means for the cells supplied to "within".
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> Warning: Implementation of ANCOVA in this version of ez is experimental and not yet fully validated. Also, note that ANCOVA is intended purely as a tool to increase statistical power; ANCOVA can not eliminate confounds in the data. Specifically, covariates should: (1) be uncorrelated with other predictors and (2) should have effects on the DV that are independent of other predictors. Failure to meet these conditions may dramatically increase the rate of false-positives.
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: contrasts dropped from factor ezCov due to missing levels
#> Warning: Collapsing data to cell means first using variables supplied to "within_full", then collapsing the resulting means to means for the cells supplied to "within".
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
```
