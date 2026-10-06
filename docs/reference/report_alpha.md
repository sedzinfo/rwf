# Cronbach's alpha reliability report for multiple scales

Computes Cronbach's alpha and a comprehensive set of item-level
reliability statistics for one or more scales using
[`psych::alpha()`](https://rdrr.io/pkg/psych/man/alpha.html). Supports
item reversal, bootstrap confidence intervals, and optional Excel
export. Scales are classified by their alpha value (Unacceptable \<
0.60, Acceptable 0.60–0.70, Good and Acceptable 0.70–0.80, Good
0.80–0.90, Excellent \> 0.90).

## Usage

``` r
report_alpha(
  df,
  key = NULL,
  questions = NULL,
  reverse = NULL,
  mini = NULL,
  maxi = NULL,
  file = NULL,
  ...
)
```

## Arguments

- df:

  A data frame containing all item columns.

- key:

  A named list where each name is a scale label and each element is a
  character vector of item column names belonging to that scale, e.g.
  `list(f1 = c("X1","X2","X3"))`. When `NULL` (default) all columns in
  `df` are treated as a single scale named `"dimension"`.

- questions:

  A named list (same structure as `key`) of question label strings to
  append to item names in the output tables. When `NULL` (default) only
  column names are used.

- reverse:

  A named list (same structure as `key`) of numeric sign vectors (`1` =
  keep, `-1` = reverse) passed to
  [`psych::reverse.code()`](https://rdrr.io/pkg/psych/man/reverse.code.html).
  When `NULL` (default) no reversal is applied.

- mini:

  Numeric scalar specifying the minimum possible scale rating used for
  item reversal. When `NULL` (default) the empirical minimum is used.

- maxi:

  Numeric scalar specifying the maximum possible scale rating used for
  item reversal. When `NULL` (default) the empirical maximum is used.

- file:

  Character string naming the output Excel file (without extension).
  When `NULL` (default) no file is written. The workbook contains four
  sheets: total statistics, bootstrap CIs (if requested), item
  statistics, and alpha-if-item-removed.

- ...:

  Additional arguments passed to
  [`psych::alpha()`](https://rdrr.io/pkg/psych/man/alpha.html), such as
  `cumulative`, `n.iter` (bootstrap iterations), or `check.keys`.

## Value

A named list with the following elements:

- result_total:

  Scale-level statistics including raw alpha, standardised alpha,
  Guttman's Lambda 6, average inter-item correlation, signal-to-noise
  ratio, mean, SD, Kaiser criterion, and alpha classification.

- result_boot:

  Bootstrap confidence intervals for alpha (only populated when
  `n.iter > 1` is passed via `...`).

- result_item_statistics:

  Item-level statistics including corrected and uncorrected item-total
  correlations, item mean and SD, and response frequencies.

- result_dropped:

  Alpha-if-item-removed statistics for each item within each scale.

## Examples

``` r
set.seed(12345)
df <- data.frame(matrix(.5, ncol = 6, nrow = 6))
correlation_martix <- as.matrix(df)
diag(correlation_martix) <- 1
df <- round(generate_correlation_matrix(correlation_martix, nrows = 1000), 0) + 5
key <- list(
  f1 = c("X1", "X2", "X3"),
  f2 = c("X4", "X5", "X6")
)
reverse <- list(
  f1 = c(1, 1, 1),
  f2 = c(1, 1, 1)
)
report_alpha(df = df, key = key, cumulative = TRUE, n.iter = 1)
#>   |                                                                                                                                                                                                      |                                                                                                                                                                                              |   0%  |                                                                                                                                                                                                      |==============================================================================================================================================================================================| 100%
#> $result_total
#>   dimension items kaiser_criterion raw_alpha std_alpha g6(smc) average_r   s/n     ase  mean    sd median_r     alpha_criterion
#> 1        f1     3                1    0.7248    0.7246  0.6381    0.4673 2.632 0.01506 15.07 2.520   0.4513 Good and Acceptable
#> 2        f2     3                1    0.7094    0.7093  0.6203    0.4486 2.440 0.01592 14.97 2.439   0.4452 Good and Acceptable
#> 
#> $result_boot
#> data frame with 0 columns and 0 rows
#> 
#> $result_item_statistics
#>   dimension question raw_alpha    n  raw_r  std_r  r_cor r_drop  mean    sd     1     2     3     4     5     6     7     8     9 miss
#> 1        f1       X1    0.7248 1000 0.7837 0.7887 0.6078 0.5192 5.014 1.024 0.001 0.002 0.067 0.225 0.387 0.257 0.057 0.004 0.000    0
#> 2        f1       X2    0.7248 1000 0.8117 0.8108 0.6596 0.5606 5.035 1.049 0.000 0.010 0.053 0.234 0.372 0.262 0.065 0.003 0.001    0
#> 3        f1       X3    0.7248 1000 0.8136 0.8097 0.6570 0.5583 5.025 1.065 0.000 0.004 0.066 0.229 0.393 0.231 0.064 0.013 0.000    0
#> 4        f2       X4    0.7094 1000 0.7820 0.7833 0.5985 0.5053 4.988 1.017    NA 0.006 0.053 0.254 0.389 0.236 0.056 0.006    NA    0
#> 5        f2       X5    0.7094 1000 0.7983 0.7966 0.6300 0.5297 5.018 1.030    NA 0.006 0.052 0.246 0.388 0.235 0.068 0.005    NA    0
#> 6        f2       X6    0.7094 1000 0.8053 0.8058 0.6504 0.5467 4.961 1.020    NA 0.008 0.060 0.243 0.403 0.231 0.048 0.007    NA    0
#> 
#> $result_dropped
#>   dimension question scale_alpha raw_alpha std_alpha g6(smc) average_r   s/n alpha se var_r  med_r
#> 1        f1       X1      0.7248    0.6683    0.6684  0.5019    0.5019 2.015  0.02097    NA 0.5019
#> 2        f1       X2      0.7248    0.6190    0.6194  0.4486    0.4486 1.627  0.02407    NA 0.4486
#> 3        f1       X3      0.7248    0.6218    0.6220  0.4513    0.4513 1.645  0.02391    NA 0.4513
#> 4        f2       X4      0.7094    0.6460    0.6460  0.4771    0.4771 1.825  0.02239    NA 0.4771
#> 5        f2       X5      0.7094    0.6161    0.6161  0.4452    0.4452 1.605  0.02428    NA 0.4452
#> 6        f2       X6      0.7094    0.5949    0.5950  0.4234    0.4234 1.469  0.02562    NA 0.4234
#> 
report_alpha(df = df, key = key, reverse = reverse, check.keys = FALSE, n.iter = 2)
#>   |                                                                                                                                                                                                      |                                                                                                                                                                                              |   0%  |                                                                                                                                                                                                      |==============================================================================================================================================================================================| 100%
#> $result_total
#>   dimension items kaiser_criterion raw_alpha std_alpha g6(smc) average_r   s/n     ase  mean     sd median_r boot_ci_2_5% boot_ci_50% boot_ci_97_5%     alpha_criterion
#> 1        f1     3                1    0.7248    0.7246  0.6381    0.4673 2.632 0.01506 5.025 0.8402   0.4513       0.7257      0.7378        0.7500 Good and Acceptable
#> 2        f2     3                1    0.7094    0.7093  0.6203    0.4486 2.440 0.01592 4.989 0.8131   0.4452       0.7046      0.7144        0.7242 Good and Acceptable
#> 
#> $result_boot
#>   dimension items kaiser_criterion raw_alpha std_alpha g6(smc) average_r   s/n    ase unidim goodfit    var_r median_r
#> 1        f1     3                1    0.7506    0.7503  0.6701    0.5004 3.004 0.1863 0.8319  0.9938 0.002319   0.5038
#> 2        f1     3                1    0.7251    0.7248  0.6412    0.4674 2.633 0.2268 0.8001  0.9922 0.003353   0.4496
#> 3        f2     3                1    0.7247    0.7246  0.6392    0.4673 2.631 0.2272 0.8011  0.9959 0.001771   0.4730
#> 4        f2     3                1    0.7041    0.7040  0.6145    0.4422 2.378 0.2623 0.7756  0.9978 0.001035   0.4312
#> 
#> $result_item_statistics
#>   dimension question raw_alpha    n  raw_r  std_r  r_cor r_drop  mean    sd     1     2     3     4     5     6     7     8     9 miss
#> 1        f1       X1    0.7248 1000 0.7837 0.7887 0.6078 0.5192 5.014 1.024 0.001 0.002 0.067 0.225 0.387 0.257 0.057 0.004 0.000    0
#> 2        f1       X2    0.7248 1000 0.8117 0.8108 0.6596 0.5606 5.035 1.049 0.000 0.010 0.053 0.234 0.372 0.262 0.065 0.003 0.001    0
#> 3        f1       X3    0.7248 1000 0.8136 0.8097 0.6570 0.5583 5.025 1.065 0.000 0.004 0.066 0.229 0.393 0.231 0.064 0.013 0.000    0
#> 4        f2       X4    0.7094 1000 0.7820 0.7833 0.5985 0.5053 4.988 1.017    NA 0.006 0.053 0.254 0.389 0.236 0.056 0.006    NA    0
#> 5        f2       X5    0.7094 1000 0.7983 0.7966 0.6300 0.5297 5.018 1.030    NA 0.006 0.052 0.246 0.388 0.235 0.068 0.005    NA    0
#> 6        f2       X6    0.7094 1000 0.8053 0.8058 0.6504 0.5467 4.961 1.020    NA 0.008 0.060 0.243 0.403 0.231 0.048 0.007    NA    0
#> 
#> $result_dropped
#>   dimension question scale_alpha raw_alpha std_alpha g6(smc) average_r   s/n alpha se var_r  med_r
#> 1        f1       X1      0.7248    0.6683    0.6684  0.5019    0.5019 2.015  0.02097    NA 0.5019
#> 2        f1       X2      0.7248    0.6190    0.6194  0.4486    0.4486 1.627  0.02407    NA 0.4486
#> 3        f1       X3      0.7248    0.6218    0.6220  0.4513    0.4513 1.645  0.02391    NA 0.4513
#> 4        f2       X4      0.7094    0.6460    0.6460  0.4771    0.4771 1.825  0.02239    NA 0.4771
#> 5        f2       X5      0.7094    0.6161    0.6161  0.4452    0.4452 1.605  0.02428    NA 0.4452
#> 6        f2       X6      0.7094    0.5949    0.5950  0.4234    0.4234 1.469  0.02562    NA 0.4234
#> 
report_alpha(df = df, key = key, check.keys = FALSE, n.iter = 2, file = "alpha")
#>   |                                                                                                                                                                                                      |                                                                                                                                                                                              |   0%  |                                                                                                                                                                                                      |==============================================================================================================================================================================================| 100%
#> $result_total
#>   dimension items kaiser_criterion raw_alpha std_alpha g6(smc) average_r   s/n     ase  mean     sd median_r boot_ci_2_5% boot_ci_50% boot_ci_97_5%     alpha_criterion
#> 1        f1     3                1    0.7248    0.7246  0.6381    0.4673 2.632 0.01506 5.025 0.8402   0.4513       0.7246      0.7363        0.7481 Good and Acceptable
#> 2        f2     3                1    0.7094    0.7093  0.6203    0.4486 2.440 0.01592 4.989 0.8131   0.4452       0.6824      0.7062        0.7301 Good and Acceptable
#> 
#> $result_boot
#>   dimension items kaiser_criterion raw_alpha std_alpha g6(smc) average_r   s/n    ase unidim goodfit     var_r median_r
#> 1        f1     3                1    0.7487    0.7487  0.6669    0.4982 2.979 0.1895 0.8308  0.9965 0.0013391   0.4979
#> 2        f1     3                1    0.7240    0.7239  0.6372    0.4663 2.621 0.2275 0.8009  0.9979 0.0008828   0.4513
#> 3        f2     3                1    0.6811    0.6814  0.5902    0.4162 2.139 0.3058 0.7454  0.9961 0.0020201   0.3938
#> 4        f2     3                1    0.7313    0.7311  0.6466    0.4754 2.718 0.2163 0.8092  0.9958 0.0017342   0.4690
#> 
#> $result_item_statistics
#>   dimension question raw_alpha    n  raw_r  std_r  r_cor r_drop  mean    sd     1     2     3     4     5     6     7     8     9 miss
#> 1        f1       X1    0.7248 1000 0.7837 0.7887 0.6078 0.5192 5.014 1.024 0.001 0.002 0.067 0.225 0.387 0.257 0.057 0.004 0.000    0
#> 2        f1       X2    0.7248 1000 0.8117 0.8108 0.6596 0.5606 5.035 1.049 0.000 0.010 0.053 0.234 0.372 0.262 0.065 0.003 0.001    0
#> 3        f1       X3    0.7248 1000 0.8136 0.8097 0.6570 0.5583 5.025 1.065 0.000 0.004 0.066 0.229 0.393 0.231 0.064 0.013 0.000    0
#> 4        f2       X4    0.7094 1000 0.7820 0.7833 0.5985 0.5053 4.988 1.017    NA 0.006 0.053 0.254 0.389 0.236 0.056 0.006    NA    0
#> 5        f2       X5    0.7094 1000 0.7983 0.7966 0.6300 0.5297 5.018 1.030    NA 0.006 0.052 0.246 0.388 0.235 0.068 0.005    NA    0
#> 6        f2       X6    0.7094 1000 0.8053 0.8058 0.6504 0.5467 4.961 1.020    NA 0.008 0.060 0.243 0.403 0.231 0.048 0.007    NA    0
#> 
#> $result_dropped
#>   dimension question scale_alpha raw_alpha std_alpha g6(smc) average_r   s/n alpha se var_r  med_r
#> 1        f1       X1      0.7248    0.6683    0.6684  0.5019    0.5019 2.015  0.02097    NA 0.5019
#> 2        f1       X2      0.7248    0.6190    0.6194  0.4486    0.4486 1.627  0.02407    NA 0.4486
#> 3        f1       X3      0.7248    0.6218    0.6220  0.4513    0.4513 1.645  0.02391    NA 0.4513
#> 4        f2       X4      0.7094    0.6460    0.6460  0.4771    0.4771 1.825  0.02239    NA 0.4771
#> 5        f2       X5      0.7094    0.6161    0.6161  0.4452    0.4452 1.605  0.02428    NA 0.4452
#> 6        f2       X6      0.7094    0.5949    0.5950  0.4234    0.4234 1.469  0.02562    NA 0.4234
#> 
```
