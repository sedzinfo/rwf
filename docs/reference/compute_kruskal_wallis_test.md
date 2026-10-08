# Kruskal-Wallis Test with Effect Sizes

Runs a one-way Kruskal-Wallis rank-sum test and returns the test
statistic, p-value, and two effect sizes:

- `etasq`: eta-squared for Kruskal-Wallis (\\\eta_H^2\\)

- `epsilonsq`: epsilon-squared (\\\epsilon^2\\)

In simple terms, this tests whether groups differ in their
distributions, and quantifies how large that group effect is.

## Usage

``` r
compute_kruskal_wallis_test(
  formula,
  df,
  ci = FALSE,
  conf.level = 0.95,
  nboot = 1000
)
```

## Arguments

- formula:

  A one-way formula in the form `y ~ group`.

- df:

  A data frame containing the variables in `formula`.

- ci:

  If TRUE, adds percentile bootstrap confidence intervals for `etasq`
  and `epsilonsq`.

- conf.level:

  Confidence level of the intervals.

- nboot:

  Number of bootstrap resamples.

## Value

A one-row data frame with:

- `formula`: model formula used

- `method`: test name

- `etasq`: Kruskal-Wallis eta-squared, \\(H-k+1)/(n-k)\\

- `etasq_lower`, `etasq_upper`: confidence interval of `etasq` (only if
  `ci = TRUE`)

- `epsilonsq`: epsilon-squared, \\H/(n-1)\\

- `epsilonsq_lower`, `epsilonsq_upper`: confidence interval of
  `epsilonsq` (only if `ci = TRUE`)

- `H`: Kruskal-Wallis chi-squared statistic

- `df`: degrees of freedom (\\k-1\\)

- `p`: p-value

## Details

`epsilonsq` is in \[0, 1\]. `etasq` is at most 1 and is negative when
\\H \< k-1\\, that is when the groups differ less than expected by
chance. Multiplying by 100 gives an approximate percentage-style
interpretation of explained rank variance.

Rules of thumb for `etasq` and `epsilonsq`. Small, medium and large are
the \\\eta^2\\ benchmarks of Cohen (1988); tiny, very large and huge
convert the Cohen's d benchmarks of Sawilowsky (2009) with
\\\eta^2=d^2/(d^2+4)\\:

- tiny: \< 0.01 (d \< 0.2)

- small: 0.01 to \< 0.06 (d = 0.2)

- medium: 0.06 to \< 0.14 (d = 0.5)

- large: 0.14 to \< 0.26 (d = 0.8)

- very large: 0.26 to \< 0.50 (d = 1.2)

- huge: \>= 0.50 (d = 2.0)

These are rough guides; what counts as a meaningful effect depends on
the field. `epsilonsq` is biased upwards by about \\(k-1)/(n-1)\\ in
small samples.

Rows with a missing value in the outcome or the grouping variable are
removed before the test, as in
[`stats::kruskal.test`](https://rdrr.io/r/stats/kruskal.test.html).

The confidence intervals resample rows with replacement `nboot` times,
recompute both effect sizes in each resample and take the
\\(1-conf.level)/2\\ and \\1-(1-conf.level)/2\\ quantiles. Use
`set.seed` for reproducible intervals.

## References

Cohen, J. (1988). Statistical power analysis for the behavioral sciences
(2nd ed.). Lawrence Erlbaum Associates.

Sawilowsky, S. S. (2009). New effect size rules of thumb. Journal of
Modern Applied Statistical Methods, 8(2), 597-599.
[doi:10.22237/jmasm/1257035100](https://doi.org/10.22237/jmasm/1257035100)

Tomczak, M., & Tomczak, E. (2014). The need to report effect size
estimates revisited. An overview of some recommended measures of effect
size. Trends in Sport Sciences, 1(21), 19-25.

## Examples

``` r
form <- formula(bp_before ~ agegrp)
kruskal.test(formula = form, data = df_blood_pressure)
#> 
#>  Kruskal-Wallis rank sum test
#> 
#> data:  bp_before by agegrp
#> Kruskal-Wallis chi-squared = 19.564, df = 2, p-value = 5.645e-05
#> 
rcompanion::epsilonSquared(
  x = df_blood_pressure$bp_before,
  g = df_blood_pressure$agegrp,
  group = "row",
  ci = TRUE,
  conf = 0.95,
  type = "perc",
  R = 1000,
  digits = 3
)
#>   epsilon.squared lower.ci upper.ci
#> 1           0.164   0.0668    0.304
rstatix::kruskal_effsize(df_blood_pressure, form, ci = TRUE, conf.level = 0.95, ci.type = "perc", nboot = 100)
#> # A tibble: 1 × 7
#>   .y.           n effsize conf.low conf.high method  magnitude
#> * <chr>     <int>   <dbl>    <dbl>     <dbl> <chr>   <ord>    
#> 1 bp_before   120   0.150     0.04      0.33 eta2[H] large    
compute_kruskal_wallis_test(formula = form, df = df_blood_pressure)
#>              formula                       method     etasq epsilonsq        H df            p
#> 1 bp_before ~ agegrp Kruskal-Wallis rank sum test 0.1501232 0.1644069 19.56442  2 5.644699e-05
set.seed(1)
compute_kruskal_wallis_test(formula = form, df = df_blood_pressure, ci = TRUE)
#>              formula                       method     etasq etasq_lower etasq_upper epsilonsq epsilonsq_lower epsilonsq_upper        H df            p
#> 1 bp_before ~ agegrp Kruskal-Wallis rank sum test 0.1501232  0.05161268   0.2963859 0.1644069      0.06755196       0.3082114 19.56442  2 5.644699e-05
```
