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

  Arguments passed on to
  [`stats::t.test`](https://rdrr.io/r/stats/t.test.html)

  `x`

  : a (non-empty) numeric vector of data values.

  `y`

  : an optional (non-empty) numeric vector of data values.

  `alternative`

  : a character string specifying the alternative hypothesis, must be
    one of `"two.sided"` (default), `"greater"` or `"less"`. You can
    specify just the initial letter.

  `mu`

  : a number indicating the true value of the mean (or difference in
    means if you are performing a two sample test).

  `paired`

  : a logical indicating whether you want a paired t-test.

  `var.equal`

  : a logical variable indicating whether to treat the two variances as
    being equal. If `TRUE` then the pooled variance is used to estimate
    the variance otherwise the Welch (or Satterthwaite) approximation to
    the degrees of freedom is used.

  `conf.level`

  : confidence level of the interval.

  `formula`

  : a formula of the form `lhs ~ rhs` where `lhs` is a numeric variable
    giving the data values and `rhs` either `1` for a one-sample or
    paired test or a factor with two levels giving the corresponding
    groups. If `lhs` is of class
    `"`[`Pair`](https://rdrr.io/r/stats/Pair.html)`"` and `rhs` is `1`,
    a paired test is done, see Examples.

  `data`

  : an optional matrix or data frame (or similar: see
    [`model.frame`](https://rdrr.io/r/stats/model.frame.html))
    containing the variables in the formula `formula`. By default the
    variables are taken from `environment(formula)`.

  `subset`

  : an optional vector specifying a subset of observations to be used.

  `na.action`

  : a function which indicates what should happen when the data contain
    [`NA`](https://rdrr.io/r/base/NA.html)s.

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

- significant: Logical-like character flag (TRUE/FALSE) indicating
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
#>    DV        IV level1 level2 n1 n2      t    df        p   CI_l   CI_u alternative                  method mean1 mean2   sd1   sd2 sd_pooled      d      r k_squared[bartlett] df[bartlett]
#> 1 sex bp_before   Male Female 60 60 -2.785 117.6 0.006244 -9.639 -1.627   two.sided Welch Two Sample t-test 159.3 153.6 11.41 10.74     11.08 0.5084 0.1128              0.2192            1
#>   p[bartlett] bonferroni_p significant
#> 1      0.6397         0.05        TRUE
report_ttests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2:3
)
#>       DV        IV level1 level2 n1 n2      t     df           p    CI_l   CI_u alternative                  method mean1 mean2    sd1   sd2 sd_pooled      d       r k_squared[bartlett] df[bartlett]
#> 1    sex bp_before   Male Female 60 60 -2.785 117.56 0.006244127  -9.639 -1.627   two.sided Welch Two Sample t-test 159.3 153.6 11.413 10.74     11.08 0.5084 0.11277              0.2192            1
#> 2 agegrp bp_before  30-45  46-59 40 40 -1.470  74.70 0.145662357  -8.066  1.216   two.sided Welch Two Sample t-test 151.7 155.1  9.258 11.46     10.42 0.3288 0.07595              1.7393            1
#> 3 agegrp bp_before  30-45    60+ 40 40 -4.865  76.37 0.000006006 -15.362 -6.438   two.sided Welch Two Sample t-test 151.7 162.6  9.258 10.73     10.02 1.0879 0.21382              0.8322            1
#> 4 agegrp bp_before  46-59    60+ 40 40 -3.012  77.66 0.003503805 -12.416 -2.534   two.sided Welch Two Sample t-test 155.1 162.6 11.460 10.73     11.10 0.6735 0.14410              0.1679            1
#>   p[bartlett] bonferroni_p significant
#> 1      0.6397       0.0125        TRUE
#> 2      0.1872       0.0125       FALSE
#> 3      0.3616       0.0125        TRUE
#> 4      0.6820       0.0125        TRUE
report_ttests(
  df = df_insurance,
  dv = which("charges" == names(df_insurance)),
  iv = c(2, 4)
)
#>          DV      IV level1 level2  n1  n2       t      df           p  CI_l    CI_u alternative                  method mean1 mean2   sd1   sd2 sd_pooled       d        r k_squared[bartlett]
#> 1       sex charges female   male 662 676 -2.1009 1313.36 0.035841015 -2682  -91.86   two.sided Welch Two Sample t-test 12570 13957 11129 12971     12085 0.11478 0.027893             15.5852
#> 2  children charges      0      1 574 324 -0.4418  679.59 0.658783431 -1988 1257.87   two.sided Welch Two Sample t-test 12366 12731 12023 11824     11924 0.03063 0.007014              0.1153
#> 3  children charges      0      3 574 157 -2.7061  243.21 0.007290553 -5165 -813.38   two.sided Welch Two Sample t-test 12366 15355 12023 12331     12178 0.24547 0.039752              0.1576
#> 4  children charges      0      2 574 240 -2.7863  421.22 0.005572108 -4618 -797.51   two.sided Welch Two Sample t-test 12366 15074 12023 12891     12465 0.21722 0.043210              1.6673
#> 5  children charges      0      5 574  18  3.4810   29.20 0.001591976  1477 5682.65   two.sided Welch Two Sample t-test 12366  8786 12023  3808      8918 0.40143 0.011696             23.1372
#> 6  children charges      0      4 574  25 -0.7833   27.75 0.440101809 -5369 2399.63   two.sided Welch Two Sample t-test 12366 13851 12023  9139     10679 0.13903 0.005530              2.9046
#> 7  children charges      1      3 324 157 -2.2178  297.45 0.027320507 -4953 -295.65   two.sided Welch Two Sample t-test 12731 15355 11824 12331     12080 0.21723 0.045584              0.3739
#> 8  children charges      1      2 324 240 -2.2095  489.12 0.027603430 -4425 -259.38   two.sided Welch Two Sample t-test 12731 15074 11824 12891     12369 0.18938 0.044245              2.0650
#> 9  children charges      1      5 324  18  3.5468   39.48 0.001022814  1696 6194.14   two.sided Welch Two Sample t-test 12731  8786 11824  3808      8784 0.44915 0.021905             22.4877
#> 10 children charges      1      4 324  25 -0.5764   30.56 0.568583875 -5083 2844.15   two.sided Welch Two Sample t-test 12731 13851 11824  9139     10567 0.10594 0.006996              2.5282
#> 11 children charges      3      2 157 240 -0.2186  344.03 0.827073078 -2817 2253.10   two.sided Welch Two Sample t-test 15355 15074 12331 12891     12614 0.02234 0.005312              0.3696
#> 12 children charges      3      5 157  18  4.9318   71.21 0.000005148  3913 9225.11   two.sided Welch Two Sample t-test 15355  8786 12331  3808      9126 0.71987 0.062290             23.3776
#> 13 children charges      3      4 157  25  0.7248   39.42 0.472847187 -2693 5702.20   two.sided Welch Two Sample t-test 15355 13851 12331  9139     10853 0.13864 0.016163              3.1777
#> 14 children charges      2      5 240  18  5.1368   55.84 0.000003684  3835 8739.70   two.sided Welch Two Sample t-test 15074  8786 12891  3808      9505 0.66149 0.041164             24.9594
#> 15 children charges      2      4 240  25  0.6089   34.83 0.546534224 -2855 5300.79   two.sided Welch Two Sample t-test 15074 13851 12891  9139     11174 0.10944 0.009264              4.2347
#> 16 children charges      5      4  18  25  2.4871   34.17 0.017921653   927 9202.28   two.sided Welch Two Sample t-test  8786 13851  3808  9139      7001 0.72341 0.149703             12.2513
#>    df[bartlett]  p[bartlett] bonferroni_p significant
#> 1             1 0.0000788678     0.003125       FALSE
#> 2             1 0.7341451329     0.003125       FALSE
#> 3             1 0.6913522564     0.003125       FALSE
#> 4             1 0.1966253499     0.003125       FALSE
#> 5             1 0.0000015084     0.003125        TRUE
#> 6             1 0.0883267624     0.003125       FALSE
#> 7             1 0.5409114605     0.003125       FALSE
#> 8             1 0.1507142694     0.003125       FALSE
#> 9             1 0.0000021149     0.003125        TRUE
#> 10            1 0.1118298401     0.003125       FALSE
#> 11            1 0.5432189483     0.003125       FALSE
#> 12            1 0.0000013312     0.003125        TRUE
#> 13            1 0.0746510253     0.003125       FALSE
#> 14            1 0.0000005855     0.003125        TRUE
#> 15            1 0.0396047045     0.003125       FALSE
#> 16            1 0.0004649248     0.003125       FALSE
report_ttests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2:3,
  alternative = "two.sided"
)
#>       DV        IV level1 level2 n1 n2      t     df           p    CI_l   CI_u alternative                  method mean1 mean2    sd1   sd2 sd_pooled      d       r k_squared[bartlett] df[bartlett]
#> 1    sex bp_before   Male Female 60 60 -2.785 117.56 0.006244127  -9.639 -1.627   two.sided Welch Two Sample t-test 159.3 153.6 11.413 10.74     11.08 0.5084 0.11277              0.2192            1
#> 2 agegrp bp_before  30-45  46-59 40 40 -1.470  74.70 0.145662357  -8.066  1.216   two.sided Welch Two Sample t-test 151.7 155.1  9.258 11.46     10.42 0.3288 0.07595              1.7393            1
#> 3 agegrp bp_before  30-45    60+ 40 40 -4.865  76.37 0.000006006 -15.362 -6.438   two.sided Welch Two Sample t-test 151.7 162.6  9.258 10.73     10.02 1.0879 0.21382              0.8322            1
#> 4 agegrp bp_before  46-59    60+ 40 40 -3.012  77.66 0.003503805 -12.416 -2.534   two.sided Welch Two Sample t-test 155.1 162.6 11.460 10.73     11.10 0.6735 0.14410              0.1679            1
#>   p[bartlett] bonferroni_p significant
#> 1      0.6397       0.0125        TRUE
#> 2      0.1872       0.0125       FALSE
#> 3      0.3616       0.0125        TRUE
#> 4      0.6820       0.0125        TRUE
report_ttests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2:3,
  alternative = "less"
)
#>       DV        IV level1 level2 n1 n2      t     df           p CI_l    CI_u alternative                  method mean1 mean2    sd1   sd2 sd_pooled      d       r k_squared[bartlett] df[bartlett]
#> 1    sex bp_before   Male Female 60 60 -2.785 117.56 0.003122063 -Inf -2.2796        less Welch Two Sample t-test 159.3 153.6 11.413 10.74     11.08 0.5084 0.11277              0.2192            1
#> 2 agegrp bp_before  30-45  46-59 40 40 -1.470  74.70 0.072831179 -Inf  0.4546        less Welch Two Sample t-test 151.7 155.1  9.258 11.46     10.42 0.3288 0.07595              1.7393            1
#> 3 agegrp bp_before  30-45    60+ 40 40 -4.865  76.37 0.000003003 -Inf -7.1695        less Welch Two Sample t-test 151.7 162.6  9.258 10.73     10.02 1.0879 0.21382              0.8322            1
#> 4 agegrp bp_before  46-59    60+ 40 40 -3.012  77.66 0.001751902 -Inf -3.3433        less Welch Two Sample t-test 155.1 162.6 11.460 10.73     11.10 0.6735 0.14410              0.1679            1
#>   p[bartlett] bonferroni_p significant
#> 1      0.6397       0.0125        TRUE
#> 2      0.1872       0.0125       FALSE
#> 3      0.3616       0.0125        TRUE
#> 4      0.6820       0.0125        TRUE
report_ttests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2:3,
  alternative = "greater"
)
#>       DV        IV level1 level2 n1 n2      t     df      p    CI_l CI_u alternative                  method mean1 mean2    sd1   sd2 sd_pooled      d       r k_squared[bartlett] df[bartlett]
#> 1    sex bp_before   Male Female 60 60 -2.785 117.56 0.9969  -8.987  Inf     greater Welch Two Sample t-test 159.3 153.6 11.413 10.74     11.08 0.5084 0.11277              0.2192            1
#> 2 agegrp bp_before  30-45  46-59 40 40 -1.470  74.70 0.9272  -7.305  Inf     greater Welch Two Sample t-test 151.7 155.1  9.258 11.46     10.42 0.3288 0.07595              1.7393            1
#> 3 agegrp bp_before  30-45    60+ 40 40 -4.865  76.37 1.0000 -14.630  Inf     greater Welch Two Sample t-test 151.7 162.6  9.258 10.73     10.02 1.0879 0.21382              0.8322            1
#> 4 agegrp bp_before  46-59    60+ 40 40 -3.012  77.66 0.9982 -11.607  Inf     greater Welch Two Sample t-test 155.1 162.6 11.460 10.73     11.10 0.6735 0.14410              0.1679            1
#>   p[bartlett] bonferroni_p significant
#> 1      0.6397       0.0125       FALSE
#> 2      0.1872       0.0125       FALSE
#> 3      0.3616       0.0125       FALSE
#> 4      0.6820       0.0125       FALSE
report_ttests(
  df = df_blood_pressure,
  dv = which("bp_before" == names(df_blood_pressure)),
  iv = 2:3,
  var.equal = TRUE,
  file = "ttest"
)
#>       DV        IV level1 level2 n1 n2      t  df           p    CI_l   CI_u alternative             method mean1 mean2    sd1   sd2 sd_pooled      d       r k_squared[bartlett] df[bartlett]
#> 1    sex bp_before   Male Female 60 60 -2.785 118 0.006240699  -9.639 -1.628   two.sided  Two Sample t-test 159.3 153.6 11.413 10.74     11.08 0.5084 0.11277              0.2192            1
#> 2 agegrp bp_before  30-45  46-59 40 40 -1.470  78 0.145485221  -8.062  1.212   two.sided  Two Sample t-test 151.7 155.1  9.258 11.46     10.42 0.3288 0.07595              1.7393            1
#> 3 agegrp bp_before  30-45    60+ 40 40 -4.865  78 0.000005833 -15.360 -6.440   two.sided  Two Sample t-test 151.7 162.6  9.258 10.73     10.02 1.0879 0.21382              0.8322            1
#> 4 agegrp bp_before  46-59    60+ 40 40 -3.012  78 0.003499571 -12.416 -2.534   two.sided  Two Sample t-test 155.1 162.6 11.460 10.73     11.10 0.6735 0.14410              0.1679            1
#>   p[bartlett] bonferroni_p significant
#> 1      0.6397       0.0125        TRUE
#> 2      0.1872       0.0125       FALSE
#> 3      0.3616       0.0125        TRUE
#> 4      0.6820       0.0125        TRUE
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
#>    DV        IV level1 level2 n1 n2      t    df        p   CI_l   CI_u alternative                  method mean1 mean2   sd1   sd2 sd_pooled      d      r k_squared[bartlett] df[bartlett]
#> 1 sex bp_before   Male Female 60 60 -2.785 117.6 0.006244 -9.639 -1.627   two.sided Welch Two Sample t-test 159.3 153.6 11.41 10.74     11.08 0.5084 0.1128              0.2192            1
#>   p[bartlett] bonferroni_p significant
#> 1      0.6397         0.05        TRUE
report_ttests(
  df = df_blood_pressure,
  dv = which("bp_after" == names(df_blood_pressure)),
  iv = 2
)
#>    DV       IV level1 level2 n1 n2      t    df        p   CI_l   CI_u alternative                  method mean1 mean2   sd1   sd2 sd_pooled      d      r k_squared[bartlett] df[bartlett] p[bartlett]
#> 1 sex bp_after   Male Female 60 60 -3.348 110.8 0.001113 -13.24 -3.394   two.sided Welch Two Sample t-test 155.5 147.2 15.24 11.74     13.61 0.6112 0.1326               3.938            1     0.04721
#>   bonferroni_p significant
#> 1         0.05        TRUE
```
