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
#>             X1 X2 X3 X4     X1.1     X2.1     X3.1    X4.1      X5      X6       X7      X8       X9      X10
#> 1/i3/iT/GJ   1 i3 iT GJ -0.35343  1.38466  0.86073  0.8589 -0.3520  0.4702  2.88739 -1.6249 -0.28193 -0.59334
#> 2/1O/S3/OH   2 1O S3 OH  1.79383 -0.30829 -0.38108  1.2065 -1.1543  0.6623  0.19468 -0.2981  0.54763 -1.22902
#> 3/mC/FS/XT   3 mC FS XT  0.17879 -0.52585  0.23302 -0.1369 -0.7784  0.1651  0.11563 -1.0709  2.20780 -0.13018
#> 4/oL/C9/vJ   4 oL C9 vJ  0.09812  1.04531 -0.97710 -0.5574  0.5174 -1.2153 -1.11935  0.4781 -0.50497 -1.19197
#> 5/ES/5E/gy   5 ES 5E gy -0.91614  1.26648 -2.09246  0.7152 -1.8662 -0.5761  1.74367 -0.2437 -0.55279  0.55777
#> 6/gA/yT/Bx   6 gA yT Bx  0.91196  1.18403  0.08144  0.9917  2.3806 -0.3008  1.06117  1.6216 -0.75281  0.19049
#> 7/rb/2X/9R   7 rb 2X 9R -0.63146 -0.04988 -1.71384  0.7272  1.7063  1.9481  0.70033  0.7984  0.61267  0.01148
#> 8/WT/OH/WK   8 WT OH WK  2.11621  0.33328  0.89579  1.7052  0.8149 -1.1430  2.70919 -0.8258 -0.06752 -0.20465
#> 9/HJ/3U/RW   9 HJ 3U RW  0.61823  0.64041  1.23332 -0.1892  0.9656 -0.5866  0.19397  1.6450  0.17621 -0.37313
#> 10/8L/kD/zN 10 8L kD zN  0.43156  0.61531  0.79115  0.7251  0.5586  0.3022  0.05888 -0.5149 -0.23619  0.32360
df[, 1] <- string
str_split_df(df, split = "/", type = "collumn", index = 1)
#>             X1 X2 X3 X4        X1.1     X2.1     X3.1    X4.1      X5      X6       X7      X8       X9      X10
#> 1/i3/iT/GJ   1 i3 iT GJ  1/i3/iT/GJ  1.38466  0.86073  0.8589 -0.3520  0.4702  2.88739 -1.6249 -0.28193 -0.59334
#> 2/1O/S3/OH   2 1O S3 OH  2/1O/S3/OH -0.30829 -0.38108  1.2065 -1.1543  0.6623  0.19468 -0.2981  0.54763 -1.22902
#> 3/mC/FS/XT   3 mC FS XT  3/mC/FS/XT -0.52585  0.23302 -0.1369 -0.7784  0.1651  0.11563 -1.0709  2.20780 -0.13018
#> 4/oL/C9/vJ   4 oL C9 vJ  4/oL/C9/vJ  1.04531 -0.97710 -0.5574  0.5174 -1.2153 -1.11935  0.4781 -0.50497 -1.19197
#> 5/ES/5E/gy   5 ES 5E gy  5/ES/5E/gy  1.26648 -2.09246  0.7152 -1.8662 -0.5761  1.74367 -0.2437 -0.55279  0.55777
#> 6/gA/yT/Bx   6 gA yT Bx  6/gA/yT/Bx  1.18403  0.08144  0.9917  2.3806 -0.3008  1.06117  1.6216 -0.75281  0.19049
#> 7/rb/2X/9R   7 rb 2X 9R  7/rb/2X/9R -0.04988 -1.71384  0.7272  1.7063  1.9481  0.70033  0.7984  0.61267  0.01148
#> 8/WT/OH/WK   8 WT OH WK  8/WT/OH/WK  0.33328  0.89579  1.7052  0.8149 -1.1430  2.70919 -0.8258 -0.06752 -0.20465
#> 9/HJ/3U/RW   9 HJ 3U RW  9/HJ/3U/RW  0.64041  1.23332 -0.1892  0.9656 -0.5866  0.19397  1.6450  0.17621 -0.37313
#> 10/8L/kD/zN 10 8L kD zN 10/8L/kD/zN  0.61531  0.79115  0.7251  0.5586  0.3022  0.05888 -0.5149 -0.23619  0.32360
```
