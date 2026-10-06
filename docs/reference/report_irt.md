# Output for irt model

Output for irt model

## Usage

``` r
report_irt(model, m2 = TRUE, file = NULL)
```

## Arguments

- model:

  object mirt

- m2:

  if TRUE report m2 statistics

- file:

  output filename

## Examples

``` r
set.seed(12345)
cormatrix<-psych::sim.rasch(nvar=5,n=50000,low=-4,high=4,d=NULL,a=1,mu=0,sd=1)$items
irt_onefactor<-mirt::mirt(cormatrix,1,empiricalhist=TRUE,calcNull=TRUE)
irt_twofactor<-mirt::mirt(cormatrix,2,empiricalhist=TRUE,calcNull=TRUE)
irt_threefactor<-mirt::mirt(cormatrix,3,empiricalhist=TRUE,calcNull=TRUE)
report_irt(model=irt_onefactor,file="one_factor")
#> Q3 summary statistics:
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>  -0.133  -0.055  -0.042  -0.052  -0.026  -0.003 
#> 
#>        V1     V2     V3     V4     V5
#> V1  1.000 -0.042 -0.053 -0.009 -0.003
#> V2 -0.042  1.000 -0.120 -0.056 -0.022
#> V3 -0.053 -0.120  1.000 -0.133 -0.041
#> V4 -0.009 -0.056 -0.133  1.000 -0.042
#> V5 -0.003 -0.022 -0.041 -0.042  1.000
#> Warning: no non-missing arguments to min; returning Inf
#> Warning: no non-missing arguments to max; returning -Inf
#> Warning: no non-missing arguments to min; returning Inf
#> Warning: no non-missing arguments to max; returning -Inf
#> Data does not contain missing values. Continuing normally
#> Sample size after row-wise response data removal: 50000
#> $model_coefficients
#>        a1         d g u
#> V1 1.1023  4.170279 0 1
#> V2 0.9437  1.945285 0 1
#> V3 1.0090  0.006786 0 1
#> V4 1.0210 -2.003479 0 1
#> V5 0.9278 -3.942474 0 1
#> 
#> $model_coefficients_oblimin
#>      .id     a1         d  g  u  x F1
#> V1 items 1.1023  4.170279  0  1 NA NA
#> V2 items 0.9437  1.945285  0  1 NA NA
#> V3 items 1.0090  0.006786  0  1 NA NA
#> V4 items 1.0210 -2.003479  0  1 NA NA
#> V5 items 0.9278 -3.942474  0  1 NA NA
#> 6  means     NA        NA NA NA  0 NA
#> 7    cov     NA        NA NA NA NA  1
#> 
#> $model_options
#>                       Options
#> method                     EM
#> draws                    5000
#> calcLL                   TRUE
#> SE                      FALSE
#> SE.type                 Oakes
#> verbose                 FALSE
#> SEtol                   0.001
#> storeEMhistory          FALSE
#> calcNull                 TRUE
#> odentype             Gaussian
#> dentype              Gaussian
#> zeroExtreme             FALSE
#> accelerate             Ramsay
#> Norder                      2
#> delta                 0.00001
#> Etable                   TRUE
#> plausible.draws             0
#> storeEtable              TRUE
#> TOL                    0.0001
#> omp_threads                 1
#> PLCI                    FALSE
#> warn                     TRUE
#> message                  TRUE
#> technical.symmetric      TRUE
#> technical.parallel       TRUE
#> technical.omp            TRUE
#> MAXQUAD                 20000
#> NCYCLES                   500
#> BURNIN                    150
#> SEMCYCLES                 100
#> SEM_from                    0
#> SEM_to                  0.999
#> KDRAWS                      1
#> MHDRAWS                     5
#> MHRM_SE_draws            2000
#> internal_constraints     TRUE
#> keep_vcov_PD             TRUE
#> theta_lim1                 -6
#> theta_lim2                  6
#> gain1                     0.1
#> gain2                    0.75
#> NULL.MODEL              FALSE
#> USEEM                    TRUE
#> returnPrepList          FALSE
#> Moptim                   BFGS
#> logLik_if_converged      TRUE
#> info_if_converged        TRUE
#> full                    FALSE
#> quadpts                    61
#> exploratory             FALSE
#> 
#> $model_call
#> [1] "NULL"
#> 
#> $q3_matrix
#>            V1       V2       V3     V4   V5      min       max
#> V1         NA       NA       NA     NA   NA       NA        NA
#> V2  -0.042436       NA       NA     NA   NA -0.04244 -0.042436
#> V3  -0.052514 -0.12027       NA     NA   NA -0.12027 -0.052514
#> V4  -0.008633 -0.05594 -0.13294     NA   NA -0.13294 -0.008633
#> V5  -0.003498 -0.02156 -0.04116 -0.042   NA -0.04200 -0.003498
#> min -0.052514 -0.12027 -0.13294 -0.042  Inf -0.13294 -0.052514
#> max -0.003498 -0.02156 -0.04116 -0.042 -Inf -0.04200 -0.003498
#> 
#> $exp_residuals
#>    V1 V2 V3 V4 V5  freq         exp   std.res
#> 1   0  0  0  0  0   305   303.35909  0.094212
#> 2   0  0  0  0  1     1     1.59070 -0.468355
#> 3   0  0  0  1  0    10    10.01357 -0.004288
#> 4   0  0  0  1  1     1     0.09944  2.855908
#> 5   0  0  1  0  0    69    75.69118 -0.769095
#> 6   0  0  1  0  1     1     0.74601  0.294068
#> 7   0  0  1  1  0     6     5.00277  0.445850
#> 8   0  1  0  0  0   555   563.76618 -0.369199
#> 9   0  1  0  0  1     5     5.33442 -0.144794
#> 10  0  1  0  1  0    26    35.62707 -1.612888
#> 11  0  1  1  0  0   301   267.25573  2.064128
#> 12  0  1  1  0  1     5     4.74502  0.117056
#> 13  0  1  1  1  0    24    33.75373 -1.678842
#> 14  1  0  0  0  0  4448  4428.45603  0.293688
#> 15  1  0  0  0  1    50    46.26632  0.548914
#> 16  1  0  0  1  0   313   312.08185  0.051973
#> 17  1  0  0  1  1     3     6.16199 -1.273797
#> 18  1  0  1  0  0  2296  2338.08421 -0.870340
#> 19  1  0  1  0  1    61    45.82145  2.242310
#> 20  1  0  1  1  0   343   329.19648  0.760785
#> 21  1  0  1  1  1     8    12.18158 -1.198088
#> 22  1  1  0  0  0 16581 16591.28512 -0.079849
#> 23  1  1  0  0  1   295   312.20151 -0.973529
#> 24  1  1  0  1  0  2253  2233.83298  0.405536
#> 25  1  1  0  1  1    84    79.36676  0.520074
#> 26  1  1  1  0  0 16618 16608.98748  0.069932
#> 27  1  1  1  0  1   588   585.71481  0.094423
#> 28  1  1  1  1  0  4452  4463.69443 -0.175038
#> 29  1  1  1  1  1   298   297.82007  0.010426
#> 
#> $item_fit
#>   item  S_X2 df.S_X2 RMSEA.S_X2 p.S_X2
#> 1   V1 6.544       2      0.007  0.038
#> 2   V2 3.738       2      0.004  0.154
#> 3   V3 0.924       2      0.000  0.630
#> 4   V4 0.252       2      0.000  0.882
#> 5   V5 0.746       2      0.000  0.689
#> 
#> $g2_fit
#>     G2      p    TLI   CFI    RMSEA df    AIC    BIC  SABIC     HQ logLik logPrior SElogLik
#> 1 29.3 0.1069 0.9963 0.997 0.002812 21 178500 178588 178557 178528 -89240        0        0
#> 
#> $m2_fit
#>         M2 df     p RMSEA RMSEA_5 RMSEA_95 SRMSR   TLI   CFI
#> stats 9.61  5 0.087 0.004       0    0.008 0.003 0.997 0.998
#> 
report_irt(model=irt_twofactor,file="two_factors")
#> Q3 summary statistics:
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>   0.049   0.099   0.125   0.163   0.211   0.335 
#> 
#>       V1    V2    V3    V4    V5
#> V1 1.000 0.096 0.130 0.072 0.049
#> V2 0.096 1.000 0.335 0.226 0.121
#> V3 0.130 0.335 1.000 0.325 0.163
#> V4 0.072 0.226 0.325 1.000 0.111
#> V5 0.049 0.121 0.163 0.111 1.000
#> Warning: no non-missing arguments to min; returning Inf
#> Warning: no non-missing arguments to max; returning -Inf
#> Warning: no non-missing arguments to min; returning Inf
#> Warning: no non-missing arguments to max; returning -Inf
#> Data does not contain missing values. Continuing normally
#> Sample size after row-wise response data removal: 50000
#> $model_coefficients
#>         a1       a2         d g u
#> V1 -1.1018  0.88341  4.499278 0 1
#> V2 -0.9022  0.07262  1.925188 0 1
#> V3 -1.1082 -0.12840  0.006985 0 1
#> V4 -1.0193  0.41052 -2.048156 0 1
#> V5 -0.9164  0.00000 -3.933192 0 1
#> 
#> $model_coefficients_oblimin
#>      .id      a1       a2         d  g  u  x     F1     F2
#> V1 items -0.0306  1.43492  4.499278  0  1 NA     NA     NA
#> V2 items  0.7452  0.20124  1.925188  0  1 NA     NA     NA
#> V3 items  1.1728 -0.07842  0.006985  0  1 NA     NA     NA
#> V4 items  0.4531  0.71885 -2.048156  0  1 NA     NA     NA
#> V5 items  0.8442  0.09403 -3.933192  0  1 NA     NA     NA
#> 6  means      NA       NA        NA NA NA  0     NA     NA
#> 7  means      NA       NA        NA NA NA  0     NA     NA
#> 8    cov      NA       NA        NA NA NA NA 1.0000 0.7453
#> 9    cov      NA       NA        NA NA NA NA 0.7453 1.0000
#> 
#> $model_options
#>                       Options
#> method                     EM
#> draws                    5000
#> calcLL                   TRUE
#> SE                      FALSE
#> SE.type                 Oakes
#> verbose                 FALSE
#> SEtol                   0.001
#> storeEMhistory          FALSE
#> calcNull                 TRUE
#> odentype             Gaussian
#> dentype              Gaussian
#> zeroExtreme             FALSE
#> accelerate             Ramsay
#> Norder                      2
#> delta                 0.00001
#> Etable                   TRUE
#> plausible.draws             0
#> storeEtable              TRUE
#> TOL                    0.0001
#> omp_threads                 1
#> PLCI                    FALSE
#> warn                     TRUE
#> message                  TRUE
#> technical.symmetric      TRUE
#> technical.parallel       TRUE
#> technical.omp            TRUE
#> MAXQUAD                 20000
#> NCYCLES                   500
#> BURNIN                    150
#> SEMCYCLES                 100
#> SEM_from                    0
#> SEM_to                  0.999
#> KDRAWS                      1
#> MHDRAWS                     5
#> MHRM_SE_draws            2000
#> internal_constraints     TRUE
#> keep_vcov_PD             TRUE
#> theta_lim1                 -6
#> theta_lim2                  6
#> gain1                     0.1
#> gain2                    0.75
#> NULL.MODEL              FALSE
#> USEEM                    TRUE
#> returnPrepList          FALSE
#> Moptim                   BFGS
#> logLik_if_converged      TRUE
#> info_if_converged        TRUE
#> full                    FALSE
#> quadpts                    31
#> exploratory              TRUE
#> 
#> $model_call
#> [1] "NULL"
#> 
#> $q3_matrix
#>          V1     V2     V3     V4   V5     min     max
#> V1       NA     NA     NA     NA   NA      NA      NA
#> V2  0.09556     NA     NA     NA   NA 0.09556 0.09556
#> V3  0.12957 0.3347     NA     NA   NA 0.12957 0.33469
#> V4  0.07209 0.2264 0.3248     NA   NA 0.07209 0.32477
#> V5  0.04891 0.1212 0.1634 0.1107   NA 0.04891 0.16340
#> min 0.04891 0.1212 0.1634 0.1107  Inf 0.04891 0.09556
#> max 0.12957 0.3347 0.3248 0.1107 -Inf 0.12957 0.33469
#> 
#> $exp_residuals
#>    V1 V2 V3 V4 V5  freq         exp  std.res
#> 1   0  0  0  0  0   305   298.99064  0.34754
#> 2   0  0  0  0  1     1     1.67449 -0.52123
#> 3   0  0  0  1  0    10     7.65641  0.84697
#> 4   0  0  0  1  1     1     0.07827  3.29452
#> 5   0  0  1  0  0    69    79.69486 -1.19801
#> 6   0  0  1  0  1     1     0.87676  0.13162
#> 7   0  0  1  1  0     6     4.04001  0.97513
#> 8   0  1  0  0  0   555   562.31807 -0.30861
#> 9   0  1  0  0  1     5     5.42144 -0.18100
#> 10  0  1  0  1  0    26    26.70787 -0.13697
#> 11  0  1  1  0  0   301   287.83112  0.77621
#> 12  0  1  1  0  1     5     5.43978 -0.18856
#> 13  0  1  1  1  0    24    27.08968 -0.59362
#> 14  1  0  0  0  0  4448  4442.28505  0.08575
#> 15  1  0  0  0  1    50    47.06176  0.42831
#> 16  1  0  0  1  0   313   321.78634 -0.48981
#> 17  1  0  0  1  1     3     6.26901 -1.30562
#> 18  1  0  1  0  0  2296  2310.20859 -0.29561
#> 19  1  0  1  0  1    61    48.15865  1.85043
#> 20  1  0  1  1  0   343   333.24976  0.53411
#> 21  1  0  1  1  1     8    12.72686 -1.32499
#> 22  1  1  0  0  0 16581 16583.16247 -0.01679
#> 23  1  1  0  0  1   295   303.56829 -0.49177
#> 24  1  1  0  1  0  2253  2247.59256  0.11406
#> 25  1  1  0  1  1    84    75.30264  1.00226
#> 26  1  1  1  0  0 16618 16605.04869  0.10051
#> 27  1  1  1  0  1   588   597.06186 -0.37086
#> 28  1  1  1  1  0  4452  4462.52888 -0.15761
#> 29  1  1  1  1  1   298   294.67710  0.19357
#> 
#> $item_fit
#>   item  S_X2 df.S_X2 RMSEA.S_X2 p.S_X2
#> 1   V1   NaN       0        NaN    NaN
#> 2   V2 2.846       1      0.006  0.092
#> 3   V3 2.545       1      0.006  0.111
#> 4   V4 0.959       1      0.000  0.327
#> 5   V5 0.536       2      0.000  0.765
#> 
#> $g2_fit
#>      G2      p    TLI    CFI    RMSEA df    AIC    BIC  SABIC     HQ logLik logPrior SElogLik
#> 1 20.35 0.2567 0.9982 0.9988 0.001985 17 178499 178623 178578 178538 -89236        0        0
#> 
#> $m2_fit
#>          M2 df    p RMSEA RMSEA_5 RMSEA_95 SRMSR   TLI CFI
#> stats 0.031  1 0.86     0       0    0.006 0.001 1.003   1
#> 
report_irt(model=irt_threefactor,file="three_factors")
#> Q3 summary statistics:
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>   0.050   0.106   0.126   0.164   0.214   0.339 
#> 
#>       V1    V2    V3    V4    V5
#> V1 1.000 0.099 0.132 0.104 0.050
#> V2 0.099 1.000 0.295 0.232 0.112
#> V3 0.132 0.295 1.000 0.339 0.162
#> V4 0.104 0.232 0.339 1.000 0.119
#> V5 0.050 0.112 0.162 0.119 1.000
#> Warning: no non-missing arguments to min; returning Inf
#> Warning: no non-missing arguments to max; returning -Inf
#> Warning: no non-missing arguments to min; returning Inf
#> Warning: no non-missing arguments to max; returning -Inf
#> Data does not contain missing values. Continuing normally
#> Sample size after row-wise response data removal: 50000
#> $model_coefficients
#>         a1      a2      a3         d g u
#> V1 -4.1240 4.51446  5.3959 16.235542 0 1
#> V2 -0.9058 0.54128 -0.4518  2.060654 0 1
#> V3 -1.0271 0.03905 -0.1730  0.006835 0 1
#> V4 -0.9995 0.11428  0.0000 -1.995141 0 1
#> V5 -0.9396 0.00000  0.0000 -3.952170 0 1
#> 
#> $model_coefficients_oblimin
#>      .id       a1       a2       a3         d  g  u  x     F1     F2     F3
#> V1 items 0.005699  0.01011  8.14833 16.235542  0  1 NA     NA     NA     NA
#> V2 items 0.017266  1.12695  0.01711  2.060654  0  1 NA     NA     NA     NA
#> V3 items 0.979659  0.12596 -0.09645  0.006835  0  1 NA     NA     NA     NA
#> V4 items 0.908478  0.04810  0.11014 -1.995141  0  1 NA     NA     NA     NA
#> V5 items 1.008980 -0.10254  0.02583 -3.952170  0  1 NA     NA     NA     NA
#> 6  means       NA       NA       NA        NA NA NA  0     NA     NA     NA
#> 7  means       NA       NA       NA        NA NA NA  0     NA     NA     NA
#> 8  means       NA       NA       NA        NA NA NA  0     NA     NA     NA
#> 9    cov       NA       NA       NA        NA NA NA NA 1.0000 0.8189 0.4831
#> 10   cov       NA       NA       NA        NA NA NA NA 0.8189 1.0000 0.3830
#> 11   cov       NA       NA       NA        NA NA NA NA 0.4831 0.3830 1.0000
#> 
#> $model_options
#>                       Options
#> method                     EM
#> draws                    5000
#> calcLL                   TRUE
#> SE                      FALSE
#> SE.type                 Oakes
#> verbose                 FALSE
#> SEtol                   0.001
#> storeEMhistory          FALSE
#> calcNull                 TRUE
#> odentype             Gaussian
#> dentype              Gaussian
#> zeroExtreme             FALSE
#> accelerate             Ramsay
#> Norder                      2
#> delta                 0.00001
#> Etable                   TRUE
#> plausible.draws             0
#> storeEtable              TRUE
#> TOL                    0.0001
#> omp_threads                 1
#> PLCI                    FALSE
#> warn                     TRUE
#> message                  TRUE
#> technical.symmetric      TRUE
#> technical.parallel       TRUE
#> technical.omp            TRUE
#> MAXQUAD                 20000
#> NCYCLES                   500
#> BURNIN                    150
#> SEMCYCLES                 100
#> SEM_from                    0
#> SEM_to                  0.999
#> KDRAWS                      1
#> MHDRAWS                     5
#> MHRM_SE_draws            2000
#> internal_constraints     TRUE
#> keep_vcov_PD             TRUE
#> theta_lim1                 -6
#> theta_lim2                  6
#> gain1                     0.1
#> gain2                    0.75
#> NULL.MODEL              FALSE
#> USEEM                    TRUE
#> returnPrepList          FALSE
#> Moptim                   BFGS
#> logLik_if_converged      TRUE
#> info_if_converged        TRUE
#> full                    FALSE
#> quadpts                    15
#> exploratory              TRUE
#> 
#> $model_call
#> [1] "NULL"
#> 
#> $q3_matrix
#>          V1     V2     V3     V4   V5     min     max
#> V1       NA     NA     NA     NA   NA      NA      NA
#> V2  0.09922     NA     NA     NA   NA 0.09922 0.09922
#> V3  0.13232 0.2949     NA     NA   NA 0.13232 0.29486
#> V4  0.10438 0.2316 0.3391     NA   NA 0.10438 0.33907
#> V5  0.04996 0.1122 0.1619 0.1187   NA 0.04996 0.16186
#> min 0.04996 0.1122 0.1619 0.1187  Inf 0.04996 0.09922
#> max 0.13232 0.2949 0.3391 0.1187 -Inf 0.13232 0.33907
#> 
#> $exp_residuals
#>    V1 V2 V3 V4 V5  freq         exp   std.res
#> 1   0  0  0  0  0   305   295.24784  0.567555
#> 2   0  0  0  0  1     1     1.49283 -0.403356
#> 3   0  0  0  1  0    10     8.23627  0.614565
#> 4   0  0  0  1  1     1     0.07122  3.480127
#> 5   0  0  1  0  0    69    82.74123 -1.510653
#> 6   0  0  1  0  1     1     0.75791  0.278074
#> 7   0  0  1  1  0     6     4.25505  0.845920
#> 8   0  1  0  0  0   555   565.97169 -0.461186
#> 9   0  1  0  0  1     5     4.50817  0.231642
#> 10  0  1  0  1  0    26    26.46688 -0.090751
#> 11  0  1  1  0  0   301   289.21140  0.693194
#> 12  0  1  1  0  1     5     4.10673  0.440792
#> 13  0  1  1  1  0    24    24.54760 -0.110525
#> 14  1  0  0  0  0  4448  4445.21656  0.041748
#> 15  1  0  0  0  1    50    48.72538  0.182601
#> 16  1  0  0  1  0   313   326.08182 -0.724444
#> 17  1  0  0  1  1     3     6.69404 -1.427768
#> 18  1  0  1  0  0  2296  2300.88760 -0.101894
#> 19  1  0  1  0  1    61    48.06098  1.866402
#> 20  1  0  1  1  0   343   333.59763  0.514785
#> 21  1  0  1  1  1     8    12.98242 -1.382810
#> 22  1  1  0  0  0 16581 16577.05323  0.030654
#> 23  1  1  0  0  1   295   307.30589 -0.701984
#> 24  1  1  0  1  0  2253  2238.85833  0.298874
#> 25  1  1  0  1  1    84    78.00533  0.678739
#> 26  1  1  1  0  0 16618 16619.21850 -0.009452
#> 27  1  1  1  0  1   588   588.79187 -0.032634
#> 28  1  1  1  1  0  4452  4462.36353 -0.155141
#> 29  1  1  1  1  1   298   297.53892  0.026731
#> 
#> $item_fit
#>   item  S_X2 df.S_X2 RMSEA.S_X2 p.S_X2
#> 1   V1   NaN       0        NaN    NaN
#> 2   V2   NaN       0        NaN    NaN
#> 3   V3   NaN       0        NaN    NaN
#> 4   V4 0.852       1          0  0.356
#> 5   V5 0.345       2          0  0.842
#> 
#> $g2_fit
#>      G2      p    TLI    CFI   RMSEA df    AIC    BIC  SABIC     HQ logLik logPrior SElogLik
#> 1 20.26 0.1222 0.9958 0.9978 0.00299 14 178505 178655 178601 178552 -89236        0        0
#> 
#> $m2_fit
#> [1] "Error : Statistic cannot be calculated (too few degrees of freedom)\n"
#> attr(,"class")
#> [1] "try-error"
#> attr(,"condition")
#> <simpleError: Statistic cannot be calculated (too few degrees of freedom)>
#> 
```
