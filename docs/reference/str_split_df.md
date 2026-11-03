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
#>             X1 X2 X3 X4        X1.1    X2.1     X3.1     X4.1      X5      X6       X7      X8      X9     X10
#> 1/rJ/Iy/pf   1 rJ Iy pf  0.01439742  0.1206  0.40830  0.01110  2.8860  0.6766  1.09885 -0.7897  0.4382  0.5570
#> 2/AN/8l/bJ   2 AN 8l bJ -1.57822068  1.0026  0.19974 -0.64941 -1.6191  0.3019  0.02194  0.1147  0.1076 -2.1844
#> 3/m6/ee/42   3 m6 ee 42  0.00006599  0.1076  2.01731  0.62683  0.9277  1.5977  1.14512  1.1350  0.5283  1.8498
#> 4/DP/tm/Ag   4 DP tm Ag -1.41280406 -1.8176  0.72312 -2.04827 -0.4330 -1.8738 -1.64066 -1.2604 -0.8523 -1.6372
#> 5/77/nj/5H   5 77 nj 5H  0.76486308  1.0250  0.76888  0.42013  1.0465 -0.6996 -0.90790 -0.6704  0.9635 -0.7133
#> 6/B6/iH/oM   6 B6 iH oM  1.06219568 -0.4651  0.46944  0.41535 -0.5910 -0.6790  1.74823  1.3975  1.6250  1.9055
#> 7/b0/PY/JF   7 b0 PY JF -1.52951769 -0.8677 -0.26685 -0.38466  1.9530  0.5870 -0.03451  2.2266  1.2371 -0.1810
#> 8/d7/S9/VI   8 d7 S9 VI -1.07902961 -0.9736 -0.58423 -0.73463 -0.1567 -0.1004 -1.86435 -1.2228 -1.1105  0.7266
#> 9/2y/BH/Zr   9 2y BH Zr -0.25929467  0.8406 -0.79497 -0.01716  0.3438  1.5153  0.27574  0.9941 -0.6272 -0.2888
#> 10/XT/rX/px 10 XT rX px  0.19236785  1.9291  0.09953 -0.67823  0.4175 -0.5637  0.02799  1.2216  0.3565  0.8388
df[, 1] <- string
str_split_df(df, split = "/", type = "collumn", index = 1)
#>             X1 X2 X3 X4        X1.1    X2.1     X3.1     X4.1      X5      X6       X7      X8      X9     X10
#> 1/rJ/Iy/pf   1 rJ Iy pf  1/rJ/Iy/pf  0.1206  0.40830  0.01110  2.8860  0.6766  1.09885 -0.7897  0.4382  0.5570
#> 2/AN/8l/bJ   2 AN 8l bJ  2/AN/8l/bJ  1.0026  0.19974 -0.64941 -1.6191  0.3019  0.02194  0.1147  0.1076 -2.1844
#> 3/m6/ee/42   3 m6 ee 42  3/m6/ee/42  0.1076  2.01731  0.62683  0.9277  1.5977  1.14512  1.1350  0.5283  1.8498
#> 4/DP/tm/Ag   4 DP tm Ag  4/DP/tm/Ag -1.8176  0.72312 -2.04827 -0.4330 -1.8738 -1.64066 -1.2604 -0.8523 -1.6372
#> 5/77/nj/5H   5 77 nj 5H  5/77/nj/5H  1.0250  0.76888  0.42013  1.0465 -0.6996 -0.90790 -0.6704  0.9635 -0.7133
#> 6/B6/iH/oM   6 B6 iH oM  6/B6/iH/oM -0.4651  0.46944  0.41535 -0.5910 -0.6790  1.74823  1.3975  1.6250  1.9055
#> 7/b0/PY/JF   7 b0 PY JF  7/b0/PY/JF -0.8677 -0.26685 -0.38466  1.9530  0.5870 -0.03451  2.2266  1.2371 -0.1810
#> 8/d7/S9/VI   8 d7 S9 VI  8/d7/S9/VI -0.9736 -0.58423 -0.73463 -0.1567 -0.1004 -1.86435 -1.2228 -1.1105  0.7266
#> 9/2y/BH/Zr   9 2y BH Zr  9/2y/BH/Zr  0.8406 -0.79497 -0.01716  0.3438  1.5153  0.27574  0.9941 -0.6272 -0.2888
#> 10/XT/rX/px 10 XT rX px 10/XT/rX/px  1.9291  0.09953 -0.67823  0.4175 -0.5637  0.02799  1.2216  0.3565  0.8388
```
