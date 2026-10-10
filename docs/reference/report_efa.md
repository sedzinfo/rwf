# Output EFA model

Output EFA model

## Usage

``` r
report_efa(
  model,
  df,
  file = NULL,
  w = 10,
  h = 5,
  cut = 0,
  base_size = 10,
  scores = FALSE
)
```

## Arguments

- model:

  psych EFA model

- df:

  dataframe

- file:

  output filename

- w:

  width of pdf file

- h:

  height of pdf file

- cut:

  cut point for loadings

- base_size:

  base font size

- scores:

  if TRUE it will output factor scores in excel file

## Note

Orthogonal=varimax, Oblique=oblimin

## Examples

``` r
model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="minres",oblique.scores=TRUE)
report_efa(model=model,df=mtcars,file="efa")




#> $correlation_loadings
#> 
#> $plot_barplot
#> 
#> $correlation_loadings
#> 
#> $plot_barplot
#> 
#> [[1]]

#> 

#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> [[1]]

#> 
#> $correlations
#>                          type       mpg           cyl      disp        hp      drat       wt     qsec       vs            am      gear     carb
#> mpg   reproduced correlations  0.852823 -0.8884146808 -0.873769 -0.768821  0.686482 -0.81533  0.44815  0.69572  0.5662638214  0.500723 -0.47287
#> cyl   reproduced correlations -0.888415  0.9357702443  0.904939  0.844320 -0.675159  0.82878 -0.54193 -0.76269 -0.5226064376 -0.449493  0.55638
#> disp  reproduced correlations -0.873769  0.9049385295  0.897960  0.765333 -0.723941  0.84596 -0.42046 -0.69325 -0.6148474388 -0.550190  0.45162
#> hp    reproduced correlations -0.768821  0.8443196149  0.765333  0.876451 -0.450036  0.64811 -0.72112 -0.78744 -0.2262826359 -0.146767  0.69565
#> drat  reproduced correlations  0.686482 -0.6751587018 -0.723941 -0.450036  0.708034 -0.73632  0.06876  0.41247  0.7174986941  0.683553 -0.13262
#> wt    reproduced correlations -0.815327  0.8287773365  0.845956  0.648112 -0.736318  0.82067 -0.27814 -0.58917 -0.6760709963 -0.623095  0.32441
#> qsec  reproduced correlations  0.448148 -0.5419313490 -0.420465 -0.721115  0.068757 -0.27814  0.78392  0.64274 -0.1939562742 -0.263731 -0.71433
#> vs    reproduced correlations  0.695716 -0.7626924007 -0.693252 -0.787439  0.412467 -0.58917  0.64274  0.70761  0.2135589724  0.142237 -0.62117
#> am    reproduced correlations  0.566264 -0.5226064376 -0.614847 -0.226283  0.717499 -0.67607 -0.19396  0.21356  0.8165109988  0.804660  0.10353
#> gear  reproduced correlations  0.500723 -0.4494934108 -0.550190 -0.146767  0.683553 -0.62310 -0.26373  0.14224  0.8046601612  0.800123  0.16989
#> carb  reproduced correlations -0.472869  0.5563784693  0.451619  0.695652 -0.132621  0.32441 -0.71433 -0.62117  0.1035312105  0.169885  0.65790
#> mpg1    observed correlations  1.000000 -0.8521619594 -0.847551 -0.776168  0.681172 -0.86766  0.41868  0.66404  0.5998324295  0.480285 -0.55093
#> cyl1    observed correlations -0.852162  1.0000000000  0.902033  0.832447 -0.699938  0.78250 -0.59124 -0.81081 -0.5226070469 -0.492687  0.52699
#> disp1   observed correlations -0.847551  0.9020328721  1.000000  0.790949 -0.710214  0.88798 -0.43370 -0.71042 -0.5912270401 -0.555569  0.39498
#> hp1     observed correlations -0.776168  0.8324474527  0.790949  1.000000 -0.448759  0.65875 -0.70822 -0.72310 -0.2432042572 -0.125704  0.74981
#> drat1   observed correlations  0.681172 -0.6999381138 -0.710214 -0.448759  1.000000 -0.71244  0.09120  0.44028  0.7127111272  0.699610 -0.09079
#> wt1     observed correlations -0.867659  0.7824957945  0.887980  0.658748 -0.712441  1.00000 -0.17472 -0.55492 -0.6924952588 -0.583287  0.42761
#> qsec1   observed correlations  0.418684 -0.5912420738 -0.433698 -0.708223  0.091205 -0.17472  1.00000  0.74454 -0.2298608622 -0.212682 -0.65625
#> vs1     observed correlations  0.664039 -0.8108117961 -0.710416 -0.723097  0.440278 -0.55492  0.74454  1.00000  0.1683451246  0.206023 -0.56961
#> am1     observed correlations  0.599832 -0.5226070469 -0.591227 -0.243204  0.712711 -0.69250 -0.22986  0.16835  1.0000000000  0.794059  0.05753
#> gear1   observed correlations  0.480285 -0.4926865994 -0.555569 -0.125704  0.699610 -0.58329 -0.21268  0.20602  0.7940587603  1.000000  0.27407
#> carb1   observed correlations -0.550925  0.5269882937  0.394977  0.749812 -0.090790  0.42761 -0.65625 -0.56961  0.0575343511  0.274073  1.00000
#> mpg2    residual correlations  0.147177  0.0362527213  0.026218 -0.007347 -0.005310 -0.05233 -0.02946 -0.03168  0.0335686081 -0.020439 -0.07806
#> cyl2    residual correlations  0.036253  0.0642297557 -0.002906 -0.011872 -0.024779 -0.04628 -0.04931 -0.04812 -0.0000006093 -0.043193 -0.02939
#> disp2   residual correlations  0.026218 -0.0029056573  0.102040  0.025615  0.013727  0.04202 -0.01323 -0.01716  0.0236203988 -0.005379 -0.05664
#> hp2     residual correlations -0.007347 -0.0118721621  0.025615  0.123549  0.001277  0.01064  0.01289  0.06434 -0.0169216212  0.021063  0.05416
#> drat2   residual correlations -0.005310 -0.0247794121  0.013727  0.001277  0.291966  0.02388  0.02245  0.02781 -0.0047875668  0.016057  0.04183
#> wt2     residual correlations -0.052333 -0.0462815420  0.042024  0.010635  0.023877  0.17933  0.10343  0.03426 -0.0164242626  0.039808  0.10320
#> qsec2   residual correlations -0.029464 -0.0493107248 -0.013233  0.012892  0.022448  0.10343  0.21608  0.10180 -0.0359045879  0.051048  0.05809
#> vs2     residual correlations -0.031677 -0.0481193954 -0.017164  0.064342  0.027811  0.03426  0.10180  0.29239 -0.0452138479  0.063787  0.05156
#> am2     residual correlations  0.033569 -0.0000006093  0.023620 -0.016922 -0.004788 -0.01642 -0.03590 -0.04521  0.1834890012 -0.010601 -0.04600
#> gear2   residual correlations -0.020439 -0.0431931885 -0.005379  0.021063  0.016057  0.03981  0.05105  0.06379 -0.0106014009  0.199877  0.10419
#> carb2   residual correlations -0.078056 -0.0293901755 -0.056642  0.054160  0.041831  0.10320  0.05809  0.05156 -0.0459968594  0.104188  0.34210
#> 
#> $npobs
#>      mpg cyl disp hp drat wt qsec vs am gear carb
#> mpg   32  32   32 32   32 32   32 32 32   32   32
#> cyl   32  32   32 32   32 32   32 32 32   32   32
#> disp  32  32   32 32   32 32   32 32 32   32   32
#> hp    32  32   32 32   32 32   32 32 32   32   32
#> drat  32  32   32 32   32 32   32 32 32   32   32
#> wt    32  32   32 32   32 32   32 32 32   32   32
#> qsec  32  32   32 32   32 32   32 32 32   32   32
#> vs    32  32   32 32   32 32   32 32 32   32   32
#> am    32  32   32 32   32 32   32 32 32   32   32
#> gear  32  32   32 32   32 32   32 32 32   32   32
#> carb  32  32   32 32   32 32   32 32 32   32   32
#> 
#> $residual_stats
#>                       residual_statistics    value critical                              formula
#> 1              Root Mean Squared Residual  0.04419       NA              sqrt(mean(residuals^2))
#> 2     Number of absolute residuals > 0.05 13.00000       NA                  abs(residuals)>0.05
#> 3 Proportion of absolute residuals > 0.05  0.23636      0.5 numberLargeResiduals/nrow(residuals)
#> 
#> $determinant_test
#>    determinant above_critical
#> 1 0.0000002057          FALSE
#> 
#> $bartlett_test
#>   x_squared[bartlett] df[bartlett]                                                  p[bartlett]
#> 1                 408           55 0.0000000000000000000000000000000000000000000000000000002227
#> 
#> $kmo_test
#>      Overall_MSA    MSA Kaiser_1974
#> mpg       0.8266 0.9276          NA
#> cyl       0.8266 0.8966          NA
#> disp      0.8266 0.7647          NA
#> hp        0.8266 0.8386          NA
#> drat      0.8266 0.9497          NA
#> wt        0.8266 0.7410          NA
#> qsec      0.8266 0.7401          NA
#> vs        0.8266 0.9067          NA
#> am        0.8266 0.8778          NA
#> gear      0.8266 0.8470          NA
#> carb      0.8266 0.6211          NA
#> 
#> $loadings
#>       Matrix variable     MR1     MR2               type row.names.model.Vaccounted.
#> 1    Pattern     qsec -0.9200 -0.3500               <NA>                        <NA>
#> 2    Pattern       hp  0.8900 -0.1200               <NA>                        <NA>
#> 3    Pattern     carb  0.8500  0.2400               <NA>                        <NA>
#> 4    Pattern       vs -0.8000  0.1200               <NA>                        <NA>
#> 5    Pattern      cyl  0.7100 -0.4800               <NA>                        <NA>
#> 6    Pattern      mpg -0.6100  0.5400               <NA>                        <NA>
#> 7    Pattern       am  0.1300  0.9300               <NA>                        <NA>
#> 8    Pattern     gear  0.2200  0.9300               <NA>                        <NA>
#> 9    Pattern     drat -0.1700  0.7800               <NA>                        <NA>
#> 10   Pattern       wt  0.4200 -0.7000               <NA>                        <NA>
#> 11   Pattern     disp  0.5800 -0.6000               <NA>                        <NA>
#> 12 Structure       hp  0.9300 -0.3800               <NA>                        <NA>
#> 13 Structure      cyl  0.8500 -0.6800               <NA>                        <NA>
#> 14 Structure       vs -0.8300  0.3500               <NA>                        <NA>
#> 15 Structure     qsec -0.8200 -0.0900               <NA>                        <NA>
#> 16 Structure     carb  0.7800  0.0000               <NA>                        <NA>
#> 17 Structure      mpg -0.7600  0.7200               <NA>                        <NA>
#> 18 Structure       am -0.1300  0.8900               <NA>                        <NA>
#> 19 Structure     gear -0.0400  0.8700               <NA>                        <NA>
#> 20 Structure     drat -0.3900  0.8300               <NA>                        <NA>
#> 21 Structure       wt  0.6100 -0.8100               <NA>                        <NA>
#> 22 Structure     disp  0.7500 -0.7700               <NA>                        <NA>
#> 23      <NA>     <NA>  4.7068  4.1509 variance accounted                 SS loadings
#> 24      <NA>     <NA>  0.4279  0.3774 variance accounted              Proportion Var
#> 25      <NA>     <NA>  0.4279  0.8053 variance accounted              Cumulative Var
#> 26      <NA>     <NA>  0.5314  0.4686 variance accounted        Proportion Explained
#> 27      <NA>     <NA>  0.5314  1.0000 variance accounted       Cumulative Proportion
#> 
#> $instruction_loading_critical_values
#>    sample critical_loading
#> 1      50             0.75
#> 2      60             0.70
#> 3      70             0.65
#> 4      85             0.60
#> 5     100             0.55
#> 6     120             0.50
#> 7     150             0.45
#> 8     200             0.40
#> 9     250             0.35
#> 10    350             0.30
#> 
#> $weights
#>           MR1      MR2
#> mpg  -0.12826  0.12270
#> cyl   0.44703 -0.08595
#> disp -0.23041 -0.46242
#> hp    0.39184  0.29700
#> drat  0.10511  0.15092
#> wt    0.22363  0.11141
#> qsec -0.24689 -0.27788
#> vs   -0.10199 -0.08728
#> am    0.21179  0.28057
#> gear  0.29637  0.32215
#> carb -0.06294 -0.05850
#> 
model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="uls",oblique.scores=TRUE)
report_efa(model=model,df=mtcars)






#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> [[1]]

#> 
#> $correlations
#>                          type       mpg           cyl      disp        hp      drat       wt     qsec       vs            am      gear     carb
#> mpg   reproduced correlations  0.852823 -0.8884146808 -0.873769 -0.768821  0.686482 -0.81533  0.44815  0.69572  0.5662638214  0.500723 -0.47287
#> cyl   reproduced correlations -0.888415  0.9357702443  0.904939  0.844320 -0.675159  0.82878 -0.54193 -0.76269 -0.5226064376 -0.449493  0.55638
#> disp  reproduced correlations -0.873769  0.9049385295  0.897960  0.765333 -0.723941  0.84596 -0.42046 -0.69325 -0.6148474388 -0.550190  0.45162
#> hp    reproduced correlations -0.768821  0.8443196149  0.765333  0.876451 -0.450036  0.64811 -0.72112 -0.78744 -0.2262826359 -0.146767  0.69565
#> drat  reproduced correlations  0.686482 -0.6751587018 -0.723941 -0.450036  0.708034 -0.73632  0.06876  0.41247  0.7174986941  0.683553 -0.13262
#> wt    reproduced correlations -0.815327  0.8287773365  0.845956  0.648112 -0.736318  0.82067 -0.27814 -0.58917 -0.6760709963 -0.623095  0.32441
#> qsec  reproduced correlations  0.448148 -0.5419313490 -0.420465 -0.721115  0.068757 -0.27814  0.78392  0.64274 -0.1939562742 -0.263731 -0.71433
#> vs    reproduced correlations  0.695716 -0.7626924007 -0.693252 -0.787439  0.412467 -0.58917  0.64274  0.70761  0.2135589724  0.142237 -0.62117
#> am    reproduced correlations  0.566264 -0.5226064376 -0.614847 -0.226283  0.717499 -0.67607 -0.19396  0.21356  0.8165109988  0.804660  0.10353
#> gear  reproduced correlations  0.500723 -0.4494934108 -0.550190 -0.146767  0.683553 -0.62310 -0.26373  0.14224  0.8046601612  0.800123  0.16989
#> carb  reproduced correlations -0.472869  0.5563784693  0.451619  0.695652 -0.132621  0.32441 -0.71433 -0.62117  0.1035312105  0.169885  0.65790
#> mpg1    observed correlations  1.000000 -0.8521619594 -0.847551 -0.776168  0.681172 -0.86766  0.41868  0.66404  0.5998324295  0.480285 -0.55093
#> cyl1    observed correlations -0.852162  1.0000000000  0.902033  0.832447 -0.699938  0.78250 -0.59124 -0.81081 -0.5226070469 -0.492687  0.52699
#> disp1   observed correlations -0.847551  0.9020328721  1.000000  0.790949 -0.710214  0.88798 -0.43370 -0.71042 -0.5912270401 -0.555569  0.39498
#> hp1     observed correlations -0.776168  0.8324474527  0.790949  1.000000 -0.448759  0.65875 -0.70822 -0.72310 -0.2432042572 -0.125704  0.74981
#> drat1   observed correlations  0.681172 -0.6999381138 -0.710214 -0.448759  1.000000 -0.71244  0.09120  0.44028  0.7127111272  0.699610 -0.09079
#> wt1     observed correlations -0.867659  0.7824957945  0.887980  0.658748 -0.712441  1.00000 -0.17472 -0.55492 -0.6924952588 -0.583287  0.42761
#> qsec1   observed correlations  0.418684 -0.5912420738 -0.433698 -0.708223  0.091205 -0.17472  1.00000  0.74454 -0.2298608622 -0.212682 -0.65625
#> vs1     observed correlations  0.664039 -0.8108117961 -0.710416 -0.723097  0.440278 -0.55492  0.74454  1.00000  0.1683451246  0.206023 -0.56961
#> am1     observed correlations  0.599832 -0.5226070469 -0.591227 -0.243204  0.712711 -0.69250 -0.22986  0.16835  1.0000000000  0.794059  0.05753
#> gear1   observed correlations  0.480285 -0.4926865994 -0.555569 -0.125704  0.699610 -0.58329 -0.21268  0.20602  0.7940587603  1.000000  0.27407
#> carb1   observed correlations -0.550925  0.5269882937  0.394977  0.749812 -0.090790  0.42761 -0.65625 -0.56961  0.0575343511  0.274073  1.00000
#> mpg2    residual correlations  0.147177  0.0362527213  0.026218 -0.007347 -0.005310 -0.05233 -0.02946 -0.03168  0.0335686081 -0.020439 -0.07806
#> cyl2    residual correlations  0.036253  0.0642297557 -0.002906 -0.011872 -0.024779 -0.04628 -0.04931 -0.04812 -0.0000006093 -0.043193 -0.02939
#> disp2   residual correlations  0.026218 -0.0029056573  0.102040  0.025615  0.013727  0.04202 -0.01323 -0.01716  0.0236203988 -0.005379 -0.05664
#> hp2     residual correlations -0.007347 -0.0118721621  0.025615  0.123549  0.001277  0.01064  0.01289  0.06434 -0.0169216212  0.021063  0.05416
#> drat2   residual correlations -0.005310 -0.0247794121  0.013727  0.001277  0.291966  0.02388  0.02245  0.02781 -0.0047875668  0.016057  0.04183
#> wt2     residual correlations -0.052333 -0.0462815420  0.042024  0.010635  0.023877  0.17933  0.10343  0.03426 -0.0164242626  0.039808  0.10320
#> qsec2   residual correlations -0.029464 -0.0493107248 -0.013233  0.012892  0.022448  0.10343  0.21608  0.10180 -0.0359045879  0.051048  0.05809
#> vs2     residual correlations -0.031677 -0.0481193954 -0.017164  0.064342  0.027811  0.03426  0.10180  0.29239 -0.0452138479  0.063787  0.05156
#> am2     residual correlations  0.033569 -0.0000006093  0.023620 -0.016922 -0.004788 -0.01642 -0.03590 -0.04521  0.1834890012 -0.010601 -0.04600
#> gear2   residual correlations -0.020439 -0.0431931885 -0.005379  0.021063  0.016057  0.03981  0.05105  0.06379 -0.0106014009  0.199877  0.10419
#> carb2   residual correlations -0.078056 -0.0293901755 -0.056642  0.054160  0.041831  0.10320  0.05809  0.05156 -0.0459968594  0.104188  0.34210
#> 
#> $npobs
#>      mpg cyl disp hp drat wt qsec vs am gear carb
#> mpg   32  32   32 32   32 32   32 32 32   32   32
#> cyl   32  32   32 32   32 32   32 32 32   32   32
#> disp  32  32   32 32   32 32   32 32 32   32   32
#> hp    32  32   32 32   32 32   32 32 32   32   32
#> drat  32  32   32 32   32 32   32 32 32   32   32
#> wt    32  32   32 32   32 32   32 32 32   32   32
#> qsec  32  32   32 32   32 32   32 32 32   32   32
#> vs    32  32   32 32   32 32   32 32 32   32   32
#> am    32  32   32 32   32 32   32 32 32   32   32
#> gear  32  32   32 32   32 32   32 32 32   32   32
#> carb  32  32   32 32   32 32   32 32 32   32   32
#> 
#> $residual_stats
#>                       residual_statistics    value critical                              formula
#> 1              Root Mean Squared Residual  0.04419       NA              sqrt(mean(residuals^2))
#> 2     Number of absolute residuals > 0.05 13.00000       NA                  abs(residuals)>0.05
#> 3 Proportion of absolute residuals > 0.05  0.23636      0.5 numberLargeResiduals/nrow(residuals)
#> 
#> $determinant_test
#>    determinant above_critical
#> 1 0.0000002057          FALSE
#> 
#> $bartlett_test
#>   x_squared[bartlett] df[bartlett]                                                  p[bartlett]
#> 1                 408           55 0.0000000000000000000000000000000000000000000000000000002227
#> 
#> $kmo_test
#>      Overall_MSA    MSA Kaiser_1974
#> mpg       0.8266 0.9276          NA
#> cyl       0.8266 0.8966          NA
#> disp      0.8266 0.7647          NA
#> hp        0.8266 0.8386          NA
#> drat      0.8266 0.9497          NA
#> wt        0.8266 0.7410          NA
#> qsec      0.8266 0.7401          NA
#> vs        0.8266 0.9067          NA
#> am        0.8266 0.8778          NA
#> gear      0.8266 0.8470          NA
#> carb      0.8266 0.6211          NA
#> 
#> $loadings
#>       Matrix variable    ULS2    ULS1               type row.names.model.Vaccounted.
#> 1    Pattern     qsec -0.9200 -0.3500               <NA>                        <NA>
#> 2    Pattern       hp  0.8900 -0.1200               <NA>                        <NA>
#> 3    Pattern     carb  0.8500  0.2400               <NA>                        <NA>
#> 4    Pattern       vs -0.8000  0.1200               <NA>                        <NA>
#> 5    Pattern      cyl  0.7100 -0.4800               <NA>                        <NA>
#> 6    Pattern      mpg -0.6100  0.5400               <NA>                        <NA>
#> 7    Pattern       am  0.1300  0.9300               <NA>                        <NA>
#> 8    Pattern     gear  0.2200  0.9300               <NA>                        <NA>
#> 9    Pattern     drat -0.1700  0.7800               <NA>                        <NA>
#> 10   Pattern       wt  0.4200 -0.7000               <NA>                        <NA>
#> 11   Pattern     disp  0.5800 -0.6000               <NA>                        <NA>
#> 12 Structure       hp  0.9300 -0.3800               <NA>                        <NA>
#> 13 Structure      cyl  0.8500 -0.6800               <NA>                        <NA>
#> 14 Structure       vs -0.8300  0.3500               <NA>                        <NA>
#> 15 Structure     qsec -0.8200 -0.0900               <NA>                        <NA>
#> 16 Structure     carb  0.7800  0.0000               <NA>                        <NA>
#> 17 Structure      mpg -0.7600  0.7200               <NA>                        <NA>
#> 18 Structure       am -0.1300  0.8900               <NA>                        <NA>
#> 19 Structure     gear -0.0400  0.8700               <NA>                        <NA>
#> 20 Structure     drat -0.3900  0.8300               <NA>                        <NA>
#> 21 Structure       wt  0.6100 -0.8100               <NA>                        <NA>
#> 22 Structure     disp  0.7500 -0.7700               <NA>                        <NA>
#> 23      <NA>     <NA>  4.7069  4.1509 variance accounted                 SS loadings
#> 24      <NA>     <NA>  0.4279  0.3774 variance accounted              Proportion Var
#> 25      <NA>     <NA>  0.4279  0.8053 variance accounted              Cumulative Var
#> 26      <NA>     <NA>  0.5314  0.4686 variance accounted        Proportion Explained
#> 27      <NA>     <NA>  0.5314  1.0000 variance accounted       Cumulative Proportion
#> 
#> $instruction_loading_critical_values
#>    sample critical_loading
#> 1      50             0.75
#> 2      60             0.70
#> 3      70             0.65
#> 4      85             0.60
#> 5     100             0.55
#> 6     120             0.50
#> 7     150             0.45
#> 8     200             0.40
#> 9     250             0.35
#> 10    350             0.30
#> 
#> $weights
#>          ULS2     ULS1
#> mpg  -0.12826  0.12270
#> cyl   0.44703 -0.08595
#> disp -0.23041 -0.46243
#> hp    0.39184  0.29700
#> drat  0.10510  0.15093
#> wt    0.22363  0.11141
#> qsec -0.24689 -0.27788
#> vs   -0.10199 -0.08729
#> am    0.21179  0.28057
#> gear  0.29636  0.32215
#> carb -0.06294 -0.05850
#> 
model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="ols",oblique.scores=TRUE)
report_efa(model=model,df=mtcars)






#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> [[1]]

#> 
#> $correlations
#>                          type       mpg           cyl      disp        hp      drat       wt     qsec       vs            am      gear     carb
#> mpg   reproduced correlations  0.852823 -0.8884143060 -0.873769 -0.768821  0.686481 -0.81533  0.44815  0.69572  0.5662636845  0.500723 -0.47287
#> cyl   reproduced correlations -0.888414  0.9357700096  0.904938  0.844320 -0.675159  0.82878 -0.54193 -0.76269 -0.5226064484 -0.449493  0.55638
#> disp  reproduced correlations -0.873769  0.9049382824  0.897960  0.765333 -0.723941  0.84596 -0.42046 -0.69325 -0.6148473484 -0.550190  0.45162
#> hp    reproduced correlations -0.768821  0.8443195096  0.765333  0.876451 -0.450037  0.64811 -0.72112 -0.78744 -0.2262827617 -0.146767  0.69565
#> drat  reproduced correlations  0.686481 -0.6751585946 -0.723941 -0.450037  0.708034 -0.73632  0.06876  0.41247  0.7174984685  0.683553 -0.13262
#> wt    reproduced correlations -0.815326  0.8287770200  0.845955  0.648112 -0.736318  0.82067 -0.27814 -0.58917 -0.6760707159 -0.623095  0.32441
#> qsec  reproduced correlations  0.448148 -0.5419313034 -0.420465 -0.721115  0.068757 -0.27814  0.78392  0.64274 -0.1939562582 -0.263731 -0.71433
#> vs    reproduced correlations  0.695716 -0.7626925196 -0.693252 -0.787439  0.412467 -0.58917  0.64274  0.70761  0.2135590316  0.142237 -0.62117
#> am    reproduced correlations  0.566264 -0.5226064484 -0.614847 -0.226283  0.717498 -0.67607 -0.19396  0.21356  0.8165108101  0.804660  0.10353
#> gear  reproduced correlations  0.500723 -0.4494934932 -0.550190 -0.146767  0.683553 -0.62310 -0.26373  0.14224  0.8046601408  0.800123  0.16988
#> carb  reproduced correlations -0.472868  0.5563783015  0.451618  0.695652 -0.132621  0.32441 -0.71433 -0.62117  0.1035310367  0.169885  0.65790
#> mpg1    observed correlations  1.000000 -0.8521619594 -0.847551 -0.776168  0.681172 -0.86766  0.41868  0.66404  0.5998324295  0.480285 -0.55093
#> cyl1    observed correlations -0.852162  1.0000000000  0.902033  0.832447 -0.699938  0.78250 -0.59124 -0.81081 -0.5226070469 -0.492687  0.52699
#> disp1   observed correlations -0.847551  0.9020328721  1.000000  0.790949 -0.710214  0.88798 -0.43370 -0.71042 -0.5912270401 -0.555569  0.39498
#> hp1     observed correlations -0.776168  0.8324474527  0.790949  1.000000 -0.448759  0.65875 -0.70822 -0.72310 -0.2432042572 -0.125704  0.74981
#> drat1   observed correlations  0.681172 -0.6999381138 -0.710214 -0.448759  1.000000 -0.71244  0.09120  0.44028  0.7127111272  0.699610 -0.09079
#> wt1     observed correlations -0.867659  0.7824957945  0.887980  0.658748 -0.712441  1.00000 -0.17472 -0.55492 -0.6924952588 -0.583287  0.42761
#> qsec1   observed correlations  0.418684 -0.5912420738 -0.433698 -0.708223  0.091205 -0.17472  1.00000  0.74454 -0.2298608622 -0.212682 -0.65625
#> vs1     observed correlations  0.664039 -0.8108117961 -0.710416 -0.723097  0.440278 -0.55492  0.74454  1.00000  0.1683451246  0.206023 -0.56961
#> am1     observed correlations  0.599832 -0.5226070469 -0.591227 -0.243204  0.712711 -0.69250 -0.22986  0.16835  1.0000000000  0.794059  0.05753
#> gear1   observed correlations  0.480285 -0.4926865994 -0.555569 -0.125704  0.699610 -0.58329 -0.21268  0.20602  0.7940587603  1.000000  0.27407
#> carb1   observed correlations -0.550925  0.5269882937  0.394977  0.749812 -0.090790  0.42761 -0.65625 -0.56961  0.0575343511  0.274073  1.00000
#> mpg2    residual correlations  0.147177  0.0362523465  0.026218 -0.007347 -0.005309 -0.05233 -0.02946 -0.03168  0.0335687449 -0.020438 -0.07806
#> cyl2    residual correlations  0.036252  0.0642299904 -0.002905 -0.011872 -0.024780 -0.04628 -0.04931 -0.04812 -0.0000005985 -0.043193 -0.02939
#> disp2   residual correlations  0.026218 -0.0029054103  0.102040  0.025616  0.013727  0.04202 -0.01323 -0.01716  0.0236203084 -0.005379 -0.05664
#> hp2     residual correlations -0.007347 -0.0118720568  0.025616  0.123549  0.001277  0.01064  0.01289  0.06434 -0.0169214954  0.021063  0.05416
#> drat2   residual correlations -0.005309 -0.0247795192  0.013727  0.001277  0.291966  0.02388  0.02245  0.02781 -0.0047873413  0.016057  0.04183
#> wt2     residual correlations -0.052333 -0.0462812255  0.042025  0.010636  0.023877  0.17933  0.10343  0.03426 -0.0164245429  0.039808  0.10320
#> qsec2   residual correlations -0.029464 -0.0493107703 -0.013233  0.012892  0.022448  0.10343  0.21608  0.10180 -0.0359046039  0.051049  0.05809
#> vs2     residual correlations -0.031677 -0.0481192764 -0.017164  0.064342  0.027811  0.03426  0.10180  0.29239 -0.0452139070  0.063787  0.05156
#> am2     residual correlations  0.033569 -0.0000005985  0.023620 -0.016921 -0.004787 -0.01642 -0.03590 -0.04521  0.1834891899 -0.010601 -0.04600
#> gear2   residual correlations -0.020438 -0.0431931062 -0.005379  0.021063  0.016057  0.03981  0.05105  0.06379 -0.0106013806  0.199877  0.10419
#> carb2   residual correlations -0.078057 -0.0293900077 -0.056642  0.054160  0.041831  0.10320  0.05809  0.05156 -0.0459966857  0.104188  0.34210
#> 
#> $npobs
#>      mpg cyl disp hp drat wt qsec vs am gear carb
#> mpg   32  32   32 32   32 32   32 32 32   32   32
#> cyl   32  32   32 32   32 32   32 32 32   32   32
#> disp  32  32   32 32   32 32   32 32 32   32   32
#> hp    32  32   32 32   32 32   32 32 32   32   32
#> drat  32  32   32 32   32 32   32 32 32   32   32
#> wt    32  32   32 32   32 32   32 32 32   32   32
#> qsec  32  32   32 32   32 32   32 32 32   32   32
#> vs    32  32   32 32   32 32   32 32 32   32   32
#> am    32  32   32 32   32 32   32 32 32   32   32
#> gear  32  32   32 32   32 32   32 32 32   32   32
#> carb  32  32   32 32   32 32   32 32 32   32   32
#> 
#> $residual_stats
#>                       residual_statistics    value critical                              formula
#> 1              Root Mean Squared Residual  0.04419       NA              sqrt(mean(residuals^2))
#> 2     Number of absolute residuals > 0.05 13.00000       NA                  abs(residuals)>0.05
#> 3 Proportion of absolute residuals > 0.05  0.23636      0.5 numberLargeResiduals/nrow(residuals)
#> 
#> $determinant_test
#>    determinant above_critical
#> 1 0.0000002057          FALSE
#> 
#> $bartlett_test
#>   x_squared[bartlett] df[bartlett]                                                  p[bartlett]
#> 1                 408           55 0.0000000000000000000000000000000000000000000000000000002227
#> 
#> $kmo_test
#>      Overall_MSA    MSA Kaiser_1974
#> mpg       0.8266 0.9276          NA
#> cyl       0.8266 0.8966          NA
#> disp      0.8266 0.7647          NA
#> hp        0.8266 0.8386          NA
#> drat      0.8266 0.9497          NA
#> wt        0.8266 0.7410          NA
#> qsec      0.8266 0.7401          NA
#> vs        0.8266 0.9067          NA
#> am        0.8266 0.8778          NA
#> gear      0.8266 0.8470          NA
#> carb      0.8266 0.6211          NA
#> 
#> $loadings
#>       Matrix variable      X1      X2               type row.names.model.Vaccounted.
#> 1    Pattern     qsec -0.9200 -0.3500               <NA>                        <NA>
#> 2    Pattern       hp  0.8900 -0.1200               <NA>                        <NA>
#> 3    Pattern     carb  0.8500  0.2400               <NA>                        <NA>
#> 4    Pattern       vs -0.8000  0.1200               <NA>                        <NA>
#> 5    Pattern      cyl  0.7100 -0.4800               <NA>                        <NA>
#> 6    Pattern      mpg -0.6100  0.5400               <NA>                        <NA>
#> 7    Pattern       am  0.1300  0.9300               <NA>                        <NA>
#> 8    Pattern     gear  0.2200  0.9300               <NA>                        <NA>
#> 9    Pattern     drat -0.1700  0.7800               <NA>                        <NA>
#> 10   Pattern       wt  0.4200 -0.7000               <NA>                        <NA>
#> 11   Pattern     disp  0.5800 -0.6000               <NA>                        <NA>
#> 12 Structure       hp  0.9300 -0.3800               <NA>                        <NA>
#> 13 Structure      cyl  0.8500 -0.6800               <NA>                        <NA>
#> 14 Structure       vs -0.8300  0.3500               <NA>                        <NA>
#> 15 Structure     qsec -0.8200 -0.0900               <NA>                        <NA>
#> 16 Structure     carb  0.7800  0.0000               <NA>                        <NA>
#> 17 Structure      mpg -0.7600  0.7200               <NA>                        <NA>
#> 18 Structure       am -0.1300  0.8900               <NA>                        <NA>
#> 19 Structure     gear -0.0400  0.8700               <NA>                        <NA>
#> 20 Structure     drat -0.3900  0.8300               <NA>                        <NA>
#> 21 Structure       wt  0.6100 -0.8100               <NA>                        <NA>
#> 22 Structure     disp  0.7500 -0.7700               <NA>                        <NA>
#> 23      <NA>     <NA>  4.7069  4.1509 variance accounted                 SS loadings
#> 24      <NA>     <NA>  0.4279  0.3774 variance accounted              Proportion Var
#> 25      <NA>     <NA>  0.4279  0.8053 variance accounted              Cumulative Var
#> 26      <NA>     <NA>  0.5314  0.4686 variance accounted        Proportion Explained
#> 27      <NA>     <NA>  0.5314  1.0000 variance accounted       Cumulative Proportion
#> 
#> $instruction_loading_critical_values
#>    sample critical_loading
#> 1      50             0.75
#> 2      60             0.70
#> 3      70             0.65
#> 4      85             0.60
#> 5     100             0.55
#> 6     120             0.50
#> 7     150             0.45
#> 8     200             0.40
#> 9     250             0.35
#> 10    350             0.30
#> 
#> $weights
#>          [,1]     [,2]
#> mpg  -0.12826  0.12270
#> cyl   0.44703 -0.08595
#> disp -0.23041 -0.46243
#> hp    0.39185  0.29700
#> drat  0.10510  0.15092
#> wt    0.22363  0.11142
#> qsec -0.24689 -0.27788
#> vs   -0.10199 -0.08728
#> am    0.21179  0.28057
#> gear  0.29636  0.32215
#> carb -0.06294 -0.05850
#> 
model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="wls",oblique.scores=TRUE)
report_efa(model=model,df=mtcars)






#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> [[1]]

#> 
#> $correlations
#>                          type      mpg        cyl     disp         hp      drat       wt      qsec       vs        am      gear     carb
#> mpg   reproduced correlations  0.84978 -0.8820571 -0.86177 -0.7623918  0.691675 -0.80474  0.445250  0.70148  0.564761  0.497727 -0.47265
#> cyl   reproduced correlations -0.88206  0.9254161  0.88952  0.8329133 -0.677753  0.81583 -0.533876 -0.76602 -0.520211 -0.446436  0.55280
#> disp  reproduced correlations -0.86177  0.8895151  0.87645  0.7521300 -0.721754  0.82594 -0.415270 -0.69221 -0.606099 -0.540241  0.44787
#> hp    reproduced correlations -0.76239  0.8329133  0.75213  0.8592082 -0.451132  0.63989 -0.701769 -0.78910 -0.228477 -0.150654  0.68624
#> drat  reproduced correlations  0.69168 -0.6777531 -0.72175 -0.4511315  0.726775 -0.73439  0.070124  0.41650  0.728659  0.691194 -0.13120
#> wt    reproduced correlations -0.80474  0.8158284  0.82594  0.6398865 -0.734386  0.80055 -0.280011 -0.58945 -0.665170 -0.609974  0.32475
#> qsec  reproduced correlations  0.44525 -0.5338764 -0.41527 -0.7017691  0.070124 -0.28001  0.754864  0.64318 -0.184073 -0.249704 -0.70002
#> vs    reproduced correlations  0.70148 -0.7660214 -0.69221 -0.7890992  0.416504 -0.58945  0.643177  0.72472  0.212547  0.141089 -0.62922
#> am    reproduced correlations  0.56476 -0.5202105 -0.60610 -0.2284775  0.728659 -0.66517 -0.184073  0.21255  0.817045  0.800571  0.10218
#> gear  reproduced correlations  0.49773 -0.4464355 -0.54024 -0.1506539  0.691194 -0.60997 -0.249704  0.14109  0.800571  0.791169  0.16593
#> carb  reproduced correlations -0.47265  0.5528000  0.44787  0.6862405 -0.131203  0.32475 -0.700020 -0.62922  0.102182  0.165927  0.65524
#> mpg1    observed correlations  1.00000 -0.8521620 -0.84755 -0.7761684  0.681172 -0.86766  0.418684  0.66404  0.599832  0.480285 -0.55093
#> cyl1    observed correlations -0.85216  1.0000000  0.90203  0.8324475 -0.699938  0.78250 -0.591242 -0.81081 -0.522607 -0.492687  0.52699
#> disp1   observed correlations -0.84755  0.9020329  1.00000  0.7909486 -0.710214  0.88798 -0.433698 -0.71042 -0.591227 -0.555569  0.39498
#> hp1     observed correlations -0.77617  0.8324475  0.79095  1.0000000 -0.448759  0.65875 -0.708223 -0.72310 -0.243204 -0.125704  0.74981
#> drat1   observed correlations  0.68117 -0.6999381 -0.71021 -0.4487591  1.000000 -0.71244  0.091205  0.44028  0.712711  0.699610 -0.09079
#> wt1     observed correlations -0.86766  0.7824958  0.88798  0.6587479 -0.712441  1.00000 -0.174716 -0.55492 -0.692495 -0.583287  0.42761
#> qsec1   observed correlations  0.41868 -0.5912421 -0.43370 -0.7082234  0.091205 -0.17472  1.000000  0.74454 -0.229861 -0.212682 -0.65625
#> vs1     observed correlations  0.66404 -0.8108118 -0.71042 -0.7230967  0.440278 -0.55492  0.744535  1.00000  0.168345  0.206023 -0.56961
#> am1     observed correlations  0.59983 -0.5226070 -0.59123 -0.2432043  0.712711 -0.69250 -0.229861  0.16835  1.000000  0.794059  0.05753
#> gear1   observed correlations  0.48028 -0.4926866 -0.55557 -0.1257043  0.699610 -0.58329 -0.212682  0.20602  0.794059  1.000000  0.27407
#> carb1   observed correlations -0.55093  0.5269883  0.39498  0.7498125 -0.090790  0.42761 -0.656249 -0.56961  0.057534  0.274073  1.00000
#> mpg2    residual correlations  0.15022  0.0298951  0.01422 -0.0137765 -0.010503 -0.06292 -0.026566 -0.03744  0.035071 -0.017443 -0.07828
#> cyl2    residual correlations  0.02990  0.0745839  0.01252 -0.0004659 -0.022185 -0.03333 -0.057366 -0.04479 -0.002397 -0.046251 -0.02581
#> disp2   residual correlations  0.01422  0.0125178  0.12355  0.0388186  0.011540  0.06204 -0.018428 -0.01820  0.014872 -0.015329 -0.05289
#> hp2     residual correlations -0.01378 -0.0004659  0.03882  0.1407918  0.002372  0.01886 -0.006454  0.06600 -0.014727  0.024950  0.06357
#> drat2   residual correlations -0.01050 -0.0221850  0.01154  0.0023724  0.273225  0.02195  0.021081  0.02377 -0.015948  0.008416  0.04041
#> wt2     residual correlations -0.06292 -0.0333326  0.06204  0.0188614  0.021945  0.19945  0.105295  0.03453 -0.027325  0.026687  0.10286
#> qsec2   residual correlations -0.02657 -0.0573656 -0.01843 -0.0064543  0.021081  0.10530  0.245136  0.10136 -0.045788  0.037022  0.04377
#> vs2     residual correlations -0.03744 -0.0447904 -0.01820  0.0660025  0.023775  0.03453  0.101358  0.27528 -0.044202  0.064935  0.05962
#> am2     residual correlations  0.03507 -0.0023965  0.01487 -0.0147268 -0.015948 -0.02732 -0.045788 -0.04420  0.182955 -0.006512 -0.04465
#> gear2   residual correlations -0.01744 -0.0462511 -0.01533  0.0249496  0.008416  0.02669  0.037022  0.06493 -0.006512  0.208831  0.10815
#> carb2   residual correlations -0.07828 -0.0258117 -0.05289  0.0635719  0.040413  0.10286  0.043770  0.05962 -0.044647  0.108146  0.34476
#> 
#> $npobs
#>      mpg cyl disp hp drat wt qsec vs am gear carb
#> mpg   32  32   32 32   32 32   32 32 32   32   32
#> cyl   32  32   32 32   32 32   32 32 32   32   32
#> disp  32  32   32 32   32 32   32 32 32   32   32
#> hp    32  32   32 32   32 32   32 32 32   32   32
#> drat  32  32   32 32   32 32   32 32 32   32   32
#> wt    32  32   32 32   32 32   32 32 32   32   32
#> qsec  32  32   32 32   32 32   32 32 32   32   32
#> vs    32  32   32 32   32 32   32 32 32   32   32
#> am    32  32   32 32   32 32   32 32 32   32   32
#> gear  32  32   32 32   32 32   32 32 32   32   32
#> carb  32  32   32 32   32 32   32 32 32   32   32
#> 
#> $residual_stats
#>                       residual_statistics    value critical                              formula
#> 1              Root Mean Squared Residual  0.04491       NA              sqrt(mean(residuals^2))
#> 2     Number of absolute residuals > 0.05 13.00000       NA                  abs(residuals)>0.05
#> 3 Proportion of absolute residuals > 0.05  0.23636      0.5 numberLargeResiduals/nrow(residuals)
#> 
#> $determinant_test
#>    determinant above_critical
#> 1 0.0000002057          FALSE
#> 
#> $bartlett_test
#>   x_squared[bartlett] df[bartlett]                                                  p[bartlett]
#> 1                 408           55 0.0000000000000000000000000000000000000000000000000000002227
#> 
#> $kmo_test
#>      Overall_MSA    MSA Kaiser_1974
#> mpg       0.8266 0.9276          NA
#> cyl       0.8266 0.8966          NA
#> disp      0.8266 0.7647          NA
#> hp        0.8266 0.8386          NA
#> drat      0.8266 0.9497          NA
#> wt        0.8266 0.7410          NA
#> qsec      0.8266 0.7401          NA
#> vs        0.8266 0.9067          NA
#> am        0.8266 0.8778          NA
#> gear      0.8266 0.8470          NA
#> carb      0.8266 0.6211          NA
#> 
#> $loadings
#>       Matrix variable    WLS1    WLS2               type row.names.model.Vaccounted.
#> 1    Pattern     qsec -0.9000 -0.3500               <NA>                        <NA>
#> 2    Pattern       hp  0.8900 -0.1100               <NA>                        <NA>
#> 3    Pattern     carb  0.8400  0.2500               <NA>                        <NA>
#> 4    Pattern       vs -0.8200  0.1000               <NA>                        <NA>
#> 5    Pattern      cyl  0.7200 -0.4600               <NA>                        <NA>
#> 6    Pattern      mpg -0.6200  0.5300               <NA>                        <NA>
#> 7    Pattern     disp  0.5900 -0.5800               <NA>                        <NA>
#> 8    Pattern       am  0.1200  0.9300               <NA>                        <NA>
#> 9    Pattern     gear  0.2000  0.9300               <NA>                        <NA>
#> 10   Pattern     drat -0.1800  0.7800               <NA>                        <NA>
#> 11   Pattern       wt  0.4300 -0.6700               <NA>                        <NA>
#> 12 Structure       hp  0.9200 -0.3600               <NA>                        <NA>
#> 13 Structure      cyl  0.8600 -0.6700               <NA>                        <NA>
#> 14 Structure       vs -0.8500  0.3400               <NA>                        <NA>
#> 15 Structure     qsec -0.8000 -0.1000               <NA>                        <NA>
#> 16 Structure      mpg -0.7700  0.7000               <NA>                        <NA>
#> 17 Structure     carb  0.7700  0.0100               <NA>                        <NA>
#> 18 Structure     disp  0.7500 -0.7500               <NA>                        <NA>
#> 19 Structure       am -0.1500  0.9000               <NA>                        <NA>
#> 20 Structure     gear -0.0600  0.8700               <NA>                        <NA>
#> 21 Structure     drat -0.4100  0.8300               <NA>                        <NA>
#> 22 Structure       wt  0.6200 -0.7900               <NA>                        <NA>
#> 23      <NA>     <NA>  4.7374  4.0438 variance accounted                 SS loadings
#> 24      <NA>     <NA>  0.4307  0.3676 variance accounted              Proportion Var
#> 25      <NA>     <NA>  0.4307  0.7983 variance accounted              Cumulative Var
#> 26      <NA>     <NA>  0.5395  0.4605 variance accounted        Proportion Explained
#> 27      <NA>     <NA>  0.5395  1.0000 variance accounted       Cumulative Proportion
#> 
#> $instruction_loading_critical_values
#>    sample critical_loading
#> 1      50             0.75
#> 2      60             0.70
#> 3      70             0.65
#> 4      85             0.60
#> 5     100             0.55
#> 6     120             0.50
#> 7     150             0.45
#> 8     200             0.40
#> 9     250             0.35
#> 10    350             0.30
#> 
#> $weights
#>          WLS1     WLS2
#> mpg  -0.16930  0.10619
#> cyl   0.44769 -0.01193
#> disp -0.18246 -0.39136
#> hp    0.36842  0.25800
#> drat  0.11254  0.21029
#> wt    0.14174  0.10278
#> qsec -0.13074 -0.20271
#> vs   -0.19067 -0.10342
#> am    0.22599  0.32521
#> gear  0.29046  0.32941
#> carb -0.02599 -0.04586
#> 
model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="gls",oblique.scores=TRUE)
report_efa(model=model,df=mtcars)






#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> [[1]]

#> 
#> $correlations
#>                          type       mpg        cyl      disp         hp      drat       wt       qsec        vs        am     gear     carb
#> mpg   reproduced correlations  0.870010 -0.8897877 -0.870355 -0.7743318  0.721204 -0.81485  0.4541307  0.721264  0.573550  0.50426 -0.48227
#> cyl   reproduced correlations -0.889788  0.9196736  0.885281  0.8332038 -0.694205  0.81409 -0.5355607 -0.776496 -0.519870 -0.44505  0.55529
#> disp  reproduced correlations -0.870355  0.8852805  0.873145  0.7538748 -0.743322  0.82488 -0.4185352 -0.702011 -0.607345 -0.54001  0.45124
#> hp    reproduced correlations -0.774332  0.8332038  0.753875  0.8655090 -0.456481  0.64283 -0.7080069 -0.807878 -0.225406 -0.14685  0.69438
#> drat  reproduced correlations  0.721204 -0.6942052 -0.743322 -0.4564807  0.792803 -0.76214  0.0569993  0.423425  0.775193  0.73550 -0.12098
#> wt    reproduced correlations -0.814854  0.8140890  0.824882  0.6428257 -0.762140  0.80171 -0.2833396 -0.597983 -0.670426 -0.61341  0.32777
#> qsec  reproduced correlations  0.454131 -0.5355607 -0.418535 -0.7080069  0.056999 -0.28334  0.7605215  0.662389 -0.191784 -0.25704 -0.70858
#> vs    reproduced correlations  0.721264 -0.7764962 -0.702011 -0.8078783  0.423425 -0.59798  0.6623887  0.754098  0.207234  0.13390 -0.64933
#> am    reproduced correlations  0.573550 -0.5198704 -0.607345 -0.2254060  0.775193 -0.67043 -0.1917835  0.207234  0.838966  0.82057  0.11072
#> gear  reproduced correlations  0.504256 -0.4450508 -0.540011 -0.1468540  0.735498 -0.61341 -0.2570352  0.133904  0.820570  0.80931  0.17451
#> carb  reproduced correlations -0.482269  0.5552890  0.451238  0.6943828 -0.120984  0.32777 -0.7085850 -0.649329  0.110721  0.17451  0.66604
#> mpg1    observed correlations  1.000000 -0.8521620 -0.847551 -0.7761684  0.681172 -0.86766  0.4186840  0.664039  0.599832  0.48028 -0.55093
#> cyl1    observed correlations -0.852162  1.0000000  0.902033  0.8324475 -0.699938  0.78250 -0.5912421 -0.810812 -0.522607 -0.49269  0.52699
#> disp1   observed correlations -0.847551  0.9020329  1.000000  0.7909486 -0.710214  0.88798 -0.4336979 -0.710416 -0.591227 -0.55557  0.39498
#> hp1     observed correlations -0.776168  0.8324475  0.790949  1.0000000 -0.448759  0.65875 -0.7082234 -0.723097 -0.243204 -0.12570  0.74981
#> drat1   observed correlations  0.681172 -0.6999381 -0.710214 -0.4487591  1.000000 -0.71244  0.0912048  0.440278  0.712711  0.69961 -0.09079
#> wt1     observed correlations -0.867659  0.7824958  0.887980  0.6587479 -0.712441  1.00000 -0.1747159 -0.554916 -0.692495 -0.58329  0.42761
#> qsec1   observed correlations  0.418684 -0.5912421 -0.433698 -0.7082234  0.091205 -0.17472  1.0000000  0.744535 -0.229861 -0.21268 -0.65625
#> vs1     observed correlations  0.664039 -0.8108118 -0.710416 -0.7230967  0.440278 -0.55492  0.7445354  1.000000  0.168345  0.20602 -0.56961
#> am1     observed correlations  0.599832 -0.5226070 -0.591227 -0.2432043  0.712711 -0.69250 -0.2298609  0.168345  1.000000  0.79406  0.05753
#> gear1   observed correlations  0.480285 -0.4926866 -0.555569 -0.1257043  0.699610 -0.58329 -0.2126822  0.206023  0.794059  1.00000  0.27407
#> carb1   observed correlations -0.550925  0.5269883  0.394977  0.7498125 -0.090790  0.42761 -0.6562492 -0.569607  0.057534  0.27407  1.00000
#> mpg2    residual correlations  0.129990  0.0376257  0.022803 -0.0018366 -0.040032 -0.05281 -0.0354466 -0.057226  0.026282 -0.02397 -0.06866
#> cyl2    residual correlations  0.037626  0.0803264  0.016752 -0.0007564 -0.005733 -0.03159 -0.0556814 -0.034316 -0.002737 -0.04764 -0.02830
#> disp2   residual correlations  0.022803  0.0167523  0.126855  0.0370738  0.033108  0.06310 -0.0151627 -0.008405  0.016118 -0.01556 -0.05626
#> hp2     residual correlations -0.001837 -0.0007564  0.037074  0.1344910  0.007722  0.01592 -0.0002165  0.084782 -0.017798  0.02115  0.05543
#> drat2   residual correlations -0.040032 -0.0057329  0.033108  0.0077216  0.207197  0.04970  0.0342054  0.016854 -0.062482 -0.03589  0.03019
#> wt2     residual correlations -0.052805 -0.0315932  0.063098  0.0159222  0.049699  0.19829  0.1086237  0.043067 -0.022069  0.03013  0.09984
#> qsec2   residual correlations -0.035447 -0.0556814 -0.015163 -0.0002165  0.034205  0.10862  0.2394785  0.082147 -0.038077  0.04435  0.05234
#> vs2     residual correlations -0.057226 -0.0343156 -0.008405  0.0847816  0.016854  0.04307  0.0821467  0.245902 -0.038889  0.07212  0.07972
#> am2     residual correlations  0.026282 -0.0027367  0.016118 -0.0177982 -0.062482 -0.02207 -0.0380773 -0.038889  0.161034 -0.02651 -0.05319
#> gear2   residual correlations -0.023972 -0.0476358 -0.015558  0.0211498 -0.035888  0.03013  0.0443529  0.072120 -0.026512  0.19069  0.09956
#> carb2   residual correlations -0.068656 -0.0283007 -0.056261  0.0554297  0.030194  0.09984  0.0523358  0.079722 -0.053186  0.09956  0.33396
#> 
#> $npobs
#>      mpg cyl disp hp drat wt qsec vs am gear carb
#> mpg   32  32   32 32   32 32   32 32 32   32   32
#> cyl   32  32   32 32   32 32   32 32 32   32   32
#> disp  32  32   32 32   32 32   32 32 32   32   32
#> hp    32  32   32 32   32 32   32 32 32   32   32
#> drat  32  32   32 32   32 32   32 32 32   32   32
#> wt    32  32   32 32   32 32   32 32 32   32   32
#> qsec  32  32   32 32   32 32   32 32 32   32   32
#> vs    32  32   32 32   32 32   32 32 32   32   32
#> am    32  32   32 32   32 32   32 32 32   32   32
#> gear  32  32   32 32   32 32   32 32 32   32   32
#> carb  32  32   32 32   32 32   32 32 32   32   32
#> 
#> $residual_stats
#>                       residual_statistics    value critical                              formula
#> 1              Root Mean Squared Residual  0.04704       NA              sqrt(mean(residuals^2))
#> 2     Number of absolute residuals > 0.05 17.00000       NA                  abs(residuals)>0.05
#> 3 Proportion of absolute residuals > 0.05  0.30909      0.5 numberLargeResiduals/nrow(residuals)
#> 
#> $determinant_test
#>    determinant above_critical
#> 1 0.0000002057          FALSE
#> 
#> $bartlett_test
#>   x_squared[bartlett] df[bartlett]                                                  p[bartlett]
#> 1                 408           55 0.0000000000000000000000000000000000000000000000000000002227
#> 
#> $kmo_test
#>      Overall_MSA    MSA Kaiser_1974
#> mpg       0.8266 0.9276          NA
#> cyl       0.8266 0.8966          NA
#> disp      0.8266 0.7647          NA
#> hp        0.8266 0.8386          NA
#> drat      0.8266 0.9497          NA
#> wt        0.8266 0.7410          NA
#> qsec      0.8266 0.7401          NA
#> vs        0.8266 0.9067          NA
#> am        0.8266 0.8778          NA
#> gear      0.8266 0.8470          NA
#> carb      0.8266 0.6211          NA
#> 
#> $loadings
#>       Matrix variable    GLS1    GLS2               type row.names.model.Vaccounted.
#> 1    Pattern       hp  0.9000 -0.1000               <NA>                        <NA>
#> 2    Pattern     qsec -0.9000 -0.3600               <NA>                        <NA>
#> 3    Pattern     carb  0.8500  0.2600               <NA>                        <NA>
#> 4    Pattern       vs -0.8400  0.0900               <NA>                        <NA>
#> 5    Pattern      cyl  0.7300 -0.4500               <NA>                        <NA>
#> 6    Pattern      mpg -0.6400  0.5300               <NA>                        <NA>
#> 7    Pattern     disp  0.6000 -0.5700               <NA>                        <NA>
#> 8    Pattern       am  0.1200  0.9400               <NA>                        <NA>
#> 9    Pattern     gear  0.2000  0.9400               <NA>                        <NA>
#> 10   Pattern     drat -0.1800  0.8200               <NA>                        <NA>
#> 11   Pattern       wt  0.4400 -0.6700               <NA>                        <NA>
#> 12 Structure       hp  0.9300 -0.3500               <NA>                        <NA>
#> 13 Structure      cyl  0.8600 -0.6600               <NA>                        <NA>
#> 14 Structure       vs -0.8600  0.3300               <NA>                        <NA>
#> 15 Structure     qsec -0.8000 -0.1000               <NA>                        <NA>
#> 16 Structure      mpg -0.7800  0.7100               <NA>                        <NA>
#> 17 Structure     carb  0.7800  0.0200               <NA>                        <NA>
#> 18 Structure     disp  0.7600 -0.7400               <NA>                        <NA>
#> 19 Structure       am -0.1500  0.9100               <NA>                        <NA>
#> 20 Structure     gear -0.0600  0.8800               <NA>                        <NA>
#> 21 Structure     drat -0.4100  0.8700               <NA>                        <NA>
#> 22 Structure       wt  0.6300 -0.7900               <NA>                        <NA>
#> 23      <NA>     <NA>  4.8303  4.1215 variance accounted                 SS loadings
#> 24      <NA>     <NA>  0.4391  0.3747 variance accounted              Proportion Var
#> 25      <NA>     <NA>  0.4391  0.8138 variance accounted              Cumulative Var
#> 26      <NA>     <NA>  0.5396  0.4604 variance accounted        Proportion Explained
#> 27      <NA>     <NA>  0.5396  1.0000 variance accounted       Cumulative Proportion
#> 
#> $instruction_loading_critical_values
#>    sample critical_loading
#> 1      50             0.75
#> 2      60             0.70
#> 3      70             0.65
#> 4      85             0.60
#> 5     100             0.55
#> 6     120             0.50
#> 7     150             0.45
#> 8     200             0.40
#> 9     250             0.35
#> 10    350             0.30
#> 
#> $weights
#>          GLS1     GLS2
#> mpg  -0.23450  0.09205
#> cyl   0.39574  0.13478
#> disp -0.17875 -0.37862
#> hp    0.39163  0.24708
#> drat  0.14230  0.34925
#> wt    0.11186  0.12424
#> qsec -0.07003 -0.13058
#> vs   -0.27851 -0.11901
#> am    0.22848  0.34634
#> gear  0.29491  0.35148
#> carb -0.04401 -0.08598
#> 
model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="pa",oblique.scores=TRUE)
report_efa(model=model,df=mtcars)






#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> [[1]]

#> 
#> $correlations
#>                          type       mpg        cyl      disp        hp      drat       wt     qsec       vs         am      gear     carb
#> mpg   reproduced correlations  0.852824 -0.8883476 -0.873810 -0.768684  0.686518 -0.81545  0.44814  0.69566  0.5660838  0.500755 -0.47308
#> cyl   reproduced correlations -0.888348  0.9356154  0.904908  0.844066 -0.675164  0.82885 -0.54184 -0.76254 -0.5224894 -0.449535  0.55660
#> disp  reproduced correlations -0.873810  0.9049076  0.898051  0.765207 -0.724043  0.84614 -0.42041 -0.69321 -0.6147040 -0.550301  0.45176
#> hp    reproduced correlations -0.768684  0.8440659  0.765207  0.876037 -0.450011  0.64810 -0.72092 -0.78715 -0.2264498 -0.146847  0.69602
#> drat  reproduced correlations  0.686518 -0.6751641 -0.724043 -0.450011  0.708135 -0.73649  0.06870  0.41248  0.7171450  0.683645 -0.13243
#> wt    reproduced correlations -0.815448  0.8288468  0.846137  0.648103 -0.736486  0.82093 -0.27814 -0.58922 -0.6758818 -0.623244  0.32446
#> qsec  reproduced correlations  0.448136 -0.5418377 -0.420414 -0.720917  0.068699 -0.27814  0.78401  0.64263 -0.1935984 -0.263780 -0.71513
#> vs    reproduced correlations  0.695662 -0.7625429 -0.693208 -0.787154  0.412480 -0.58922  0.64263  0.70743  0.2137105  0.142310 -0.62157
#> am    reproduced correlations  0.566084 -0.5224894 -0.614704 -0.226450  0.717145 -0.67588 -0.19360  0.21371  0.8153664  0.804100  0.10364
#> gear  reproduced correlations  0.500755 -0.4495352 -0.550301 -0.146847  0.683645 -0.62324 -0.26378  0.14231  0.8040996  0.800180  0.17038
#> carb  reproduced correlations -0.473079  0.5566050  0.451764  0.696018 -0.132431  0.32446 -0.71513 -0.62157  0.1036423  0.170375  0.65923
#> mpg1    observed correlations  1.000000 -0.8521620 -0.847551 -0.776168  0.681172 -0.86766  0.41868  0.66404  0.5998324  0.480285 -0.55093
#> cyl1    observed correlations -0.852162  1.0000000  0.902033  0.832447 -0.699938  0.78250 -0.59124 -0.81081 -0.5226070 -0.492687  0.52699
#> disp1   observed correlations -0.847551  0.9020329  1.000000  0.790949 -0.710214  0.88798 -0.43370 -0.71042 -0.5912270 -0.555569  0.39498
#> hp1     observed correlations -0.776168  0.8324475  0.790949  1.000000 -0.448759  0.65875 -0.70822 -0.72310 -0.2432043 -0.125704  0.74981
#> drat1   observed correlations  0.681172 -0.6999381 -0.710214 -0.448759  1.000000 -0.71244  0.09120  0.44028  0.7127111  0.699610 -0.09079
#> wt1     observed correlations -0.867659  0.7824958  0.887980  0.658748 -0.712441  1.00000 -0.17472 -0.55492 -0.6924953 -0.583287  0.42761
#> qsec1   observed correlations  0.418684 -0.5912421 -0.433698 -0.708223  0.091205 -0.17472  1.00000  0.74454 -0.2298609 -0.212682 -0.65625
#> vs1     observed correlations  0.664039 -0.8108118 -0.710416 -0.723097  0.440278 -0.55492  0.74454  1.00000  0.1683451  0.206023 -0.56961
#> am1     observed correlations  0.599832 -0.5226070 -0.591227 -0.243204  0.712711 -0.69250 -0.22986  0.16835  1.0000000  0.794059  0.05753
#> gear1   observed correlations  0.480285 -0.4926866 -0.555569 -0.125704  0.699610 -0.58329 -0.21268  0.20602  0.7940588  1.000000  0.27407
#> carb1   observed correlations -0.550925  0.5269883  0.394977  0.749812 -0.090790  0.42761 -0.65625 -0.56961  0.0575344  0.274073  1.00000
#> mpg2    residual correlations  0.147176  0.0361856  0.026259 -0.007484 -0.005346 -0.05221 -0.02945 -0.03162  0.0337486 -0.020471 -0.07785
#> cyl2    residual correlations  0.036186  0.0643846 -0.002875 -0.011618 -0.024774 -0.04635 -0.04940 -0.04827 -0.0001176 -0.043151 -0.02962
#> disp2   residual correlations  0.026259 -0.0028747  0.101949  0.025742  0.013829  0.04184 -0.01328 -0.01721  0.0234769 -0.005269 -0.05679
#> hp2     residual correlations -0.007484 -0.0116184  0.025742  0.123963  0.001252  0.01064  0.01269  0.06406 -0.0167544  0.021143  0.05379
#> drat2   residual correlations -0.005346 -0.0247740  0.013829  0.001252  0.291865  0.02405  0.02251  0.02780 -0.0044339  0.015965  0.04164
#> wt2     residual correlations -0.052211 -0.0463510  0.041843  0.010645  0.024045  0.17907  0.10342  0.03431 -0.0166135  0.039957  0.10314
#> qsec2   residual correlations -0.029452 -0.0494044 -0.013284  0.012693  0.022506  0.10342  0.21599  0.10190 -0.0362625  0.051097  0.05888
#> vs2     residual correlations -0.031623 -0.0482689 -0.017208  0.064057  0.027799  0.03431  0.10190  0.29257 -0.0453654  0.063713  0.05196
#> am2     residual correlations  0.033749 -0.0001176  0.023477 -0.016754 -0.004434 -0.01661 -0.03626 -0.04537  0.1846336 -0.010041 -0.04611
#> gear2   residual correlations -0.020471 -0.0431514 -0.005269  0.021143  0.015965  0.03996  0.05110  0.06371 -0.0100408  0.199820  0.10370
#> carb2   residual correlations -0.077846 -0.0296167 -0.056787  0.053794  0.041641  0.10314  0.05888  0.05196 -0.0461079  0.103698  0.34077
#> 
#> $npobs
#>      mpg cyl disp hp drat wt qsec vs am gear carb
#> mpg   32  32   32 32   32 32   32 32 32   32   32
#> cyl   32  32   32 32   32 32   32 32 32   32   32
#> disp  32  32   32 32   32 32   32 32 32   32   32
#> hp    32  32   32 32   32 32   32 32 32   32   32
#> drat  32  32   32 32   32 32   32 32 32   32   32
#> wt    32  32   32 32   32 32   32 32 32   32   32
#> qsec  32  32   32 32   32 32   32 32 32   32   32
#> vs    32  32   32 32   32 32   32 32 32   32   32
#> am    32  32   32 32   32 32   32 32 32   32   32
#> gear  32  32   32 32   32 32   32 32 32   32   32
#> carb  32  32   32 32   32 32   32 32 32   32   32
#> 
#> $residual_stats
#>                       residual_statistics    value critical                              formula
#> 1              Root Mean Squared Residual  0.04419       NA              sqrt(mean(residuals^2))
#> 2     Number of absolute residuals > 0.05 13.00000       NA                  abs(residuals)>0.05
#> 3 Proportion of absolute residuals > 0.05  0.23636      0.5 numberLargeResiduals/nrow(residuals)
#> 
#> $determinant_test
#>    determinant above_critical
#> 1 0.0000002057          FALSE
#> 
#> $bartlett_test
#>   x_squared[bartlett] df[bartlett]                                                  p[bartlett]
#> 1                 408           55 0.0000000000000000000000000000000000000000000000000000002227
#> 
#> $kmo_test
#>      Overall_MSA    MSA Kaiser_1974
#> mpg       0.8266 0.9276          NA
#> cyl       0.8266 0.8966          NA
#> disp      0.8266 0.7647          NA
#> hp        0.8266 0.8386          NA
#> drat      0.8266 0.9497          NA
#> wt        0.8266 0.7410          NA
#> qsec      0.8266 0.7401          NA
#> vs        0.8266 0.9067          NA
#> am        0.8266 0.8778          NA
#> gear      0.8266 0.8470          NA
#> carb      0.8266 0.6211          NA
#> 
#> $loadings
#>       Matrix variable     PA1     PA2               type row.names.model.Vaccounted.
#> 1    Pattern     qsec -0.9200 -0.3500               <NA>                        <NA>
#> 2    Pattern       hp  0.8900 -0.1200               <NA>                        <NA>
#> 3    Pattern     carb  0.8500  0.2400               <NA>                        <NA>
#> 4    Pattern       vs -0.8000  0.1200               <NA>                        <NA>
#> 5    Pattern      cyl  0.7100 -0.4800               <NA>                        <NA>
#> 6    Pattern      mpg -0.6100  0.5500               <NA>                        <NA>
#> 7    Pattern       am  0.1300  0.9300               <NA>                        <NA>
#> 8    Pattern     gear  0.2200  0.9300               <NA>                        <NA>
#> 9    Pattern     drat -0.1700  0.7800               <NA>                        <NA>
#> 10   Pattern       wt  0.4200 -0.7000               <NA>                        <NA>
#> 11   Pattern     disp  0.5800 -0.6000               <NA>                        <NA>
#> 12 Structure       hp  0.9300 -0.3800               <NA>                        <NA>
#> 13 Structure      cyl  0.8500 -0.6800               <NA>                        <NA>
#> 14 Structure       vs -0.8300  0.3500               <NA>                        <NA>
#> 15 Structure     qsec -0.8200 -0.0900               <NA>                        <NA>
#> 16 Structure     carb  0.7800  0.0000               <NA>                        <NA>
#> 17 Structure      mpg -0.7600  0.7200               <NA>                        <NA>
#> 18 Structure       am -0.1300  0.8900               <NA>                        <NA>
#> 19 Structure     gear -0.0400  0.8700               <NA>                        <NA>
#> 20 Structure     drat -0.3900  0.8300               <NA>                        <NA>
#> 21 Structure       wt  0.6100 -0.8100               <NA>                        <NA>
#> 22 Structure     disp  0.7500 -0.7700               <NA>                        <NA>
#> 23      <NA>     <NA>  4.7008  4.1570 variance accounted                 SS loadings
#> 24      <NA>     <NA>  0.4273  0.3779 variance accounted              Proportion Var
#> 25      <NA>     <NA>  0.4273  0.8053 variance accounted              Cumulative Var
#> 26      <NA>     <NA>  0.5307  0.4693 variance accounted        Proportion Explained
#> 27      <NA>     <NA>  0.5307  1.0000 variance accounted       Cumulative Proportion
#> 
#> $instruction_loading_critical_values
#>    sample critical_loading
#> 1      50             0.75
#> 2      60             0.70
#> 3      70             0.65
#> 4      85             0.60
#> 5     100             0.55
#> 6     120             0.50
#> 7     150             0.45
#> 8     200             0.40
#> 9     250             0.35
#> 10    350             0.30
#> 
#> $weights
#>           PA1      PA2
#> mpg  -0.12719  0.12383
#> cyl   0.44305 -0.08942
#> disp -0.22261 -0.45697
#> hp    0.38630  0.29346
#> drat  0.10438  0.15061
#> wt    0.21774  0.10593
#> qsec -0.24784 -0.27803
#> vs   -0.10108 -0.08715
#> am    0.21028  0.27688
#> gear  0.29479  0.32111
#> carb -0.05545 -0.05342
#> 
model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="ml",oblique.scores=TRUE)
report_efa(model=model,df=mtcars)






#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> [[1]]

#> 
#> $correlations
#>                          type       mpg       cyl      disp        hp      drat        wt      qsec        vs        am      gear     carb
#> mpg   reproduced correlations  0.832842 -0.871663 -0.867526 -0.750332  0.689137 -0.808164  0.434978  0.688421  0.573534  0.514470 -0.45056
#> cyl   reproduced correlations -0.871663  0.930250  0.904782  0.842341 -0.672580  0.816515 -0.561007 -0.776589 -0.511982 -0.449915  0.55312
#> disp  reproduced correlations -0.867526  0.904782  0.904219  0.771474 -0.726462  0.847016 -0.434354 -0.707154 -0.613064 -0.551584  0.45487
#> hp    reproduced correlations -0.750332  0.842341  0.771474  0.857149 -0.466249  0.634973 -0.727776 -0.798335 -0.236299 -0.182295  0.66498
#> drat  reproduced correlations  0.689137 -0.672580 -0.726462 -0.466249  0.702192 -0.748201  0.073238  0.417613  0.713907  0.665710 -0.15170
#> wt    reproduced correlations -0.808164  0.816515  0.847016  0.634973 -0.748201  0.832092 -0.249416 -0.576458 -0.700694 -0.643787  0.30403
#> qsec  reproduced correlations  0.434978 -0.561007 -0.434354 -0.727776  0.073238 -0.249416  0.849989  0.689811 -0.220397 -0.252712 -0.71567
#> vs    reproduced correlations  0.688421 -0.776589 -0.707154 -0.798335  0.417613 -0.576458  0.689811  0.744174  0.198365  0.148765 -0.62715
#> am    reproduced correlations  0.573534 -0.511982 -0.613064 -0.236299  0.713907 -0.700694 -0.220397  0.198365  0.829030  0.789581  0.09074
#> gear  reproduced correlations  0.514470 -0.449915 -0.551584 -0.182295  0.665710 -0.643787 -0.252712  0.148765  0.789581  0.754324  0.12383
#> carb  reproduced correlations -0.450558  0.553124  0.454869  0.664984 -0.151703  0.304029 -0.715672 -0.627149  0.090742  0.123827  0.61423
#> mpg1    observed correlations  1.000000 -0.852162 -0.847551 -0.776168  0.681172 -0.867659  0.418684  0.664039  0.599832  0.480285 -0.55093
#> cyl1    observed correlations -0.852162  1.000000  0.902033  0.832447 -0.699938  0.782496 -0.591242 -0.810812 -0.522607 -0.492687  0.52699
#> disp1   observed correlations -0.847551  0.902033  1.000000  0.790949 -0.710214  0.887980 -0.433698 -0.710416 -0.591227 -0.555569  0.39498
#> hp1     observed correlations -0.776168  0.832447  0.790949  1.000000 -0.448759  0.658748 -0.708223 -0.723097 -0.243204 -0.125704  0.74981
#> drat1   observed correlations  0.681172 -0.699938 -0.710214 -0.448759  1.000000 -0.712441  0.091205  0.440278  0.712711  0.699610 -0.09079
#> wt1     observed correlations -0.867659  0.782496  0.887980  0.658748 -0.712441  1.000000 -0.174716 -0.554916 -0.692495 -0.583287  0.42761
#> qsec1   observed correlations  0.418684 -0.591242 -0.433698 -0.708223  0.091205 -0.174716  1.000000  0.744535 -0.229861 -0.212682 -0.65625
#> vs1     observed correlations  0.664039 -0.810812 -0.710416 -0.723097  0.440278 -0.554916  0.744535  1.000000  0.168345  0.206023 -0.56961
#> am1     observed correlations  0.599832 -0.522607 -0.591227 -0.243204  0.712711 -0.692495 -0.229861  0.168345  1.000000  0.794059  0.05753
#> gear1   observed correlations  0.480285 -0.492687 -0.555569 -0.125704  0.699610 -0.583287 -0.212682  0.206023  0.794059  1.000000  0.27407
#> carb1   observed correlations -0.550925  0.526988  0.394977  0.749812 -0.090790  0.427606 -0.656249 -0.569607  0.057534  0.274073  1.00000
#> mpg2    residual correlations  0.167158  0.019501  0.019975 -0.025836 -0.007965 -0.059495 -0.016294 -0.024382  0.026298 -0.034185 -0.10037
#> cyl2    residual correlations  0.019501  0.069750 -0.002749 -0.009894 -0.027358 -0.034019 -0.030236 -0.034223 -0.010625 -0.042772 -0.02614
#> disp2   residual correlations  0.019975 -0.002749  0.095781  0.019475  0.016248  0.040964  0.000656 -0.003262  0.021837 -0.003986 -0.05989
#> hp2     residual correlations -0.025836 -0.009894  0.019475  0.142851  0.017490  0.023775  0.019553  0.075238 -0.006905  0.056591  0.08483
#> drat2   residual correlations -0.007965 -0.027358  0.016248  0.017490  0.297808  0.035760  0.017967  0.022666 -0.001196  0.033900  0.06091
#> wt2     residual correlations -0.059495 -0.034019  0.040964  0.023775  0.035760  0.167908  0.074700  0.021542  0.008199  0.060500  0.12358
#> qsec2   residual correlations -0.016294 -0.030236  0.000656  0.019553  0.017967  0.074700  0.150011  0.054724 -0.009464  0.040030  0.05942
#> vs2     residual correlations -0.024382 -0.034223 -0.003262  0.075238  0.022666  0.021542  0.054724  0.255826 -0.030020  0.057259  0.05754
#> am2     residual correlations  0.026298 -0.010625  0.021837 -0.006905 -0.001196  0.008199 -0.009464 -0.030020  0.170970  0.004478 -0.03321
#> gear2   residual correlations -0.034185 -0.042772 -0.003986  0.056591  0.033900  0.060500  0.040030  0.057259  0.004478  0.245676  0.15025
#> carb2   residual correlations -0.100367 -0.026136 -0.059892  0.084828  0.060913  0.123577  0.059423  0.057542 -0.033207  0.150246  0.38577
#> 
#> $npobs
#>      mpg cyl disp hp drat wt qsec vs am gear carb
#> mpg   32  32   32 32   32 32   32 32 32   32   32
#> cyl   32  32   32 32   32 32   32 32 32   32   32
#> disp  32  32   32 32   32 32   32 32 32   32   32
#> hp    32  32   32 32   32 32   32 32 32   32   32
#> drat  32  32   32 32   32 32   32 32 32   32   32
#> wt    32  32   32 32   32 32   32 32 32   32   32
#> qsec  32  32   32 32   32 32   32 32 32   32   32
#> vs    32  32   32 32   32 32   32 32 32   32   32
#> am    32  32   32 32   32 32   32 32 32   32   32
#> gear  32  32   32 32   32 32   32 32 32   32   32
#> carb  32  32   32 32   32 32   32 32 32   32   32
#> 
#> $residual_stats
#>                       residual_statistics    value critical                              formula
#> 1              Root Mean Squared Residual  0.04666       NA              sqrt(mean(residuals^2))
#> 2     Number of absolute residuals > 0.05 15.00000       NA                  abs(residuals)>0.05
#> 3 Proportion of absolute residuals > 0.05  0.27273      0.5 numberLargeResiduals/nrow(residuals)
#> 
#> $determinant_test
#>    determinant above_critical
#> 1 0.0000002057          FALSE
#> 
#> $bartlett_test
#>   x_squared[bartlett] df[bartlett]                                                  p[bartlett]
#> 1                 408           55 0.0000000000000000000000000000000000000000000000000000002227
#> 
#> $kmo_test
#>      Overall_MSA    MSA Kaiser_1974
#> mpg       0.8266 0.9276          NA
#> cyl       0.8266 0.8966          NA
#> disp      0.8266 0.7647          NA
#> hp        0.8266 0.8386          NA
#> drat      0.8266 0.9497          NA
#> wt        0.8266 0.7410          NA
#> qsec      0.8266 0.7401          NA
#> vs        0.8266 0.9067          NA
#> am        0.8266 0.8778          NA
#> gear      0.8266 0.8470          NA
#> carb      0.8266 0.6211          NA
#> 
#> $loadings
#>       Matrix variable     ML1     ML2               type row.names.model.Vaccounted.
#> 1    Pattern     qsec -0.9600 -0.3200               <NA>                        <NA>
#> 2    Pattern       hp  0.8500 -0.2000               <NA>                        <NA>
#> 3    Pattern     carb  0.8100  0.1600               <NA>                        <NA>
#> 4    Pattern       vs -0.8000  0.1600               <NA>                        <NA>
#> 5    Pattern      cyl  0.6700 -0.5200               <NA>                        <NA>
#> 6    Pattern       am  0.2000  0.9500               <NA>                        <NA>
#> 7    Pattern     gear  0.2400  0.9100               <NA>                        <NA>
#> 8    Pattern     drat -0.1300  0.7900               <NA>                        <NA>
#> 9    Pattern       wt  0.3300 -0.7600               <NA>                        <NA>
#> 10   Pattern     disp  0.5300 -0.6500               <NA>                        <NA>
#> 11   Pattern      mpg -0.5300  0.6000               <NA>                        <NA>
#> 12 Structure       hp  0.9100 -0.4400               <NA>                        <NA>
#> 13 Structure     qsec -0.8700 -0.0500               <NA>                        <NA>
#> 14 Structure       vs -0.8500  0.3900               <NA>                        <NA>
#> 15 Structure      cyl  0.8200 -0.7200               <NA>                        <NA>
#> 16 Structure     carb  0.7700 -0.0700               <NA>                        <NA>
#> 17 Structure       am -0.0700  0.8900               <NA>                        <NA>
#> 18 Structure       wt  0.5500 -0.8600               <NA>                        <NA>
#> 19 Structure     gear -0.0200  0.8400               <NA>                        <NA>
#> 20 Structure     drat -0.3500  0.8300               <NA>                        <NA>
#> 21 Structure     disp  0.7200 -0.8000               <NA>                        <NA>
#> 22 Structure      mpg -0.7100  0.7600               <NA>                        <NA>
#> 23      <NA>     <NA>  4.4305  4.4200 variance accounted                 SS loadings
#> 24      <NA>     <NA>  0.4028  0.4018 variance accounted              Proportion Var
#> 25      <NA>     <NA>  0.4028  0.8046 variance accounted              Cumulative Var
#> 26      <NA>     <NA>  0.5006  0.4994 variance accounted        Proportion Explained
#> 27      <NA>     <NA>  0.5006  1.0000 variance accounted       Cumulative Proportion
#> 
#> $instruction_loading_critical_values
#>    sample critical_loading
#> 1      50             0.75
#> 2      60             0.70
#> 3      70             0.65
#> 4      85             0.60
#> 5     100             0.55
#> 6     120             0.50
#> 7     150             0.45
#> 8     200             0.40
#> 9     250             0.35
#> 10    350             0.30
#> 
#> $weights
#>           ML1      ML2
#> mpg  -0.04829  0.09421
#> cyl   0.24216 -0.11404
#> disp  0.07217 -0.18703
#> hp    0.23861  0.09028
#> drat  0.05442  0.12138
#> wt   -0.03544 -0.17393
#> qsec -0.35954 -0.27994
#> vs   -0.12914 -0.05321
#> am    0.21026  0.30864
#> gear  0.14913  0.21073
#> carb  0.11072  0.07832
#> 
model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="minchi",oblique.scores=TRUE)
report_efa(model=model,df=mtcars)






#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> [[1]]

#> 
#> $correlations
#>                          type       mpg       cyl       disp        hp      drat        wt       qsec        vs        am      gear     carb
#> mpg   reproduced correlations  0.832877 -0.872506 -0.8676820 -0.756337  0.685461 -0.806173  0.4413483  0.691031  0.566491  0.508724 -0.45690
#> cyl   reproduced correlations -0.872506  0.927403  0.9049457  0.842042 -0.674237  0.820318 -0.5503165 -0.769431 -0.517153 -0.453058  0.55195
#> disp  reproduced correlations -0.867682  0.904946  0.9051498  0.773005 -0.727278  0.847138 -0.4333586 -0.706231 -0.613088 -0.553982  0.45396
#> hp    reproduced correlations -0.756337  0.842042  0.7730047  0.871538 -0.459605  0.642130 -0.7276042 -0.796638 -0.230998 -0.165243  0.68727
#> drat  reproduced correlations  0.685461 -0.674237 -0.7272777 -0.459605  0.707740 -0.742803  0.0750648  0.419609  0.716139  0.680321 -0.13588
#> wt    reproduced correlations -0.806173  0.820318  0.8471384  0.642130 -0.742803  0.824139 -0.2680282 -0.586513 -0.686369 -0.636930  0.30960
#> qsec  reproduced correlations  0.441348 -0.550316 -0.4333586 -0.727604  0.075065 -0.268028  0.8121313  0.665404 -0.201311 -0.255450 -0.72402
#> vs    reproduced correlations  0.691031 -0.769431 -0.7062310 -0.796638  0.419609 -0.586513  0.6654038  0.728176  0.210511  0.150408 -0.62845
#> am    reproduced correlations  0.566491 -0.517153 -0.6130882 -0.230998  0.716139 -0.686369 -0.2013114  0.210511  0.820236  0.801349  0.10718
#> gear  reproduced correlations  0.508724 -0.453058 -0.5539824 -0.165243  0.680321 -0.636930 -0.2554497  0.150408  0.801349  0.787425  0.15847
#> carb  reproduced correlations -0.456899  0.551950  0.4539638  0.687273 -0.135877  0.309601 -0.7240241 -0.628451  0.107176  0.158472  0.65226
#> mpg1    observed correlations  1.000000 -0.852162 -0.8475514 -0.776168  0.681172 -0.867659  0.4186840  0.664039  0.599832  0.480285 -0.55093
#> cyl1    observed correlations -0.852162  1.000000  0.9020329  0.832447 -0.699938  0.782496 -0.5912421 -0.810812 -0.522607 -0.492687  0.52699
#> disp1   observed correlations -0.847551  0.902033  1.0000000  0.790949 -0.710214  0.887980 -0.4336979 -0.710416 -0.591227 -0.555569  0.39498
#> hp1     observed correlations -0.776168  0.832447  0.7909486  1.000000 -0.448759  0.658748 -0.7082234 -0.723097 -0.243204 -0.125704  0.74981
#> drat1   observed correlations  0.681172 -0.699938 -0.7102139 -0.448759  1.000000 -0.712441  0.0912048  0.440278  0.712711  0.699610 -0.09079
#> wt1     observed correlations -0.867659  0.782496  0.8879799  0.658748 -0.712441  1.000000 -0.1747159 -0.554916 -0.692495 -0.583287  0.42761
#> qsec1   observed correlations  0.418684 -0.591242 -0.4336979 -0.708223  0.091205 -0.174716  1.0000000  0.744535 -0.229861 -0.212682 -0.65625
#> vs1     observed correlations  0.664039 -0.810812 -0.7104159 -0.723097  0.440278 -0.554916  0.7445354  1.000000  0.168345  0.206023 -0.56961
#> am1     observed correlations  0.599832 -0.522607 -0.5912270 -0.243204  0.712711 -0.692495 -0.2298609  0.168345  1.000000  0.794059  0.05753
#> gear1   observed correlations  0.480285 -0.492687 -0.5555692 -0.125704  0.699610 -0.583287 -0.2126822  0.206023  0.794059  1.000000  0.27407
#> carb1   observed correlations -0.550925  0.526988  0.3949769  0.749812 -0.090790  0.427606 -0.6562492 -0.569607  0.057534  0.274073  1.00000
#> mpg2    residual correlations  0.167123  0.020344  0.0201306 -0.019831 -0.004289 -0.061486 -0.0226642 -0.026993  0.033342 -0.028439 -0.09403
#> cyl2    residual correlations  0.020344  0.072597 -0.0029128 -0.009594 -0.025701 -0.037822 -0.0409256 -0.041381 -0.005454 -0.039628 -0.02496
#> disp2   residual correlations  0.020131 -0.002913  0.0948502  0.017944  0.017064  0.040841 -0.0003393 -0.004185  0.021861 -0.001587 -0.05899
#> hp2     residual correlations -0.019831 -0.009594  0.0179439  0.128462  0.010846  0.016618  0.0193808  0.073542 -0.012206  0.039538  0.06254
#> drat2   residual correlations -0.004289 -0.025701  0.0170638  0.010846  0.292260  0.030363  0.0161399  0.020670 -0.003428  0.019290  0.04509
#> wt2     residual correlations -0.061486 -0.037822  0.0408415  0.016618  0.030363  0.175861  0.0933124  0.031597 -0.006126  0.053643  0.11800
#> qsec2   residual correlations -0.022664 -0.040926 -0.0003393  0.019381  0.016140  0.093312  0.1878687  0.079132 -0.028549  0.042768  0.06777
#> vs2     residual correlations -0.026993 -0.041381 -0.0041849  0.073542  0.020670  0.031597  0.0791316  0.271824 -0.042166  0.055616  0.05884
#> am2     residual correlations  0.033342 -0.005454  0.0218611 -0.012206 -0.003428 -0.006126 -0.0285494 -0.042166  0.179764 -0.007290 -0.04964
#> gear2   residual correlations -0.028439 -0.039628 -0.0015868  0.039538  0.019290  0.053643  0.0427675  0.055616 -0.007290  0.212575  0.11560
#> carb2   residual correlations -0.094026 -0.024962 -0.0589869  0.062539  0.045087  0.118005  0.0677748  0.058844 -0.049641  0.115600  0.34774
#> 
#> $npobs
#>      mpg cyl disp hp drat wt qsec vs am gear carb
#> mpg   32  32   32 32   32 32   32 32 32   32   32
#> cyl   32  32   32 32   32 32   32 32 32   32   32
#> disp  32  32   32 32   32 32   32 32 32   32   32
#> hp    32  32   32 32   32 32   32 32 32   32   32
#> drat  32  32   32 32   32 32   32 32 32   32   32
#> wt    32  32   32 32   32 32   32 32 32   32   32
#> qsec  32  32   32 32   32 32   32 32 32   32   32
#> vs    32  32   32 32   32 32   32 32 32   32   32
#> am    32  32   32 32   32 32   32 32 32   32   32
#> gear  32  32   32 32   32 32   32 32 32   32   32
#> carb  32  32   32 32   32 32   32 32 32   32   32
#> 
#> $residual_stats
#>                       residual_statistics    value critical                              formula
#> 1              Root Mean Squared Residual  0.04496       NA              sqrt(mean(residuals^2))
#> 2     Number of absolute residuals > 0.05 13.00000       NA                  abs(residuals)>0.05
#> 3 Proportion of absolute residuals > 0.05  0.23636      0.5 numberLargeResiduals/nrow(residuals)
#> 
#> $determinant_test
#>    determinant above_critical
#> 1 0.0000002057          FALSE
#> 
#> $bartlett_test
#>   x_squared[bartlett] df[bartlett]                                                  p[bartlett]
#> 1                 408           55 0.0000000000000000000000000000000000000000000000000000002227
#> 
#> $kmo_test
#>      Overall_MSA    MSA Kaiser_1974
#> mpg       0.8266 0.9276          NA
#> cyl       0.8266 0.8966          NA
#> disp      0.8266 0.7647          NA
#> hp        0.8266 0.8386          NA
#> drat      0.8266 0.9497          NA
#> wt        0.8266 0.7410          NA
#> qsec      0.8266 0.7401          NA
#> vs        0.8266 0.9067          NA
#> am        0.8266 0.8778          NA
#> gear      0.8266 0.8470          NA
#> carb      0.8266 0.6211          NA
#> 
#> $loadings
#>       Matrix variable     MC1     MC2               type row.names.model.Vaccounted.
#> 1    Pattern     qsec -0.9400 -0.3300               <NA>                        <NA>
#> 2    Pattern       hp  0.8700 -0.1600               <NA>                        <NA>
#> 3    Pattern     carb  0.8400  0.2100               <NA>                        <NA>
#> 4    Pattern       vs -0.8000  0.1500               <NA>                        <NA>
#> 5    Pattern      cyl  0.6900 -0.5000               <NA>                        <NA>
#> 6    Pattern      mpg -0.5700  0.5700               <NA>                        <NA>
#> 7    Pattern       am  0.1700  0.9400               <NA>                        <NA>
#> 8    Pattern     gear  0.2300  0.9200               <NA>                        <NA>
#> 9    Pattern     drat -0.1500  0.7900               <NA>                        <NA>
#> 10   Pattern       wt  0.3700 -0.7300               <NA>                        <NA>
#> 11   Pattern     disp  0.5600 -0.6300               <NA>                        <NA>
#> 12 Structure       hp  0.9200 -0.4100               <NA>                        <NA>
#> 13 Structure     qsec -0.8400 -0.0600               <NA>                        <NA>
#> 14 Structure       vs -0.8400  0.3800               <NA>                        <NA>
#> 15 Structure      cyl  0.8300 -0.7000               <NA>                        <NA>
#> 16 Structure     carb  0.7800 -0.0300               <NA>                        <NA>
#> 17 Structure      mpg -0.7300  0.7300               <NA>                        <NA>
#> 18 Structure       am -0.1000  0.8900               <NA>                        <NA>
#> 19 Structure     gear -0.0300  0.8600               <NA>                        <NA>
#> 20 Structure     drat -0.3700  0.8300               <NA>                        <NA>
#> 21 Structure       wt  0.5800 -0.8300               <NA>                        <NA>
#> 22 Structure     disp  0.7400 -0.7900               <NA>                        <NA>
#> 23      <NA>     <NA>  4.5715  4.2976 variance accounted                 SS loadings
#> 24      <NA>     <NA>  0.4156  0.3907 variance accounted              Proportion Var
#> 25      <NA>     <NA>  0.4156  0.8063 variance accounted              Cumulative Var
#> 26      <NA>     <NA>  0.5154  0.4846 variance accounted        Proportion Explained
#> 27      <NA>     <NA>  0.5154  1.0000 variance accounted       Cumulative Proportion
#> 
#> $instruction_loading_critical_values
#>    sample critical_loading
#> 1      50             0.75
#> 2      60             0.70
#> 3      70             0.65
#> 4      85             0.60
#> 5     100             0.55
#> 6     120             0.50
#> 7     150             0.45
#> 8     200             0.40
#> 9     250             0.35
#> 10    350             0.30
#> 
#> $weights
#>           MC1      MC2
#> mpg  -0.05811  0.08597
#> cyl   0.24455 -0.09996
#> disp  0.08401 -0.18491
#> hp    0.28482  0.12510
#> drat  0.05601  0.12733
#> wt   -0.02271 -0.15460
#> qsec -0.27061 -0.21888
#> vs   -0.12571 -0.05534
#> am    0.19854  0.30023
#> gear  0.18521  0.26599
#> carb  0.13757  0.10421
#> 
model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="minrank",oblique.scores=TRUE)
#> Loading required namespace: Rcsdp
report_efa(model=model,df=mtcars)






#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> [[1]]

#> 
#> $correlations
#>                          type       mpg       cyl      disp         hp      drat         wt     qsec        vs        am      gear     carb
#> mpg   reproduced correlations  0.857299 -0.889911 -0.883728 -0.7704939  0.687986 -0.8343292  0.45051  0.705796  0.574760  0.506023 -0.49027
#> cyl   reproduced correlations -0.889911  0.933583  0.911732  0.8421967 -0.675629  0.8450696 -0.54333 -0.770782 -0.530668 -0.455251  0.57845
#> disp  reproduced correlations -0.883728  0.911732  0.914182  0.7700065 -0.731226  0.8720576 -0.42113 -0.705748 -0.630194 -0.561662  0.46563
#> hp    reproduced correlations -0.770494  0.842197  0.770007  0.8755111 -0.451974  0.6591860 -0.73166 -0.798988 -0.231787 -0.152460  0.74082
#> drat  reproduced correlations  0.687986 -0.675629 -0.731226 -0.4519741  0.703300 -0.7519535  0.06456  0.416755  0.720068  0.680856 -0.12061
#> wt    reproduced correlations -0.834329  0.845070  0.872058  0.6591860 -0.751953  0.8568854 -0.27658 -0.605324 -0.700423 -0.642221  0.32843
#> qsec  reproduced correlations  0.450514 -0.543333 -0.421127 -0.7316603  0.064558 -0.2765828  0.82011  0.664855 -0.206364 -0.273817 -0.79357
#> vs    reproduced correlations  0.705796 -0.770782 -0.705748 -0.7989882  0.416755 -0.6053244  0.66486  0.729193  0.217003  0.144625 -0.67368
#> am    reproduced correlations  0.574760 -0.530668 -0.630194 -0.2317873  0.720068 -0.7004229 -0.20636  0.217003  0.828413  0.809635  0.13837
#> gear  reproduced correlations  0.506023 -0.455251 -0.561662 -0.1524603  0.680856 -0.6422206 -0.27382  0.144625  0.809635  0.798051  0.20647
#> carb  reproduced correlations -0.490270  0.578448  0.465627  0.7408221 -0.120610  0.3284342 -0.79357 -0.673684  0.138373  0.206466  0.77273
#> mpg1    observed correlations  1.000000 -0.852162 -0.847551 -0.7761684  0.681172 -0.8676594  0.41868  0.664039  0.599832  0.480285 -0.55093
#> cyl1    observed correlations -0.852162  1.000000  0.902033  0.8324475 -0.699938  0.7824958 -0.59124 -0.810812 -0.522607 -0.492687  0.52699
#> disp1   observed correlations -0.847551  0.902033  1.000000  0.7909486 -0.710214  0.8879799 -0.43370 -0.710416 -0.591227 -0.555569  0.39498
#> hp1     observed correlations -0.776168  0.832447  0.790949  1.0000000 -0.448759  0.6587479 -0.70822 -0.723097 -0.243204 -0.125704  0.74981
#> drat1   observed correlations  0.681172 -0.699938 -0.710214 -0.4487591  1.000000 -0.7124406  0.09120  0.440278  0.712711  0.699610 -0.09079
#> wt1     observed correlations -0.867659  0.782496  0.887980  0.6587479 -0.712441  1.0000000 -0.17472 -0.554916 -0.692495 -0.583287  0.42761
#> qsec1   observed correlations  0.418684 -0.591242 -0.433698 -0.7082234  0.091205 -0.1747159  1.00000  0.744535 -0.229861 -0.212682 -0.65625
#> vs1     observed correlations  0.664039 -0.810812 -0.710416 -0.7230967  0.440278 -0.5549157  0.74454  1.000000  0.168345  0.206023 -0.56961
#> am1     observed correlations  0.599832 -0.522607 -0.591227 -0.2432043  0.712711 -0.6924953 -0.22986  0.168345  1.000000  0.794059  0.05753
#> gear1   observed correlations  0.480285 -0.492687 -0.555569 -0.1257043  0.699610 -0.5832870 -0.21268  0.206023  0.794059  1.000000  0.27407
#> carb1   observed correlations -0.550925  0.526988  0.394977  0.7498125 -0.090790  0.4276059 -0.65625 -0.569607  0.057534  0.274073  1.00000
#> mpg2    residual correlations  0.142701  0.037749  0.036176 -0.0056745 -0.006814 -0.0333302 -0.03183 -0.041757  0.025073 -0.025738 -0.06066
#> cyl2    residual correlations  0.037749  0.066417 -0.009699 -0.0097493 -0.024309 -0.0625738 -0.04791 -0.040030  0.008061 -0.037436 -0.05146
#> disp2   residual correlations  0.036176 -0.009699  0.085818  0.0209420  0.021012  0.0159223 -0.01257 -0.004668  0.038967  0.006093 -0.07065
#> hp2     residual correlations -0.005674 -0.009749  0.020942  0.1244889  0.003215 -0.0004381  0.02344  0.075891 -0.011417  0.026756  0.00899
#> drat2   residual correlations -0.006814 -0.024309  0.021012  0.0032150  0.296700  0.0395128  0.02665  0.023523 -0.007357  0.018754  0.02982
#> wt2     residual correlations -0.033330 -0.062574  0.015922 -0.0004381  0.039513  0.1431146  0.10187  0.050409  0.007928  0.058934  0.09917
#> qsec2   residual correlations -0.031830 -0.047909 -0.012571  0.0234369  0.026646  0.1018669  0.17989  0.079680 -0.023497  0.061134  0.13732
#> vs2     residual correlations -0.041757 -0.040030 -0.004668  0.0758915  0.023523  0.0504087  0.07968  0.270807 -0.048658  0.061398  0.10408
#> am2     residual correlations  0.025073  0.008061  0.038967 -0.0114169 -0.007357  0.0079276 -0.02350 -0.048658  0.171587 -0.015576 -0.08084
#> gear2   residual correlations -0.025738 -0.037436  0.006093  0.0267561  0.018754  0.0589336  0.06113  0.061398 -0.015576  0.201949  0.06761
#> carb2   residual correlations -0.060655 -0.051460 -0.070650  0.0089904  0.029820  0.0991717  0.13732  0.104077 -0.080838  0.067607  0.22727
#> 
#> $npobs
#>      mpg cyl disp hp drat wt qsec vs am gear carb
#> mpg   32  32   32 32   32 32   32 32 32   32   32
#> cyl   32  32   32 32   32 32   32 32 32   32   32
#> disp  32  32   32 32   32 32   32 32 32   32   32
#> hp    32  32   32 32   32 32   32 32 32   32   32
#> drat  32  32   32 32   32 32   32 32 32   32   32
#> wt    32  32   32 32   32 32   32 32 32   32   32
#> qsec  32  32   32 32   32 32   32 32 32   32   32
#> vs    32  32   32 32   32 32   32 32 32   32   32
#> am    32  32   32 32   32 32   32 32 32   32   32
#> gear  32  32   32 32   32 32   32 32 32   32   32
#> carb  32  32   32 32   32 32   32 32 32   32   32
#> 
#> $residual_stats
#>                       residual_statistics    value critical                              formula
#> 1              Root Mean Squared Residual  0.04818       NA              sqrt(mean(residuals^2))
#> 2     Number of absolute residuals > 0.05 16.00000       NA                  abs(residuals)>0.05
#> 3 Proportion of absolute residuals > 0.05  0.29091      0.5 numberLargeResiduals/nrow(residuals)
#> 
#> $determinant_test
#>    determinant above_critical
#> 1 0.0000002057          FALSE
#> 
#> $bartlett_test
#>   x_squared[bartlett] df[bartlett]                                                  p[bartlett]
#> 1                 408           55 0.0000000000000000000000000000000000000000000000000000002227
#> 
#> $kmo_test
#>      Overall_MSA    MSA Kaiser_1974
#> mpg       0.8266 0.9276          NA
#> cyl       0.8266 0.8966          NA
#> disp      0.8266 0.7647          NA
#> hp        0.8266 0.8386          NA
#> drat      0.8266 0.9497          NA
#> wt        0.8266 0.7410          NA
#> qsec      0.8266 0.7401          NA
#> vs        0.8266 0.9067          NA
#> am        0.8266 0.8778          NA
#> gear      0.8266 0.8470          NA
#> carb      0.8266 0.6211          NA
#> 
#> $loadings
#>       Matrix variable   MRFA2   MRFA1               type row.names.model.Vaccounted.
#> 1    Pattern       am  0.9400  0.2200               <NA>                        <NA>
#> 2    Pattern     gear  0.9300  0.3000               <NA>                        <NA>
#> 3    Pattern     drat  0.8100 -0.0900               <NA>                        <NA>
#> 4    Pattern       wt -0.7800  0.3300               <NA>                        <NA>
#> 5    Pattern     disp -0.6900  0.5000               <NA>                        <NA>
#> 6    Pattern      mpg  0.6300 -0.5300               <NA>                        <NA>
#> 7    Pattern     qsec -0.2700 -0.9400               <NA>                        <NA>
#> 8    Pattern     carb  0.1900  0.9100               <NA>                        <NA>
#> 9    Pattern       hp -0.2300  0.8500               <NA>                        <NA>
#> 10   Pattern       vs  0.2200 -0.7700               <NA>                        <NA>
#> 11   Pattern      cyl -0.5800  0.6400               <NA>                        <NA>
#> 12 Structure       am  0.8800 -0.0300               <NA>                        <NA>
#> 13 Structure       wt -0.8700  0.5400               <NA>                        <NA>
#> 14 Structure     gear  0.8500  0.0500               <NA>                        <NA>
#> 15 Structure     disp -0.8300  0.6800               <NA>                        <NA>
#> 16 Structure     drat  0.8300 -0.3100               <NA>                        <NA>
#> 17 Structure      mpg  0.7700 -0.7000               <NA>                        <NA>
#> 18 Structure       hp -0.4600  0.9100               <NA>                        <NA>
#> 19 Structure     qsec -0.0100 -0.8700               <NA>                        <NA>
#> 20 Structure     carb -0.0600  0.8600               <NA>                        <NA>
#> 21 Structure       vs  0.4200 -0.8300               <NA>                        <NA>
#> 22 Structure      cyl -0.7500  0.7900               <NA>                        <NA>
#> 23      <NA>     <NA>  4.6556  4.4336 variance accounted                 SS loadings
#> 24      <NA>     <NA>  0.4232  0.4031 variance accounted              Proportion Var
#> 25      <NA>     <NA>  0.4232  0.8263 variance accounted              Cumulative Var
#> 26      <NA>     <NA>  0.5122  0.4878 variance accounted        Proportion Explained
#> 27      <NA>     <NA>  0.5122  1.0000 variance accounted       Cumulative Proportion
#> 
#> $instruction_loading_critical_values
#>    sample critical_loading
#> 1      50             0.75
#> 2      60             0.70
#> 3      70             0.65
#> 4      85             0.60
#> 5     100             0.55
#> 6     120             0.50
#> 7     150             0.45
#> 8     200             0.40
#> 9     250             0.35
#> 10    350             0.30
#> 
#> $weights
#>         MRFA2    MRFA1
#> mpg   0.12574 -0.03050
#> cyl  -0.31638  0.06544
#> disp -0.02264  0.26953
#> hp    0.04373  0.10023
#> drat  0.05627  0.01672
#> wt   -0.34379 -0.17444
#> qsec -0.20538 -0.28699
#> vs   -0.04278 -0.09511
#> am    0.26626  0.19282
#> gear  0.12166  0.06904
#> carb  0.34645  0.48165
#> 
model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="old.min",oblique.scores=TRUE)
report_efa(model=model,df=mtcars)






#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> $correlation_loadings

#> 
#> $plot_barplot

#> 
#> [[1]]

#> 
#> $correlations
#>                          type       mpg        cyl      disp        hp      drat       wt     qsec       vs         am      gear     carb
#> mpg   reproduced correlations  0.847173 -0.8839678 -0.871480 -0.765672  0.682946 -0.81407  0.44743  0.69483  0.5655512  0.499096 -0.47106
#> cyl   reproduced correlations -0.883968  0.9326071  0.904044  0.842179 -0.673037  0.82879 -0.54251 -0.76315 -0.5228804 -0.449176  0.55522
#> disp  reproduced correlations -0.871480  0.9040442  0.899211  0.765326 -0.722957  0.84808 -0.42124 -0.69509 -0.6164656 -0.550355  0.45171
#> hp    reproduced correlations -0.765672  0.8421792  0.765326  0.874591 -0.450203  0.64863 -0.72371 -0.78898 -0.2273294 -0.148850  0.69466
#> drat  reproduced correlations  0.682946 -0.6730371 -0.722957 -0.450203  0.703381 -0.73597  0.06855  0.41284  0.7155789  0.678856 -0.13371
#> wt    reproduced correlations -0.814070  0.8287870  0.848075  0.648627 -0.735972  0.82384 -0.27757 -0.59085 -0.6788875 -0.623818  0.32432
#> qsec  reproduced correlations  0.447430 -0.5425085 -0.421240 -0.723707  0.068548 -0.27757  0.79478  0.64855 -0.1976830 -0.264993 -0.71912
#> vs    reproduced correlations  0.694827 -0.7631453 -0.695086 -0.788981  0.412836 -0.59085  0.64855  0.71185  0.2135815  0.142836 -0.62348
#> am    reproduced correlations  0.565551 -0.5228804 -0.616466 -0.227329  0.715579 -0.67889 -0.19768  0.21358  0.8187284  0.802994  0.10356
#> gear  reproduced correlations  0.499096 -0.4491757 -0.550355 -0.148850  0.678856 -0.62382 -0.26499  0.14284  0.8029944  0.794331  0.16764
#> carb  reproduced correlations -0.471057  0.5552227  0.451705  0.694661 -0.133706  0.32432 -0.71912 -0.62348  0.1035640  0.167643  0.65802
#> mpg1    observed correlations  1.000000 -0.8521620 -0.847551 -0.776168  0.681172 -0.86766  0.41868  0.66404  0.5998324  0.480285 -0.55093
#> cyl1    observed correlations -0.852162  1.0000000  0.902033  0.832447 -0.699938  0.78250 -0.59124 -0.81081 -0.5226070 -0.492687  0.52699
#> disp1   observed correlations -0.847551  0.9020329  1.000000  0.790949 -0.710214  0.88798 -0.43370 -0.71042 -0.5912270 -0.555569  0.39498
#> hp1     observed correlations -0.776168  0.8324475  0.790949  1.000000 -0.448759  0.65875 -0.70822 -0.72310 -0.2432043 -0.125704  0.74981
#> drat1   observed correlations  0.681172 -0.6999381 -0.710214 -0.448759  1.000000 -0.71244  0.09120  0.44028  0.7127111  0.699610 -0.09079
#> wt1     observed correlations -0.867659  0.7824958  0.887980  0.658748 -0.712441  1.00000 -0.17472 -0.55492 -0.6924953 -0.583287  0.42761
#> qsec1   observed correlations  0.418684 -0.5912421 -0.433698 -0.708223  0.091205 -0.17472  1.00000  0.74454 -0.2298609 -0.212682 -0.65625
#> vs1     observed correlations  0.664039 -0.8108118 -0.710416 -0.723097  0.440278 -0.55492  0.74454  1.00000  0.1683451  0.206023 -0.56961
#> am1     observed correlations  0.599832 -0.5226070 -0.591227 -0.243204  0.712711 -0.69250 -0.22986  0.16835  1.0000000  0.794059  0.05753
#> gear1   observed correlations  0.480285 -0.4926866 -0.555569 -0.125704  0.699610 -0.58329 -0.21268  0.20602  0.7940588  1.000000  0.27407
#> carb1   observed correlations -0.550925  0.5269883  0.394977  0.749812 -0.090790  0.42761 -0.65625 -0.56961  0.0575344  0.274073  1.00000
#> mpg2    residual correlations  0.152827  0.0318058  0.023928 -0.010496 -0.001774 -0.05359 -0.02875 -0.03079  0.0342812 -0.018811 -0.07987
#> cyl2    residual correlations  0.031806  0.0673929 -0.002011 -0.009732 -0.026901 -0.04629 -0.04873 -0.04767  0.0002734 -0.043511 -0.02823
#> disp2   residual correlations  0.023928 -0.0020113  0.100789  0.025623  0.012743  0.03990 -0.01246 -0.01533  0.0252386 -0.005215 -0.05673
#> hp2     residual correlations -0.010496 -0.0097317  0.025623  0.125409  0.001444  0.01012  0.01548  0.06588 -0.0158749  0.023145  0.05515
#> drat2   residual correlations -0.001774 -0.0269010  0.012743  0.001444  0.296619  0.02353  0.02266  0.02744 -0.0028677  0.020754  0.04292
#> wt2     residual correlations -0.053590 -0.0462912  0.039905  0.010121  0.023531  0.17616  0.10285  0.03593 -0.0136078  0.040531  0.10328
#> qsec2   residual correlations -0.028746 -0.0487336 -0.012458  0.015483  0.022657  0.10285  0.20522  0.09599 -0.0321779  0.052310  0.06287
#> vs2     residual correlations -0.030788 -0.0476665 -0.015330  0.065884  0.027443  0.03593  0.09599  0.28815 -0.0452364  0.063187  0.05388
#> am2     residual correlations  0.034281  0.0002734  0.025239 -0.015875 -0.002868 -0.01361 -0.03218 -0.04524  0.1812716 -0.008936 -0.04603
#> gear2   residual correlations -0.018811 -0.0435109 -0.005215  0.023145  0.020754  0.04053  0.05231  0.06319 -0.0089356  0.205669  0.10643
#> carb2   residual correlations -0.079868 -0.0282344 -0.056728  0.055152  0.042916  0.10328  0.06287  0.05388 -0.0460296  0.106430  0.34198
#> 
#> $npobs
#>      mpg cyl disp hp drat wt qsec vs am gear carb
#> mpg   32  32   32 32   32 32   32 32 32   32   32
#> cyl   32  32   32 32   32 32   32 32 32   32   32
#> disp  32  32   32 32   32 32   32 32 32   32   32
#> hp    32  32   32 32   32 32   32 32 32   32   32
#> drat  32  32   32 32   32 32   32 32 32   32   32
#> wt    32  32   32 32   32 32   32 32 32   32   32
#> qsec  32  32   32 32   32 32   32 32 32   32   32
#> vs    32  32   32 32   32 32   32 32 32   32   32
#> am    32  32   32 32   32 32   32 32 32   32   32
#> gear  32  32   32 32   32 32   32 32 32   32   32
#> carb  32  32   32 32   32 32   32 32 32   32   32
#> 
#> $residual_stats
#>                       residual_statistics    value critical                              formula
#> 1              Root Mean Squared Residual  0.04424       NA              sqrt(mean(residuals^2))
#> 2     Number of absolute residuals > 0.05 13.00000       NA                  abs(residuals)>0.05
#> 3 Proportion of absolute residuals > 0.05  0.23636      0.5 numberLargeResiduals/nrow(residuals)
#> 
#> $determinant_test
#>    determinant above_critical
#> 1 0.0000002057          FALSE
#> 
#> $bartlett_test
#>   x_squared[bartlett] df[bartlett]                                                  p[bartlett]
#> 1                 408           55 0.0000000000000000000000000000000000000000000000000000002227
#> 
#> $kmo_test
#>      Overall_MSA    MSA Kaiser_1974
#> mpg       0.8266 0.9276          NA
#> cyl       0.8266 0.8966          NA
#> disp      0.8266 0.7647          NA
#> hp        0.8266 0.8386          NA
#> drat      0.8266 0.9497          NA
#> wt        0.8266 0.7410          NA
#> qsec      0.8266 0.7401          NA
#> vs        0.8266 0.9067          NA
#> am        0.8266 0.8778          NA
#> gear      0.8266 0.8470          NA
#> carb      0.8266 0.6211          NA
#> 
#> $loadings
#>       Matrix variable oldmin1 oldmin2               type row.names.model.Vaccounted.
#> 1    Pattern     qsec -0.9300 -0.3400               <NA>                        <NA>
#> 2    Pattern       hp  0.8900 -0.1400               <NA>                        <NA>
#> 3    Pattern     carb  0.8500  0.2300               <NA>                        <NA>
#> 4    Pattern       vs -0.8000  0.1300               <NA>                        <NA>
#> 5    Pattern      cyl  0.7000 -0.4900               <NA>                        <NA>
#> 6    Pattern      mpg -0.6000  0.5500               <NA>                        <NA>
#> 7    Pattern       am  0.1400  0.9400               <NA>                        <NA>
#> 8    Pattern     gear  0.2300  0.9300               <NA>                        <NA>
#> 9    Pattern     drat -0.1600  0.7800               <NA>                        <NA>
#> 10   Pattern       wt  0.4100 -0.7100               <NA>                        <NA>
#> 11   Pattern     disp  0.5700 -0.6100               <NA>                        <NA>
#> 12 Structure       hp  0.9300 -0.3900               <NA>                        <NA>
#> 13 Structure      cyl  0.8400 -0.6900               <NA>                        <NA>
#> 14 Structure     qsec -0.8300 -0.0800               <NA>                        <NA>
#> 15 Structure       vs -0.8300  0.3600               <NA>                        <NA>
#> 16 Structure     carb  0.7800 -0.0100               <NA>                        <NA>
#> 17 Structure      mpg -0.7500  0.7200               <NA>                        <NA>
#> 18 Structure       am -0.1200  0.8900               <NA>                        <NA>
#> 19 Structure     gear -0.0400  0.8600               <NA>                        <NA>
#> 20 Structure     drat -0.3800  0.8200               <NA>                        <NA>
#> 21 Structure       wt  0.6100 -0.8200               <NA>                        <NA>
#> 22 Structure     disp  0.7400 -0.7700               <NA>                        <NA>
#> 23      <NA>     <NA>  4.6601  4.1984 variance accounted                 SS loadings
#> 24      <NA>     <NA>  0.4236  0.3817 variance accounted              Proportion Var
#> 25      <NA>     <NA>  0.4236  0.8053 variance accounted              Cumulative Var
#> 26      <NA>     <NA>  0.5261  0.4739 variance accounted        Proportion Explained
#> 27      <NA>     <NA>  0.5261  1.0000 variance accounted       Cumulative Proportion
#> 
#> $instruction_loading_critical_values
#>    sample critical_loading
#> 1      50             0.75
#> 2      60             0.70
#> 3      70             0.65
#> 4      85             0.60
#> 5     100             0.55
#> 6     120             0.50
#> 7     150             0.45
#> 8     200             0.40
#> 9     250             0.35
#> 10    350             0.30
#> 
#> $weights
#>       oldmin1  oldmin2
#> mpg  -0.09760  0.11552
#> cyl   0.38551 -0.11616
#> disp -0.24251 -0.45299
#> hp    0.39093  0.27781
#> drat  0.09590  0.13713
#> wt    0.25525  0.09710
#> qsec -0.30211 -0.29923
#> vs   -0.10511 -0.07628
#> am    0.19842  0.28468
#> gear  0.27461  0.29736
#> carb -0.05401 -0.04296
#> 
model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="alpha",oblique.scores=TRUE)
#report_efa(model=model,df=mtcars)
```
