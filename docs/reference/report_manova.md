# Manova result

Manova result

## Usage

``` r
report_manova(model, file = NULL)
```

## Arguments

- model:

  object of manova model

- file:

  output filename

## Note

Pillai-Bartlett trace (V): Represents the sum of the proportion of
explained variance on the discriminant functions. As such,it is similar
to the ratio of SS M /SS T,which is known as R 2.\
Hotelling-s T 2: Represents the sum of the eigenvalues for each variate
it compares directly to the F-ratio in ANOVA\
Wilks-s lambda (L): Represents the ratio of error variance to total
variance (SS R /SS T ) for each variate.\
Roy-s largest root: Represents the proportion of explained variance to
unexplained variance (SS M /SS R ) for the first discriminant function.\
ASSUMPTIONS\
Independence: Observations should be statistically independent.\
Random sampling: Data should be randomly sampled from the population of
interest and measured at an interval level.\
Multivariate normality: In ANOVA,we assume that our dependent variable
is normally distributed within each group. In the case of MANOVA,we
assume that the dependent variables (collectively) have multivariate
normality within groups.\
Homogeneity of covariance matrices: In ANOVA,it is assumed that the
variances in each group are roughly equal (homogeneity of variance). In
MANOVA we must assume that this is true for each dependent variable,but
also that the correlation between any two dependent variables is the
same in all groups. This assumption is examined by testing whether the
population variance-covariance matrices of the different groups in the
analysis are equal.

## Examples

``` r
## Set orthogonal contrasts.
op <- options(contrasts = c("contr.helmert", "contr.poly"))
model_mixed <- manova(cbind(yield, foo) ~ N * P * K, within(npk, foo <- rnorm(24)))
model_between <- manova(cbind(rnorm(24), rnorm(24)) ~ round(rnorm(24), 0) * round(rnorm(24), 0))
report_manova(model = model_mixed)
#> [1] "####################################################################################################"
#> [1] "Pillai,Wilks,Hotelling-Lawley,Roy Statistics"
#> [1] "####################################################################################################"
#>          Group Df  Statistic    approx F num Df den Df                 Pr(>F)             type
#> 1  (Intercept)  1   0.993315 1114.376679      2     15 0.00000000000000004879           Pillai
#> 2            N  1   0.294620    3.132571      2     15 0.07297470277603194944           Pillai
#> 3            P  1   0.020020    0.153214      2     15 0.85927177400956344933           Pillai
#> 4            K  1   0.260664    2.644239      2     15 0.10382773546121241981           Pillai
#> 5          N:P  1   0.149832    1.321782      2     15 0.29599680111852860742           Pillai
#> 6          N:K  1   0.064882    0.520379      2     15 0.60464149148135315492           Pillai
#> 7          P:K  1   0.001198    0.008994      2     15 0.99105138181217222737           Pillai
#> 8        N:P:K  1   0.161617    1.445795      2     15 0.26657373353215213507           Pillai
#> 9    Residuals 16         NA          NA     NA     NA                     NA           Pillai
#> 10 (Intercept)  1   0.006685 1114.376679      2     15 0.00000000000000004879            Wilks
#> 11           N  1   0.705380    3.132571      2     15 0.07297470277603181066            Wilks
#> 12           P  1   0.979980    0.153214      2     15 0.85927177400956311626            Wilks
#> 13           K  1   0.739336    2.644239      2     15 0.10382773546121237818            Wilks
#> 14         N:P  1   0.850168    1.321782      2     15 0.29599680111852866293            Wilks
#> 15         N:K  1   0.935118    0.520379      2     15 0.60464149148135337697            Wilks
#> 16         P:K  1   0.998802    0.008994      2     15 0.99105138181217200533            Wilks
#> 17       N:P:K  1   0.838383    1.445795      2     15 0.26657373353215207956            Wilks
#> 18   Residuals 16         NA          NA     NA     NA                     NA            Wilks
#> 19 (Intercept)  1 148.583557 1114.376679      2     15 0.00000000000000004879 Hotelling-Lawley
#> 20           N  1   0.417676    3.132571      2     15 0.07297470277603189392 Hotelling-Lawley
#> 21           P  1   0.020429    0.153214      2     15 0.85927177400956344933 Hotelling-Lawley
#> 22           K  1   0.352565    2.644239      2     15 0.10382773546121241981 Hotelling-Lawley
#> 23         N:P  1   0.176238    1.321782      2     15 0.29599680111852866293 Hotelling-Lawley
#> 24         N:K  1   0.069384    0.520379      2     15 0.60464149148135315492 Hotelling-Lawley
#> 25         P:K  1   0.001199    0.008994      2     15 0.99105138181217222737 Hotelling-Lawley
#> 26       N:P:K  1   0.192773    1.445795      2     15 0.26657373353215213507 Hotelling-Lawley
#> 27   Residuals 16         NA          NA     NA     NA                     NA Hotelling-Lawley
#> 28 (Intercept)  1 148.583557 1114.376679      2     15 0.00000000000000004879              Roy
#> 29           N  1   0.417676    3.132571      2     15 0.07297470277603189392              Roy
#> 30           P  1   0.020429    0.153214      2     15 0.85927177400956344933              Roy
#> 31           K  1   0.352565    2.644239      2     15 0.10382773546121241981              Roy
#> 32         N:P  1   0.176238    1.321782      2     15 0.29599680111852866293              Roy
#> 33         N:K  1   0.069384    0.520379      2     15 0.60464149148135315492              Roy
#> 34         P:K  1   0.001199    0.008994      2     15 0.99105138181217222737              Roy
#> 35       N:P:K  1   0.192773    1.445795      2     15 0.26657373353215207956              Roy
#> 36   Residuals 16         NA          NA     NA     NA                     NA              Roy
#> [1] "####################################################################################################"
#> [1] "type Three"
#> [1] "####################################################################################################"
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
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
report_manova(model = model_between)
#> [1] "####################################################################################################"
#> [1] "Pillai,Wilks,Hotelling-Lawley,Roy Statistics"
#> [1] "####################################################################################################"
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
#> [1] "####################################################################################################"
#> [1] "type Three"
#> [1] "####################################################################################################"
#> 
#> Type III MANOVA Tests: Pillai test statistic
#>                     Df test stat approx F num Df den Df Pr(>F)
#> (Intercept)          1    0.0107    0.114      2     21   0.89
#> round(rnorm(24), 0)  1    0.0242    0.261      2     21   0.77
```
