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
#>                               str1                               str2     num1
#> 1  YDP CZS BJ T H EFGRXQKVOUWANLIM K B YOVZSN U C TE M GIHXPFAQ DLJRW  1.14732
#> 2  YDP CZS BJ T H EFGRXQKVOUWANLIM K B YOVZSN U C TE M GIHXPFAQ DLJRW -0.10770
#> 3  YDP CZS BJ T H EFGRXQKVOUWANLIM K B YOVZSN U C TE M GIHXPFAQ DLJRW  1.55877
#> 4  YDP CZS BJ T H EFGRXQKVOUWANLIM K B YOVZSN U C TE M GIHXPFAQ DLJRW -0.84610
#> 5  YDP CZS BJ T H EFGRXQKVOUWANLIM K B YOVZSN U C TE M GIHXPFAQ DLJRW  0.01738
#> 6  YDP CZS BJ T H EFGRXQKVOUWANLIM K B YOVZSN U C TE M GIHXPFAQ DLJRW -1.28735
#> 7  YDP CZS BJ T H EFGRXQKVOUWANLIM K B YOVZSN U C TE M GIHXPFAQ DLJRW -1.03497
#> 8  YDP CZS BJ T H EFGRXQKVOUWANLIM K B YOVZSN U C TE M GIHXPFAQ DLJRW  0.53473
#> 9  YDP CZS BJ T H EFGRXQKVOUWANLIM K B YOVZSN U C TE M GIHXPFAQ DLJRW  0.91150
#> 10 YDP CZS BJ T H EFGRXQKVOUWANLIM K B YOVZSN U C TE M GIHXPFAQ DLJRW -3.07672
```
