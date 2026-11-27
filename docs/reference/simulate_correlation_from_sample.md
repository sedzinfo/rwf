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
#>           X1       X2      X3       X4      X5       X6       X7       X8       X9      X10
#> X1   1.00000  0.39782 -0.1709 -0.11915 -0.1867  0.10048  0.55773 -0.09285 -0.36245 -0.09602
#> X2   0.39782  1.00000  0.5220  0.14942  0.1725  0.30966  0.65804 -0.45161  0.02904  0.27895
#> X3  -0.17093  0.52196  1.0000  0.63452  0.6286  0.43799  0.29756  0.30324  0.58891  0.14558
#> X4  -0.11915  0.14942  0.6345  1.00000  0.4445 -0.09614  0.26431  0.25314  0.50291 -0.06854
#> X5  -0.18672  0.17254  0.6286  0.44451  1.0000  0.42116  0.34064  0.47365  0.29590  0.48927
#> X6   0.10048  0.30966  0.4380 -0.09614  0.4212  1.00000  0.07981  0.07451  0.09245  0.59201
#> X7   0.55773  0.65804  0.2976  0.26431  0.3406  0.07981  1.00000 -0.09482  0.05921 -0.04091
#> X8  -0.09285 -0.45161  0.3032  0.25314  0.4736  0.07451 -0.09482  1.00000  0.36473 -0.29388
#> X9  -0.36245  0.02904  0.5889  0.50291  0.2959  0.09245  0.05921  0.36473  1.00000 -0.15024
#> X10 -0.09602  0.27895  0.1456 -0.06854  0.4893  0.59201 -0.04091 -0.29388 -0.15024  1.00000
```
