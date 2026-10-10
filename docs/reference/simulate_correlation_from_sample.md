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
#>           X1        X2       X3     X4       X5        X6      X7        X8       X9       X10
#> X1   1.00000  0.496014  0.15907 0.2012  0.25810  0.682100 -0.4642 -0.015474  0.29781  0.151853
#> X2   0.49601  1.000000  0.64986 0.6972  0.47445  0.282054  0.3877  0.615765  0.22078 -0.007062
#> X3   0.15907  0.649858  1.00000 0.4654 -0.06816  0.209322  0.2616  0.497973  0.01875  0.012214
#> X4   0.20117  0.697200  0.46541 1.0000  0.47857  0.309343  0.5229  0.348549  0.52604  0.410248
#> X5   0.25810  0.474454 -0.06816 0.4786  1.00000  0.061123  0.1479  0.191050  0.59065  0.544771
#> X6   0.68210  0.282054  0.20932 0.3093  0.06112  1.000000 -0.1910 -0.008972 -0.02454  0.165468
#> X7  -0.46416  0.387664  0.26162 0.5229  0.14787 -0.191039  1.0000  0.462362 -0.21626 -0.179572
#> X8  -0.01547  0.615765  0.49797 0.3485  0.19105 -0.008972  0.4624  1.000000 -0.08630 -0.144862
#> X9   0.29781  0.220776  0.01875 0.5260  0.59065 -0.024541 -0.2163 -0.086303  1.00000  0.822033
#> X10  0.15185 -0.007062  0.01221 0.4102  0.54477  0.165468 -0.1796 -0.144862  0.82203  1.000000
```
