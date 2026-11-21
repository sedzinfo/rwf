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
#>                                 str1                              str2     num1
#> 1  W HTM U SCPYXG DF RABQVJILOK N ZE NTE GOQP LHY UJMFAXR KV WZB CDI S  0.85780
#> 2  W HTM U SCPYXG DF RABQVJILOK N ZE NTE GOQP LHY UJMFAXR KV WZB CDI S  1.83525
#> 3  W HTM U SCPYXG DF RABQVJILOK N ZE NTE GOQP LHY UJMFAXR KV WZB CDI S -0.04390
#> 4  W HTM U SCPYXG DF RABQVJILOK N ZE NTE GOQP LHY UJMFAXR KV WZB CDI S -0.36665
#> 5  W HTM U SCPYXG DF RABQVJILOK N ZE NTE GOQP LHY UJMFAXR KV WZB CDI S -1.89182
#> 6  W HTM U SCPYXG DF RABQVJILOK N ZE NTE GOQP LHY UJMFAXR KV WZB CDI S  1.22808
#> 7  W HTM U SCPYXG DF RABQVJILOK N ZE NTE GOQP LHY UJMFAXR KV WZB CDI S  0.06309
#> 8  W HTM U SCPYXG DF RABQVJILOK N ZE NTE GOQP LHY UJMFAXR KV WZB CDI S -1.02485
#> 9  W HTM U SCPYXG DF RABQVJILOK N ZE NTE GOQP LHY UJMFAXR KV WZB CDI S  0.05602
#> 10 W HTM U SCPYXG DF RABQVJILOK N ZE NTE GOQP LHY UJMFAXR KV WZB CDI S -0.40787
```
