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
#>           X1       X2       X3     X4       X5        X6      X7        X8       X9       X10
#> X1   1.00000 0.501313  0.18534 0.2085  0.28956  0.656319 -0.4672  0.013719  0.33169  0.184808
#> X2   0.50131 1.000000  0.68518 0.6994  0.48664  0.261138  0.3809  0.623548  0.23253  0.005517
#> X3   0.18534 0.685175  1.00000 0.4973 -0.01293  0.235015  0.2830  0.546300  0.02318  0.010423
#> X4   0.20849 0.699366  0.49726 1.0000  0.46257  0.302368  0.5124  0.379016  0.51796  0.398845
#> X5   0.28956 0.486644 -0.01293 0.4626  1.00000  0.035975  0.1090  0.191652  0.60877  0.564674
#> X6   0.65632 0.261138  0.23502 0.3024  0.03598  1.000000 -0.1892  0.009213 -0.02515  0.169000
#> X7  -0.46716 0.380943  0.28302 0.5124  0.10900 -0.189245  1.0000  0.424804 -0.24659 -0.212387
#> X8   0.01372 0.623548  0.54630 0.3790  0.19165  0.009213  0.4248  1.000000 -0.03675 -0.102624
#> X9   0.33169 0.232525  0.02318 0.5180  0.60877 -0.025150 -0.2466 -0.036749  1.00000  0.826173
#> X10  0.18481 0.005517  0.01042 0.3988  0.56467  0.169000 -0.2124 -0.102624  0.82617  1.000000
stats::cor(simulate_correlation_from_sample(correlation_matrix, nrows = 1000))
#>           X1        X2        X3     X4       X5        X6      X7        X8        X9       X10
#> X1   1.00000  0.493669  0.160123 0.1999  0.25744  0.680922 -0.4589 -0.020351  0.293018  0.152481
#> X2   0.49367  1.000000  0.655774 0.6800  0.49772  0.274126  0.3972  0.613251  0.198621 -0.009008
#> X3   0.16012  0.655774  1.000000 0.4639 -0.05706  0.206178  0.2718  0.534532  0.008559  0.003358
#> X4   0.19987  0.679960  0.463923 1.0000  0.46502  0.311661  0.5054  0.349074  0.530576  0.423643
#> X5   0.25744  0.497719 -0.057058 0.4650  1.00000  0.051560  0.1818  0.216763  0.543877  0.513025
#> X6   0.68092  0.274126  0.206178 0.3117  0.05156  1.000000 -0.1952 -0.006396 -0.018584  0.168652
#> X7  -0.45887  0.397238  0.271759 0.5054  0.18175 -0.195250  1.0000  0.448342 -0.231816 -0.180375
#> X8  -0.02035  0.613251  0.534532 0.3491  0.21676 -0.006396  0.4483  1.000000 -0.074030 -0.109761
#> X9   0.29302  0.198621  0.008559 0.5306  0.54388 -0.018584 -0.2318 -0.074030  1.000000  0.824695
#> X10  0.15248 -0.009008  0.003358 0.4236  0.51302  0.168652 -0.1804 -0.109761  0.824695  1.000000
```
