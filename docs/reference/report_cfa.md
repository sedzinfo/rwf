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
#>    Unknown argument 'add.labels' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'add.class' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'list.by.group' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'drop.list.single.group' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'add.labels' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'add.class' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'list.by.group' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'drop.list.single.group' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'add.labels' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'add.class' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'list.by.group' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'drop.list.single.group' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'add.labels' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'add.class' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'list.by.group' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'drop.list.single.group' for 'inspect'
#> Skipping circle_parameters_wih_equality_constraints: replacement has 0 rows, data has 5
#> Skipping tree_parameters_wih_equality_constraints: replacement has 0 rows, data has 5
#> Skipping spring_parameters_wih_equality_constraints: replacement has 0 rows, data has 5






#> [1] "##################################################"
#> [1] "SUMMARY"
#> [1] "##################################################"
#> lavaan 0.7-3 ended normally after 26 iterations
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
#>   Test statistic                                 0.674
#>   Degrees of freedom                                 5
#>   P-value (Chi-square)                           0.984
#>                                                       
#>   Browne's residual (NT model-based) test             
#>   Test statistic                                 1.993
#>   Degrees of freedom                                 5
#>   P-value (Chi-square)                           0.850
#> 
#> Model Test Baseline Model:
#> 
#>   Test statistic                               174.479
#>   Degrees of freedom                                10
#>   P-value                                        0.000
#> 
#> User Model versus Baseline Model:
#> 
#>   Comparative Fit Index (CFI)                    1.000
#>   Tucker-Lewis Index (TLI)                       1.053
#>                                                       
#>   Robust Comparative Fit Index (CFI)             1.000
#>   Robust Tucker-Lewis Index (TLI)                1.055
#> 
#> Loglikelihood and Information Criteria:
#> 
#>   Loglikelihood user model (H0)               -749.132
#>   Loglikelihood unrestricted model (H1)       -748.795
#>                                                       
#>   Akaike (AIC)                                1528.264
#>   Bayesian (BIC)                              1567.341
#>   Sample-size adjusted Bayesian (SABIC)       1519.967
#> 
#> Root Mean Square Error of Approximation:
#> 
#>   RMSEA                                          0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.000
#>   P-value H_0: RMSEA <= 0.050                    0.991
#>   P-value H_0: RMSEA >= 0.080                    0.004
#>                                                       
#>   Robust RMSEA                                   0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.000
#>   P-value H_0: Robust RMSEA <= 0.050             0.989
#>   P-value H_0: Robust RMSEA >= 0.080             0.005
#> 
#> Standardized Root Mean Square Residual:
#> 
#>   SRMR                                           0.010
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
#>     ITEM1             1.000                               1.116    0.704
#>     ITEM2             0.894    0.145    6.165    0.000    0.998    0.716
#>     ITEM3             1.075    0.158    6.786    0.000    1.200    0.815
#>     ITEM4             0.820    0.140    5.875    0.000    0.915    0.691
#>     ITEM5             0.781    0.132    5.911    0.000    0.872    0.688
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1            -0.053    0.161   -0.332    0.740   -0.053   -0.034
#>    .ITEM2            -0.207    0.142   -1.458    0.145   -0.207   -0.148
#>    .ITEM3            -0.139    0.149   -0.931    0.352   -0.139   -0.094
#>    .ITEM4            -0.088    0.134   -0.656    0.512   -0.088   -0.067
#>    .ITEM5            -0.265    0.129   -2.058    0.040   -0.265   -0.209
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1             1.267    0.226    5.612    0.000    1.267    0.504
#>    .ITEM2             0.949    0.171    5.553    0.000    0.949    0.488
#>    .ITEM3             0.728    0.167    4.351    0.000    0.728    0.336
#>    .ITEM4             0.915    0.160    5.723    0.000    0.915    0.522
#>    .ITEM5             0.846    0.147    5.753    0.000    0.846    0.526
#>     LATENT            1.246    0.338    3.688    0.000    1.000    1.000
#> 
#> R-Square:
#>                    Estimate
#>     ITEM1             0.496
#>     ITEM2             0.512
#>     ITEM3             0.664
#>     ITEM4             0.478
#>     ITEM5             0.474
#> 
#> [1] "##################################################"
#> [1] "R_SQUARED"
#> [1] "##################################################"
#>       r_squared
#> ITEM1    0.4960
#> ITEM2    0.5121
#> ITEM3    0.6642
#> ITEM4    0.4778
#> ITEM5    0.4737
#> [1] "##################################################"
#> [1] "FIT INDICES"
#> [1] "##################################################"
#>                                      fit
#> npar                           15.000000
#> fmin                            0.003370
#> chisq                           0.674046
#> df                              5.000000
#> pvalue                          0.984363
#> baseline.chisq                174.478659
#> baseline.df                    10.000000
#> baseline.pvalue                 0.000000
#> cfi                             1.000000
#> tli                             1.052602
#> cfi.robust                      1.000000
#> tli.robust                      1.055065
#> nnfi                            1.052602
#> rfi                             0.992274
#> nfi                             0.996137
#> pnfi                            0.498068
#> ifi                             1.025525
#> rni                             1.026301
#> nnfi.robust                     1.055065
#> rni.robust                      1.027533
#> logl                         -749.131822
#> unrestricted.logl            -748.794799
#> aic                          1528.263645
#> bic                          1567.341197
#> ntotal                        100.000000
#> bic2                         1519.967429
#> rmsea                           0.000000
#> rmsea.ci.lower                  0.000000
#> rmsea.ci.upper                  0.000000
#> rmsea.ci.level                  0.900000
#> rmsea.pvalue                    0.991126
#> rmsea.close.h0                  0.050000
#> rmsea.notclose.pvalue           0.003662
#> rmsea.notclose.h0               0.080000
#> rmsea.robust                    0.000000
#> rmsea.ci.lower.robust           0.000000
#> rmsea.ci.upper.robust           0.000000
#> rmsea.pvalue.robust             0.989151
#> rmsea.notclose.pvalue.robust    0.004981
#> rmr                             0.019733
#> rmr_nomean                      0.022770
#> srmr                            0.010002
#> srmr_bentler                    0.010002
#> srmr_bentler_nomean             0.011538
#> crmr                            0.011490
#> crmr_nomean                     0.014058
#> srmr_mplus                      0.010000
#> srmr_mplus_nomean               0.011535
#> gfi                             1.000000
#> gfi.ci.lower                    1.000000
#> gfi.ci.upper                    1.000000
#> gfi.ci.level                    0.900000
#> gfi.robust                      1.000000
#> gfi.ci.lower.robust             1.000000
#> gfi.ci.upper.robust             1.000000
#> cn_05                        1643.395407
#> cn_01                        2239.167181
#> gfi_lisrel                      0.990266
#> agfi_lisrel                     0.961064
#> pgfi                            0.247566
#> mfi                             1.021865
#> ecvi                            0.306740
#> [1] "##################################################"
#> [1] "PARAMETERS"
#> [1] "##################################################"
#>       lhs op    rhs exo      est     se       z           pvalue ci.lower ci.upper   std.lv  std.all
#> 1  LATENT =~  ITEM1   0  1.00000 0.0000      NA               NA   1.0000  1.00000  1.11643  0.70424
#> 2  LATENT =~  ITEM2   0  0.89419 0.1451  6.1647 0.00000000070625   0.6099  1.17848  0.99829  0.71562
#> 3  LATENT =~  ITEM3   0  1.07504 0.1584  6.7855 0.00000000001157   0.7645  1.38555  1.20020  0.81498
#> 4  LATENT =~  ITEM4   0  0.81956 0.1395  5.8746 0.00000000423789   0.5461  1.09299  0.91498  0.69123
#> 5  LATENT =~  ITEM5   0  0.78140 0.1322  5.9106 0.00000000340802   0.5223  1.04051  0.87237  0.68825
#> 6   ITEM1 ~~  ITEM1   0  1.26674 0.2257  5.6124 0.00000001995429   0.8244  1.70911  1.26674  0.50405
#> 7   ITEM2 ~~  ITEM2   0  0.94947 0.1710  5.5531 0.00000002806169   0.6144  1.28458  0.94947  0.48789
#> 8   ITEM3 ~~  ITEM3   0  0.72828 0.1674  4.3510 0.00001355217445   0.4002  1.05634  0.72828  0.33581
#> 9   ITEM4 ~~  ITEM4   0  0.91499 0.1599  5.7229 0.00000001047405   0.6016  1.22836  0.91499  0.52220
#> 10  ITEM5 ~~  ITEM5   0  0.84560 0.1470  5.7529 0.00000000877034   0.5575  1.13368  0.84560  0.52632
#> 11 LATENT ~~ LATENT   0  1.24641 0.3379  3.6884 0.00022571087869   0.5841  1.90874  1.00000  1.00000
#> 12  ITEM1 ~1          0 -0.05338 0.1610 -0.3316 0.74021280963860  -0.3689  0.26217 -0.05338 -0.03367
#> 13  ITEM2 ~1          0 -0.20653 0.1417 -1.4580 0.14484703309578  -0.4842  0.07111 -0.20653 -0.14805
#> 14  ITEM3 ~1          0 -0.13891 0.1492 -0.9313 0.35170464156875  -0.4312  0.15343 -0.13891 -0.09432
#> 15  ITEM4 ~1          0 -0.08822 0.1345 -0.6561 0.51177311709724  -0.3518  0.17533 -0.08822 -0.06665
#> 16  ITEM5 ~1          0 -0.26501 0.1288 -2.0580 0.03958868413543  -0.5174 -0.01263 -0.26501 -0.20908
#> 17 LATENT ~1          0  0.00000 0.0000      NA               NA   0.0000  0.00000  0.00000  0.00000
#> 18  ITEM1 r2  ITEM1   0  0.49595     NA      NA               NA       NA       NA       NA       NA
#> 19  ITEM2 r2  ITEM2   0  0.51211     NA      NA               NA       NA       NA       NA       NA
#> 20  ITEM3 r2  ITEM3   0  0.66419     NA      NA               NA       NA       NA       NA       NA
#> 21  ITEM4 r2  ITEM4   0  0.47780     NA      NA               NA       NA       NA       NA       NA
#> 22  ITEM5 r2  ITEM5   0  0.47368     NA      NA               NA       NA       NA       NA       NA
#> [1] "##################################################"
#> [1] "UNSTANDARDIZED PARAMETERS"
#> [1] "##################################################"
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  0.894
#> ITEM3  1.075
#> ITEM4  0.820
#> ITEM5  0.781
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 1.267                        
#> ITEM2 0.000 0.949                  
#> ITEM3 0.000 0.000 0.728            
#> ITEM4 0.000 0.000 0.000 0.915      
#> ITEM5 0.000 0.000 0.000 0.000 0.846
#> 
#> $psi
#>        LATENT
#> LATENT  1.246
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.053
#> ITEM2 -0.207
#> ITEM3 -0.139
#> ITEM4 -0.088
#> ITEM5 -0.265
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
#> ITEM1  0.704
#> ITEM2  0.716
#> ITEM3  0.815
#> ITEM4  0.691
#> ITEM5  0.688
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.504                        
#> ITEM2 0.000 0.488                  
#> ITEM3 0.000 0.000 0.336            
#> ITEM4 0.000 0.000 0.000 0.522      
#> ITEM5 0.000 0.000 0.000 0.000 0.526
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.034
#> ITEM2 -0.148
#> ITEM3 -0.094
#> ITEM4 -0.067
#> ITEM5 -0.209
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> [1] "##################################################"
#> [1] "SAMPLE COVARIANCE"
#> [1] "##################################################"
#>      X1     X2    X3     X4     X5
#> 1 2.526 1.1726 1.355 1.0057 1.0740
#> 2 1.173 1.9700 1.226 0.9421 0.8961
#> 3 1.355 1.2262 2.198 1.1661 1.0095
#> 4 1.006 0.9421 1.166 1.7480 0.7210
#> 5 1.074 0.8961 1.010 0.7210 1.5890
#> [1] "##################################################"
#> [1] "CALL"
#> [1] "##################################################"
#> [1] "lavaan::lavaan(model=model,data=df,missing=\"ML\",model.type=\"cfa\"," "cmd=\"cfa\",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,"  
#> [3] "auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,"                "auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)"          
#> NULL
#> $r_squared
#>       r_squared
#> ITEM1    0.4960
#> ITEM2    0.5121
#> ITEM3    0.6642
#> ITEM4    0.4778
#> ITEM5    0.4737
#> 
#> $fit_indices
#>                                      fit
#> npar                           15.000000
#> fmin                            0.003370
#> chisq                           0.674046
#> df                              5.000000
#> pvalue                          0.984363
#> baseline.chisq                174.478659
#> baseline.df                    10.000000
#> baseline.pvalue                 0.000000
#> cfi                             1.000000
#> tli                             1.052602
#> cfi.robust                      1.000000
#> tli.robust                      1.055065
#> nnfi                            1.052602
#> rfi                             0.992274
#> nfi                             0.996137
#> pnfi                            0.498068
#> ifi                             1.025525
#> rni                             1.026301
#> nnfi.robust                     1.055065
#> rni.robust                      1.027533
#> logl                         -749.131822
#> unrestricted.logl            -748.794799
#> aic                          1528.263645
#> bic                          1567.341197
#> ntotal                        100.000000
#> bic2                         1519.967429
#> rmsea                           0.000000
#> rmsea.ci.lower                  0.000000
#> rmsea.ci.upper                  0.000000
#> rmsea.ci.level                  0.900000
#> rmsea.pvalue                    0.991126
#> rmsea.close.h0                  0.050000
#> rmsea.notclose.pvalue           0.003662
#> rmsea.notclose.h0               0.080000
#> rmsea.robust                    0.000000
#> rmsea.ci.lower.robust           0.000000
#> rmsea.ci.upper.robust           0.000000
#> rmsea.pvalue.robust             0.989151
#> rmsea.notclose.pvalue.robust    0.004981
#> rmr                             0.019733
#> rmr_nomean                      0.022770
#> srmr                            0.010002
#> srmr_bentler                    0.010002
#> srmr_bentler_nomean             0.011538
#> crmr                            0.011490
#> crmr_nomean                     0.014058
#> srmr_mplus                      0.010000
#> srmr_mplus_nomean               0.011535
#> gfi                             1.000000
#> gfi.ci.lower                    1.000000
#> gfi.ci.upper                    1.000000
#> gfi.ci.level                    0.900000
#> gfi.robust                      1.000000
#> gfi.ci.lower.robust             1.000000
#> gfi.ci.upper.robust             1.000000
#> cn_05                        1643.395407
#> cn_01                        2239.167181
#> gfi_lisrel                      0.990266
#> agfi_lisrel                     0.961064
#> pgfi                            0.247566
#> mfi                             1.021865
#> ecvi                            0.306740
#> 
#> $parameters
#>       lhs op    rhs exo      est     se       z           pvalue ci.lower ci.upper   std.lv  std.all
#> 1  LATENT =~  ITEM1   0  1.00000 0.0000      NA               NA   1.0000  1.00000  1.11643  0.70424
#> 2  LATENT =~  ITEM2   0  0.89419 0.1451  6.1647 0.00000000070625   0.6099  1.17848  0.99829  0.71562
#> 3  LATENT =~  ITEM3   0  1.07504 0.1584  6.7855 0.00000000001157   0.7645  1.38555  1.20020  0.81498
#> 4  LATENT =~  ITEM4   0  0.81956 0.1395  5.8746 0.00000000423789   0.5461  1.09299  0.91498  0.69123
#> 5  LATENT =~  ITEM5   0  0.78140 0.1322  5.9106 0.00000000340802   0.5223  1.04051  0.87237  0.68825
#> 6   ITEM1 ~~  ITEM1   0  1.26674 0.2257  5.6124 0.00000001995429   0.8244  1.70911  1.26674  0.50405
#> 7   ITEM2 ~~  ITEM2   0  0.94947 0.1710  5.5531 0.00000002806169   0.6144  1.28458  0.94947  0.48789
#> 8   ITEM3 ~~  ITEM3   0  0.72828 0.1674  4.3510 0.00001355217445   0.4002  1.05634  0.72828  0.33581
#> 9   ITEM4 ~~  ITEM4   0  0.91499 0.1599  5.7229 0.00000001047405   0.6016  1.22836  0.91499  0.52220
#> 10  ITEM5 ~~  ITEM5   0  0.84560 0.1470  5.7529 0.00000000877034   0.5575  1.13368  0.84560  0.52632
#> 11 LATENT ~~ LATENT   0  1.24641 0.3379  3.6884 0.00022571087869   0.5841  1.90874  1.00000  1.00000
#> 12  ITEM1 ~1          0 -0.05338 0.1610 -0.3316 0.74021280963860  -0.3689  0.26217 -0.05338 -0.03367
#> 13  ITEM2 ~1          0 -0.20653 0.1417 -1.4580 0.14484703309578  -0.4842  0.07111 -0.20653 -0.14805
#> 14  ITEM3 ~1          0 -0.13891 0.1492 -0.9313 0.35170464156875  -0.4312  0.15343 -0.13891 -0.09432
#> 15  ITEM4 ~1          0 -0.08822 0.1345 -0.6561 0.51177311709724  -0.3518  0.17533 -0.08822 -0.06665
#> 16  ITEM5 ~1          0 -0.26501 0.1288 -2.0580 0.03958868413543  -0.5174 -0.01263 -0.26501 -0.20908
#> 17 LATENT ~1          0  0.00000 0.0000      NA               NA   0.0000  0.00000  0.00000  0.00000
#> 18  ITEM1 r2  ITEM1   0  0.49595     NA      NA               NA       NA       NA       NA       NA
#> 19  ITEM2 r2  ITEM2   0  0.51211     NA      NA               NA       NA       NA       NA       NA
#> 20  ITEM3 r2  ITEM3   0  0.66419     NA      NA               NA       NA       NA       NA       NA
#> 21  ITEM4 r2  ITEM4   0  0.47780     NA      NA               NA       NA       NA       NA       NA
#> 22  ITEM5 r2  ITEM5   0  0.47368     NA      NA               NA       NA       NA       NA       NA
#> 
#> $modification_indices
#>       lhs op    rhs                   mi             epc        sepc.all delta    ncp   power decision
#> 21  ITEM1 ~~  ITEM5 0.546839559868500080  0.105427920679  0.101866223045   0.1 0.4920 0.10799      (i)
#> 25  ITEM3 ~~  ITEM4 0.275767621240508021  0.073874994761  0.090498129420   0.1 0.5053 0.10959      (i)
#> 20  ITEM1 ~~  ITEM4 0.182608093538490890 -0.063586230775 -0.059062288848   0.1 0.4516 0.10313      (i)
#> 26  ITEM3 ~~  ITEM5 0.144146944786839315 -0.051078368338 -0.065088839207   0.1 0.5525 0.11530      (i)
#> 27  ITEM4 ~~  ITEM5 0.055751883265722953 -0.028087992141 -0.031932286682   0.1 0.7067 0.13405      (i)
#> 19  ITEM1 ~~  ITEM3 0.045199737013381272 -0.036087498532 -0.037571986417   0.1 0.3471 0.09061      (i)
#> 24  ITEM2 ~~  ITEM5 0.005416283716054107 -0.009202625795 -0.010270451024   0.1 0.6396 0.12587      (i)
#> 22  ITEM2 ~~  ITEM3 0.004474560269000743  0.010044330851  0.012079016583   0.1 0.4435 0.10215      (i)
#> 18  ITEM1 ~~  ITEM2 0.003803638239458201 -0.009638680153 -0.008788872998   0.1 0.4094 0.09806      (i)
#> 23  ITEM2 ~~  ITEM4 0.003578688330884250  0.007808557914  0.008377630806   0.1 0.5869 0.11947      (i)
#> 6   ITEM1 ~~  ITEM1 0.000000000006250995 -0.000000541352 -0.504045141476   0.1 0.2133 0.07477      (i)
#> 9   ITEM4 ~~  ITEM4 0.000000000000540229  0.000000113514  0.522204342330   0.1 0.4193 0.09924      (i)
#> 7   ITEM2 ~~  ITEM2 0.000000000000472315  0.000000112738  0.487893130267   0.1 0.3716 0.09354      (i)
#> 8   ITEM3 ~~  ITEM3 0.000000000000238537 -0.000000073629 -0.335805001662   0.1 0.4400 0.10173      (i)
#> 11 LATENT ~~ LATENT 0.000000000000178507 -0.000000088079 -1.000000000000   0.1 0.2301 0.07675      (i)
#> 2  LATENT =~  ITEM2 0.000000000000105779  0.000000033940  0.000000027162   0.1 0.9183 0.16001      (i)
#> 5  LATENT =~  ITEM5 0.000000000000088833  0.000000029060  0.000000025596   0.1 1.0519 0.17648      (i)
#> 12  ITEM1 ~1        0.000000000000036875  0.000000024070  0.000000015183   0.1 0.6365 0.12549      (i)
#> 4  LATENT =~  ITEM4 0.000000000000032181  0.000000018213  0.000000015361   0.1 0.9701 0.16639      (i)
#> 14  ITEM3 ~1        0.000000000000015834  0.000000013162  0.000000008938   0.1 0.9139 0.15947      (i)
#> 10  ITEM5 ~~  ITEM5 0.000000000000006525 -0.000000011499 -0.526317783477   0.1 0.4935 0.10817      (i)
#> 13  ITEM2 ~1        0.000000000000002848  0.000000005822  0.000000004173   0.1 0.8401 0.15040      (i)
#> 16  ITEM5 ~1        0.000000000000002491  0.000000005073  0.000000004002   0.1 0.9682 0.16615      (i)
#> 3  LATENT =~  ITEM3 0.000000000000002179  0.000000004575  0.000000003468   0.1 1.0411 0.17515      (i)
#> 15  ITEM4 ~1        0.000000000000002165  0.000000004925  0.000000003721   0.1 0.8924 0.15682      (i)
#> 
#> $sample_covariance
#>      X1     X2    X3     X4     X5
#> 1 2.526 1.1726 1.355 1.0057 1.0740
#> 2 1.173 1.9700 1.226 0.9421 0.8961
#> 3 1.355 1.2262 2.198 1.1661 1.0095
#> 4 1.006 0.9421 1.166 1.7480 0.7210
#> 5 1.074 0.8961 1.010 0.7210 1.5890
#> 
#> $unstandardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  0.894
#> ITEM3  1.075
#> ITEM4  0.820
#> ITEM5  0.781
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 1.267                        
#> ITEM2 0.000 0.949                  
#> ITEM3 0.000 0.000 0.728            
#> ITEM4 0.000 0.000 0.000 0.915      
#> ITEM5 0.000 0.000 0.000 0.000 0.846
#> 
#> $psi
#>        LATENT
#> LATENT  1.246
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.053
#> ITEM2 -0.207
#> ITEM3 -0.139
#> ITEM4 -0.088
#> ITEM5 -0.265
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> 
#> $standardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  0.704
#> ITEM2  0.716
#> ITEM3  0.815
#> ITEM4  0.691
#> ITEM5  0.688
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.504                        
#> ITEM2 0.000 0.488                  
#> ITEM3 0.000 0.000 0.336            
#> ITEM4 0.000 0.000 0.000 0.522      
#> ITEM5 0.000 0.000 0.000 0.000 0.526
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.034
#> ITEM2 -0.148
#> ITEM3 -0.094
#> ITEM4 -0.067
#> ITEM5 -0.209
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
#>            X1       X2        X3       X4        X5     LATENT
#> 1    0.639786       NA        NA -0.56123 -0.452156 -0.0162082
#> 2   -2.462159 -2.24205 -1.872255 -1.75436 -0.314500 -1.4452155
#> 3   -3.173193 -0.30594 -0.170723 -2.27201 -0.475878 -0.8680697
#> 4    2.391312  0.73163 -0.124045  1.33760  1.527821  1.0533706
#> 5    2.022265  1.41504  0.730857  1.39196  0.987034  1.2657522
#> 6    1.383443  1.13576  1.838407  1.81671 -0.060534  1.3168717
#> 7   -0.676032  1.25276 -0.678001  0.83943  1.200650  0.4148860
#> 8    1.109309 -1.60560  1.649983  0.22981 -0.582407  0.4076129
#> 9   -3.006267 -3.48008 -3.968901 -2.26092 -2.684625 -2.7843513
#> 10   1.241994  0.40066        NA -0.73485  0.759983  0.5044819
#> 11  -0.671821 -0.03584  0.968296  0.69037  1.602008  0.6809625
#> 12   0.009977 -1.27707        NA  1.27346 -0.855387 -0.0730292
#> 13  -1.440489 -0.72304 -0.390055  0.01643 -0.756342 -0.4222243
#> 14  -1.048633       NA -2.565442 -1.15141 -0.633791 -1.2213413
#> 15  -1.052949  1.25520 -1.977844       NA -0.813196 -0.5552705
#> 16  -2.705331 -2.95574 -0.624360 -0.90667 -1.773437 -1.3741800
#> 17         NA  0.04042  0.158792 -0.48458  0.268199  0.1727432
#> 18  -1.122548  0.03449  0.636602 -0.19419        NA  0.0910219
#> 19   1.724857  1.85038  1.016928 -0.82100  0.901207  0.9984535
#> 20  -0.823031  0.87220 -0.743756 -0.30193 -2.183369 -0.4470834
#> 21   2.247335  0.15024  1.529624  0.31685  0.619615  1.0581722
#> 22  -0.865883 -0.19776 -0.554558 -0.95455 -2.524469 -0.7505321
#> 23         NA -1.24310 -2.309152 -2.34084 -0.748606 -1.4174670
#> 24   1.286175  0.20415  1.333835  0.06162  0.833330  0.8704523
#> 25  -4.298038 -3.05750 -4.087274 -3.85652  0.133625 -2.7152280
#> 26   2.495902 -0.75263  2.528312  1.12448 -0.704335  1.1166151
#> 27  -0.823530 -0.59527 -2.098346  1.01561  0.040350 -0.4739180
#> 28   2.316649 -1.01674 -0.395587 -0.25432  0.382797  0.2152466
#> 29   1.626247 -2.54697 -0.550370 -0.17640  0.143733 -0.2167060
#> 30  -1.351659       NA -1.610394  0.82331 -1.100452 -0.6801976
#> 31   0.633766  0.61780  0.596913 -2.15710  0.318937  0.1992874
#> 32  -1.384579 -1.21795 -3.028885 -0.95312 -3.051564 -1.7563003
#> 33   0.007360 -0.32950  0.673445 -0.21368 -1.117877  0.0421390
#> 34  -2.826463 -0.46275 -1.690815 -1.18182 -2.640033 -1.4416026
#> 35   0.294657 -1.89621 -0.745613  1.04713 -0.005622 -0.1744611
#> 36         NA -0.26031  0.788891  0.65495  1.237793  0.7196342
#> 37   1.451930 -0.70076 -1.035591 -0.58223 -0.838214 -0.2871902
#> 38  -0.480311 -0.05407  0.171414  0.42461  0.052321  0.1857271
#> 39   0.090071 -0.66147 -1.579065 -0.05741 -0.205198 -0.4305728
#> 40  -1.669765 -1.49730 -1.257693 -1.03100 -2.229167 -1.2420526
#> 41   1.667761 -0.77184  0.656335 -0.16149 -0.603245  0.2961564
#> 42  -1.134263 -2.84989 -0.405335 -1.59245 -1.892230 -1.2026916
#> 43   1.062521  1.12370 -0.135651  0.04811  0.826208  0.5968680
#> 44  -0.999419  0.27077 -1.761869  0.07868 -1.134894 -0.6111817
#> 45  -0.156330  0.24365 -0.387066  0.61340 -1.305877 -0.0651862
#> 46   1.236885  0.74165  1.279900 -0.55135  0.616662  0.8044333
#> 47   0.604340  1.65448  0.448725 -0.40711 -0.060499  0.5555439
#> 48   1.354228  0.98154 -0.087781 -0.18221 -1.316586  0.2281679
#> 49  -1.964453  1.23789 -0.504673 -0.29547 -0.722946 -0.2368213
#> 50   1.323308 -0.42226 -0.201303 -1.07283 -0.152976  0.0023978
#> 51  -2.640016 -1.07243 -1.809780 -0.52287  0.577211 -0.9010428
#> 52  -0.741620 -1.77211  0.210706  1.15967        NA -0.0807453
#> 53  -1.453124 -2.29694 -1.306631 -3.21899 -1.807075 -1.6481260
#> 54   0.497749 -0.66202 -3.708221 -2.95105        NA -1.6460956
#> 55   0.808181  1.45290  0.851715  0.63938  0.451935  0.9164791
#> 56   1.132951 -0.44072 -0.157261  0.66816  0.604495  0.3961831
#> 57  -0.560108 -1.47832  0.000185  0.74542 -0.267699 -0.1183604
#> 58  -0.386646 -2.97814 -2.005607  0.19209 -1.914683 -1.2602329
#> 59   3.079060  0.42778  1.395911  1.83170  1.150547  1.5270627
#> 60  -0.129479 -1.52672 -1.488135 -2.20964 -2.527302 -1.3302641
#> 61   0.634189  2.20799  2.173958  1.65723 -1.036166  1.2929959
#> 62   1.185995  0.98461  2.321097  0.83858  1.171766  1.4404692
#> 63   1.701540  0.54735        NA  0.73202  0.418642  0.8899227
#> 64         NA -1.75139  0.118915 -1.17354 -1.054536 -0.5922253
#> 65  -1.219101 -3.37202 -1.765710       NA -1.286063 -1.5278554
#> 66  -1.282848 -0.55215 -0.303290  1.33225 -1.488990 -0.2551562
#> 67  -0.200893 -0.01939  1.193102  0.18210  2.383388  0.8609720
#> 68   1.069363 -1.14897 -0.602401 -3.05781 -0.841137 -0.7080046
#> 69   0.723955  1.10954  0.552389 -0.05279 -0.474423  0.4951276
#> 70  -1.769029 -0.39022  0.482808 -1.73143  0.156053 -0.3090007
#> 71  -0.607125 -0.83899  1.153078 -0.89711 -0.733107 -0.0516193
#> 72   2.082636  1.83798        NA  0.41960  0.407821  1.2052201
#> 73  -2.174829 -0.25616 -0.479623 -0.36643 -1.010068 -0.5773503
#> 74   1.969984  2.47497  1.156767  1.73831  3.616271  2.0555203
#> 75   2.392735  0.45617  0.296841       NA  1.624826  1.0425686
#> 76  -1.314367 -0.23376 -0.455483       NA        NA -0.3701817
#> 77   0.797466  1.53080  0.703988  1.07348  1.328744  1.1074453
#> 78  -0.226802       NA -1.254460 -0.09453 -0.301778 -0.3933819
#> 79  -4.610416 -1.78377 -2.871683 -1.27790 -3.755634 -2.4480990
#> 80   2.451652  2.39100 -0.420545  1.17354 -1.116675  0.7944741
#> 81  -1.129669 -0.26796  1.301954  1.51736 -1.008650  0.3597530
#> 82  -0.115980 -0.11174 -0.474545  0.30391  1.002906  0.1948708
#> 83   0.160418  1.27257  0.741898  0.02651  0.418738  0.6566753
#> 84  -0.883454  2.13771  2.543341       NA  1.016580  1.4118395
#> 85  -1.039326 -0.11530  0.739306 -2.19353 -0.629758 -0.2955752
#> 86  -0.856566 -1.99731 -1.100760 -0.04275  0.597388 -0.5299975
#> 87  -1.078149 -0.62091 -0.032027  0.98580 -0.181584 -0.0004321
#> 88   1.663212 -0.29661  1.141832  1.60975  0.677057  1.0137568
#> 89  -0.282234       NA  1.521132 -0.52321 -0.202426  0.4181409
#> 90  -2.209001 -1.59546 -0.936984  0.97103 -1.271507 -0.7612236
#> 91   0.607963  1.45034  0.430476  2.03382 -0.275280  0.8789990
#> 92  -0.848125 -0.04688 -1.395504 -1.63656 -1.658392 -0.9140910
#> 93   0.933619 -0.07215 -1.067518 -0.37519 -0.113384 -0.1062550
#> 94         NA -1.26543 -2.310348 -0.59963 -0.468427 -1.0343780
#> 95   0.915919 -0.46984 -0.235870 -1.44221 -0.706289 -0.2275850
#> 96   0.802705  1.55491  0.522001  1.48089 -0.914367  0.7514624
#> 97   1.811700  1.08863  1.116562  2.46323  2.051236  1.6379804
#> 98   2.349805  2.26437  2.852502  2.31184        NA  2.2691915
#> 99   0.586106  0.80988  3.291084  2.35975  1.531432  1.8948454
#> 100  0.395401  2.45207  2.009135  1.19827  1.964904  1.6874133
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
#>    Unknown argument 'add.labels' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'add.class' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'list.by.group' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'drop.list.single.group' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'add.labels' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'add.class' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'list.by.group' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'drop.list.single.group' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'add.labels' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'add.class' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'list.by.group' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'drop.list.single.group' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'add.labels' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'add.class' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'list.by.group' for 'inspect'
#> Warning: lavaan->inspect.lavaan():  
#>    Unknown argument 'drop.list.single.group' for 'inspect'
#> Skipping circle_parameters_wih_equality_constraints: replacement has 0 rows, data has 5
#> Skipping tree_parameters_wih_equality_constraints: replacement has 0 rows, data has 5
#> Skipping spring_parameters_wih_equality_constraints: replacement has 0 rows, data has 5






#> [1] "##################################################"
#> [1] "SUMMARY"
#> [1] "##################################################"
#> lavaan 0.7-3 ended normally after 26 iterations
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
#>   Test statistic                                 0.674
#>   Degrees of freedom                                 5
#>   P-value (Chi-square)                           0.984
#>                                                       
#>   Browne's residual (NT model-based) test             
#>   Test statistic                                 1.993
#>   Degrees of freedom                                 5
#>   P-value (Chi-square)                           0.850
#> 
#> Model Test Baseline Model:
#> 
#>   Test statistic                               174.479
#>   Degrees of freedom                                10
#>   P-value                                        0.000
#> 
#> User Model versus Baseline Model:
#> 
#>   Comparative Fit Index (CFI)                    1.000
#>   Tucker-Lewis Index (TLI)                       1.053
#>                                                       
#>   Robust Comparative Fit Index (CFI)             1.000
#>   Robust Tucker-Lewis Index (TLI)                1.055
#> 
#> Loglikelihood and Information Criteria:
#> 
#>   Loglikelihood user model (H0)               -749.132
#>   Loglikelihood unrestricted model (H1)       -748.795
#>                                                       
#>   Akaike (AIC)                                1528.264
#>   Bayesian (BIC)                              1567.341
#>   Sample-size adjusted Bayesian (SABIC)       1519.967
#> 
#> Root Mean Square Error of Approximation:
#> 
#>   RMSEA                                          0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.000
#>   P-value H_0: RMSEA <= 0.050                    0.991
#>   P-value H_0: RMSEA >= 0.080                    0.004
#>                                                       
#>   Robust RMSEA                                   0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.000
#>   P-value H_0: Robust RMSEA <= 0.050             0.989
#>   P-value H_0: Robust RMSEA >= 0.080             0.005
#> 
#> Standardized Root Mean Square Residual:
#> 
#>   SRMR                                           0.010
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
#>     ITEM1             1.000                               1.116    0.704
#>     ITEM2             0.894    0.145    6.165    0.000    0.998    0.716
#>     ITEM3             1.075    0.158    6.786    0.000    1.200    0.815
#>     ITEM4             0.820    0.140    5.875    0.000    0.915    0.691
#>     ITEM5             0.781    0.132    5.911    0.000    0.872    0.688
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1            -0.053    0.161   -0.332    0.740   -0.053   -0.034
#>    .ITEM2            -0.207    0.142   -1.458    0.145   -0.207   -0.148
#>    .ITEM3            -0.139    0.149   -0.931    0.352   -0.139   -0.094
#>    .ITEM4            -0.088    0.134   -0.656    0.512   -0.088   -0.067
#>    .ITEM5            -0.265    0.129   -2.058    0.040   -0.265   -0.209
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1             1.267    0.226    5.612    0.000    1.267    0.504
#>    .ITEM2             0.949    0.171    5.553    0.000    0.949    0.488
#>    .ITEM3             0.728    0.167    4.351    0.000    0.728    0.336
#>    .ITEM4             0.915    0.160    5.723    0.000    0.915    0.522
#>    .ITEM5             0.846    0.147    5.753    0.000    0.846    0.526
#>     LATENT            1.246    0.338    3.688    0.000    1.000    1.000
#> 
#> R-Square:
#>                    Estimate
#>     ITEM1             0.496
#>     ITEM2             0.512
#>     ITEM3             0.664
#>     ITEM4             0.478
#>     ITEM5             0.474
#> 
#> [1] "##################################################"
#> [1] "R_SQUARED"
#> [1] "##################################################"
#>       r_squared
#> ITEM1    0.4960
#> ITEM2    0.5121
#> ITEM3    0.6642
#> ITEM4    0.4778
#> ITEM5    0.4737
#> [1] "##################################################"
#> [1] "FIT INDICES"
#> [1] "##################################################"
#>                                      fit
#> npar                           15.000000
#> fmin                            0.003370
#> chisq                           0.674046
#> df                              5.000000
#> pvalue                          0.984363
#> baseline.chisq                174.478659
#> baseline.df                    10.000000
#> baseline.pvalue                 0.000000
#> cfi                             1.000000
#> tli                             1.052602
#> cfi.robust                      1.000000
#> tli.robust                      1.055065
#> nnfi                            1.052602
#> rfi                             0.992274
#> nfi                             0.996137
#> pnfi                            0.498068
#> ifi                             1.025525
#> rni                             1.026301
#> nnfi.robust                     1.055065
#> rni.robust                      1.027533
#> logl                         -749.131822
#> unrestricted.logl            -748.794799
#> aic                          1528.263645
#> bic                          1567.341197
#> ntotal                        100.000000
#> bic2                         1519.967429
#> rmsea                           0.000000
#> rmsea.ci.lower                  0.000000
#> rmsea.ci.upper                  0.000000
#> rmsea.ci.level                  0.900000
#> rmsea.pvalue                    0.991126
#> rmsea.close.h0                  0.050000
#> rmsea.notclose.pvalue           0.003662
#> rmsea.notclose.h0               0.080000
#> rmsea.robust                    0.000000
#> rmsea.ci.lower.robust           0.000000
#> rmsea.ci.upper.robust           0.000000
#> rmsea.pvalue.robust             0.989151
#> rmsea.notclose.pvalue.robust    0.004981
#> rmr                             0.019733
#> rmr_nomean                      0.022770
#> srmr                            0.010002
#> srmr_bentler                    0.010002
#> srmr_bentler_nomean             0.011538
#> crmr                            0.011490
#> crmr_nomean                     0.014058
#> srmr_mplus                      0.010000
#> srmr_mplus_nomean               0.011535
#> gfi                             1.000000
#> gfi.ci.lower                    1.000000
#> gfi.ci.upper                    1.000000
#> gfi.ci.level                    0.900000
#> gfi.robust                      1.000000
#> gfi.ci.lower.robust             1.000000
#> gfi.ci.upper.robust             1.000000
#> cn_05                        1643.395407
#> cn_01                        2239.167181
#> gfi_lisrel                      0.990266
#> agfi_lisrel                     0.961064
#> pgfi                            0.247566
#> mfi                             1.021865
#> ecvi                            0.306740
#> [1] "##################################################"
#> [1] "PARAMETERS"
#> [1] "##################################################"
#>       lhs op    rhs exo      est     se       z           pvalue ci.lower ci.upper   std.lv  std.all
#> 1  LATENT =~  ITEM1   0  1.00000 0.0000      NA               NA   1.0000  1.00000  1.11643  0.70424
#> 2  LATENT =~  ITEM2   0  0.89419 0.1451  6.1647 0.00000000070625   0.6099  1.17848  0.99829  0.71562
#> 3  LATENT =~  ITEM3   0  1.07504 0.1584  6.7855 0.00000000001157   0.7645  1.38555  1.20020  0.81498
#> 4  LATENT =~  ITEM4   0  0.81956 0.1395  5.8746 0.00000000423789   0.5461  1.09299  0.91498  0.69123
#> 5  LATENT =~  ITEM5   0  0.78140 0.1322  5.9106 0.00000000340802   0.5223  1.04051  0.87237  0.68825
#> 6   ITEM1 ~~  ITEM1   0  1.26674 0.2257  5.6124 0.00000001995429   0.8244  1.70911  1.26674  0.50405
#> 7   ITEM2 ~~  ITEM2   0  0.94947 0.1710  5.5531 0.00000002806169   0.6144  1.28458  0.94947  0.48789
#> 8   ITEM3 ~~  ITEM3   0  0.72828 0.1674  4.3510 0.00001355217445   0.4002  1.05634  0.72828  0.33581
#> 9   ITEM4 ~~  ITEM4   0  0.91499 0.1599  5.7229 0.00000001047405   0.6016  1.22836  0.91499  0.52220
#> 10  ITEM5 ~~  ITEM5   0  0.84560 0.1470  5.7529 0.00000000877034   0.5575  1.13368  0.84560  0.52632
#> 11 LATENT ~~ LATENT   0  1.24641 0.3379  3.6884 0.00022571087869   0.5841  1.90874  1.00000  1.00000
#> 12  ITEM1 ~1          0 -0.05338 0.1610 -0.3316 0.74021280963860  -0.3689  0.26217 -0.05338 -0.03367
#> 13  ITEM2 ~1          0 -0.20653 0.1417 -1.4580 0.14484703309578  -0.4842  0.07111 -0.20653 -0.14805
#> 14  ITEM3 ~1          0 -0.13891 0.1492 -0.9313 0.35170464156875  -0.4312  0.15343 -0.13891 -0.09432
#> 15  ITEM4 ~1          0 -0.08822 0.1345 -0.6561 0.51177311709724  -0.3518  0.17533 -0.08822 -0.06665
#> 16  ITEM5 ~1          0 -0.26501 0.1288 -2.0580 0.03958868413543  -0.5174 -0.01263 -0.26501 -0.20908
#> 17 LATENT ~1          0  0.00000 0.0000      NA               NA   0.0000  0.00000  0.00000  0.00000
#> 18  ITEM1 r2  ITEM1   0  0.49595     NA      NA               NA       NA       NA       NA       NA
#> 19  ITEM2 r2  ITEM2   0  0.51211     NA      NA               NA       NA       NA       NA       NA
#> 20  ITEM3 r2  ITEM3   0  0.66419     NA      NA               NA       NA       NA       NA       NA
#> 21  ITEM4 r2  ITEM4   0  0.47780     NA      NA               NA       NA       NA       NA       NA
#> 22  ITEM5 r2  ITEM5   0  0.47368     NA      NA               NA       NA       NA       NA       NA
#> [1] "##################################################"
#> [1] "UNSTANDARDIZED PARAMETERS"
#> [1] "##################################################"
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  0.894
#> ITEM3  1.075
#> ITEM4  0.820
#> ITEM5  0.781
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 1.267                        
#> ITEM2 0.000 0.949                  
#> ITEM3 0.000 0.000 0.728            
#> ITEM4 0.000 0.000 0.000 0.915      
#> ITEM5 0.000 0.000 0.000 0.000 0.846
#> 
#> $psi
#>        LATENT
#> LATENT  1.246
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.053
#> ITEM2 -0.207
#> ITEM3 -0.139
#> ITEM4 -0.088
#> ITEM5 -0.265
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
#> ITEM1  0.704
#> ITEM2  0.716
#> ITEM3  0.815
#> ITEM4  0.691
#> ITEM5  0.688
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.504                        
#> ITEM2 0.000 0.488                  
#> ITEM3 0.000 0.000 0.336            
#> ITEM4 0.000 0.000 0.000 0.522      
#> ITEM5 0.000 0.000 0.000 0.000 0.526
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.034
#> ITEM2 -0.148
#> ITEM3 -0.094
#> ITEM4 -0.067
#> ITEM5 -0.209
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> [1] "##################################################"
#> [1] "SAMPLE COVARIANCE"
#> [1] "##################################################"
#>      X1     X2    X3     X4     X5
#> 1 2.526 1.1726 1.355 1.0057 1.0740
#> 2 1.173 1.9700 1.226 0.9421 0.8961
#> 3 1.355 1.2262 2.198 1.1661 1.0095
#> 4 1.006 0.9421 1.166 1.7480 0.7210
#> 5 1.074 0.8961 1.010 0.7210 1.5890
#> [1] "##################################################"
#> [1] "CALL"
#> [1] "##################################################"
#> [1] "lavaan::lavaan(model=model,data=df,missing=\"ML\",model.type=\"cfa\"," "cmd=\"cfa\",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,"  
#> [3] "auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,"                "auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)"          
#> NULL
#> $r_squared
#>       r_squared
#> ITEM1    0.4960
#> ITEM2    0.5121
#> ITEM3    0.6642
#> ITEM4    0.4778
#> ITEM5    0.4737
#> 
#> $fit_indices
#>                                      fit
#> npar                           15.000000
#> fmin                            0.003370
#> chisq                           0.674046
#> df                              5.000000
#> pvalue                          0.984363
#> baseline.chisq                174.478659
#> baseline.df                    10.000000
#> baseline.pvalue                 0.000000
#> cfi                             1.000000
#> tli                             1.052602
#> cfi.robust                      1.000000
#> tli.robust                      1.055065
#> nnfi                            1.052602
#> rfi                             0.992274
#> nfi                             0.996137
#> pnfi                            0.498068
#> ifi                             1.025525
#> rni                             1.026301
#> nnfi.robust                     1.055065
#> rni.robust                      1.027533
#> logl                         -749.131822
#> unrestricted.logl            -748.794799
#> aic                          1528.263645
#> bic                          1567.341197
#> ntotal                        100.000000
#> bic2                         1519.967429
#> rmsea                           0.000000
#> rmsea.ci.lower                  0.000000
#> rmsea.ci.upper                  0.000000
#> rmsea.ci.level                  0.900000
#> rmsea.pvalue                    0.991126
#> rmsea.close.h0                  0.050000
#> rmsea.notclose.pvalue           0.003662
#> rmsea.notclose.h0               0.080000
#> rmsea.robust                    0.000000
#> rmsea.ci.lower.robust           0.000000
#> rmsea.ci.upper.robust           0.000000
#> rmsea.pvalue.robust             0.989151
#> rmsea.notclose.pvalue.robust    0.004981
#> rmr                             0.019733
#> rmr_nomean                      0.022770
#> srmr                            0.010002
#> srmr_bentler                    0.010002
#> srmr_bentler_nomean             0.011538
#> crmr                            0.011490
#> crmr_nomean                     0.014058
#> srmr_mplus                      0.010000
#> srmr_mplus_nomean               0.011535
#> gfi                             1.000000
#> gfi.ci.lower                    1.000000
#> gfi.ci.upper                    1.000000
#> gfi.ci.level                    0.900000
#> gfi.robust                      1.000000
#> gfi.ci.lower.robust             1.000000
#> gfi.ci.upper.robust             1.000000
#> cn_05                        1643.395407
#> cn_01                        2239.167181
#> gfi_lisrel                      0.990266
#> agfi_lisrel                     0.961064
#> pgfi                            0.247566
#> mfi                             1.021865
#> ecvi                            0.306740
#> 
#> $parameters
#>       lhs op    rhs exo      est     se       z           pvalue ci.lower ci.upper   std.lv  std.all
#> 1  LATENT =~  ITEM1   0  1.00000 0.0000      NA               NA   1.0000  1.00000  1.11643  0.70424
#> 2  LATENT =~  ITEM2   0  0.89419 0.1451  6.1647 0.00000000070625   0.6099  1.17848  0.99829  0.71562
#> 3  LATENT =~  ITEM3   0  1.07504 0.1584  6.7855 0.00000000001157   0.7645  1.38555  1.20020  0.81498
#> 4  LATENT =~  ITEM4   0  0.81956 0.1395  5.8746 0.00000000423789   0.5461  1.09299  0.91498  0.69123
#> 5  LATENT =~  ITEM5   0  0.78140 0.1322  5.9106 0.00000000340802   0.5223  1.04051  0.87237  0.68825
#> 6   ITEM1 ~~  ITEM1   0  1.26674 0.2257  5.6124 0.00000001995429   0.8244  1.70911  1.26674  0.50405
#> 7   ITEM2 ~~  ITEM2   0  0.94947 0.1710  5.5531 0.00000002806169   0.6144  1.28458  0.94947  0.48789
#> 8   ITEM3 ~~  ITEM3   0  0.72828 0.1674  4.3510 0.00001355217445   0.4002  1.05634  0.72828  0.33581
#> 9   ITEM4 ~~  ITEM4   0  0.91499 0.1599  5.7229 0.00000001047405   0.6016  1.22836  0.91499  0.52220
#> 10  ITEM5 ~~  ITEM5   0  0.84560 0.1470  5.7529 0.00000000877034   0.5575  1.13368  0.84560  0.52632
#> 11 LATENT ~~ LATENT   0  1.24641 0.3379  3.6884 0.00022571087869   0.5841  1.90874  1.00000  1.00000
#> 12  ITEM1 ~1          0 -0.05338 0.1610 -0.3316 0.74021280963860  -0.3689  0.26217 -0.05338 -0.03367
#> 13  ITEM2 ~1          0 -0.20653 0.1417 -1.4580 0.14484703309578  -0.4842  0.07111 -0.20653 -0.14805
#> 14  ITEM3 ~1          0 -0.13891 0.1492 -0.9313 0.35170464156875  -0.4312  0.15343 -0.13891 -0.09432
#> 15  ITEM4 ~1          0 -0.08822 0.1345 -0.6561 0.51177311709724  -0.3518  0.17533 -0.08822 -0.06665
#> 16  ITEM5 ~1          0 -0.26501 0.1288 -2.0580 0.03958868413543  -0.5174 -0.01263 -0.26501 -0.20908
#> 17 LATENT ~1          0  0.00000 0.0000      NA               NA   0.0000  0.00000  0.00000  0.00000
#> 18  ITEM1 r2  ITEM1   0  0.49595     NA      NA               NA       NA       NA       NA       NA
#> 19  ITEM2 r2  ITEM2   0  0.51211     NA      NA               NA       NA       NA       NA       NA
#> 20  ITEM3 r2  ITEM3   0  0.66419     NA      NA               NA       NA       NA       NA       NA
#> 21  ITEM4 r2  ITEM4   0  0.47780     NA      NA               NA       NA       NA       NA       NA
#> 22  ITEM5 r2  ITEM5   0  0.47368     NA      NA               NA       NA       NA       NA       NA
#> 
#> $modification_indices
#>       lhs op    rhs                   mi             epc        sepc.all delta    ncp   power decision
#> 21  ITEM1 ~~  ITEM5 0.546839559868500080  0.105427920679  0.101866223045   0.1 0.4920 0.10799      (i)
#> 25  ITEM3 ~~  ITEM4 0.275767621240508021  0.073874994761  0.090498129420   0.1 0.5053 0.10959      (i)
#> 20  ITEM1 ~~  ITEM4 0.182608093538490890 -0.063586230775 -0.059062288848   0.1 0.4516 0.10313      (i)
#> 26  ITEM3 ~~  ITEM5 0.144146944786839315 -0.051078368338 -0.065088839207   0.1 0.5525 0.11530      (i)
#> 27  ITEM4 ~~  ITEM5 0.055751883265722953 -0.028087992141 -0.031932286682   0.1 0.7067 0.13405      (i)
#> 19  ITEM1 ~~  ITEM3 0.045199737013381272 -0.036087498532 -0.037571986417   0.1 0.3471 0.09061      (i)
#> 24  ITEM2 ~~  ITEM5 0.005416283716054107 -0.009202625795 -0.010270451024   0.1 0.6396 0.12587      (i)
#> 22  ITEM2 ~~  ITEM3 0.004474560269000743  0.010044330851  0.012079016583   0.1 0.4435 0.10215      (i)
#> 18  ITEM1 ~~  ITEM2 0.003803638239458201 -0.009638680153 -0.008788872998   0.1 0.4094 0.09806      (i)
#> 23  ITEM2 ~~  ITEM4 0.003578688330884250  0.007808557914  0.008377630806   0.1 0.5869 0.11947      (i)
#> 6   ITEM1 ~~  ITEM1 0.000000000006250995 -0.000000541352 -0.504045141476   0.1 0.2133 0.07477      (i)
#> 9   ITEM4 ~~  ITEM4 0.000000000000540229  0.000000113514  0.522204342330   0.1 0.4193 0.09924      (i)
#> 7   ITEM2 ~~  ITEM2 0.000000000000472315  0.000000112738  0.487893130267   0.1 0.3716 0.09354      (i)
#> 8   ITEM3 ~~  ITEM3 0.000000000000238537 -0.000000073629 -0.335805001662   0.1 0.4400 0.10173      (i)
#> 11 LATENT ~~ LATENT 0.000000000000178507 -0.000000088079 -1.000000000000   0.1 0.2301 0.07675      (i)
#> 2  LATENT =~  ITEM2 0.000000000000105779  0.000000033940  0.000000027162   0.1 0.9183 0.16001      (i)
#> 5  LATENT =~  ITEM5 0.000000000000088833  0.000000029060  0.000000025596   0.1 1.0519 0.17648      (i)
#> 12  ITEM1 ~1        0.000000000000036875  0.000000024070  0.000000015183   0.1 0.6365 0.12549      (i)
#> 4  LATENT =~  ITEM4 0.000000000000032181  0.000000018213  0.000000015361   0.1 0.9701 0.16639      (i)
#> 14  ITEM3 ~1        0.000000000000015834  0.000000013162  0.000000008938   0.1 0.9139 0.15947      (i)
#> 10  ITEM5 ~~  ITEM5 0.000000000000006525 -0.000000011499 -0.526317783477   0.1 0.4935 0.10817      (i)
#> 13  ITEM2 ~1        0.000000000000002848  0.000000005822  0.000000004173   0.1 0.8401 0.15040      (i)
#> 16  ITEM5 ~1        0.000000000000002491  0.000000005073  0.000000004002   0.1 0.9682 0.16615      (i)
#> 3  LATENT =~  ITEM3 0.000000000000002179  0.000000004575  0.000000003468   0.1 1.0411 0.17515      (i)
#> 15  ITEM4 ~1        0.000000000000002165  0.000000004925  0.000000003721   0.1 0.8924 0.15682      (i)
#> 
#> $sample_covariance
#>      X1     X2    X3     X4     X5
#> 1 2.526 1.1726 1.355 1.0057 1.0740
#> 2 1.173 1.9700 1.226 0.9421 0.8961
#> 3 1.355 1.2262 2.198 1.1661 1.0095
#> 4 1.006 0.9421 1.166 1.7480 0.7210
#> 5 1.074 0.8961 1.010 0.7210 1.5890
#> 
#> $unstandardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  0.894
#> ITEM3  1.075
#> ITEM4  0.820
#> ITEM5  0.781
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 1.267                        
#> ITEM2 0.000 0.949                  
#> ITEM3 0.000 0.000 0.728            
#> ITEM4 0.000 0.000 0.000 0.915      
#> ITEM5 0.000 0.000 0.000 0.000 0.846
#> 
#> $psi
#>        LATENT
#> LATENT  1.246
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.053
#> ITEM2 -0.207
#> ITEM3 -0.139
#> ITEM4 -0.088
#> ITEM5 -0.265
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> 
#> $standardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  0.704
#> ITEM2  0.716
#> ITEM3  0.815
#> ITEM4  0.691
#> ITEM5  0.688
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.504                        
#> ITEM2 0.000 0.488                  
#> ITEM3 0.000 0.000 0.336            
#> ITEM4 0.000 0.000 0.000 0.522      
#> ITEM5 0.000 0.000 0.000 0.000 0.526
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.034
#> ITEM2 -0.148
#> ITEM3 -0.094
#> ITEM4 -0.067
#> ITEM5 -0.209
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
#>            X1       X2        X3       X4        X5     LATENT
#> 1    0.639786       NA        NA -0.56123 -0.452156 -0.0162082
#> 2   -2.462159 -2.24205 -1.872255 -1.75436 -0.314500 -1.4452155
#> 3   -3.173193 -0.30594 -0.170723 -2.27201 -0.475878 -0.8680697
#> 4    2.391312  0.73163 -0.124045  1.33760  1.527821  1.0533706
#> 5    2.022265  1.41504  0.730857  1.39196  0.987034  1.2657522
#> 6    1.383443  1.13576  1.838407  1.81671 -0.060534  1.3168717
#> 7   -0.676032  1.25276 -0.678001  0.83943  1.200650  0.4148860
#> 8    1.109309 -1.60560  1.649983  0.22981 -0.582407  0.4076129
#> 9   -3.006267 -3.48008 -3.968901 -2.26092 -2.684625 -2.7843513
#> 10   1.241994  0.40066        NA -0.73485  0.759983  0.5044819
#> 11  -0.671821 -0.03584  0.968296  0.69037  1.602008  0.6809625
#> 12   0.009977 -1.27707        NA  1.27346 -0.855387 -0.0730292
#> 13  -1.440489 -0.72304 -0.390055  0.01643 -0.756342 -0.4222243
#> 14  -1.048633       NA -2.565442 -1.15141 -0.633791 -1.2213413
#> 15  -1.052949  1.25520 -1.977844       NA -0.813196 -0.5552705
#> 16  -2.705331 -2.95574 -0.624360 -0.90667 -1.773437 -1.3741800
#> 17         NA  0.04042  0.158792 -0.48458  0.268199  0.1727432
#> 18  -1.122548  0.03449  0.636602 -0.19419        NA  0.0910219
#> 19   1.724857  1.85038  1.016928 -0.82100  0.901207  0.9984535
#> 20  -0.823031  0.87220 -0.743756 -0.30193 -2.183369 -0.4470834
#> 21   2.247335  0.15024  1.529624  0.31685  0.619615  1.0581722
#> 22  -0.865883 -0.19776 -0.554558 -0.95455 -2.524469 -0.7505321
#> 23         NA -1.24310 -2.309152 -2.34084 -0.748606 -1.4174670
#> 24   1.286175  0.20415  1.333835  0.06162  0.833330  0.8704523
#> 25  -4.298038 -3.05750 -4.087274 -3.85652  0.133625 -2.7152280
#> 26   2.495902 -0.75263  2.528312  1.12448 -0.704335  1.1166151
#> 27  -0.823530 -0.59527 -2.098346  1.01561  0.040350 -0.4739180
#> 28   2.316649 -1.01674 -0.395587 -0.25432  0.382797  0.2152466
#> 29   1.626247 -2.54697 -0.550370 -0.17640  0.143733 -0.2167060
#> 30  -1.351659       NA -1.610394  0.82331 -1.100452 -0.6801976
#> 31   0.633766  0.61780  0.596913 -2.15710  0.318937  0.1992874
#> 32  -1.384579 -1.21795 -3.028885 -0.95312 -3.051564 -1.7563003
#> 33   0.007360 -0.32950  0.673445 -0.21368 -1.117877  0.0421390
#> 34  -2.826463 -0.46275 -1.690815 -1.18182 -2.640033 -1.4416026
#> 35   0.294657 -1.89621 -0.745613  1.04713 -0.005622 -0.1744611
#> 36         NA -0.26031  0.788891  0.65495  1.237793  0.7196342
#> 37   1.451930 -0.70076 -1.035591 -0.58223 -0.838214 -0.2871902
#> 38  -0.480311 -0.05407  0.171414  0.42461  0.052321  0.1857271
#> 39   0.090071 -0.66147 -1.579065 -0.05741 -0.205198 -0.4305728
#> 40  -1.669765 -1.49730 -1.257693 -1.03100 -2.229167 -1.2420526
#> 41   1.667761 -0.77184  0.656335 -0.16149 -0.603245  0.2961564
#> 42  -1.134263 -2.84989 -0.405335 -1.59245 -1.892230 -1.2026916
#> 43   1.062521  1.12370 -0.135651  0.04811  0.826208  0.5968680
#> 44  -0.999419  0.27077 -1.761869  0.07868 -1.134894 -0.6111817
#> 45  -0.156330  0.24365 -0.387066  0.61340 -1.305877 -0.0651862
#> 46   1.236885  0.74165  1.279900 -0.55135  0.616662  0.8044333
#> 47   0.604340  1.65448  0.448725 -0.40711 -0.060499  0.5555439
#> 48   1.354228  0.98154 -0.087781 -0.18221 -1.316586  0.2281679
#> 49  -1.964453  1.23789 -0.504673 -0.29547 -0.722946 -0.2368213
#> 50   1.323308 -0.42226 -0.201303 -1.07283 -0.152976  0.0023978
#> 51  -2.640016 -1.07243 -1.809780 -0.52287  0.577211 -0.9010428
#> 52  -0.741620 -1.77211  0.210706  1.15967        NA -0.0807453
#> 53  -1.453124 -2.29694 -1.306631 -3.21899 -1.807075 -1.6481260
#> 54   0.497749 -0.66202 -3.708221 -2.95105        NA -1.6460956
#> 55   0.808181  1.45290  0.851715  0.63938  0.451935  0.9164791
#> 56   1.132951 -0.44072 -0.157261  0.66816  0.604495  0.3961831
#> 57  -0.560108 -1.47832  0.000185  0.74542 -0.267699 -0.1183604
#> 58  -0.386646 -2.97814 -2.005607  0.19209 -1.914683 -1.2602329
#> 59   3.079060  0.42778  1.395911  1.83170  1.150547  1.5270627
#> 60  -0.129479 -1.52672 -1.488135 -2.20964 -2.527302 -1.3302641
#> 61   0.634189  2.20799  2.173958  1.65723 -1.036166  1.2929959
#> 62   1.185995  0.98461  2.321097  0.83858  1.171766  1.4404692
#> 63   1.701540  0.54735        NA  0.73202  0.418642  0.8899227
#> 64         NA -1.75139  0.118915 -1.17354 -1.054536 -0.5922253
#> 65  -1.219101 -3.37202 -1.765710       NA -1.286063 -1.5278554
#> 66  -1.282848 -0.55215 -0.303290  1.33225 -1.488990 -0.2551562
#> 67  -0.200893 -0.01939  1.193102  0.18210  2.383388  0.8609720
#> 68   1.069363 -1.14897 -0.602401 -3.05781 -0.841137 -0.7080046
#> 69   0.723955  1.10954  0.552389 -0.05279 -0.474423  0.4951276
#> 70  -1.769029 -0.39022  0.482808 -1.73143  0.156053 -0.3090007
#> 71  -0.607125 -0.83899  1.153078 -0.89711 -0.733107 -0.0516193
#> 72   2.082636  1.83798        NA  0.41960  0.407821  1.2052201
#> 73  -2.174829 -0.25616 -0.479623 -0.36643 -1.010068 -0.5773503
#> 74   1.969984  2.47497  1.156767  1.73831  3.616271  2.0555203
#> 75   2.392735  0.45617  0.296841       NA  1.624826  1.0425686
#> 76  -1.314367 -0.23376 -0.455483       NA        NA -0.3701817
#> 77   0.797466  1.53080  0.703988  1.07348  1.328744  1.1074453
#> 78  -0.226802       NA -1.254460 -0.09453 -0.301778 -0.3933819
#> 79  -4.610416 -1.78377 -2.871683 -1.27790 -3.755634 -2.4480990
#> 80   2.451652  2.39100 -0.420545  1.17354 -1.116675  0.7944741
#> 81  -1.129669 -0.26796  1.301954  1.51736 -1.008650  0.3597530
#> 82  -0.115980 -0.11174 -0.474545  0.30391  1.002906  0.1948708
#> 83   0.160418  1.27257  0.741898  0.02651  0.418738  0.6566753
#> 84  -0.883454  2.13771  2.543341       NA  1.016580  1.4118395
#> 85  -1.039326 -0.11530  0.739306 -2.19353 -0.629758 -0.2955752
#> 86  -0.856566 -1.99731 -1.100760 -0.04275  0.597388 -0.5299975
#> 87  -1.078149 -0.62091 -0.032027  0.98580 -0.181584 -0.0004321
#> 88   1.663212 -0.29661  1.141832  1.60975  0.677057  1.0137568
#> 89  -0.282234       NA  1.521132 -0.52321 -0.202426  0.4181409
#> 90  -2.209001 -1.59546 -0.936984  0.97103 -1.271507 -0.7612236
#> 91   0.607963  1.45034  0.430476  2.03382 -0.275280  0.8789990
#> 92  -0.848125 -0.04688 -1.395504 -1.63656 -1.658392 -0.9140910
#> 93   0.933619 -0.07215 -1.067518 -0.37519 -0.113384 -0.1062550
#> 94         NA -1.26543 -2.310348 -0.59963 -0.468427 -1.0343780
#> 95   0.915919 -0.46984 -0.235870 -1.44221 -0.706289 -0.2275850
#> 96   0.802705  1.55491  0.522001  1.48089 -0.914367  0.7514624
#> 97   1.811700  1.08863  1.116562  2.46323  2.051236  1.6379804
#> 98   2.349805  2.26437  2.852502  2.31184        NA  2.2691915
#> 99   0.586106  0.80988  3.291084  2.35975  1.531432  1.8948454
#> 100  0.395401  2.45207  2.009135  1.19827  1.964904  1.6874133
#> 
#> $call
#>                                                                call
#> 1 lavaan::lavaan(model=model,data=df,missing="ML",model.type="cfa",
#> 2 cmd="cfa",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,
#> 3            auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,
#> 4       auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)
#> 
```
