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

  if TRUE it will output scatterplots

## Examples

``` r
report_correlation(x=generate_missing(mtcars[,1:3],10))




#> $r_lower
#>          mpg    cyl disp
#> mpg       NA     NA   NA
#> cyl  -0.8646     NA   NA
#> disp -0.8583 0.9232   NA
#> 
#> $r_squared_lower
#>         mpg    cyl disp
#> mpg      NA     NA   NA
#> cyl  0.7475     NA   NA
#> disp 0.7367 0.8523   NA
#> 
#> $p_lower
#>             mpg          cyl disp
#> mpg          NA           NA   NA
#> cyl  0.00006604           NA   NA
#> disp 0.00004223 0.0000001281   NA
#> 
#> $p_lower_adjusted
#>             mpg          cyl disp
#> mpg          NA           NA   NA
#> cyl  0.00008447           NA   NA
#> disp 0.00008447 0.0000003843   NA
#> 
#> $t_lower
#>         mpg   cyl disp
#> mpg      NA    NA   NA
#> cyl  -5.961    NA   NA
#> disp -6.032 9.303   NA
#> 
#> $n_lower
#>      mpg cyl disp
#> mpg   NA  NA   NA
#> cyl   14  NA   NA
#> disp  15  17   NA
#> 
#> $se_lower
#>         mpg     cyl disp
#> mpg      NA      NA   NA
#> cyl  0.1451      NA   NA
#> disp 0.1423 0.09923   NA
#> 
#> $ci
#>            lower       r   upper            p lower.adj upper.adj
#> mpg-cyl  -0.9564 -0.8646 -0.6171 0.0000660430   -0.9631   -0.5618
#> mpg-disp -0.9520 -0.8583 -0.6176 0.0000422343   -0.9520   -0.6176
#> cyl-disp  0.7956  0.9232  0.9724 0.0000001281    0.7489    0.9780
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
                   file=file.path(tempdir(),"correlation"),scatterplot=TRUE)




#> $r_lower
#>          mpg    cyl disp
#> mpg       NA     NA   NA
#> cyl  -0.9439     NA   NA
#> disp -0.8187 0.8777   NA
#> 
#> $r_squared_lower
#>         mpg    cyl disp
#> mpg      NA     NA   NA
#> cyl  0.8910     NA   NA
#> disp 0.6703 0.7703   NA
#> 
#> $p_lower
#>               mpg        cyl disp
#> mpg            NA         NA   NA
#> cyl  0.0000001264         NA   NA
#> disp 0.0011275786 0.00003694   NA
#> 
#> $p_lower_adjusted
#>               mpg        cyl disp
#> mpg            NA         NA   NA
#> cyl  0.0000003791         NA   NA
#> disp 0.0011275786 0.00007389   NA
#> 
#> $t_lower
#>          mpg   cyl disp
#> mpg       NA    NA   NA
#> cyl  -10.308    NA   NA
#> disp  -4.509 6.344   NA
#> 
#> $n_lower
#>      mpg cyl disp
#> mpg   NA  NA   NA
#> cyl   15  NA   NA
#> disp  12  14   NA
#> 
#> $se_lower
#>          mpg    cyl disp
#> mpg       NA     NA   NA
#> cyl  0.09157     NA   NA
#> disp 0.18158 0.1383   NA
#> 
#> $ci
#>            lower       r   upper            p lower.adj upper.adj
#> mpg-cyl  -0.9816 -0.9439 -0.8358 0.0000001264   -0.9856   -0.7939
#> mpg-disp -0.9474 -0.8187 -0.4618 0.0011275786   -0.9474   -0.4618
#> cyl-disp  0.6496  0.8777  0.9608 0.0000369446    0.5979    0.9668
#> 
#> $call
#>                  function_arguments function_values
#> 1                               Use        pairwise
#> 2                            Method         pearson
#> 3 Adjustment for Probability values            holm
#> 4                             Alpha            0.05
#> 5               Confidence Interval            TRUE
#> 
report_correlation(x=mtcars[,1:3],file=file.path(tempdir(),"correlation"))




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
