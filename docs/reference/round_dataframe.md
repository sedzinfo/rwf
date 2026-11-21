# Round numeric columns in a data frame

Applies a rounding or transformation function to every numeric column in
a data frame, leaving non-numeric columns (factor, character, etc.)
unchanged.

## Usage

``` r
round_dataframe(df, digits = 0, type = "round")
```

## Arguments

- df:

  A data frame containing a mix of numeric and non-numeric columns.

- digits:

  Integer number of decimal places. Only used with `type = "round"` and
  `type = "tenth"`. Default is `0`.

- type:

  Character string specifying the transformation to apply to numeric
  columns:

  `"round"`

  : Round to `digits` decimal places using
    [`round()`](https://rdrr.io/r/base/Round.html) (default).

  `"ceiling"`

  : Round up to the nearest integer using
    [`ceiling()`](https://rdrr.io/r/base/Round.html).

  `"floor"`

  : Round down to the nearest integer using
    [`floor()`](https://rdrr.io/r/base/Round.html).

  `"tenth"`

  : Divide each value by 10 then round to `digits` decimal places —
    useful for rescaling values that were multiplied by 10 (e.g.
    converting tenths back to units).

## Value

A data frame with the same structure as `df` where all numeric columns
have been rounded or transformed according to `type`.

## Examples

``` r
round_dataframe(df = change_data_type(df = mtcars, type = "factor"), digits = 0)
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
round_dataframe(df = change_data_type(df = mtcars, type = "character"), digits = 0)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
round_dataframe(df = mtcars, digits = 0)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
round_dataframe(df = mtcars, digits = 0, type = "ceiling")
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
round_dataframe(df = mtcars, digits = 0, type = "floor")
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
round_dataframe(df = mtcars * 100, digits = 2, type = "tenth")
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
```
