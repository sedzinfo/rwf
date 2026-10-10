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
#>  [1] -0.5569      NA  1.0980      NA      NA      NA -0.2768  0.7523  1.0451      NA
generate_missing(generate_data(nrow = 10, ncol = 2), missing = 5)
#>         X1      X2
#> 1       NA      NA
#> 2  -0.4388      NA
#> 3       NA  0.9218
#> 4       NA      NA
#> 5       NA  0.3606
#> 6  -1.5297 -1.3665
#> 7  -0.2401      NA
#> 8   1.1533 -0.6981
#> 9       NA -0.8304
#> 10 -1.3230      NA
```
