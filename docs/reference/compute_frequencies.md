# Frequency table for categorical variables

Computes frequency counts, proportions, and percentages for every column
in a data frame. All columns are processed together and the results are
stacked into a single long-format table. Missing values are excluded
from the frequency counts via
[`table()`](https://rdrr.io/r/base/table.html). Results can be exported
to an Excel file.

## Usage

``` r
compute_frequencies(df, file = NULL)
```

## Arguments

- df:

  A data frame whose columns are the categorical variables to tabulate.
  All columns are processed regardless of class.

- file:

  Character string naming the output Excel file (without extension).
  When `NULL` (default) no file is written.

## Value

A data frame in long format with one row per observed level per
variable, containing the following columns:

- variable:

  Name of the column from `df`.

- Observation:

  Observed level (category label).

- Frequency:

  Count of observations at that level.

- Proportion:

  Relative frequency (Frequency / total for that variable).

- Percent:

  Proportion multiplied by 100.

## Examples

``` r
df = generate_missing(generate_factor(nrows = 10, ncols = 10), missing = 5)
compute_frequencies(df = df)
#>    variable Observation Frequency Proportion Percent
#> 1        X1           D         2        0.4      40
#> 2        X1           A         1        0.2      20
#> 3        X1           C         1        0.2      20
#> 4        X1           E         1        0.2      20
#> 5        X1           B         0        0.0       0
#> 6        X2           A         2        0.4      40
#> 7        X2           C         1        0.2      20
#> 8        X2           D         1        0.2      20
#> 9        X2           E         1        0.2      20
#> 10       X2           B         0        0.0       0
#> 11       X3           B         2        0.4      40
#> 12       X3           A         1        0.2      20
#> 13       X3           C         1        0.2      20
#> 14       X3           E         1        0.2      20
#> 15       X3           D         0        0.0       0
#> 16       X4           B         2        0.4      40
#> 17       X4           A         1        0.2      20
#> 18       X4           D         1        0.2      20
#> 19       X4           E         1        0.2      20
#> 20       X4           C         0        0.0       0
#> 21       X5           D         2        0.4      40
#> 22       X5           A         1        0.2      20
#> 23       X5           C         1        0.2      20
#> 24       X5           E         1        0.2      20
#> 25       X5           B         0        0.0       0
#> 26       X6           C         3        0.6      60
#> 27       X6           A         1        0.2      20
#> 28       X6           E         1        0.2      20
#> 29       X6           B         0        0.0       0
#> 30       X6           D         0        0.0       0
#> 31       X7           B         2        0.4      40
#> 32       X7           C         1        0.2      20
#> 33       X7           D         1        0.2      20
#> 34       X7           E         1        0.2      20
#> 35       X7           A         0        0.0       0
#> 36       X8           B         2        0.4      40
#> 37       X8           D         2        0.4      40
#> 38       X8           E         1        0.2      20
#> 39       X8           A         0        0.0       0
#> 40       X8           C         0        0.0       0
#> 41       X9           C         3        0.6      60
#> 42       X9           A         1        0.2      20
#> 43       X9           B         1        0.2      20
#> 44       X9           D         0        0.0       0
#> 45       X9           E         0        0.0       0
#> 46      X10           E         2        0.4      40
#> 47      X10           A         1        0.2      20
#> 48      X10           B         1        0.2      20
#> 49      X10           D         1        0.2      20
#> 50      X10           C         0        0.0       0
compute_frequencies(df = generate_factor())
#>    variable Observation Frequency Proportion Percent
#> 1        X1           A         1        0.5      50
#> 2        X1           C         1        0.5      50
#> 3        X1           B         0        0.0       0
#> 4        X1           D         0        0.0       0
#> 5        X1           E         0        0.0       0
#> 6        X2           A         2        1.0     100
#> 7        X2           B         0        0.0       0
#> 8        X2           C         0        0.0       0
#> 9        X2           D         0        0.0       0
#> 10       X2           E         0        0.0       0
#> 11       X3           C         1        0.5      50
#> 12       X3           D         1        0.5      50
#> 13       X3           A         0        0.0       0
#> 14       X3           B         0        0.0       0
#> 15       X3           E         0        0.0       0
#> 16       X4           C         1        0.5      50
#> 17       X4           E         1        0.5      50
#> 18       X4           A         0        0.0       0
#> 19       X4           B         0        0.0       0
#> 20       X4           D         0        0.0       0
#> 21       X5           A         1        0.5      50
#> 22       X5           E         1        0.5      50
#> 23       X5           B         0        0.0       0
#> 24       X5           C         0        0.0       0
#> 25       X5           D         0        0.0       0
#> 26       X6           A         2        1.0     100
#> 27       X6           B         0        0.0       0
#> 28       X6           C         0        0.0       0
#> 29       X6           D         0        0.0       0
#> 30       X6           E         0        0.0       0
#> 31       X7           D         1        0.5      50
#> 32       X7           E         1        0.5      50
#> 33       X7           A         0        0.0       0
#> 34       X7           B         0        0.0       0
#> 35       X7           C         0        0.0       0
#> 36       X8           D         2        1.0     100
#> 37       X8           A         0        0.0       0
#> 38       X8           B         0        0.0       0
#> 39       X8           C         0        0.0       0
#> 40       X8           E         0        0.0       0
#> 41       X9           D         1        0.5      50
#> 42       X9           E         1        0.5      50
#> 43       X9           A         0        0.0       0
#> 44       X9           B         0        0.0       0
#> 45       X9           C         0        0.0       0
#> 46      X10           B         1        0.5      50
#> 47      X10           D         1        0.5      50
#> 48      X10           A         0        0.0       0
#> 49      X10           C         0        0.0       0
#> 50      X10           E         0        0.0       0
compute_frequencies(df = generate_factor(), file = "descriptives")
#>    variable Observation Frequency Proportion Percent
#> 1        X1           A         1        0.5      50
#> 2        X1           D         1        0.5      50
#> 3        X1           B         0        0.0       0
#> 4        X1           C         0        0.0       0
#> 5        X1           E         0        0.0       0
#> 6        X2           D         1        0.5      50
#> 7        X2           E         1        0.5      50
#> 8        X2           A         0        0.0       0
#> 9        X2           B         0        0.0       0
#> 10       X2           C         0        0.0       0
#> 11       X3           B         1        0.5      50
#> 12       X3           D         1        0.5      50
#> 13       X3           A         0        0.0       0
#> 14       X3           C         0        0.0       0
#> 15       X3           E         0        0.0       0
#> 16       X4           B         2        1.0     100
#> 17       X4           A         0        0.0       0
#> 18       X4           C         0        0.0       0
#> 19       X4           D         0        0.0       0
#> 20       X4           E         0        0.0       0
#> 21       X5           A         2        1.0     100
#> 22       X5           B         0        0.0       0
#> 23       X5           C         0        0.0       0
#> 24       X5           D         0        0.0       0
#> 25       X5           E         0        0.0       0
#> 26       X6           D         2        1.0     100
#> 27       X6           A         0        0.0       0
#> 28       X6           B         0        0.0       0
#> 29       X6           C         0        0.0       0
#> 30       X6           E         0        0.0       0
#> 31       X7           E         2        1.0     100
#> 32       X7           A         0        0.0       0
#> 33       X7           B         0        0.0       0
#> 34       X7           C         0        0.0       0
#> 35       X7           D         0        0.0       0
#> 36       X8           A         1        0.5      50
#> 37       X8           E         1        0.5      50
#> 38       X8           B         0        0.0       0
#> 39       X8           C         0        0.0       0
#> 40       X8           D         0        0.0       0
#> 41       X9           A         1        0.5      50
#> 42       X9           D         1        0.5      50
#> 43       X9           B         0        0.0       0
#> 44       X9           C         0        0.0       0
#> 45       X9           E         0        0.0       0
#> 46      X10           A         1        0.5      50
#> 47      X10           B         1        0.5      50
#> 48      X10           C         0        0.0       0
#> 49      X10           D         0        0.0       0
#> 50      X10           E         0        0.0       0
```
