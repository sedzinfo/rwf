# one way test

one way test

## Usage

``` r
compute_one_way_test(formula, df, var.equal = TRUE)
```

## Arguments

- formula:

  A one-way formula in the form `y ~ group`.

- df:

  A data frame containing the variables in `formula`.

- var.equal:

  if TRUE it assumes equal variances

## Note

eta and omega for Welch statistics are not adequately tested and they
should not be consulted

## Examples

``` r
form <- formula(bp_before ~ agegrp)
compute_one_way_test(formula = form, df = df_blood_pressure, var.equal = TRUE)
#>              formula                    method ss_effect ss_error ms_effect ms_error     etasq partial.etasq   omegasq partial.omegasq  cohens.f     power statistic df_effect df_error            p
#> 1 bp_before ~ agegrp Assuming homoscedasticity   2485.55 12952.15  1242.775 110.7021 0.1610052     0.1610052 0.1456192       0.1456192 0.4380668 0.9999993   11.2263         2      117 3.466707e-05
compute_one_way_test(formula = form, df = df_blood_pressure, var.equal = FALSE)
#>              formula                      method ss_effect ss_error ms_effect ms_error     etasq partial.etasq   omegasq partial.omegasq  cohens.f     power statistic df_effect df_error            p
#> 1 bp_before ~ agegrp Assuming heteroscedasticity  48.00725 156.0266  24.00362 2.017238 0.2352906     0.2352906 0.2134071       0.1537287 0.5546947 0.9999877  11.89925         2 77.34665 3.121909e-05
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
#> agegrp     2485.6   2  11.226 3.467e-05 ***
#> Residuals 12952.2 117                      
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
model <- lm(form, data = df_blood_pressure)
lsr::etaSquared(aov(form, data = df_blood_pressure), type = 3, anova = TRUE)
#>              eta.sq eta.sq.part       SS  df        MS       F            p
#> agegrp    0.1610052   0.1610052  2485.55   2 1242.7750 11.2263 3.466707e-05
#> Residuals 0.8389948          NA 12952.15 117  110.7021      NA           NA
sjstats::anova_stats(model, digits = 22)
#> etasq | partial.etasq | omegasq | partial.omegasq | epsilonsq | cohens.f |      term |     sumsq |  df |   meansq | statistic | p.value | power
#> -----------------------------------------------------------------------------------------------------------------------------------------------
#> 0.161 |         0.161 |   0.146 |           0.146 |     0.147 |    0.438 |    agegrp |  2485.550 |   2 | 1242.775 |    11.226 |  < .001 | 0.993
#>       |               |         |                 |           |          | Residuals | 12952.150 | 117 |  110.702 |           |         |      
```
