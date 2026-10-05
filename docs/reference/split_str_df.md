# Split a string column or row names in a data frame into separate columns

Splits a delimited string — either from row names or a specified column
— and prepends the resulting parts as new columns to the data frame.

## Usage

``` r
split_str_df(df, split = "/", type = "row", index, ...)
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
  [`split_str`](https://sedzinfo.github.io/rwf/reference/split_str.md).

## Value

A data frame with the split parts prepended as new columns, followed by
the original columns of `df`.

## See also

[`split_str`](https://sedzinfo.github.io/rwf/reference/split_str.md)

## Examples

``` r
df<-generate_correlation_matrix()
string<-paste0(1:nrow(df),"/",
               generate_string(nchar=2,vector_length=nrow(df)),"/",
               generate_string(nchar=2,vector_length=nrow(df)),"/",
               generate_string(nchar=2,vector_length=nrow(df)))
row.names(df)<-string
split_str_df(df,split="/",type="row")
#>             X1 X2 X3 X4     X1.1     X2.1    X3.1    X4.1       X5       X6      X7      X8      X9      X10
#> 1/36/l9/lU   1 36 l9 lU  1.04893  1.79565 -0.6492  1.5664  0.47028 -1.28105  1.1235 -1.2460 -1.6611  1.30895
#> 2/xN/Hg/6F   2 xN Hg 6F -0.03332  1.06540  0.1620 -0.8575 -0.80892 -0.11693  0.3616 -0.9486  0.4610 -0.82077
#> 3/Cp/1V/dT   3 Cp 1V dT -1.19467 -0.30959  0.9639  0.7247 -0.02675  1.94821  0.3133  0.9916  0.4518  1.25972
#> 4/0A/Wq/rD   4 0A Wq rD  1.57968  0.57108  1.0985  1.1842 -0.22987  0.80735 -0.1985  0.3354  0.8270 -0.17282
#> 5/0M/xh/zZ   5 0M xh zZ  1.06210 -0.51993  1.2677  1.4146 -0.72530  1.04822 -1.4909 -2.3841  1.4014 -0.23837
#> 6/cl/4a/Qe   6 cl 4a Qe -0.59785 -1.04960 -0.6237  1.5585 -0.42596  0.06129  0.1647  0.8393  0.6548 -0.94387
#> 7/ne/k4/Wa   7 ne k4 Wa  2.34955  0.08238 -0.3837 -0.3828 -0.16507 -0.50489 -1.2331 -1.5700 -0.3363  0.11692
#> 8/zA/Ba/aC   8 zA Ba aC  1.01641  0.14942  1.1559 -0.3076  0.69598  0.66733 -0.9380  1.3293  0.9407  1.57286
#> 9/2M/VO/1P   9 2M VO 1P  0.91118 -2.45914 -0.3563 -0.3728  0.29088  0.65588  0.9739  0.3094 -0.1346 -0.16139
#> 10/IG/6j/9P 10 IG 6j 9P -0.76379 -0.34879 -0.1575  0.6524 -0.50372  0.26231  0.4198  0.1651 -1.7970  0.08575
df[,1]<-string
split_str_df(df,split="/",type="collumn",index=1)
#>             X1 X2 X3 X4        X1.1     X2.1    X3.1    X4.1       X5       X6      X7      X8      X9      X10
#> 1/36/l9/lU   1 36 l9 lU  1/36/l9/lU  1.79565 -0.6492  1.5664  0.47028 -1.28105  1.1235 -1.2460 -1.6611  1.30895
#> 2/xN/Hg/6F   2 xN Hg 6F  2/xN/Hg/6F  1.06540  0.1620 -0.8575 -0.80892 -0.11693  0.3616 -0.9486  0.4610 -0.82077
#> 3/Cp/1V/dT   3 Cp 1V dT  3/Cp/1V/dT -0.30959  0.9639  0.7247 -0.02675  1.94821  0.3133  0.9916  0.4518  1.25972
#> 4/0A/Wq/rD   4 0A Wq rD  4/0A/Wq/rD  0.57108  1.0985  1.1842 -0.22987  0.80735 -0.1985  0.3354  0.8270 -0.17282
#> 5/0M/xh/zZ   5 0M xh zZ  5/0M/xh/zZ -0.51993  1.2677  1.4146 -0.72530  1.04822 -1.4909 -2.3841  1.4014 -0.23837
#> 6/cl/4a/Qe   6 cl 4a Qe  6/cl/4a/Qe -1.04960 -0.6237  1.5585 -0.42596  0.06129  0.1647  0.8393  0.6548 -0.94387
#> 7/ne/k4/Wa   7 ne k4 Wa  7/ne/k4/Wa  0.08238 -0.3837 -0.3828 -0.16507 -0.50489 -1.2331 -1.5700 -0.3363  0.11692
#> 8/zA/Ba/aC   8 zA Ba aC  8/zA/Ba/aC  0.14942  1.1559 -0.3076  0.69598  0.66733 -0.9380  1.3293  0.9407  1.57286
#> 9/2M/VO/1P   9 2M VO 1P  9/2M/VO/1P -2.45914 -0.3563 -0.3728  0.29088  0.65588  0.9739  0.3094 -0.1346 -0.16139
#> 10/IG/6j/9P 10 IG 6j 9P 10/IG/6j/9P -0.34879 -0.1575  0.6524 -0.50372  0.26231  0.4198  0.1651 -1.7970  0.08575
```
