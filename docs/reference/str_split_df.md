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
#>             X1 X2 X3 X4     X1.1     X2.1     X3.1     X4.1      X5      X6      X7       X8       X9     X10
#> 1/Nm/le/J4   1 Nm le J4 -0.23476 -0.49968 -0.28004 -1.51004  0.7363 -0.1688 -0.2142  0.10675 -1.42527 -1.0216
#> 2/6D/et/2A   2 6D et 2A  0.51924 -0.33985  0.05214 -1.13565 -0.6010 -0.1095 -0.5271  0.01207 -1.63081 -0.5127
#> 3/P7/mn/g5   3 P7 mn g5  0.40441  2.48511 -0.24601 -0.11483 -0.2273  1.7429  0.6448  1.00570  0.46697 -0.1938
#> 4/7B/ji/Ho   4 7B ji Ho -0.46292 -0.72654 -0.44825 -0.23671 -0.9602  0.4413 -0.6510  1.04656 -1.92798  0.2269
#> 5/6b/HP/MJ   5 6b HP MJ  0.34689  0.55061 -1.10604 -1.05120  1.4381 -0.9400 -0.1128 -0.93444  0.12393 -0.3741
#> 6/0d/YS/FV   6 0d YS FV  0.02292  0.04484  0.91220  0.10944  1.6115  1.2383 -0.3015  0.54301  0.21651 -0.4081
#> 7/72/9B/IZ   7 72 9B IZ -1.09721  1.28468  0.65543 -0.06592 -0.7443 -0.3542 -1.6384  0.26965 -0.58898  0.4680
#> 8/yX/Hr/rp   8 yX Hr rp  0.60718 -0.29796  2.13613  0.28716  1.4944  1.0819  0.5510  0.68324  0.06783 -0.5714
#> 9/TI/Xp/xy   9 TI Xp xy  2.08189  1.33115 -0.61449 -0.06673  0.9133 -0.4617  0.1949 -0.12948 -1.04778  0.3233
#> 10/y8/fb/We 10 y8 fb We  1.26525 -0.56054  0.02872  0.52032 -1.0994 -0.1462  1.1782 -0.98154  0.45323 -1.1924
df[, 1] <- string
str_split_df(df, split = "/", type = "collumn", index = 1)
#>             X1 X2 X3 X4        X1.1     X2.1     X3.1     X4.1      X5      X6      X7       X8       X9     X10
#> 1/Nm/le/J4   1 Nm le J4  1/Nm/le/J4 -0.49968 -0.28004 -1.51004  0.7363 -0.1688 -0.2142  0.10675 -1.42527 -1.0216
#> 2/6D/et/2A   2 6D et 2A  2/6D/et/2A -0.33985  0.05214 -1.13565 -0.6010 -0.1095 -0.5271  0.01207 -1.63081 -0.5127
#> 3/P7/mn/g5   3 P7 mn g5  3/P7/mn/g5  2.48511 -0.24601 -0.11483 -0.2273  1.7429  0.6448  1.00570  0.46697 -0.1938
#> 4/7B/ji/Ho   4 7B ji Ho  4/7B/ji/Ho -0.72654 -0.44825 -0.23671 -0.9602  0.4413 -0.6510  1.04656 -1.92798  0.2269
#> 5/6b/HP/MJ   5 6b HP MJ  5/6b/HP/MJ  0.55061 -1.10604 -1.05120  1.4381 -0.9400 -0.1128 -0.93444  0.12393 -0.3741
#> 6/0d/YS/FV   6 0d YS FV  6/0d/YS/FV  0.04484  0.91220  0.10944  1.6115  1.2383 -0.3015  0.54301  0.21651 -0.4081
#> 7/72/9B/IZ   7 72 9B IZ  7/72/9B/IZ  1.28468  0.65543 -0.06592 -0.7443 -0.3542 -1.6384  0.26965 -0.58898  0.4680
#> 8/yX/Hr/rp   8 yX Hr rp  8/yX/Hr/rp -0.29796  2.13613  0.28716  1.4944  1.0819  0.5510  0.68324  0.06783 -0.5714
#> 9/TI/Xp/xy   9 TI Xp xy  9/TI/Xp/xy  1.33115 -0.61449 -0.06673  0.9133 -0.4617  0.1949 -0.12948 -1.04778  0.3233
#> 10/y8/fb/We 10 y8 fb We 10/y8/fb/We -0.56054  0.02872  0.52032 -1.0994 -0.1462  1.1782 -0.98154  0.45323 -1.1924
```
