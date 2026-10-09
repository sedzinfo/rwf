# MANOVA Report

Reports the four multivariate test statistics (Pillai's trace, Wilks'
lambda, the Hotelling-Lawley trace and Roy's largest root) with their
approximate F tests for every term of a `manova` model, and the Type III
MANOVA table from
[`car::Anova`](https://rdrr.io/pkg/car/man/Anova.html). The tables are
printed and can also be written to an Excel workbook.

In simple terms, this tests whether groups differ on several outcomes
considered together, rather than on each outcome separately.

## Usage

``` r
report_manova(model, file = NULL)
```

## Arguments

- model:

  A model fitted with
  [`stats::manova`](https://rdrr.io/r/stats/manova.html).

- file:

  Name of the Excel file to write, without the extension. If `NULL`
  (default), nothing is written.

## Value

Invisibly, a list with:

- `multivariate`: data frame with the Pillai, Wilks, Hotelling-Lawley
  and Roy statistics, their approximate F tests and p-values (column
  `type` names the test)

- `type_three`: Type III MANOVA table from
  [`car::Anova`](https://rdrr.io/pkg/car/man/Anova.html)

- `call`: the model call

## Details

With \\\lambda_1, \dots, \lambda_s\\ the eigenvalues of \\HE^{-1}\\,
where \\H\\ is the hypothesis and \\E\\ the error sums of squares and
cross-products matrix of a term:

- Pillai's trace, \\V=\sum \lambda_i/(1+\lambda_i)\\: the sum of the
  proportions of variance explained on the discriminant functions. It is
  the most robust of the four to violations of the assumptions and a
  good default.

- Wilks' lambda, \\\Lambda=\prod 1/(1+\lambda_i)\\: the proportion of
  variance not explained; smaller values mean larger effects.

- Hotelling-Lawley trace, \\T=\sum \lambda_i\\: the sum of the ratios of
  explained to unexplained variance.

- Roy's largest root, \\\lambda_1\\: uses only the first discriminant
  function. Its F statistic is an upper bound, so its p-value is a lower
  bound and the test is liberal.

The four tests agree when the term has one degree of freedom. The table
also includes the intercept.

The Type III table tests each term adjusted for all the others, so it
needs sum-to-zero contrasts such as `contr.sum` or `contr.helmert`. Set
them with `options(contrasts = c("contr.sum", "contr.poly"))` before
fitting the model with `manova`; `report_manova` does not change them.

Assumptions of MANOVA:

- independent observations, randomly sampled

- dependent variables measured on an interval scale

- multivariate normality of the dependent variables within each group

- equal variance-covariance matrices across groups: equal variances of
  each dependent variable and equal correlations between them in every
  group

The Excel workbook has the sheets "critical" (the four tests) and
"call".

## References

Fox, J., & Weisberg, S. (2019). An R companion to applied regression
(3rd ed.). Sage. <https://www.john-fox.ca/Companion/>

Hotelling, H. (1951). A generalized T test and measure of multivariate
dispersion. In J. Neyman (Ed.), Proceedings of the Second Berkeley
Symposium on Mathematical Statistics and Probability (pp. 23-41).
University of California Press.

Olson, C. L. (1976). On choosing a test statistic in multivariate
analysis of variance. Psychological Bulletin, 83(4), 579-586.
[doi:10.1037/0033-2909.83.4.579](https://doi.org/10.1037/0033-2909.83.4.579)

Pillai, K. C. S. (1955). Some new test criteria in multivariate
analysis. The Annals of Mathematical Statistics, 26(1), 117-121.
[doi:10.1214/aoms/1177728599](https://doi.org/10.1214/aoms/1177728599)

Roy, S. N. (1953). On a heuristic method of test construction and its
use in multivariate analysis. The Annals of Mathematical Statistics,
24(2), 220-238.
[doi:10.1214/aoms/1177729029](https://doi.org/10.1214/aoms/1177729029)

Wilks, S. S. (1932). Certain generalizations in the analysis of
variance. Biometrika, 24(3/4), 471-494.
[doi:10.2307/2331979](https://doi.org/10.2307/2331979)

## Examples

``` r
## Set orthogonal contrasts.
op <- options(contrasts = c("contr.helmert", "contr.poly"))
model_mixed <- manova(cbind(yield, foo) ~ N * P * K, within(npk, foo <- rnorm(24)))
model_between <- manova(cbind(rnorm(24), rnorm(24)) ~ round(rnorm(24), 0) * round(rnorm(24), 0))
report_manova(model = model_mixed)
#> [1] "##################################################"
#> [1] "Pillai,Wilks,Hotelling-Lawley,Roy Statistics"
#> [1] "##################################################"
#>          Group Df  Statistic    approx F num Df den Df                 Pr(>F)             type
#> 1  (Intercept)  1   0.993315 1114.376679      2     15 0.00000000000000004879           Pillai
#> 2            N  1   0.294620    3.132571      2     15 0.07297470277603194944           Pillai
#> 3            P  1   0.020020    0.153214      2     15 0.85927177400956378239           Pillai
#> 4            K  1   0.260664    2.644239      2     15 0.10382773546121241981           Pillai
#> 5          N:P  1   0.149832    1.321782      2     15 0.29599680111852888498           Pillai
#> 6          N:K  1   0.064882    0.520379      2     15 0.60464149148135315492           Pillai
#> 7          P:K  1   0.001198    0.008994      2     15 0.99105138181217222737           Pillai
#> 8        N:P:K  1   0.161617    1.445795      2     15 0.26657373353215246814           Pillai
#> 9    Residuals 16         NA          NA     NA     NA                     NA           Pillai
#> 10 (Intercept)  1   0.006685 1114.376679      2     15 0.00000000000000004879            Wilks
#> 11           N  1   0.705380    3.132571      2     15 0.07297470277603194944            Wilks
#> 12           P  1   0.979980    0.153214      2     15 0.85927177400956311626            Wilks
#> 13           K  1   0.739336    2.644239      2     15 0.10382773546121247532            Wilks
#> 14         N:P  1   0.850168    1.321782      2     15 0.29599680111852866293            Wilks
#> 15         N:K  1   0.935118    0.520379      2     15 0.60464149148135337697            Wilks
#> 16         P:K  1   0.998802    0.008994      2     15 0.99105138181217200533            Wilks
#> 17       N:P:K  1   0.838383    1.445795      2     15 0.26657373353215246814            Wilks
#> 18   Residuals 16         NA          NA     NA     NA                     NA            Wilks
#> 19 (Intercept)  1 148.583557 1114.376679      2     15 0.00000000000000004879 Hotelling-Lawley
#> 20           N  1   0.417676    3.132571      2     15 0.07297470277603194944 Hotelling-Lawley
#> 21           P  1   0.020429    0.153214      2     15 0.85927177400956378239 Hotelling-Lawley
#> 22           K  1   0.352565    2.644239      2     15 0.10382773546121241981 Hotelling-Lawley
#> 23         N:P  1   0.176238    1.321782      2     15 0.29599680111852882947 Hotelling-Lawley
#> 24         N:K  1   0.069384    0.520379      2     15 0.60464149148135315492 Hotelling-Lawley
#> 25         P:K  1   0.001199    0.008994      2     15 0.99105138181217222737 Hotelling-Lawley
#> 26       N:P:K  1   0.192773    1.445795      2     15 0.26657373353215246814 Hotelling-Lawley
#> 27   Residuals 16         NA          NA     NA     NA                     NA Hotelling-Lawley
#> 28 (Intercept)  1 148.583557 1114.376679      2     15 0.00000000000000004879              Roy
#> 29           N  1   0.417676    3.132571      2     15 0.07297470277603194944              Roy
#> 30           P  1   0.020429    0.153214      2     15 0.85927177400956378239              Roy
#> 31           K  1   0.352565    2.644239      2     15 0.10382773546121241981              Roy
#> 32         N:P  1   0.176238    1.321782      2     15 0.29599680111852882947              Roy
#> 33         N:K  1   0.069384    0.520379      2     15 0.60464149148135315492              Roy
#> 34         P:K  1   0.001199    0.008994      2     15 0.99105138181217222737              Roy
#> 35       N:P:K  1   0.192773    1.445795      2     15 0.26657373353215246814              Roy
#> 36   Residuals 16         NA          NA     NA     NA                     NA              Roy
#> [1] "##################################################"
#> [1] "type Three"
#> [1] "##################################################"
#> 
#> Type III MANOVA Tests: Pillai test statistic
#>             Df test stat approx F num Df den Df              Pr(>F)    
#> (Intercept)  1     0.993     1114      2     15 <0.0000000000000002 ***
#> N            1     0.295        3      2     15               0.073 .  
#> P            1     0.020        0      2     15               0.859    
#> K            1     0.261        3      2     15               0.104    
#> N:P          1     0.150        1      2     15               0.296    
#> N:K          1     0.065        1      2     15               0.605    
#> P:K          1     0.001        0      2     15               0.991    
#> N:P:K        1     0.162        1      2     15               0.267    
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
result <- report_manova(model = model_between)
#> [1] "##################################################"
#> [1] "Pillai,Wilks,Hotelling-Lawley,Roy Statistics"
#> [1] "##################################################"
#>                  Group Df Statistic approx F num Df den Df Pr(>F)             type
#> 1          (Intercept)  1   0.01021   0.1083      2     21 0.8978           Pillai
#> 2  round(rnorm(24), 0)  1   0.02424   0.2608      2     21 0.7729           Pillai
#> 3            Residuals 22        NA       NA     NA     NA     NA           Pillai
#> 4          (Intercept)  1   0.98979   0.1083      2     21 0.8978            Wilks
#> 5  round(rnorm(24), 0)  1   0.97576   0.2608      2     21 0.7729            Wilks
#> 6            Residuals 22        NA       NA     NA     NA     NA            Wilks
#> 7          (Intercept)  1   0.01032   0.1083      2     21 0.8978 Hotelling-Lawley
#> 8  round(rnorm(24), 0)  1   0.02484   0.2608      2     21 0.7729 Hotelling-Lawley
#> 9            Residuals 22        NA       NA     NA     NA     NA Hotelling-Lawley
#> 10         (Intercept)  1   0.01032   0.1083      2     21 0.8978              Roy
#> 11 round(rnorm(24), 0)  1   0.02484   0.2608      2     21 0.7729              Roy
#> 12           Residuals 22        NA       NA     NA     NA     NA              Roy
#> [1] "##################################################"
#> [1] "type Three"
#> [1] "##################################################"
#> 
#> Type III MANOVA Tests: Pillai test statistic
#>                     Df test stat approx F num Df den Df Pr(>F)
#> (Intercept)          1    0.0107    0.114      2     21   0.89
#> round(rnorm(24), 0)  1    0.0242    0.261      2     21   0.77
result$multivariate
#>                  Group Df Statistic approx F num Df den Df Pr(>F)             type
#> 1          (Intercept)  1   0.01021   0.1083      2     21 0.8978           Pillai
#> 2  round(rnorm(24), 0)  1   0.02424   0.2608      2     21 0.7729           Pillai
#> 3            Residuals 22        NA       NA     NA     NA     NA           Pillai
#> 4          (Intercept)  1   0.98979   0.1083      2     21 0.8978            Wilks
#> 5  round(rnorm(24), 0)  1   0.97576   0.2608      2     21 0.7729            Wilks
#> 6            Residuals 22        NA       NA     NA     NA     NA            Wilks
#> 7          (Intercept)  1   0.01032   0.1083      2     21 0.8978 Hotelling-Lawley
#> 8  round(rnorm(24), 0)  1   0.02484   0.2608      2     21 0.7729 Hotelling-Lawley
#> 9            Residuals 22        NA       NA     NA     NA     NA Hotelling-Lawley
#> 10         (Intercept)  1   0.01032   0.1083      2     21 0.8978              Roy
#> 11 round(rnorm(24), 0)  1   0.02484   0.2608      2     21 0.7729              Roy
#> 12           Residuals 22        NA       NA     NA     NA     NA              Roy
## Restore the previous contrasts.
options(op)
```
