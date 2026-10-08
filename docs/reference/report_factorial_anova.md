# Factorial ANOVA report for one or more dependent variables

Runs a factorial (within, between or mixed) ANOVA with
[`ez::ezANOVA`](https://rdrr.io/pkg/ez/man/ezANOVA.html) for every
dependent variable in `dv`, adds effect sizes
([`sjstats::anova_stats`](https://strengejacke.github.io/sjstats/reference/anova_stats.html))
and pairwise post hoc comparisons for every factor and every combination
of factors (`emmeans`), and optionally writes everything to an Excel
workbook.

Before the analysis the data are collapsed to one mean per participant
and design cell (every column named in `wid`, `within`, `within_full`,
`between` and the covariates is treated as a factor). Sum-to-zero
contrasts are set with `options(contrasts = ...)`, which changes the
session option.

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
  post_hoc_test = TRUE,
  base_size = 15
)
```

## Arguments

- df:

  data frame in long format, one row per observation.

- dv:

  character vector, names of the dependent variables. One ANOVA is run
  per variable.

- wid:

  name of the column that identifies participants (the subject id).

- within:

  character vector, names of the within-subject factors, or `NULL`.

- within_full:

  character vector, names of the within-subject factors after the data
  are collapsed to means per condition, or `NULL`. Usually the same as
  `within`.

- between:

  character vector, names of the between-subject factors, or `NULL`.

- within_covariates:

  character vector, names of the within-subject covariates, or `NULL`.

- between_covariates:

  character vector, names of the between-subject covariates, or `NULL`.

- observed:

  character vector, names of variables already listed in `within` or
  `between` that are observed (measured) rather than manipulated. Used
  by `ezANOVA` for the generalized eta squared.

- diff:

  character vector, names of within variables to collapse into a
  difference score.

- reverse_diff:

  logical. If `TRUE`, reverses the direction of the difference requested
  in `diff`.

- type:

  sum of squares type: 1, 2 or 3. Default 3.

- white.adjust:

  logical. If `TRUE`, uses a heteroscedasticity-corrected covariance
  matrix (between-subject designs only).

- detailed:

  logical. If `TRUE`, `ezANOVA` returns sums of squares.

- return_aov:

  logical. If `TRUE`, keeps the `aov` object; it is needed for the
  effect sizes and post hoc tests, so leave it `TRUE`.

- file:

  output file name without extension. If not `NULL`, the results are
  written to `<file>.xlsx`, replacing any existing file.

- post_hoc_test:

  logical. If `TRUE`, adds the post hoc comparisons as a sheet in the
  Excel file. Post hoc comparisons are always computed and returned;
  this only controls whether they are written to `file`.

- base_size:

  base font size. Currently unused (the diagnostic plot that used it is
  commented out).

## Value

A list with:

- omnibus:

  data frame, the ANOVA table of every dependent variable, with Levene's
  (`[L]`) and Mauchly's (`[M]`) tests and sphericity corrections where
  they apply.

- omnibus_effect_size:

  data frame, effect sizes per term (eta squared, partial eta squared,
  omega squared, Cohen's f, power, ...).

- post_hoc:

  data frame, pairwise comparisons for every factor and combination of
  factors.

- object:

  list, the raw `ezANOVA` result per dependent variable, including the
  `aov` object.

## Examples

``` r
set.seed(12345)
df <- data.frame(
  id = rep(seq(1, 80), each = 81, 1),
  IV1 = rep(LETTERS[1:3], each = 1, 2160),
  IV2 = rep(LETTERS[4:6], each = 3, 720),
  IV3 = rep(LETTERS[7:9], each = 9, 240),
  IV4 = rep(LETTERS[10:12], each = 27, 80),
  stringsAsFactors = FALSE
)
cdf <- data.frame(matrix(.01, ncol = 4, nrow = 4))
correlation_martix <- as.matrix(cdf)
diag(correlation_martix) <- 1
cdf <- generate_correlation_matrix(correlation_martix, nrows = nrow(df)) + 10
names(cdf) <- paste0("DV", 1:4)
df <- data.frame(df, cdf)
df$DV2 <- df$DV2 + 10
df$DV3 <- df$DV3 + 20
df$DV4 <- df$DV4 + 30
df[df$IV1 %in% "A", ]$DV1 <- df[df$IV1 %in% "A", ]$DV1 + 1
df[df$IV1 %in% "B", ]$DV1 <- df[df$IV1 %in% "B", ]$DV1 + 2
df[df$IV1 %in% "C", ]$DV1 <- df[df$IV1 %in% "C", ]$DV1 + 3
cdf(df)
#> $summary
#>   COLLUMNS ROWS TOTAL EMPTY null NAN na INF   FIN FACTOR
#> 1        9 6480 58320     0    0   0  0   0 32400      0
#> 
#> $check
#>   NAMES EMPTY null na NOT_NA NAN INF  FIN RANGE  MEAN MEDIAN    SD         MIN         MAX      MODE      TYPE     CLASS FACTOR
#> 1    id     0    0  0   6480   0   0 6480    80  40.5   40.5 23.09           1          80   numeric   integer   integer  FALSE
#> 2   IV1     0    0  0   6480   0   0    0     3    NA     NA    NA           A           C character character character  FALSE
#> 3   IV2     0    0  0   6480   0   0    0     3    NA     NA    NA           D           F character character character  FALSE
#> 4   IV3     0    0  0   6480   0   0    0     3    NA     NA    NA           G           I character character character  FALSE
#> 5   IV4     0    0  0   6480   0   0    0     3    NA     NA    NA           J           L character character character  FALSE
#> 6   DV1     0    0  0   6480   0   0 6480  6480 11.98  11.99   1.3 7.512912073 16.26404907   numeric    double   numeric  FALSE
#> 7   DV2     0    0  0   6480   0   0 6480  6480 20.01  20.02     1 16.33788325 23.62325263   numeric    double   numeric  FALSE
#> 8   DV3     0    0  0   6480   0   0 6480  6480 30.01     30  0.98 26.12652032 33.14197274   numeric    double   numeric  FALSE
#> 9   DV4     0    0  0   6480   0   0 6480  6480    40  39.99  1.01 36.48240015 43.74431445   numeric    double   numeric  FALSE
#> 
r1 <- report_factorial_anova(
  df = df, wid = "id", dv = c("DV1", "DV2"),
  within = c("IV1", "IV2"), within_full = c("IV1", "IV2"),
  between = NULL,
  within_covariates = NULL, between_covariates = NULL,
  file = "anova_within",
  post_hoc_test = TRUE
)
#> Warning: Collapsing data to cell means first using variables supplied to "within_full", then collapsing the resulting means to means for the cells supplied to "within".
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> Warning: Collapsing data to cell means first using variables supplied to "within_full", then collapsing the resulting means to means for the cells supplied to "within".
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
r2 <- report_factorial_anova(
  df = df, wid = "id", dv = c("DV1", "DV2"),
  within = NULL, within_full = NULL,
  between = c("IV1", "IV2"),
  within_covariates = NULL, between_covariates = NULL,
  file = "anova_between",
  post_hoc_test = TRUE
)
#> Warning: The column supplied as the wid variable contains non-unique values across levels of the supplied between-Ss variables. Automatically fixing this by generating unique wid labels.
#> Coefficient covariances computed by hccm()
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
#> Warning: The column supplied as the wid variable contains non-unique values across levels of the supplied between-Ss variables. Automatically fixing this by generating unique wid labels.
#> Coefficient covariances computed by hccm()
#> NOTE: Results may be misleading due to involvement in interactions
#> NOTE: Results may be misleading due to involvement in interactions
r3 <- report_factorial_anova(
  df = df, wid = "id", dv = c("DV1", "DV2"),
  within = c("IV3", "IV4"), within_full = c("IV3", "IV4"),
  between = c("IV1", "IV2"),
  within_covariates = NULL, between_covariates = NULL,
  file = "anova_mixed",
  post_hoc_test = FALSE
)
#> Warning: The column supplied as the wid variable contains non-unique values across levels of the supplied between-Ss variables. Automatically fixing this by generating unique wid labels.
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
#> Warning: The column supplied as the wid variable contains non-unique values across levels of the supplied between-Ss variables. Automatically fixing this by generating unique wid labels.
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
r4 <- report_factorial_anova(
  df = df, wid = "id", dv = c("DV1", "DV2"),
  within = c("IV1", "IV2"), within_full = c("IV1", "IV2"),
  between = NULL,
  within_covariates = c("DV3", "DV4"), between_covariates = NULL,
  file = "anova_within_cov",
  post_hoc_test = TRUE
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
