# Trim whitespace from all character cells in a data frame

Applies [`base::strwrap()`](https://rdrr.io/r/base/strwrap.html) to
every character cell in a data frame, removing leading and trailing
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
#>                                 str1                              str2    num1
#> 1  BUK TDLJEH M ION WV PA C YSXRGZFQ KTA IV X H WLOCZS J D RFUQYBMPNGE  2.1481
#> 2  BUK TDLJEH M ION WV PA C YSXRGZFQ KTA IV X H WLOCZS J D RFUQYBMPNGE -0.5606
#> 3  BUK TDLJEH M ION WV PA C YSXRGZFQ KTA IV X H WLOCZS J D RFUQYBMPNGE  0.7167
#> 4  BUK TDLJEH M ION WV PA C YSXRGZFQ KTA IV X H WLOCZS J D RFUQYBMPNGE -1.2916
#> 5  BUK TDLJEH M ION WV PA C YSXRGZFQ KTA IV X H WLOCZS J D RFUQYBMPNGE  0.4709
#> 6  BUK TDLJEH M ION WV PA C YSXRGZFQ KTA IV X H WLOCZS J D RFUQYBMPNGE  0.2237
#> 7  BUK TDLJEH M ION WV PA C YSXRGZFQ KTA IV X H WLOCZS J D RFUQYBMPNGE  1.4664
#> 8  BUK TDLJEH M ION WV PA C YSXRGZFQ KTA IV X H WLOCZS J D RFUQYBMPNGE  1.0564
#> 9  BUK TDLJEH M ION WV PA C YSXRGZFQ KTA IV X H WLOCZS J D RFUQYBMPNGE -0.3610
#> 10 BUK TDLJEH M ION WV PA C YSXRGZFQ KTA IV X H WLOCZS J D RFUQYBMPNGE -2.0910
```
