# Effect Sizes for ANOVA Models

Builds the ANOVA table of a between-subjects `aov` model with Type I, II
or III sums of squares and adds six effect sizes for every term:

- `etasq`: eta-squared (\\\eta^2\\)

- `partial_etasq`: partial eta-squared (\\\eta^2_p\\)

- `omegasq`: omega-squared (\\\omega^2\\)

- `partial_omegasq`: partial omega-squared (\\\omega^2_p\\)

- `epsilonsq`: epsilon-squared (\\\epsilon^2\\)

- `cohens_f`: Cohen's f, computed from \\\eta^2_p\\

In simple terms, this shows for every factor and interaction of an ANOVA
how much of the variance in the outcome it explains.

## Usage

``` r
compute_aov_es(model, ss = "I")
```

## Source

The computation of `partial_omegasq` is adapted from the answer of
Stephen Martin (2014) to the question "Omega squared for measure of
effect in R?" on Cross Validated,
<https://stats.stackexchange.com/a/126520>, licensed CC BY-SA 3.0. The
Type II and III sums of squares come from
[`car::Anova`](https://rdrr.io/pkg/car/man/Anova.html) (Fox & Weisberg,
2019).

## Arguments

- model:

  An `aov` model of a between-subjects design (without an `Error()`
  term).

- ss:

  Type of sums of squares: `"I"` (sequential, the default), `"II"` or
  `"III"`.

## Value

A data frame with one row per term, one for the residuals and, with
`ss = "III"`, one for the intercept:

- `call`: model formula

- `ss`: type of sums of squares

- `comparisons`: term

- `Df`, `Sum Sq`, `Mean Sq`, `F value`, `Pr(>F)`: the ANOVA table

- `etasq`: \\SS\_{effect}/SS\_{total}\\

- `partial_etasq`: \\SS\_{effect}/(SS\_{effect}+SS\_{error})\\

- `omegasq`: \\(SS\_{effect}-df\_{effect}
  MS\_{error})/(SS\_{total}+MS\_{error})\\

- `partial_omegasq`:
  \\df\_{effect}(MS\_{effect}-MS\_{error})/(SS\_{effect}+(N-df\_{effect})
  MS\_{error})\\

- `epsilonsq`: \\(SS\_{effect}-df\_{effect} MS\_{error})/SS\_{total}\\

- `cohens_f`: \\\sqrt{\eta^2_p/(1-\eta^2_p)}\\

The effect sizes are `NA` for the residuals and the intercept.

## Details

\\SS\_{total}\\ is the sum of the sums of squares of all the terms and
the residuals in the table, \\MS\_{error}\\ the residual mean square and
\\N\\ the number of observations used by the model.

The non-partial measures (`etasq`, `omegasq`, `epsilonsq`) divide by the
total variance, so they depend on the other factors in the design. The
partial measures (`partial_etasq`, `partial_omegasq`, `cohens_f`) divide
by the variance of the term and the error only, which makes them easier
to compare across designs. In a one-way design the two are the same.
`etasq` and `partial_etasq` are biased upwards in small samples;
`omegasq`, `partial_omegasq` and `epsilonsq` correct for that and are
negative when \\F \< 1\\. Negative values are returned as they are, as
in
[`sjstats::anova_stats`](https://strengejacke.github.io/sjstats/reference/anova_stats.html);
`effectsize` reports them as 0.

Types of sums of squares:

- `"I"`: sequential; each term is adjusted for the terms before it, so
  the result depends on the order of the terms in the formula.

- `"II"`: each term is adjusted for all the other terms that do not
  contain it (main effects are not adjusted for their interactions).

- `"III"`: each term is adjusted for all the other terms. It needs
  sum-to-zero contrasts, set with
  `options(contrasts = c("contr.sum", "contr.poly"))` before the model
  is fitted; with the default treatment contrasts the Type III sums of
  squares of main effects are not meaningful.

In a balanced design the three types give the same results. In an
unbalanced design Type II and III sums of squares do not add up to the
total variance of the outcome; \\SS\_{total}\\ is then the sum of the
table, as in `effectsize`.

Rules of thumb for `etasq`, `omegasq`, `epsilonsq` and `cohens_f`.
Small, medium and large are the benchmarks of Cohen (1988); tiny, very
large and huge convert the Cohen's d benchmarks of Sawilowsky (2009)
with \\\eta^2=d^2/(d^2+4)\\ and \\f=d/2\\:

- tiny: \\\eta^2\\ \< 0.01, f \< 0.10 (d \< 0.2)

- small: \\\eta^2\\ 0.01 to \< 0.06, f 0.10 to \< 0.25 (d = 0.2)

- medium: \\\eta^2\\ 0.06 to \< 0.14, f 0.25 to \< 0.40 (d = 0.5)

- large: \\\eta^2\\ 0.14 to \< 0.26, f 0.40 to \< 0.60 (d = 0.8)

- very large: \\\eta^2\\ 0.26 to \< 0.50, f 0.60 to \< 1.00 (d = 1.2)

- huge: \\\eta^2\\ \>= 0.50, f \>= 1.00 (d = 2.0)

These are rough guides; what counts as a meaningful effect depends on
the field.

The effect sizes match
[`effectsize::eta_squared`](https://easystats.github.io/effectsize/reference/eta_squared.html),
[`effectsize::omega_squared`](https://easystats.github.io/effectsize/reference/eta_squared.html),
[`effectsize::epsilon_squared`](https://easystats.github.io/effectsize/reference/eta_squared.html)
and
[`effectsize::cohens_f`](https://easystats.github.io/effectsize/reference/eta_squared.html)
(apart from the truncation of negative values) and
[`sjstats::anova_stats`](https://strengejacke.github.io/sjstats/reference/anova_stats.html).

## References

Ben-Shachar, M. S., Lüdecke, D., & Makowski, D. (2020). effectsize:
Estimation of effect size indices and standardized parameters. Journal
of Open Source Software, 5(56), 2815.
[doi:10.21105/joss.02815](https://doi.org/10.21105/joss.02815)

Cohen, J. (1988). Statistical power analysis for the behavioral sciences
(2nd ed.). Lawrence Erlbaum Associates.

Fox, J., & Weisberg, S. (2019). An R companion to applied regression
(3rd ed.). Sage. <https://www.john-fox.ca/Companion/>

Hays, W. L. (1963). Statistics for psychologists. Holt, Rinehart and
Winston.

Kelley, T. L. (1935). An unbiased correlation ratio measure. Proceedings
of the National Academy of Sciences, 21(9), 554-559.
[doi:10.1073/pnas.21.9.554](https://doi.org/10.1073/pnas.21.9.554)

Martin, S. (2014, December 3). Answer to "Omega squared for measure of
effect in R?" Cross Validated.
<https://stats.stackexchange.com/a/126520>

Olejnik, S., & Algina, J. (2003). Generalized eta and omega squared
statistics: Measures of effect size for some common research designs.
Psychological Methods, 8(4), 434-447.
[doi:10.1037/1082-989X.8.4.434](https://doi.org/10.1037/1082-989X.8.4.434)

Sawilowsky, S. S. (2009). New effect size rules of thumb. Journal of
Modern Applied Statistical Methods, 8(2), 597-599.
[doi:10.22237/jmasm/1257035100](https://doi.org/10.22237/jmasm/1257035100)

## Examples

``` r
one_way_between <- aov(uptake ~ Treatment, data = CO2)
compute_aov_es(model = one_way_between, ss = "I")
#>                 call ss comparisons Df    Sum Sq  Mean Sq  F value      Pr(>F)     etasq partial_etasq    omegasq partial_omegasq  epsilonsq  cohens_f
#> 1 uptake ~ Treatment  I   Treatment  1  988.1144 988.1144 9.293115 0.003095733 0.1017943     0.1017943 0.08985627      0.08985627 0.09084053 0.3366462
#> 2 uptake ~ Treatment  I   Residuals 82 8718.8612 106.3276       NA          NA        NA            NA         NA              NA         NA        NA
sjstats::anova_stats(one_way_between, digits = 10)
#> etasq | partial.etasq | omegasq | partial.omegasq | epsilonsq | cohens.f |      term |    sumsq | df |  meansq | statistic | p.value | power
#> --------------------------------------------------------------------------------------------------------------------------------------------
#> 0.102 |         0.102 |   0.090 |           0.090 |     0.091 |    0.337 | Treatment |  988.114 |  1 | 988.114 |     9.293 |   0.003 | 0.862
#>       |               |         |                 |           |          | Residuals | 8718.861 | 82 | 106.328 |           |         |      
effectsize::omega_squared(one_way_between, partial = FALSE)
#> # Effect Size for ANOVA (Type I)
#> 
#> Parameter | Omega2 |       95% CI
#> ---------------------------------
#> Treatment |   0.09 | [0.02, 1.00]
#> 
#> - One-sided CIs: upper bound fixed at [1.00].

# Type III sums of squares need sum-to-zero contrasts
old_contrasts <- options(contrasts = c("contr.sum", "contr.poly"))
factorial_between <- aov(uptake ~ Treatment * Type, data = CO2)
compute_aov_es(model = factorial_between, ss = "I")
#>                        call ss    comparisons Df    Sum Sq    Mean Sq  F value       Pr(>F)      etasq partial_etasq    omegasq partial_omegasq  epsilonsq  cohens_f
#> 1 uptake ~ Treatment * Type  I      Treatment  1  988.1144  988.11440 15.41641 1.817080e-04 0.10179426    0.16156982 0.09456686      0.14648382 0.09519128 0.4389820
#> 2 uptake ~ Treatment * Type  I           Type  1 3365.5344 3365.53440 52.50856 2.377680e-10 0.34671298    0.39626543 0.33787899      0.38011297 0.34011000 0.8101586
#> 3 uptake ~ Treatment * Type  I Treatment:Type  1  225.7296  225.72964  3.52180 6.421283e-02 0.02325437    0.04216624 0.01654217      0.02914641 0.01665139 0.2098154
#> 4 uptake ~ Treatment * Type  I      Residuals 80 5127.5971   64.09496       NA           NA         NA            NA         NA              NA         NA        NA
compute_aov_es(model = factorial_between, ss = "II")
#>                        call ss    comparisons Df    Sum Sq    Mean Sq  F value       Pr(>F)      etasq partial_etasq    omegasq partial_omegasq  epsilonsq  cohens_f
#> 1 uptake ~ Treatment * Type II      Treatment  1  988.1144  988.11440 15.41641 1.817080e-04 0.10179426    0.16156982 0.09456686      0.14648382 0.09519128 0.4389820
#> 2 uptake ~ Treatment * Type II           Type  1 3365.5344 3365.53440 52.50856 2.377680e-10 0.34671298    0.39626543 0.33787899      0.38011297 0.34011000 0.8101586
#> 3 uptake ~ Treatment * Type II Treatment:Type  1  225.7296  225.72964  3.52180 6.421283e-02 0.02325437    0.04216624 0.01654217      0.02914641 0.01665139 0.2098154
#> 4 uptake ~ Treatment * Type II      Residuals 80 5127.5971   64.09496       NA           NA         NA            NA         NA              NA         NA        NA
compute_aov_es(model = factorial_between, ss = "III")
#>                        call  ss    comparisons Df     Sum Sq     Mean Sq   F value       Pr(>F)      etasq partial_etasq    omegasq partial_omegasq  epsilonsq  cohens_f
#> 1 uptake ~ Treatment * Type III      Treatment  1   988.1144   988.11440  15.41641 1.817080e-04 0.10179426    0.16156982 0.09456686      0.14648382 0.09519128 0.4389820
#> 2 uptake ~ Treatment * Type III           Type  1  3365.5344  3365.53440  52.50856 2.377680e-10 0.34671298    0.39626543 0.33787899      0.38011297 0.34011000 0.8101586
#> 3 uptake ~ Treatment * Type III Treatment:Type  1   225.7296   225.72964   3.52180 6.421283e-02 0.02325437    0.04216624 0.01654217      0.02914641 0.01665139 0.2098154
#> 4 uptake ~ Treatment * Type III    (Intercept)  1 62206.4144 62206.41440 970.53513 1.709930e-46         NA            NA         NA              NA         NA        NA
#> 5 uptake ~ Treatment * Type III      Residuals 80  5127.5971    64.09496        NA           NA         NA            NA         NA              NA         NA        NA
sjstats::anova_stats(car::Anova(factorial_between, type = 3), digits = 10)
#> Type 3 ANOVAs only give sensible and informative results when covariates are mean-centered and factors are coded with orthogonal contrasts (such as those produced by `contr.sum`,
#>   `contr.poly`, or `contr.helmert`, but *not* by the default `contr.treatment`).
#> etasq | partial.etasq | omegasq | partial.omegasq | epsilonsq | cohens.f |           term |    sumsq | df |   meansq | statistic | p.value | power
#> --------------------------------------------------------------------------------------------------------------------------------------------------
#> 0.102 |         0.162 |   0.095 |           0.146 |     0.095 |    0.439 |      Treatment |  988.114 |  1 |  988.114 |    15.416 |  < .001 | 0.975
#> 0.347 |         0.396 |   0.338 |           0.380 |     0.340 |    0.810 |           Type | 3365.534 |  1 | 3365.534 |    52.509 |  < .001 | 1.000
#> 0.023 |         0.042 |   0.017 |           0.029 |     0.017 |    0.210 | Treatment:Type |  225.730 |  1 |  225.730 |     3.522 |   0.064 | 0.467
#>       |               |         |                 |           |          |      Residuals | 5127.597 | 80 |   64.095 |           |         |      
effectsize::omega_squared(car::Anova(factorial_between, type = 3), partial = TRUE)
#> Type 3 ANOVAs only give sensible and informative results when covariates are mean-centered and factors are coded with orthogonal contrasts (such as those produced by `contr.sum`,
#>   `contr.poly`, or `contr.helmert`, but *not* by the default `contr.treatment`).
#> # Effect Size for ANOVA (Type III)
#> 
#> Parameter      | Omega2 (partial) |       95% CI
#> ------------------------------------------------
#> Treatment      |             0.15 | [0.05, 1.00]
#> Type           |             0.38 | [0.25, 1.00]
#> Treatment:Type |             0.03 | [0.00, 1.00]
#> 
#> - One-sided CIs: upper bound fixed at [1.00].
options(old_contrasts)
```
