# Friedman Test with Effect Size

Runs the Friedman rank-sum test for a complete block design (repeated
measures) and returns the test statistic, p-value, and Kendall's W
(`kendall_w`) as the effect size.

In simple terms, this tests whether the same subjects (blocks) respond
differently across conditions (groups), and quantifies how consistently
the subjects rank the conditions in the same order.

## Usage

``` r
compute_friedman_test(formula, df, ci = FALSE, conf.level = 0.95, nboot = 1000)
```

## Arguments

- formula:

  A formula in the form `y ~ group | block`, where `group` is the
  repeated condition and `block` identifies the subject.

- df:

  A data frame in long format containing the variables in `formula`,
  with one row per block and group.

- ci:

  If TRUE, adds a percentile bootstrap confidence interval for
  `kendall_w`.

- conf.level:

  Confidence level of the interval.

- nboot:

  Number of bootstrap resamples.

## Value

A one-row data frame with:

- `formula`: model formula used

- `method`: test name

- `kendall_w`: Kendall's coefficient of concordance, \\Q/(n(k-1))\\

- `kendall_w_lower`, `kendall_w_upper`: confidence interval of
  `kendall_w` (only if `ci = TRUE`)

- `Q`: Friedman chi-squared statistic, corrected for ties

- `df`: degrees of freedom (\\k-1\\)

- `n`: number of complete blocks used

- `p`: p-value

## Details

The observations are ranked within each block. With \\n\\ blocks, \\k\\
groups, \\R_j\\ the rank sum of group \\j\\ and \\t\\ the sizes of the
groups of tied values within blocks,
\$\$Q=\frac{12\sum\_{j=1}^{k}\left(R_j-n(k+1)/2\right)^2}{nk(k+1)-\sum(t^3-t)/(k-1)}\$\$
Under the null hypothesis \\Q\\ approximately follows a chi-squared
distribution with \\k-1\\ degrees of freedom.

`kendall_w` is in \[0, 1\]. 0 means the blocks rank the groups in no
consistent order; 1 means every block ranks the groups in the same
order.

Rules of thumb for `kendall_w`, the Cohen (1988) benchmarks for
correlations that
[`rstatix::friedman_effsize`](https://rpkgs.datanovia.com/rstatix/reference/friedman_effsize.html)
also uses:

- tiny: \< 0.1

- small: 0.1 to \< 0.3

- medium: 0.3 to \< 0.5

- large: \>= 0.5

These are rough guides; what counts as a meaningful effect depends on
the field.

Rows with a missing group or block are removed. Blocks with a missing
value in any group are removed, as in the default method of
[`stats::friedman.test`](https://rdrr.io/r/stats/friedman.test.html);
`n` reports how many blocks remain. A block with more than one
observation for the same group is an error.

The confidence interval resamples blocks with replacement `nboot` times,
recomputes `kendall_w` in each resample and takes the
\\(1-conf.level)/2\\ and \\1-(1-conf.level)/2\\ quantiles. Use
`set.seed` for reproducible intervals.

## References

Cohen, J. (1988). Statistical power analysis for the behavioral sciences
(2nd ed.). Lawrence Erlbaum Associates.

Friedman, M. (1937). The use of ranks to avoid the assumption of
normality implicit in the analysis of variance. Journal of the American
Statistical Association, 32(200), 675-701.
[doi:10.1080/01621459.1937.10503522](https://doi.org/10.1080/01621459.1937.10503522)

Kendall, M. G., & Babington Smith, B. (1939). The problem of m rankings.
The Annals of Mathematical Statistics, 10(3), 275-287.
[doi:10.1214/aoms/1177732186](https://doi.org/10.1214/aoms/1177732186)

## Examples

``` r
form <- formula(uptake ~ conc | Plant)
friedman.test(formula = form, data = df_co2)
#> 
#>  Friedman rank sum test
#> 
#> data:  uptake and conc and Plant
#> Friedman chi-squared = 59.677, df = 6, p-value = 5.236e-11
#> 
rstatix::friedman_effsize(df_co2, form, ci = TRUE, conf.level = 0.95, ci.type = "perc", nboot = 100)
#> # A tibble: 1 × 7
#>   .y.        n effsize conf.low conf.high method    magnitude
#> * <chr>  <int>   <dbl>    <dbl>     <dbl> <chr>     <ord>    
#> 1 uptake    12   0.829     0.73      0.92 Kendall W large    
effectsize::kendalls_w(form, data = df_co2)
#> Warning: 1 block(s) contain ties.
#> Kendall's W |       95% CI
#> --------------------------
#> 0.83        | [0.77, 1.00]
#> 
#> - One-sided CIs: upper bound fixed at [1.00].
compute_friedman_test(formula = form, df = df_co2)
#>                 formula                 method kendall_w        Q df  n            p
#> 1 uptake ~ conc | Plant Friedman rank sum test 0.8288423 59.67665  6 12 5.235869e-11
set.seed(1)
compute_friedman_test(formula = form, df = df_co2, ci = TRUE)
#>                 formula                 method kendall_w kendall_w_lower kendall_w_upper        Q df  n            p
#> 1 uptake ~ conc | Plant Friedman rank sum test 0.8288423       0.7565647       0.9340429 59.67665  6 12 5.235869e-11
```
