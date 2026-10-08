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
#> 1   1 WM Yk Wk
#> 2   2 9W 7t pA
#> 3   3 vk iS 3T
#> 4   4 AR r5 72
#> 5   5 bZ Kz Kj
#> 6   6 PF Kb BY
#> 7   7 Pa c6 Mx
#> 8   8 U1 dQ 9Y
#> 9   9 gK Qf Rf
#> 10 10 hO n8 Wl
```
