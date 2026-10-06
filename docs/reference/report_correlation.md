# Report correlation matrix

Report correlation matrix

## Usage

``` r
report_correlation(
  x,
  y = NULL,
  use = "pairwise",
  method = "pearson",
  adjust = "holm",
  alpha = 0.05,
  ci = TRUE,
  file = NULL,
  w = 10,
  h = 10,
  base_size = 20,
  scatterplot = TRUE
)
```

## Arguments

- x:

  matrix or dataframe

- y:

  a second matrix or dataframe with the same number of rows as x

- use:

  "pairwise" is the default value and will do pairwise deletion of
  cases. "complete" will select just complete cases

- method:

  "pearson" "spearman" "kendall"

- adjust:

  "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"

- alpha:

  alpha level of confidence intervals

- ci:

  By default, confidence intervals are found. However, this leads to a
  great slowdown of speed. So, for just the rs, ts and ps, set ci=FALSE

- file:

  output filename

- w:

  width of pdf file

- h:

  height of pdf file

- base_size:

  base font size

- scatterplot:

  if TRUE it will outpu scatterplots

## Examples

``` r
report_correlation(x=generate_missing(mtcars[,1:3],10))




#> $r_lower
#>          mpg    cyl disp
#> mpg       NA     NA   NA
#> cyl  -0.8673     NA   NA
#> disp -0.8391 0.9063   NA
#> 
#> $r_squared_lower
#>         mpg    cyl disp
#> mpg      NA     NA   NA
#> cyl  0.7522     NA   NA
#> disp 0.7041 0.8213   NA
#> 
#> $p_lower
#>             mpg         cyl disp
#> mpg          NA          NA   NA
#> cyl  0.00000655          NA   NA
#> disp 0.00001344 0.000001326   NA
#> 
#> $p_lower_adjusted
#>             mpg         cyl disp
#> mpg          NA          NA   NA
#> cyl  0.00001310          NA   NA
#> disp 0.00001344 0.000003977   NA
#> 
#> $t_lower
#>         mpg   cyl disp
#> mpg      NA    NA   NA
#> cyl  -6.748    NA   NA
#> disp -6.171 8.022   NA
#> 
#> $n_lower
#>      mpg cyl disp
#> mpg   NA  NA   NA
#> cyl   17  NA   NA
#> disp  18  16   NA
#> 
#> $se_lower
#>         mpg   cyl disp
#> mpg      NA    NA   NA
#> cyl  0.1285    NA   NA
#> disp 0.1360 0.113   NA
#> 
#> $ci
#>            lower       r   upper           p lower.adj upper.adj
#> mpg-cyl  -0.9514 -0.8673 -0.6630 0.000006550   -0.9580   -0.6188
#> mpg-disp -0.9384 -0.8391 -0.6120 0.000013445   -0.9384   -0.6120
#> cyl-disp  0.7455  0.9063  0.9674 0.000001326    0.6870    0.9743
#> 
#> $call
#>                  function_arguments function_values
#> 1                               Use        pairwise
#> 2                            Method         pearson
#> 3 Adjustment for Probability values            holm
#> 4                             Alpha            0.05
#> 5               Confidence Interval            TRUE
#> 
report_correlation(x=generate_missing(mtcars[,1:3],10),
                   file="correlation",scatterplot=TRUE)




#> $r_lower
#>          mpg    cyl disp
#> mpg       NA     NA   NA
#> cyl  -0.8581     NA   NA
#> disp -0.7978 0.9269   NA
#> 
#> $r_squared_lower
#>         mpg    cyl disp
#> mpg      NA     NA   NA
#> cyl  0.7363     NA   NA
#> disp 0.6365 0.8592   NA
#> 
#> $p_lower
#>             mpg          cyl disp
#> mpg          NA           NA   NA
#> cyl  0.00008627           NA   NA
#> disp 0.00062777 0.0000002452   NA
#> 
#> $p_lower_adjusted
#>            mpg          cyl disp
#> mpg         NA           NA   NA
#> cyl  0.0001725           NA   NA
#> disp 0.0006278 0.0000007355   NA
#> 
#> $t_lower
#>         mpg   cyl disp
#> mpg      NA    NA   NA
#> cyl  -5.788    NA   NA
#> disp -4.584 9.244   NA
#> 
#> $n_lower
#>      mpg cyl disp
#> mpg   NA  NA   NA
#> cyl   14  NA   NA
#> disp  14  16   NA
#> 
#> $se_lower
#>         mpg    cyl disp
#> mpg      NA     NA   NA
#> cyl  0.1482     NA   NA
#> disp 0.1740 0.1003   NA
#> 
#> $ci
#>            lower       r   upper            p lower.adj upper.adj
#> mpg-cyl  -0.9542 -0.8581 -0.6012 0.0000862744   -0.9612   -0.5443
#> mpg-disp -0.9333 -0.7978 -0.4634 0.0006277709   -0.9333   -0.4634
#> cyl-disp  0.7978  0.9269  0.9748 0.0000002452    0.7497    0.9801
#> 
#> $call
#>                  function_arguments function_values
#> 1                               Use        pairwise
#> 2                            Method         pearson
#> 3 Adjustment for Probability values            holm
#> 4                             Alpha            0.05
#> 5               Confidence Interval            TRUE
#> 
report_correlation(x=mtcars[,1:3],file="correlation")




#> $r_lower
#>          mpg   cyl disp
#> mpg       NA    NA   NA
#> cyl  -0.8522    NA   NA
#> disp -0.8476 0.902   NA
#> 
#> $r_squared_lower
#>         mpg    cyl disp
#> mpg      NA     NA   NA
#> cyl  0.7262     NA   NA
#> disp 0.7183 0.8137   NA
#> 
#> $p_lower
#>                  mpg               cyl disp
#> mpg               NA                NA   NA
#> cyl  0.0000000006113                NA   NA
#> disp 0.0000000009380 0.000000000001803   NA
#> 
#> $p_lower_adjusted
#>                 mpg               cyl disp
#> mpg              NA                NA   NA
#> cyl  0.000000001223                NA   NA
#> disp 0.000000001223 0.000000000005409   NA
#> 
#> $t_lower
#>         mpg   cyl disp
#> mpg      NA    NA   NA
#> cyl  -8.920    NA   NA
#> disp -8.747 11.45   NA
#> 
#> $n_lower
#>    n
#> 1 32
#> 
#> $se_lower
#>          mpg     cyl disp
#> mpg       NA      NA   NA
#> cyl  0.09554      NA   NA
#> disp 0.09689 0.07881   NA
#> 
#> $ci
#>            lower       r   upper                 p lower.adj upper.adj
#> mpg-cyl  -0.9258 -0.8522 -0.7163 0.000000000611269   -0.9329   -0.6899
#> mpg-disp -0.9234 -0.8476 -0.7081 0.000000000938033   -0.9234   -0.7081
#> cyl-disp  0.8072  0.9020  0.9515 0.000000000001803    0.7773    0.9585
#> 
#> $call
#>                  function_arguments function_values
#> 1                               Use        pairwise
#> 2                            Method         pearson
#> 3 Adjustment for Probability values            holm
#> 4                             Alpha            0.05
#> 5               Confidence Interval            TRUE
#> 
```
