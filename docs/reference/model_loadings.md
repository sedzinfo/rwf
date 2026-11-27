# Pattern and structure matrix

Pattern and structure matrix

## Usage

``` r
model_loadings(model, cut = NULL, matrix_type = "pattern", sort = TRUE, ...)
```

## Arguments

- model:

  psych EFA model

- cut:

  cut point for loadings

- matrix_type:

  "pattern" "structure" "all"

- sort:

  if TRUE it will sort loadings

- ...:

  arguments passed to psych::fa.sort

## Note

Check to see if you have multicolinearity values above .8 in the matrix
are problematic\
Structure matrix represents Loadings after rotation\
Pattern matrix represents Loadings before rotation\

## Examples

``` r
model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="pa",oblique.scores=TRUE)
model_loadings(model=model,cut=NULL,matrix_type="pattern")
#>       Matrix variable   PA2  PA1
#> qsec Pattern     qsec -0.92     
#> hp   Pattern       hp  0.89     
#> carb Pattern     carb  0.85     
#> vs   Pattern       vs  -0.8     
#> cyl  Pattern      cyl           
#> mpg  Pattern      mpg           
#> am   Pattern       am       0.93
#> gear Pattern     gear       0.93
#> drat Pattern     drat       0.78
#> wt   Pattern       wt           
#> disp Pattern     disp           
model_loadings(model=model,cut=0.4,matrix_type="structure")
#>         Matrix variable   PA2   PA1
#> hp   Structure       hp  0.93      
#> cyl  Structure      cyl  0.85 -0.68
#> vs   Structure       vs -0.83      
#> qsec Structure     qsec -0.82      
#> carb Structure     carb  0.78      
#> mpg  Structure      mpg -0.76  0.72
#> am   Structure       am        0.89
#> gear Structure     gear        0.87
#> drat Structure     drat        0.83
#> wt   Structure       wt  0.61 -0.81
#> disp Structure     disp  0.75 -0.77
model_loadings(model=model,cut=0.4,matrix_type="all",sort=FALSE)
#>       Matrix variable   PA2   PA1
#> 1    Pattern      mpg -0.61  0.55
#> 2    Pattern      cyl  0.71 -0.48
#> 3    Pattern     disp  0.58  -0.6
#> 4    Pattern       hp  0.89      
#> 5    Pattern     drat        0.78
#> 6    Pattern       wt  0.42  -0.7
#> 7    Pattern     qsec -0.92      
#> 8    Pattern       vs  -0.8      
#> 9    Pattern       am        0.93
#> 10   Pattern     gear        0.93
#> 11   Pattern     carb  0.85      
#> 12 Structure      mpg -0.76  0.72
#> 13 Structure      cyl  0.85 -0.68
#> 14 Structure     disp  0.75 -0.77
#> 15 Structure       hp  0.93      
#> 16 Structure     drat        0.83
#> 17 Structure       wt  0.61 -0.81
#> 18 Structure     qsec -0.82      
#> 19 Structure       vs -0.83      
#> 20 Structure       am        0.89
#> 21 Structure     gear        0.87
#> 22 Structure     carb  0.78      
```
