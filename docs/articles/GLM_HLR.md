# Hierarchical linear regression

## Description

This shows the output of the Hierarchical Linear Regression (HLR)
function `report_hlr` from the package rwf. HLR builds regression models
in sequential steps (blocks), adding predictors at each step. This shows
how much additional variance each new set of predictors explains beyond
the earlier ones, measured as the change in R² (ΔR²).

Installation instructions for rwf can be found
[here](https://github.com/sedzinfo/rwf)

The code can be found
[here](https://github.com/sedzinfo/rwf/blob/main/rwf/R/GLM_HLR.R)

## Report HLR

`report_hlr` fits a series of hierarchical regression models and returns
a structured report with model fit statistics (R², adjusted R²,
F-change, ΔR²), standardized and unstandardized regression coefficients,
and significance tests at each step.

The example uses the built-in `infert` dataset, which records
infertility after induced and spontaneous abortions. The arguments
specify:

- `df = infert`: the dataset.
- `corlist = 8`: column index of the continuous predictor(s) to include.
- `factorlist = 1`: column index of categorical predictor(s) treated as
  factors.
- `predictor = "case"`: the outcome variable (case/control status).
- `random_effect = "case"`: the variable used as a random effect in the
  mixed model comparison.

The ΔR² column in the output tells you whether each block of predictors
significantly improved model fit — a key quantity when building
theoretically motivated regression models step by step.

``` r

result<-report_hlr(df=infert,corlist=8,factorlist=1,predictor="case",random_effect="case")
result
```

    ##               dv                      model                 fixed       random                                                                                                call Model df      AIC
    ## 1 pooled.stratum                       base    pooled.stratum ~ 1         <NA>                                   nlme::gls(model = formula(fbaseline), data = temp, method = "ML")     1  2 2119.941
    ## 2 pooled.stratum           random_intercept    pooled.stratum ~ 1    ~1 | case lme.formula(fixed = formula(fbaseline), data = temp, random = frandom_intercept,     method = "ML")     2  3 2121.941
    ## 3 pooled.stratum random_intercept_predictor pooled.stratum ~ case    ~1 | case         lme.formula(fixed = fpredictor, data = temp, random = frandom_intercept,     method = "ML")     3  4 2123.936
    ## 4 pooled.stratum     random_intercept_slope pooled.stratum ~ case ~case | case             lme.formula(fixed = fpredictor, data = temp, random = frandom_slope,     method = "ML")     4  6 2127.936
    ##        BIC    logLik   Test      L.Ratio   p.value
    ## 1 2126.968 -1057.971                  NA        NA
    ## 2 2132.482 -1057.971 1 vs 2 3.060691e-07 0.9995586
    ## 3 2137.989 -1057.968 2 vs 3 5.861154e-03 0.9389750
    ## 4 2149.016 -1057.968 3 vs 4 4.047206e-08 1.0000000
