# ANOVA effect sizes

## Description

This shows the output of `compute_aov_es` from the package rwf, which
takes a between-subjects `aov` model, builds its ANOVA table with Type
I, II or III sums of squares and adds six effect sizes for every factor
and interaction: eta-squared, partial eta-squared, omega-squared,
partial omega-squared, epsilon-squared and Cohen’s f. Each section gives
the formulas the function uses, computes them by hand and checks the
results against `effectsize`, `sjstats`, `car` and
`compute_one_way_test`.

The computation of partial omega-squared is adapted from the answer of
Stephen Martin (2014) to the question “Omega squared for measure of
effect in R?” on Cross Validated
(<https://stats.stackexchange.com/a/126520>). The Type II and III sums
of squares come from
[`car::Anova`](https://rdrr.io/pkg/car/man/Anova.html) (Fox & Weisberg,
2019).

Installation instructions for rwf can be found
[here](https://github.com/sedzinfo/rwf)

The code can be found
[here](https://github.com/sedzinfo/rwf/blob/main/rwf/R/GLM_ANOVA.R)

Type III sums of squares need sum-to-zero contrasts
([below](#type-iii-and-contrasts)), so this document sets them before
any model is fitted:

``` r

options(contrasts = c("contr.sum", "contr.poly"))
```

## Notation

A term is a factor or an interaction of factors. For a term with
df\_{\text{effect}} degrees of freedom, SS\_{\text{effect}} is its sum
of squares and
MS\_{\text{effect}}=SS\_{\text{effect}}/df\_{\text{effect}} its mean
square. SS\_{\text{error}}, df\_{\text{error}} and MS\_{\text{error}}
belong to the residuals. SS\_{\text{total}} is the sum of the sums of
squares of all the terms and the residuals in the ANOVA table, and N the
number of observations used by the model. SS(A\mid B) is the reduction
in the residual sum of squares when A is added to a model that already
contains B.

## Types of sums of squares

In a factorial design with factors A and B, the sum of squares of each
term is the variance it explains **after** some other terms are already
in the model. The three types differ in which terms come first:

| Term | Type I (sequential) | Type II         | Type III        |
|------|---------------------|-----------------|-----------------|
| A    | SS(A)               | SS(A\mid B)     | SS(A\mid B, AB) |
| B    | SS(B\mid A)         | SS(B\mid A)     | SS(B\mid A, AB) |
| AB   | SS(AB\mid A, B)     | SS(AB\mid A, B) | SS(AB\mid A, B) |

- **Type I** adds the terms in the order of the formula, so the result
  depends on that order. It suits designs where the order has a meaning,
  such as a covariate entered first.
- **Type II** adjusts each term for every other term that does not
  contain it. Main effects are not adjusted for their interactions. It
  is the most powerful test of main effects when there is no interaction
  (Fox & Weisberg, 2019).
- **Type III** adjusts each term for all the others, including the
  interactions. It tests main effects averaged over the levels of the
  other factors and is the default of SPSS and SAS.

In a **balanced** design (equal numbers in every cell) the three types
give the same sums of squares. In an **unbalanced** design they differ.
`mtcars` has between 2 and 12 cars per cell of cylinders by
transmission:

``` r

cars <- transform(mtcars, cyl = factor(cyl), am = factor(am))
table(cars$cyl, cars$am)
```

    ##    
    ##      0  1
    ##   4  3  8
    ##   6  4  3
    ##   8 12  2

``` r

model_cars <- stats::aov(mpg ~ cyl * am, data = cars)
compute_aov_es(model = model_cars, ss = "I")[, c("comparisons", "Df", "Sum Sq", "F value", "Pr(>F)")]
```

    ##   comparisons Df    Sum Sq   F value       Pr(>F)
    ## 1         cyl  2 824.78459 44.851657 3.725274e-09
    ## 2          am  1  36.76692  3.998759 5.608373e-02
    ## 3      cyl:am  2  25.43651  1.383233 2.686140e-01
    ## 4   Residuals 26 239.05917        NA           NA

``` r

compute_aov_es(model = model_cars, ss = "II")[, c("comparisons", "Df", "Sum Sq", "F value", "Pr(>F)")]
```

    ##   comparisons Df    Sum Sq   F value       Pr(>F)
    ## 1         cyl  2 456.40092 24.819011 9.354735e-07
    ## 2          am  1  36.76692  3.998759 5.608373e-02
    ## 3      cyl:am  2  25.43651  1.383233 2.686140e-01
    ## 4   Residuals 26 239.05917        NA           NA

``` r

compute_aov_es(model = model_cars, ss = "III")[, c("comparisons", "Df", "Sum Sq", "F value", "Pr(>F)")]
```

    ##   comparisons Df     Sum Sq    F value       Pr(>F)
    ## 1         cyl  2  410.46389  22.320962 2.274263e-06
    ## 2          am  1   29.86735   3.248364 8.310053e-02
    ## 3      cyl:am  2   25.43651   1.383233 2.686140e-01
    ## 4 (Intercept)  1 9027.22889 981.798583 3.518351e-22
    ## 5   Residuals 26  239.05917         NA           NA

Type I depends on the order of the terms. With `am` first, `am` gets all
the variance it shares with `cyl`:

``` r

compute_aov_es(model = stats::aov(mpg ~ am * cyl, data = cars), ss = "I")[, c("comparisons", "Sum Sq")]
```

    ##   comparisons    Sum Sq
    ## 1          am 405.15059
    ## 2         cyl 456.40092
    ## 3      am:cyl  25.43651
    ## 4   Residuals 239.05917

Each sum of squares is a comparison of two models. The Type II sum of
squares of `cyl` is the drop in the residual sum of squares when `cyl`
is added to a model with `am`:

``` r

stats::anova(stats::lm(mpg ~ am, data = cars), stats::lm(mpg ~ am + cyl, data = cars))
```

    ## Analysis of Variance Table
    ## 
    ## Model 1: mpg ~ am
    ## Model 2: mpg ~ am + cyl
    ##   Res.Df   RSS Df Sum of Sq      F   Pr(>F)    
    ## 1     30 720.9                                 
    ## 2     28 264.5  2     456.4 24.158 8.01e-07 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Type III and contrasts

Type III tests a main effect with the interaction in the model, so it
depends on how the factor levels are coded. With sum-to-zero contrasts
(`contr.sum`), the main effect is averaged over the levels of the other
factor. With R’s default treatment contrasts (`contr.treatment`), it
becomes the effect at the reference level of the other factor, which is
rarely the question asked. The interaction is the same either way:

``` r

model_treatment <- stats::aov(mpg ~ cyl * am, data = cars,
                              contrasts = list(cyl = "contr.treatment", am = "contr.treatment"))
data.frame(term = c("cyl", "am", "cyl:am"),
           ss_contr_sum = compute_aov_es(model = model_cars, ss = "III")$`Sum Sq`[1:3],
           ss_contr_treatment = compute_aov_es(model = model_treatment, ss = "III")$`Sum Sq`[1:3])
```

    ##     term ss_contr_sum ss_contr_treatment
    ## 1    cyl    410.46389          167.70987
    ## 2     am     29.86735           58.43045
    ## 3 cyl:am     25.43651           25.43651

Set `options(contrasts = c("contr.sum", "contr.poly"))` **before**
fitting the model whenever you use `ss = "III"`. Types I and II do not
depend on the contrasts.

## When to use it and assumptions

### When to use it

Use `compute_aov_es` to report the size of each effect of a
between-subjects ANOVA: one or more factors, each participant in one
cell only. It works with any `aov` model whose ANOVA table `summary`
(Type I) or [`car::Anova`](https://rdrr.io/pkg/car/man/Anova.html)
(Types II and III) can compute.

Choosing the type of sums of squares:

- **Balanced design:** any type; they agree.
- **Unbalanced design, no interaction of interest:** Type II.
- **Unbalanced design with an interaction:** Type III with sum-to-zero
  contrasts, or interpret the simple effects instead of the main
  effects.
- **Terms with a natural order** (for example a covariate entered before
  the factor of interest): Type I, with the terms in that order.

Do not use it when:

- **The same participants are measured more than once.** Models with an
  `Error()` term have several error strata, and the function only reads
  the first.
- **The model has aliased terms**, such as an interaction that is
  confounded with blocks. Type I still works, but
  [`car::Anova`](https://rdrr.io/pkg/car/man/Anova.html) cannot compute
  Type II or III ([example below](#aliased-terms)).

### Assumptions

The effect sizes describe the ANOVA, so they inherit its assumptions:

1.  **Independent observations.** Each participant contributes one
    observation to one cell.
2.  **Normally distributed residuals.** With moderate cell sizes the F
    tests are fairly robust to non-normality.
3.  **Equal variances across cells.** With unequal cell sizes, unequal
    variances can bias the F tests.

## Why effect sizes

An F test answers one question: if a factor had no effect, how
surprising would data like these be? It does not say how large the
effect is. Because F grows with the sample size, a trivial effect
becomes “significant” in a large sample, and a large effect can be
“non-significant” in a small one.

An effect size answers a different question: how much of the variance in
the outcome does each factor explain? Effect sizes are useful because
they:

- **measure magnitude.** They separate practical importance from
  statistical significance.
- **do not grow with N.** The same population effect gives roughly the
  same effect size in a study of 30 people or 3,000.
- **can be compared across studies.** This is what meta-analysis
  combines.
- **drive power analysis.** The sample size a new study needs depends on
  the effect size it expects.
- **are expected in reports.** The APA Task Force on Statistical
  Inference recommends reporting effect sizes for primary outcomes
  (Wilkinson & Task Force on Statistical Inference, 1999; see also
  Lakens, 2013).

## Effect sizes

### Formulas

\eta^2=\frac{SS\_{\text{effect}}}{SS\_{\text{total}}},\qquad
\eta^2_p=\frac{SS\_{\text{effect}}}{SS\_{\text{effect}}+SS\_{\text{error}}}

\omega^2=\frac{SS\_{\text{effect}}-df\_{\text{effect}}\\MS\_{\text{error}}}{SS\_{\text{total}}+MS\_{\text{error}}},\qquad
\omega^2_p=\frac{df\_{\text{effect}}\left(MS\_{\text{effect}}-MS\_{\text{error}}\right)}{SS\_{\text{effect}}+\left(N-df\_{\text{effect}}\right)MS\_{\text{error}}}

\varepsilon^2=\frac{SS\_{\text{effect}}-df\_{\text{effect}}\\MS\_{\text{error}}}{SS\_{\text{total}}},\qquad
f=\sqrt{\frac{\eta^2_p}{1-\eta^2_p}}

- **Eta-squared** \eta^2 is the proportion of the total variance
  explained by the term.
- **Omega-squared** \omega^2 (Hays, 1963) and **epsilon-squared**
  \varepsilon^2 (Kelley, 1935) subtract
  df\_{\text{effect}}\\MS\_{\text{error}}, the part of
  SS\_{\text{effect}} expected by chance. They estimate the proportion
  of variance explained in the population and remove most of the upward
  bias of \eta^2. They differ only in the denominator.
- **Partial** measures (Olejnik & Algina, 2003) divide by the variance
  of the term and the error only, leaving out the variance explained by
  the other terms.
- **Cohen’s f** is computed from \eta^2_p, so it is a partial measure.
  It is the effect size used in power analysis (Cohen, 1988).

### Partial and non-partial

The non-partial measures share one denominator, so they add up to at
most 1 across the terms and depend on the other factors in the design.
The partial measures do not add up to anything meaningful, but the value
of a term does not shrink when other factors explain a lot of variance,
which makes them easier to compare between studies with different
designs. In a one-way design the two are the same.

`ToothGrowth` is balanced, so the sum of squares of `supp` is the same
with or without `dose` in the model. Adding `dose`, which explains most
of the variance, leaves \eta^2 of `supp` unchanged but raises \eta^2_p,
because the error variance shrinks:

``` r

tooth <- transform(ToothGrowth, dose = factor(dose))
rbind(compute_aov_es(model = stats::aov(len ~ supp, data = tooth))[1, c("comparisons", "etasq", "partial_etasq")],
      compute_aov_es(model = stats::aov(len ~ supp * dose, data = tooth))[1, c("comparisons", "etasq", "partial_etasq")])
```

    ##   comparisons      etasq partial_etasq
    ## 1        supp 0.05948365    0.05948365
    ## 2        supp 0.05948365    0.22382545

### Negative values

\omega^2, \omega^2_p and \varepsilon^2 are negative when F\<1, when a
term explains less variance than expected by chance. `compute_aov_es`
returns them as they are, as
[`sjstats::anova_stats`](https://strengejacke.github.io/sjstats/reference/anova_stats.html)
does, and `effectsize` reports them as 0 ([example
below](#negative-values-1)). Report a negative value as 0 or as it is,
but do not read it as a negative effect.

### Interpretation

Multiplied by 100, \eta^2, \omega^2 and \varepsilon^2 read as the
percentage of variance explained. Small, medium and large are the
benchmarks of Cohen (1988). Sawilowsky (2009) added very small, very
large and huge benchmarks for Cohen’s d, and the table converts them
with \eta^2=d^2/(d^2+4) and f=d/2, the relations for two groups of equal
size:

| Magnitude  | \eta^2, \omega^2, \varepsilon^2 | Cohen’s f       | Cohen’s d |
|------------|---------------------------------|-----------------|-----------|
| tiny       | \< 0.01                         | \< 0.10         | \< 0.2    |
| small      | 0.01 to \< 0.06                 | 0.10 to \< 0.25 | 0.2       |
| medium     | 0.06 to \< 0.14                 | 0.25 to \< 0.40 | 0.5       |
| large      | 0.14 to \< 0.26                 | 0.40 to \< 0.60 | 0.8       |
| very large | 0.26 to \< 0.50                 | 0.60 to \< 1.00 | 1.2       |
| huge       | ≥ 0.50                          | ≥ 1.00          | 2.0       |

These are rough guides. What counts as a meaningful effect depends on
the field and the outcome. Partial measures are usually larger than
non-partial ones, so apply the benchmarks to the measure you report and
say which one it is.

## Data

`ToothGrowth` records the length of the odontoblasts of 60 guinea pigs,
each given vitamin C at one of three doses (0.5, 1 and 2 mg/day) by one
of two delivery methods (orange juice or ascorbic acid). The design is a
balanced 2 by 3 factorial with 10 animals per cell.

``` r

head(tooth)
```

    ##    len supp dose
    ## 1  4.2   VC  0.5
    ## 2 11.5   VC  0.5
    ## 3  7.3   VC  0.5
    ## 4  5.8   VC  0.5
    ## 5  6.4   VC  0.5
    ## 6 10.0   VC  0.5

``` r

table(tooth$supp, tooth$dose)
```

    ##     
    ##      0.5  1  2
    ##   OJ  10 10 10
    ##   VC  10 10 10

## compute_aov_es

``` r

model_tooth <- stats::aov(len ~ supp * dose, data = tooth)
compute_aov_es(model = model_tooth, ss = "I")
```

    ##                call ss comparisons Df   Sum Sq    Mean Sq   F value       Pr(>F)      etasq partial_etasq    omegasq partial_omegasq  epsilonsq  cohens_f
    ## 1 len ~ supp * dose  I        supp  1  205.350  205.35000 15.571979 2.311828e-04 0.05948365     0.2238254 0.05545191      0.19540824 0.05566373 0.5370009
    ## 2 len ~ supp * dose  I        dose  2 2426.434 1213.21717 91.999965 4.046291e-18 0.70286419     0.7731092 0.69257877      0.75206604 0.69522436 1.8459161
    ## 3 len ~ supp * dose  I   supp:dose  2  108.319   54.15950  4.106991 2.186027e-02 0.03137672     0.1320279 0.02364656      0.09384698 0.02373689 0.3900138
    ## 4 len ~ supp * dose  I   Residuals 54  712.106   13.18715        NA           NA         NA            NA         NA              NA         NA        NA

``` r

compute_aov_es(model = model_tooth, ss = "II")
```

    ##                call ss comparisons Df   Sum Sq    Mean Sq   F value       Pr(>F)      etasq partial_etasq    omegasq partial_omegasq  epsilonsq  cohens_f
    ## 1 len ~ supp * dose II        supp  1  205.350  205.35000 15.571979 2.311828e-04 0.05948365     0.2238254 0.05545191      0.19540824 0.05566373 0.5370009
    ## 2 len ~ supp * dose II        dose  2 2426.434 1213.21717 91.999965 4.046291e-18 0.70286419     0.7731092 0.69257877      0.75206604 0.69522436 1.8459161
    ## 3 len ~ supp * dose II   supp:dose  2  108.319   54.15950  4.106991 2.186027e-02 0.03137672     0.1320279 0.02364656      0.09384698 0.02373689 0.3900138
    ## 4 len ~ supp * dose II   Residuals 54  712.106   13.18715        NA           NA         NA            NA         NA              NA         NA        NA

``` r

compute_aov_es(model = model_tooth, ss = "III")
```

    ##                call  ss comparisons Df    Sum Sq     Mean Sq     F value       Pr(>F)      etasq partial_etasq    omegasq partial_omegasq  epsilonsq  cohens_f
    ## 1 len ~ supp * dose III        supp  1   205.350   205.35000   15.571979 2.311828e-04 0.05948365     0.2238254 0.05545191      0.19540824 0.05566373 0.5370009
    ## 2 len ~ supp * dose III        dose  2  2426.434  1213.21717   91.999965 4.046291e-18 0.70286419     0.7731092 0.69257877      0.75206604 0.69522436 1.8459161
    ## 3 len ~ supp * dose III   supp:dose  2   108.319    54.15950    4.106991 2.186027e-02 0.03137672     0.1320279 0.02364656      0.09384698 0.02373689 0.3900138
    ## 4 len ~ supp * dose III (Intercept)  1 21236.491 21236.49067 1610.392970 6.939976e-42         NA            NA         NA              NA         NA        NA
    ## 5 len ~ supp * dose III   Residuals 54   712.106    13.18715          NA           NA         NA            NA         NA              NA         NA        NA

The design is balanced, so the three types give the same effect sizes.
Type III also reports the intercept.

The output columns are:

| Column                                         | Meaning                 |
|------------------------------------------------|-------------------------|
| `call`                                         | the model formula       |
| `ss`                                           | type of sums of squares |
| `comparisons`                                  | the term                |
| `Df`, `Sum Sq`, `Mean Sq`, `F value`, `Pr(>F)` | the ANOVA table         |
| `etasq`, `partial_etasq`                       | \eta^2, \eta^2_p        |
| `omegasq`, `partial_omegasq`                   | \omega^2, \omega^2_p    |
| `epsilonsq`                                    | \varepsilon^2           |
| `cohens_f`                                     | f from \eta^2_p         |

The effect sizes are `NA` for the residuals and the intercept.

## Step by step

Every effect size computed by hand from the Type II table of the
unbalanced `mtcars` model, where the sums of squares of the terms and
the residuals do not add up to the total variance of `mpg`:

``` r

table_ii <- as.data.frame(car::Anova(model_cars, type = "II"))
terms <- rownames(table_ii) != "Residuals"
ss_effect <- table_ii$`Sum Sq`[terms]
df_effect <- table_ii$Df[terms]
ms_effect <- ss_effect / df_effect
ss_error <- table_ii["Residuals", "Sum Sq"]
ms_error <- ss_error / table_ii["Residuals", "Df"]
ss_total <- sum(table_ii$`Sum Sq`)
N <- nrow(stats::model.frame(model_cars))
c(ss_total_table = ss_total, ss_total_mpg = sum((cars$mpg - mean(cars$mpg))^2))
```

    ## ss_total_table   ss_total_mpg 
    ##       757.6635      1126.0472

``` r

partial_etasq <- ss_effect / (ss_effect + ss_error)
by_hand <- data.frame(comparisons = rownames(table_ii)[terms],
                      etasq = ss_effect / ss_total,
                      partial_etasq = partial_etasq,
                      omegasq = (ss_effect - df_effect * ms_error) / (ss_total + ms_error),
                      partial_omegasq = df_effect * (ms_effect - ms_error) / (ss_effect + (N - df_effect) * ms_error),
                      epsilonsq = (ss_effect - df_effect * ms_error) / ss_total,
                      cohens_f = sqrt(partial_etasq / (1 - partial_etasq)))
by_hand
```

    ##   comparisons      etasq partial_etasq     omegasq partial_omegasq   epsilonsq  cohens_f
    ## 1         cyl 0.60237943    0.65625753 0.571177058      0.59818188 0.578108545 1.3817216
    ## 2          am 0.04852671    0.13329747 0.035954939      0.08568186 0.036391268 0.3921714
    ## 3      cyl:am 0.03357231    0.09616986 0.009189894      0.02339181 0.009301417 0.3261941

``` r

rwf <- compute_aov_es(model = model_cars, ss = "II")
all.equal(by_hand[, -1], rwf[!is.na(rwf$etasq), names(by_hand)[-1]], check.attributes = FALSE)
```

    ## [1] TRUE

## Checks against other packages

### effectsize and sjstats

`effectsize` and `sjstats` compute the same effect sizes from the `aov`
model (Type I) or from the
[`car::Anova`](https://rdrr.io/pkg/car/man/Anova.html) table (Types II
and III):

``` r

effectsize::eta_squared(car::Anova(model_cars, type = 3), partial = FALSE, ci = NULL)
```

    ## # Effect Size for ANOVA (Type III)
    ## 
    ## Parameter | Eta2
    ## ----------------
    ## cyl       | 0.58
    ## am        | 0.04
    ## cyl:am    | 0.04

``` r

effectsize::eta_squared(car::Anova(model_cars, type = 3), partial = TRUE, ci = NULL)
```

    ## # Effect Size for ANOVA (Type III)
    ## 
    ## Parameter | Eta2 (partial)
    ## --------------------------
    ## cyl       |           0.63
    ## am        |           0.11
    ## cyl:am    |           0.10

``` r

effectsize::omega_squared(car::Anova(model_cars, type = 3), partial = FALSE, ci = NULL)
```

    ## # Effect Size for ANOVA (Type III)
    ## 
    ## Parameter |   Omega2
    ## --------------------
    ## cyl       |     0.55
    ## am        |     0.03
    ## cyl:am    | 9.87e-03

``` r

effectsize::omega_squared(car::Anova(model_cars, type = 3), partial = TRUE, ci = NULL)
```

    ## # Effect Size for ANOVA (Type III)
    ## 
    ## Parameter | Omega2 (partial)
    ## ----------------------------
    ## cyl       |             0.57
    ## am        |             0.07
    ## cyl:am    |             0.02

``` r

effectsize::epsilon_squared(car::Anova(model_cars, type = 3), partial = FALSE, ci = NULL)
```

    ## # Effect Size for ANOVA (Type III)
    ## 
    ## Parameter | Epsilon2
    ## --------------------
    ## cyl       |     0.56
    ## am        |     0.03
    ## cyl:am    | 1.00e-02

``` r

effectsize::cohens_f(car::Anova(model_cars, type = 3), partial = TRUE, ci = NULL)
```

    ## # Effect Size for ANOVA (Type III)
    ## 
    ## Parameter | Cohen's f (partial)
    ## -------------------------------
    ## cyl       |                1.31
    ## am        |                0.35
    ## cyl:am    |                0.33

``` r

sjstats::anova_stats(car::Anova(model_cars, type = 3), digits = 22)
```

    ## etasq | partial.etasq | omegasq | partial.omegasq | epsilonsq | cohens.f |      term |   sumsq | df |  meansq | statistic | p.value | power
    ## -------------------------------------------------------------------------------------------------------------------------------------------
    ## 0.582 |         0.632 |   0.549 |           0.571 |     0.556 |    1.310 |       cyl | 410.464 |  2 | 205.232 |    22.321 |  < .001 | 1.000
    ## 0.042 |         0.111 |   0.029 |           0.066 |     0.029 |    0.353 |        am |  29.867 |  1 |  29.867 |     3.248 |   0.083 | 0.437
    ## 0.036 |         0.096 |   0.010 |           0.023 |     0.010 |    0.326 |    cyl:am |  25.437 |  2 |  12.718 |     1.383 |   0.269 | 0.298
    ##       |               |         |                 |           |          | Residuals | 239.059 | 26 |   9.195 |           |         |

``` r

compute_aov_es(model = model_cars, ss = "III")
```

    ##             call  ss comparisons Df     Sum Sq     Mean Sq    F value       Pr(>F)      etasq partial_etasq     omegasq partial_omegasq   epsilonsq  cohens_f
    ## 1 mpg ~ cyl * am III         cyl  2  410.46389  205.231946  22.320962 2.274263e-06 0.58236126    0.63194661 0.549107728      0.57128651 0.556270929 1.3103424
    ## 2 mpg ~ cyl * am III          am  1   29.86735   29.867350   3.248364 8.310053e-02 0.04237544    0.11106138 0.028952583      0.06564879 0.029330275 0.3534644
    ## 3 mpg ~ cyl * am III      cyl:am  2   25.43651   12.718256   1.383233 2.686140e-01 0.03608902    0.09616986 0.009869933      0.02339181 0.009998688 0.3261941
    ## 4 mpg ~ cyl * am III (Intercept)  1 9027.22889 9027.228889 981.798583 3.518351e-22         NA            NA          NA              NA          NA        NA
    ## 5 mpg ~ cyl * am III   Residuals 26  239.05917    9.194583         NA           NA         NA            NA          NA              NA          NA        NA

### compute_one_way_test

In a one-way design, `compute_aov_es` and `compute_one_way_test` (with
`var.equal = TRUE`) give the same \eta^2, \omega^2 and Cohen’s f:

``` r

one_way <- compute_one_way_test(formula = weight ~ feed, df = chickwts, var.equal = TRUE)
aov_es <- compute_aov_es(model = stats::aov(weight ~ feed, data = chickwts))
data.frame(statistic = c("etasq", "omegasq", "partial_omegasq", "cohens_f"),
           compute_one_way_test = c(one_way$etasq, one_way$omegasq, one_way$partial.omegasq, one_way$cohens.f),
           compute_aov_es = c(aov_es$etasq[1], aov_es$omegasq[1], aov_es$partial_omegasq[1], aov_es$cohens_f[1]))
```

    ##         statistic compute_one_way_test compute_aov_es
    ## 1           etasq            0.5416855      0.5416855
    ## 2         omegasq            0.5028847      0.5028847
    ## 3 partial_omegasq            0.5028847      0.5028847
    ## 4        cohens_f            1.0871558      1.0871558

### A test function

`check_aov_es` puts each rwf value next to the value from `effectsize`
and `sjstats` and returns the differences, one row per term.
`effectsize` reports negative values as 0, so the rwf values are
truncated at 0 before the comparison with `effectsize`.

``` r

check_aov_es <- function(model, ss) {
  rwf <- compute_aov_es(model = model, ss = ss)
  rwf <- rwf[!is.na(rwf$etasq), ]
  table <- if (ss == "I") model else car::Anova(model, type = ss)
  effectsize_value <- function(fun, ...) {
    values <- as.data.frame(suppressMessages(suppressWarnings(fun(table, ci = NULL, ...))))
    values[match(rwf$comparisons, values$Parameter), 2]
  }
  sjstats_table <- as.data.frame(suppressMessages(suppressWarnings(sjstats::anova_stats(table, digits = 22))))
  sjstats_table <- sjstats_table[match(rwf$comparisons, sjstats_table$term), ]
  data.frame(term = rwf$comparisons,
             etasq_effectsize = rwf$etasq - effectsize_value(effectsize::eta_squared, partial = FALSE),
             partial_etasq_effectsize = rwf$partial_etasq - effectsize_value(effectsize::eta_squared, partial = TRUE),
             omegasq_effectsize = pmax(0, rwf$omegasq) - effectsize_value(effectsize::omega_squared, partial = FALSE),
             partial_omegasq_effectsize = pmax(0, rwf$partial_omegasq) - effectsize_value(effectsize::omega_squared, partial = TRUE),
             epsilonsq_effectsize = pmax(0, rwf$epsilonsq) - effectsize_value(effectsize::epsilon_squared, partial = FALSE),
             cohens_f_effectsize = rwf$cohens_f - effectsize_value(effectsize::cohens_f, partial = TRUE),
             etasq_sjstats = rwf$etasq - sjstats_table$etasq,
             partial_etasq_sjstats = rwf$partial_etasq - sjstats_table$partial.etasq,
             omegasq_sjstats = rwf$omegasq - sjstats_table$omegasq,
             partial_omegasq_sjstats = rwf$partial_omegasq - sjstats_table$partial.omegasq,
             epsilonsq_sjstats = rwf$epsilonsq - sjstats_table$epsilonsq,
             cohens_f_sjstats = rwf$cohens_f - sjstats_table$cohens.f,
             row.names = NULL)
}
check_aov_es(model = model_cars, ss = "III")
```

    ##     term etasq_effectsize partial_etasq_effectsize omegasq_effectsize partial_omegasq_effectsize epsilonsq_effectsize cohens_f_effectsize etasq_sjstats partial_etasq_sjstats omegasq_sjstats
    ## 1    cyl                0                        0                  0                          0                    0                   0             0                     0               0
    ## 2     am                0                        0                  0                          0                    0                   0             0                     0               0
    ## 3 cyl:am                0                        0                  0                          0                    0                   0             0                     0               0
    ##   partial_omegasq_sjstats epsilonsq_sjstats cohens_f_sjstats
    ## 1                       0                 0                0
    ## 2                       0                 0                0
    ## 3                       0                 0                0

The same check on five models, balanced and unbalanced, with one to four
terms, for all three types of sums of squares. `max_abs_difference` is
the largest absolute difference across all the comparisons and terms:

``` r

models <- list(
  "len ~ supp * dose" = model_tooth,
  "mpg ~ cyl * am" = model_cars,
  "breaks ~ wool * tension" = stats::aov(breaks ~ wool * tension, data = warpbreaks),
  "yield ~ block + N * P + K" = stats::aov(yield ~ block + N * P + K, data = npk),
  "weight ~ feed" = stats::aov(weight ~ feed, data = chickwts)
)
do.call(rbind, lapply(names(models), function(name) {
  do.call(rbind, lapply(c("I", "II", "III"), function(ss) {
    check <- check_aov_es(model = models[[name]], ss = ss)
    data.frame(model = name, ss = ss, terms = nrow(check),
               max_abs_difference = max(abs(as.matrix(check[, -1]))))
  }))
}))
```

    ##                        model  ss terms max_abs_difference
    ## 1          len ~ supp * dose   I     3       0.000000e+00
    ## 2          len ~ supp * dose  II     3       0.000000e+00
    ## 3          len ~ supp * dose III     3       0.000000e+00
    ## 4             mpg ~ cyl * am   I     3       0.000000e+00
    ## 5             mpg ~ cyl * am  II     3       0.000000e+00
    ## 6             mpg ~ cyl * am III     3       0.000000e+00
    ## 7    breaks ~ wool * tension   I     3       0.000000e+00
    ## 8    breaks ~ wool * tension  II     3       0.000000e+00
    ## 9    breaks ~ wool * tension III     3       0.000000e+00
    ## 10 yield ~ block + N * P + K   I     5       0.000000e+00
    ## 11 yield ~ block + N * P + K  II     5       0.000000e+00
    ## 12 yield ~ block + N * P + K III     5       0.000000e+00
    ## 13             weight ~ feed   I     1       1.110223e-16
    ## 14             weight ~ feed  II     1       0.000000e+00
    ## 15             weight ~ feed III     1       0.000000e+00

## Bias of eta-squared

In a 2 by 3 design with 5 observations per cell and **no** effects at
all, the average \eta^2 and \eta^2_p are well above 0, while \omega^2,
\omega^2_p and \varepsilon^2 are close to 0:

``` r

set.seed(1)
null_effects <- do.call(rbind, replicate(1000, {
  sim <- data.frame(a = factor(rep(1:2, each = 15)), b = factor(rep(1:3, times = 10)), y = rnorm(30))
  compute_aov_es(model = stats::aov(y ~ a * b, data = sim))[1:3, c("comparisons", "etasq", "partial_etasq", "omegasq", "partial_omegasq", "epsilonsq")]
}, simplify = FALSE))
aggregate(cbind(etasq, partial_etasq, omegasq, partial_omegasq, epsilonsq) ~ comparisons, data = null_effects, FUN = mean)
```

    ##   comparisons      etasq partial_etasq       omegasq partial_omegasq     epsilonsq
    ## 1           a 0.03466595    0.04014430  5.727781e-05    0.0005051266 -2.410846e-05
    ## 2         a:b 0.06575311    0.07335943 -3.342161e-03   -0.0027103529 -3.627003e-03
    ## 3           b 0.06701952    0.07457376 -2.127749e-03   -0.0016001909 -2.360598e-03

The bias grows with the degrees of freedom of the term: `b` and `a:b`
have 2 degrees of freedom and `a` has 1. With small samples, report
\omega^2, \omega^2_p or \varepsilon^2.

## Negative values

A factor of random labels explains less variance than expected by chance
here (F\<1). rwf and `sjstats` return negative \omega^2, \omega^2_p and
\varepsilon^2, while `effectsize` reports 0:

``` r

set.seed(5)
tooth_noise <- transform(tooth, noise = factor(sample(c("a", "b"), nrow(tooth), replace = TRUE)))
model_noise <- stats::aov(len ~ dose + noise, data = tooth_noise)
compute_aov_es(model = model_noise)[, c("comparisons", "F value", "omegasq", "partial_omegasq", "epsilonsq")]
```

    ##   comparisons     F value     omegasq partial_omegasq    epsilonsq
    ## 1        dose 66.25825665  0.68860391      0.68506667  0.692256246
    ## 2       noise  0.02134975 -0.00516335     -0.01658129 -0.005190736
    ## 3   Residuals          NA          NA              NA           NA

``` r

as.data.frame(sjstats::anova_stats(model_noise, digits = 22))[, c("term", "omegasq", "partial.omegasq", "epsilonsq")]
```

    ##            term     omegasq partial.omegasq    epsilonsq
    ## dose       dose  0.68860391      0.68506667  0.692256246
    ## noise     noise -0.00516335     -0.01658129 -0.005190736
    ## 1     Residuals          NA              NA           NA

``` r

effectsize::omega_squared(model_noise, partial = FALSE, ci = NULL)
```

    ## # Effect Size for ANOVA (Type I)
    ## 
    ## Parameter | Omega2
    ## ------------------
    ## dose      |   0.69
    ## noise     |   0.00

## Missing values

`aov` removes the rows with a missing value in any variable of the model
before fitting, and `compute_aov_es` takes N from the rows the model
used:

``` r

tooth_missing <- tooth
tooth_missing$len[c(1, 31)] <- NA
model_missing <- stats::aov(len ~ supp * dose, data = tooth_missing)
nrow(stats::model.frame(model_missing))
```

    ## [1] 58

``` r

check_aov_es(model = model_missing, ss = "II")
```

    ##        term etasq_effectsize partial_etasq_effectsize omegasq_effectsize partial_omegasq_effectsize epsilonsq_effectsize cohens_f_effectsize etasq_sjstats partial_etasq_sjstats omegasq_sjstats
    ## 1      supp                0                        0                  0                          0                    0                   0             0                     0               0
    ## 2      dose                0                        0                  0                          0                    0                   0             0                     0               0
    ## 3 supp:dose                0                        0                  0                          0                    0                   0             0                     0               0
    ##   partial_omegasq_sjstats epsilonsq_sjstats cohens_f_sjstats
    ## 1                       0                 0                0
    ## 2                       0                 0                0
    ## 3                       0                 0                0

## Aliased terms

In `npk` the three-way interaction `N:P:K` is confounded with the
blocks, so it cannot be estimated. Type I sums of squares still work,
but [`car::Anova`](https://rdrr.io/pkg/car/man/Anova.html) cannot
compute Types II and III:

``` r

model_npk <- stats::aov(yield ~ block + N * P * K, data = npk)
compute_aov_es(model = model_npk, ss = "I")[, c("comparisons", "Df", "Sum Sq", "etasq", "partial_etasq")]
```

    ##   comparisons Df      Sum Sq        etasq partial_etasq
    ## 1       block  5 343.2950000 0.3917260502   0.649464447
    ## 2           N  1 189.2816667 0.2159849682   0.505332805
    ## 3           P  1   8.4016667 0.0095869491   0.043377247
    ## 4           K  1  95.2016667 0.1086324382   0.339413998
    ## 5         N:P  1  21.2816667 0.0242840217   0.103024826
    ## 6         N:K  1  33.1350000 0.0378095885   0.151701983
    ## 7         P:K  1   0.4816667 0.0005496188   0.002592835
    ## 8   Residuals 12 185.2866667           NA            NA

``` r

tryCatch(compute_aov_es(model = model_npk, ss = "III"), error = conditionMessage)
```

    ## [1] "there are aliased coefficients in the model"

Drop the aliased term (here `yield ~ block + N * P + K`, as in the
[checks above](#a-test-function)) to use Types II and III.

## References

Ben-Shachar, M. S., Lüdecke, D., & Makowski, D. (2020). effectsize:
Estimation of effect size indices and standardized parameters. *Journal
of Open Source Software, 5*(56), 2815.
<https://doi.org/10.21105/joss.02815>

Cohen, J. (1988). *Statistical power analysis for the behavioral
sciences* (2nd ed.). Lawrence Erlbaum Associates.

Fox, J., & Weisberg, S. (2019). *An R companion to applied regression*
(3rd ed.). Sage. <https://www.john-fox.ca/Companion/>

Hays, W. L. (1963). *Statistics for psychologists*. Holt, Rinehart and
Winston.

Kelley, T. L. (1935). An unbiased correlation ratio measure.
*Proceedings of the National Academy of Sciences, 21*(9), 554–559.
<https://doi.org/10.1073/pnas.21.9.554>

Lakens, D. (2013). Calculating and reporting effect sizes to facilitate
cumulative science: A practical primer for t-tests and ANOVAs.
*Frontiers in Psychology, 4*, 863.
<https://doi.org/10.3389/fpsyg.2013.00863>

Martin, S. (2014, December 3). Answer to “Omega squared for measure of
effect in R?” *Cross Validated*.
<https://stats.stackexchange.com/a/126520>

Olejnik, S., & Algina, J. (2003). Generalized eta and omega squared
statistics: Measures of effect size for some common research designs.
*Psychological Methods, 8*(4), 434–447.
<https://doi.org/10.1037/1082-989X.8.4.434>

Sawilowsky, S. S. (2009). New effect size rules of thumb. *Journal of
Modern Applied Statistical Methods, 8*(2), 597–599.
<https://doi.org/10.22237/jmasm/1257035100>

Wilkinson, L., & Task Force on Statistical Inference. (1999).
Statistical methods in psychology journals: Guidelines and explanations.
*American Psychologist, 54*(8), 594–604.
<https://doi.org/10.1037/0003-066X.54.8.594>
