# Correlation

## Description

This shows the output of correlation functions from the package rwf. The
functions include a correlation heatmap plotter, power analysis for
correlation tests, a full bivariate correlation report (r, p, CI,
adjusted p and sample size, all as lower-triangle matrices), and special
correlation types for dichotomous and ordinal data (tetrachoric,
polychoric, biserial, polyserial).

Installation instructions for rwf can be found
[here](https://github.com/sedzinfo/rwf)

The code can be found
[here](https://github.com/sedzinfo/rwf/blob/main/rwf/R/GLM_CORRELATION.R)

## Theoretical Background

### Pearson, Spearman, and Kendall correlation

The Pearson correlation coefficient measures *linear* association:

r = \frac{\sum (x_i-\bar x)(y_i-\bar y)}{\sqrt{\sum(x_i-\bar
x)^2}\sqrt{\sum(y_i-\bar y)^2}}

Spearman’s \rho and Kendall’s \tau instead correlate the *ranks* of the
data, making them robust to outliers and appropriate for
monotonic-but-not-linear relationships or ordinal data.

### Multiple-comparison adjustment

When many pairwise correlations are tested at once (as in a full
correlation matrix), the chance of at least one false positive grows
with the number of tests. `report_correlation` adjusts p-values (Holm by
default; also supports Bonferroni, Hochberg, BH/FDR, etc.) so the
reported significance accounts for the whole matrix, not just one pair
at a time.

### Statistical power for a correlation test

Power is the probability of detecting a true effect of a given size. For
a bivariate correlation, power depends on the sample size n, the true
correlation r, and the significance threshold \alpha — `compute_power_r`
sweeps over n (via
[`pwr::pwr.r.test`](https://rdrr.io/pkg/pwr/man/pwr.r.test.html)) to
show how power accumulates as sample size grows for a fixed r.

### Tetrachoric, polychoric, biserial, and polyserial correlation

Pearson correlation assumes continuous, normally distributed variables.
When one or both variables are discrete, the naive Pearson correlation
on the raw 0/1 or ordinal codes systematically *underestimates* the true
association between the underlying continuous constructs. Four
corrections exist depending on variable types:

| Correlation | X | Y |
|----|----|----|
| Tetrachoric | dichotomous (assumed to reflect an underlying continuous, normal latent variable) | dichotomous |
| Polychoric | ordinal (few categories) | ordinal |
| Biserial | continuous | dichotomous |
| Polyserial | continuous | ordinal |

All four estimate the correlation between the *latent continuous*
variables assumed to underlie the observed discrete/dichotomous scores,
rather than the raw observed correlation.

------------------------------------------------------------------------

## Correlation Matrix Plot

`plot_corrplot` draws a correlation matrix as a colour-coded, annotated
heatmap — only the lower triangle is shown (the matrix is symmetric, so
the upper triangle is redundant).

``` r

plot_corrplot(stats::cor(mtcars), title = "mtcars correlation matrix")
```

![](GLM_CORRELATION_files/figure-html/plot_corrplot-1.png)

Blue cells indicate positive correlation, red negative, and white
near-zero — `fill_limits` controls the midpoint and endpoints of this
gradient (default `c(-1, 0, 1)`).

## Power Analysis for Correlation

`compute_power_r` sweeps sample size from 10 up to `n` and computes the
statistical power to detect a correlation of magnitude `r` at the given
significance level, via
[`pwr::pwr.r.test`](https://rdrr.io/pkg/pwr/man/pwr.r.test.html).

``` r

result <- compute_power_r(n = 100, r = 0.5, sig.level = 0.05, alternative = "two.sided")
result$plot
```

![](GLM_CORRELATION_files/figure-html/compute_power_r-1.png)

``` r

head(result$power_table)
```

    ##    n   r    p     power alternative                                                              method
    ## 1 10 0.5 0.05 0.3290749   two.sided approximate correlation power calculation (arctangh transformation)
    ## 2 11 0.5 0.05 0.3650995   two.sided approximate correlation power calculation (arctangh transformation)
    ## 3 12 0.5 0.05 0.4001745   two.sided approximate correlation power calculation (arctangh transformation)
    ## 4 13 0.5 0.05 0.4341885   two.sided approximate correlation power calculation (arctangh transformation)
    ## 5 14 0.5 0.05 0.4670576   two.sided approximate correlation power calculation (arctangh transformation)
    ## 6 15 0.5 0.05 0.4987194   two.sided approximate correlation power calculation (arctangh transformation)

Power climbs steeply then flattens as it approaches 1 — the sample size
at which the curve crosses the conventional 0.80 threshold is the
minimum recommended sample for reliably detecting an effect of this
size.

`compute_power_r_matrix` applies this to an entire correlation matrix at
once, running the power sweep for the matrix’s minimum, maximum, mean,
and median absolute correlation (off-diagonal), and arranging all four
power curves in one multiplot — a quick way to see the range of power
your dataset’s correlations imply.

``` r

result_matrix <- compute_power_r_matrix(m = stats::cor(mtcars, use = "pairwise.complete.obs"), n = 100)
```

![](GLM_CORRELATION_files/figure-html/compute_power_r_matrix-1.png)

``` r

result_matrix$plot
```

    ## [[1]]

## Full Correlation Report

`report_correlation` wraps
[`psych::corr.test`](https://rdrr.io/pkg/psych/man/corr.test.html) and
returns every quantity you’d need for a correlation table in a paper: r,
r², p (raw and adjusted), t, n, and SE — each as a lower-triangle matrix
— plus confidence intervals and (optionally) all pairwise scatterplots.

``` r

result <- report_correlation(x = mtcars[, 1:5], scatterplot = TRUE)
```

![](GLM_CORRELATION_files/figure-html/report_correlation-1.png)![](GLM_CORRELATION_files/figure-html/report_correlation-2.png)![](GLM_CORRELATION_files/figure-html/report_correlation-3.png)![](GLM_CORRELATION_files/figure-html/report_correlation-4.png)![](GLM_CORRELATION_files/figure-html/report_correlation-5.png)![](GLM_CORRELATION_files/figure-html/report_correlation-6.png)![](GLM_CORRELATION_files/figure-html/report_correlation-7.png)![](GLM_CORRELATION_files/figure-html/report_correlation-8.png)![](GLM_CORRELATION_files/figure-html/report_correlation-9.png)![](GLM_CORRELATION_files/figure-html/report_correlation-10.png)![](GLM_CORRELATION_files/figure-html/report_correlation-11.png)

``` r

result$r_lower
```

    ##             mpg        cyl       disp         hp drat
    ## mpg          NA         NA         NA         NA   NA
    ## cyl  -0.8521620         NA         NA         NA   NA
    ## disp -0.8475514  0.9020329         NA         NA   NA
    ## hp   -0.7761684  0.8324475  0.7909486         NA   NA
    ## drat  0.6811719 -0.6999381 -0.7102139 -0.4487591   NA

``` r

result$p_lower
```

    ##               mpg          cyl         disp          hp drat
    ## mpg            NA           NA           NA          NA   NA
    ## cyl  6.112687e-10           NA           NA          NA   NA
    ## disp 9.380327e-10 1.802838e-12           NA          NA   NA
    ## hp   1.787835e-07 3.477861e-09 7.142679e-08          NA   NA
    ## drat 1.776240e-05 8.244636e-06 5.282022e-06 0.009988772   NA

``` r

result$p_lower_adjusted
```

    ##               mpg          cyl         disp          hp drat
    ## mpg            NA           NA           NA          NA   NA
    ## cyl  5.501418e-09           NA           NA          NA   NA
    ## disp 7.504261e-09 1.802838e-11           NA          NA   NA
    ## hp   8.939176e-07 2.434502e-08 4.285607e-07          NA   NA
    ## drat 3.552480e-05 2.473391e-05 2.112809e-05 0.009988772   NA

``` r

result$n_lower
```

    ##    n
    ## 1 32

``` r

head(result$ci)
```

    ##               lower          r      upper            p  lower.adj  upper.adj
    ## mpg-cyl  -0.9257694 -0.8521620 -0.7163171 6.112687e-10 -0.9445783 -0.6345981
    ## mpg-disp -0.9233594 -0.8475514 -0.7081376 9.380327e-10 -0.9419593 -0.6289245
    ## mpg-hp   -0.8852686 -0.7761684 -0.5860994 1.787835e-07 -0.9076427 -0.5060014
    ## mpg-drat  0.4360484  0.6811719  0.8322010 1.776240e-05  0.3927768  0.8475854
    ## cyl-disp  0.8072442  0.9020329  0.9514607 1.802838e-12  0.7450654  0.9643285
    ## cyl-hp    0.6816016  0.8324475  0.9154223 3.477861e-09  0.6021508  0.9348563

The `scatterplot` argument (when `TRUE`) additionally returns a full set
of pairwise scatterplots (via `plot_scatterplot`), so you can visually
confirm that a Pearson correlation is appropriate (i.e. the relationship
looks linear, without strong outliers) before trusting the numeric
table.

## Tetrachoric, Polychoric, Biserial, and Polyserial Correlation

`report_choric_serial` dispatches to the appropriate `psych` function
based on `type`, and produces both a correlation heatmap and (when
`file` is set) an Excel export.

``` r

set.seed(12345)
binary_data <- generate_data(min = 0, max = 1, type = "uniform")
ordinal_data <- generate_data(min = 1, max = 5, type = "uniform")
```

``` r

result_tetrachoric <- report_choric_serial(binary_data, type = "tetrachoric")
```

![](GLM_CORRELATION_files/figure-html/tetrachoric-1.png)

``` r

result_tetrachoric$rho
```

    ##            X1          X2         X3         X4          X5
    ## X1 1.00000000  0.08174944  0.3755173  0.5497670  0.08174944
    ## X2 0.08174944  1.00000000 -0.2691495 -0.1500260  0.08174944
    ## X3 0.37551731 -0.26914951  1.0000000  0.1810725  0.37551731
    ## X4 0.54976701 -0.15002601  0.1810725  1.0000000 -0.62268231
    ## X5 0.08174944  0.08174944  0.3755173 -0.6226823  1.00000000

``` r

result_polychoric <- report_choric_serial(ordinal_data, type = "polychoric")
```

![](GLM_CORRELATION_files/figure-html/polychoric-1.png)

``` r

result_polychoric$rho
```

    ##             X1          X2          X3          X4          X5
    ## X1  1.00000000 -0.55211654  0.76948238 -0.22606737  0.06875757
    ## X2 -0.55211654  1.00000000 -0.02604481  0.01504807 -0.58026259
    ## X3  0.76948238 -0.02604481  1.00000000 -0.37106659  0.03417760
    ## X4 -0.22606737  0.01504807 -0.37106659  1.00000000  0.13208526
    ## X5  0.06875757 -0.58026259  0.03417760  0.13208526  1.00000000

``` r

result_polyserial <- report_choric_serial(x = psych::lsat6, y = psych::lsat6, type = "polyserial")
result_polyserial
```

    ##            Q1         Q2         Q3         Q4         Q5
    ## Q1 1.00000000 0.13678199 0.18325313 0.08203137 0.04408537
    ## Q2 0.09778090 1.00000000 0.15207478 0.08253264 0.11422015
    ## Q3 0.12433121 0.14433140 1.00000000 0.13714718 0.06685219
    ## Q4 0.06096647 0.08580483 0.15023434 1.00000000 0.13666538
    ## Q5 0.03781726 0.13706077 0.08452447 0.15774041 1.00000000

``` r

result_biserial <- report_choric_serial(x = psych::lsat6, y = psych::lsat6, type = "biserial")
```

![](GLM_CORRELATION_files/figure-html/biserial-1.png)

``` r

result_biserial
```

    ##            Q1         Q2         Q3         Q4         Q5
    ## Q1 1.00000000 0.13671358 0.18316148 0.08199035 0.04406333
    ## Q2 0.09773200 1.00000000 0.15199872 0.08249136 0.11416303
    ## Q3 0.12426903 0.14425922 1.00000000 0.13707859 0.06681876
    ## Q4 0.06093598 0.08576191 0.15015921 1.00000000 0.13659703
    ## Q5 0.03779835 0.13699222 0.08448219 0.15766152 1.00000000

Notice the tetrachoric/polychoric correlations tend to run *higher in
magnitude* than a naive Pearson correlation on the same raw codes would
— this is the latent-variable correction described above, not an
inflation artifact.

------------------------------------------------------------------------

## Conclusion

`plot_corrplot` gives a quick visual read of a correlation matrix;
`compute_power_r`/`compute_power_r_matrix` tell you whether your sample
size is adequate to detect the correlations you care about;
`report_correlation` produces a full, publication-ready correlation
table with multiple-comparison-adjusted significance; and
`report_choric_serial` extends correlation analysis to dichotomous and
ordinal variables via their appropriate latent-variable estimators.

------------------------------------------------------------------------

*Rendered with R 4.6.1*
