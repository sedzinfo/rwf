# Split a string vector into a data frame of parts

Splits each element of a character vector by a separator and returns
theparts as columns of a data frame, one row per input element.

## Usage

``` r
str_split(vector, split = "/", include_original = FALSE)
```

## Arguments

- vector:

  Character vector to split.

- split:

  Character. The separator to split on. Default is `"/"`.

- include_original:

  Logical. If `TRUE`, appends the original input as a final column.
  Default is `FALSE`.

## Value

A data frame with one row per element of `vector` and one column per
split part. Assumes all elements produce the same number of parts.

## Examples

``` r
string <- paste0(
  1:10, "/",
  generate_string(nchar = 2, vector_length = 10), "/",
  generate_string(nchar = 2, vector_length = 10), "/",
  generate_string(nchar = 2, vector_length = 10)
)
str_split(string, split = "/")
#>    X1 X2 X3 X4
#> 1   1 EZ 9N rH
#> 2   2 5q mv YH
#> 3   3 Yr dl Fq
#> 4   4 U8 N4 1F
#> 5   5 7f Gt jM
#> 6   6 jQ t8 GX
#> 7   7 w8 pO 7B
#> 8   8 wD jg vh
#> 9   9 1N ju p9
#> 10 10 x6 wp vy
```
