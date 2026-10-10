# Combine the upper triangle of one matrix with the lower triangle of another

Builds a matrix whose upper triangle comes from `m_upper` and whose
lower triangle comes from `m_lower`, e.g. to show two correlation
matrices, or correlations and p values, in a single table.

## Usage

``` r
display_upper_lower_triangle(m_upper, m_lower, diagonal = NA)
```

## Arguments

- m_upper:

  A square numeric matrix (or an object that
  [`as.matrix()`](https://rdrr.io/r/base/matrix.html) turns into one)
  supplying the upper triangle.

- m_lower:

  A square numeric matrix of the same size supplying the lower triangle.

- diagonal:

  What to place on the diagonal: `NA` (default) for `NA`, `"upper"` for
  the diagonal of `m_upper`, `"lower"` for the diagonal of `m_lower`, or
  any other value(s), either a single value or one value per diagonal
  element.

## Value

A matrix with the dimensions and row / column names of `m_lower`. It is
numeric, unless `diagonal` contains text, in which case the whole matrix
becomes character.

## See also

[`matrix_triangle`](https://sedzinfo.github.io/rwf/reference/matrix_triangle.md),
[`symmetric_matrix`](https://sedzinfo.github.io/rwf/reference/symmetric_matrix.md)

## Examples

``` r
m1<-matrix(1:9,nrow=3,ncol=3)
m2<-matrix(11:19,nrow=3,ncol=3)
display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal="upper")
#>      [,1] [,2] [,3]
#> [1,]    1    4    7
#> [2,]   12    5    8
#> [3,]   13   16    9
display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal="lower")
#>      [,1] [,2] [,3]
#> [1,]   11    4    7
#> [2,]   12   15    8
#> [3,]   13   16   19
display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal=NA)
#>      [,1] [,2] [,3]
#> [1,]   NA    4    7
#> [2,]   12   NA    8
#> [3,]   13   16   NA
display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal=1)
#>      [,1] [,2] [,3]
#> [1,]    1    4    7
#> [2,]   12    1    8
#> [3,]   13   16    1
display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal=c("X1","X2","X3"))
#>      [,1] [,2] [,3]
#> [1,] "X1" "4"  "7" 
#> [2,] "12" "X2" "8" 
#> [3,] "13" "16" "X3"
display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal=c(1,2,3))
#>      [,1] [,2] [,3]
#> [1,]    1    4    7
#> [2,]   12    2    8
#> [3,]   13   16    3
display_upper_lower_triangle(m_upper=m1,m2)
#>      [,1] [,2] [,3]
#> [1,]   NA    4    7
#> [2,]   12   NA    8
#> [3,]   13   16   NA
```
