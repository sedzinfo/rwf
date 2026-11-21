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
#> 1   1 Cu By c5
#> 2   2 2S by 5a
#> 3   3 CN zZ D8
#> 4   4 Oi Io 2k
#> 5   5 uA rJ Qm
#> 6   6 83 TX Nm
#> 7   7 68 IJ 25
#> 8   8 gM 5h 5D
#> 9   9 rl gj QS
#> 10 10 LJ ku Uh
```
