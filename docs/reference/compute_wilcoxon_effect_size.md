# Compute Wilcoxon Effect Size

Computes the Wilcoxon rank-sum / signed-rank effect size r = abs(Z) /
sqrt(N), with Z derived from the p-value of stats::wilcox.test (Z =
qnorm(p / 2, lower.tail = FALSE)). This avoids a dependency on rstatix /
coin, using only stats::wilcox.test under the hood. The effect size
magnitude is computed from the two-sided p-value regardless of the
alternative used for the underlying hypothesis test.

## Usage

``` r
compute_wilcoxon_effect_size(
  formula,
  data,
  mu = 0,
  exact = NULL,
  correct = TRUE,
  ...
)
```

## Arguments

- formula:

  a formula of the form dv ~ group, same as used by stats::wilcox.test's
  formula method. Note: as with stats::wilcox.test's formula method,
  paired tests are not supported here; use stats::wilcox.test(x, y,
  paired = TRUE) directly for that case.

- data:

  data frame containing the variables in formula, same as
  stats::wilcox.test's data argument.

- mu:

  a number specifying an optional shift, same as stats::wilcox.test.

- exact:

  logical, as in stats::wilcox.test, indicating whether an exact p-value
  should be computed.

- correct:

  logical, as in stats::wilcox.test, indicating whether to apply the
  continuity correction.

- ...:

  additional arguments passed to stats::wilcox.test.

## Value

A single numeric value, the Wilcoxon effect size (r).

## Examples

``` r
compute_wilcoxon_effect_size(
  formula = bp_before ~ agegrp,
  data = df_blood_pressure[df_blood_pressure$agegrp %in% c("30-45", "46-59"), ]
)
#> [1] 0.1425689
rstatix::wilcox_effsize(bp_before ~ agegrp,
  data = df_blood_pressure[df_blood_pressure$agegrp %in% c("30-45", "46-59"), ]
)
#> # A tibble: 1 × 7
#>   .y.       group1 group2 effsize    n1    n2 magnitude
#> * <chr>     <chr>  <chr>    <dbl> <int> <int> <ord>    
#> 1 bp_before 30-45  46-59    0.143    40    40 small    
```
