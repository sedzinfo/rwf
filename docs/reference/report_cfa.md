# Report

Report

## Usage

``` r
report_cfa(model, file = NULL, w = 10, h = 10)
```

## Arguments

- model:

  lavaan object

- file:

  output filename

- w:

  width of pdf file

- h:

  height of pdf file

## Examples

``` r
model='LATENT=~ITEM1+ITEM2+ITEM3+ITEM4+ITEM5'
df<-lavaan::simulateData(model=model,model.type="cfa",
                             return.type="data.frame",sample.nobs=100)
df<-generate_missing(df)
fit<-lavaan::cfa(model,data=df,missing="ML")
report_cfa(fit)
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.labels’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.class’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘list.by.group’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘drop.list.single.group’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.labels’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.class’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘list.by.group’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘drop.list.single.group’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.labels’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.class’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘list.by.group’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘drop.list.single.group’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.labels’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.class’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘list.by.group’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘drop.list.single.group’ for ‘inspect’
#> Skipping circle_parameters_wih_equality_constraints: replacement has 0 rows, data has 5
#> Skipping tree_parameters_wih_equality_constraints: replacement has 0 rows, data has 5
#> Skipping spring_parameters_wih_equality_constraints: replacement has 0 rows, data has 5






#> [1] "##################################################"
#> [1] "SUMMARY"
#> [1] "##################################################"
#> lavaan 0.7-3 ended normally after 25 iterations
#> 
#>   Estimator                                         ML
#>   Optimization method                           NLMINB
#>   Number of model parameters                        15
#> 
#>   Number of observations                           100
#>   Number of missing patterns                         8
#> 
#> Model Test User Model:
#>                                                       
#>   Test statistic                                 0.526
#>   Degrees of freedom                                 5
#>   P-value (Chi-square)                           0.991
#>                                                       
#>   Browne's residual (NT model-based) test             
#>   Test statistic                                 0.957
#>   Degrees of freedom                                 5
#>   P-value (Chi-square)                           0.966
#> 
#> Model Test Baseline Model:
#> 
#>   Test statistic                               181.936
#>   Degrees of freedom                                10
#>   P-value                                        0.000
#> 
#> User Model versus Baseline Model:
#> 
#>   Comparative Fit Index (CFI)                    1.000
#>   Tucker-Lewis Index (TLI)                       1.052
#>                                                       
#>   Robust Comparative Fit Index (CFI)             1.000
#>   Robust Tucker-Lewis Index (TLI)                1.058
#> 
#> Loglikelihood and Information Criteria:
#> 
#>   Loglikelihood user model (H0)               -778.757
#>   Loglikelihood unrestricted model (H1)       -778.494
#>                                                       
#>   Akaike (AIC)                                1587.514
#>   Bayesian (BIC)                              1626.591
#>   Sample-size adjusted Bayesian (SABIC)       1579.218
#> 
#> Root Mean Square Error of Approximation:
#> 
#>   RMSEA                                          0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.000
#>   P-value H_0: RMSEA <= 0.050                    0.995
#>   P-value H_0: RMSEA >= 0.080                    0.002
#>                                                       
#>   Robust RMSEA                                   0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.000
#>   P-value H_0: Robust RMSEA <= 0.050             0.995
#>   P-value H_0: Robust RMSEA >= 0.080             0.002
#> 
#> Standardized Root Mean Square Residual:
#> 
#>   SRMR                                           0.008
#> 
#> Goodness of Fit Index:
#> 
#>   Goodness of Fit Index (GFI)                    1.000
#>   90 Percent confidence interval - lower         1.000
#>   90 Percent confidence interval - upper         1.000
#>                                                       
#>   Robust GFI                                     1.000
#>   90 Percent confidence interval - lower         1.000
#>   90 Percent confidence interval - upper         1.000
#> 
#> Parameter Estimates:
#> 
#>   Standard errors                             Standard
#>   Information                                 Observed
#>   Observed information based on                Hessian
#> 
#> Latent Variables:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>   LATENT =~                                                             
#>     ITEM1             1.000                               0.978    0.701
#>     ITEM2             1.163    0.184    6.337    0.000    1.138    0.733
#>     ITEM3             1.105    0.174    6.356    0.000    1.081    0.745
#>     ITEM4             1.242    0.196    6.350    0.000    1.216    0.763
#>     ITEM5             1.127    0.184    6.119    0.000    1.103    0.717
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1             0.145    0.142    1.021    0.307    0.145    0.104
#>    .ITEM2             0.018    0.158    0.117    0.907    0.018    0.012
#>    .ITEM3             0.022    0.147    0.148    0.882    0.022    0.015
#>    .ITEM4             0.233    0.162    1.439    0.150    0.233    0.146
#>    .ITEM5             0.070    0.156    0.450    0.653    0.070    0.046
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1             0.989    0.176    5.610    0.000    0.989    0.508
#>    .ITEM2             1.117    0.206    5.424    0.000    1.117    0.463
#>    .ITEM3             0.939    0.178    5.265    0.000    0.939    0.445
#>    .ITEM4             1.062    0.208    5.101    0.000    1.062    0.418
#>    .ITEM5             1.150    0.207    5.548    0.000    1.150    0.486
#>     LATENT            0.957    0.262    3.659    0.000    1.000    1.000
#> 
#> R-Square:
#>                    Estimate
#>     ITEM1             0.492
#>     ITEM2             0.537
#>     ITEM3             0.555
#>     ITEM4             0.582
#>     ITEM5             0.514
#> 
#> [1] "##################################################"
#> [1] "R_SQUARED"
#> [1] "##################################################"
#>       r_squared
#> ITEM1    0.4919
#> ITEM2    0.5370
#> ITEM3    0.5546
#> ITEM4    0.5819
#> ITEM5    0.5139
#> [1] "##################################################"
#> [1] "FIT INDICES"
#> [1] "##################################################"
#>                                      fit
#> npar                           15.000000
#> fmin                            0.002628
#> chisq                           0.525500
#> df                              5.000000
#> pvalue                          0.991160
#> baseline.chisq                181.936078
#> baseline.df                    10.000000
#> baseline.pvalue                 0.000000
#> cfi                             1.000000
#> tli                             1.052048
#> cfi.robust                      1.000000
#> tli.robust                      1.057638
#> nnfi                            1.052048
#> rfi                             0.994223
#> nfi                             0.997112
#> pnfi                            0.498556
#> ifi                             1.025289
#> rni                             1.026024
#> nnfi.robust                     1.057638
#> rni.robust                      1.028819
#> logl                         -778.756960
#> unrestricted.logl            -778.494210
#> aic                          1587.513919
#> bic                          1626.591472
#> ntotal                        100.000000
#> bic2                         1579.217704
#> rmsea                           0.000000
#> rmsea.ci.lower                  0.000000
#> rmsea.ci.upper                  0.000000
#> rmsea.ci.level                  0.900000
#> rmsea.pvalue                    0.995046
#> rmsea.close.h0                  0.050000
#> rmsea.notclose.pvalue           0.002006
#> rmsea.notclose.h0               0.080000
#> rmsea.robust                    0.000000
#> rmsea.ci.lower.robust           0.000000
#> rmsea.ci.upper.robust           0.000000
#> rmsea.pvalue.robust             0.995040
#> rmsea.notclose.pvalue.robust    0.002286
#> rmr                             0.018360
#> rmr_nomean                      0.021190
#> srmr                            0.008270
#> srmr_bentler                    0.008270
#> srmr_bentler_nomean             0.009539
#> crmr                            0.009474
#> crmr_nomean                     0.011590
#> srmr_mplus                      0.008231
#> srmr_mplus_nomean               0.009493
#> gfi                             1.000000
#> gfi.ci.lower                    1.000000
#> gfi.ci.upper                    1.000000
#> gfi.ci.level                    0.900000
#> gfi.robust                      1.000000
#> gfi.ci.lower.robust             1.000000
#> gfi.ci.upper.robust             1.000000
#> cn_05                        2107.659245
#> cn_01                        2871.840703
#> gfi_lisrel                      0.993713
#> agfi_lisrel                     0.974853
#> pgfi                            0.248428
#> mfi                             1.022625
#> ecvi                            0.305255
#> [1] "##################################################"
#> [1] "PARAMETERS"
#> [1] "##################################################"
#>       lhs op    rhs exo     est     se      z          pvalue ci.lower ci.upper  std.lv std.all
#> 1  LATENT =~  ITEM1   0 1.00000 0.0000     NA              NA  1.00000   1.0000 0.97835 0.70135
#> 2  LATENT =~  ITEM2   0 1.16338 0.1836 6.3367 0.0000000002347  0.80354   1.5232 1.13819 0.73277
#> 3  LATENT =~  ITEM3   0 1.10536 0.1739 6.3556 0.0000000002076  0.76448   1.4462 1.08143 0.74473
#> 4  LATENT =~  ITEM4   0 1.24247 0.1957 6.3504 0.0000000002148  0.85900   1.6259 1.21557 0.76285
#> 5  LATENT =~  ITEM5   0 1.12691 0.1842 6.1185 0.0000000009444  0.76593   1.4879 1.10251 0.71687
#> 6   ITEM1 ~~  ITEM1   0 0.98870 0.1762 5.6098 0.0000000202596  0.64327   1.3341 0.98870 0.50810
#> 7   ITEM2 ~~  ITEM2   0 1.11715 0.2060 5.4243 0.0000000581926  0.71348   1.5208 1.11715 0.46304
#> 8   ITEM3 ~~  ITEM3   0 0.93911 0.1784 5.2645 0.0000001405424  0.58949   1.2887 0.93911 0.44537
#> 9   ITEM4 ~~  ITEM4   0 1.06150 0.2081 5.1015 0.0000003370276  0.65368   1.4693 1.06150 0.41806
#> 10  ITEM5 ~~  ITEM5   0 1.14974 0.2072 5.5482 0.0000000288673  0.74358   1.5559 1.14974 0.48609
#> 11 LATENT ~~ LATENT   0 0.95716 0.2616 3.6593 0.0002528699693  0.44450   1.4698 1.00000 1.00000
#> 12  ITEM1 ~1          0 0.14469 0.1417 1.0211 0.3071904169358 -0.13303   0.4224 0.14469 0.10372
#> 13  ITEM2 ~1          0 0.01840 0.1577 0.1167 0.9071082413696 -0.29065   0.3274 0.01840 0.01185
#> 14  ITEM3 ~1          0 0.02180 0.1473 0.1480 0.8823496601689 -0.26692   0.3105 0.02180 0.01501
#> 15  ITEM4 ~1          0 0.23276 0.1617 1.4394 0.1500266146215 -0.08417   0.5497 0.23276 0.14607
#> 16  ITEM5 ~1          0 0.07033 0.1562 0.4502 0.6525596789616 -0.23584   0.3765 0.07033 0.04573
#> 17 LATENT ~1          0 0.00000 0.0000     NA              NA  0.00000   0.0000 0.00000 0.00000
#> 18  ITEM1 r2  ITEM1   0 0.49190     NA     NA              NA       NA       NA      NA      NA
#> 19  ITEM2 r2  ITEM2   0 0.53696     NA     NA              NA       NA       NA      NA      NA
#> 20  ITEM3 r2  ITEM3   0 0.55463     NA     NA              NA       NA       NA      NA      NA
#> 21  ITEM4 r2  ITEM4   0 0.58194     NA     NA              NA       NA       NA      NA      NA
#> 22  ITEM5 r2  ITEM5   0 0.51391     NA     NA              NA       NA       NA      NA      NA
#> [1] "##################################################"
#> [1] "UNSTANDARDIZED PARAMETERS"
#> [1] "##################################################"
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  1.163
#> ITEM3  1.105
#> ITEM4  1.242
#> ITEM5  1.127
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.989                        
#> ITEM2 0.000 1.117                  
#> ITEM3 0.000 0.000 0.939            
#> ITEM4 0.000 0.000 0.000 1.062      
#> ITEM5 0.000 0.000 0.000 0.000 1.150
#> 
#> $psi
#>        LATENT
#> LATENT  0.957
#> 
#> $nu
#>       intrcp
#> ITEM1  0.145
#> ITEM2  0.018
#> ITEM3  0.022
#> ITEM4  0.233
#> ITEM5  0.070
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> [1] "##################################################"
#> [1] "STANDARDIZED PARAMETERS"
#> [1] "##################################################"
#> $lambda
#>       LATENT
#> ITEM1  0.701
#> ITEM2  0.733
#> ITEM3  0.745
#> ITEM4  0.763
#> ITEM5  0.717
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.508                        
#> ITEM2 0.000 0.463                  
#> ITEM3 0.000 0.000 0.445            
#> ITEM4 0.000 0.000 0.000 0.418      
#> ITEM5 0.000 0.000 0.000 0.000 0.486
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1  0.104
#> ITEM2  0.012
#> ITEM3  0.015
#> ITEM4  0.146
#> ITEM5  0.046
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> [1] "##################################################"
#> [1] "SAMPLE COVARIANCE"
#> [1] "##################################################"
#>      X1    X2    X3    X4    X5
#> 1 1.955 1.127 1.162 1.150 1.041
#> 2 1.127 2.435 1.315 1.377 1.334
#> 3 1.162 1.315 2.148 1.364 1.226
#> 4 1.150 1.377 1.364 2.518 1.388
#> 5 1.041 1.334 1.226 1.388 2.385
#> [1] "##################################################"
#> [1] "CALL"
#> [1] "##################################################"
#> [1] "lavaan::lavaan(model=model,data=df,missing=\"ML\",model.type=\"cfa\"," "cmd=\"cfa\",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,"  
#> [3] "auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,"                "auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)"          
#> NULL
#> $r_squared
#>       r_squared
#> ITEM1    0.4919
#> ITEM2    0.5370
#> ITEM3    0.5546
#> ITEM4    0.5819
#> ITEM5    0.5139
#> 
#> $fit_indices
#>                                      fit
#> npar                           15.000000
#> fmin                            0.002628
#> chisq                           0.525500
#> df                              5.000000
#> pvalue                          0.991160
#> baseline.chisq                181.936078
#> baseline.df                    10.000000
#> baseline.pvalue                 0.000000
#> cfi                             1.000000
#> tli                             1.052048
#> cfi.robust                      1.000000
#> tli.robust                      1.057638
#> nnfi                            1.052048
#> rfi                             0.994223
#> nfi                             0.997112
#> pnfi                            0.498556
#> ifi                             1.025289
#> rni                             1.026024
#> nnfi.robust                     1.057638
#> rni.robust                      1.028819
#> logl                         -778.756960
#> unrestricted.logl            -778.494210
#> aic                          1587.513919
#> bic                          1626.591472
#> ntotal                        100.000000
#> bic2                         1579.217704
#> rmsea                           0.000000
#> rmsea.ci.lower                  0.000000
#> rmsea.ci.upper                  0.000000
#> rmsea.ci.level                  0.900000
#> rmsea.pvalue                    0.995046
#> rmsea.close.h0                  0.050000
#> rmsea.notclose.pvalue           0.002006
#> rmsea.notclose.h0               0.080000
#> rmsea.robust                    0.000000
#> rmsea.ci.lower.robust           0.000000
#> rmsea.ci.upper.robust           0.000000
#> rmsea.pvalue.robust             0.995040
#> rmsea.notclose.pvalue.robust    0.002286
#> rmr                             0.018360
#> rmr_nomean                      0.021190
#> srmr                            0.008270
#> srmr_bentler                    0.008270
#> srmr_bentler_nomean             0.009539
#> crmr                            0.009474
#> crmr_nomean                     0.011590
#> srmr_mplus                      0.008231
#> srmr_mplus_nomean               0.009493
#> gfi                             1.000000
#> gfi.ci.lower                    1.000000
#> gfi.ci.upper                    1.000000
#> gfi.ci.level                    0.900000
#> gfi.robust                      1.000000
#> gfi.ci.lower.robust             1.000000
#> gfi.ci.upper.robust             1.000000
#> cn_05                        2107.659245
#> cn_01                        2871.840703
#> gfi_lisrel                      0.993713
#> agfi_lisrel                     0.974853
#> pgfi                            0.248428
#> mfi                             1.022625
#> ecvi                            0.305255
#> 
#> $parameters
#>       lhs op    rhs exo     est     se      z          pvalue ci.lower ci.upper  std.lv std.all
#> 1  LATENT =~  ITEM1   0 1.00000 0.0000     NA              NA  1.00000   1.0000 0.97835 0.70135
#> 2  LATENT =~  ITEM2   0 1.16338 0.1836 6.3367 0.0000000002347  0.80354   1.5232 1.13819 0.73277
#> 3  LATENT =~  ITEM3   0 1.10536 0.1739 6.3556 0.0000000002076  0.76448   1.4462 1.08143 0.74473
#> 4  LATENT =~  ITEM4   0 1.24247 0.1957 6.3504 0.0000000002148  0.85900   1.6259 1.21557 0.76285
#> 5  LATENT =~  ITEM5   0 1.12691 0.1842 6.1185 0.0000000009444  0.76593   1.4879 1.10251 0.71687
#> 6   ITEM1 ~~  ITEM1   0 0.98870 0.1762 5.6098 0.0000000202596  0.64327   1.3341 0.98870 0.50810
#> 7   ITEM2 ~~  ITEM2   0 1.11715 0.2060 5.4243 0.0000000581926  0.71348   1.5208 1.11715 0.46304
#> 8   ITEM3 ~~  ITEM3   0 0.93911 0.1784 5.2645 0.0000001405424  0.58949   1.2887 0.93911 0.44537
#> 9   ITEM4 ~~  ITEM4   0 1.06150 0.2081 5.1015 0.0000003370276  0.65368   1.4693 1.06150 0.41806
#> 10  ITEM5 ~~  ITEM5   0 1.14974 0.2072 5.5482 0.0000000288673  0.74358   1.5559 1.14974 0.48609
#> 11 LATENT ~~ LATENT   0 0.95716 0.2616 3.6593 0.0002528699693  0.44450   1.4698 1.00000 1.00000
#> 12  ITEM1 ~1          0 0.14469 0.1417 1.0211 0.3071904169358 -0.13303   0.4224 0.14469 0.10372
#> 13  ITEM2 ~1          0 0.01840 0.1577 0.1167 0.9071082413696 -0.29065   0.3274 0.01840 0.01185
#> 14  ITEM3 ~1          0 0.02180 0.1473 0.1480 0.8823496601689 -0.26692   0.3105 0.02180 0.01501
#> 15  ITEM4 ~1          0 0.23276 0.1617 1.4394 0.1500266146215 -0.08417   0.5497 0.23276 0.14607
#> 16  ITEM5 ~1          0 0.07033 0.1562 0.4502 0.6525596789616 -0.23584   0.3765 0.07033 0.04573
#> 17 LATENT ~1          0 0.00000 0.0000     NA              NA  0.00000   0.0000 0.00000 0.00000
#> 18  ITEM1 r2  ITEM1   0 0.49190     NA     NA              NA       NA       NA      NA      NA
#> 19  ITEM2 r2  ITEM2   0 0.53696     NA     NA              NA       NA       NA      NA      NA
#> 20  ITEM3 r2  ITEM3   0 0.55463     NA     NA              NA       NA       NA      NA      NA
#> 21  ITEM4 r2  ITEM4   0 0.58194     NA     NA              NA       NA       NA      NA      NA
#> 22  ITEM5 r2  ITEM5   0 0.51391     NA     NA              NA       NA       NA      NA      NA
#> 
#> $modification_indices
#>       lhs op    rhs                       mi              epc          sepc.all delta    ncp   power decision
#> 27  ITEM4 ~~  ITEM5 0.2248866381322639496076  0.0808147066087  0.07315268450961   0.1 0.3443 0.09029      (i)
#> 21  ITEM1 ~~  ITEM5 0.2139931116690655665824 -0.0692648211491 -0.06496519421964   0.1 0.4460 0.10246      (i)
#> 18  ITEM1 ~~  ITEM2 0.1391623298547297049588  0.0563547573262  0.05362200851531   0.1 0.4382 0.10151      (i)
#> 19  ITEM1 ~~  ITEM3 0.1283585766575589814931  0.0505948935953  0.05250672125055   0.1 0.5014 0.10913      (i)
#> 23  ITEM2 ~~  ITEM4 0.0988350029163786447661 -0.0543623952421 -0.04992095911369   0.1 0.3344 0.08911      (i)
#> 20  ITEM1 ~~  ITEM4 0.0750056888118614123462 -0.0424467000615 -0.04143339502545   0.1 0.4163 0.09889      (i)
#> 26  ITEM3 ~~  ITEM5 0.0588625345014270051625 -0.0375882381110 -0.03617374408976   0.1 0.4166 0.09893      (i)
#> 22  ITEM2 ~~  ITEM3 0.0473618535279620375689 -0.0342007487801 -0.03339039650882   0.1 0.4049 0.09752      (i)
#> 24  ITEM2 ~~  ITEM5 0.0376420306554564390589  0.0321297282949  0.02834998450134   0.1 0.3646 0.09271      (i)
#> 25  ITEM3 ~~  ITEM4 0.0120351739748937019286  0.0178270281292  0.01785496512954   0.1 0.3787 0.09439      (i)
#> 10  ITEM5 ~~  ITEM5 0.0000000000030179052730  0.0000003452875  0.48609060856832   0.1 0.2531 0.07947      (i)
#> 7   ITEM2 ~~  ITEM2 0.0000000000025057046553 -0.0000003116274 -0.46304407718188   0.1 0.2580 0.08005      (i)
#> 6   ITEM1 ~~  ITEM1 0.0000000000012953911826 -0.0000001918632 -0.50810388610992   0.1 0.3519 0.09119      (i)
#> 11 LATENT ~~ LATENT 0.0000000000006175486245 -0.0000001258483 -1.00000000000000   0.1 0.3899 0.09573      (i)
#> 5  LATENT =~  ITEM5 0.0000000000005199108064 -0.0000000944862 -0.00000006010640   0.1 0.5824 0.11892      (i)
#> 4  LATENT =~  ITEM4 0.0000000000002809237877 -0.0000000683980 -0.00000004199483   0.1 0.6005 0.12112      (i)
#> 3  LATENT =~  ITEM3 0.0000000000001647664429 -0.0000000487738 -0.00000003286112   0.1 0.6926 0.13234      (i)
#> 9   ITEM4 ~~  ITEM4 0.0000000000001167063754  0.0000000667353  0.41806188145327   0.1 0.2620 0.08052      (i)
#> 8   ITEM3 ~~  ITEM3 0.0000000000000152681757  0.0000000207995  0.44537319997600   0.1 0.3529 0.09131      (i)
#> 12  ITEM1 ~1        0.0000000000000019608524  0.0000000048977  0.00000000351105   0.1 0.8174 0.14761      (i)
#> 15  ITEM4 ~1        0.0000000000000000724376  0.0000000010133  0.00000000063594   0.1 0.7054 0.13390      (i)
#> 16  ITEM5 ~1        0.0000000000000000475334  0.0000000008279  0.00000000053834   0.1 0.6934 0.13243      (i)
#> 14  ITEM3 ~1        0.0000000000000000207625 -0.0000000005037 -0.00000000034684   0.1 0.8185 0.14774      (i)
#> 2  LATENT =~  ITEM2 0.0000000000000000008048  0.0000000001168  0.00000000007355   0.1 0.5902 0.11987      (i)
#> 13  ITEM2 ~1        0.0000000000000000007324  0.0000000001023  0.00000000006585   0.1 0.7000 0.13324      (i)
#> 
#> $sample_covariance
#>      X1    X2    X3    X4    X5
#> 1 1.955 1.127 1.162 1.150 1.041
#> 2 1.127 2.435 1.315 1.377 1.334
#> 3 1.162 1.315 2.148 1.364 1.226
#> 4 1.150 1.377 1.364 2.518 1.388
#> 5 1.041 1.334 1.226 1.388 2.385
#> 
#> $unstandardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  1.163
#> ITEM3  1.105
#> ITEM4  1.242
#> ITEM5  1.127
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.989                        
#> ITEM2 0.000 1.117                  
#> ITEM3 0.000 0.000 0.939            
#> ITEM4 0.000 0.000 0.000 1.062      
#> ITEM5 0.000 0.000 0.000 0.000 1.150
#> 
#> $psi
#>        LATENT
#> LATENT  0.957
#> 
#> $nu
#>       intrcp
#> ITEM1  0.145
#> ITEM2  0.018
#> ITEM3  0.022
#> ITEM4  0.233
#> ITEM5  0.070
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> 
#> $standardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  0.701
#> ITEM2  0.733
#> ITEM3  0.745
#> ITEM4  0.763
#> ITEM5  0.717
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.508                        
#> ITEM2 0.000 0.463                  
#> ITEM3 0.000 0.000 0.445            
#> ITEM4 0.000 0.000 0.000 0.418      
#> ITEM5 0.000 0.000 0.000 0.000 0.486
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1  0.104
#> ITEM2  0.012
#> ITEM3  0.015
#> ITEM4  0.146
#> ITEM5  0.046
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> 
#> $group
#> data frame with 0 columns and 0 rows
#> 
#> $predict
#>           X1       X2         X3       X4       X5     LATENT
#> 1   -0.52177 -0.37626  0.2638611  1.14615 -1.97366 -0.2433427
#> 2   -1.08077 -1.31484  2.1854301  0.02173 -0.27684 -0.0937915
#> 3   -0.60951  1.57712 -0.4266277  1.34491  0.63135  0.3064489
#> 4    0.15098 -0.87772 -1.4812360 -1.81010 -1.25122 -0.8954498
#> 5   -0.90163  1.53209 -1.5192033  1.14297  0.15360 -0.0208697
#> 6   -0.99794 -0.37516 -0.0116650  1.43547  2.02052  0.2405180
#> 7   -0.07478  0.25470 -0.9277173 -1.80911 -1.38335 -0.6886341
#> 8   -0.27210  0.35066         NA  0.98704       NA  0.1709743
#> 9    0.86442 -1.51731         NA  0.24405  0.17144 -0.1302625
#> 10   0.24016 -0.07390  1.2427643  0.57124 -0.57133  0.1690362
#> 11   0.62584 -1.67334  0.1656848 -0.24110 -1.74076 -0.4820031
#> 12   0.25837  2.08974 -0.2946629  0.73183 -2.81117 -0.0477847
#> 13   0.38866  1.41573  1.6954807  1.46111  0.09219  0.7198919
#> 14   1.31690 -0.63767  0.1402924 -0.77073  0.19864 -0.0570931
#> 15   0.82499 -1.78450 -0.1017759  1.20476 -0.05612 -0.0450516
#> 16  -0.40629 -0.99026 -0.7424018 -0.45831 -1.60902 -0.6961769
#> 17        NA  1.74825  0.3316355  1.59700 -0.65307  0.4993180
#> 18  -0.64576 -0.62986  1.1891556 -1.07114  0.02270 -0.2347836
#> 19   0.86689  2.78046  1.6860681 -0.12423 -0.05403  0.7051441
#> 20   0.08371  2.05241  1.4643413 -0.31114  1.02543  0.5687692
#> 21  -0.74292 -0.21561 -0.3278453 -0.28209 -1.75838 -0.5539087
#> 22  -0.71380  0.02556  0.4198880  0.06379  1.74279  0.1472036
#> 23   0.29940  0.55615 -0.6361672  1.14492 -0.95167  0.0011230
#> 24  -1.14582 -3.22306 -1.0415625 -2.44665  0.59979 -1.1995266
#> 25   1.20247 -1.60981 -0.8815551  0.72915  0.01051 -0.1636747
#> 26   0.08677  2.65405 -0.3436889       NA  3.58174  1.0042975
#> 27   0.29319  1.59279  2.1504296  2.30290  1.33464  1.1164353
#> 28        NA -0.47035  0.0063514  0.13148 -1.13530 -0.2987812
#> 29   2.46501  2.22386  2.9904502  3.20902  3.81151  2.1449553
#> 30   2.69788  3.39628  1.4013788  2.00824  2.41633  1.6978349
#> 31   0.78379  0.62428 -0.8395647  1.12086 -0.83417  0.0584301
#> 32  -1.36483  0.61108 -1.7599862       NA  0.01836 -0.5389643
#> 33   1.29329  2.06942  0.6101684  0.14869 -0.13824  0.5173319
#> 34  -1.27382 -0.90301 -1.5121763       NA -1.54916 -1.0200656
#> 35   1.64991       NA -0.3243972  0.18861 -0.42239  0.0980920
#> 36   1.58836 -0.72328 -0.4429537  1.93325 -1.28879  0.1121035
#> 37   1.52359  0.78390 -1.2987526  0.34797 -1.44629 -0.1001951
#> 38   0.48479  0.71451  0.5702436  0.59200  2.96890  0.6981289
#> 39  -0.38632 -0.37368 -0.5246403  0.28446  1.63123  0.0002643
#> 40  -3.34163       NA -1.3574878 -1.53052 -0.54435 -1.3211448
#> 41        NA  0.25727  0.6004728 -1.32259 -1.46604 -0.3918317
#> 42   0.02548  0.06416  0.3601861 -0.96761 -0.73640 -0.2624094
#> 43   1.35767  2.39758 -0.5848915  1.10109  1.55722  0.7666185
#> 44  -1.14012 -1.56646 -0.6195809 -3.16323 -1.41331 -1.2815016
#> 45  -1.58820       NA -0.1042343       NA       NA -0.5662518
#> 46  -1.13929  1.37678 -0.0118645  1.67092  0.46863  0.3016532
#> 47   1.94471  1.98492  0.6514518  1.38411  0.77475  0.9326716
#> 48   0.53258 -0.16566  0.9234091  2.38104  2.20529  0.8234179
#> 49  -1.48655 -0.47653         NA  0.90730 -1.33484 -0.4724975
#> 50  -2.74633 -2.88650 -1.8255062 -0.64877 -1.28711 -1.4711592
#> 51   0.19378 -1.96511 -1.5715437  0.08512  0.12519 -0.5626562
#> 52   0.37600 -0.74021  0.1026112  2.38986  0.39287  0.3339226
#> 53  -0.98580 -0.32752  0.6421612  0.74878 -0.33443 -0.0794366
#> 54   1.71970  1.29708  2.0068943  1.33454  1.29648  1.0876838
#> 55  -0.86408 -1.09895 -1.0141944 -3.00041 -1.68216 -1.2494194
#> 56  -2.91009 -1.71294 -3.2523432 -3.98988 -2.35404 -2.2539481
#> 57   0.50087 -0.53235  0.0433118 -0.43476  1.91439  0.1175958
#> 58  -0.99882  1.02054  0.8731154  2.16048  3.35388  0.8928406
#> 59        NA  2.54190  0.3894242  3.16089  2.58182  1.4632742
#> 60  -0.29329 -0.75969 -3.4456853 -4.51592 -2.24251 -1.8463171
#> 61  -0.80974 -0.77366 -3.0050260 -1.23074 -0.65684 -1.0913338
#> 62  -0.05053  0.49525 -0.2836893 -0.65113 -1.21072 -0.3297934
#> 63   2.39536  1.57845  2.0525307  0.80214       NA  1.1551782
#> 64   0.51578 -0.59047  0.2385814  0.29267  0.37435  0.0511450
#> 65   0.74224 -0.92972 -0.5522690 -1.65320  0.53248 -0.3946868
#> 66   2.04211  1.56275  2.3085326  1.56169  4.13441  1.6496243
#> 67   0.63149 -2.63066 -0.6765335 -1.40554 -2.57179 -1.0656560
#> 68   0.13999  0.43021  1.2698622  2.37530  0.10923  0.6227987
#> 69  -2.10589 -0.10386 -1.8905290 -0.05841 -1.67882 -0.9413753
#> 70   1.01574  0.35279  1.3558500  0.93517  0.85445  0.6159404
#> 71   1.39052  2.28689 -0.1008021  0.01944  1.34268  0.6279199
#> 72   3.66711  2.64220  4.4615415  3.69197  1.82881  2.4262479
#> 73  -0.73933 -0.88661  1.1307115  0.63375       NA -0.0102960
#> 74   2.58399  0.39786         NA -0.66232  2.57255  0.7323782
#> 75  -0.46241  1.30983  0.2208964  0.18816  1.32323  0.3003848
#> 76  -1.17710 -2.01981 -1.2669019 -0.85618 -2.18118 -1.1866140
#> 77  -0.65779  0.20058 -0.7310786 -0.49348 -0.59806 -0.4227600
#> 78  -2.10764 -2.21589  0.7680871 -1.70093 -1.76300 -1.0924763
#> 79   2.00726  0.87148  2.0367901  0.31910  1.10635  0.8783422
#> 80  -2.36009 -1.56580 -0.1903303 -0.30115       NA -0.8397393
#> 81  -0.25833 -1.68527  0.0004032  0.79251  0.61085 -0.1433872
#> 82   0.59765       NA  0.4673238  1.09821  0.21801  0.3617738
#> 83   3.29340  0.57335  2.2466083  3.16310  0.73085  1.4673419
#> 84   0.10432 -2.04344 -1.0940275  1.64188 -0.43369 -0.3291450
#> 85   1.14176 -2.25175  0.0057519 -1.49549 -0.98194 -0.6213588
#> 86        NA  1.29820  0.2758400  2.46739  0.20785  0.7164916
#> 87   0.10958  0.99187  1.8518617 -0.14102 -0.42702  0.3096868
#> 88  -1.82275 -3.73423 -4.2301137 -2.14703 -1.50323 -2.1368100
#> 89   2.68240  0.35199 -0.6025905  2.30867  2.54410  0.9868263
#> 90   1.94949  1.33611  1.1109751  1.43583  0.53189  0.8895358
#> 91  -1.90785  0.02778  0.4530989 -1.99704 -0.92791 -0.7221150
#> 92  -1.05989 -1.36406         NA  1.36691 -0.16614 -0.2681339
#> 93   0.66160  0.72626  0.5261177 -0.53033 -0.45870  0.0619938
#> 94   1.60615  3.13618  2.5825152  1.88646  3.22990  1.7918412
#> 95  -1.16293       NA  0.6231777 -0.05532 -0.74392 -0.2958049
#> 96   1.36260  0.91533  1.3885984 -0.14716  1.96845  0.7282130
#> 97  -1.17734 -3.90858 -1.5031215 -2.09820 -1.38527 -1.5961309
#> 98   1.96652  0.77161  0.7319926  2.82024  0.38433  0.9539451
#> 99  -1.17341 -1.45245 -4.0148481       NA -1.21936 -1.5652663
#> 100  0.17491 -0.33964 -1.8113959 -1.24574 -0.71666 -0.7017719
#> 
#> $call
#>                                                                call
#> 1 lavaan::lavaan(model=model,data=df,missing="ML",model.type="cfa",
#> 2 cmd="cfa",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,
#> 3            auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,
#> 4       auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)
#> 
report_cfa(fit,file="cfa")
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.labels’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.class’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘list.by.group’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘drop.list.single.group’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.labels’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.class’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘list.by.group’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘drop.list.single.group’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.labels’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.class’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘list.by.group’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘drop.list.single.group’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.labels’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘add.class’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘list.by.group’ for ‘inspect’
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument ‘drop.list.single.group’ for ‘inspect’
#> Skipping circle_parameters_wih_equality_constraints: replacement has 0 rows, data has 5
#> Skipping tree_parameters_wih_equality_constraints: replacement has 0 rows, data has 5
#> Skipping spring_parameters_wih_equality_constraints: replacement has 0 rows, data has 5






#> [1] "##################################################"
#> [1] "SUMMARY"
#> [1] "##################################################"
#> lavaan 0.7-3 ended normally after 25 iterations
#> 
#>   Estimator                                         ML
#>   Optimization method                           NLMINB
#>   Number of model parameters                        15
#> 
#>   Number of observations                           100
#>   Number of missing patterns                         8
#> 
#> Model Test User Model:
#>                                                       
#>   Test statistic                                 0.526
#>   Degrees of freedom                                 5
#>   P-value (Chi-square)                           0.991
#>                                                       
#>   Browne's residual (NT model-based) test             
#>   Test statistic                                 0.957
#>   Degrees of freedom                                 5
#>   P-value (Chi-square)                           0.966
#> 
#> Model Test Baseline Model:
#> 
#>   Test statistic                               181.936
#>   Degrees of freedom                                10
#>   P-value                                        0.000
#> 
#> User Model versus Baseline Model:
#> 
#>   Comparative Fit Index (CFI)                    1.000
#>   Tucker-Lewis Index (TLI)                       1.052
#>                                                       
#>   Robust Comparative Fit Index (CFI)             1.000
#>   Robust Tucker-Lewis Index (TLI)                1.058
#> 
#> Loglikelihood and Information Criteria:
#> 
#>   Loglikelihood user model (H0)               -778.757
#>   Loglikelihood unrestricted model (H1)       -778.494
#>                                                       
#>   Akaike (AIC)                                1587.514
#>   Bayesian (BIC)                              1626.591
#>   Sample-size adjusted Bayesian (SABIC)       1579.218
#> 
#> Root Mean Square Error of Approximation:
#> 
#>   RMSEA                                          0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.000
#>   P-value H_0: RMSEA <= 0.050                    0.995
#>   P-value H_0: RMSEA >= 0.080                    0.002
#>                                                       
#>   Robust RMSEA                                   0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.000
#>   P-value H_0: Robust RMSEA <= 0.050             0.995
#>   P-value H_0: Robust RMSEA >= 0.080             0.002
#> 
#> Standardized Root Mean Square Residual:
#> 
#>   SRMR                                           0.008
#> 
#> Goodness of Fit Index:
#> 
#>   Goodness of Fit Index (GFI)                    1.000
#>   90 Percent confidence interval - lower         1.000
#>   90 Percent confidence interval - upper         1.000
#>                                                       
#>   Robust GFI                                     1.000
#>   90 Percent confidence interval - lower         1.000
#>   90 Percent confidence interval - upper         1.000
#> 
#> Parameter Estimates:
#> 
#>   Standard errors                             Standard
#>   Information                                 Observed
#>   Observed information based on                Hessian
#> 
#> Latent Variables:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>   LATENT =~                                                             
#>     ITEM1             1.000                               0.978    0.701
#>     ITEM2             1.163    0.184    6.337    0.000    1.138    0.733
#>     ITEM3             1.105    0.174    6.356    0.000    1.081    0.745
#>     ITEM4             1.242    0.196    6.350    0.000    1.216    0.763
#>     ITEM5             1.127    0.184    6.119    0.000    1.103    0.717
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1             0.145    0.142    1.021    0.307    0.145    0.104
#>    .ITEM2             0.018    0.158    0.117    0.907    0.018    0.012
#>    .ITEM3             0.022    0.147    0.148    0.882    0.022    0.015
#>    .ITEM4             0.233    0.162    1.439    0.150    0.233    0.146
#>    .ITEM5             0.070    0.156    0.450    0.653    0.070    0.046
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1             0.989    0.176    5.610    0.000    0.989    0.508
#>    .ITEM2             1.117    0.206    5.424    0.000    1.117    0.463
#>    .ITEM3             0.939    0.178    5.265    0.000    0.939    0.445
#>    .ITEM4             1.062    0.208    5.101    0.000    1.062    0.418
#>    .ITEM5             1.150    0.207    5.548    0.000    1.150    0.486
#>     LATENT            0.957    0.262    3.659    0.000    1.000    1.000
#> 
#> R-Square:
#>                    Estimate
#>     ITEM1             0.492
#>     ITEM2             0.537
#>     ITEM3             0.555
#>     ITEM4             0.582
#>     ITEM5             0.514
#> 
#> [1] "##################################################"
#> [1] "R_SQUARED"
#> [1] "##################################################"
#>       r_squared
#> ITEM1    0.4919
#> ITEM2    0.5370
#> ITEM3    0.5546
#> ITEM4    0.5819
#> ITEM5    0.5139
#> [1] "##################################################"
#> [1] "FIT INDICES"
#> [1] "##################################################"
#>                                      fit
#> npar                           15.000000
#> fmin                            0.002628
#> chisq                           0.525500
#> df                              5.000000
#> pvalue                          0.991160
#> baseline.chisq                181.936078
#> baseline.df                    10.000000
#> baseline.pvalue                 0.000000
#> cfi                             1.000000
#> tli                             1.052048
#> cfi.robust                      1.000000
#> tli.robust                      1.057638
#> nnfi                            1.052048
#> rfi                             0.994223
#> nfi                             0.997112
#> pnfi                            0.498556
#> ifi                             1.025289
#> rni                             1.026024
#> nnfi.robust                     1.057638
#> rni.robust                      1.028819
#> logl                         -778.756960
#> unrestricted.logl            -778.494210
#> aic                          1587.513919
#> bic                          1626.591472
#> ntotal                        100.000000
#> bic2                         1579.217704
#> rmsea                           0.000000
#> rmsea.ci.lower                  0.000000
#> rmsea.ci.upper                  0.000000
#> rmsea.ci.level                  0.900000
#> rmsea.pvalue                    0.995046
#> rmsea.close.h0                  0.050000
#> rmsea.notclose.pvalue           0.002006
#> rmsea.notclose.h0               0.080000
#> rmsea.robust                    0.000000
#> rmsea.ci.lower.robust           0.000000
#> rmsea.ci.upper.robust           0.000000
#> rmsea.pvalue.robust             0.995040
#> rmsea.notclose.pvalue.robust    0.002286
#> rmr                             0.018360
#> rmr_nomean                      0.021190
#> srmr                            0.008270
#> srmr_bentler                    0.008270
#> srmr_bentler_nomean             0.009539
#> crmr                            0.009474
#> crmr_nomean                     0.011590
#> srmr_mplus                      0.008231
#> srmr_mplus_nomean               0.009493
#> gfi                             1.000000
#> gfi.ci.lower                    1.000000
#> gfi.ci.upper                    1.000000
#> gfi.ci.level                    0.900000
#> gfi.robust                      1.000000
#> gfi.ci.lower.robust             1.000000
#> gfi.ci.upper.robust             1.000000
#> cn_05                        2107.659245
#> cn_01                        2871.840703
#> gfi_lisrel                      0.993713
#> agfi_lisrel                     0.974853
#> pgfi                            0.248428
#> mfi                             1.022625
#> ecvi                            0.305255
#> [1] "##################################################"
#> [1] "PARAMETERS"
#> [1] "##################################################"
#>       lhs op    rhs exo     est     se      z          pvalue ci.lower ci.upper  std.lv std.all
#> 1  LATENT =~  ITEM1   0 1.00000 0.0000     NA              NA  1.00000   1.0000 0.97835 0.70135
#> 2  LATENT =~  ITEM2   0 1.16338 0.1836 6.3367 0.0000000002347  0.80354   1.5232 1.13819 0.73277
#> 3  LATENT =~  ITEM3   0 1.10536 0.1739 6.3556 0.0000000002076  0.76448   1.4462 1.08143 0.74473
#> 4  LATENT =~  ITEM4   0 1.24247 0.1957 6.3504 0.0000000002148  0.85900   1.6259 1.21557 0.76285
#> 5  LATENT =~  ITEM5   0 1.12691 0.1842 6.1185 0.0000000009444  0.76593   1.4879 1.10251 0.71687
#> 6   ITEM1 ~~  ITEM1   0 0.98870 0.1762 5.6098 0.0000000202596  0.64327   1.3341 0.98870 0.50810
#> 7   ITEM2 ~~  ITEM2   0 1.11715 0.2060 5.4243 0.0000000581926  0.71348   1.5208 1.11715 0.46304
#> 8   ITEM3 ~~  ITEM3   0 0.93911 0.1784 5.2645 0.0000001405424  0.58949   1.2887 0.93911 0.44537
#> 9   ITEM4 ~~  ITEM4   0 1.06150 0.2081 5.1015 0.0000003370276  0.65368   1.4693 1.06150 0.41806
#> 10  ITEM5 ~~  ITEM5   0 1.14974 0.2072 5.5482 0.0000000288673  0.74358   1.5559 1.14974 0.48609
#> 11 LATENT ~~ LATENT   0 0.95716 0.2616 3.6593 0.0002528699693  0.44450   1.4698 1.00000 1.00000
#> 12  ITEM1 ~1          0 0.14469 0.1417 1.0211 0.3071904169358 -0.13303   0.4224 0.14469 0.10372
#> 13  ITEM2 ~1          0 0.01840 0.1577 0.1167 0.9071082413696 -0.29065   0.3274 0.01840 0.01185
#> 14  ITEM3 ~1          0 0.02180 0.1473 0.1480 0.8823496601689 -0.26692   0.3105 0.02180 0.01501
#> 15  ITEM4 ~1          0 0.23276 0.1617 1.4394 0.1500266146215 -0.08417   0.5497 0.23276 0.14607
#> 16  ITEM5 ~1          0 0.07033 0.1562 0.4502 0.6525596789616 -0.23584   0.3765 0.07033 0.04573
#> 17 LATENT ~1          0 0.00000 0.0000     NA              NA  0.00000   0.0000 0.00000 0.00000
#> 18  ITEM1 r2  ITEM1   0 0.49190     NA     NA              NA       NA       NA      NA      NA
#> 19  ITEM2 r2  ITEM2   0 0.53696     NA     NA              NA       NA       NA      NA      NA
#> 20  ITEM3 r2  ITEM3   0 0.55463     NA     NA              NA       NA       NA      NA      NA
#> 21  ITEM4 r2  ITEM4   0 0.58194     NA     NA              NA       NA       NA      NA      NA
#> 22  ITEM5 r2  ITEM5   0 0.51391     NA     NA              NA       NA       NA      NA      NA
#> [1] "##################################################"
#> [1] "UNSTANDARDIZED PARAMETERS"
#> [1] "##################################################"
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  1.163
#> ITEM3  1.105
#> ITEM4  1.242
#> ITEM5  1.127
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.989                        
#> ITEM2 0.000 1.117                  
#> ITEM3 0.000 0.000 0.939            
#> ITEM4 0.000 0.000 0.000 1.062      
#> ITEM5 0.000 0.000 0.000 0.000 1.150
#> 
#> $psi
#>        LATENT
#> LATENT  0.957
#> 
#> $nu
#>       intrcp
#> ITEM1  0.145
#> ITEM2  0.018
#> ITEM3  0.022
#> ITEM4  0.233
#> ITEM5  0.070
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> [1] "##################################################"
#> [1] "STANDARDIZED PARAMETERS"
#> [1] "##################################################"
#> $lambda
#>       LATENT
#> ITEM1  0.701
#> ITEM2  0.733
#> ITEM3  0.745
#> ITEM4  0.763
#> ITEM5  0.717
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.508                        
#> ITEM2 0.000 0.463                  
#> ITEM3 0.000 0.000 0.445            
#> ITEM4 0.000 0.000 0.000 0.418      
#> ITEM5 0.000 0.000 0.000 0.000 0.486
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1  0.104
#> ITEM2  0.012
#> ITEM3  0.015
#> ITEM4  0.146
#> ITEM5  0.046
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> [1] "##################################################"
#> [1] "SAMPLE COVARIANCE"
#> [1] "##################################################"
#>      X1    X2    X3    X4    X5
#> 1 1.955 1.127 1.162 1.150 1.041
#> 2 1.127 2.435 1.315 1.377 1.334
#> 3 1.162 1.315 2.148 1.364 1.226
#> 4 1.150 1.377 1.364 2.518 1.388
#> 5 1.041 1.334 1.226 1.388 2.385
#> [1] "##################################################"
#> [1] "CALL"
#> [1] "##################################################"
#> [1] "lavaan::lavaan(model=model,data=df,missing=\"ML\",model.type=\"cfa\"," "cmd=\"cfa\",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,"  
#> [3] "auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,"                "auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)"          
#> NULL
#> $r_squared
#>       r_squared
#> ITEM1    0.4919
#> ITEM2    0.5370
#> ITEM3    0.5546
#> ITEM4    0.5819
#> ITEM5    0.5139
#> 
#> $fit_indices
#>                                      fit
#> npar                           15.000000
#> fmin                            0.002628
#> chisq                           0.525500
#> df                              5.000000
#> pvalue                          0.991160
#> baseline.chisq                181.936078
#> baseline.df                    10.000000
#> baseline.pvalue                 0.000000
#> cfi                             1.000000
#> tli                             1.052048
#> cfi.robust                      1.000000
#> tli.robust                      1.057638
#> nnfi                            1.052048
#> rfi                             0.994223
#> nfi                             0.997112
#> pnfi                            0.498556
#> ifi                             1.025289
#> rni                             1.026024
#> nnfi.robust                     1.057638
#> rni.robust                      1.028819
#> logl                         -778.756960
#> unrestricted.logl            -778.494210
#> aic                          1587.513919
#> bic                          1626.591472
#> ntotal                        100.000000
#> bic2                         1579.217704
#> rmsea                           0.000000
#> rmsea.ci.lower                  0.000000
#> rmsea.ci.upper                  0.000000
#> rmsea.ci.level                  0.900000
#> rmsea.pvalue                    0.995046
#> rmsea.close.h0                  0.050000
#> rmsea.notclose.pvalue           0.002006
#> rmsea.notclose.h0               0.080000
#> rmsea.robust                    0.000000
#> rmsea.ci.lower.robust           0.000000
#> rmsea.ci.upper.robust           0.000000
#> rmsea.pvalue.robust             0.995040
#> rmsea.notclose.pvalue.robust    0.002286
#> rmr                             0.018360
#> rmr_nomean                      0.021190
#> srmr                            0.008270
#> srmr_bentler                    0.008270
#> srmr_bentler_nomean             0.009539
#> crmr                            0.009474
#> crmr_nomean                     0.011590
#> srmr_mplus                      0.008231
#> srmr_mplus_nomean               0.009493
#> gfi                             1.000000
#> gfi.ci.lower                    1.000000
#> gfi.ci.upper                    1.000000
#> gfi.ci.level                    0.900000
#> gfi.robust                      1.000000
#> gfi.ci.lower.robust             1.000000
#> gfi.ci.upper.robust             1.000000
#> cn_05                        2107.659245
#> cn_01                        2871.840703
#> gfi_lisrel                      0.993713
#> agfi_lisrel                     0.974853
#> pgfi                            0.248428
#> mfi                             1.022625
#> ecvi                            0.305255
#> 
#> $parameters
#>       lhs op    rhs exo     est     se      z          pvalue ci.lower ci.upper  std.lv std.all
#> 1  LATENT =~  ITEM1   0 1.00000 0.0000     NA              NA  1.00000   1.0000 0.97835 0.70135
#> 2  LATENT =~  ITEM2   0 1.16338 0.1836 6.3367 0.0000000002347  0.80354   1.5232 1.13819 0.73277
#> 3  LATENT =~  ITEM3   0 1.10536 0.1739 6.3556 0.0000000002076  0.76448   1.4462 1.08143 0.74473
#> 4  LATENT =~  ITEM4   0 1.24247 0.1957 6.3504 0.0000000002148  0.85900   1.6259 1.21557 0.76285
#> 5  LATENT =~  ITEM5   0 1.12691 0.1842 6.1185 0.0000000009444  0.76593   1.4879 1.10251 0.71687
#> 6   ITEM1 ~~  ITEM1   0 0.98870 0.1762 5.6098 0.0000000202596  0.64327   1.3341 0.98870 0.50810
#> 7   ITEM2 ~~  ITEM2   0 1.11715 0.2060 5.4243 0.0000000581926  0.71348   1.5208 1.11715 0.46304
#> 8   ITEM3 ~~  ITEM3   0 0.93911 0.1784 5.2645 0.0000001405424  0.58949   1.2887 0.93911 0.44537
#> 9   ITEM4 ~~  ITEM4   0 1.06150 0.2081 5.1015 0.0000003370276  0.65368   1.4693 1.06150 0.41806
#> 10  ITEM5 ~~  ITEM5   0 1.14974 0.2072 5.5482 0.0000000288673  0.74358   1.5559 1.14974 0.48609
#> 11 LATENT ~~ LATENT   0 0.95716 0.2616 3.6593 0.0002528699693  0.44450   1.4698 1.00000 1.00000
#> 12  ITEM1 ~1          0 0.14469 0.1417 1.0211 0.3071904169358 -0.13303   0.4224 0.14469 0.10372
#> 13  ITEM2 ~1          0 0.01840 0.1577 0.1167 0.9071082413696 -0.29065   0.3274 0.01840 0.01185
#> 14  ITEM3 ~1          0 0.02180 0.1473 0.1480 0.8823496601689 -0.26692   0.3105 0.02180 0.01501
#> 15  ITEM4 ~1          0 0.23276 0.1617 1.4394 0.1500266146215 -0.08417   0.5497 0.23276 0.14607
#> 16  ITEM5 ~1          0 0.07033 0.1562 0.4502 0.6525596789616 -0.23584   0.3765 0.07033 0.04573
#> 17 LATENT ~1          0 0.00000 0.0000     NA              NA  0.00000   0.0000 0.00000 0.00000
#> 18  ITEM1 r2  ITEM1   0 0.49190     NA     NA              NA       NA       NA      NA      NA
#> 19  ITEM2 r2  ITEM2   0 0.53696     NA     NA              NA       NA       NA      NA      NA
#> 20  ITEM3 r2  ITEM3   0 0.55463     NA     NA              NA       NA       NA      NA      NA
#> 21  ITEM4 r2  ITEM4   0 0.58194     NA     NA              NA       NA       NA      NA      NA
#> 22  ITEM5 r2  ITEM5   0 0.51391     NA     NA              NA       NA       NA      NA      NA
#> 
#> $modification_indices
#>       lhs op    rhs                       mi              epc          sepc.all delta    ncp   power decision
#> 27  ITEM4 ~~  ITEM5 0.2248866381322639496076  0.0808147066087  0.07315268450961   0.1 0.3443 0.09029      (i)
#> 21  ITEM1 ~~  ITEM5 0.2139931116690655665824 -0.0692648211491 -0.06496519421964   0.1 0.4460 0.10246      (i)
#> 18  ITEM1 ~~  ITEM2 0.1391623298547297049588  0.0563547573262  0.05362200851531   0.1 0.4382 0.10151      (i)
#> 19  ITEM1 ~~  ITEM3 0.1283585766575589814931  0.0505948935953  0.05250672125055   0.1 0.5014 0.10913      (i)
#> 23  ITEM2 ~~  ITEM4 0.0988350029163786447661 -0.0543623952421 -0.04992095911369   0.1 0.3344 0.08911      (i)
#> 20  ITEM1 ~~  ITEM4 0.0750056888118614123462 -0.0424467000615 -0.04143339502545   0.1 0.4163 0.09889      (i)
#> 26  ITEM3 ~~  ITEM5 0.0588625345014270051625 -0.0375882381110 -0.03617374408976   0.1 0.4166 0.09893      (i)
#> 22  ITEM2 ~~  ITEM3 0.0473618535279620375689 -0.0342007487801 -0.03339039650882   0.1 0.4049 0.09752      (i)
#> 24  ITEM2 ~~  ITEM5 0.0376420306554564390589  0.0321297282949  0.02834998450134   0.1 0.3646 0.09271      (i)
#> 25  ITEM3 ~~  ITEM4 0.0120351739748937019286  0.0178270281292  0.01785496512954   0.1 0.3787 0.09439      (i)
#> 10  ITEM5 ~~  ITEM5 0.0000000000030179052730  0.0000003452875  0.48609060856832   0.1 0.2531 0.07947      (i)
#> 7   ITEM2 ~~  ITEM2 0.0000000000025057046553 -0.0000003116274 -0.46304407718188   0.1 0.2580 0.08005      (i)
#> 6   ITEM1 ~~  ITEM1 0.0000000000012953911826 -0.0000001918632 -0.50810388610992   0.1 0.3519 0.09119      (i)
#> 11 LATENT ~~ LATENT 0.0000000000006175486245 -0.0000001258483 -1.00000000000000   0.1 0.3899 0.09573      (i)
#> 5  LATENT =~  ITEM5 0.0000000000005199108064 -0.0000000944862 -0.00000006010640   0.1 0.5824 0.11892      (i)
#> 4  LATENT =~  ITEM4 0.0000000000002809237877 -0.0000000683980 -0.00000004199483   0.1 0.6005 0.12112      (i)
#> 3  LATENT =~  ITEM3 0.0000000000001647664429 -0.0000000487738 -0.00000003286112   0.1 0.6926 0.13234      (i)
#> 9   ITEM4 ~~  ITEM4 0.0000000000001167063754  0.0000000667353  0.41806188145327   0.1 0.2620 0.08052      (i)
#> 8   ITEM3 ~~  ITEM3 0.0000000000000152681757  0.0000000207995  0.44537319997600   0.1 0.3529 0.09131      (i)
#> 12  ITEM1 ~1        0.0000000000000019608524  0.0000000048977  0.00000000351105   0.1 0.8174 0.14761      (i)
#> 15  ITEM4 ~1        0.0000000000000000724376  0.0000000010133  0.00000000063594   0.1 0.7054 0.13390      (i)
#> 16  ITEM5 ~1        0.0000000000000000475334  0.0000000008279  0.00000000053834   0.1 0.6934 0.13243      (i)
#> 14  ITEM3 ~1        0.0000000000000000207625 -0.0000000005037 -0.00000000034684   0.1 0.8185 0.14774      (i)
#> 2  LATENT =~  ITEM2 0.0000000000000000008048  0.0000000001168  0.00000000007355   0.1 0.5902 0.11987      (i)
#> 13  ITEM2 ~1        0.0000000000000000007324  0.0000000001023  0.00000000006585   0.1 0.7000 0.13324      (i)
#> 
#> $sample_covariance
#>      X1    X2    X3    X4    X5
#> 1 1.955 1.127 1.162 1.150 1.041
#> 2 1.127 2.435 1.315 1.377 1.334
#> 3 1.162 1.315 2.148 1.364 1.226
#> 4 1.150 1.377 1.364 2.518 1.388
#> 5 1.041 1.334 1.226 1.388 2.385
#> 
#> $unstandardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  1.163
#> ITEM3  1.105
#> ITEM4  1.242
#> ITEM5  1.127
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.989                        
#> ITEM2 0.000 1.117                  
#> ITEM3 0.000 0.000 0.939            
#> ITEM4 0.000 0.000 0.000 1.062      
#> ITEM5 0.000 0.000 0.000 0.000 1.150
#> 
#> $psi
#>        LATENT
#> LATENT  0.957
#> 
#> $nu
#>       intrcp
#> ITEM1  0.145
#> ITEM2  0.018
#> ITEM3  0.022
#> ITEM4  0.233
#> ITEM5  0.070
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> 
#> $standardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  0.701
#> ITEM2  0.733
#> ITEM3  0.745
#> ITEM4  0.763
#> ITEM5  0.717
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.508                        
#> ITEM2 0.000 0.463                  
#> ITEM3 0.000 0.000 0.445            
#> ITEM4 0.000 0.000 0.000 0.418      
#> ITEM5 0.000 0.000 0.000 0.000 0.486
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1  0.104
#> ITEM2  0.012
#> ITEM3  0.015
#> ITEM4  0.146
#> ITEM5  0.046
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> 
#> $group
#> data frame with 0 columns and 0 rows
#> 
#> $predict
#>           X1       X2         X3       X4       X5     LATENT
#> 1   -0.52177 -0.37626  0.2638611  1.14615 -1.97366 -0.2433427
#> 2   -1.08077 -1.31484  2.1854301  0.02173 -0.27684 -0.0937915
#> 3   -0.60951  1.57712 -0.4266277  1.34491  0.63135  0.3064489
#> 4    0.15098 -0.87772 -1.4812360 -1.81010 -1.25122 -0.8954498
#> 5   -0.90163  1.53209 -1.5192033  1.14297  0.15360 -0.0208697
#> 6   -0.99794 -0.37516 -0.0116650  1.43547  2.02052  0.2405180
#> 7   -0.07478  0.25470 -0.9277173 -1.80911 -1.38335 -0.6886341
#> 8   -0.27210  0.35066         NA  0.98704       NA  0.1709743
#> 9    0.86442 -1.51731         NA  0.24405  0.17144 -0.1302625
#> 10   0.24016 -0.07390  1.2427643  0.57124 -0.57133  0.1690362
#> 11   0.62584 -1.67334  0.1656848 -0.24110 -1.74076 -0.4820031
#> 12   0.25837  2.08974 -0.2946629  0.73183 -2.81117 -0.0477847
#> 13   0.38866  1.41573  1.6954807  1.46111  0.09219  0.7198919
#> 14   1.31690 -0.63767  0.1402924 -0.77073  0.19864 -0.0570931
#> 15   0.82499 -1.78450 -0.1017759  1.20476 -0.05612 -0.0450516
#> 16  -0.40629 -0.99026 -0.7424018 -0.45831 -1.60902 -0.6961769
#> 17        NA  1.74825  0.3316355  1.59700 -0.65307  0.4993180
#> 18  -0.64576 -0.62986  1.1891556 -1.07114  0.02270 -0.2347836
#> 19   0.86689  2.78046  1.6860681 -0.12423 -0.05403  0.7051441
#> 20   0.08371  2.05241  1.4643413 -0.31114  1.02543  0.5687692
#> 21  -0.74292 -0.21561 -0.3278453 -0.28209 -1.75838 -0.5539087
#> 22  -0.71380  0.02556  0.4198880  0.06379  1.74279  0.1472036
#> 23   0.29940  0.55615 -0.6361672  1.14492 -0.95167  0.0011230
#> 24  -1.14582 -3.22306 -1.0415625 -2.44665  0.59979 -1.1995266
#> 25   1.20247 -1.60981 -0.8815551  0.72915  0.01051 -0.1636747
#> 26   0.08677  2.65405 -0.3436889       NA  3.58174  1.0042975
#> 27   0.29319  1.59279  2.1504296  2.30290  1.33464  1.1164353
#> 28        NA -0.47035  0.0063514  0.13148 -1.13530 -0.2987812
#> 29   2.46501  2.22386  2.9904502  3.20902  3.81151  2.1449553
#> 30   2.69788  3.39628  1.4013788  2.00824  2.41633  1.6978349
#> 31   0.78379  0.62428 -0.8395647  1.12086 -0.83417  0.0584301
#> 32  -1.36483  0.61108 -1.7599862       NA  0.01836 -0.5389643
#> 33   1.29329  2.06942  0.6101684  0.14869 -0.13824  0.5173319
#> 34  -1.27382 -0.90301 -1.5121763       NA -1.54916 -1.0200656
#> 35   1.64991       NA -0.3243972  0.18861 -0.42239  0.0980920
#> 36   1.58836 -0.72328 -0.4429537  1.93325 -1.28879  0.1121035
#> 37   1.52359  0.78390 -1.2987526  0.34797 -1.44629 -0.1001951
#> 38   0.48479  0.71451  0.5702436  0.59200  2.96890  0.6981289
#> 39  -0.38632 -0.37368 -0.5246403  0.28446  1.63123  0.0002643
#> 40  -3.34163       NA -1.3574878 -1.53052 -0.54435 -1.3211448
#> 41        NA  0.25727  0.6004728 -1.32259 -1.46604 -0.3918317
#> 42   0.02548  0.06416  0.3601861 -0.96761 -0.73640 -0.2624094
#> 43   1.35767  2.39758 -0.5848915  1.10109  1.55722  0.7666185
#> 44  -1.14012 -1.56646 -0.6195809 -3.16323 -1.41331 -1.2815016
#> 45  -1.58820       NA -0.1042343       NA       NA -0.5662518
#> 46  -1.13929  1.37678 -0.0118645  1.67092  0.46863  0.3016532
#> 47   1.94471  1.98492  0.6514518  1.38411  0.77475  0.9326716
#> 48   0.53258 -0.16566  0.9234091  2.38104  2.20529  0.8234179
#> 49  -1.48655 -0.47653         NA  0.90730 -1.33484 -0.4724975
#> 50  -2.74633 -2.88650 -1.8255062 -0.64877 -1.28711 -1.4711592
#> 51   0.19378 -1.96511 -1.5715437  0.08512  0.12519 -0.5626562
#> 52   0.37600 -0.74021  0.1026112  2.38986  0.39287  0.3339226
#> 53  -0.98580 -0.32752  0.6421612  0.74878 -0.33443 -0.0794366
#> 54   1.71970  1.29708  2.0068943  1.33454  1.29648  1.0876838
#> 55  -0.86408 -1.09895 -1.0141944 -3.00041 -1.68216 -1.2494194
#> 56  -2.91009 -1.71294 -3.2523432 -3.98988 -2.35404 -2.2539481
#> 57   0.50087 -0.53235  0.0433118 -0.43476  1.91439  0.1175958
#> 58  -0.99882  1.02054  0.8731154  2.16048  3.35388  0.8928406
#> 59        NA  2.54190  0.3894242  3.16089  2.58182  1.4632742
#> 60  -0.29329 -0.75969 -3.4456853 -4.51592 -2.24251 -1.8463171
#> 61  -0.80974 -0.77366 -3.0050260 -1.23074 -0.65684 -1.0913338
#> 62  -0.05053  0.49525 -0.2836893 -0.65113 -1.21072 -0.3297934
#> 63   2.39536  1.57845  2.0525307  0.80214       NA  1.1551782
#> 64   0.51578 -0.59047  0.2385814  0.29267  0.37435  0.0511450
#> 65   0.74224 -0.92972 -0.5522690 -1.65320  0.53248 -0.3946868
#> 66   2.04211  1.56275  2.3085326  1.56169  4.13441  1.6496243
#> 67   0.63149 -2.63066 -0.6765335 -1.40554 -2.57179 -1.0656560
#> 68   0.13999  0.43021  1.2698622  2.37530  0.10923  0.6227987
#> 69  -2.10589 -0.10386 -1.8905290 -0.05841 -1.67882 -0.9413753
#> 70   1.01574  0.35279  1.3558500  0.93517  0.85445  0.6159404
#> 71   1.39052  2.28689 -0.1008021  0.01944  1.34268  0.6279199
#> 72   3.66711  2.64220  4.4615415  3.69197  1.82881  2.4262479
#> 73  -0.73933 -0.88661  1.1307115  0.63375       NA -0.0102960
#> 74   2.58399  0.39786         NA -0.66232  2.57255  0.7323782
#> 75  -0.46241  1.30983  0.2208964  0.18816  1.32323  0.3003848
#> 76  -1.17710 -2.01981 -1.2669019 -0.85618 -2.18118 -1.1866140
#> 77  -0.65779  0.20058 -0.7310786 -0.49348 -0.59806 -0.4227600
#> 78  -2.10764 -2.21589  0.7680871 -1.70093 -1.76300 -1.0924763
#> 79   2.00726  0.87148  2.0367901  0.31910  1.10635  0.8783422
#> 80  -2.36009 -1.56580 -0.1903303 -0.30115       NA -0.8397393
#> 81  -0.25833 -1.68527  0.0004032  0.79251  0.61085 -0.1433872
#> 82   0.59765       NA  0.4673238  1.09821  0.21801  0.3617738
#> 83   3.29340  0.57335  2.2466083  3.16310  0.73085  1.4673419
#> 84   0.10432 -2.04344 -1.0940275  1.64188 -0.43369 -0.3291450
#> 85   1.14176 -2.25175  0.0057519 -1.49549 -0.98194 -0.6213588
#> 86        NA  1.29820  0.2758400  2.46739  0.20785  0.7164916
#> 87   0.10958  0.99187  1.8518617 -0.14102 -0.42702  0.3096868
#> 88  -1.82275 -3.73423 -4.2301137 -2.14703 -1.50323 -2.1368100
#> 89   2.68240  0.35199 -0.6025905  2.30867  2.54410  0.9868263
#> 90   1.94949  1.33611  1.1109751  1.43583  0.53189  0.8895358
#> 91  -1.90785  0.02778  0.4530989 -1.99704 -0.92791 -0.7221150
#> 92  -1.05989 -1.36406         NA  1.36691 -0.16614 -0.2681339
#> 93   0.66160  0.72626  0.5261177 -0.53033 -0.45870  0.0619938
#> 94   1.60615  3.13618  2.5825152  1.88646  3.22990  1.7918412
#> 95  -1.16293       NA  0.6231777 -0.05532 -0.74392 -0.2958049
#> 96   1.36260  0.91533  1.3885984 -0.14716  1.96845  0.7282130
#> 97  -1.17734 -3.90858 -1.5031215 -2.09820 -1.38527 -1.5961309
#> 98   1.96652  0.77161  0.7319926  2.82024  0.38433  0.9539451
#> 99  -1.17341 -1.45245 -4.0148481       NA -1.21936 -1.5652663
#> 100  0.17491 -0.33964 -1.8113959 -1.24574 -0.71666 -0.7017719
#> 
#> $call
#>                                                                call
#> 1 lavaan::lavaan(model=model,data=df,missing="ML",model.type="cfa",
#> 2 cmd="cfa",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,
#> 3            auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,
#> 4       auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)
#> 
```
