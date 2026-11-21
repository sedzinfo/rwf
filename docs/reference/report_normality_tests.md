# Battery of normality tests

Runs eight normality tests on each numeric column of `df`. The tests are
Shapiro-Wilk, Anderson-Darling, Cramér-von Mises, Shapiro-Francia,
Jarque-Bera (the robust version of Gel and Gastwirth, 2008),
Kolmogorov-Smirnov, Lilliefors, and Pearson chi-squared. Each column is
z-standardised before testing. Columns with fewer than 8 or more than
4999 non-missing observations are skipped with a console message.
Results are printed to the console; when `file` is supplied they are
also written to a `.log` file and a colour-coded `.xlsx` file with
significant p-values (\\p \le 0.05\\) highlighted.

## Usage

``` r
report_normality_tests(df, file = NULL)
```

## Arguments

- df:

  Data frame or numeric vector.

- file:

  Character string naming the output files (without extension). When
  supplied, a `.log` and an `.xlsx` file are written. When `NULL`
  (default) no files are written.

## Value

Invisibly returns `NULL`. Called for its side effects of printing
results and optionally writing output files.

## Examples

``` r
file = file.path(tempdir(), "normality_tests")
vector <- generate_missing(rnorm(50), missing = 10)
df <- generate_missing(mtcars[, 1:2], missing = 10)
report_normality_tests(df = df)
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_normality_tests(df = vector, file = file)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
```
