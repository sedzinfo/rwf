# Generate a data frame with a predetermined correlation structure

Simulates multivariate normal data whose columns reproduce a target
correlation matrix, using Cholesky decomposition. If no matrix is
supplied, a random symmetric positive-definite matrix is generated
automatically.

## Usage

``` r
generate_correlation_matrix(correlation_martix, nrows = 10)
```

## Arguments

- correlation_martix:

  A symmetric positive-definite matrix specifying the desired
  correlations between columns. Must pass Cholesky decomposition. If
  omitted, a random correlation matrix is generated.

- nrows:

  Integer. Number of observations (rows) to generate. Default is `10`.

## Value

A data frame with `nrows` rows and `ncol(correlation_martix)` columns of
simulated numeric values.

## Details

Uses Cholesky decomposition
([`chol()`](https://rdrr.io/r/base/chol.html)) to factor the target
correlation matrix, then multiplies by independent standard normal draws
to produce correlated columns. The resulting correlations approximate
the target matrix, with accuracy improving as `nrows` increases.

## See also

[`generate_data`](https://sedzinfo.github.io/rwf/reference/generate_data.md),
[`symmetric_matrix`](https://sedzinfo.github.io/rwf/reference/symmetric_matrix.md)

## Examples

``` r
df <- data.frame(matrix(.999, ncol = 2, nrow = 2))
correlation_martix <- as.matrix(df)
diag(correlation_martix) <- 1
df <- generate_correlation_matrix(correlation_martix, nrows = 100)
stats::cor(df)
#>        X1     X2
#> X1 1.0000 0.9993
#> X2 0.9993 1.0000
```
