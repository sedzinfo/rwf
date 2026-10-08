# Trim whitespace from all character cells in a data frame

Applies [`strwrap`](https://rdrr.io/r/base/strwrap.html) to every
character cell in a data frame, removing leading and trailing
whitespace.

## Usage

``` r
str_trim_df(df)
```

## Arguments

- df:

  A data frame containing one or more character columns.

## Value

A data frame of the same dimensions with whitespace trimmed from all
character cells. Non-character cells are unchanged.

## Examples

``` r
string <- data.frame(
  str1 = rep(paste0(sample(c(LETTERS, rep(" ", 10))), collapse = ""), 10),
  str2 = rep(paste0(sample(c(LETTERS, rep(" ", 10))), collapse = ""), 10),
  num1 = rnorm(10),
  stringsAsFactors = FALSE
)
str_trim_df(string)
#>                                   str1                             str2     num1
#> 1  HTM U SCPYXG DFW ZAB VJINQL O E K R E QPNLHZY TUJMFA OKX W BRDCI SGV -1.89182
#> 2  HTM U SCPYXG DFW ZAB VJINQL O E K R E QPNLHZY TUJMFA OKX W BRDCI SGV  1.22808
#> 3  HTM U SCPYXG DFW ZAB VJINQL O E K R E QPNLHZY TUJMFA OKX W BRDCI SGV  0.06309
#> 4  HTM U SCPYXG DFW ZAB VJINQL O E K R E QPNLHZY TUJMFA OKX W BRDCI SGV -1.02485
#> 5  HTM U SCPYXG DFW ZAB VJINQL O E K R E QPNLHZY TUJMFA OKX W BRDCI SGV  0.05602
#> 6  HTM U SCPYXG DFW ZAB VJINQL O E K R E QPNLHZY TUJMFA OKX W BRDCI SGV -0.40787
#> 7  HTM U SCPYXG DFW ZAB VJINQL O E K R E QPNLHZY TUJMFA OKX W BRDCI SGV -0.56319
#> 8  HTM U SCPYXG DFW ZAB VJINQL O E K R E QPNLHZY TUJMFA OKX W BRDCI SGV -0.78485
#> 9  HTM U SCPYXG DFW ZAB VJINQL O E K R E QPNLHZY TUJMFA OKX W BRDCI SGV  0.44729
#> 10 HTM U SCPYXG DFW ZAB VJINQL O E K R E QPNLHZY TUJMFA OKX W BRDCI SGV -0.79364
```
