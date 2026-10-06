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






#> [1] "####################################################################################################"
#> [1] "SUMMARY"
#> [1] "####################################################################################################"
#> lavaan 0.7-2 ended normally after 23 iterations
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
#>   Test statistic                                 1.444
#>   Degrees of freedom                                 5
#>   P-value (Chi-square)                           0.919
#> 
#> Model Test Baseline Model:
#> 
#>   Test statistic                               241.776
#>   Degrees of freedom                                10
#>   P-value                                        0.000
#> 
#> User Model versus Baseline Model:
#> 
#>   Comparative Fit Index (CFI)                    1.000
#>   Tucker-Lewis Index (TLI)                       1.031
#>                                                       
#>   Robust Comparative Fit Index (CFI)             1.000
#>   Robust Tucker-Lewis Index (TLI)                1.033
#> 
#> Loglikelihood and Information Criteria:
#> 
#>   Loglikelihood user model (H0)               -752.005
#>   Loglikelihood unrestricted model (H1)       -751.283
#>                                                       
#>   Akaike (AIC)                                1534.011
#>   Bayesian (BIC)                              1573.088
#>   Sample-size adjusted Bayesian (SABIC)       1525.715
#> 
#> Root Mean Square Error of Approximation:
#> 
#>   RMSEA                                          0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.049
#>   P-value H_0: RMSEA <= 0.050                    0.951
#>   P-value H_0: RMSEA >= 0.080                    0.022
#>                                                       
#>   Robust RMSEA                                   0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.052
#>   P-value H_0: Robust RMSEA <= 0.050             0.948
#>   P-value H_0: Robust RMSEA >= 0.080             0.026
#> 
#> Standardized Root Mean Square Residual:
#> 
#>   SRMR                                           0.011
#> 
#> Goodness of Fit Index:
#> 
#>   Goodness of Fit Index (GFI)                    1.000
#>   90 Percent confidence interval - lower         0.995
#>   90 Percent confidence interval - upper         1.000
#>                                                       
#>   Robust GFI                                     1.000
#>   90 Percent confidence interval - lower         0.995
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
#>     ITEM1             1.000                               1.140    0.795
#>     ITEM2             0.979    0.124    7.910    0.000    1.116    0.774
#>     ITEM3             1.050    0.131    7.993    0.000    1.197    0.777
#>     ITEM4             1.046    0.135    7.730    0.000    1.193    0.775
#>     ITEM5             1.136    0.140    8.133    0.000    1.296    0.796
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1             0.078    0.145    0.540    0.589    0.078    0.055
#>    .ITEM2            -0.194    0.146   -1.327    0.185   -0.194   -0.134
#>    .ITEM3            -0.179    0.156   -1.145    0.252   -0.179   -0.116
#>    .ITEM4            -0.034    0.156   -0.220    0.826   -0.034   -0.022
#>    .ITEM5             0.015    0.165    0.093    0.926    0.015    0.009
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1             0.756    0.143    5.271    0.000    0.756    0.368
#>    .ITEM2             0.832    0.151    5.528    0.000    0.832    0.401
#>    .ITEM3             0.939    0.172    5.470    0.000    0.939    0.396
#>    .ITEM4             0.943    0.173    5.451    0.000    0.943    0.399
#>    .ITEM5             0.969    0.185    5.245    0.000    0.969    0.366
#>     LATENT            1.300    0.290    4.481    0.000    1.000    1.000
#> 
#> R-Square:
#>                    Estimate
#>     ITEM1             0.632
#>     ITEM2             0.599
#>     ITEM3             0.604
#>     ITEM4             0.601
#>     ITEM5             0.634
#> 
#> [1] "####################################################################################################"
#> [1] "R_SQUARED"
#> [1] "####################################################################################################"
#>       r_squared
#> ITEM1    0.6323
#> ITEM2    0.5995
#> ITEM3    0.6042
#> ITEM4    0.6013
#> ITEM5    0.6340
#> [1] "####################################################################################################"
#> [1] "FIT INDICES"
#> [1] "####################################################################################################"
#>                                     fit
#> npar                           15.00000
#> fmin                            0.00722
#> chisq                           1.44405
#> df                              5.00000
#> pvalue                          0.91943
#> baseline.chisq                241.77594
#> baseline.df                    10.00000
#> baseline.pvalue                 0.00000
#> cfi                             1.00000
#> tli                             1.03068
#> cfi.robust                      1.00000
#> tli.robust                      1.03312
#> nnfi                            1.03068
#> rfi                             0.98805
#> nfi                             0.99403
#> pnfi                            0.49701
#> ifi                             1.01502
#> rni                             1.01534
#> nnfi.robust                     1.03312
#> rni.robust                      1.01656
#> logl                         -752.00543
#> unrestricted.logl            -751.28340
#> aic                          1534.01086
#> bic                          1573.08841
#> ntotal                        100.00000
#> bic2                         1525.71464
#> rmsea                           0.00000
#> rmsea.ci.lower                  0.00000
#> rmsea.ci.upper                  0.04866
#> rmsea.ci.level                  0.90000
#> rmsea.pvalue                    0.95132
#> rmsea.close.h0                  0.05000
#> rmsea.notclose.pvalue           0.02206
#> rmsea.notclose.h0               0.08000
#> rmsea.robust                    0.00000
#> rmsea.ci.lower.robust           0.00000
#> rmsea.ci.upper.robust           0.05227
#> rmsea.pvalue.robust             0.94792
#> rmsea.notclose.pvalue.robust    0.02620
#> rmr                             0.02589
#> rmr_nomean                      0.02988
#> srmr                            0.01120
#> srmr_bentler                    0.01120
#> srmr_bentler_nomean             0.01291
#> crmr                            0.01284
#> crmr_nomean                     0.01570
#> srmr_mplus                      0.01115
#> srmr_mplus_nomean               0.01285
#> gfi                             1.00000
#> gfi.ci.lower                    0.99529
#> gfi.ci.upper                    1.00000
#> gfi.ci.level                    0.90000
#> gfi.robust                      1.00000
#> gfi.ci.lower.robust             0.99457
#> gfi.ci.upper.robust             1.00000
#> cn_05                         767.62724
#> cn_01                        1045.71794
#> gfi_lisrel                      0.98261
#> agfi_lisrel                     0.93043
#> pgfi                            0.24565
#> mfi                             1.01794
#> ecvi                            0.31444
#> [1] "####################################################################################################"
#> [1] "PARAMETERS"
#> [1] "####################################################################################################"
#>       lhs op    rhs exo      est     se       z                pvalue ci.lower ci.upper   std.lv   std.all
#> 1  LATENT =~  ITEM1   0  1.00000 0.0000      NA                    NA   1.0000  1.00000  1.14012  0.795174
#> 2  LATENT =~  ITEM2   0  0.97901 0.1238  7.9096 0.0000000000000026645   0.7364  1.22160  1.11619  0.774263
#> 3  LATENT =~  ITEM3   0  1.05004 0.1314  7.9926 0.0000000000000013323   0.7925  1.30753  1.19717  0.777273
#> 4  LATENT =~  ITEM4   0  1.04607 0.1353  7.7303 0.0000000000000106581   0.7808  1.31129  1.19265  0.775453
#> 5  LATENT =~  ITEM5   0  1.13646 0.1397  8.1329 0.0000000000000004441   0.8626  1.41034  1.29570  0.796234
#> 6   ITEM1 ~~  ITEM1   0  0.75591 0.1434  5.2710 0.0000001356631531557   0.4748  1.03699  0.75591  0.367699
#> 7   ITEM2 ~~  ITEM2   0  0.83237 0.1506  5.5276 0.0000000324550872843   0.5372  1.12751  0.83237  0.400516
#> 8   ITEM3 ~~  ITEM3   0  0.93905 0.1717  5.4695 0.0000000451253359124   0.6026  1.27556  0.93905  0.395847
#> 9   ITEM4 ~~  ITEM4   0  0.94304 0.1730  5.4514 0.0000000499656345188   0.6040  1.28210  0.94304  0.398673
#> 10  ITEM5 ~~  ITEM5   0  0.96922 0.1848  5.2453 0.0000001559956859243   0.6071  1.33138  0.96922  0.366011
#> 11 LATENT ~~ LATENT   0  1.29988 0.2901  4.4812 0.0000074222706858418   0.7313  1.86841  1.00000  1.000000
#> 12  ITEM1 ~1          0  0.07839 0.1451  0.5402 0.5890267286129460267  -0.2060  0.36278  0.07839  0.054672
#> 13  ITEM2 ~1          0 -0.19368 0.1460 -1.3266 0.1846250653790726393  -0.4798  0.09246 -0.19368 -0.134351
#> 14  ITEM3 ~1          0 -0.17870 0.1560 -1.1454 0.2520441596297475773  -0.4845  0.12709 -0.17870 -0.116023
#> 15  ITEM4 ~1          0 -0.03428 0.1558 -0.2201 0.8257840965289942048  -0.3396  0.27099 -0.03428 -0.022291
#> 16  ITEM5 ~1          0  0.01537 0.1647  0.0933 0.9256638379686097373  -0.3074  0.33814  0.01537  0.009442
#> 17 LATENT ~1          0  0.00000 0.0000      NA                    NA   0.0000  0.00000  0.00000  0.000000
#> 18  ITEM1 r2  ITEM1   0  0.63230     NA      NA                    NA       NA       NA       NA        NA
#> 19  ITEM2 r2  ITEM2   0  0.59948     NA      NA                    NA       NA       NA       NA        NA
#> 20  ITEM3 r2  ITEM3   0  0.60415     NA      NA                    NA       NA       NA       NA        NA
#> 21  ITEM4 r2  ITEM4   0  0.60133     NA      NA                    NA       NA       NA       NA        NA
#> 22  ITEM5 r2  ITEM5   0  0.63399     NA      NA                    NA       NA       NA       NA        NA
#> [1] "####################################################################################################"
#> [1] "UNSTANDARDIZED PARAMETERS"
#> [1] "####################################################################################################"
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  0.979
#> ITEM3  1.050
#> ITEM4  1.046
#> ITEM5  1.136
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.756                        
#> ITEM2 0.000 0.832                  
#> ITEM3 0.000 0.000 0.939            
#> ITEM4 0.000 0.000 0.000 0.943      
#> ITEM5 0.000 0.000 0.000 0.000 0.969
#> 
#> $psi
#>        LATENT
#> LATENT    1.3
#> 
#> $nu
#>       intrcp
#> ITEM1  0.078
#> ITEM2 -0.194
#> ITEM3 -0.179
#> ITEM4 -0.034
#> ITEM5  0.015
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
#> ITEM1  0.795
#> ITEM2  0.774
#> ITEM3  0.777
#> ITEM4  0.775
#> ITEM5  0.796
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.368                        
#> ITEM2 0.000 0.401                  
#> ITEM3 0.000 0.000 0.396            
#> ITEM4 0.000 0.000 0.000 0.399      
#> ITEM5 0.000 0.000 0.000 0.000 0.366
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1  0.055
#> ITEM2 -0.134
#> ITEM3 -0.116
#> ITEM4 -0.022
#> ITEM5  0.009
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> [1] "####################################################################################################"
#> [1] "SAMPLE COVARIANCE"
#> [1] "####################################################################################################"
#>      X1    X2    X3    X4    X5
#> 1 2.058 1.355 1.439 1.236 1.475
#> 2 1.355 2.122 1.389 1.413 1.472
#> 3 1.439 1.389 2.387 1.385 1.548
#> 4 1.236 1.413 1.385 2.339 1.638
#> 5 1.475 1.472 1.548 1.638 2.666
#> [1] "####################################################################################################"
#> [1] "CALL"
#> [1] "####################################################################################################"
#> [1] "lavaan::lavaan(model=model,data=df,missing=\"ML\",model.type=\"cfa\"," "cmd=\"cfa\",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,"  
#> [3] "auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,"                "auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)"          
#> [1] "lavaan::lavaan(model=model,data=df,missing=\"ML\",model.type=\"cfa\"," "cmd=\"cfa\",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,"  
#> [3] "auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,"                "auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)"          
#> $r_squared
#>       r_squared
#> ITEM1    0.6323
#> ITEM2    0.5995
#> ITEM3    0.6042
#> ITEM4    0.6013
#> ITEM5    0.6340
#> 
#> $fit_indices
#>                                     fit
#> npar                           15.00000
#> fmin                            0.00722
#> chisq                           1.44405
#> df                              5.00000
#> pvalue                          0.91943
#> baseline.chisq                241.77594
#> baseline.df                    10.00000
#> baseline.pvalue                 0.00000
#> cfi                             1.00000
#> tli                             1.03068
#> cfi.robust                      1.00000
#> tli.robust                      1.03312
#> nnfi                            1.03068
#> rfi                             0.98805
#> nfi                             0.99403
#> pnfi                            0.49701
#> ifi                             1.01502
#> rni                             1.01534
#> nnfi.robust                     1.03312
#> rni.robust                      1.01656
#> logl                         -752.00543
#> unrestricted.logl            -751.28340
#> aic                          1534.01086
#> bic                          1573.08841
#> ntotal                        100.00000
#> bic2                         1525.71464
#> rmsea                           0.00000
#> rmsea.ci.lower                  0.00000
#> rmsea.ci.upper                  0.04866
#> rmsea.ci.level                  0.90000
#> rmsea.pvalue                    0.95132
#> rmsea.close.h0                  0.05000
#> rmsea.notclose.pvalue           0.02206
#> rmsea.notclose.h0               0.08000
#> rmsea.robust                    0.00000
#> rmsea.ci.lower.robust           0.00000
#> rmsea.ci.upper.robust           0.05227
#> rmsea.pvalue.robust             0.94792
#> rmsea.notclose.pvalue.robust    0.02620
#> rmr                             0.02589
#> rmr_nomean                      0.02988
#> srmr                            0.01120
#> srmr_bentler                    0.01120
#> srmr_bentler_nomean             0.01291
#> crmr                            0.01284
#> crmr_nomean                     0.01570
#> srmr_mplus                      0.01115
#> srmr_mplus_nomean               0.01285
#> gfi                             1.00000
#> gfi.ci.lower                    0.99529
#> gfi.ci.upper                    1.00000
#> gfi.ci.level                    0.90000
#> gfi.robust                      1.00000
#> gfi.ci.lower.robust             0.99457
#> gfi.ci.upper.robust             1.00000
#> cn_05                         767.62724
#> cn_01                        1045.71794
#> gfi_lisrel                      0.98261
#> agfi_lisrel                     0.93043
#> pgfi                            0.24565
#> mfi                             1.01794
#> ecvi                            0.31444
#> 
#> $parameters
#>       lhs op    rhs exo      est     se       z                pvalue ci.lower ci.upper   std.lv   std.all
#> 1  LATENT =~  ITEM1   0  1.00000 0.0000      NA                    NA   1.0000  1.00000  1.14012  0.795174
#> 2  LATENT =~  ITEM2   0  0.97901 0.1238  7.9096 0.0000000000000026645   0.7364  1.22160  1.11619  0.774263
#> 3  LATENT =~  ITEM3   0  1.05004 0.1314  7.9926 0.0000000000000013323   0.7925  1.30753  1.19717  0.777273
#> 4  LATENT =~  ITEM4   0  1.04607 0.1353  7.7303 0.0000000000000106581   0.7808  1.31129  1.19265  0.775453
#> 5  LATENT =~  ITEM5   0  1.13646 0.1397  8.1329 0.0000000000000004441   0.8626  1.41034  1.29570  0.796234
#> 6   ITEM1 ~~  ITEM1   0  0.75591 0.1434  5.2710 0.0000001356631531557   0.4748  1.03699  0.75591  0.367699
#> 7   ITEM2 ~~  ITEM2   0  0.83237 0.1506  5.5276 0.0000000324550872843   0.5372  1.12751  0.83237  0.400516
#> 8   ITEM3 ~~  ITEM3   0  0.93905 0.1717  5.4695 0.0000000451253359124   0.6026  1.27556  0.93905  0.395847
#> 9   ITEM4 ~~  ITEM4   0  0.94304 0.1730  5.4514 0.0000000499656345188   0.6040  1.28210  0.94304  0.398673
#> 10  ITEM5 ~~  ITEM5   0  0.96922 0.1848  5.2453 0.0000001559956859243   0.6071  1.33138  0.96922  0.366011
#> 11 LATENT ~~ LATENT   0  1.29988 0.2901  4.4812 0.0000074222706858418   0.7313  1.86841  1.00000  1.000000
#> 12  ITEM1 ~1          0  0.07839 0.1451  0.5402 0.5890267286129460267  -0.2060  0.36278  0.07839  0.054672
#> 13  ITEM2 ~1          0 -0.19368 0.1460 -1.3266 0.1846250653790726393  -0.4798  0.09246 -0.19368 -0.134351
#> 14  ITEM3 ~1          0 -0.17870 0.1560 -1.1454 0.2520441596297475773  -0.4845  0.12709 -0.17870 -0.116023
#> 15  ITEM4 ~1          0 -0.03428 0.1558 -0.2201 0.8257840965289942048  -0.3396  0.27099 -0.03428 -0.022291
#> 16  ITEM5 ~1          0  0.01537 0.1647  0.0933 0.9256638379686097373  -0.3074  0.33814  0.01537  0.009442
#> 17 LATENT ~1          0  0.00000 0.0000      NA                    NA   0.0000  0.00000  0.00000  0.000000
#> 18  ITEM1 r2  ITEM1   0  0.63230     NA      NA                    NA       NA       NA       NA        NA
#> 19  ITEM2 r2  ITEM2   0  0.59948     NA      NA                    NA       NA       NA       NA        NA
#> 20  ITEM3 r2  ITEM3   0  0.60415     NA      NA                    NA       NA       NA       NA        NA
#> 21  ITEM4 r2  ITEM4   0  0.60133     NA      NA                    NA       NA       NA       NA        NA
#> 22  ITEM5 r2  ITEM5   0  0.63399     NA      NA                    NA       NA       NA       NA        NA
#> 
#> $modification_indices
#>       lhs op    rhs                    mi             epc         sepc.all delta    ncp   power decision
#> 19  ITEM1 ~~  ITEM3 0.8850843863677139156  0.120614969359  0.1431595228417   0.1 0.6084 0.12208      (i)
#> 20  ITEM1 ~~  ITEM4 0.8621350975754459300 -0.118898533595 -0.1408235448956   0.1 0.6098 0.12226      (i)
#> 27  ITEM4 ~~  ITEM5 0.5007694535984043016  0.102561459297  0.1072771631277   0.1 0.4761 0.10607      (i)
#> 26  ITEM3 ~~  ITEM5 0.3534826474864162793 -0.086396378499 -0.0905605151889   0.1 0.4736 0.10577      (i)
#> 23  ITEM2 ~~  ITEM4 0.1891744160005738862  0.056201512996  0.0634342945919   0.1 0.5989 0.12093      (i)
#> 25  ITEM3 ~~  ITEM4 0.0437988938423093041 -0.028866469735 -0.0306748800952   0.1 0.5256 0.11205      (i)
#> 24  ITEM2 ~~  ITEM5 0.0357712569065468805 -0.025735892891 -0.0286529600744   0.1 0.5401 0.11380      (i)
#> 22  ITEM2 ~~  ITEM3 0.0210885056149049746 -0.018748739344 -0.0212064726144   0.1 0.5999 0.12105      (i)
#> 18  ITEM1 ~~  ITEM2 0.0083338130951393953 -0.010959833585 -0.0138168772495   0.1 0.6938 0.13248      (i)
#> 21  ITEM1 ~~  ITEM5 0.0055219470870310362  0.010052883988  0.0117447449914   0.1 0.5464 0.11456      (i)
#> 10  ITEM5 ~~  ITEM5 0.0000000000014850667  0.000000214480  0.3660107192209   0.1 0.3228 0.08773      (i)
#> 9   ITEM4 ~~  ITEM4 0.0000000000012701092 -0.000000186982 -0.3986731781624   0.1 0.3633 0.09255      (i)
#> 6   ITEM1 ~~  ITEM1 0.0000000000002282273 -0.000000065508 -0.3676987588209   0.1 0.5318 0.11280      (i)
#> 8   ITEM3 ~~  ITEM3 0.0000000000001609214 -0.000000066448 -0.3958465008356   0.1 0.3645 0.09269      (i)
#> 7   ITEM2 ~~  ITEM2 0.0000000000001393916  0.000000054592  0.4005163428723   0.1 0.4677 0.10506      (i)
#> 4  LATENT =~  ITEM4 0.0000000000000674904  0.000000026225  0.0000000194406   0.1 0.9813 0.16777      (i)
#> 11 LATENT ~~ LATENT 0.0000000000000286120  0.000000035236  1.0000000000000   0.1 0.2305 0.07679      (i)
#> 2  LATENT =~  ITEM2 0.0000000000000162673  0.000000012089  0.0000000095605   0.1 1.1132 0.18404      (i)
#> 5  LATENT =~  ITEM5 0.0000000000000155342 -0.000000012925 -0.0000000090559   0.1 0.9298 0.16143      (i)
#> 3  LATENT =~  ITEM3 0.0000000000000073910  0.000000008670  0.0000000064177   0.1 0.9833 0.16802      (i)
#> 16  ITEM5 ~1        0.0000000000000017835  0.000000004773  0.0000000029329   0.1 0.7830 0.14339      (i)
#> 15  ITEM4 ~1        0.0000000000000015986  0.000000004387  0.0000000028524   0.1 0.8306 0.14923      (i)
#> 12  ITEM1 ~1        0.0000000000000011664  0.000000003407  0.0000000023761   0.1 1.0049 0.17068      (i)
#> 13  ITEM2 ~1        0.0000000000000005663  0.000000002451  0.0000000017003   0.1 0.9425 0.16299      (i)
#> 14  ITEM3 ~1        0.0000000000000001856  0.000000001494  0.0000000009697   0.1 0.8320 0.14940      (i)
#> 
#> $sample_covariance
#>      X1    X2    X3    X4    X5
#> 1 2.058 1.355 1.439 1.236 1.475
#> 2 1.355 2.122 1.389 1.413 1.472
#> 3 1.439 1.389 2.387 1.385 1.548
#> 4 1.236 1.413 1.385 2.339 1.638
#> 5 1.475 1.472 1.548 1.638 2.666
#> 
#> $unstandardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  0.979
#> ITEM3  1.050
#> ITEM4  1.046
#> ITEM5  1.136
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.756                        
#> ITEM2 0.000 0.832                  
#> ITEM3 0.000 0.000 0.939            
#> ITEM4 0.000 0.000 0.000 0.943      
#> ITEM5 0.000 0.000 0.000 0.000 0.969
#> 
#> $psi
#>        LATENT
#> LATENT    1.3
#> 
#> $nu
#>       intrcp
#> ITEM1  0.078
#> ITEM2 -0.194
#> ITEM3 -0.179
#> ITEM4 -0.034
#> ITEM5  0.015
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> 
#> $standardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  0.795
#> ITEM2  0.774
#> ITEM3  0.777
#> ITEM4  0.775
#> ITEM5  0.796
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.368                        
#> ITEM2 0.000 0.401                  
#> ITEM3 0.000 0.000 0.396            
#> ITEM4 0.000 0.000 0.000 0.399      
#> ITEM5 0.000 0.000 0.000 0.000 0.366
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1  0.055
#> ITEM2 -0.134
#> ITEM3 -0.116
#> ITEM4 -0.022
#> ITEM5  0.009
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
#>            X1       X2        X3       X4       X5   LATENT
#> 1    0.376512       NA        NA -0.19485 -1.71650 -0.39572
#> 2    0.942149  2.15307  0.329438  2.45571  2.00127  1.38359
#> 3    2.713222  2.95246  2.731591  3.58229  1.25352  2.30131
#> 4   -2.870522 -1.50366 -1.710679 -2.09578 -1.11568 -1.55813
#> 5   -1.685238 -1.38412 -0.674752 -1.85563 -1.23258 -1.12456
#> 6    0.322411 -1.05413 -0.081931 -1.98833 -0.81230 -0.53815
#> 7   -0.407597  1.16502  1.983387  0.80386  1.41491  0.86004
#> 8    0.670714 -0.65132 -2.488692 -1.79718 -1.29016 -0.84274
#> 9    0.952020  0.30962 -0.346576  2.59472  2.97294  1.14953
#> 10  -0.271743 -0.14395        NA -0.60219 -2.42190 -0.67853
#> 11   0.760095  2.40278  0.909641  0.39128  0.87086  0.96196
#> 12  -0.541286 -0.97811        NA -0.97884  1.74383 -0.13308
#> 13   1.459374  0.95216  0.947983  0.85843  1.53699  1.04314
#> 14  -0.732397       NA -0.529034  1.21310  1.31413  0.25041
#> 15  -0.464434 -0.60236  1.898254       NA  0.60780  0.31621
#> 16   2.980697  1.89449  0.207322  1.56180  2.36165  1.62773
#> 17         NA  0.35295  0.040789  0.36910 -0.33104  0.16637
#> 18   1.914278  0.68238  1.243301  0.75078       NA  1.06128
#> 19  -1.546814 -1.19036 -0.440325 -0.41821 -2.82295 -1.06627
#> 20   1.054307 -1.37709  1.544129  0.71005  0.51523  0.46846
#> 21  -1.175667 -1.35247 -2.211521 -2.01872 -2.39800 -1.49420
#> 22   1.387197 -1.30152  0.536568  0.68723  0.12899  0.31282
#> 23         NA  1.14865  0.793672  2.81596  1.33967  1.32083
#> 24  -0.568840 -0.24610 -1.167895 -1.02160 -1.62939 -0.73042
#> 25   0.505151  3.77899  1.110796  5.17523  3.14028  2.33286
#> 26   0.163656 -2.07767 -3.055586 -3.28499 -2.37471 -1.69712
#> 27  -0.630163  0.29119  0.530488  0.26575  2.45797  0.52423
#> 28  -2.585257 -2.08233 -3.493441 -1.90786 -1.95043 -2.00194
#> 29  -1.794975 -1.23374 -4.038345 -1.83824 -0.97681 -1.61803
#> 30   0.694114       NA  1.302258  0.56640  2.46915  1.04424
#> 31  -0.685013 -0.39880 -0.606972  0.74483 -2.51864 -0.55523
#> 32   0.317286 -1.86307  0.127739  1.03590  1.71938  0.27209
#> 33   1.006229 -0.58582 -0.318220 -0.30565 -0.47229 -0.03800
#> 34   2.393224  0.32898  2.372700  2.44855  2.23206  1.71954
#> 35  -0.496185 -0.12514 -1.757254 -1.20413  1.12244 -0.35368
#> 36         NA -1.32391 -2.823833 -2.30899 -1.98614 -1.63877
#> 37  -1.798057 -2.46841 -2.375353 -1.11898 -1.29689 -1.49854
#> 38   0.629466  0.64407  0.581755  0.14822  0.70114  0.51677
#> 39  -1.143817 -0.70146 -0.745348 -0.06637  0.59942 -0.31812
#> 40   1.578470 -0.16468  0.263154  1.17275  1.31437  0.77773
#> 41  -0.740637 -1.84512 -2.512844 -1.69811 -1.82750 -1.39527
#> 42   1.612619  0.15886 -1.572615  0.60910  0.30038  0.27978
#> 43  -1.565587 -0.78206 -0.194384 -0.39073 -0.99090 -0.64533
#> 44   0.088177 -0.57272  1.270577  0.84061  1.54829  0.57239
#> 45   0.514265 -1.07397  0.488586 -0.33837  0.62256  0.09580
#> 46  -0.615169 -0.53176 -0.788181 -0.55778 -2.12725 -0.73649
#> 47  -0.415360 -0.92622  0.685017  0.10314 -1.30468 -0.28135
#> 48  -0.861358 -2.77919 -0.701535 -0.99891 -1.59077 -1.13188
#> 49   1.613349  1.02598  3.137551  2.00832  1.51626  1.62052
#> 50  -1.454628 -1.54271 -2.061505 -0.65254 -1.87769 -1.24814
#> 51   0.843536  2.84481  1.805084  2.47180  2.95027  1.88481
#> 52   1.934323  0.01229 -0.457932 -0.83975       NA  0.26743
#> 53   0.871719  0.05545 -1.133797  1.98525 -0.35550  0.30096
#> 54  -2.736323 -3.59113 -1.920948  0.94896       NA -1.53761
#> 55  -0.341999 -0.50294  0.533571 -0.59861 -0.79138 -0.24532
#> 56  -1.302333 -0.65961 -1.484142 -1.24030 -0.34728 -0.80994
#> 57   0.902040  0.75032 -0.493579 -0.38861  1.28608  0.42612
#> 58   0.002073 -1.18126 -2.185957 -0.74471  1.62969 -0.34760
#> 59  -2.076376 -1.88696 -2.563626 -3.26538 -1.96105 -1.94053
#> 60  -0.089587 -2.16271 -1.725101  0.47996 -0.90226 -0.69064
#> 61   1.591869 -1.17209  1.636270 -1.24497 -0.63046  0.11297
#> 62   0.177598  0.34273 -0.176800 -1.17766 -1.44699 -0.32105
#> 63  -1.593909 -1.53058        NA -1.54111 -1.11305 -1.18176
#> 64         NA -0.64156 -1.982371 -0.28259 -0.91978 -0.70073
#> 65   0.559171  0.37223 -1.805071       NA  1.65953  0.24536
#> 66   1.903407  0.21993  1.203436 -0.05669  2.26866  1.02211
#> 67   0.056592  2.59764  0.310106  0.40429  0.02535  0.62208
#> 68  -1.464793 -1.86057 -2.856101  0.27561 -2.92082 -1.46076
#> 69  -0.153990 -1.21156  0.162909 -0.42467 -1.13311 -0.41997
#> 70   1.709711  2.24270  1.260361  2.18627  0.18240  1.34455
#> 71   1.711064  0.66323 -0.204184  0.42037 -0.51183  0.43778
#> 72  -1.636776 -2.02247        NA -1.41799 -2.15392 -1.48144
#> 73   2.086440  1.37795  2.069697  1.74000  1.85891  1.61327
#> 74  -2.537805  0.71534  0.404780 -1.20817 -1.06198 -0.62291
#> 75  -2.972140 -1.27157 -2.473195       NA -3.12956 -2.00971
#> 76   0.600474  0.79823  0.517938       NA       NA  0.59674
#> 77  -0.776673  0.15455  0.706571 -0.58972 -0.33983 -0.11059
#> 78  -0.583601       NA -0.198192  0.21127  0.68598  0.02798
#> 79   3.769815  1.19834  3.126408  3.50612  4.38228  2.78755
#> 80  -2.144627 -4.21041 -0.419101 -2.11041 -1.64029 -1.76223
#> 81   2.771800  0.98578  1.387486 -0.30444  1.61456  1.19772
#> 82  -0.645528  0.79005  0.085628  0.17666  0.62033  0.20812
#> 83   0.112960  0.14695  0.955177  0.19899 -0.59426  0.18206
#> 84   2.368151  2.26159  3.268601       NA  0.73718  1.84650
#> 85   1.476917  0.84762  0.597371  1.70864 -1.03730  0.67167
#> 86  -0.128111  1.45275 -0.821268  0.43175  1.55250  0.47232
#> 87   1.281481  1.16597  0.864758  0.16965  1.82258  0.96991
#> 88  -0.701768 -0.68768 -1.687831 -2.26478 -0.65929 -0.95010
#> 89   1.498683       NA -0.363224  0.05928 -0.65114  0.17274
#> 90   2.227238  1.38267  1.225512  0.71959  3.27585  1.58106
#> 91   0.075412 -0.99646  1.030686 -1.24400  0.55765 -0.04368
#> 92   0.215719 -0.99104  0.471538  1.34963 -0.02115  0.21173
#> 93  -1.689513 -1.48355 -1.215676 -0.47485 -0.70033 -0.91789
#> 94         NA  0.30560 -0.003301  1.12478  1.72445  0.72892
#> 95  -0.906187 -1.56611 -1.738892 -0.25535 -1.80662 -1.01912
#> 96   0.152100 -1.72584  0.785484 -1.23527 -0.13918 -0.30964
#> 97  -1.470331 -0.04888 -0.468147 -2.15090 -0.25454 -0.70419
#> 98  -0.795549 -0.23000 -0.013182 -2.40414       NA -0.65300
#> 99   1.577242  1.72101  0.704641 -1.56426 -0.08817  0.49257
#> 100  0.242476  1.37514  2.025376 -0.10756 -0.50246  0.55542
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






#> [1] "####################################################################################################"
#> [1] "SUMMARY"
#> [1] "####################################################################################################"
#> lavaan 0.7-2 ended normally after 23 iterations
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
#>   Test statistic                                 1.444
#>   Degrees of freedom                                 5
#>   P-value (Chi-square)                           0.919
#> 
#> Model Test Baseline Model:
#> 
#>   Test statistic                               241.776
#>   Degrees of freedom                                10
#>   P-value                                        0.000
#> 
#> User Model versus Baseline Model:
#> 
#>   Comparative Fit Index (CFI)                    1.000
#>   Tucker-Lewis Index (TLI)                       1.031
#>                                                       
#>   Robust Comparative Fit Index (CFI)             1.000
#>   Robust Tucker-Lewis Index (TLI)                1.033
#> 
#> Loglikelihood and Information Criteria:
#> 
#>   Loglikelihood user model (H0)               -752.005
#>   Loglikelihood unrestricted model (H1)       -751.283
#>                                                       
#>   Akaike (AIC)                                1534.011
#>   Bayesian (BIC)                              1573.088
#>   Sample-size adjusted Bayesian (SABIC)       1525.715
#> 
#> Root Mean Square Error of Approximation:
#> 
#>   RMSEA                                          0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.049
#>   P-value H_0: RMSEA <= 0.050                    0.951
#>   P-value H_0: RMSEA >= 0.080                    0.022
#>                                                       
#>   Robust RMSEA                                   0.000
#>   90 Percent confidence interval - lower         0.000
#>   90 Percent confidence interval - upper         0.052
#>   P-value H_0: Robust RMSEA <= 0.050             0.948
#>   P-value H_0: Robust RMSEA >= 0.080             0.026
#> 
#> Standardized Root Mean Square Residual:
#> 
#>   SRMR                                           0.011
#> 
#> Goodness of Fit Index:
#> 
#>   Goodness of Fit Index (GFI)                    1.000
#>   90 Percent confidence interval - lower         0.995
#>   90 Percent confidence interval - upper         1.000
#>                                                       
#>   Robust GFI                                     1.000
#>   90 Percent confidence interval - lower         0.995
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
#>     ITEM1             1.000                               1.140    0.795
#>     ITEM2             0.979    0.124    7.910    0.000    1.116    0.774
#>     ITEM3             1.050    0.131    7.993    0.000    1.197    0.777
#>     ITEM4             1.046    0.135    7.730    0.000    1.193    0.775
#>     ITEM5             1.136    0.140    8.133    0.000    1.296    0.796
#> 
#> Intercepts:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1             0.078    0.145    0.540    0.589    0.078    0.055
#>    .ITEM2            -0.194    0.146   -1.327    0.185   -0.194   -0.134
#>    .ITEM3            -0.179    0.156   -1.145    0.252   -0.179   -0.116
#>    .ITEM4            -0.034    0.156   -0.220    0.826   -0.034   -0.022
#>    .ITEM5             0.015    0.165    0.093    0.926    0.015    0.009
#> 
#> Variances:
#>                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
#>    .ITEM1             0.756    0.143    5.271    0.000    0.756    0.368
#>    .ITEM2             0.832    0.151    5.528    0.000    0.832    0.401
#>    .ITEM3             0.939    0.172    5.470    0.000    0.939    0.396
#>    .ITEM4             0.943    0.173    5.451    0.000    0.943    0.399
#>    .ITEM5             0.969    0.185    5.245    0.000    0.969    0.366
#>     LATENT            1.300    0.290    4.481    0.000    1.000    1.000
#> 
#> R-Square:
#>                    Estimate
#>     ITEM1             0.632
#>     ITEM2             0.599
#>     ITEM3             0.604
#>     ITEM4             0.601
#>     ITEM5             0.634
#> 
#> [1] "####################################################################################################"
#> [1] "R_SQUARED"
#> [1] "####################################################################################################"
#>       r_squared
#> ITEM1    0.6323
#> ITEM2    0.5995
#> ITEM3    0.6042
#> ITEM4    0.6013
#> ITEM5    0.6340
#> [1] "####################################################################################################"
#> [1] "FIT INDICES"
#> [1] "####################################################################################################"
#>                                     fit
#> npar                           15.00000
#> fmin                            0.00722
#> chisq                           1.44405
#> df                              5.00000
#> pvalue                          0.91943
#> baseline.chisq                241.77594
#> baseline.df                    10.00000
#> baseline.pvalue                 0.00000
#> cfi                             1.00000
#> tli                             1.03068
#> cfi.robust                      1.00000
#> tli.robust                      1.03312
#> nnfi                            1.03068
#> rfi                             0.98805
#> nfi                             0.99403
#> pnfi                            0.49701
#> ifi                             1.01502
#> rni                             1.01534
#> nnfi.robust                     1.03312
#> rni.robust                      1.01656
#> logl                         -752.00543
#> unrestricted.logl            -751.28340
#> aic                          1534.01086
#> bic                          1573.08841
#> ntotal                        100.00000
#> bic2                         1525.71464
#> rmsea                           0.00000
#> rmsea.ci.lower                  0.00000
#> rmsea.ci.upper                  0.04866
#> rmsea.ci.level                  0.90000
#> rmsea.pvalue                    0.95132
#> rmsea.close.h0                  0.05000
#> rmsea.notclose.pvalue           0.02206
#> rmsea.notclose.h0               0.08000
#> rmsea.robust                    0.00000
#> rmsea.ci.lower.robust           0.00000
#> rmsea.ci.upper.robust           0.05227
#> rmsea.pvalue.robust             0.94792
#> rmsea.notclose.pvalue.robust    0.02620
#> rmr                             0.02589
#> rmr_nomean                      0.02988
#> srmr                            0.01120
#> srmr_bentler                    0.01120
#> srmr_bentler_nomean             0.01291
#> crmr                            0.01284
#> crmr_nomean                     0.01570
#> srmr_mplus                      0.01115
#> srmr_mplus_nomean               0.01285
#> gfi                             1.00000
#> gfi.ci.lower                    0.99529
#> gfi.ci.upper                    1.00000
#> gfi.ci.level                    0.90000
#> gfi.robust                      1.00000
#> gfi.ci.lower.robust             0.99457
#> gfi.ci.upper.robust             1.00000
#> cn_05                         767.62724
#> cn_01                        1045.71794
#> gfi_lisrel                      0.98261
#> agfi_lisrel                     0.93043
#> pgfi                            0.24565
#> mfi                             1.01794
#> ecvi                            0.31444
#> [1] "####################################################################################################"
#> [1] "PARAMETERS"
#> [1] "####################################################################################################"
#>       lhs op    rhs exo      est     se       z                pvalue ci.lower ci.upper   std.lv   std.all
#> 1  LATENT =~  ITEM1   0  1.00000 0.0000      NA                    NA   1.0000  1.00000  1.14012  0.795174
#> 2  LATENT =~  ITEM2   0  0.97901 0.1238  7.9096 0.0000000000000026645   0.7364  1.22160  1.11619  0.774263
#> 3  LATENT =~  ITEM3   0  1.05004 0.1314  7.9926 0.0000000000000013323   0.7925  1.30753  1.19717  0.777273
#> 4  LATENT =~  ITEM4   0  1.04607 0.1353  7.7303 0.0000000000000106581   0.7808  1.31129  1.19265  0.775453
#> 5  LATENT =~  ITEM5   0  1.13646 0.1397  8.1329 0.0000000000000004441   0.8626  1.41034  1.29570  0.796234
#> 6   ITEM1 ~~  ITEM1   0  0.75591 0.1434  5.2710 0.0000001356631531557   0.4748  1.03699  0.75591  0.367699
#> 7   ITEM2 ~~  ITEM2   0  0.83237 0.1506  5.5276 0.0000000324550872843   0.5372  1.12751  0.83237  0.400516
#> 8   ITEM3 ~~  ITEM3   0  0.93905 0.1717  5.4695 0.0000000451253359124   0.6026  1.27556  0.93905  0.395847
#> 9   ITEM4 ~~  ITEM4   0  0.94304 0.1730  5.4514 0.0000000499656345188   0.6040  1.28210  0.94304  0.398673
#> 10  ITEM5 ~~  ITEM5   0  0.96922 0.1848  5.2453 0.0000001559956859243   0.6071  1.33138  0.96922  0.366011
#> 11 LATENT ~~ LATENT   0  1.29988 0.2901  4.4812 0.0000074222706858418   0.7313  1.86841  1.00000  1.000000
#> 12  ITEM1 ~1          0  0.07839 0.1451  0.5402 0.5890267286129460267  -0.2060  0.36278  0.07839  0.054672
#> 13  ITEM2 ~1          0 -0.19368 0.1460 -1.3266 0.1846250653790726393  -0.4798  0.09246 -0.19368 -0.134351
#> 14  ITEM3 ~1          0 -0.17870 0.1560 -1.1454 0.2520441596297475773  -0.4845  0.12709 -0.17870 -0.116023
#> 15  ITEM4 ~1          0 -0.03428 0.1558 -0.2201 0.8257840965289942048  -0.3396  0.27099 -0.03428 -0.022291
#> 16  ITEM5 ~1          0  0.01537 0.1647  0.0933 0.9256638379686097373  -0.3074  0.33814  0.01537  0.009442
#> 17 LATENT ~1          0  0.00000 0.0000      NA                    NA   0.0000  0.00000  0.00000  0.000000
#> 18  ITEM1 r2  ITEM1   0  0.63230     NA      NA                    NA       NA       NA       NA        NA
#> 19  ITEM2 r2  ITEM2   0  0.59948     NA      NA                    NA       NA       NA       NA        NA
#> 20  ITEM3 r2  ITEM3   0  0.60415     NA      NA                    NA       NA       NA       NA        NA
#> 21  ITEM4 r2  ITEM4   0  0.60133     NA      NA                    NA       NA       NA       NA        NA
#> 22  ITEM5 r2  ITEM5   0  0.63399     NA      NA                    NA       NA       NA       NA        NA
#> [1] "####################################################################################################"
#> [1] "UNSTANDARDIZED PARAMETERS"
#> [1] "####################################################################################################"
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  0.979
#> ITEM3  1.050
#> ITEM4  1.046
#> ITEM5  1.136
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.756                        
#> ITEM2 0.000 0.832                  
#> ITEM3 0.000 0.000 0.939            
#> ITEM4 0.000 0.000 0.000 0.943      
#> ITEM5 0.000 0.000 0.000 0.000 0.969
#> 
#> $psi
#>        LATENT
#> LATENT    1.3
#> 
#> $nu
#>       intrcp
#> ITEM1  0.078
#> ITEM2 -0.194
#> ITEM3 -0.179
#> ITEM4 -0.034
#> ITEM5  0.015
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
#> ITEM1  0.795
#> ITEM2  0.774
#> ITEM3  0.777
#> ITEM4  0.775
#> ITEM5  0.796
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.368                        
#> ITEM2 0.000 0.401                  
#> ITEM3 0.000 0.000 0.396            
#> ITEM4 0.000 0.000 0.000 0.399      
#> ITEM5 0.000 0.000 0.000 0.000 0.366
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1  0.055
#> ITEM2 -0.134
#> ITEM3 -0.116
#> ITEM4 -0.022
#> ITEM5  0.009
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> [1] "####################################################################################################"
#> [1] "SAMPLE COVARIANCE"
#> [1] "####################################################################################################"
#>      X1    X2    X3    X4    X5
#> 1 2.058 1.355 1.439 1.236 1.475
#> 2 1.355 2.122 1.389 1.413 1.472
#> 3 1.439 1.389 2.387 1.385 1.548
#> 4 1.236 1.413 1.385 2.339 1.638
#> 5 1.475 1.472 1.548 1.638 2.666
#> [1] "####################################################################################################"
#> [1] "CALL"
#> [1] "####################################################################################################"
#> [1] "lavaan::lavaan(model=model,data=df,missing=\"ML\",model.type=\"cfa\"," "cmd=\"cfa\",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,"  
#> [3] "auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,"                "auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)"          
#> [1] "lavaan::lavaan(model=model,data=df,missing=\"ML\",model.type=\"cfa\"," "cmd=\"cfa\",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,"  
#> [3] "auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,"                "auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)"          
#> $r_squared
#>       r_squared
#> ITEM1    0.6323
#> ITEM2    0.5995
#> ITEM3    0.6042
#> ITEM4    0.6013
#> ITEM5    0.6340
#> 
#> $fit_indices
#>                                     fit
#> npar                           15.00000
#> fmin                            0.00722
#> chisq                           1.44405
#> df                              5.00000
#> pvalue                          0.91943
#> baseline.chisq                241.77594
#> baseline.df                    10.00000
#> baseline.pvalue                 0.00000
#> cfi                             1.00000
#> tli                             1.03068
#> cfi.robust                      1.00000
#> tli.robust                      1.03312
#> nnfi                            1.03068
#> rfi                             0.98805
#> nfi                             0.99403
#> pnfi                            0.49701
#> ifi                             1.01502
#> rni                             1.01534
#> nnfi.robust                     1.03312
#> rni.robust                      1.01656
#> logl                         -752.00543
#> unrestricted.logl            -751.28340
#> aic                          1534.01086
#> bic                          1573.08841
#> ntotal                        100.00000
#> bic2                         1525.71464
#> rmsea                           0.00000
#> rmsea.ci.lower                  0.00000
#> rmsea.ci.upper                  0.04866
#> rmsea.ci.level                  0.90000
#> rmsea.pvalue                    0.95132
#> rmsea.close.h0                  0.05000
#> rmsea.notclose.pvalue           0.02206
#> rmsea.notclose.h0               0.08000
#> rmsea.robust                    0.00000
#> rmsea.ci.lower.robust           0.00000
#> rmsea.ci.upper.robust           0.05227
#> rmsea.pvalue.robust             0.94792
#> rmsea.notclose.pvalue.robust    0.02620
#> rmr                             0.02589
#> rmr_nomean                      0.02988
#> srmr                            0.01120
#> srmr_bentler                    0.01120
#> srmr_bentler_nomean             0.01291
#> crmr                            0.01284
#> crmr_nomean                     0.01570
#> srmr_mplus                      0.01115
#> srmr_mplus_nomean               0.01285
#> gfi                             1.00000
#> gfi.ci.lower                    0.99529
#> gfi.ci.upper                    1.00000
#> gfi.ci.level                    0.90000
#> gfi.robust                      1.00000
#> gfi.ci.lower.robust             0.99457
#> gfi.ci.upper.robust             1.00000
#> cn_05                         767.62724
#> cn_01                        1045.71794
#> gfi_lisrel                      0.98261
#> agfi_lisrel                     0.93043
#> pgfi                            0.24565
#> mfi                             1.01794
#> ecvi                            0.31444
#> 
#> $parameters
#>       lhs op    rhs exo      est     se       z                pvalue ci.lower ci.upper   std.lv   std.all
#> 1  LATENT =~  ITEM1   0  1.00000 0.0000      NA                    NA   1.0000  1.00000  1.14012  0.795174
#> 2  LATENT =~  ITEM2   0  0.97901 0.1238  7.9096 0.0000000000000026645   0.7364  1.22160  1.11619  0.774263
#> 3  LATENT =~  ITEM3   0  1.05004 0.1314  7.9926 0.0000000000000013323   0.7925  1.30753  1.19717  0.777273
#> 4  LATENT =~  ITEM4   0  1.04607 0.1353  7.7303 0.0000000000000106581   0.7808  1.31129  1.19265  0.775453
#> 5  LATENT =~  ITEM5   0  1.13646 0.1397  8.1329 0.0000000000000004441   0.8626  1.41034  1.29570  0.796234
#> 6   ITEM1 ~~  ITEM1   0  0.75591 0.1434  5.2710 0.0000001356631531557   0.4748  1.03699  0.75591  0.367699
#> 7   ITEM2 ~~  ITEM2   0  0.83237 0.1506  5.5276 0.0000000324550872843   0.5372  1.12751  0.83237  0.400516
#> 8   ITEM3 ~~  ITEM3   0  0.93905 0.1717  5.4695 0.0000000451253359124   0.6026  1.27556  0.93905  0.395847
#> 9   ITEM4 ~~  ITEM4   0  0.94304 0.1730  5.4514 0.0000000499656345188   0.6040  1.28210  0.94304  0.398673
#> 10  ITEM5 ~~  ITEM5   0  0.96922 0.1848  5.2453 0.0000001559956859243   0.6071  1.33138  0.96922  0.366011
#> 11 LATENT ~~ LATENT   0  1.29988 0.2901  4.4812 0.0000074222706858418   0.7313  1.86841  1.00000  1.000000
#> 12  ITEM1 ~1          0  0.07839 0.1451  0.5402 0.5890267286129460267  -0.2060  0.36278  0.07839  0.054672
#> 13  ITEM2 ~1          0 -0.19368 0.1460 -1.3266 0.1846250653790726393  -0.4798  0.09246 -0.19368 -0.134351
#> 14  ITEM3 ~1          0 -0.17870 0.1560 -1.1454 0.2520441596297475773  -0.4845  0.12709 -0.17870 -0.116023
#> 15  ITEM4 ~1          0 -0.03428 0.1558 -0.2201 0.8257840965289942048  -0.3396  0.27099 -0.03428 -0.022291
#> 16  ITEM5 ~1          0  0.01537 0.1647  0.0933 0.9256638379686097373  -0.3074  0.33814  0.01537  0.009442
#> 17 LATENT ~1          0  0.00000 0.0000      NA                    NA   0.0000  0.00000  0.00000  0.000000
#> 18  ITEM1 r2  ITEM1   0  0.63230     NA      NA                    NA       NA       NA       NA        NA
#> 19  ITEM2 r2  ITEM2   0  0.59948     NA      NA                    NA       NA       NA       NA        NA
#> 20  ITEM3 r2  ITEM3   0  0.60415     NA      NA                    NA       NA       NA       NA        NA
#> 21  ITEM4 r2  ITEM4   0  0.60133     NA      NA                    NA       NA       NA       NA        NA
#> 22  ITEM5 r2  ITEM5   0  0.63399     NA      NA                    NA       NA       NA       NA        NA
#> 
#> $modification_indices
#>       lhs op    rhs                    mi             epc         sepc.all delta    ncp   power decision
#> 19  ITEM1 ~~  ITEM3 0.8850843863677139156  0.120614969359  0.1431595228417   0.1 0.6084 0.12208      (i)
#> 20  ITEM1 ~~  ITEM4 0.8621350975754459300 -0.118898533595 -0.1408235448956   0.1 0.6098 0.12226      (i)
#> 27  ITEM4 ~~  ITEM5 0.5007694535984043016  0.102561459297  0.1072771631277   0.1 0.4761 0.10607      (i)
#> 26  ITEM3 ~~  ITEM5 0.3534826474864162793 -0.086396378499 -0.0905605151889   0.1 0.4736 0.10577      (i)
#> 23  ITEM2 ~~  ITEM4 0.1891744160005738862  0.056201512996  0.0634342945919   0.1 0.5989 0.12093      (i)
#> 25  ITEM3 ~~  ITEM4 0.0437988938423093041 -0.028866469735 -0.0306748800952   0.1 0.5256 0.11205      (i)
#> 24  ITEM2 ~~  ITEM5 0.0357712569065468805 -0.025735892891 -0.0286529600744   0.1 0.5401 0.11380      (i)
#> 22  ITEM2 ~~  ITEM3 0.0210885056149049746 -0.018748739344 -0.0212064726144   0.1 0.5999 0.12105      (i)
#> 18  ITEM1 ~~  ITEM2 0.0083338130951393953 -0.010959833585 -0.0138168772495   0.1 0.6938 0.13248      (i)
#> 21  ITEM1 ~~  ITEM5 0.0055219470870310362  0.010052883988  0.0117447449914   0.1 0.5464 0.11456      (i)
#> 10  ITEM5 ~~  ITEM5 0.0000000000014850667  0.000000214480  0.3660107192209   0.1 0.3228 0.08773      (i)
#> 9   ITEM4 ~~  ITEM4 0.0000000000012701092 -0.000000186982 -0.3986731781624   0.1 0.3633 0.09255      (i)
#> 6   ITEM1 ~~  ITEM1 0.0000000000002282273 -0.000000065508 -0.3676987588209   0.1 0.5318 0.11280      (i)
#> 8   ITEM3 ~~  ITEM3 0.0000000000001609214 -0.000000066448 -0.3958465008356   0.1 0.3645 0.09269      (i)
#> 7   ITEM2 ~~  ITEM2 0.0000000000001393916  0.000000054592  0.4005163428723   0.1 0.4677 0.10506      (i)
#> 4  LATENT =~  ITEM4 0.0000000000000674904  0.000000026225  0.0000000194406   0.1 0.9813 0.16777      (i)
#> 11 LATENT ~~ LATENT 0.0000000000000286120  0.000000035236  1.0000000000000   0.1 0.2305 0.07679      (i)
#> 2  LATENT =~  ITEM2 0.0000000000000162673  0.000000012089  0.0000000095605   0.1 1.1132 0.18404      (i)
#> 5  LATENT =~  ITEM5 0.0000000000000155342 -0.000000012925 -0.0000000090559   0.1 0.9298 0.16143      (i)
#> 3  LATENT =~  ITEM3 0.0000000000000073910  0.000000008670  0.0000000064177   0.1 0.9833 0.16802      (i)
#> 16  ITEM5 ~1        0.0000000000000017835  0.000000004773  0.0000000029329   0.1 0.7830 0.14339      (i)
#> 15  ITEM4 ~1        0.0000000000000015986  0.000000004387  0.0000000028524   0.1 0.8306 0.14923      (i)
#> 12  ITEM1 ~1        0.0000000000000011664  0.000000003407  0.0000000023761   0.1 1.0049 0.17068      (i)
#> 13  ITEM2 ~1        0.0000000000000005663  0.000000002451  0.0000000017003   0.1 0.9425 0.16299      (i)
#> 14  ITEM3 ~1        0.0000000000000001856  0.000000001494  0.0000000009697   0.1 0.8320 0.14940      (i)
#> 
#> $sample_covariance
#>      X1    X2    X3    X4    X5
#> 1 2.058 1.355 1.439 1.236 1.475
#> 2 1.355 2.122 1.389 1.413 1.472
#> 3 1.439 1.389 2.387 1.385 1.548
#> 4 1.236 1.413 1.385 2.339 1.638
#> 5 1.475 1.472 1.548 1.638 2.666
#> 
#> $unstandardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  1.000
#> ITEM2  0.979
#> ITEM3  1.050
#> ITEM4  1.046
#> ITEM5  1.136
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.756                        
#> ITEM2 0.000 0.832                  
#> ITEM3 0.000 0.000 0.939            
#> ITEM4 0.000 0.000 0.000 0.943      
#> ITEM5 0.000 0.000 0.000 0.000 0.969
#> 
#> $psi
#>        LATENT
#> LATENT    1.3
#> 
#> $nu
#>       intrcp
#> ITEM1  0.078
#> ITEM2 -0.194
#> ITEM3 -0.179
#> ITEM4 -0.034
#> ITEM5  0.015
#> 
#> $alpha
#>        intrcp
#> LATENT      0
#> 
#> 
#> $standardized_estimates
#> $lambda
#>       LATENT
#> ITEM1  0.795
#> ITEM2  0.774
#> ITEM3  0.777
#> ITEM4  0.775
#> ITEM5  0.796
#> 
#> $theta
#>       ITEM1 ITEM2 ITEM3 ITEM4 ITEM5
#> ITEM1 0.368                        
#> ITEM2 0.000 0.401                  
#> ITEM3 0.000 0.000 0.396            
#> ITEM4 0.000 0.000 0.000 0.399      
#> ITEM5 0.000 0.000 0.000 0.000 0.366
#> 
#> $psi
#>        LATENT
#> LATENT      1
#> 
#> $nu
#>       intrcp
#> ITEM1  0.055
#> ITEM2 -0.134
#> ITEM3 -0.116
#> ITEM4 -0.022
#> ITEM5  0.009
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
#>            X1       X2        X3       X4       X5   LATENT
#> 1    0.376512       NA        NA -0.19485 -1.71650 -0.39572
#> 2    0.942149  2.15307  0.329438  2.45571  2.00127  1.38359
#> 3    2.713222  2.95246  2.731591  3.58229  1.25352  2.30131
#> 4   -2.870522 -1.50366 -1.710679 -2.09578 -1.11568 -1.55813
#> 5   -1.685238 -1.38412 -0.674752 -1.85563 -1.23258 -1.12456
#> 6    0.322411 -1.05413 -0.081931 -1.98833 -0.81230 -0.53815
#> 7   -0.407597  1.16502  1.983387  0.80386  1.41491  0.86004
#> 8    0.670714 -0.65132 -2.488692 -1.79718 -1.29016 -0.84274
#> 9    0.952020  0.30962 -0.346576  2.59472  2.97294  1.14953
#> 10  -0.271743 -0.14395        NA -0.60219 -2.42190 -0.67853
#> 11   0.760095  2.40278  0.909641  0.39128  0.87086  0.96196
#> 12  -0.541286 -0.97811        NA -0.97884  1.74383 -0.13308
#> 13   1.459374  0.95216  0.947983  0.85843  1.53699  1.04314
#> 14  -0.732397       NA -0.529034  1.21310  1.31413  0.25041
#> 15  -0.464434 -0.60236  1.898254       NA  0.60780  0.31621
#> 16   2.980697  1.89449  0.207322  1.56180  2.36165  1.62773
#> 17         NA  0.35295  0.040789  0.36910 -0.33104  0.16637
#> 18   1.914278  0.68238  1.243301  0.75078       NA  1.06128
#> 19  -1.546814 -1.19036 -0.440325 -0.41821 -2.82295 -1.06627
#> 20   1.054307 -1.37709  1.544129  0.71005  0.51523  0.46846
#> 21  -1.175667 -1.35247 -2.211521 -2.01872 -2.39800 -1.49420
#> 22   1.387197 -1.30152  0.536568  0.68723  0.12899  0.31282
#> 23         NA  1.14865  0.793672  2.81596  1.33967  1.32083
#> 24  -0.568840 -0.24610 -1.167895 -1.02160 -1.62939 -0.73042
#> 25   0.505151  3.77899  1.110796  5.17523  3.14028  2.33286
#> 26   0.163656 -2.07767 -3.055586 -3.28499 -2.37471 -1.69712
#> 27  -0.630163  0.29119  0.530488  0.26575  2.45797  0.52423
#> 28  -2.585257 -2.08233 -3.493441 -1.90786 -1.95043 -2.00194
#> 29  -1.794975 -1.23374 -4.038345 -1.83824 -0.97681 -1.61803
#> 30   0.694114       NA  1.302258  0.56640  2.46915  1.04424
#> 31  -0.685013 -0.39880 -0.606972  0.74483 -2.51864 -0.55523
#> 32   0.317286 -1.86307  0.127739  1.03590  1.71938  0.27209
#> 33   1.006229 -0.58582 -0.318220 -0.30565 -0.47229 -0.03800
#> 34   2.393224  0.32898  2.372700  2.44855  2.23206  1.71954
#> 35  -0.496185 -0.12514 -1.757254 -1.20413  1.12244 -0.35368
#> 36         NA -1.32391 -2.823833 -2.30899 -1.98614 -1.63877
#> 37  -1.798057 -2.46841 -2.375353 -1.11898 -1.29689 -1.49854
#> 38   0.629466  0.64407  0.581755  0.14822  0.70114  0.51677
#> 39  -1.143817 -0.70146 -0.745348 -0.06637  0.59942 -0.31812
#> 40   1.578470 -0.16468  0.263154  1.17275  1.31437  0.77773
#> 41  -0.740637 -1.84512 -2.512844 -1.69811 -1.82750 -1.39527
#> 42   1.612619  0.15886 -1.572615  0.60910  0.30038  0.27978
#> 43  -1.565587 -0.78206 -0.194384 -0.39073 -0.99090 -0.64533
#> 44   0.088177 -0.57272  1.270577  0.84061  1.54829  0.57239
#> 45   0.514265 -1.07397  0.488586 -0.33837  0.62256  0.09580
#> 46  -0.615169 -0.53176 -0.788181 -0.55778 -2.12725 -0.73649
#> 47  -0.415360 -0.92622  0.685017  0.10314 -1.30468 -0.28135
#> 48  -0.861358 -2.77919 -0.701535 -0.99891 -1.59077 -1.13188
#> 49   1.613349  1.02598  3.137551  2.00832  1.51626  1.62052
#> 50  -1.454628 -1.54271 -2.061505 -0.65254 -1.87769 -1.24814
#> 51   0.843536  2.84481  1.805084  2.47180  2.95027  1.88481
#> 52   1.934323  0.01229 -0.457932 -0.83975       NA  0.26743
#> 53   0.871719  0.05545 -1.133797  1.98525 -0.35550  0.30096
#> 54  -2.736323 -3.59113 -1.920948  0.94896       NA -1.53761
#> 55  -0.341999 -0.50294  0.533571 -0.59861 -0.79138 -0.24532
#> 56  -1.302333 -0.65961 -1.484142 -1.24030 -0.34728 -0.80994
#> 57   0.902040  0.75032 -0.493579 -0.38861  1.28608  0.42612
#> 58   0.002073 -1.18126 -2.185957 -0.74471  1.62969 -0.34760
#> 59  -2.076376 -1.88696 -2.563626 -3.26538 -1.96105 -1.94053
#> 60  -0.089587 -2.16271 -1.725101  0.47996 -0.90226 -0.69064
#> 61   1.591869 -1.17209  1.636270 -1.24497 -0.63046  0.11297
#> 62   0.177598  0.34273 -0.176800 -1.17766 -1.44699 -0.32105
#> 63  -1.593909 -1.53058        NA -1.54111 -1.11305 -1.18176
#> 64         NA -0.64156 -1.982371 -0.28259 -0.91978 -0.70073
#> 65   0.559171  0.37223 -1.805071       NA  1.65953  0.24536
#> 66   1.903407  0.21993  1.203436 -0.05669  2.26866  1.02211
#> 67   0.056592  2.59764  0.310106  0.40429  0.02535  0.62208
#> 68  -1.464793 -1.86057 -2.856101  0.27561 -2.92082 -1.46076
#> 69  -0.153990 -1.21156  0.162909 -0.42467 -1.13311 -0.41997
#> 70   1.709711  2.24270  1.260361  2.18627  0.18240  1.34455
#> 71   1.711064  0.66323 -0.204184  0.42037 -0.51183  0.43778
#> 72  -1.636776 -2.02247        NA -1.41799 -2.15392 -1.48144
#> 73   2.086440  1.37795  2.069697  1.74000  1.85891  1.61327
#> 74  -2.537805  0.71534  0.404780 -1.20817 -1.06198 -0.62291
#> 75  -2.972140 -1.27157 -2.473195       NA -3.12956 -2.00971
#> 76   0.600474  0.79823  0.517938       NA       NA  0.59674
#> 77  -0.776673  0.15455  0.706571 -0.58972 -0.33983 -0.11059
#> 78  -0.583601       NA -0.198192  0.21127  0.68598  0.02798
#> 79   3.769815  1.19834  3.126408  3.50612  4.38228  2.78755
#> 80  -2.144627 -4.21041 -0.419101 -2.11041 -1.64029 -1.76223
#> 81   2.771800  0.98578  1.387486 -0.30444  1.61456  1.19772
#> 82  -0.645528  0.79005  0.085628  0.17666  0.62033  0.20812
#> 83   0.112960  0.14695  0.955177  0.19899 -0.59426  0.18206
#> 84   2.368151  2.26159  3.268601       NA  0.73718  1.84650
#> 85   1.476917  0.84762  0.597371  1.70864 -1.03730  0.67167
#> 86  -0.128111  1.45275 -0.821268  0.43175  1.55250  0.47232
#> 87   1.281481  1.16597  0.864758  0.16965  1.82258  0.96991
#> 88  -0.701768 -0.68768 -1.687831 -2.26478 -0.65929 -0.95010
#> 89   1.498683       NA -0.363224  0.05928 -0.65114  0.17274
#> 90   2.227238  1.38267  1.225512  0.71959  3.27585  1.58106
#> 91   0.075412 -0.99646  1.030686 -1.24400  0.55765 -0.04368
#> 92   0.215719 -0.99104  0.471538  1.34963 -0.02115  0.21173
#> 93  -1.689513 -1.48355 -1.215676 -0.47485 -0.70033 -0.91789
#> 94         NA  0.30560 -0.003301  1.12478  1.72445  0.72892
#> 95  -0.906187 -1.56611 -1.738892 -0.25535 -1.80662 -1.01912
#> 96   0.152100 -1.72584  0.785484 -1.23527 -0.13918 -0.30964
#> 97  -1.470331 -0.04888 -0.468147 -2.15090 -0.25454 -0.70419
#> 98  -0.795549 -0.23000 -0.013182 -2.40414       NA -0.65300
#> 99   1.577242  1.72101  0.704641 -1.56426 -0.08817  0.49257
#> 100  0.242476  1.37514  2.025376 -0.10756 -0.50246  0.55542
#> 
#> $call
#>                                                                call
#> 1 lavaan::lavaan(model=model,data=df,missing="ML",model.type="cfa",
#> 2 cmd="cfa",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,
#> 3            auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,
#> 4       auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)
#> 
```
