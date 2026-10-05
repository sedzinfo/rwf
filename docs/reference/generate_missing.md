# Introduce missing values into a vector or data frame

Randomly replaces a fixed number of values with `NA`, either in a vector
or across every column of a data frame independently.

## Usage

``` r
generate_missing(df, missing = 5)
```

## Arguments

- df:

  A numeric vector or data frame. The object into which missing values
  are introduced.

- missing:

  Integer. Number of values to replace with `NA` per vector or per
  column. Must not exceed the length of the vector or `nrow(df)`.
  Default is `5`.

## Value

The input object with `missing` values replaced by `NA`. Returns the
same type as the input (vector or data frame).

## Examples

``` r
generate_missing(rnorm(10), missing = 5)
#>  [1]       NA       NA  0.37348       NA -0.47331  0.08991       NA  0.55574 -1.16888       NA
generate_missing(generate_data(nrow = 10, ncol = 2), missing = 5)
#>         X1      X2
#> 1       NA      NA
#> 2  -1.6423      NA
#> 3  -1.3938  0.3724
#> 4       NA -0.4400
#> 5   0.6286      NA
#> 6  -0.3834 -0.3526
#> 7       NA      NA
#> 8  -0.7217  1.3487
#> 9       NA      NA
#> 10      NA -0.7335
```
