# Pairwise cross-tabulation of categorical variables

Computes contingency tables (frequency counts and percentages) for pairs
of categorical variables. Variable pairs can be supplied explicitly via
`combinations`, or all unique pairs within a set of columns can be
generated automatically via `factor_index`.

## Usage

``` r
compute_crosstable(df, factor_index = NULL, combinations = NULL)
```

## Arguments

- df:

  A data frame containing the variables to cross-tabulate.

- factor_index:

  Integer vector of column indices. When provided and `combinations` is
  `NULL`, all unique pairwise combinations of the selected columns are
  computed (self-pairs and duplicate pairs are excluded).

- combinations:

  A data frame with two character columns named `index1` and `index2`,
  each row specifying one variable pair to cross-tabulate. This argument
  takes precedence over `factor_index`.

## Value

A data frame with one row for each combination of levels of each pair of
variables, with the following columns:

- f1:

  Name of the first variable.

- f2:

  Name of the second variable.

- l1:

  Level of the first variable.

- l2:

  Level of the second variable.

- Frequency:

  Observed count for the `l1` × `l2` cell.

- Percent:

  Cell count as a percentage of all observations in that variable pair
  (`Frequency / total * 100`).

Variable pairs with zero total observations are silently dropped.

## Examples

``` r
combinations <- data.frame(index1 = c("vs", "am", "gear"), 
                           index2 = c("cyl", "cyl", "cyl"))
compute_crosstable(df = mtcars, combinations = combinations)
#>      f1  f2 l1 l2 Frequency Percent
#> 1    vs cyl  0  4         1   3.125
#> 2    vs cyl  1  4        10  31.250
#> 3    vs cyl  0  6         3   9.375
#> 4    vs cyl  1  6         4  12.500
#> 5    vs cyl  0  8        14  43.750
#> 6    vs cyl  1  8         0   0.000
#> 7    am cyl  0  4         3   9.375
#> 8    am cyl  1  4         8  25.000
#> 9    am cyl  0  6         4  12.500
#> 10   am cyl  1  6         3   9.375
#> 11   am cyl  0  8        12  37.500
#> 12   am cyl  1  8         2   6.250
#> 13 gear cyl  3  4         1   3.125
#> 14 gear cyl  4  4         8  25.000
#> 15 gear cyl  5  4         2   6.250
#> 16 gear cyl  3  6         2   6.250
#> 17 gear cyl  4  6         4  12.500
#> 18 gear cyl  5  6         1   3.125
#> 19 gear cyl  3  8        12  37.500
#> 20 gear cyl  4  8         0   0.000
#> 21 gear cyl  5  8         2   6.250
combinations <- data.frame(index1 = c("vs", "am"), 
                           index2 = c("cyl", "cyl"))
compute_crosstable(df = mtcars, combinations = combinations)
#>    f1  f2 l1 l2 Frequency Percent
#> 1  vs cyl  0  4         1   3.125
#> 2  vs cyl  1  4        10  31.250
#> 3  vs cyl  0  6         3   9.375
#> 4  vs cyl  1  6         4  12.500
#> 5  vs cyl  0  8        14  43.750
#> 6  vs cyl  1  8         0   0.000
#> 7  am cyl  0  4         3   9.375
#> 8  am cyl  1  4         8  25.000
#> 9  am cyl  0  6         4  12.500
#> 10 am cyl  1  6         3   9.375
#> 11 am cyl  0  8        12  37.500
#> 12 am cyl  1  8         2   6.250
compute_crosstable(df = mtcars, factor_index = 8:10)
#>      f1 f2 l1 l2 Frequency Percent
#> 1    am vs  0  0        12  37.500
#> 2    am vs  1  0         6  18.750
#> 3    am vs  0  1         7  21.875
#> 4    am vs  1  1         7  21.875
#> 5  gear vs  3  0        12  37.500
#> 6  gear vs  4  0         2   6.250
#> 7  gear vs  5  0         4  12.500
#> 8  gear vs  3  1         3   9.375
#> 9  gear vs  4  1        10  31.250
#> 10 gear vs  5  1         1   3.125
#> 11 gear am  3  0        15  46.875
#> 12 gear am  4  0         4  12.500
#> 13 gear am  5  0         0   0.000
#> 14 gear am  3  1         0   0.000
#> 15 gear am  4  1         8  25.000
#> 16 gear am  5  1         5  15.625
```
