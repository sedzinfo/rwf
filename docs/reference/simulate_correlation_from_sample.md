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
#>           X1      X2       X3      X4       X5       X6       X7       X8        X9     X10
#> X1   1.00000  0.1485 -0.05258  0.5330  0.33485 0.472075  0.58372 -0.06751  0.080628  0.1404
#> X2   0.14852  1.0000 -0.23079  0.2616 -0.37314 0.102541  0.42390  0.11398  0.295923  0.5047
#> X3  -0.05258 -0.2308  1.00000  0.4943  0.08123 0.513299 -0.04967  0.12414 -0.254189  0.1011
#> X4   0.53300  0.2616  0.49434  1.0000 -0.14532 0.645254  0.13366  0.14151 -0.310712  0.4837
#> X5   0.33485 -0.3731  0.08123 -0.1453  1.00000 0.375467  0.36076  0.45171 -0.096154 -0.2766
#> X6   0.47207  0.1025  0.51330  0.6453  0.37547 1.000000  0.49805  0.36554  0.007535  0.2149
#> X7   0.58372  0.4239 -0.04967  0.1337  0.36076 0.498052  1.00000 -0.06948  0.562107 -0.1225
#> X8  -0.06751  0.1140  0.12414  0.1415  0.45171 0.365541 -0.06948  1.00000 -0.603866  0.5449
#> X9   0.08063  0.2959 -0.25419 -0.3107 -0.09615 0.007535  0.56211 -0.60387  1.000000 -0.4262
#> X10  0.14041  0.5047  0.10106  0.4837 -0.27664 0.214870 -0.12249  0.54485 -0.426195  1.0000
stats::cor(simulate_correlation_from_sample(correlation_matrix, nrows = 1000))
#>           X1       X2       X3      X4       X5      X6       X7       X8       X9      X10
#> X1   1.00000  0.15324 -0.06249  0.5136  0.37135 0.52650  0.65216 -0.04764  0.12209  0.07357
#> X2   0.15324  1.00000 -0.24084  0.3009 -0.38683 0.09499  0.39286  0.12229  0.27784  0.54079
#> X3  -0.06249 -0.24084  1.00000  0.4786  0.08436 0.48757 -0.06091  0.11623 -0.26339  0.07826
#> X4   0.51364  0.30091  0.47858  1.0000 -0.13784 0.64527  0.17756  0.15600 -0.29311  0.45605
#> X5   0.37135 -0.38683  0.08436 -0.1378  1.00000 0.40908  0.37785  0.44335 -0.07806 -0.31275
#> X6   0.52650  0.09499  0.48757  0.6453  0.40908 1.00000  0.54828  0.34154  0.02938  0.15144
#> X7   0.65216  0.39286 -0.06091  0.1776  0.37785 0.54828  1.00000 -0.07386  0.55841 -0.14224
#> X8  -0.04764  0.12229  0.11623  0.1560  0.44335 0.34154 -0.07386  1.00000 -0.61139  0.54715
#> X9   0.12209  0.27784 -0.26339 -0.2931 -0.07806 0.02938  0.55841 -0.61139  1.00000 -0.42086
#> X10  0.07357  0.54079  0.07826  0.4561 -0.31275 0.15144 -0.14224  0.54715 -0.42086  1.00000
```
