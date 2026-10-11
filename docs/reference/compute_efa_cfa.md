# Exploratory and confirmatory factor analysis for each dimension

For every dimension of a questionnaire, fits three exploratory factor
analysis (EFA) models with
[`psych::fa`](https://rdrr.io/pkg/psych/man/fa.html) and two one-factor
confirmatory factor analysis (CFA) models with
[`lavaan::cfa`](https://rdrr.io/pkg/lavaan/man/cfa.html), and collects
their loadings, fit indices, modification indices, residuals, factor
scores and score correlations. All results are also written to an Excel
workbook.

## Usage

``` r
compute_efa_cfa(
  dimensions,
  df_response,
  filename = "efa_cfa_models.xlsx",
  mini = 1,
  maxi = 5
)
```

## Arguments

- dimensions:

  Data frame with one row per item and the columns `dimension` (the
  dimension the item belongs to), `subquestion_text` (the name of the
  item's column in `df_response`) and `key` (`1` for an item that is
  reverse scored, `-1` for an item scored as it is; see Details).

- df_response:

  Data frame of numeric item responses with one column per item, named
  as in `dimensions$subquestion_text`. Missing responses must be `NA`;
  recode missing-data codes (such as 0) to `NA` first.

- filename:

  Path of the Excel file to write. Its folder is created if it does not
  exist. Default `"efa_cfa_models.xlsx"` in the working directory.

- mini, maxi:

  Lowest and highest possible response. They are used to reverse score
  items (`mini + maxi - x`). Defaults `1` and `5`.

## Value

A list with

- efa_cfa_models:

  One row per item with n, dimension, variable and F1 (Model 1
  loadings); S2F1, S2F2 (Model 2 structure matrix, the correlations of
  the items with the rotated factors); P2F1, P2F2 (Model 2 pattern
  matrix, the regression weights of the rotated factors); S3F1 to S3F3
  and P3F1 to P3F3 (the same for Model 3); index with f1_v, f2_v, f3_v
  (EFA fit of Models 1 to 3: RMSEA with its lower and upper limits and
  confidence level, RMS, CFI, TLI); unstandardized and standardized
  (Model 4 loadings); unstandardized_RI, standardized_RI, RI_u and RI_s
  (Model 5 loadings and random intercept loadings); index_cfa with
  fit_CFA and fit_CFA_RI (CFA fit of Models 4 and 5: RMSEA with its
  limits, SRMR, CFI, TLI). A dimension with fewer than 7 items gets
  extra rows (without a variable) for the EFA fit indices.

- cfa_scores:

  Factor scores of Model 4
  ([`lavaan::lavPredict`](https://rdrr.io/pkg/lavaan/man/lavPredict.html)),
  one column per dimension whose CFA ran and one row per row of
  `df_response` (`NA` for respondents without any answer in that
  dimension).

- plots_scree:

  An empty list (the scree plot code is switched off).

- cfa_coefficients:

  Model 4 loadings (lambda), residual variances (theta) and intercepts,
  standardized and unstandardized, one row per item.

The Excel file has the sheets critical (efa_cfa_models, with loadings
beyond 0.32 or below -0.32 highlighted), CFA_Modification_Indexes (Model
4 modification indices of 10 or more), EFA1F_Residuals (Model 1 residual
correlations beyond 0.1 in absolute value), CFA_Coefficients,
CFA_RI_Coefficients, used_items (correlations of the items with the
dimension mean scores), used_items_item_correlation (item pairs sorted
by the size of their correlation), used_items_mean_score and
used_items_cfa_score (correlations between the dimension mean scores and
between the CFA scores). A sheet without any content (for example when
no CFA ran) is not written.

## Details

The models fitted for each dimension are

1.  Model 1: one-factor EFA (maximum likelihood).

2.  Model 2: two-factor EFA (maximum likelihood, oblimin rotation).

3.  Model 3: three-factor EFA (maximum likelihood, oblimin rotation).

4.  Model 4: one-factor CFA (`missing = "ML"`, with means).

5.  Model 5: Model 4 plus a random intercept factor `RI`, with all its
    loadings fixed to 1 and unrelated to the dimension's factor.

An EFA model that is not identified for the number of items (negative
degrees of freedom), or that fails, is reported as `NA`: the one-factor
model needs at least 3 items, the two-factor model 5 and the
three-factor model 6. The CFA models need at least 4 items, because with
3 items the random intercept model has more parameters than the data can
identify (lavaan fits it without a warning, so the function skips it).

The EFA and CFA models use the responses as they are, so items worded in
the opposite direction have negative loadings. The mean scores and the
correlation sheets use reverse scored items:
[`psych::reverse.code`](https://rdrr.io/pkg/psych/man/reverse.code.html)
is called with `key * -1`, so the items with `key = 1` are reversed.

Warnings from lavaan (for example about respondents without any answer)
are shown as messages and do not stop the CFA. If a CFA model stops with
an error or does not converge, the CFA columns of that dimension are
`NA` and the function continues with the next dimension. In the lavaan
models, a dimension name that is not a syntactically valid R name (for
example one with spaces) is changed with `make.names`.

The function stops with an error if `dimensions` lacks one of its
columns, if `key` has values other than 1 and -1, or if an item is not a
numeric column of `df_response`. It warns about responses outside `mini`
to `maxi` and about items without variance (no responses, or the same
response from everyone), because the EFA and CFA of their dimension
fail.

The function needs the rwf functions `model_loadings`, `c_bind`,
`change_data_type`, `matrix_triangle`, `excel_critical_value` and
`excel_matrix`.

## Note

Most of the run time is spent writing the Excel file, because
`excel_critical_value` adds conditional formatting one cell at a time.

## Examples

``` r
# \donttest{
items<-c(paste0("E",1:10),paste0("N",1:10),paste0("A",1:10),
         paste0("C",1:10),paste0("O",1:10))
reverse_items<-c("E2","E4","E6","E8","E10","N2","N4","A1","A3","A5",
                 "A7","C2","C4","C6","C8","O2","O4","O6")
df<-df_ocean[,items]
df[df==0]<-NA # 0 is the missing-data code of df_ocean
dimensions<-data.frame(dimension=substr(items,1,1),
                       subquestion_text=items,
                       key=ifelse(items%in%reverse_items,1,-1))
result<-compute_efa_cfa(dimensions=dimensions,
                        df_response=df[1:2000,],
                        filename=file.path(tempdir(),"efa_cfa_ocean.xlsx"))
#> Dimension: A
#> Dimension: C
#> Dimension: E
#> Dimension: N
#> Dimension: O
head(result$efa_cfa_models)
#>   n dimension variable    F1  S2F1  S2F2  P2F1  P2F2  S3F1  S3F2  S3F3  P3F1  P3F2  P3F3          index       f1_v       f2_v       f3_v unstandardized standardized unstandardized_RI RI_u
#> 1 1         A       A4  0.79  0.84 -0.51  0.84    NA  0.84 -0.53 -0.10  0.81 -0.04 -0.05          RMSEA 0.11168502 0.06322788 0.05259288      -1.404050   -0.7902895        -1.3055799    1
#> 2 2         A       A9  0.73  0.77 -0.46  0.77    NA  0.78 -0.48  0.07  0.80  0.02  0.12 RMSEA.CI.LOWER 0.10549652 0.05594790 0.04378433      -1.374717   -0.7345254        -1.2718309    1
#> 3 3         A       A7 -0.66 -0.52  0.91  0.04  0.94 -0.51  0.86 -0.03  0.03  0.89  0.05 RMSEA.CI.UPPER 0.11805417 0.07080742 0.06186001       1.291011    0.6550750         1.3043961    1
#> 4 4         A       A5 -0.65 -0.57  0.63 -0.30  0.45 -0.56  0.65  0.13 -0.23  0.52  0.16     RMSEA_CONF 0.90000000 0.90000000 0.90000000       1.290238    0.6516141         1.3064060    1
#> 5 5         A       A8  0.60  0.56 -0.45  0.45 -0.18  0.56 -0.48 -0.04  0.42 -0.23 -0.04            RMS 0.06383535 0.03359986 0.02271046      -1.059541   -0.5990305        -0.9927793    1
#> 6 6         A       A6  0.59  0.64 -0.34  0.68  0.07  0.64 -0.35 -0.14  0.67  0.05 -0.10            CFI 0.85849240 0.96630768 0.98386091      -1.131672   -0.5896522        -1.0395285    1
#>   standardized_RI      RI_s      index_cfa    fit_CFA fit_CFA_RI
#> 1      -0.7724990 0.1824496          RMSEA 0.11185591 0.10644680
#> 2      -0.7185898 0.1742209 RMSEA.CI.LOWER 0.10564001 0.10013769
#> 3       0.6946150 0.1642038 RMSEA.CI.UPPER 0.11819415 0.11288766
#> 4       0.6934097 0.1636666           SRMR 0.05311425 0.05106747
#> 5      -0.5834842 0.1812278            CFI 0.85843121 0.87545514
#> 6      -0.5698478 0.1690328            TLI 0.81798299 0.83516122
round(cor(result$cfa_scores,use="pairwise.complete.obs"),2)
#>       A     C     E     N     O
#> A  1.00 -0.13 -0.35  0.06 -0.15
#> C -0.13  1.00  0.15 -0.32  0.10
#> E -0.35  0.15  1.00 -0.27  0.20
#> N  0.06 -0.32 -0.27  1.00 -0.11
#> O -0.15  0.10  0.20 -0.11  1.00
# }
```
