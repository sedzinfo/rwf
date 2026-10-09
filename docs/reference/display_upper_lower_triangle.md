# Return upper diagonal from one matrix and lower diagonal from another matrix

Return upper diagonal from one matrix and lower diagonal from another
matrix

## Usage

``` r
display_upper_lower_triangle(m_upper, m_lower, diagonal = NA)
```

## Arguments

- m_upper:

  matrix

- m_lower:

  matrix

- diagonal:

  if "upper" it returns upper diagonal if "lower" it returns lower
  diagonal if NA returns NA in diagonal otherwise it returns any value
  specified

## Examples

``` r
m1<-matrix(1:9,nrow=3,ncol=3)
m2<-matrix(11:19,nrow=3,ncol=3)
display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal="upper")
#>      X1 X2 X3
#> [1,]  1  4  7
#> [2,] 12  5  8
#> [3,] 13 16  9
display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal="lower")
#>      X1 X2 X3
#> [1,] 11  4  7
#> [2,] 12 15  8
#> [3,] 13 16 19
display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal=NA)
#>      X1 X2 X3
#> [1,] NA  4  7
#> [2,] 12 NA  8
#> [3,] 13 16 NA
display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal=1)
#>      X1 X2 X3
#> [1,]  1  4  7
#> [2,] 12  1  8
#> [3,] 13 16  1
display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal=c("X1","X2","X3"))
#>      X1   X2   X3  
#> [1,] "X1" "4"  "7" 
#> [2,] "12" "X2" "8" 
#> [3,] "13" "16" "X3"
display_upper_lower_triangle(m_upper=m1,m_lower=m2,diagonal=c(1,2,3))
#>      X1 X2 X3
#> [1,]  1  4  7
#> [2,] 12  2  8
#> [3,] 13 16  3
display_upper_lower_triangle(m_upper=m1,m2)
#>      X1 X2 X3
#> [1,] NA  4  7
#> [2,] 12 NA  8
#> [3,] 13 16 NA
```
