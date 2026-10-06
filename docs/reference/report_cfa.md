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






#> [1] "####################################################################################################"
#> [1] "SUMMARY"
#> [1] "####################################################################################################"
#> lavaan 0.7-2 ended normally after 26 iterations
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
#>   Test statistic                                 2.516
#>   Degrees of freedom                                 5
#>   P-value (Chi-square)                           0.774
#> 
#> Model Test Baseline Model:
#> 
#>   Test statistic                               123.277
#>   Degrees of freedom                                10
#>   P-value                                        0.000
#> 
#> User Model versus Baseline Model:
#> 
#>   Comparative Fit Index (CFI)                    1.000
#>   Tucker-Lewis Index (TLI)                       1.044
#>                                                       
#>   Robust Comparative Fit Index (CFI)             1.000
#>   Robust Tucker-Lewis Index (TLI)                1.043
#> 
#> Loglikelihood and Information Criteria:
#> 
#>   Loglikelihood user model (H0)               -778.766
#>   Loglikelihood unrestricted model (H1)       -777.508
#>                                                       
#>   Akaike (AIC)                                1587.532
#>   Bayesian (BIC)                              1626.610
#>   Sample-size adjusted Bayesian (SABIC)       1579.236
#> 
#> Root Mean Square Error of Approximation:
#> 
#>   RMSEA                                          0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.093
#>   P-value H_0: RMSEA <= 0.050                    0.852
#>   P-value H_0: RMSEA >= 0.080                    0.075
#>                                                       
#>   Robust RMSEA                                   0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.100
#>   P-value H_0: Robust RMSEA <= 0.050             0.840
#>   P-value H_0: Robust RMSEA >= 0.080             0.088
#> 
#> Standardized Root Mean Square Residual:
#> 
#>   SRMR                                           0.021
#> 
#> Goodness of Fit Index:
#> 
#>   Goodness of Fit Index (GFI)                    1.000
#>   90 Percent confidence interval - lower         0.983
#>   90 Percent confidence interval - upper         1.000
#>                                                       
#>   Robust GFI                                     1.000
#>   90 Percent confidence interval - lower         0.980
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
#>     ITEM1             1.000                               0.905    0.657
#>     ITEM2             1.021    0.215    4.742    0.000    0.923    0.614
#>     ITEM3             1.045    0.210    4.980    0.000    0.945    0.645
#>     ITEM4             1.097    0.208    5.279    0.000    0.993    0.725
#>     ITEM5             1.084    0.213    5.076    0.000    0.980    0.699
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1            -0.055    0.140   -0.394    0.693   -0.055   -0.040
#>    .ITEM2            -0.046    0.153   -0.297    0.766   -0.046   -0.030
#>    .ITEM3            -0.182    0.149   -1.221    0.222   -0.182   -0.124
#>    .ITEM4            -0.244    0.139   -1.755    0.079   -0.244   -0.178
#>    .ITEM5            -0.261    0.143   -1.831    0.067   -0.261   -0.186
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1             1.078    0.197    5.459    0.000    1.078    0.568
#>    .ITEM2             1.407    0.245    5.740    0.000    1.407    0.623
#>    .ITEM3             1.255    0.223    5.622    0.000    1.255    0.584
#>    .ITEM4             0.890    0.180    4.940    0.000    0.890    0.474
#>    .ITEM5             1.004    0.195    5.139    0.000    1.004    0.511
#>     LATENT            0.818    0.258    3.170    0.002    1.000    1.000
#> 
#> R-Square:
#>                    Estimate
#>     ITEM1             0.432
#>     ITEM2             0.377
#>     ITEM3             0.416
#>     ITEM4             0.526
#>     ITEM5             0.489
#> 
#> [1] "####################################################################################################"
#> [1] "R_SQUARED"
#> [1] "####################################################################################################"
#>       r_squared
#> ITEM1    0.4316
#> ITEM2    0.3774
#> ITEM3    0.4159
#> ITEM4    0.5256
#> ITEM5    0.4891
#> [1] "####################################################################################################"
#> [1] "FIT INDICES"
#> [1] "####################################################################################################"
#>                                     fit
#> npar                           15.00000
#> fmin                            0.01258
#> chisq                           2.51627
#> df                              5.00000
#> pvalue                          0.77404
#> baseline.chisq                123.27742
#> baseline.df                    10.00000
#> baseline.pvalue                 0.00000
#> cfi                             1.00000
#> tli                             1.04385
#> cfi.robust                      1.00000
#> tli.robust                      1.04294
#> nnfi                            1.04385
#> rfi                             0.95918
#> nfi                             0.97959
#> pnfi                            0.48979
#> ifi                             1.02100
#> rni                             1.02193
#> nnfi.robust                     1.04294
#> rni.robust                      1.02147
#> logl                         -778.76617
#> unrestricted.logl            -777.50803
#> aic                          1587.53234
#> bic                          1626.60989
#> ntotal                        100.00000
#> bic2                         1579.23612
#> rmsea                           0.00000
#> rmsea.ci.lower                  0.00000
#> rmsea.ci.upper                  0.09338
#> rmsea.ci.level                  0.90000
#> rmsea.pvalue                    0.85211
#> rmsea.close.h0                  0.05000
#> rmsea.notclose.pvalue           0.07526
#> rmsea.notclose.h0               0.08000
#> rmsea.robust                    0.00000
#> rmsea.ci.lower.robust           0.00000
#> rmsea.ci.upper.robust           0.10029
#> rmsea.pvalue.robust             0.83956
#> rmsea.notclose.pvalue.robust    0.08842
#> rmr                             0.04319
#> rmr_nomean                      0.04986
#> srmr                            0.02129
#> srmr_bentler                    0.02129
#> srmr_bentler_nomean             0.02456
#> crmr                            0.02450
#> crmr_nomean                     0.02998
#> srmr_mplus                      0.02125
#> srmr_mplus_nomean               0.02452
#> gfi                             1.00000
#> gfi.ci.lower                    0.98286
#> gfi.ci.upper                    1.00000
#> gfi.ci.level                    0.90000
#> gfi.robust                      1.00000
#> gfi.ci.lower.robust             0.98028
#> gfi.ci.upper.robust             1.00000
#> cn_05                         440.95642
#> cn_01                         600.54870
#> gfi_lisrel                      0.98262
#> agfi_lisrel                     0.93049
#> pgfi                            0.24566
#> mfi                             1.01250
#> ecvi                            0.32516
#> [1] "####################################################################################################"
#> [1] "PARAMETERS"
#> [1] "####################################################################################################"
#>       lhs op    rhs exo      est     se       z         pvalue ci.lower ci.upper   std.lv  std.all
#> 1  LATENT =~  ITEM1   0  1.00000 0.0000      NA             NA   1.0000  1.00000  0.90459  0.65696
#> 2  LATENT =~  ITEM2   0  1.02080 0.2153  4.7417 0.000002119027   0.5989  1.44274  0.92341  0.61434
#> 3  LATENT =~  ITEM3   0  1.04522 0.2099  4.9796 0.000000637158   0.6338  1.45662  0.94550  0.64492
#> 4  LATENT =~  ITEM4   0  1.09748 0.2079  5.2790 0.000000129913   0.6900  1.50495  0.99277  0.72495
#> 5  LATENT =~  ITEM5   0  1.08364 0.2135  5.0761 0.000000385257   0.6652  1.50205  0.98025  0.69933
#> 6   ITEM1 ~~  ITEM1   0  1.07769 0.1974  5.4592 0.000000047834   0.6908  1.46461  1.07769  0.56841
#> 7   ITEM2 ~~  ITEM2   0  1.40660 0.2450  5.7404 0.000000009448   0.9263  1.88686  1.40660  0.62259
#> 8   ITEM3 ~~  ITEM3   0  1.25539 0.2233  5.6217 0.000000018906   0.8177  1.69308  1.25539  0.58408
#> 9   ITEM4 ~~  ITEM4   0  0.88975 0.1801  4.9396 0.000000782962   0.5367  1.24279  0.88975  0.47445
#> 10  ITEM5 ~~  ITEM5   0  1.00387 0.1953  5.1391 0.000000276066   0.6210  1.38673  1.00387  0.51094
#> 11 LATENT ~~ LATENT   0  0.81829 0.2581  3.1703 0.001522776030   0.3124  1.32417  1.00000  1.00000
#> 12  ITEM1 ~1          0 -0.05527 0.1402 -0.3943 0.693368377850  -0.3300  0.21947 -0.05527 -0.04014
#> 13  ITEM2 ~1          0 -0.04559 0.1532 -0.2975 0.766092428621  -0.3459  0.25476 -0.04559 -0.03033
#> 14  ITEM3 ~1          0 -0.18227 0.1492 -1.2214 0.221940261910  -0.4748  0.11022 -0.18227 -0.12433
#> 15  ITEM4 ~1          0 -0.24423 0.1392 -1.7545 0.079338519742  -0.5170  0.02859 -0.24423 -0.17834
#> 16  ITEM5 ~1          0 -0.26109 0.1426 -1.8308 0.067135503599  -0.5406  0.01843 -0.26109 -0.18627
#> 17 LATENT ~1          0  0.00000 0.0000      NA             NA   0.0000  0.00000  0.00000  0.00000
#> 18  ITEM1 r2  ITEM1   0  0.43159     NA      NA             NA       NA       NA       NA       NA
#> 19  ITEM2 r2  ITEM2   0  0.37741     NA      NA             NA       NA       NA       NA       NA
#> 20  ITEM3 r2  ITEM3   0  0.41592     NA      NA             NA       NA       NA       NA       NA
#> 21  ITEM4 r2  ITEM4   0  0.52555     NA      NA             NA       NA       NA       NA       NA
#> 22  ITEM5 r2  ITEM5   0  0.48906     NA      NA             NA       NA       NA       NA       NA
#> [1] "####################################################################################################"
#> [1] "UNSTANDARDIZED PARAMETERS"
#> [1] "####################################################################################################"
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  1.021
#> ITEM3  1.045
#> ITEM4  1.097
#> ITEM5  1.084
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 1.078                        
#> ITEM2 0.000 1.407                  
#> ITEM3 0.000 0.000 1.255            
#> ITEM4 0.000 0.000 0.000 0.890      
#> ITEM5 0.000 0.000 0.000 0.000 1.004
#> 
#> $psi
#>        LATENT
#> LATENT  0.818
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.055
#> ITEM2 -0.046
#> ITEM3 -0.182
#> ITEM4 -0.244
#> ITEM5 -0.261
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> [1] "####################################################################################################"
#> [1] "STANDARDIZED PARAMETERS"
#> [1] "####################################################################################################"
#> $lambda
#>       LATENT
#> ITEM1  0.657
#> ITEM2  0.614
#> ITEM3  0.645
#> ITEM4  0.725
#> ITEM5  0.699
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.568                        
#> ITEM2 0.000 0.623                  
#> ITEM3 0.000 0.000 0.584            
#> ITEM4 0.000 0.000 0.000 0.474      
#> ITEM5 0.000 0.000 0.000 0.000 0.511
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.040
#> ITEM2 -0.030
#> ITEM3 -0.124
#> ITEM4 -0.178
#> ITEM5 -0.186
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> [1] "####################################################################################################"
#> [1] "SAMPLE COVARIANCE"
#> [1] "####################################################################################################"
#>       X1     X2     X3     X4     X5
#> 1 1.8837 0.8843 0.7668 0.8772 0.7431
#> 2 0.8843 2.2061 0.7537 0.7714 0.8021
#> 3 0.7668 0.7537 2.1320 0.9960 0.8395
#> 4 0.8772 0.7714 0.9960 1.8931 1.0420
#> 5 0.7431 0.8021 0.8395 1.0420 1.9344
#> [1] "####################################################################################################"
#> [1] "CALL"
#> [1] "####################################################################################################"
#> [1] "lavaan::lavaan(model=model,data=df,missing=\"ML\",model.type=\"cfa\"," "cmd=\"cfa\",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,"  
#> [3] "auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,"                "auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)"          
#> [1] "lavaan::lavaan(model=model,data=df,missing=\"ML\",model.type=\"cfa\"," "cmd=\"cfa\",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,"  
#> [3] "auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,"                "auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)"          
#> $r_squared
#>       r_squared
#> ITEM1    0.4316
#> ITEM2    0.3774
#> ITEM3    0.4159
#> ITEM4    0.5256
#> ITEM5    0.4891
#> 
#> $fit_indices
#>                                     fit
#> npar                           15.00000
#> fmin                            0.01258
#> chisq                           2.51627
#> df                              5.00000
#> pvalue                          0.77404
#> baseline.chisq                123.27742
#> baseline.df                    10.00000
#> baseline.pvalue                 0.00000
#> cfi                             1.00000
#> tli                             1.04385
#> cfi.robust                      1.00000
#> tli.robust                      1.04294
#> nnfi                            1.04385
#> rfi                             0.95918
#> nfi                             0.97959
#> pnfi                            0.48979
#> ifi                             1.02100
#> rni                             1.02193
#> nnfi.robust                     1.04294
#> rni.robust                      1.02147
#> logl                         -778.76617
#> unrestricted.logl            -777.50803
#> aic                          1587.53234
#> bic                          1626.60989
#> ntotal                        100.00000
#> bic2                         1579.23612
#> rmsea                           0.00000
#> rmsea.ci.lower                  0.00000
#> rmsea.ci.upper                  0.09338
#> rmsea.ci.level                  0.90000
#> rmsea.pvalue                    0.85211
#> rmsea.close.h0                  0.05000
#> rmsea.notclose.pvalue           0.07526
#> rmsea.notclose.h0               0.08000
#> rmsea.robust                    0.00000
#> rmsea.ci.lower.robust           0.00000
#> rmsea.ci.upper.robust           0.10029
#> rmsea.pvalue.robust             0.83956
#> rmsea.notclose.pvalue.robust    0.08842
#> rmr                             0.04319
#> rmr_nomean                      0.04986
#> srmr                            0.02129
#> srmr_bentler                    0.02129
#> srmr_bentler_nomean             0.02456
#> crmr                            0.02450
#> crmr_nomean                     0.02998
#> srmr_mplus                      0.02125
#> srmr_mplus_nomean               0.02452
#> gfi                             1.00000
#> gfi.ci.lower                    0.98286
#> gfi.ci.upper                    1.00000
#> gfi.ci.level                    0.90000
#> gfi.robust                      1.00000
#> gfi.ci.lower.robust             0.98028
#> gfi.ci.upper.robust             1.00000
#> cn_05                         440.95642
#> cn_01                         600.54870
#> gfi_lisrel                      0.98262
#> agfi_lisrel                     0.93049
#> pgfi                            0.24566
#> mfi                             1.01250
#> ecvi                            0.32516
#> 
#> $parameters
#>       lhs op    rhs exo      est     se       z         pvalue ci.lower ci.upper   std.lv  std.all
#> 1  LATENT =~  ITEM1   0  1.00000 0.0000      NA             NA   1.0000  1.00000  0.90459  0.65696
#> 2  LATENT =~  ITEM2   0  1.02080 0.2153  4.7417 0.000002119027   0.5989  1.44274  0.92341  0.61434
#> 3  LATENT =~  ITEM3   0  1.04522 0.2099  4.9796 0.000000637158   0.6338  1.45662  0.94550  0.64492
#> 4  LATENT =~  ITEM4   0  1.09748 0.2079  5.2790 0.000000129913   0.6900  1.50495  0.99277  0.72495
#> 5  LATENT =~  ITEM5   0  1.08364 0.2135  5.0761 0.000000385257   0.6652  1.50205  0.98025  0.69933
#> 6   ITEM1 ~~  ITEM1   0  1.07769 0.1974  5.4592 0.000000047834   0.6908  1.46461  1.07769  0.56841
#> 7   ITEM2 ~~  ITEM2   0  1.40660 0.2450  5.7404 0.000000009448   0.9263  1.88686  1.40660  0.62259
#> 8   ITEM3 ~~  ITEM3   0  1.25539 0.2233  5.6217 0.000000018906   0.8177  1.69308  1.25539  0.58408
#> 9   ITEM4 ~~  ITEM4   0  0.88975 0.1801  4.9396 0.000000782962   0.5367  1.24279  0.88975  0.47445
#> 10  ITEM5 ~~  ITEM5   0  1.00387 0.1953  5.1391 0.000000276066   0.6210  1.38673  1.00387  0.51094
#> 11 LATENT ~~ LATENT   0  0.81829 0.2581  3.1703 0.001522776030   0.3124  1.32417  1.00000  1.00000
#> 12  ITEM1 ~1          0 -0.05527 0.1402 -0.3943 0.693368377850  -0.3300  0.21947 -0.05527 -0.04014
#> 13  ITEM2 ~1          0 -0.04559 0.1532 -0.2975 0.766092428621  -0.3459  0.25476 -0.04559 -0.03033
#> 14  ITEM3 ~1          0 -0.18227 0.1492 -1.2214 0.221940261910  -0.4748  0.11022 -0.18227 -0.12433
#> 15  ITEM4 ~1          0 -0.24423 0.1392 -1.7545 0.079338519742  -0.5170  0.02859 -0.24423 -0.17834
#> 16  ITEM5 ~1          0 -0.26109 0.1426 -1.8308 0.067135503599  -0.5406  0.01843 -0.26109 -0.18627
#> 17 LATENT ~1          0  0.00000 0.0000      NA             NA   0.0000  0.00000  0.00000  0.00000
#> 18  ITEM1 r2  ITEM1   0  0.43159     NA      NA             NA       NA       NA       NA       NA
#> 19  ITEM2 r2  ITEM2   0  0.37741     NA      NA             NA       NA       NA       NA       NA
#> 20  ITEM3 r2  ITEM3   0  0.41592     NA      NA             NA       NA       NA       NA       NA
#> 21  ITEM4 r2  ITEM4   0  0.52555     NA      NA             NA       NA       NA       NA       NA
#> 22  ITEM5 r2  ITEM5   0  0.48906     NA      NA             NA       NA       NA       NA       NA
#> 
#> $modification_indices
#>       lhs op    rhs                   mi            epc        sepc.all delta    ncp   power decision
#> 18  ITEM1 ~~  ITEM2 1.575110839935802476  0.21251846477  0.172609378822   0.1 0.3488 0.09081      (i)
#> 23  ITEM2 ~~  ITEM4 1.008753758987093629 -0.17067529477 -0.152563912262   0.1 0.3463 0.09052      (i)
#> 27  ITEM4 ~~  ITEM5 0.842221227549647122  0.15216652522  0.161007600078   0.1 0.3637 0.09260      (i)
#> 21  ITEM1 ~~  ITEM5 0.541638274408710041 -0.11794058521 -0.113390611105   0.1 0.3894 0.09567      (i)
#> 25  ITEM3 ~~  ITEM4 0.325186402585709800  0.09572643860  0.090574888446   0.1 0.3549 0.09154      (i)
#> 20  ITEM1 ~~  ITEM4 0.311399865863062286 -0.08858882108 -0.090468471125   0.1 0.3968 0.09655      (i)
#> 26  ITEM3 ~~  ITEM5 0.189989559345094344 -0.07386167342 -0.065794643424   0.1 0.3483 0.09075      (i)
#> 22  ITEM2 ~~  ITEM3 0.144596528094055321 -0.06851017202 -0.051556135328   0.1 0.3081 0.08597      (i)
#> 24  ITEM2 ~~  ITEM5 0.041533539181603039  0.03513801191  0.029570170577   0.1 0.3364 0.08934      (i)
#> 19  ITEM1 ~~  ITEM3 0.040331467084170618  0.03323201387  0.028570584861   0.1 0.3652 0.09278      (i)
#> 3  LATENT =~  ITEM3 0.000000000018327700 -0.00000064481 -0.000000397860   0.1 0.4408 0.10183      (i)
#> 10  ITEM5 ~~  ITEM5 0.000000000009064950  0.00000054287  0.510938157360   0.1 0.3076 0.08592      (i)
#> 7   ITEM2 ~~  ITEM2 0.000000000007915495  0.00000065436  0.622586353975   0.1 0.1849 0.07143      (i)
#> 4  LATENT =~  ITEM4 0.000000000007501251  0.00000035895  0.000000237108   0.1 0.5822 0.11890      (i)
#> 14  ITEM3 ~1        0.000000000003059248  0.00000021741  0.000000148293   0.1 0.6472 0.12680      (i)
#> 12  ITEM1 ~1        0.000000000002893124  0.00000019704  0.000000143101   0.1 0.7452 0.13876      (i)
#> 13  ITEM2 ~1        0.000000000002649062  0.00000021143  0.000000140662   0.1 0.5926 0.12016      (i)
#> 15  ITEM4 ~1        0.000000000002066507  0.00000015779  0.000000115226   0.1 0.8300 0.14915      (i)
#> 16  ITEM5 ~1        0.000000000001839429  0.00000015513  0.000000110671   0.1 0.7644 0.14111      (i)
#> 5  LATENT =~  ITEM5 0.000000000001179528  0.00000014918  0.000000096271   0.1 0.5300 0.11258      (i)
#> 8   ITEM3 ~~  ITEM3 0.000000000000966081  0.00000020928  0.584076895647   0.1 0.2206 0.07563      (i)
#> 6   ITEM1 ~~  ITEM1 0.000000000000485507  0.00000012885  0.568409936084   0.1 0.2924 0.08412      (i)
#> 11 LATENT ~~ LATENT 0.000000000000288934  0.00000007819  1.000000000000   0.1 0.4726 0.10565      (i)
#> 9   ITEM4 ~~  ITEM4 0.000000000000042977  0.00000003442  0.474446646181   0.1 0.3627 0.09248      (i)
#> 2  LATENT =~  ITEM2 0.000000000000004385 -0.00000001046 -0.000000006295   0.1 0.4008 0.09703      (i)
#> 
#> $sample_covariance
#>       X1     X2     X3     X4     X5
#> 1 1.8837 0.8843 0.7668 0.8772 0.7431
#> 2 0.8843 2.2061 0.7537 0.7714 0.8021
#> 3 0.7668 0.7537 2.1320 0.9960 0.8395
#> 4 0.8772 0.7714 0.9960 1.8931 1.0420
#> 5 0.7431 0.8021 0.8395 1.0420 1.9344
#> 
#> $unstandardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  1.021
#> ITEM3  1.045
#> ITEM4  1.097
#> ITEM5  1.084
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 1.078                        
#> ITEM2 0.000 1.407                  
#> ITEM3 0.000 0.000 1.255            
#> ITEM4 0.000 0.000 0.000 0.890      
#> ITEM5 0.000 0.000 0.000 0.000 1.004
#> 
#> $psi
#>        LATENT
#> LATENT  0.818
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.055
#> ITEM2 -0.046
#> ITEM3 -0.182
#> ITEM4 -0.244
#> ITEM5 -0.261
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> 
#> $standardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  0.657
#> ITEM2  0.614
#> ITEM3  0.645
#> ITEM4  0.725
#> ITEM5  0.699
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.568                        
#> ITEM2 0.000 0.623                  
#> ITEM3 0.000 0.000 0.584            
#> ITEM4 0.000 0.000 0.000 0.474      
#> ITEM5 0.000 0.000 0.000 0.000 0.511
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.040
#> ITEM2 -0.030
#> ITEM3 -0.124
#> ITEM4 -0.178
#> ITEM5 -0.186
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
#>           X1       X2        X3       X4       X5    LATENT
#> 1    2.30399 -0.62185  0.216067 -0.31233  0.32447  0.421786
#> 2    1.29998  0.96930  2.011199 -0.97523  2.31276  0.906520
#> 3    1.54746  1.64206 -0.405864  1.66905  0.51747  0.911163
#> 4   -1.33798 -1.78760 -0.115288  0.09109 -1.09291 -0.458750
#> 5    1.75337  1.51868 -0.473187  2.38263  0.02131  0.973231
#> 6    1.22093  3.24302  1.301723  0.67116  0.37175  1.053164
#> 7   -0.86883 -1.66117 -0.431770  0.77050  0.04665 -0.087721
#> 8    0.29469  2.30208        NA  0.20169       NA  0.607494
#> 9   -1.06430 -0.70209        NA -1.08696 -2.78961 -0.957039
#> 10   0.61144 -0.54066 -0.024551 -0.99525  0.54694  0.053552
#> 11  -0.21492 -2.17093  0.091133 -1.91821 -1.07128 -0.700503
#> 12   1.77965 -2.32520 -1.982789  0.85984  0.23657  0.071320
#> 13   1.11609  0.12359 -0.761045 -0.39851  1.06670  0.313599
#> 14  -2.06728 -1.55800 -0.605755 -1.52283 -1.29870 -0.957012
#> 15  -0.01463 -0.51942  0.158947 -2.05527 -2.03164 -0.663090
#> 16   0.54033 -0.99698  0.400467 -0.07499 -0.37012  0.069766
#> 17        NA  0.90204 -0.430920  1.41694  1.36464  0.799876
#> 18  -0.18604  0.35370  1.204072 -0.24374  1.67332  0.542829
#> 19  -0.43218 -1.08850 -1.792360  0.30435  1.60227  0.038337
#> 20  -0.39489  0.59556 -0.598771  0.77373  1.96285  0.550508
#> 21   1.21367 -0.69614  0.316106  0.50203  0.57693  0.468673
#> 22   0.03742  2.21838  0.997200  0.65122  1.00256  0.824190
#> 23   1.04911 -0.70233 -0.946168  0.12230 -0.89533 -0.050982
#> 24  -1.60819  0.94178  2.682028 -0.21294 -0.23116  0.275483
#> 25  -0.87084 -1.04233 -0.370516 -1.83158 -2.82695 -1.012742
#> 26   0.20004  3.46702 -0.984932       NA  0.00383  0.487505
#> 27   1.42072  1.52240 -0.488319 -0.38455  1.29837  0.598776
#> 28        NA -1.77349 -0.644034 -1.19601 -1.03875 -0.681759
#> 29  -0.90230  1.42958 -1.967338 -2.12383 -0.40862 -0.585459
#> 30  -1.54375 -0.37187 -3.327904 -0.79604 -1.01035 -0.911199
#> 31   0.48613 -1.14955 -1.396045 -0.14957 -1.52959 -0.407657
#> 32  -1.23421  0.49271  0.591671       NA  1.18701  0.305074
#> 33  -0.79139 -1.51556 -2.041046 -0.09371 -0.05984 -0.460584
#> 34   0.08694 -0.49714  0.995327       NA  0.40603  0.305191
#> 35  -1.26940       NA -1.744933 -1.08906 -1.83165 -0.931709
#> 36   0.45113 -2.11489 -1.389769 -2.11903 -2.83588 -1.134395
#> 37  -0.63640 -2.72914 -2.250908 -0.44458 -2.34208 -1.066523
#> 38  -1.15665  2.06262 -0.099876  0.04398 -0.05000  0.184574
#> 39  -0.20561  1.85600  0.691747  0.49146 -0.30853  0.449432
#> 40   2.01598       NA  2.924245  3.09645  2.48670  2.091600
#> 41        NA -2.60759 -0.893688 -0.85431  0.13247 -0.518860
#> 42  -0.44315 -0.96563 -0.050797 -0.09444  0.60148  0.031461
#> 43  -0.92029  0.12661 -2.271007  0.68890 -1.28214 -0.376791
#> 44  -1.08094 -0.96480  1.551459  0.55348  1.06273  0.356053
#> 45   2.36147       NA  0.968872       NA       NA  1.059839
#> 46   2.43016  2.20717  0.169111  1.74478  1.22211  1.318824
#> 47  -0.83090 -1.06544 -2.420426 -0.81966 -1.14616 -0.793778
#> 48   0.53288  2.01929  0.134751 -1.10161 -0.69292  0.124837
#> 49   2.61760  0.89258        NA  1.21112  0.28902  1.025070
#> 50   2.21327  1.81254  3.129310  1.31225  0.48525  1.421942
#> 51  -0.57086 -0.04874  0.544531 -0.74229 -2.27465 -0.423818
#> 52   1.33569  0.74093  0.023338 -1.17709 -1.34805 -0.046355
#> 53   1.76295  1.07623  1.000587  0.20721  1.18600  0.891882
#> 54  -0.80496 -0.41791 -1.461017 -1.64332 -0.12994 -0.575176
#> 55  -1.09332 -1.43166  0.927129  0.74882  0.61645  0.179285
#> 56   0.08987 -0.03144  2.337408  3.26843  1.05759  1.272818
#> 57  -1.74412  0.85047  0.290784 -0.52879 -0.64490 -0.204991
#> 58   1.48115  4.55424  0.976593  1.23916  1.37426  1.483611
#> 59        NA  0.24969 -3.102385 -0.98529 -2.44602 -1.024831
#> 60  -2.87816 -3.02366 -0.272409  1.76127 -1.27785 -0.553670
#> 61  -0.33996 -0.02889  0.338793  1.71212 -1.44486  0.209570
#> 62   0.07471 -1.15358 -0.478080  0.45897  0.27220  0.081672
#> 63  -1.79804 -1.48121 -2.141252 -2.01796       NA -1.266508
#> 64  -0.47264 -0.16148  0.002004 -0.96094 -0.69336 -0.265514
#> 65  -2.47849 -0.95017 -0.017004 -0.71461 -1.11118 -0.678693
#> 66  -2.12193  1.59803 -1.253555 -1.59056 -0.29143 -0.526727
#> 67  -1.00562 -3.23822  0.318781 -2.09477 -1.75172 -1.061868
#> 68   1.94159  0.74422 -0.194278 -0.76626  0.31129  0.380308
#> 69   2.54026  0.96659  1.006594  2.49430  0.74264  1.367525
#> 70  -0.42170 -0.12149 -0.598312 -1.33657 -0.15924 -0.314888
#> 71  -1.69897 -0.46369 -2.097059  0.49202 -0.64706 -0.466444
#> 72  -0.60809 -1.35512 -3.250221 -3.90634 -0.40506 -1.382798
#> 73   1.02621  1.48728  1.390372 -0.48988       NA  0.610454
#> 74  -3.92709 -1.02763        NA -2.64528 -0.71140 -1.431980
#> 75   0.19716  1.63346 -0.021705  1.30842  1.08762  0.788842
#> 76   1.05244 -0.73197  1.365527  0.15945 -0.26071  0.368644
#> 77   0.44851  0.07589  0.177412  1.06074  0.36246  0.499296
#> 78   1.30006  0.32317  2.824783  0.07513  2.47070  1.172991
#> 79  -1.87677 -1.23941 -1.429641 -2.07009 -0.26787 -0.931593
#> 80   2.50274  1.37462  2.440114  1.01745       NA  1.396723
#> 81   0.44401  1.07258  1.166165 -0.93632 -0.68142  0.173451
#> 82   0.20457       NA -0.128311 -1.23910 -0.81212 -0.277058
#> 83  -0.66681 -1.97393 -2.534804 -3.96819 -2.40793 -1.724310
#> 84   1.07750  0.13558  0.550475 -1.23221 -2.28569 -0.256420
#> 85  -2.16198 -2.55603  0.177681 -2.41314 -1.62197 -1.212721
#> 86        NA -1.61043 -2.674753 -1.70657 -2.47511 -1.382329
#> 87   0.28225 -0.54373 -0.267156 -0.33374  1.80839  0.318961
#> 88  -0.18545  0.12677  2.344283  1.24701 -2.25952  0.284834
#> 89  -1.90286 -0.09759 -2.155424 -1.89986 -3.91431 -1.492664
#> 90  -0.70770 -1.24758 -2.027954 -1.50733 -1.06171 -0.865088
#> 91   0.70977  0.65693  1.588627  1.68132  2.99200  1.365401
#> 92   1.93760  1.53826        NA  0.40550 -0.85587  0.583279
#> 93  -0.74207 -1.29954 -0.854198 -0.32681  0.19845 -0.272506
#> 94  -0.82408  1.44230 -1.870106 -0.43899  0.95839  0.005935
#> 95   1.61869       NA  0.358794  1.39358  2.19789  1.204676
#> 96  -2.06952  0.01488 -0.876805 -0.99505  0.02061 -0.481415
#> 97  -0.54772 -0.49879  2.552413 -0.71153 -0.87515  0.040060
#> 98   0.36456 -0.89475 -1.953051 -1.94059 -2.02049 -0.905824
#> 99   0.41756  0.07920  0.624322       NA -2.24426 -0.190617
#> 100 -1.11307 -1.18659 -0.428160  0.56358 -1.34684 -0.348468
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






#> [1] "####################################################################################################"
#> [1] "SUMMARY"
#> [1] "####################################################################################################"
#> lavaan 0.7-2 ended normally after 26 iterations
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
#>   Test statistic                                 2.516
#>   Degrees of freedom                                 5
#>   P-value (Chi-square)                           0.774
#> 
#> Model Test Baseline Model:
#> 
#>   Test statistic                               123.277
#>   Degrees of freedom                                10
#>   P-value                                        0.000
#> 
#> User Model versus Baseline Model:
#> 
#>   Comparative Fit Index (CFI)                    1.000
#>   Tucker-Lewis Index (TLI)                       1.044
#>                                                       
#>   Robust Comparative Fit Index (CFI)             1.000
#>   Robust Tucker-Lewis Index (TLI)                1.043
#> 
#> Loglikelihood and Information Criteria:
#> 
#>   Loglikelihood user model (H0)               -778.766
#>   Loglikelihood unrestricted model (H1)       -777.508
#>                                                       
#>   Akaike (AIC)                                1587.532
#>   Bayesian (BIC)                              1626.610
#>   Sample-size adjusted Bayesian (SABIC)       1579.236
#> 
#> Root Mean Square Error of Approximation:
#> 
#>   RMSEA                                          0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.093
#>   P-value H_0: RMSEA <= 0.050                    0.852
#>   P-value H_0: RMSEA >= 0.080                    0.075
#>                                                       
#>   Robust RMSEA                                   0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.100
#>   P-value H_0: Robust RMSEA <= 0.050             0.840
#>   P-value H_0: Robust RMSEA >= 0.080             0.088
#> 
#> Standardized Root Mean Square Residual:
#> 
#>   SRMR                                           0.021
#> 
#> Goodness of Fit Index:
#> 
#>   Goodness of Fit Index (GFI)                    1.000
#>   90 Percent confidence interval - lower         0.983
#>   90 Percent confidence interval - upper         1.000
#>                                                       
#>   Robust GFI                                     1.000
#>   90 Percent confidence interval - lower         0.980
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
#>     ITEM1             1.000                               0.905    0.657
#>     ITEM2             1.021    0.215    4.742    0.000    0.923    0.614
#>     ITEM3             1.045    0.210    4.980    0.000    0.945    0.645
#>     ITEM4             1.097    0.208    5.279    0.000    0.993    0.725
#>     ITEM5             1.084    0.213    5.076    0.000    0.980    0.699
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1            -0.055    0.140   -0.394    0.693   -0.055   -0.040
#>    .ITEM2            -0.046    0.153   -0.297    0.766   -0.046   -0.030
#>    .ITEM3            -0.182    0.149   -1.221    0.222   -0.182   -0.124
#>    .ITEM4            -0.244    0.139   -1.755    0.079   -0.244   -0.178
#>    .ITEM5            -0.261    0.143   -1.831    0.067   -0.261   -0.186
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1             1.078    0.197    5.459    0.000    1.078    0.568
#>    .ITEM2             1.407    0.245    5.740    0.000    1.407    0.623
#>    .ITEM3             1.255    0.223    5.622    0.000    1.255    0.584
#>    .ITEM4             0.890    0.180    4.940    0.000    0.890    0.474
#>    .ITEM5             1.004    0.195    5.139    0.000    1.004    0.511
#>     LATENT            0.818    0.258    3.170    0.002    1.000    1.000
#> 
#> R-Square:
#>                    Estimate
#>     ITEM1             0.432
#>     ITEM2             0.377
#>     ITEM3             0.416
#>     ITEM4             0.526
#>     ITEM5             0.489
#> 
#> [1] "####################################################################################################"
#> [1] "R_SQUARED"
#> [1] "####################################################################################################"
#>       r_squared
#> ITEM1    0.4316
#> ITEM2    0.3774
#> ITEM3    0.4159
#> ITEM4    0.5256
#> ITEM5    0.4891
#> [1] "####################################################################################################"
#> [1] "FIT INDICES"
#> [1] "####################################################################################################"
#>                                     fit
#> npar                           15.00000
#> fmin                            0.01258
#> chisq                           2.51627
#> df                              5.00000
#> pvalue                          0.77404
#> baseline.chisq                123.27742
#> baseline.df                    10.00000
#> baseline.pvalue                 0.00000
#> cfi                             1.00000
#> tli                             1.04385
#> cfi.robust                      1.00000
#> tli.robust                      1.04294
#> nnfi                            1.04385
#> rfi                             0.95918
#> nfi                             0.97959
#> pnfi                            0.48979
#> ifi                             1.02100
#> rni                             1.02193
#> nnfi.robust                     1.04294
#> rni.robust                      1.02147
#> logl                         -778.76617
#> unrestricted.logl            -777.50803
#> aic                          1587.53234
#> bic                          1626.60989
#> ntotal                        100.00000
#> bic2                         1579.23612
#> rmsea                           0.00000
#> rmsea.ci.lower                  0.00000
#> rmsea.ci.upper                  0.09338
#> rmsea.ci.level                  0.90000
#> rmsea.pvalue                    0.85211
#> rmsea.close.h0                  0.05000
#> rmsea.notclose.pvalue           0.07526
#> rmsea.notclose.h0               0.08000
#> rmsea.robust                    0.00000
#> rmsea.ci.lower.robust           0.00000
#> rmsea.ci.upper.robust           0.10029
#> rmsea.pvalue.robust             0.83956
#> rmsea.notclose.pvalue.robust    0.08842
#> rmr                             0.04319
#> rmr_nomean                      0.04986
#> srmr                            0.02129
#> srmr_bentler                    0.02129
#> srmr_bentler_nomean             0.02456
#> crmr                            0.02450
#> crmr_nomean                     0.02998
#> srmr_mplus                      0.02125
#> srmr_mplus_nomean               0.02452
#> gfi                             1.00000
#> gfi.ci.lower                    0.98286
#> gfi.ci.upper                    1.00000
#> gfi.ci.level                    0.90000
#> gfi.robust                      1.00000
#> gfi.ci.lower.robust             0.98028
#> gfi.ci.upper.robust             1.00000
#> cn_05                         440.95642
#> cn_01                         600.54870
#> gfi_lisrel                      0.98262
#> agfi_lisrel                     0.93049
#> pgfi                            0.24566
#> mfi                             1.01250
#> ecvi                            0.32516
#> [1] "####################################################################################################"
#> [1] "PARAMETERS"
#> [1] "####################################################################################################"
#>       lhs op    rhs exo      est     se       z         pvalue ci.lower ci.upper   std.lv  std.all
#> 1  LATENT =~  ITEM1   0  1.00000 0.0000      NA             NA   1.0000  1.00000  0.90459  0.65696
#> 2  LATENT =~  ITEM2   0  1.02080 0.2153  4.7417 0.000002119027   0.5989  1.44274  0.92341  0.61434
#> 3  LATENT =~  ITEM3   0  1.04522 0.2099  4.9796 0.000000637158   0.6338  1.45662  0.94550  0.64492
#> 4  LATENT =~  ITEM4   0  1.09748 0.2079  5.2790 0.000000129913   0.6900  1.50495  0.99277  0.72495
#> 5  LATENT =~  ITEM5   0  1.08364 0.2135  5.0761 0.000000385257   0.6652  1.50205  0.98025  0.69933
#> 6   ITEM1 ~~  ITEM1   0  1.07769 0.1974  5.4592 0.000000047834   0.6908  1.46461  1.07769  0.56841
#> 7   ITEM2 ~~  ITEM2   0  1.40660 0.2450  5.7404 0.000000009448   0.9263  1.88686  1.40660  0.62259
#> 8   ITEM3 ~~  ITEM3   0  1.25539 0.2233  5.6217 0.000000018906   0.8177  1.69308  1.25539  0.58408
#> 9   ITEM4 ~~  ITEM4   0  0.88975 0.1801  4.9396 0.000000782962   0.5367  1.24279  0.88975  0.47445
#> 10  ITEM5 ~~  ITEM5   0  1.00387 0.1953  5.1391 0.000000276066   0.6210  1.38673  1.00387  0.51094
#> 11 LATENT ~~ LATENT   0  0.81829 0.2581  3.1703 0.001522776030   0.3124  1.32417  1.00000  1.00000
#> 12  ITEM1 ~1          0 -0.05527 0.1402 -0.3943 0.693368377850  -0.3300  0.21947 -0.05527 -0.04014
#> 13  ITEM2 ~1          0 -0.04559 0.1532 -0.2975 0.766092428621  -0.3459  0.25476 -0.04559 -0.03033
#> 14  ITEM3 ~1          0 -0.18227 0.1492 -1.2214 0.221940261910  -0.4748  0.11022 -0.18227 -0.12433
#> 15  ITEM4 ~1          0 -0.24423 0.1392 -1.7545 0.079338519742  -0.5170  0.02859 -0.24423 -0.17834
#> 16  ITEM5 ~1          0 -0.26109 0.1426 -1.8308 0.067135503599  -0.5406  0.01843 -0.26109 -0.18627
#> 17 LATENT ~1          0  0.00000 0.0000      NA             NA   0.0000  0.00000  0.00000  0.00000
#> 18  ITEM1 r2  ITEM1   0  0.43159     NA      NA             NA       NA       NA       NA       NA
#> 19  ITEM2 r2  ITEM2   0  0.37741     NA      NA             NA       NA       NA       NA       NA
#> 20  ITEM3 r2  ITEM3   0  0.41592     NA      NA             NA       NA       NA       NA       NA
#> 21  ITEM4 r2  ITEM4   0  0.52555     NA      NA             NA       NA       NA       NA       NA
#> 22  ITEM5 r2  ITEM5   0  0.48906     NA      NA             NA       NA       NA       NA       NA
#> [1] "####################################################################################################"
#> [1] "UNSTANDARDIZED PARAMETERS"
#> [1] "####################################################################################################"
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  1.021
#> ITEM3  1.045
#> ITEM4  1.097
#> ITEM5  1.084
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 1.078                        
#> ITEM2 0.000 1.407                  
#> ITEM3 0.000 0.000 1.255            
#> ITEM4 0.000 0.000 0.000 0.890      
#> ITEM5 0.000 0.000 0.000 0.000 1.004
#> 
#> $psi
#>        LATENT
#> LATENT  0.818
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.055
#> ITEM2 -0.046
#> ITEM3 -0.182
#> ITEM4 -0.244
#> ITEM5 -0.261
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> [1] "####################################################################################################"
#> [1] "STANDARDIZED PARAMETERS"
#> [1] "####################################################################################################"
#> $lambda
#>       LATENT
#> ITEM1  0.657
#> ITEM2  0.614
#> ITEM3  0.645
#> ITEM4  0.725
#> ITEM5  0.699
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.568                        
#> ITEM2 0.000 0.623                  
#> ITEM3 0.000 0.000 0.584            
#> ITEM4 0.000 0.000 0.000 0.474      
#> ITEM5 0.000 0.000 0.000 0.000 0.511
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.040
#> ITEM2 -0.030
#> ITEM3 -0.124
#> ITEM4 -0.178
#> ITEM5 -0.186
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> [1] "####################################################################################################"
#> [1] "SAMPLE COVARIANCE"
#> [1] "####################################################################################################"
#>       X1     X2     X3     X4     X5
#> 1 1.8837 0.8843 0.7668 0.8772 0.7431
#> 2 0.8843 2.2061 0.7537 0.7714 0.8021
#> 3 0.7668 0.7537 2.1320 0.9960 0.8395
#> 4 0.8772 0.7714 0.9960 1.8931 1.0420
#> 5 0.7431 0.8021 0.8395 1.0420 1.9344
#> [1] "####################################################################################################"
#> [1] "CALL"
#> [1] "####################################################################################################"
#> [1] "lavaan::lavaan(model=model,data=df,missing=\"ML\",model.type=\"cfa\"," "cmd=\"cfa\",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,"  
#> [3] "auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,"                "auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)"          
#> [1] "lavaan::lavaan(model=model,data=df,missing=\"ML\",model.type=\"cfa\"," "cmd=\"cfa\",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,"  
#> [3] "auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,"                "auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)"          
#> $r_squared
#>       r_squared
#> ITEM1    0.4316
#> ITEM2    0.3774
#> ITEM3    0.4159
#> ITEM4    0.5256
#> ITEM5    0.4891
#> 
#> $fit_indices
#>                                     fit
#> npar                           15.00000
#> fmin                            0.01258
#> chisq                           2.51627
#> df                              5.00000
#> pvalue                          0.77404
#> baseline.chisq                123.27742
#> baseline.df                    10.00000
#> baseline.pvalue                 0.00000
#> cfi                             1.00000
#> tli                             1.04385
#> cfi.robust                      1.00000
#> tli.robust                      1.04294
#> nnfi                            1.04385
#> rfi                             0.95918
#> nfi                             0.97959
#> pnfi                            0.48979
#> ifi                             1.02100
#> rni                             1.02193
#> nnfi.robust                     1.04294
#> rni.robust                      1.02147
#> logl                         -778.76617
#> unrestricted.logl            -777.50803
#> aic                          1587.53234
#> bic                          1626.60989
#> ntotal                        100.00000
#> bic2                         1579.23612
#> rmsea                           0.00000
#> rmsea.ci.lower                  0.00000
#> rmsea.ci.upper                  0.09338
#> rmsea.ci.level                  0.90000
#> rmsea.pvalue                    0.85211
#> rmsea.close.h0                  0.05000
#> rmsea.notclose.pvalue           0.07526
#> rmsea.notclose.h0               0.08000
#> rmsea.robust                    0.00000
#> rmsea.ci.lower.robust           0.00000
#> rmsea.ci.upper.robust           0.10029
#> rmsea.pvalue.robust             0.83956
#> rmsea.notclose.pvalue.robust    0.08842
#> rmr                             0.04319
#> rmr_nomean                      0.04986
#> srmr                            0.02129
#> srmr_bentler                    0.02129
#> srmr_bentler_nomean             0.02456
#> crmr                            0.02450
#> crmr_nomean                     0.02998
#> srmr_mplus                      0.02125
#> srmr_mplus_nomean               0.02452
#> gfi                             1.00000
#> gfi.ci.lower                    0.98286
#> gfi.ci.upper                    1.00000
#> gfi.ci.level                    0.90000
#> gfi.robust                      1.00000
#> gfi.ci.lower.robust             0.98028
#> gfi.ci.upper.robust             1.00000
#> cn_05                         440.95642
#> cn_01                         600.54870
#> gfi_lisrel                      0.98262
#> agfi_lisrel                     0.93049
#> pgfi                            0.24566
#> mfi                             1.01250
#> ecvi                            0.32516
#> 
#> $parameters
#>       lhs op    rhs exo      est     se       z         pvalue ci.lower ci.upper   std.lv  std.all
#> 1  LATENT =~  ITEM1   0  1.00000 0.0000      NA             NA   1.0000  1.00000  0.90459  0.65696
#> 2  LATENT =~  ITEM2   0  1.02080 0.2153  4.7417 0.000002119027   0.5989  1.44274  0.92341  0.61434
#> 3  LATENT =~  ITEM3   0  1.04522 0.2099  4.9796 0.000000637158   0.6338  1.45662  0.94550  0.64492
#> 4  LATENT =~  ITEM4   0  1.09748 0.2079  5.2790 0.000000129913   0.6900  1.50495  0.99277  0.72495
#> 5  LATENT =~  ITEM5   0  1.08364 0.2135  5.0761 0.000000385257   0.6652  1.50205  0.98025  0.69933
#> 6   ITEM1 ~~  ITEM1   0  1.07769 0.1974  5.4592 0.000000047834   0.6908  1.46461  1.07769  0.56841
#> 7   ITEM2 ~~  ITEM2   0  1.40660 0.2450  5.7404 0.000000009448   0.9263  1.88686  1.40660  0.62259
#> 8   ITEM3 ~~  ITEM3   0  1.25539 0.2233  5.6217 0.000000018906   0.8177  1.69308  1.25539  0.58408
#> 9   ITEM4 ~~  ITEM4   0  0.88975 0.1801  4.9396 0.000000782962   0.5367  1.24279  0.88975  0.47445
#> 10  ITEM5 ~~  ITEM5   0  1.00387 0.1953  5.1391 0.000000276066   0.6210  1.38673  1.00387  0.51094
#> 11 LATENT ~~ LATENT   0  0.81829 0.2581  3.1703 0.001522776030   0.3124  1.32417  1.00000  1.00000
#> 12  ITEM1 ~1          0 -0.05527 0.1402 -0.3943 0.693368377850  -0.3300  0.21947 -0.05527 -0.04014
#> 13  ITEM2 ~1          0 -0.04559 0.1532 -0.2975 0.766092428621  -0.3459  0.25476 -0.04559 -0.03033
#> 14  ITEM3 ~1          0 -0.18227 0.1492 -1.2214 0.221940261910  -0.4748  0.11022 -0.18227 -0.12433
#> 15  ITEM4 ~1          0 -0.24423 0.1392 -1.7545 0.079338519742  -0.5170  0.02859 -0.24423 -0.17834
#> 16  ITEM5 ~1          0 -0.26109 0.1426 -1.8308 0.067135503599  -0.5406  0.01843 -0.26109 -0.18627
#> 17 LATENT ~1          0  0.00000 0.0000      NA             NA   0.0000  0.00000  0.00000  0.00000
#> 18  ITEM1 r2  ITEM1   0  0.43159     NA      NA             NA       NA       NA       NA       NA
#> 19  ITEM2 r2  ITEM2   0  0.37741     NA      NA             NA       NA       NA       NA       NA
#> 20  ITEM3 r2  ITEM3   0  0.41592     NA      NA             NA       NA       NA       NA       NA
#> 21  ITEM4 r2  ITEM4   0  0.52555     NA      NA             NA       NA       NA       NA       NA
#> 22  ITEM5 r2  ITEM5   0  0.48906     NA      NA             NA       NA       NA       NA       NA
#> 
#> $modification_indices
#>       lhs op    rhs                   mi            epc        sepc.all delta    ncp   power decision
#> 18  ITEM1 ~~  ITEM2 1.575110839935802476  0.21251846477  0.172609378822   0.1 0.3488 0.09081      (i)
#> 23  ITEM2 ~~  ITEM4 1.008753758987093629 -0.17067529477 -0.152563912262   0.1 0.3463 0.09052      (i)
#> 27  ITEM4 ~~  ITEM5 0.842221227549647122  0.15216652522  0.161007600078   0.1 0.3637 0.09260      (i)
#> 21  ITEM1 ~~  ITEM5 0.541638274408710041 -0.11794058521 -0.113390611105   0.1 0.3894 0.09567      (i)
#> 25  ITEM3 ~~  ITEM4 0.325186402585709800  0.09572643860  0.090574888446   0.1 0.3549 0.09154      (i)
#> 20  ITEM1 ~~  ITEM4 0.311399865863062286 -0.08858882108 -0.090468471125   0.1 0.3968 0.09655      (i)
#> 26  ITEM3 ~~  ITEM5 0.189989559345094344 -0.07386167342 -0.065794643424   0.1 0.3483 0.09075      (i)
#> 22  ITEM2 ~~  ITEM3 0.144596528094055321 -0.06851017202 -0.051556135328   0.1 0.3081 0.08597      (i)
#> 24  ITEM2 ~~  ITEM5 0.041533539181603039  0.03513801191  0.029570170577   0.1 0.3364 0.08934      (i)
#> 19  ITEM1 ~~  ITEM3 0.040331467084170618  0.03323201387  0.028570584861   0.1 0.3652 0.09278      (i)
#> 3  LATENT =~  ITEM3 0.000000000018327700 -0.00000064481 -0.000000397860   0.1 0.4408 0.10183      (i)
#> 10  ITEM5 ~~  ITEM5 0.000000000009064950  0.00000054287  0.510938157360   0.1 0.3076 0.08592      (i)
#> 7   ITEM2 ~~  ITEM2 0.000000000007915495  0.00000065436  0.622586353975   0.1 0.1849 0.07143      (i)
#> 4  LATENT =~  ITEM4 0.000000000007501251  0.00000035895  0.000000237108   0.1 0.5822 0.11890      (i)
#> 14  ITEM3 ~1        0.000000000003059248  0.00000021741  0.000000148293   0.1 0.6472 0.12680      (i)
#> 12  ITEM1 ~1        0.000000000002893124  0.00000019704  0.000000143101   0.1 0.7452 0.13876      (i)
#> 13  ITEM2 ~1        0.000000000002649062  0.00000021143  0.000000140662   0.1 0.5926 0.12016      (i)
#> 15  ITEM4 ~1        0.000000000002066507  0.00000015779  0.000000115226   0.1 0.8300 0.14915      (i)
#> 16  ITEM5 ~1        0.000000000001839429  0.00000015513  0.000000110671   0.1 0.7644 0.14111      (i)
#> 5  LATENT =~  ITEM5 0.000000000001179528  0.00000014918  0.000000096271   0.1 0.5300 0.11258      (i)
#> 8   ITEM3 ~~  ITEM3 0.000000000000966081  0.00000020928  0.584076895647   0.1 0.2206 0.07563      (i)
#> 6   ITEM1 ~~  ITEM1 0.000000000000485507  0.00000012885  0.568409936084   0.1 0.2924 0.08412      (i)
#> 11 LATENT ~~ LATENT 0.000000000000288934  0.00000007819  1.000000000000   0.1 0.4726 0.10565      (i)
#> 9   ITEM4 ~~  ITEM4 0.000000000000042977  0.00000003442  0.474446646181   0.1 0.3627 0.09248      (i)
#> 2  LATENT =~  ITEM2 0.000000000000004385 -0.00000001046 -0.000000006295   0.1 0.4008 0.09703      (i)
#> 
#> $sample_covariance
#>       X1     X2     X3     X4     X5
#> 1 1.8837 0.8843 0.7668 0.8772 0.7431
#> 2 0.8843 2.2061 0.7537 0.7714 0.8021
#> 3 0.7668 0.7537 2.1320 0.9960 0.8395
#> 4 0.8772 0.7714 0.9960 1.8931 1.0420
#> 5 0.7431 0.8021 0.8395 1.0420 1.9344
#> 
#> $unstandardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  1.021
#> ITEM3  1.045
#> ITEM4  1.097
#> ITEM5  1.084
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 1.078                        
#> ITEM2 0.000 1.407                  
#> ITEM3 0.000 0.000 1.255            
#> ITEM4 0.000 0.000 0.000 0.890      
#> ITEM5 0.000 0.000 0.000 0.000 1.004
#> 
#> $psi
#>        LATENT
#> LATENT  0.818
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.055
#> ITEM2 -0.046
#> ITEM3 -0.182
#> ITEM4 -0.244
#> ITEM5 -0.261
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> 
#> $standardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  0.657
#> ITEM2  0.614
#> ITEM3  0.645
#> ITEM4  0.725
#> ITEM5  0.699
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.568                        
#> ITEM2 0.000 0.623                  
#> ITEM3 0.000 0.000 0.584            
#> ITEM4 0.000 0.000 0.000 0.474      
#> ITEM5 0.000 0.000 0.000 0.000 0.511
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1 -0.040
#> ITEM2 -0.030
#> ITEM3 -0.124
#> ITEM4 -0.178
#> ITEM5 -0.186
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
#>           X1       X2        X3       X4       X5    LATENT
#> 1    2.30399 -0.62185  0.216067 -0.31233  0.32447  0.421786
#> 2    1.29998  0.96930  2.011199 -0.97523  2.31276  0.906520
#> 3    1.54746  1.64206 -0.405864  1.66905  0.51747  0.911163
#> 4   -1.33798 -1.78760 -0.115288  0.09109 -1.09291 -0.458750
#> 5    1.75337  1.51868 -0.473187  2.38263  0.02131  0.973231
#> 6    1.22093  3.24302  1.301723  0.67116  0.37175  1.053164
#> 7   -0.86883 -1.66117 -0.431770  0.77050  0.04665 -0.087721
#> 8    0.29469  2.30208        NA  0.20169       NA  0.607494
#> 9   -1.06430 -0.70209        NA -1.08696 -2.78961 -0.957039
#> 10   0.61144 -0.54066 -0.024551 -0.99525  0.54694  0.053552
#> 11  -0.21492 -2.17093  0.091133 -1.91821 -1.07128 -0.700503
#> 12   1.77965 -2.32520 -1.982789  0.85984  0.23657  0.071320
#> 13   1.11609  0.12359 -0.761045 -0.39851  1.06670  0.313599
#> 14  -2.06728 -1.55800 -0.605755 -1.52283 -1.29870 -0.957012
#> 15  -0.01463 -0.51942  0.158947 -2.05527 -2.03164 -0.663090
#> 16   0.54033 -0.99698  0.400467 -0.07499 -0.37012  0.069766
#> 17        NA  0.90204 -0.430920  1.41694  1.36464  0.799876
#> 18  -0.18604  0.35370  1.204072 -0.24374  1.67332  0.542829
#> 19  -0.43218 -1.08850 -1.792360  0.30435  1.60227  0.038337
#> 20  -0.39489  0.59556 -0.598771  0.77373  1.96285  0.550508
#> 21   1.21367 -0.69614  0.316106  0.50203  0.57693  0.468673
#> 22   0.03742  2.21838  0.997200  0.65122  1.00256  0.824190
#> 23   1.04911 -0.70233 -0.946168  0.12230 -0.89533 -0.050982
#> 24  -1.60819  0.94178  2.682028 -0.21294 -0.23116  0.275483
#> 25  -0.87084 -1.04233 -0.370516 -1.83158 -2.82695 -1.012742
#> 26   0.20004  3.46702 -0.984932       NA  0.00383  0.487505
#> 27   1.42072  1.52240 -0.488319 -0.38455  1.29837  0.598776
#> 28        NA -1.77349 -0.644034 -1.19601 -1.03875 -0.681759
#> 29  -0.90230  1.42958 -1.967338 -2.12383 -0.40862 -0.585459
#> 30  -1.54375 -0.37187 -3.327904 -0.79604 -1.01035 -0.911199
#> 31   0.48613 -1.14955 -1.396045 -0.14957 -1.52959 -0.407657
#> 32  -1.23421  0.49271  0.591671       NA  1.18701  0.305074
#> 33  -0.79139 -1.51556 -2.041046 -0.09371 -0.05984 -0.460584
#> 34   0.08694 -0.49714  0.995327       NA  0.40603  0.305191
#> 35  -1.26940       NA -1.744933 -1.08906 -1.83165 -0.931709
#> 36   0.45113 -2.11489 -1.389769 -2.11903 -2.83588 -1.134395
#> 37  -0.63640 -2.72914 -2.250908 -0.44458 -2.34208 -1.066523
#> 38  -1.15665  2.06262 -0.099876  0.04398 -0.05000  0.184574
#> 39  -0.20561  1.85600  0.691747  0.49146 -0.30853  0.449432
#> 40   2.01598       NA  2.924245  3.09645  2.48670  2.091600
#> 41        NA -2.60759 -0.893688 -0.85431  0.13247 -0.518860
#> 42  -0.44315 -0.96563 -0.050797 -0.09444  0.60148  0.031461
#> 43  -0.92029  0.12661 -2.271007  0.68890 -1.28214 -0.376791
#> 44  -1.08094 -0.96480  1.551459  0.55348  1.06273  0.356053
#> 45   2.36147       NA  0.968872       NA       NA  1.059839
#> 46   2.43016  2.20717  0.169111  1.74478  1.22211  1.318824
#> 47  -0.83090 -1.06544 -2.420426 -0.81966 -1.14616 -0.793778
#> 48   0.53288  2.01929  0.134751 -1.10161 -0.69292  0.124837
#> 49   2.61760  0.89258        NA  1.21112  0.28902  1.025070
#> 50   2.21327  1.81254  3.129310  1.31225  0.48525  1.421942
#> 51  -0.57086 -0.04874  0.544531 -0.74229 -2.27465 -0.423818
#> 52   1.33569  0.74093  0.023338 -1.17709 -1.34805 -0.046355
#> 53   1.76295  1.07623  1.000587  0.20721  1.18600  0.891882
#> 54  -0.80496 -0.41791 -1.461017 -1.64332 -0.12994 -0.575176
#> 55  -1.09332 -1.43166  0.927129  0.74882  0.61645  0.179285
#> 56   0.08987 -0.03144  2.337408  3.26843  1.05759  1.272818
#> 57  -1.74412  0.85047  0.290784 -0.52879 -0.64490 -0.204991
#> 58   1.48115  4.55424  0.976593  1.23916  1.37426  1.483611
#> 59        NA  0.24969 -3.102385 -0.98529 -2.44602 -1.024831
#> 60  -2.87816 -3.02366 -0.272409  1.76127 -1.27785 -0.553670
#> 61  -0.33996 -0.02889  0.338793  1.71212 -1.44486  0.209570
#> 62   0.07471 -1.15358 -0.478080  0.45897  0.27220  0.081672
#> 63  -1.79804 -1.48121 -2.141252 -2.01796       NA -1.266508
#> 64  -0.47264 -0.16148  0.002004 -0.96094 -0.69336 -0.265514
#> 65  -2.47849 -0.95017 -0.017004 -0.71461 -1.11118 -0.678693
#> 66  -2.12193  1.59803 -1.253555 -1.59056 -0.29143 -0.526727
#> 67  -1.00562 -3.23822  0.318781 -2.09477 -1.75172 -1.061868
#> 68   1.94159  0.74422 -0.194278 -0.76626  0.31129  0.380308
#> 69   2.54026  0.96659  1.006594  2.49430  0.74264  1.367525
#> 70  -0.42170 -0.12149 -0.598312 -1.33657 -0.15924 -0.314888
#> 71  -1.69897 -0.46369 -2.097059  0.49202 -0.64706 -0.466444
#> 72  -0.60809 -1.35512 -3.250221 -3.90634 -0.40506 -1.382798
#> 73   1.02621  1.48728  1.390372 -0.48988       NA  0.610454
#> 74  -3.92709 -1.02763        NA -2.64528 -0.71140 -1.431980
#> 75   0.19716  1.63346 -0.021705  1.30842  1.08762  0.788842
#> 76   1.05244 -0.73197  1.365527  0.15945 -0.26071  0.368644
#> 77   0.44851  0.07589  0.177412  1.06074  0.36246  0.499296
#> 78   1.30006  0.32317  2.824783  0.07513  2.47070  1.172991
#> 79  -1.87677 -1.23941 -1.429641 -2.07009 -0.26787 -0.931593
#> 80   2.50274  1.37462  2.440114  1.01745       NA  1.396723
#> 81   0.44401  1.07258  1.166165 -0.93632 -0.68142  0.173451
#> 82   0.20457       NA -0.128311 -1.23910 -0.81212 -0.277058
#> 83  -0.66681 -1.97393 -2.534804 -3.96819 -2.40793 -1.724310
#> 84   1.07750  0.13558  0.550475 -1.23221 -2.28569 -0.256420
#> 85  -2.16198 -2.55603  0.177681 -2.41314 -1.62197 -1.212721
#> 86        NA -1.61043 -2.674753 -1.70657 -2.47511 -1.382329
#> 87   0.28225 -0.54373 -0.267156 -0.33374  1.80839  0.318961
#> 88  -0.18545  0.12677  2.344283  1.24701 -2.25952  0.284834
#> 89  -1.90286 -0.09759 -2.155424 -1.89986 -3.91431 -1.492664
#> 90  -0.70770 -1.24758 -2.027954 -1.50733 -1.06171 -0.865088
#> 91   0.70977  0.65693  1.588627  1.68132  2.99200  1.365401
#> 92   1.93760  1.53826        NA  0.40550 -0.85587  0.583279
#> 93  -0.74207 -1.29954 -0.854198 -0.32681  0.19845 -0.272506
#> 94  -0.82408  1.44230 -1.870106 -0.43899  0.95839  0.005935
#> 95   1.61869       NA  0.358794  1.39358  2.19789  1.204676
#> 96  -2.06952  0.01488 -0.876805 -0.99505  0.02061 -0.481415
#> 97  -0.54772 -0.49879  2.552413 -0.71153 -0.87515  0.040060
#> 98   0.36456 -0.89475 -1.953051 -1.94059 -2.02049 -0.905824
#> 99   0.41756  0.07920  0.624322       NA -2.24426 -0.190617
#> 100 -1.11307 -1.18659 -0.428160  0.56358 -1.34684 -0.348468
#> 
#> $call
#>                                                                call
#> 1 lavaan::lavaan(model=model,data=df,missing="ML",model.type="cfa",
#> 2 cmd="cfa",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,
#> 3            auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,
#> 4       auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)
#> 
```
