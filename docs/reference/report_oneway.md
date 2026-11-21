# One-Way ANOVA Report for Several Variables

For every combination of a dependent variable (`dv`) and a grouping
variable (`iv`), runs and collects in one report:

- Fisher's F test, assuming equal variances (`compute_one_way_test`)

- Welch's F test, not assuming equal variances (`compute_one_way_test`)

- the Kruskal-Wallis test (`compute_kruskal_wallis_test`)

- Levene's and Bartlett's tests of equal variances

- Tukey and Games-Howell post hoc comparisons (`compute_posthoc`)

with effect sizes, and a Bonferroni adjustment for the number of
combinations. The report can also be written to an Excel workbook, with
optional PDF plots.

In simple terms, this compares the group means of several outcomes
across several grouping variables at once, checks whether the groups
have equal variances, and shows which groups differ from which.

## Usage

``` r
report_oneway(
  df,
  dv,
  iv,
  file = NULL,
  w = 10,
  h = 10,
  base_size = 10,
  note = "",
  title = "",
  type = "ci",
  plot_means = FALSE,
  plot_diagnostics = FALSE,
  pb = FALSE
)
```

## Arguments

- df:

  A data frame.

- dv:

  Integer vector with the column indices of the numeric dependent
  variables.

- iv:

  Integer vector with the column indices of the grouping variables.

- file:

  Name of the output file, without the extension. If `NULL` (default),
  nothing is written.

- w:

  Width of the PDF pages, in inches.

- h:

  Height of the PDF pages, in inches.

- base_size:

  Base font size of the plots.

- note:

  Text for the footnote of the mean plots.

- title:

  Title of the mean plots.

- type:

  Error bars of the mean plots: `"ci"` (95% confidence interval,
  default), `"se"` (standard error), `"sd"` (standard deviation) or `""`
  (none).

- plot_means:

  If TRUE, writes plots of the group means to a PDF file.

- plot_diagnostics:

  If TRUE, writes ANOVA diagnostic plots to a PDF file.

- pb:

  Logical; whether to display a progress bar in the console.

## Value

A list with:

- `instructions`: short notes on when to use each test

- `fisher`, `welch`: one row per combination, with the output of
  `compute_one_way_test` (sums of squares, F, degrees of freedom,
  p-value, effect sizes and power)

- `kruskal_wallis`: the output of `compute_kruskal_wallis_test`, with
  one row per combination

- `tukey`, `games_howell`: one row per pair of groups in each
  combination, with the output of `compute_posthoc` (`LEVEL` names the
  pair)

- `homogeneity`: Levene's and Bartlett's tests for every combination

Every table has the columns `DV` and `IV`, `bonferroni_p` (the
Bonferroni-adjusted critical p-value) and `significant` (whether
`p < bonferroni_p`).

## Details

For each combination, rows with a missing value in the dependent or the
grouping variable are removed, and groups with a single observation are
dropped, because their variance cannot be estimated. Combinations left
with fewer than two groups are skipped.

The Bonferroni adjustment divides 0.05 by the number of combinations of
`dv` and `iv`; `significant` compares each p-value with that critical
value. The post hoc p-values are already adjusted for the pairs within
each combination.

Levene's test uses the deviations from the group means. Bartlett's test
is more powerful when the data are normal but sensitive to
non-normality. A significant result in either suggests unequal
variances.

Which test to read:

- Fisher's F assumes equal variances (homoscedasticity); use it with the
  Tukey post hoc test.

- Welch's F does not assume equal variances; use it with the
  Games-Howell post hoc test. It is the safer default when the variances
  or the group sizes differ.

- The Kruskal-Wallis test does not assume normality and suits ordinal or
  skewed outcomes, but it is not a remedy for unequal variances.

- The Tukey test (Tukey-Kramer) handles unequal group sizes but assumes
  equal variances.

- The Games-Howell test handles unequal group sizes and unequal
  variances.

The Excel workbook contains the sheets "Fisher", "Welch", "Kruskal",
"Homogeneity", "Tukey", "Games-Howell" and "Descriptives". The plots are
written to PDF files named after `file`. With `pb = TRUE`, a progress
bar is printed to the console while the tests run.

## References

Bartlett, M. S. (1937). Properties of sufficiency and statistical tests.
Proceedings of the Royal Society of London. Series A, 160(901), 268-282.
[doi:10.1098/rspa.1937.0109](https://doi.org/10.1098/rspa.1937.0109)

Dunn, O. J. (1961). Multiple comparisons among means. Journal of the
American Statistical Association, 56(293), 52-64.
[doi:10.1080/01621459.1961.10482090](https://doi.org/10.1080/01621459.1961.10482090)

Games, P. A., & Howell, J. F. (1976). Pairwise multiple comparison
procedures with unequal n's and/or variances: A Monte Carlo study.
Journal of Educational Statistics, 1(2), 113-125.
[doi:10.3102/10769986001002113](https://doi.org/10.3102/10769986001002113)

Kramer, C. Y. (1956). Extension of multiple range tests to group means
with unequal numbers of replications. Biometrics, 12(3), 307-310.
[doi:10.2307/3001469](https://doi.org/10.2307/3001469)

Kruskal, W. H., & Wallis, W. A. (1952). Use of ranks in one-criterion
variance analysis. Journal of the American Statistical Association,
47(260), 583-621.
[doi:10.1080/01621459.1952.10483441](https://doi.org/10.1080/01621459.1952.10483441)

Levene, H. (1960). Robust tests for equality of variances. In I. Olkin
(Ed.), Contributions to probability and statistics: Essays in honor of
Harold Hotelling (pp. 278-292). Stanford University Press.

Welch, B. L. (1951). On the comparison of several mean values: An
alternative approach. Biometrika, 38(3/4), 330-336.
[doi:10.2307/2332579](https://doi.org/10.2307/2332579)

## See also

[`compute_one_way_test`](https://sedzinfo.github.io/rwf/reference/compute_one_way_test.md),
[`compute_kruskal_wallis_test`](https://sedzinfo.github.io/rwf/reference/compute_kruskal_wallis_test.md),
[`compute_posthoc`](https://sedzinfo.github.io/rwf/reference/compute_posthoc.md)

## Examples

``` r
report_oneway(
  df = df_blood_pressure,
  dv = c(
    which("bp_before" == names(df_blood_pressure)),
    which("bp_after" == names(df_blood_pressure))
  ),
  iv = c(
    which("sex" == names(df_blood_pressure)),
    which("agegrp" == names(df_blood_pressure))
  ),
  file = file.path(tempdir(), "anova"),
  plot_diagnostics = FALSE,
  plot_means = FALSE
)
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_oneway(df = mtcars, dv = 2:4, iv = 9:10,
              file = file.path(tempdir(), "anova_oneway_two_factor"))
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_oneway(df = mtcars, dv = 2:4, iv = 9, file = file.path(tempdir(), "anova_oneway_one_factor"))
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_oneway(
  df = mtcars, dv = 2:4, iv = 9, file = file.path(tempdir(), "anova_oneway_one_factor"),
  plot_means = TRUE, plot_diagnostics = TRUE
)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
```
