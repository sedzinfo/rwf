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
#>                                 str1                              str2     num1
#> 1  O C Q DTPAY Z SX VBJUWNRMHLEF IKG KD FCPWYORTEX VB SIM J UG HQNLA Z  0.76496
#> 2  O C Q DTPAY Z SX VBJUWNRMHLEF IKG KD FCPWYORTEX VB SIM J UG HQNLA Z  1.73498
#> 3  O C Q DTPAY Z SX VBJUWNRMHLEF IKG KD FCPWYORTEX VB SIM J UG HQNLA Z -1.83870
#> 4  O C Q DTPAY Z SX VBJUWNRMHLEF IKG KD FCPWYORTEX VB SIM J UG HQNLA Z  2.24934
#> 5  O C Q DTPAY Z SX VBJUWNRMHLEF IKG KD FCPWYORTEX VB SIM J UG HQNLA Z  0.18747
#> 6  O C Q DTPAY Z SX VBJUWNRMHLEF IKG KD FCPWYORTEX VB SIM J UG HQNLA Z  0.57400
#> 7  O C Q DTPAY Z SX VBJUWNRMHLEF IKG KD FCPWYORTEX VB SIM J UG HQNLA Z  0.06403
#> 8  O C Q DTPAY Z SX VBJUWNRMHLEF IKG KD FCPWYORTEX VB SIM J UG HQNLA Z -1.80281
#> 9  O C Q DTPAY Z SX VBJUWNRMHLEF IKG KD FCPWYORTEX VB SIM J UG HQNLA Z  0.04258
#> 10 O C Q DTPAY Z SX VBJUWNRMHLEF IKG KD FCPWYORTEX VB SIM J UG HQNLA Z  1.14732
```
