# Report HLR

Report HLR

## Usage

``` r
report_hlr(
  df,
  corlist,
  factorlist,
  predictor,
  random_effect,
  file = NULL,
  sheet = "report"
)
```

## Arguments

- df:

  dataframe

- corlist:

  Numeric outcome index

- factorlist:

  Numeric predictor index

- predictor:

  Character predictor name

- random_effect:

  Character random effect name

- file:

  Character file

- sheet:

  Character sheet

## Examples

``` r
report_hlr(df=infert,corlist=8,factorlist=1,
           predictor="case",random_effect="case")
#>               dv                      model                 fixed       random                                                                                                call Model df  AIC  BIC
#> 1 pooled.stratum                       base    pooled.stratum ~ 1         <NA>                                   nlme::gls(model = formula(fbaseline), data = temp, method = "ML")     1  2 2120 2127
#> 2 pooled.stratum           random_intercept    pooled.stratum ~ 1    ~1 | case lme.formula(fixed = formula(fbaseline), data = temp, random = frandom_intercept,     method = "ML")     2  3 2122 2132
#> 3 pooled.stratum random_intercept_predictor pooled.stratum ~ case    ~1 | case         lme.formula(fixed = fpredictor, data = temp, random = frandom_intercept,     method = "ML")     3  4 2124 2138
#> 4 pooled.stratum     random_intercept_slope pooled.stratum ~ case ~case | case             lme.formula(fixed = fpredictor, data = temp, random = frandom_slope,     method = "ML")     4  6 2128 2149
#>   logLik   Test       L.Ratio p.value
#> 1  -1058                   NA      NA
#> 2  -1058 1 vs 2 0.00000030607  0.9996
#> 3  -1058 2 vs 3 0.00586115354  0.9390
#> 4  -1058 3 vs 4 0.00000004047  1.0000
```
