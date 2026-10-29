# Structural equation modeling and CFA

## Description

This shows the output of Structural Equation Modeling (SEM) and
Confirmatory Factor Analysis (CFA) functions from the package rwf. The
functions include a path diagram plotter that does not need `semPlot`, a
full CFA report (fit indices, parameter estimates, modification indices,
predicted scores), and a sample-size planning simulation that tracks how
model fit changes as sample size grows.

Installation instructions for rwf can be found
[here](https://github.com/sedzinfo/rwf)

The code can be found
[here](https://github.com/sedzinfo/rwf/blob/main/rwf/R/GLM_SEM.R)

## Theoretical Background

### Confirmatory Factor Analysis

CFA specifies, in advance, which observed indicators load onto which
latent factors (unlike EFA, which discovers the structure). For a
single-indicator relationship,

x_i = \lambda_i \eta + \epsilon_i

where \eta is the latent factor, \lambda_i is the factor loading (how
strongly indicator i reflects the factor), and \epsilon_i is measurement
error. The model is fit by finding parameter values that best reproduce
the observed covariance matrix among indicators.

### Model fit indices

Every index in the report is listed with its reference in [Fit indices
in the report](#fit-indices-in-the-report).

### Modification indices

A modification index estimates how much \chi^2 would drop if a
currently-fixed parameter (typically a residual covariance, or a
cross-loading) were freed and re-estimated. Large indices flag places
where the model doesn’t match the data — but freeing parameters purely
to improve fit, without substantive justification, risks overfitting to
sample-specific noise rather than reflecting genuine structure.

### Sample size and power for SEM

SEM fit indices and standard errors are sample-size dependent: small
samples can fail to reject a poorly-fitting model (low power) while very
large samples can flag trivial misfit as statistically significant.
`simulate_cfa_fit` directly visualizes how fit indices stabilize as
sample size grows, supporting sample-size planning before data
collection.

------------------------------------------------------------------------

## Model Diagrams

`plot_cfa_gg` draws a path diagram directly in `ggplot2` (no
`semPlot`/Rgraphviz system dependency), with latent variables as filled
rectangles, observed variables as light rectangles, and edges labeled
with loadings.

``` r

model_syntax <- "LATENT1=~X1+X2+X3
                 LATENT2=~X4+X5+X6"
df_cfa <- lavaan::simulateData(model = model_syntax, model.type = "cfa", return.type = "data.frame", sample.nobs = 300)
fit <- lavaan::cfa(model_syntax, data = df_cfa)
```

``` r

plot_cfa_gg(fit, what = "std", layout = "tree")
```

![](GLM_SEM_files/figure-html/plot_cfa_std-1.png)

``` r

plot_cfa_gg(fit, what = "est", layout = "circle")
```

![](GLM_SEM_files/figure-html/plot_cfa_est-1.png)

`what = "std"` shows standardized loadings (comparable across indicators
regardless of their original scale); `what = "est"` shows raw,
unstandardized estimates (in the original metric of each indicator).
Three `layout` options (`tree`, `circle`, `spring`) control node
placement via `igraph`.

### Equality constraints

`what = "eq"` labels each loading with its parameter label, so loadings
constrained to be equal (sharing the same label) are easy to spot;
loadings without a label show their estimate. It needs a model with
labelled parameters. Here the loadings of X2 and X3 are constrained to
be equal (`a`), and so are those of X5 and X6 (`b`):

``` r

model_eq <- "LATENT1=~X1+a*X2+a*X3
             LATENT2=~X4+b*X5+b*X6"
fit_eq <- lavaan::cfa(model_eq, data = df_cfa)
plot_cfa_gg(fit_eq, what = "eq", layout = "spring")
```

![](GLM_SEM_files/figure-html/plot_cfa_eq-1.png)

### Styling

`label_size` and `edge_label_size` set the text size of the node and
path labels; `color_latent` and `color_observed` set the fill colour of
the latent and observed nodes:

``` r

plot_cfa_gg(fit, what = "std", layout = "tree",
            label_size = 4, edge_label_size = 3.5,
            color_latent = "#2c3e50", color_observed = "#ecf0f1")
```

![](GLM_SEM_files/figure-html/plot_cfa_style-1.png)

### All layouts at once

`plot_cfa` is a batch wrapper that runs every combination of `layout` ×
`what` in one call and returns them as a named list — useful for quickly
picking the clearest arrangement for a report. The three `eq` diagrams
are only produced for models with labelled parameters, so `fit` gives 6
diagrams and `fit_eq` gives all 9:

``` r

all_plots <- plot_cfa(fit)
all_plots_eq <- plot_cfa(fit_eq)
```

``` r

names(all_plots)
```

    ## [1] "circle_estimates"          "circle_standard_estimates" "tree_estimates"            "tree_standard_estimates"   "spring_estimates"          "spring_standard_estimates"

``` r

names(all_plots_eq)
```

    ## [1] "circle_estimates"                           "circle_standard_estimates"                  "circle_parameters_wih_equality_constraints" "tree_estimates"                            
    ## [5] "tree_standard_estimates"                    "tree_parameters_wih_equality_constraints"   "spring_estimates"                           "spring_standard_estimates"                 
    ## [9] "spring_parameters_wih_equality_constraints"

Any diagram can be taken from the list by name:

``` r

all_plots$spring_standard_estimates
```

![](GLM_SEM_files/figure-html/plot_cfa_batch_one-1.png)

## Full CFA Report

`report_cfa` bundles fit indices, R², parameter estimates
(unstandardized and standardized), modification indices, sample
covariance, model-implied predicted scores, and the path diagrams into
one structured report.

``` r

result <- report_cfa(model = fit)
```

![](GLM_SEM_files/figure-html/report_cfa-1.png)![](GLM_SEM_files/figure-html/report_cfa-2.png)![](GLM_SEM_files/figure-html/report_cfa-3.png)![](GLM_SEM_files/figure-html/report_cfa-4.png)![](GLM_SEM_files/figure-html/report_cfa-5.png)![](GLM_SEM_files/figure-html/report_cfa-6.png)

``` r

result$fit_indices
```

    ##                                 fit
    ## npar                   1.300000e+01
    ## fmin                   1.410897e-02
    ## chisq                  8.465381e+00
    ## df                     8.000000e+00
    ## pvalue                 3.893785e-01
    ## baseline.chisq         4.184732e+02
    ## baseline.df            1.500000e+01
    ## baseline.pvalue        0.000000e+00
    ## cfi                    9.988466e-01
    ## tli                    9.978373e-01
    ## nnfi                   9.978373e-01
    ## rfi                    9.620702e-01
    ## nfi                    9.797708e-01
    ## pnfi                   5.225444e-01
    ## ifi                    9.988662e-01
    ## rni                    9.988466e-01
    ## logl                  -2.939962e+03
    ## unrestricted.logl     -2.935729e+03
    ## aic                    5.905923e+03
    ## bic                    5.954072e+03
    ## ntotal                 3.000000e+02
    ## bic2                   5.912844e+03
    ## rmsea                  1.392512e-02
    ## rmsea.ci.lower         0.000000e+00
    ## rmsea.ci.upper         7.006258e-02
    ## rmsea.ci.level         9.000000e-01
    ## rmsea.pvalue           8.055863e-01
    ## rmsea.close.h0         5.000000e-02
    ## rmsea.notclose.pvalue  1.981321e-02
    ## rmsea.notclose.h0      8.000000e-02
    ## rmr                    5.371712e-02
    ## rmr_nomean             5.371712e-02
    ## srmr                   2.836043e-02
    ## srmr_bentler           2.836043e-02
    ## srmr_bentler_nomean    2.836043e-02
    ## crmr                   3.355651e-02
    ## crmr_nomean            3.355651e-02
    ## srmr_mplus             2.836043e-02
    ## srmr_mplus_nomean      2.836043e-02
    ## gfi                    9.995555e-01
    ## gfi.ci.lower           9.871986e-01
    ## gfi.ci.upper           1.000000e+00
    ## gfi.ci.level           9.000000e-01
    ## cn_05                  5.505551e+02
    ## cn_01                  7.129668e+02
    ## gfi_lisrel             9.907527e-01
    ## agfi_lisrel            9.757259e-01
    ## pgfi                   3.774296e-01
    ## mfi                    9.992247e-01
    ## ecvi                   1.148846e-01

``` r

result$r_squared
```

    ##    r_squared
    ## X1 0.5097622
    ## X2 0.5809755
    ## X3 0.4796281
    ## X4 0.4181322
    ## X5 0.5162224
    ## X6 0.4683997

``` r

result$parameters
```

    ##        lhs op     rhs exo         est         se          z       pvalue   ci.lower  ci.upper      std.lv     std.all
    ## 1  LATENT1 =~      X1   0  1.00000000 0.00000000         NA           NA  1.0000000 1.0000000  1.05053670  0.71397632
    ## 2  LATENT1 =~      X2   0  1.04940012 0.11347769  9.2476336 0.000000e+00  0.8269879 1.2718123  1.10243334  0.76221747
    ## 3  LATENT1 =~      X3   0  0.91191842 0.09881219  9.2288053 0.000000e+00  0.7182501 1.1055867  0.95800377  0.69255185
    ## 4  LATENT2 =~      X4   0  1.00000000 0.00000000         NA           NA  1.0000000 1.0000000  0.89617650  0.64663146
    ## 5  LATENT2 =~      X5   0  1.05833263 0.13622370  7.7690784 7.993606e-15  0.7913391 1.3253262  0.94845283  0.71848618
    ## 6  LATENT2 =~      X6   0  1.01635591 0.12980269  7.8300067 4.884981e-15  0.7619473 1.2707645  0.91083428  0.68439730
    ## 7       X1 ~~      X1   0  1.06135741 0.13317475  7.9696594 1.554312e-15  0.8003397 1.3223751  1.06135741  0.49023782
    ## 8       X2 ~~      X2   0  0.87656944 0.13237244  6.6219934 3.543876e-11  0.6171242 1.1360147  0.87656944  0.41902453
    ## 9       X3 ~~      X3   0  0.99573484 0.11696934  8.5127850 0.000000e+00  0.7664791 1.2249905  0.99573484  0.52037193
    ## 10      X4 ~~      X4   0  1.11762920 0.12965572  8.6199761 0.000000e+00  0.8635087 1.3717497  1.11762920  0.58186776
    ## 11      X5 ~~      X5   0  0.84302488 0.12401129  6.7979687 1.061040e-11  0.5999672 1.0860825  0.84302488  0.48377761
    ## 12      X6 ~~      X6   0  0.94155870 0.12231645  7.6977275 1.376677e-14  0.7018229 1.1812945  0.94155870  0.53160033
    ## 13 LATENT1 ~~ LATENT1   0  1.10362735 0.18429193  5.9884737 2.118194e-09  0.7424218 1.4648329  1.00000000  1.00000000
    ## 14 LATENT2 ~~ LATENT2   0  0.80313231 0.15732611  5.1048890 3.309887e-07  0.4947788 1.1114858  1.00000000  1.00000000
    ## 15 LATENT1 ~~ LATENT2   0 -0.02254035 0.07268426 -0.3101133 7.564748e-01 -0.1649989 0.1199182 -0.02394175 -0.02394175
    ## 16      X1 r2      X1   0  0.50976218         NA         NA           NA         NA        NA          NA          NA
    ## 17      X2 r2      X2   0  0.58097547         NA         NA           NA         NA        NA          NA          NA
    ## 18      X3 r2      X3   0  0.47962807         NA         NA           NA         NA        NA          NA          NA
    ## 19      X4 r2      X4   0  0.41813224         NA         NA           NA         NA        NA          NA          NA
    ## 20      X5 r2      X5   0  0.51622239         NA         NA           NA         NA        NA          NA          NA
    ## 21      X6 r2      X6   0  0.46839967         NA         NA           NA         NA        NA          NA          NA

``` r

result$modification_indices[order(-result$modification_indices$mi), ]
```

    ##        lhs op     rhs           mi           epc      sepc.all delta          ncp      power decision
    ## 35      X4 ~~      X6 3.394818e+00  5.166441e+00  5.036385e+00   0.1 0.0012718431 0.05014570      (i)
    ## 17 LATENT1 =~      X5 3.394745e+00 -1.368874e-01 -1.089375e-01   0.1 1.8116754952 0.27008787      (i)
    ## 33      X3 ~~      X6 3.166415e+00  1.291835e-01  1.334171e-01   0.1 1.8973770837 0.28053412      (i)
    ## 32      X3 ~~      X5 2.265033e+00 -1.071722e-01 -1.169742e-01   0.1 1.9720149578 0.28959875      (i)
    ## 28      X2 ~~      X4 1.982602e+00  1.094326e-01  1.105616e-01   0.1 1.6555509662 0.25096787      (i)
    ## 30      X2 ~~      X6 1.499302e+00 -9.003308e-02 -9.910264e-02   0.1 1.8496303201 0.27471896      (i)
    ## 18 LATENT1 =~      X6 1.342336e+00  8.609855e-02  6.796354e-02   0.1 1.8107954566 0.26998040      (i)
    ## 34      X4 ~~      X5 1.342139e+00 -3.523223e+00 -3.629703e+00   0.1 0.0010812275 0.05012386      (i)
    ## 24      X1 ~~      X4 6.998506e-01 -6.754728e-02 -6.201949e-02   0.1 1.5338736428 0.23600179      (i)
    ## 16 LATENT1 =~      X4 6.498502e-01  6.248254e-02  4.736234e-02   0.1 1.6645463793 0.25207227      (i)
    ## 36      X5 ~~      X6 6.496986e-01 -2.641045e+00 -2.964367e+00   0.1 0.0009314516 0.05010670      (i)
    ## 26      X1 ~~      X6 4.995397e-01  5.395593e-02  5.397401e-02   0.1 1.7158987359 0.25837088      (i)
    ## 19 LATENT2 =~      X1 8.671187e-02 -2.761617e-02 -1.682014e-02   0.1 1.1369772631 0.18698655      (i)
    ## 27      X2 ~~      X3 8.668570e-02  1.038472e+00  1.111552e+00   0.1 0.0008038185 0.05009208      (i)
    ## 21 LATENT2 =~      X3 5.838617e-02  2.140776e-02  1.386915e-02   0.1 1.2739940686 0.20392131      (i)
    ## 22      X1 ~~      X2 5.836548e-02 -9.680087e-01 -1.003588e+00   0.1 0.0006228702 0.05007135      (i)
    ## 25      X1 ~~      X5 4.390232e-02 -1.569374e-02 -1.659111e-02   0.1 1.7825203616 0.26652563      (i)
    ## 31      X3 ~~      X4 4.294430e-03  5.032793e-03  4.770768e-03   0.1 1.6954598966 0.25586523      (i)
    ## 20 LATENT2 =~      X2 3.308077e-03  5.317839e-03  3.294999e-03   0.1 1.1697828955 0.19104052      (i)
    ## 23      X1 ~~      X3 3.307787e-03 -1.816063e-01 -1.766559e-01   0.1 0.0010029422 0.05011490      (i)
    ## 29      X2 ~~      X5 8.091584e-04 -2.053847e-03 -2.389212e-03   0.1 1.9182151487 0.28306810      (i)
    ## 11      X5 ~~      X5 1.007374e-11 -3.081256e-07 -4.837776e-01   0.1 1.0610483070 0.17760823      (i)
    ## 12      X6 ~~      X6 8.559038e-12 -2.960419e-07 -5.316003e-01   0.1 0.9766040392 0.16719031      (i)
    ## 10      X4 ~~      X4 2.553316e-12 -1.813523e-07 -5.818678e-01   0.1 0.7763518603 0.14257414      (i)
    ## 6  LATENT2 =~      X6 1.964368e-12 -1.114443e-07 -7.504477e-08   0.1 1.5816377974 0.24188237      (i)
    ## 15 LATENT1 ~~ LATENT2 1.949928e-12  1.013783e-07  1.076812e-07   0.1 1.8972693099 0.28052100      (i)
    ## 14 LATENT2 ~~ LATENT2 1.495602e-12 -1.102320e-07 -1.000000e+00   0.1 1.2308375348 0.19858693      (i)
    ## 9       X3 ~~      X3 1.357357e-12  1.201982e-07  5.203719e-01   0.1 0.9395039976 0.16261893      (i)
    ## 13 LATENT1 ~~ LATENT1 7.381495e-13  1.005109e-07  1.000000e+00   0.1 0.7306652686 0.13698275      (i)
    ## 5  LATENT2 =~      X5 6.029296e-13 -5.954292e-08 -4.042280e-08   0.1 1.7006160664 0.25649751      (i)
    ## 3  LATENT1 =~      X3 3.351878e-13  3.921372e-08  2.978066e-08   0.1 2.1797772214 0.31464489      (i)
    ## 7       X1 ~~      X1 2.275846e-13 -5.433439e-08 -4.902378e-01   0.1 0.7708913364 0.14190528      (i)
    ## 2  LATENT1 =~      X2 8.058919e-14  1.889164e-08  1.372168e-08   0.1 2.2580709464 0.32400375      (i)
    ## 8       X2 ~~      X2 6.361666e-14  2.650224e-08  4.190245e-01   0.1 0.9057444156 0.15846284      (i)

- **`fit_indices`**: the full `lavaan` fit table (CFI, TLI, RMSEA + CI,
  SRMR, AIC, BIC, etc.).
- **`r_squared`**: proportion of each indicator’s variance explained by
  its latent factor.
- **`parameters`**: every estimated parameter (loadings, variances,
  covariances) with SE, z, p, and confidence intervals.
- **`modification_indices`**: sorted here by size — the largest values
  are the parameters most likely to improve fit if freed (again, only
  worth freeing with a substantive rationale).

The rest of the report holds the input data and model matrices:

``` r

result$sample_covariance
```

    ##            X1          X2          X3          X4          X5          X6
    ## 1  2.16498482  1.15795978  1.00635404 -0.03586956 -0.11364379  0.04557297
    ## 2  1.15795978  2.09192882  1.05637825  0.07798752 -0.09721179 -0.01665839
    ## 3  1.00635404  1.05637825  1.91350623  0.02699628 -0.13486048  0.10953145
    ## 4 -0.03586956  0.07798752  0.02699628  1.92076138  0.84878467  0.81857306
    ## 5 -0.11364379 -0.09721179 -0.13486048  0.84878467  1.74258736  0.86323231
    ## 6  0.04557297 -0.01665839  0.10953145  0.81857306  0.86323231  1.77117744

``` r

result$standardized_estimates
```

    ## $lambda
    ##    LATENT1 LATENT2
    ## X1   0.714   0.000
    ## X2   0.762   0.000
    ## X3   0.693   0.000
    ## X4   0.000   0.647
    ## X5   0.000   0.718
    ## X6   0.000   0.684
    ## 
    ## $theta
    ##       X1    X2    X3    X4    X5    X6
    ## X1 0.490                              
    ## X2 0.000 0.419                        
    ## X3 0.000 0.000 0.520                  
    ## X4 0.000 0.000 0.000 0.582            
    ## X5 0.000 0.000 0.000 0.000 0.484      
    ## X6 0.000 0.000 0.000 0.000 0.000 0.532
    ## 
    ## $psi
    ##         LATENT1 LATENT2
    ## LATENT1   1.000        
    ## LATENT2  -0.024   1.000

``` r

head(result$predict)
```

    ##           X1         X2         X3         X4         X5         X6    LATENT1    LATENT2
    ## 1 -1.9067342 -0.8628151 -0.2705948  1.3446878 -0.9457707 -0.6144465 -0.7639561 -0.1515991
    ## 2  0.1952525 -1.1245288  0.5688888  3.2133725  4.6475442  1.3692525 -0.1610330  2.2178810
    ## 3 -2.7513374  0.7630427  0.1038519  0.5729471 -1.6735123 -2.5231921 -0.3797068 -0.9562469
    ## 4  1.0453496  2.2324965  3.0276794 -0.9433231 -1.4945343 -2.3286911  1.6555615 -1.1695109
    ## 5  0.7261056  0.3029449 -0.4017335 -0.6748330 -0.6954542 -1.6117709  0.1929808 -0.7195893
    ## 6  1.0277574 -0.5210594 -1.2306230  1.8513064  1.7918047  2.6459962 -0.1920262  1.4678569

``` r

result$call
```

    ##                                                                call
    ## 1   lavaan::lavaan(model=model_syntax,data=df_cfa,model.type="cfa",
    ## 2 cmd="cfa",int.ov.free=TRUE,int.lv.free=FALSE,auto.fix.first=TRUE,
    ## 3            auto.fix.single=TRUE,auto.var=TRUE,auto.cov.lv.x=TRUE,
    ## 4       auto.cov.y=TRUE,auto.th=TRUE,auto.delta=TRUE,auto.efa=TRUE)

- **`sample_covariance`**: the observed covariance matrix of the
  indicators that the model tries to reproduce.
- **`unstandardized_estimates`** / **`standardized_estimates`**: the
  model matrices — `lambda` (loadings), `theta` (residual variances and
  covariances) and `psi` (factor variances and covariances).
- **`predict`**: the observed data with each case’s predicted factor
  scores added as extra columns.
- **`call`**: the `lavaan` call that fitted the model.

With `file`, the report is also saved: `report_cfa(fit, file = "cfa")`
writes every table to `cfa.xlsx` and all diagrams to `cfa_diagram.pdf`,
with `w` and `h` setting the PDF page size in inches.

### Fit indices in the report

`result$fit_indices` holds every fit measure `lavaan` computes (Rosseel,
2012). Cut-offs are given only where the literature gives one; “lower is
better” indices are for comparing models fitted to the same data. The
`_nomean` variants ignore the mean structure, so they equal the plain
index when the model has no means, as here.

| Row in `fit_indices` | Index | Good fit | Reference |
|----|----|----|----|
| `npar` | Number of free parameters | — | — |
| `fmin` | Minimum of the fit function, \chi^2/(2N) | — | Jöreskog (1969) |
| `chisq`, `df`, `pvalue` | \chi^2 test of exact fit | p \> .05 | Jöreskog (1969) |
| `baseline.chisq`, `baseline.df`, `baseline.pvalue` | \chi^2 test of the baseline (independence) model, used by the incremental indices | — | Bentler & Bonett (1980) |
| `cfi` | Comparative Fit Index | \geq .95 | Bentler (1990); Hu & Bentler (1999) |
| `tli`, `nnfi` | Tucker-Lewis Index / Non-Normed Fit Index (same value) | \geq .95 | Tucker & Lewis (1973); Bentler & Bonett (1980); Hu & Bentler (1999) |
| `rfi` | Relative Fit Index | close to 1 | Bollen (1986) |
| `nfi` | Normed Fit Index | \geq .90 | Bentler & Bonett (1980) |
| `pnfi` | Parsimony Normed Fit Index | higher is better | James et al. (1982) |
| `ifi` | Incremental Fit Index | close to 1 | Bollen (1989a) |
| `rni` | Relative Noncentrality Index | \geq .95 | McDonald & Marsh (1990); Hu & Bentler (1999) |
| `logl`, `unrestricted.logl` | Log-likelihood of the model and of the saturated model | — | Jöreskog (1969) |
| `aic` | Akaike Information Criterion | lower is better | Akaike (1974) |
| `bic` | Bayesian Information Criterion | lower is better | Schwarz (1978) |
| `ntotal` | Total sample size | — | — |
| `bic2` | Sample-size adjusted BIC | lower is better | Sclove (1987) |
| `rmsea` | Root Mean Square Error of Approximation | \leq .06 | Steiger & Lind (1980); Steiger (1990); Hu & Bentler (1999) |
| `rmsea.ci.lower`, `rmsea.ci.upper`, `rmsea.ci.level` | 90% confidence interval of RMSEA | — | Browne & Cudeck (1992) |
| `rmsea.pvalue`, `rmsea.close.h0` | Test of close fit, H_0: RMSEA \leq .05 | p \> .05 | Browne & Cudeck (1992) |
| `rmsea.notclose.pvalue`, `rmsea.notclose.h0` | Test of not-close fit, H_0: RMSEA \geq .08 | p \< .05 | MacCallum et al. (1996) |
| `rmr`, `rmr_nomean` | Root Mean Square Residual (unstandardized, depends on the scale of the variables) | — | Jöreskog & Sörbom (1981) |
| `srmr`, `srmr_bentler`, `srmr_bentler_nomean` | Standardized Root Mean Square Residual | \leq .08 | Bentler (1995); Hu & Bentler (1999) |
| `crmr`, `crmr_nomean` | Correlation Root Mean Square Residual (residual correlations, diagonal excluded) | — | Bollen (1989b) |
| `srmr_mplus`, `srmr_mplus_nomean` | SRMR as computed by Mplus | \leq .08 | Asparouhov & Muthén (2018) |
| `gfi`, `gfi.ci.lower`, `gfi.ci.upper`, `gfi.ci.level` | Goodness of Fit Index, with confidence interval | close to 1 | Jöreskog & Sörbom (1981) |
| `cn_05`, `cn_01` | Hoelter’s critical N at \alpha = .05 and .01 | \> 200 | Hoelter (1983) |
| `gfi_lisrel`, `agfi_lisrel` | GFI and Adjusted GFI as computed by LISREL | close to 1 | Jöreskog & Sörbom (1981) |
| `pgfi` | Parsimony Goodness of Fit Index | higher is better | Mulaik et al. (1989) |
| `mfi` | McDonald’s Fit Index | close to 1 | McDonald (1989) |
| `ecvi` | Expected Cross-Validation Index | lower is better | Browne & Cudeck (1989) |

### Multi-group models

When the fitted model has more than one group, `report_cfa` additionally
returns a `group` summary table (group labels, sample sizes per group,
and total N) — omitted here since the example above is single-group.

## Sample Size Planning

`simulate_cfa_fit` refits a CFA model repeatedly across a range of
sample sizes, in parallel, and returns fit indices at each size — either
generating data from known population parameters (`model_sim`) or
resampling from an observed dataset’s correlation structure (`df`).

``` r

model_sim <- "LATENT =~ 1*X1 + 0.5*X2 + 1.5*X3 + 1.5*X4 + X5"
model_est <- "LATENT =~ X1 + X2 + X3 + X4 + X5"
result_sim <- simulate_cfa_fit(model_sim = model_sim, model = model_est, minnobs = 50, maxnobs = 10000, stepping = 100)
```

![](GLM_SEM_files/figure-html/simulate_cfa_fit-1.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-2.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-3.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-4.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-5.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-6.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-7.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-8.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-9.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-10.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-11.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-12.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-13.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-14.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-15.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-16.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-17.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-18.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-19.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-20.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-21.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-22.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-23.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-24.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-25.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-26.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-27.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-28.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-29.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-30.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-31.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-32.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-33.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-34.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-35.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-36.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-37.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-38.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-39.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-40.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-41.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-42.png)![](GLM_SEM_files/figure-html/simulate_cfa_fit-43.png)

The first element is a table with one row per sample size and one column
per fit index; the second is a named list of plots, one per fit index:

``` r

head(result_sim[[1]][, c("observations", "cfi", "tli", "rmsea", "srmr")])
```

    ##   observations       cfi       tli      rmsea        srmr
    ## 1           50 0.9944520 0.9889041 0.03458957 0.049146723
    ## 2          150 1.0000000 1.0055521 0.00000000 0.020759799
    ## 3          250 0.9988255 0.9976509 0.02257587 0.018848604
    ## 4          350 0.9982321 0.9964642 0.02508720 0.016727099
    ## 5          450 1.0000000 1.0092607 0.00000000 0.008447864
    ## 6          550 1.0000000 1.0025621 0.00000000 0.010802308

``` r

plot_multiplot(plotlist = result_sim[[2]][c("observations_cfi", "observations_tli",
                                            "observations_rmsea", "observations_srmr")],
               cols = 2)
```

![](GLM_SEM_files/figure-html/simulate_cfa_fit_plots-1.png)

Each panel tracks one fit index against sample size. Indices like RMSEA
and SRMR typically stabilize and tighten (less sample-to-sample
variability) as n grows — the point at which a given index’s variability
becomes acceptably small for your purposes is a data-driven answer to
“how large a sample do I need?” for this specific model.

------------------------------------------------------------------------

## Conclusion

`plot_cfa_gg`/`plot_cfa` visualize a fitted measurement model’s
structure without requiring `semPlot`’s system dependencies;
`report_cfa` collects every quantity needed to write up a CFA (fit,
parameters, R², modification indices) in one call; and
`simulate_cfa_fit` turns “what sample size do I need” into an empirical,
visualizable question rather than a rule of thumb.

## References

Akaike, H. (1974). A new look at the statistical model identification.
*IEEE Transactions on Automatic Control, 19*(6), 716–723.
<https://doi.org/10.1109/TAC.1974.1100705>

Asparouhov, T., & Muthén, B. (2018). *SRMR in Mplus* \[Technical
report\]. Muthén & Muthén.
<https://www.statmodel.com/download/SRMR2.pdf>

Bentler, P. M. (1990). Comparative fit indexes in structural models.
*Psychological Bulletin, 107*(2), 238–246.
<https://doi.org/10.1037/0033-2909.107.2.238>

Bentler, P. M. (1995). *EQS structural equations program manual*.
Multivariate Software.

Bentler, P. M., & Bonett, D. G. (1980). Significance tests and goodness
of fit in the analysis of covariance structures. *Psychological
Bulletin, 88*(3), 588–606. <https://doi.org/10.1037/0033-2909.88.3.588>

Bollen, K. A. (1986). Sample size and Bentler and Bonett’s nonnormed fit
index. *Psychometrika, 51*(3), 375–377.
<https://doi.org/10.1007/BF02294061>

Bollen, K. A. (1989a). A new incremental fit index for general
structural equation models. *Sociological Methods & Research, 17*(3),
303–316. <https://doi.org/10.1177/0049124189017003004>

Bollen, K. A. (1989b). *Structural equations with latent variables*.
Wiley. <https://doi.org/10.1002/9781118619179>

Browne, M. W., & Cudeck, R. (1989). Single sample cross-validation
indices for covariance structures. *Multivariate Behavioral Research,
24*(4), 445–455. <https://doi.org/10.1207/s15327906mbr2404_4>

Browne, M. W., & Cudeck, R. (1992). Alternative ways of assessing model
fit. *Sociological Methods & Research, 21*(2), 230–258.
<https://doi.org/10.1177/0049124192021002005>

Hoelter, J. W. (1983). The analysis of covariance structures:
Goodness-of-fit indices. *Sociological Methods & Research, 11*(3),
325–344. <https://doi.org/10.1177/0049124183011003003>

Hu, L., & Bentler, P. M. (1999). Cutoff criteria for fit indexes in
covariance structure analysis: Conventional criteria versus new
alternatives. *Structural Equation Modeling, 6*(1), 1–55.
<https://doi.org/10.1080/10705519909540118>

James, L. R., Mulaik, S. A., & Brett, J. M. (1982). *Causal analysis:
Assumptions, models, and data*. Sage.

Jöreskog, K. G. (1969). A general approach to confirmatory maximum
likelihood factor analysis. *Psychometrika, 34*(2), 183–202.
<https://doi.org/10.1007/BF02289343>

Jöreskog, K. G., & Sörbom, D. (1981). *LISREL V: Analysis of linear
structural relationships by maximum likelihood and least squares
methods*. National Educational Resources.

MacCallum, R. C., Browne, M. W., & Sugawara, H. M. (1996). Power
analysis and determination of sample size for covariance structure
modeling. *Psychological Methods, 1*(2), 130–149.
<https://doi.org/10.1037/1082-989X.1.2.130>

McDonald, R. P. (1989). An index of goodness-of-fit based on
noncentrality. *Journal of Classification, 6*(1), 97–103.
<https://doi.org/10.1007/BF01908590>

McDonald, R. P., & Marsh, H. W. (1990). Choosing a multivariate model:
Noncentrality and goodness of fit. *Psychological Bulletin, 107*(2),
247–255. <https://doi.org/10.1037/0033-2909.107.2.247>

Mulaik, S. A., James, L. R., Van Alstine, J., Bennett, N., Lind, S., &
Stilwell, C. D. (1989). Evaluation of goodness-of-fit indices for
structural equation models. *Psychological Bulletin, 105*(3), 430–445.
<https://doi.org/10.1037/0033-2909.105.3.430>

Rosseel, Y. (2012). lavaan: An R package for structural equation
modeling. *Journal of Statistical Software, 48*(2), 1–36.
<https://doi.org/10.18637/jss.v048.i02>

Schwarz, G. (1978). Estimating the dimension of a model. *The Annals of
Statistics, 6*(2), 461–464. <https://doi.org/10.1214/aos/1176344136>

Sclove, S. L. (1987). Application of model-selection criteria to some
problems in multivariate analysis. *Psychometrika, 52*(3), 333–343.
<https://doi.org/10.1007/BF02294360>

Steiger, J. H. (1990). Structural model evaluation and modification: An
interval estimation approach. *Multivariate Behavioral Research, 25*(2),
173–180. <https://doi.org/10.1207/s15327906mbr2502_4>

Steiger, J. H., & Lind, J. C. (1980). *Statistically based tests for the
number of common factors* \[Paper presentation\]. Annual meeting of the
Psychometric Society, Iowa City, IA, United States.

Tucker, L. R., & Lewis, C. (1973). A reliability coefficient for maximum
likelihood factor analysis. *Psychometrika, 38*(1), 1–10.
<https://doi.org/10.1007/BF02291170>

------------------------------------------------------------------------

*Rendered with R 4.6.1 · lavaan 0.7.3*
