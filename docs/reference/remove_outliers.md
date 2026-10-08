# Replace outliers with NA using IQR fences

Replaces values outside the boxplot fences with `NA`. The fences are
computed as \\Q1 - 1.5 \times IQR\\ and \\Q3 + 1.5 \times IQR\\, where
\\Q1\\ and \\Q3\\ are the quantiles specified by `probs`. Designed to be
applied across columns with `sapply`.

## Usage

``` r
remove_outliers(vector, probs = c(0.25, 0.75), na.rm = TRUE, ...)
```

## Arguments

- vector:

  Numeric vector.

- probs:

  Length-2 numeric vector giving the lower and upper quantile
  probabilities used to define the fence boundaries. Default is
  `c(0.25, 0.75)` (standard quartiles).

- na.rm:

  Logical; whether to remove `NA` values when computing quantiles and
  IQR. Default is `TRUE`.

- ...:

  Additional arguments passed to
  [`quantile`](https://rdrr.io/r/stats/quantile.html).

## Value

A numeric vector the same length as `vector` with outlying values
replaced by `NA`.

## Examples

``` r
vector <- generate_missing(rnorm(50), missing = 10)
df <- generate_missing(mtcars[, 1:2], missing = 10)
remove_outliers(vector)
#>  [1]  0.170678 -1.225071  0.387333  0.490668        NA  0.892212  0.798933        NA        NA  0.632521  0.102591  1.010211        NA  0.500871 -0.909468 -2.197209  0.438545        NA  0.713078
#> [20]  1.028269 -0.570633 -0.434009        NA  1.203545  1.496183 -0.156598 -0.936031  0.352539 -1.286189 -0.272523  0.156915        NA -0.121898 -0.855251        NA -0.913952 -2.078234 -0.140647
#> [39]        NA -0.029369 -2.236622        NA  0.830842 -0.497579 -0.601027 -0.512198 -0.004932 -0.097148        NA -0.127390
data.frame(sapply(df, remove_outliers))
#>     mpg cyl
#> 1    NA   6
#> 2    NA   6
#> 3  22.8   4
#> 4    NA  NA
#> 5  18.7   8
#> 6  18.1   6
#> 7  14.3   8
#> 8  24.4  NA
#> 9  22.8   4
#> 10 19.2  NA
#> 11 17.8  NA
#> 12 16.4   8
#> 13 17.3   8
#> 14   NA   8
#> 15 10.4   8
#> 16 10.4  NA
#> 17 14.7   8
#> 18   NA   4
#> 19   NA   4
#> 20   NA   4
#> 21 21.5  NA
#> 22 15.5   8
#> 23 15.2  NA
#> 24 13.3  NA
#> 25   NA   8
#> 26   NA   4
#> 27   NA  NA
#> 28 30.4   4
#> 29   NA   8
#> 30 19.7   6
#> 31 15.0  NA
#> 32 21.4   4
```
