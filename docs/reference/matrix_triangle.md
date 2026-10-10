# Keep the lower or upper triangle of a matrix

Keeps one triangle of a matrix, including the diagonal, and fills the
other triangle with the value of `off_diagonal`; optionally replaces the
diagonal. Useful for displaying correlation or covariance matrices
without repeated values.

## Usage

``` r
matrix_triangle(m, off_diagonal = NA, diagonal = NULL, type = "lower")
```

## Arguments

- m:

  A numeric matrix, or an object that
  [`as.matrix()`](https://rdrr.io/r/base/matrix.html) turns into a
  numeric matrix (e.g. a data frame of numbers).

- off_diagonal:

  Value used to fill the dropped triangle. Default `NA`.

- diagonal:

  Value(s) to place on the diagonal: a single value or one value per
  diagonal element. If `NULL` (default), the original diagonal is kept.

- type:

  Character, `"lower"` (default) or `"upper"`: the triangle to keep.

## Value

A numeric matrix with the same dimensions and row / column names as `m`.

## See also

[`display_upper_lower_triangle`](https://sedzinfo.github.io/rwf/reference/display_upper_lower_triangle.md),
[`symmetric_matrix`](https://sedzinfo.github.io/rwf/reference/symmetric_matrix.md)

## Examples

``` r
m<-matrix(1:9,nrow=3,ncol=3)
matrix_triangle(m=m)
#>      [,1] [,2] [,3]
#> [1,]    1   NA   NA
#> [2,]    2    5   NA
#> [3,]    3    6    9
matrix_triangle(m=m,diagonal=NA,type="lower")
#>      [,1] [,2] [,3]
#> [1,]   NA   NA   NA
#> [2,]    2   NA   NA
#> [3,]    3    6   NA
matrix_triangle(m=m,diagonal=NULL,type="lower")
#>      [,1] [,2] [,3]
#> [1,]    1   NA   NA
#> [2,]    2    5   NA
#> [3,]    3    6    9
matrix_triangle(m=m,diagonal=NA,type="upper")
#>      [,1] [,2] [,3]
#> [1,]   NA    4    7
#> [2,]   NA   NA    8
#> [3,]   NA   NA   NA
matrix_triangle(m=m,diagonal=NULL,type="upper")
#>      [,1] [,2] [,3]
#> [1,]    1    4    7
#> [2,]   NA    5    8
#> [3,]   NA   NA    9
```
