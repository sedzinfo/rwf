# Split a string column or row names in a data frame into separate columns

Splits a delimited string — either from row names or a specified column
— and prepends the resulting parts as new columns to the data frame.

## Usage

``` r
str_split_df(df, split = "/", type = "row", index, ...)
```

## Arguments

- df:

  A data frame.

- split:

  Character. The separator to split on. Default is `"/"`.

- type:

  Character. Where to read the string from. One of:

  `"row"`

  : Splits the row names of `df`.

  `"collumn"`

  : Splits the column specified by `index`.

  Default is `"row"`.

- index:

  Integer. Column index to split when `type = "collumn"`.

- ...:

  Additional arguments passed to
  [`str_split`](https://sedzinfo.github.io/rwf/reference/str_split.md).

## Value

A data frame with the split parts prepended as new columns, followed by
the original columns of `df`.

## See also

[`str_split`](https://sedzinfo.github.io/rwf/reference/str_split.md)

## Examples

``` r
df <- generate_correlation_matrix()
string <- paste0(
  1:nrow(df), "/",
  generate_string(nchar = 2, vector_length = nrow(df)), "/",
  generate_string(nchar = 2, vector_length = nrow(df)), "/",
  generate_string(nchar = 2, vector_length = nrow(df))
)
row.names(df) <- string
str_split_df(df, split = "/", type = "row")
#>             X1 X2 X3 X4     X1.1     X2.1    X3.1    X4.1      X5       X6      X7      X8      X9      X10
#> 1/Pv/zE/Z5   1 Pv zE Z5  1.57968  0.57108  1.0985  1.1842 -0.2299  0.80735 -0.1985  0.3354  0.8270 -0.17282
#> 2/hR/6H/2i   2 hR 6H 2i  1.06210 -0.51993  1.2677  1.4146 -0.7253  1.04822 -1.4909 -2.3841  1.4014 -0.23837
#> 3/oB/Ia/Z5   3 oB Ia Z5 -0.59785 -1.04960 -0.6237  1.5585 -0.4260  0.06129  0.1647  0.8393  0.6548 -0.94387
#> 4/cY/C6/H1   4 cY C6 H1  2.34955  0.08238 -0.3837 -0.3828 -0.1651 -0.50489 -1.2331 -1.5700 -0.3363  0.11692
#> 5/P9/p4/xe   5 P9 p4 xe  1.01641  0.14942  1.1559 -0.3076  0.6960  0.66733 -0.9380  1.3293  0.9407  1.57286
#> 6/9h/Xb/eX   6 9h Xb eX  0.91118 -2.45914 -0.3563 -0.3728  0.2909  0.65588  0.9739  0.3094 -0.1346 -0.16139
#> 7/Sy/U9/nj   7 Sy U9 nj -0.76379 -0.34879 -0.1575  0.6524 -0.5037  0.26231  0.4198  0.1651 -1.7970  0.08575
#> 8/vx/BV/CB   8 vx BV CB -0.39202  0.55083  1.4129  0.9850  0.5611 -0.05635 -1.2282  0.7089  1.4884  0.96509
#> 9/oD/i8/HW   9 oD i8 HW  1.61516  0.13988  0.3077  1.0856 -0.5230  0.68076 -0.8589  0.2996  2.4177 -2.07358
#> 10/Qd/22/VH 10 Qd 22 VH -0.02794  0.85111  1.7109  1.0789  1.3041  0.60958 -0.2764  0.7070  0.2182 -2.09965
df[, 1] <- string
str_split_df(df, split = "/", type = "collumn", index = 1)
#>             X1 X2 X3 X4        X1.1     X2.1    X3.1    X4.1      X5       X6      X7      X8      X9      X10
#> 1/Pv/zE/Z5   1 Pv zE Z5  1/Pv/zE/Z5  0.57108  1.0985  1.1842 -0.2299  0.80735 -0.1985  0.3354  0.8270 -0.17282
#> 2/hR/6H/2i   2 hR 6H 2i  2/hR/6H/2i -0.51993  1.2677  1.4146 -0.7253  1.04822 -1.4909 -2.3841  1.4014 -0.23837
#> 3/oB/Ia/Z5   3 oB Ia Z5  3/oB/Ia/Z5 -1.04960 -0.6237  1.5585 -0.4260  0.06129  0.1647  0.8393  0.6548 -0.94387
#> 4/cY/C6/H1   4 cY C6 H1  4/cY/C6/H1  0.08238 -0.3837 -0.3828 -0.1651 -0.50489 -1.2331 -1.5700 -0.3363  0.11692
#> 5/P9/p4/xe   5 P9 p4 xe  5/P9/p4/xe  0.14942  1.1559 -0.3076  0.6960  0.66733 -0.9380  1.3293  0.9407  1.57286
#> 6/9h/Xb/eX   6 9h Xb eX  6/9h/Xb/eX -2.45914 -0.3563 -0.3728  0.2909  0.65588  0.9739  0.3094 -0.1346 -0.16139
#> 7/Sy/U9/nj   7 Sy U9 nj  7/Sy/U9/nj -0.34879 -0.1575  0.6524 -0.5037  0.26231  0.4198  0.1651 -1.7970  0.08575
#> 8/vx/BV/CB   8 vx BV CB  8/vx/BV/CB  0.55083  1.4129  0.9850  0.5611 -0.05635 -1.2282  0.7089  1.4884  0.96509
#> 9/oD/i8/HW   9 oD i8 HW  9/oD/i8/HW  0.13988  0.3077  1.0856 -0.5230  0.68076 -0.8589  0.2996  2.4177 -2.07358
#> 10/Qd/22/VH 10 Qd 22 VH 10/Qd/22/VH  0.85111  1.7109  1.0789  1.3041  0.60958 -0.2764  0.7070  0.2182 -2.09965
```
