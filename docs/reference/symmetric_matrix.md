# Make a matrix symmetric by mirroring one triangle

Copies the lower or upper triangle of a square matrix onto the opposite
triangle, producing a symmetric matrix; optionally replaces the
diagonal. The row names are set to the column names, so both sides carry
the same labels.

## Usage

``` r
symmetric_matrix(matrix, duplicate = "lower", diagonal = NULL)
```

## Arguments

- matrix:

  A square matrix. Unlike
  [`matrix_triangle`](https://sedzinfo.github.io/rwf/reference/matrix_triangle.md),
  a data frame is not accepted; convert it with
  [`as.matrix()`](https://rdrr.io/r/base/matrix.html) first.

- duplicate:

  Character. Use `"lower"` (default) to copy the lower triangle into the
  upper, or `"upper"` to copy the upper triangle into the lower.

- diagonal:

  Value(s) to place on the diagonal: a single value (e.g. `NA`) or one
  value per diagonal element. Leave it out to keep the original
  diagonal; passing `NULL` explicitly is an error.

## Value

A symmetric matrix with the same dimensions as `matrix`, whose row names
are the column names of `matrix`.

## See also

[`matrix_triangle`](https://sedzinfo.github.io/rwf/reference/matrix_triangle.md),
[`display_upper_lower_triangle`](https://sedzinfo.github.io/rwf/reference/display_upper_lower_triangle.md)

## Examples

``` r
m_lower<-matrix_triangle(matrix(1:9,nrow=3,ncol=3),type="lower",diagonal=NA)
m_upper<-matrix_triangle(matrix(11:19,nrow=3,ncol=3),type="upper",diagonal=NA)
symmetric_matrix(matrix=m_lower,duplicate="lower",diagonal=NA)
#>      [,1] [,2] [,3]
#> [1,]   NA    2    3
#> [2,]    2   NA    6
#> [3,]    3    6   NA
symmetric_matrix(matrix=m_upper,duplicate="upper",diagonal=NA)
#>      [,1] [,2] [,3]
#> [1,]   NA   14   17
#> [2,]   14   NA   18
#> [3,]   17   18   NA
```
