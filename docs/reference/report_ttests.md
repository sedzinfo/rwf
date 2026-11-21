# Run Pairwise t-tests and Return a Reporting Table

Performs t-tests for each selected dependent variable against each
selected independent variable, across all pairwise level combinations of
the independent variable. Also computes descriptive statistics, effect
sizes, Bartlett homogeneity test results, and Bonferroni adjustment.

In simple terms: this function creates a full t-test report table you
can export or use in downstream summaries.

## Usage

``` r
report_ttests(df, dv, iv, file = NULL, ...)
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
  [`stats::t.test()`](https://rdrr.io/r/stats/t.test.html) for every
  comparison, for example `alternative`, `mu`, `var.equal` or
  `conf.level`. The formula and data are built by the function, so do
  not pass `x`, `y`, `formula`, `data` or `paired`.

## Value

A data frame where each row is one pairwise group comparison for one
dependent-independent variable combination. Returned columns mean:

- DV: Name stored in the DV column by the current implementation. Note:
  this currently contains the independent variable name.

- IV: Name stored in the IV column by the current implementation. Note:
  this currently contains the dependent variable name.

- level1: First group level being compared.

- level2: Second group level being compared.

- n1: Sample size in level1.

- n2: Sample size in level2.

- t: t statistic from t.test.

- df: Degrees of freedom for the t statistic.

- p: p-value from t.test.

- CI_l: Lower confidence interval bound for the mean difference.

- CI_u: Upper confidence interval bound for the mean difference.

- alternative: Alternative hypothesis used by t.test.

- method: Test label from t.test (for example Welch Two Sample t-test).

- mean1: Mean of the dependent variable in level1.

- mean2: Mean of the dependent variable in level2.

- sd1: Standard deviation in level1.

- sd2: Standard deviation in level2.

- sd_pooled: Pooled standard deviation, sqrt((sd1^2 + sd2^2) / 2).

- d: Cohen d effect size, abs(mean2 - mean1) / sd_pooled.

- r: Effect-size r derived from d using the function formula.

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

The function also calls report_dataframe to generate a formatted report.

## Examples

``` r
report_ttests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2
)
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_ttests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2:3
)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_ttests(
  df = df_insurance,
  dv = which("charges" == names(df_insurance)),
  iv = c(2, 4)
)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_ttests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2:3,
  alternative = "two.sided"
)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_ttests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2:3,
  alternative = "less"
)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_ttests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2:3,
  alternative = "greater"
)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_ttests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2:3,
  var.equal = TRUE,
  file = file.path(tempdir(), "ttest")
)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
effectsize::cohens_d(bp_before ~ sex, data = df_blood_pressure, pooled_sd = TRUE)
#> Cohen's d |         95% CI
#> --------------------------
#> -0.51     | [-0.87, -0.14]
#> 
#> - Estimated using pooled SD.
effectsize::cohens_d(bp_after ~ sex, data = df_blood_pressure, pooled_sd = TRUE)
#> Cohen's d |         95% CI
#> --------------------------
#> -0.61     | [-0.98, -0.24]
#> 
#> - Estimated using pooled SD.
effectsize::hedges_g(bp_before ~ sex, data = df_blood_pressure, pooled_sd = TRUE)
#> Hedges' g |         95% CI
#> --------------------------
#> -0.51     | [-0.87, -0.14]
#> 
#> - Estimated using pooled SD.
effectsize::hedges_g(bp_after ~ sex, data = df_blood_pressure, pooled_sd = TRUE)
#> Hedges' g |         95% CI
#> --------------------------
#> -0.61     | [-0.97, -0.24]
#> 
#> - Estimated using pooled SD.
report_ttests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2
)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_ttests(
  df = df_blood_pressure,
  dv = which("bp_after" == names(df_blood_pressure)),
  iv = 2
)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
```
