# Percentage of outliers at three z-score thresholds

Z-standardises `vector` and counts the percentage of observations whose
absolute z-score exceeds 1.96, 2.58, and 3.29, corresponding
approximately to the 95 %, 99 %, and 99.9 % tails of the normal
distribution. Designed to be applied across columns with `sapply`.

## Usage

``` r
outlier_summary(vector)
```

## Arguments

- vector:

  Numeric vector. Missing values are removed before z-standardisation
  and counts.

## Value

A one-row data frame with three character columns:

- abs_z_1.96:

  Percentage of observations with \\\|z\| \ge 1.96\\.

- abs_z_2.58:

  Percentage of observations with \\\|z\| \ge 2.58\\.

- abs_z_3.29:

  Percentage of observations with \\\|z\| \ge 3.29\\.

## Examples

``` r
vector <- generate_missing(rnorm(1000), missing = 10)
df <- generate_missing(mtcars[, 1:2], missing = 10)
outlier_summary(vector)
#>   abs_z_1.96 abs_z_2.58 abs_z_3.29
#> 1     4.85 %     0.81 %      0.1 %
data.frame(sapply(mtcars, outlier_summary))
#>               mpg cyl disp     hp   drat     wt   qsec  vs  am gear   carb
#> abs_z_1.96 6.25 % 0 %  0 % 3.12 % 3.12 % 9.38 % 3.12 % 0 % 0 %  0 % 6.25 %
#> abs_z_2.58    0 % 0 %  0 % 3.12 %    0 %    0 % 3.12 % 0 % 0 %  0 % 3.12 %
#> abs_z_3.29    0 % 0 %  0 %    0 %    0 %    0 %    0 % 0 % 0 %  0 %    0 %
```
