# Column-bind data frames or vectors of unequal lengths

Combines any number of data frames or vectors side by side, padding
shorter inputs with `NA` rows so all columns reach the same length. Each
input's columns are prefixed with the object's name to avoid duplicate
column names. Vectors are coerced to single-column data frames before
binding.

## Usage

``` r
c_bind(..., first = TRUE)
```

## Arguments

- ...:

  Data frames or vectors to column-bind. Names are taken from the
  unevaluated expressions passed (e.g. variable names).

- first:

  Logical. When `TRUE` (default) `NA` padding rows are appended at the
  bottom of shorter inputs; when `FALSE` they are prepended at the top.

## Value

A data frame with one column per column across all inputs, padded with
`NA` rows to the length of the longest input. Column names follow the
pattern `<object_name>` for single-column inputs and
`<object_name>_<original_colname>` for multi-column inputs.

## Author

Ananda Mahto

## Examples

``` r
c_bind(rnorm(10), rnorm(11), rnorm(12), rnorm(13))
#>       rnorm(10)   rnorm(11)   rnorm(12)   rnorm(13)
#> 1  -1.400043517 -0.55369938  0.36295126  1.62354888
#> 2   0.255317055  0.62898204 -1.30454355  0.11203808
#> 3  -2.437263611  2.06502490  0.73777632 -0.13399701
#> 4  -0.005571287 -1.63098940  1.88850493 -1.91008747
#> 5   0.621552721  0.51242695 -0.09744510 -0.27923724
#> 6   1.148411606 -1.86301149 -0.93584735 -0.31344598
#> 7  -1.821817661 -0.52201251 -0.01595031  1.06730788
#> 8  -0.247325302 -0.05260191 -0.82678895  0.07003485
#> 9  -0.244199607  0.54299634 -1.51239965 -0.63912332
#> 10 -0.282705449 -0.91407483  0.93536319 -0.04996490
#> 11           NA  0.46815442  0.17648861 -0.25148344
#> 12           NA          NA  0.24368546  0.44479712
#> 13           NA          NA          NA  2.75541758
```
