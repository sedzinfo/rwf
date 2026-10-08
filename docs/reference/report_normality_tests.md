# Battery of normality tests

Runs eight normality tests on each numeric column of `df`: Shapiro-Wilk,
Anderson-Darling, Cramér-von Mises, Shapiro-Francia, Jarque-Bera,
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
vector <- generate_missing(rnorm(50), missing = 10)
df <- generate_missing(mtcars[, 1:2], missing = 10)
report_normality_tests(df = df)
#> [1] "##################################################"
#> [1] "NORMALITY TESTS"
#> [1] "##################################################"
#> [1] ""
#> [1] "#########################"
#>    variable  n statistic df            p                                         method alternative n.classes
#> 1       mpg 22   0.94351 NA 0.2336273805                    Shapiro-Wilk normality test        <NA>        NA
#> 2       mpg 22   0.44630 NA 0.8001836686       Anderson-Darling test of goodness-of-fit        <NA>        NA
#> 3       mpg 22   0.07085 NA 0.2597518367                Cramer-von Mises normality test        <NA>        NA
#> 4       mpg 22   0.95197 NA 0.2938563796                 Shapiro-Francia normality test        <NA>        NA
#> 5       mpg 22   1.17648  2 0.5553028005                        Robust Jarque Bera Test        <NA>        NA
#> 6       mpg 22   0.14383 NA 0.2776302746 Lilliefors (Kolmogorov-Smirnov) normality test        <NA>        NA
#> 7       mpg 22   0.14383 NA 0.7529607263  Asymptotic one-sample Kolmogorov-Smirnov test   two-sided        NA
#> 8       mpg 22   5.36364  4 0.2519785081              Pearson chi-square normality test        <NA>         7
#> 9       cyl 22   0.73970 NA 0.0000654667                    Shapiro-Wilk normality test        <NA>        NA
#> 10      cyl 22   2.37833 NA 0.0579950719       Anderson-Darling test of goodness-of-fit        <NA>        NA
#> 11      cyl 22   0.34675 NA 0.0000812074                Cramer-von Mises normality test        <NA>        NA
#> 12      cyl 22   0.76570 NA 0.0003442400                 Shapiro-Francia normality test        <NA>        NA
#> 13      cyl 22   1.79943  2 0.4066847330                        Robust Jarque Bera Test        <NA>        NA
#> 14      cyl 22   0.29271 NA 0.0000316411 Lilliefors (Kolmogorov-Smirnov) normality test        <NA>        NA
#> 15      cyl 22   0.29271 NA 0.0461132930  Asymptotic one-sample Kolmogorov-Smirnov test   two-sided        NA
#> 16      cyl 22  35.27273  4 0.0000004083              Pearson chi-square normality test        <NA>         7
#>                                                                                                             instruction
#> 1                                                       Shapiro-Wilk Composite null hypothesis: any normal distribution
#> 2                                                   Anderson-Darling Composite null hypothesis: any normal distribution
#> 3                                                   Cramer-von-Mises Composite null hypothesis: any normal distribution
#> 4                                                    Shapiro-Francia Composite null hypothesis: any normal distribution
#> 5                                                        Jarque-Bera Composite null hypothesis: any normal distribution
#> 6                                                         Lilliefors Composite null hypothesis: any normal distribution
#> 7  Kolmogorov-Smirnov Exact null hypothesis: fully specified normal distribution (ties present, p value is approximate)
#> 8   Pearson X2 Tests weaker null hypothesis: any distribution with the same probabilities for the given class intervals
#> 9                                                       Shapiro-Wilk Composite null hypothesis: any normal distribution
#> 10                                                  Anderson-Darling Composite null hypothesis: any normal distribution
#> 11                                                  Cramer-von-Mises Composite null hypothesis: any normal distribution
#> 12                                                   Shapiro-Francia Composite null hypothesis: any normal distribution
#> 13                                                       Jarque-Bera Composite null hypothesis: any normal distribution
#> 14                                                        Lilliefors Composite null hypothesis: any normal distribution
#> 15 Kolmogorov-Smirnov Exact null hypothesis: fully specified normal distribution (ties present, p value is approximate)
#> 16  Pearson X2 Tests weaker null hypothesis: any distribution with the same probabilities for the given class intervals
#> NULL
report_normality_tests(df = vector, file = "normality_tests")
#> [1] "##################################################"
#> [1] "NORMALITY TESTS"
#> [1] "##################################################"
#> [1] ""
#> [1] "#########################"
#>   variable  n statistic df      p                                         method alternative n.classes
#> 1       df 40   0.97618 NA 0.5503                    Shapiro-Wilk normality test        <NA>        NA
#> 2       df 40   0.37883 NA 0.8687       Anderson-Darling test of goodness-of-fit        <NA>        NA
#> 3       df 40   0.06275 NA 0.3399                Cramer-von Mises normality test        <NA>        NA
#> 4       df 40   0.97759 NA 0.5134                 Shapiro-Francia normality test        <NA>        NA
#> 5       df 40   1.00849  2 0.6040                        Robust Jarque Bera Test        <NA>        NA
#> 6       df 40   0.11583 NA 0.1935 Lilliefors (Kolmogorov-Smirnov) normality test        <NA>        NA
#> 7       df 40   0.11583 NA 0.6151       Exact one-sample Kolmogorov-Smirnov test   two-sided        NA
#> 8       df 40   8.15000  6 0.2273              Pearson chi-square normality test        <NA>         9
#>                                                                                                           instruction
#> 1                                                     Shapiro-Wilk Composite null hypothesis: any normal distribution
#> 2                                                 Anderson-Darling Composite null hypothesis: any normal distribution
#> 3                                                 Cramer-von-Mises Composite null hypothesis: any normal distribution
#> 4                                                  Shapiro-Francia Composite null hypothesis: any normal distribution
#> 5                                                      Jarque-Bera Composite null hypothesis: any normal distribution
#> 6                                                       Lilliefors Composite null hypothesis: any normal distribution
#> 7                                       Kolmogorov-Smirnov Exact null hypothesis: fully specified normal distribution
#> 8 Pearson X2 Tests weaker null hypothesis: any distribution with the same probabilities for the given class intervals
#> NULL
```
