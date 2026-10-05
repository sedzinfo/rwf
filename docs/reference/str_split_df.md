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
#>             X1 X2 X3 X4    X1.1    X2.1     X3.1     X4.1      X5      X6      X7       X8       X9     X10
#> 1/yv/9B/jC   1 yv 9B jC -0.3640  0.6871 -1.41393  1.05883 -1.3364 -1.4569  0.1602  0.60592 -0.49677 -1.2676
#> 2/xo/Vi/BH   2 xo Vi BH  0.7421 -2.3570 -0.64007  0.81509 -1.2416  0.6343 -1.0200  0.01712  1.29768  0.3377
#> 3/DQ/82/WV   3 DQ 82 WV  1.0282 -0.6625 -0.22412  0.19258  0.7100  0.6180  0.5329  0.76333 -1.57999 -0.7712
#> 4/dz/2Z/Ho   4 dz 2Z Ho  0.8899 -0.2991 -0.80510  0.21457 -0.5298  0.8120 -1.5439  0.01906 -0.54662  1.0502
#> 5/E6/52/4O   5 E6 52 4O -0.2613  0.8889  0.12019  0.08753  0.5958 -0.2000  1.9294 -0.17313 -0.23542 -1.3361
#> 6/HI/iZ/gC   6 HI iZ gC -0.1375  0.3179  0.13538  0.17151  1.0346 -1.1203 -1.6141  0.28255  0.17247 -1.1894
#> 7/aC/5H/fQ   7 aC 5H fQ -1.9437  1.1840  0.09906 -0.87754 -0.2102 -2.1470 -0.7153 -0.06359  1.36304  0.9353
#> 8/6p/1x/Qj   8 6p 1x Qj  0.7421 -1.0991 -0.29958 -0.17075 -1.6146  1.4665  0.9140  1.09213 -1.38831  0.6388
#> 9/4X/ee/TP   9 4X ee TP -0.3370  0.5409  0.72458  0.81351 -0.5382 -0.6127  2.5273  1.65778  0.07733  0.7744
#> 10/bU/Xn/8g 10 bU Xn 8g  1.8828 -0.8664  0.98580 -0.86333 -2.2607 -0.2218 -0.8764 -0.72677 -1.51336 -1.7468
df[, 1] <- string
str_split_df(df, split = "/", type = "collumn", index = 1)
#>             X1 X2 X3 X4        X1.1    X2.1     X3.1     X4.1      X5      X6      X7       X8       X9     X10
#> 1/yv/9B/jC   1 yv 9B jC  1/yv/9B/jC  0.6871 -1.41393  1.05883 -1.3364 -1.4569  0.1602  0.60592 -0.49677 -1.2676
#> 2/xo/Vi/BH   2 xo Vi BH  2/xo/Vi/BH -2.3570 -0.64007  0.81509 -1.2416  0.6343 -1.0200  0.01712  1.29768  0.3377
#> 3/DQ/82/WV   3 DQ 82 WV  3/DQ/82/WV -0.6625 -0.22412  0.19258  0.7100  0.6180  0.5329  0.76333 -1.57999 -0.7712
#> 4/dz/2Z/Ho   4 dz 2Z Ho  4/dz/2Z/Ho -0.2991 -0.80510  0.21457 -0.5298  0.8120 -1.5439  0.01906 -0.54662  1.0502
#> 5/E6/52/4O   5 E6 52 4O  5/E6/52/4O  0.8889  0.12019  0.08753  0.5958 -0.2000  1.9294 -0.17313 -0.23542 -1.3361
#> 6/HI/iZ/gC   6 HI iZ gC  6/HI/iZ/gC  0.3179  0.13538  0.17151  1.0346 -1.1203 -1.6141  0.28255  0.17247 -1.1894
#> 7/aC/5H/fQ   7 aC 5H fQ  7/aC/5H/fQ  1.1840  0.09906 -0.87754 -0.2102 -2.1470 -0.7153 -0.06359  1.36304  0.9353
#> 8/6p/1x/Qj   8 6p 1x Qj  8/6p/1x/Qj -1.0991 -0.29958 -0.17075 -1.6146  1.4665  0.9140  1.09213 -1.38831  0.6388
#> 9/4X/ee/TP   9 4X ee TP  9/4X/ee/TP  0.5409  0.72458  0.81351 -0.5382 -0.6127  2.5273  1.65778  0.07733  0.7744
#> 10/bU/Xn/8g 10 bU Xn 8g 10/bU/Xn/8g -0.8664  0.98580 -0.86333 -2.2607 -0.2218 -0.8764 -0.72677 -1.51336 -1.7468
```
