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
#>     rnorm(10)   rnorm(11)   rnorm(12)   rnorm(13)
#> 1   0.6010915  0.49926364  0.99967633 -1.74550515
#> 2  -2.7671158 -0.37971579 -0.25402600 -0.20723144
#> 3   0.1815231  0.27895349  0.76922242 -0.02346067
#> 4   2.2618871  0.02597137 -0.10234503 -1.48048653
#> 5   0.7119713  1.34252439 -1.49921376  2.72769292
#> 6   1.1572727 -1.68496253  0.10291082  0.29197216
#> 7   0.2509712 -1.89403426  1.46249872  1.44972635
#> 8  -1.0991411 -1.38330270 -0.83939182 -0.63243773
#> 9   0.3724235 -0.83727797  1.17592794 -0.07519550
#> 10 -1.7843500  0.00256629  0.04779855 -0.23536331
#> 11         NA -1.77304002  2.35389080  2.38749939
#> 12         NA          NA -0.57521892 -1.13864182
#> 13         NA          NA          NA -1.27214497
```
