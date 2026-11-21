# Simulate data preserving the correlation structure of an input data frame

Estimates the covariance matrix and column means from the input data,
then draws multivariate normal samples that reproduce the same
correlation structure.

## Usage

``` r
simulate_correlation_from_sample(cordata, nrows = 10)
```

## Arguments

- cordata:

  A numeric data frame or matrix. The source data from which the
  covariance matrix and means are estimated. Missing values are handled
  pairwise.

- nrows:

  Integer. Number of observations to simulate. Default is `10`.

## Value

A data frame with `nrows` rows and the same number of columns as
`cordata`, containing simulated values with matching correlation
structure.

## Details

Uses `mvrnorm` to draw from a multivariate normal distribution
parameterised by the sample covariance matrix and column means of
`cordata`. Accuracy of the reproduced correlations improves with larger
`nrows`.

## See also

[`generate_correlation_matrix`](https://sedzinfo.github.io/rwf/reference/generate_correlation_matrix.md)

## Examples

``` r
correlation_matrix <- generate_correlation_matrix()
stats::cor(correlation_matrix)
#>           X1       X2      X3       X4      X5       X6       X7       X8       X9      X10
#> X1   1.00000  0.42524 -0.1624 -0.11568 -0.1853  0.11371  0.57403 -0.11195 -0.35707 -0.06984
#> X2   0.42524  1.00000  0.5123  0.19084  0.2189  0.32674  0.68603 -0.44372  0.01034  0.33806
#> X3  -0.16244  0.51229  1.0000  0.66649  0.6681  0.44393  0.28147  0.31962  0.57028  0.17924
#> X4  -0.11568  0.19084  0.6665  1.00000  0.4583 -0.06459  0.24619  0.23092  0.50559 -0.02670
#> X5  -0.18528  0.21894  0.6681  0.45826  1.0000  0.42231  0.32616  0.46044  0.28250  0.48575
#> X6   0.11371  0.32674  0.4439 -0.06459  0.4223  1.00000  0.10400  0.06734  0.11160  0.58795
#> X7   0.57403  0.68603  0.2815  0.24619  0.3262  0.10400  1.00000 -0.13950  0.03057  0.00252
#> X8  -0.11195 -0.44372  0.3196  0.23092  0.4604  0.06734 -0.13950  1.00000  0.34725 -0.32021
#> X9  -0.35707  0.01034  0.5703  0.50559  0.2825  0.11160  0.03057  0.34725  1.00000 -0.13824
#> X10 -0.06984  0.33806  0.1792 -0.02670  0.4857  0.58795  0.00252 -0.32021 -0.13824  1.00000
stats::cor(simulate_correlation_from_sample(correlation_matrix, nrows = 1000))
#>           X1       X2      X3       X4      X5       X6        X7       X8       X9       X10
#> X1   1.00000  0.36551 -0.1903 -0.12759 -0.1709  0.09182  0.577645 -0.06907 -0.33211 -0.096863
#> X2   0.36551  1.00000  0.5236  0.14503  0.2068  0.33619  0.655685 -0.45439  0.04868  0.321727
#> X3  -0.19027  0.52363  1.0000  0.64149  0.6296  0.44439  0.252590  0.29696  0.57837  0.157454
#> X4  -0.12759  0.14503  0.6415  1.00000  0.4387 -0.08653  0.207818  0.26357  0.48562 -0.062635
#> X5  -0.17094  0.20677  0.6296  0.43871  1.0000  0.43306  0.339248  0.44374  0.26100  0.498014
#> X6   0.09182  0.33619  0.4444 -0.08653  0.4331  1.00000  0.103220  0.04901  0.09876  0.596333
#> X7   0.57764  0.65568  0.2526  0.20782  0.3392  0.10322  1.000000 -0.11827  0.03347  0.002458
#> X8  -0.06907 -0.45439  0.2970  0.26357  0.4437  0.04901 -0.118265  1.00000  0.34895 -0.330694
#> X9  -0.33211  0.04868  0.5784  0.48562  0.2610  0.09876  0.033465  0.34895  1.00000 -0.156581
#> X10 -0.09686  0.32173  0.1575 -0.06263  0.4980  0.59633  0.002458 -0.33069 -0.15658  1.000000
```
