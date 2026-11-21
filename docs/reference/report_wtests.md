# Run Pairwise Wilcoxon Tests and Return a Reporting Table

Performs Wilcoxon rank-sum tests for each selected dependent variable
against each selected independent variable, across all pairwise level
combinations of the independent variable. Also computes descriptive
statistics, effect sizes, Bartlett homogeneity results, and Bonferroni
adjustment.

In simple terms: this function builds a full nonparametric comparison
table, similar to report_ttests, but using wilcox.test for group
differences.

## Usage

``` r
report_wtests(df, dv, iv, file = NULL, ...)
```

## Arguments

- df:

  A data frame containing both the independent and dependent variables.

- dv:

  Integer vector of column indices for the continuous dependent
  variables.

- iv:

  Integer vector of column indices for the categorical independent
  variables.

- file:

  output filename

- ...:

  Further arguments passed to
  [`stats::wilcox.test()`](https://rdrr.io/r/stats/wilcox.test.html) for
  every comparison, e.g. `alternative`, `mu`, `exact` or `correct`. The
  formula and data are built by the function and `conf.int = TRUE` is
  always used, so do not pass `x`, `y`, `formula`, `data`, `paired` or
  `conf.int`.

## Value

A data frame where each row is one pairwise level comparison for one
dependent-independent variable combination. Returned columns mean:

- DV: Name stored in the DV column by the current implementation. Note:
  this currently contains the independent variable name.

- IV: Name stored in the IV column by the current implementation. Note:
  this currently contains the dependent variable name.

- level1: First group level being compared.

- level2: Second group level being compared.

- n1: Sample size in level1.

- n2: Sample size in level2.

- W: Wilcoxon test statistic from wilcox.test.

- p: p-value from wilcox.test.

- CI_l: Lower confidence interval bound from wilcox.test.

- CI_u: Upper confidence interval bound from wilcox.test.

- alternative: Alternative hypothesis used by wilcox.test.

- method: Test label from wilcox.test.

- mean1: Mean of the dependent variable in level1.

- mean2: Mean of the dependent variable in level2.

- sd1: Standard deviation in level1.

- sd2: Standard deviation in level2.

- sd_pooled: Pooled standard deviation, sqrt((sd1^2 + sd2^2) / 2).

- d: Cohen d effect size, abs(mean2 - mean1) / sd_pooled.

- r: Wilcoxon effect size from compute_wilcoxon_effect_size.

- k_squared\[bartlett\]: Bartlett test statistic for equal variances.

- df\[bartlett\]: Degrees of freedom of Bartlett test.

- p\[bartlett\]: p-value of Bartlett test. Small values suggest
  heteroscedasticity.

- bonferroni_p: Bonferroni-adjusted alpha threshold computed for the
  number of tests in the output table.

- significant: Logical-like character flag (TRUE / FALSE) indicating
  whether p is below bonferroni_p.

## Details

Missing values are removed per analysis pair using complete cases on the
current dependent and independent variables.

For each independent variable, all pairwise level combinations are
tested using utils::combn.

The function calls stats::wilcox.test with conf.int = TRUE and passes
any additional arguments on through ....

The function also calls report_dataframe to generate a formatted report.

## Examples

``` r
report_wtests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2
)
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_wtests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2:3
)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_wtests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2:3,
  alternative = "two.sided"
)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_wtests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2:3,
  alternative = "less"
)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_wtests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2:3,
  alternative = "greater"
)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_wtests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2:3,
  var.equal = TRUE,
  file = file.path(tempdir(), "wilcoxontest")
)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
```
