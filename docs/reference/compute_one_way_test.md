# One-Way ANOVA with Effect Sizes and Power

Runs a one-way analysis of variance for two or more independent groups,
assuming equal variances (Fisher's F test) or not (Welch's F test), and
returns the sums of squares, mean squares, F statistic, p-value,
observed power, and five effect sizes:

- `etasq`: eta-squared (\\\eta^2\\)

- `partial.etasq`: partial eta-squared (\\\eta^2_p\\)

- `omegasq`: omega-squared (\\\omega^2\\)

- `partial.omegasq`: partial omega-squared (\\\omega^2_p\\)

- `cohens.f`: Cohen's f

In simple terms, this tests whether the group means differ, and
quantifies how much of the variance in the outcome the groups explain.

## Usage

``` r
compute_one_way_test(formula, df, var.equal = TRUE)
```

## Source

The group statistics and the Welch test (the weights, the Welch F
statistic and its degrees of freedom) are adapted from
[`stats::oneway.test`](https://rdrr.io/r/stats/oneway.test.html) (R Core
Team, R package `stats`, licensed GPL-2 \| GPL-3). The sums of squares,
effect sizes and power are added in rwf.

## Arguments

- formula:

  A one-way formula in the form `y ~ group`.

- df:

  A data frame containing the variables in `formula`.

- var.equal:

  If TRUE, assumes equal variances (Fisher's F test). If FALSE, uses
  Welch's F test.

## Value

A one-row data frame with:

- `formula`: model formula used

- `method`: "Assuming homoscedasticity" (Fisher) or "Assuming
  heteroscedasticity" (Welch)

- `ss_effect`, `ss_error`: sums of squares between and within groups

- `ms_effect`, `ms_error`: mean squares, \\SS/df\\

- `etasq`: eta-squared, \\SS\_{effect}/SS\_{total}\\

- `partial.etasq`: partial eta-squared,
  \\SS\_{effect}/(SS\_{effect}+SS\_{error})\\

- `omegasq`: omega-squared, \\(SS\_{effect}-df\_{effect}
  MS\_{error})/(SS\_{total}+MS\_{error})\\

- `partial.omegasq`: partial omega-squared,
  \\df\_{effect}(MS\_{effect}-MS\_{error})/(df\_{effect}
  MS\_{effect}+(df\_{error}+1) MS\_{error})\\

- `cohens.f`: Cohen's f, \\\sqrt{\eta^2/(1-\eta^2)}\\

- `power`: observed power of the F test at \\\alpha = 0.05\\

- `statistic`: F statistic, \\MS\_{effect}/MS\_{error}\\

- `df_effect`: degrees of freedom of the effect (\\k-1\\)

- `df_error`: degrees of freedom of the error (\\N-k\\, or the Welch
  degrees of freedom)

- `p`: p-value

## Details

In a one-way design `partial.etasq` equals `etasq` and `partial.omegasq`
equals `omegasq`. `etasq` and `partial.etasq` are in \[0, 1\] and are
biased upwards in small samples, by about \\(k-1)/(N-1)\\ when there is
no effect. `omegasq` and `partial.omegasq` remove most of that bias and
are negative when \\F \< 1\\. Multiplying `etasq` or `omegasq` by 100
gives the percentage of variance explained by the groups.

Rules of thumb for `etasq`, `omegasq` and `cohens.f`. Small, medium and
large are the benchmarks of Cohen (1988); tiny, very large and huge
convert the Cohen's d benchmarks of Sawilowsky (2009) with
\\\eta^2=d^2/(d^2+4)\\ and \\f=d/2\\:

- tiny: \\\eta^2\\ \< 0.01, f \< 0.10 (d \< 0.2)

- small: \\\eta^2\\ 0.01 to \< 0.06, f 0.10 to \< 0.25 (d = 0.2)

- medium: \\\eta^2\\ 0.06 to \< 0.14, f 0.25 to \< 0.40 (d = 0.5)

- large: \\\eta^2\\ 0.14 to \< 0.26, f 0.40 to \< 0.60 (d = 0.8)

- very large: \\\eta^2\\ 0.26 to \< 0.50, f 0.60 to \< 1.00 (d = 1.2)

- huge: \\\eta^2\\ \>= 0.50, f \>= 1.00 (d = 2.0)

These are rough guides; what counts as a meaningful effect depends on
the field.

`power` uses the noncentral F distribution with noncentrality parameter
\\\lambda = f^2 N\\ (Cohen, 1988), evaluated at the observed `cohens.f`.
Observed power is a function of the p-value and adds no information to
it (Hoenig & Heisey, 2001); use power analysis with an expected effect
size to plan a study, for example with
[`pwr::pwr.anova.test`](https://rdrr.io/pkg/pwr/man/pwr.anova.test.html).

Welch's test (Welch, 1951) has no sums of squares. With
`var.equal = FALSE`, `ms_effect` and `ms_error` are the numerator and
denominator of the Welch F statistic and `ss_effect` and `ss_error` are
\\MS \times df\\. The resulting `etasq`, `omegasq`, `partial.omegasq`
and `cohens.f` equal the conversions of the Welch F statistic in
[`effectsize::F_to_eta2`](https://easystats.github.io/effectsize/reference/F_to_eta2.html),
[`effectsize::F_to_omega2`](https://easystats.github.io/effectsize/reference/F_to_eta2.html)
and
[`effectsize::F_to_f`](https://easystats.github.io/effectsize/reference/F_to_eta2.html).
Treat the Welch effect sizes as approximations.

Rows with a missing value in the outcome or the grouping variable are
removed before the test, as in
[`stats::oneway.test`](https://rdrr.io/r/stats/oneway.test.html).

## References

Cohen, J. (1988). Statistical power analysis for the behavioral sciences
(2nd ed.). Lawrence Erlbaum Associates.

Hoenig, J. M., & Heisey, D. M. (2001). The abuse of power: The pervasive
fallacy of power calculations for data analysis. The American
Statistician, 55(1), 19-24.
[doi:10.1198/000313001300339897](https://doi.org/10.1198/000313001300339897)

Olejnik, S., & Algina, J. (2003). Generalized eta and omega squared
statistics: Measures of effect size for some common research designs.
Psychological Methods, 8(4), 434-447.
[doi:10.1037/1082-989X.8.4.434](https://doi.org/10.1037/1082-989X.8.4.434)

R Core Team (2026). R: A language and environment for statistical
computing. R Foundation for Statistical Computing, Vienna, Austria.
[doi:10.32614/R.manuals](https://doi.org/10.32614/R.manuals)

Sawilowsky, S. S. (2009). New effect size rules of thumb. Journal of
Modern Applied Statistical Methods, 8(2), 597-599.
[doi:10.22237/jmasm/1257035100](https://doi.org/10.22237/jmasm/1257035100)

Welch, B. L. (1951). On the comparison of several mean values: An
alternative approach. Biometrika, 38(3/4), 330-336.
[doi:10.2307/2332579](https://doi.org/10.2307/2332579)

## Examples

``` r
form <- formula(bp_before ~ agegrp)
oneway.test(formula = form, data = df_blood_pressure, var.equal = TRUE)
#> 
#>  One-way analysis of means
#> 
#> data:  bp_before and agegrp
#> F = 11.226, num df = 2, denom df = 117, p-value = 3.467e-05
#> 
oneway.test(formula = form, data = df_blood_pressure, var.equal = FALSE)
#> 
#>  One-way analysis of means (not assuming equal variances)
#> 
#> data:  bp_before and agegrp
#> F = 11.899, num df = 2.000, denom df = 77.347, p-value = 3.122e-05
#> 
car::Anova(aov(form, data = df_blood_pressure), type = 2)
#> Anova Table (Type II tests)
#> 
#> Response: bp_before
#>            Sum Sq  Df F value    Pr(>F)    
#> agegrp     2485.5   2  11.226 3.467e-05 ***
#> Residuals 12952.2 117                      
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
lsr::etaSquared(aov(form, data = df_blood_pressure), type = 3, anova = TRUE)
#>              eta.sq eta.sq.part       SS  df        MS       F            p
#> agegrp    0.1610052   0.1610052  2485.55   2 1242.7750 11.2263 3.466707e-05
#> Residuals 0.8389948          NA 12952.15 117  110.7021      NA           NA
effectsize::omega_squared(aov(form, data = df_blood_pressure), partial = FALSE)
#> # Effect Size for ANOVA (Type I)
#> 
#> Parameter | Omega2 |       95% CI
#> ---------------------------------
#> agegrp    |   0.15 | [0.05, 1.00]
#> 
#> - One-sided CIs: upper bound fixed at [1.00].
sjstats::anova_stats(lm(form, data = df_blood_pressure), digits = 22)
#> etasq | partial.etasq | omegasq | partial.omegasq | epsilonsq | cohens.f |      term |     sumsq |  df |   meansq | statistic | p.value | power
#> -----------------------------------------------------------------------------------------------------------------------------------------------
#> 0.161 |         0.161 |   0.146 |           0.146 |     0.147 |    0.438 |    agegrp |  2485.550 |   2 | 1242.775 |    11.226 |  < .001 | 0.993
#>       |               |         |                 |           |          | Residuals | 12952.150 | 117 |  110.702 |           |         |      
compute_one_way_test(formula = form, df = df_blood_pressure, var.equal = TRUE)
#>              formula                    method ss_effect ss_error ms_effect ms_error     etasq partial.etasq   omegasq partial.omegasq  cohens.f     power statistic df_effect df_error            p
#> 1 bp_before ~ agegrp Assuming homoscedasticity   2485.55 12952.15  1242.775 110.7021 0.1610052     0.1610052 0.1456192       0.1456192 0.4380668 0.9925726   11.2263         2      117 3.466707e-05
compute_one_way_test(formula = form, df = df_blood_pressure, var.equal = FALSE)
#>              formula                      method ss_effect ss_error ms_effect ms_error     etasq partial.etasq   omegasq partial.omegasq  cohens.f     power statistic df_effect df_error            p
#> 1 bp_before ~ agegrp Assuming heteroscedasticity  48.00725 156.0266  24.00362 2.017238 0.2352906     0.2352906 0.2134071       0.2134071 0.5546947 0.9998626  11.89925         2 77.34665 3.121909e-05
```
