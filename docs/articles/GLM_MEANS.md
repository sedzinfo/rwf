# t tests and Wilcoxon tests

## Description

This shows the output of mean comparison functions from the package rwf:
`report_ttests` and `report_wtests`. Both functions run pairwise
comparisons between the levels of each independent variable and return a
table with test statistics, effect sizes, confidence intervals, and
Bonferroni-adjusted significance flags.

- Use `report_ttests` when data meet the normality assumption
  (parametric).
- Use `report_wtests` when data are ordinal or normality cannot be
  assumed (non-parametric).

Installation instructions for rwf can be found
[here](https://github.com/sedzinfo/rwf)

The code can be found
[here](https://github.com/sedzinfo/rwf/blob/main/rwf/R/GLM_MEANS.R)

## Data

The `df_insurance` dataset is used throughout this vignette. It contains
insurance data for 1338 individuals with the following variables:

Format: A data frame with 1338 rows and 7 variables:

- **age**: Age of the individual
- **sex**: Sex of the individual (male/female)
- **bmi**: Body Mass Index
- **children**: Number of children covered by the insurance
- **smoker**: Smoking status (yes/no)
- **region**: Region of residence (southwest, southeast, northwest,
  northeast)
- **charges**: Medical insurance charges billed

Source: researchpy repo

``` r

head(df_insurance)
```

    ##   age    sex    bmi children smoker    region   charges
    ## 1  19 female 27.900        0    yes southwest 16884.924
    ## 2  18   male 33.770        1     no southeast  1725.552
    ## 3  28   male 33.000        3     no southeast  4449.462
    ## 4  33   male 22.705        0     no northwest 21984.471
    ## 5  32   male 28.880        0     no northwest  3866.855
    ## 6  31 female 25.740        0     no southeast  3756.622

``` r

cdf(df_insurance)
```

    ## $summary
    ##   COLLUMNS ROWS TOTAL EMPTY null NAN na INF  FIN FACTOR
    ## 1        7 1338  9366     0    0   0  0   0 5352      0
    ## 
    ## $check
    ##      NAMES EMPTY null na NOT_NA NAN INF  FIN RANGE     MEAN  MEDIAN       SD       MIN         MAX      MODE      TYPE     CLASS FACTOR
    ## 1      age     0    0  0   1338   0   0 1338    47    39.21   39.00    14.05        18          64   numeric   integer   integer  FALSE
    ## 2      sex     0    0  0   1338   0   0    0     2       NA      NA       NA    female        male character character character  FALSE
    ## 3      bmi     0    0  0   1338   0   0 1338   548    30.66   30.40     6.10     15.96       53.13   numeric    double   numeric  FALSE
    ## 4 children     0    0  0   1338   0   0 1338     6     1.09    1.00     1.21         0           5   numeric   integer   integer  FALSE
    ## 5   smoker     0    0  0   1338   0   0    0     2       NA      NA       NA        no         yes character character character  FALSE
    ## 6   region     0    0  0   1338   0   0    0     4       NA      NA       NA northeast   southwest character character character  FALSE
    ## 7  charges     0    0  0   1338   0   0 1338  1337 13270.42 9382.03 12110.01 1121.8739 63770.42801   numeric    double   numeric  FALSE

## Assumptions

### t-test

- **Independence**: observations are independent within and between
  groups (Student, 1908). For a within-subjects design, the pairs are
  independent of each other.
- **Scale**: the DV is measured on an interval or ratio scale.
- **Normality**: the DV is normally distributed within each group; for a
  within-subjects design, the differences d_i are normally distributed
  (Student, 1908). With large groups the t-test is robust to
  non-normality. Normality can be checked with the Shapiro-Wilk test
  (Shapiro & Wilk, 1965).
- **Equal variances**: Student’s t-test (`var.equal = TRUE`) assumes
  equal variances in both groups. Welch’s t-test (the default) does not
  (Welch, 1947) and is the safer default (Delacre et al., 2017). The
  Bartlett columns (`k_squared[bartlett]`, `df[bartlett]`,
  `p[bartlett]`) test this assumption (Bartlett, 1937); `p[bartlett]` \<
  .05 suggests unequal variances. Bartlett’s test is itself sensitive to
  non-normality (Box, 1953).

### Wilcoxon test

- **Independence**: observations are independent within and between
  groups (Wilcoxon, 1945; Mann & Whitney, 1947). For a within-subjects
  design (signed-rank test), the pairs are independent of each other.
- **Scale**: the DV is at least ordinal. For the signed-rank test, the
  differences d_i must be meaningful to rank, so the DV should be
  interval.
- **No normality required**: the test uses ranks instead of raw values
  (Wilcoxon, 1945).
- **Shape**: the rank-sum test compares whether values in one group tend
  to be larger than in the other, P(X_1\>X_2)\neq 0.5 (Mann & Whitney,
  1947). It can be read as a difference in medians only when both groups
  have the same distribution shape and spread; otherwise it can be
  significant even with equal medians (Fagerland & Sandvik, 2009). The
  signed-rank test assumes the differences d_i are symmetric around
  their median (Wilcoxon, 1945).
- **Ties**: tied values are given average ranks and the variance is
  corrected for ties (see Formulas).

## T-Test

`report_ttests` runs independent-samples t-tests for all pairwise
combinations of levels of the specified independent variable(s) against
a dependent variable. When multiple IVs are provided, it tests all level
combinations.

The calls below demonstrate the key options:

- **Single IV** (`iv = 2`, sex): one pairwise comparison (male
  vs. female).
- **Single IV** (`iv = 4`, children): pairwise comparisons across all
  child-count groups.
- **Multiple IVs** (`iv = c(2,4)`): all combinations of sex and children
  levels.
- **`alternative`**: controls the direction of the hypothesis —
  `"two.sided"` (default), `"less"`, or `"greater"`.
- **`var.equal = TRUE`**: uses Student’s t-test assuming equal
  variances; default (`FALSE`) uses Welch’s t-test which does not assume
  equal variances and is generally safer.

``` r

report_ttests(df=df_insurance,dv=7,iv=c(2))
```

    ##        DV  IV level1 level2  n1  n2         t      df          p      CI_l      CI_u alternative                  method    mean1    mean2     sd1      sd2 sd_pooled         d          r
    ## 1 charges sex female   male 662 676 -2.100888 1313.36 0.03584101 -2682.489 -91.85535   two.sided Welch Two Sample t-test 12569.58 13956.75 11128.7 12971.03  12085.02 0.1147844 0.05733752
    ##   k_squared[bartlett] df[bartlett]  p[bartlett] bonferroni_p significant
    ## 1            15.58524            1 7.886777e-05         0.05        TRUE

``` r

report_ttests(df=df_insurance,dv=7,iv=c(4))
```

    ##         DV       IV level1 level2  n1  n2          t        df            p       CI_l      CI_u alternative                  method    mean1     mean2       sd1       sd2 sd_pooled          d
    ## 1  charges children      0      1 574 324 -0.4417876 679.59012 6.587834e-01 -1988.2577 1257.8653   two.sided Welch Two Sample t-test 12365.98 12731.172 12023.294 11823.631 11923.881 0.03062730
    ## 2  charges children      0      2 574 240 -2.7863080 421.22473 5.572108e-03 -4617.6666 -797.5096   two.sided Welch Two Sample t-test 12365.98 15073.564 12023.294 12891.368 12464.890 0.21721717
    ## 3  charges children      0      3 574 157 -2.7060695 243.20548 7.290553e-03 -5165.3054 -813.3802   two.sided Welch Two Sample t-test 12365.98 15355.318 12023.294 12330.869 12178.053 0.24546968
    ## 4  charges children      0      4 574  25 -0.7832723  27.74801 4.401018e-01 -5368.9942 2399.6328   two.sided Welch Two Sample t-test 12365.98 13850.656 12023.294  9139.223 10679.068 0.13902718
    ## 5  charges children      0      5 574  18  3.4810329  29.20259 1.591976e-03  1477.2327 5682.6480   two.sided Welch Two Sample t-test 12365.98  8786.035 12023.294  3808.436  8918.065 0.40142567
    ## 6  charges children      1      2 324 240 -2.2094856 489.12306 2.760343e-02 -4425.4071 -259.3767   two.sided Welch Two Sample t-test 12731.17 15073.564 11823.631 12891.368 12369.027 0.18937561
    ## 7  charges children      1      3 324 157 -2.2178485 297.45198 2.732051e-02 -4952.6397 -295.6534   two.sided Welch Two Sample t-test 12731.17 15355.318 11823.631 12330.869 12079.913 0.21723224
    ## 8  charges children      1      4 324  25 -0.5763734  30.56138 5.685839e-01 -5083.1176 2844.1486   two.sided Welch Two Sample t-test 12731.17 13850.656 11823.631  9139.223 10567.016 0.10594140
    ## 9  charges children      1      5 324  18  3.5467523  39.48455 1.022814e-03  1696.1320 6194.1411   two.sided Welch Two Sample t-test 12731.17  8786.035 11823.631  3808.436  8783.577 0.44914921
    ## 10 charges children      2      3 240 157 -0.2186234 344.03032 8.270731e-01 -2816.6095 2253.1002   two.sided Welch Two Sample t-test 15073.56 15355.318 12891.368 12330.869 12614.232 0.02233625
    ## 11 charges children      2      4 240  25  0.6089120  34.82901 5.465342e-01 -2854.9724 5300.7872   two.sided Welch Two Sample t-test 15073.56 13850.656 12891.368  9139.223 11173.916 0.10944305
    ## 12 charges children      2      5 240  18  5.1367681  55.83856 3.683650e-06  3835.3569 8739.7001   two.sided Welch Two Sample t-test 15073.56  8786.035 12891.368  3808.436  9505.040 0.66149419
    ## 13 charges children      3      4 157  25  0.7248131  39.42099 4.728472e-01 -2692.8715 5702.1956   two.sided Welch Two Sample t-test 15355.32 13850.656 12330.869  9139.223 10853.012 0.13864004
    ## 14 charges children      3      5 157  18  4.9318423  71.21179 5.147633e-06  3913.4595 9225.1068   two.sided Welch Two Sample t-test 15355.32  8786.035 12330.869  3808.436  9125.638 0.71987114
    ## 15 charges children      4      5  25  18  2.4870826  34.16692 1.792165e-02   926.9633 9202.2788   two.sided Welch Two Sample t-test 13850.66  8786.035  9139.223  3808.436  7001.056 0.72340811
    ##             r k_squared[bartlett] df[bartlett]  p[bartlett] bonferroni_p significant
    ## 1  0.01472305           0.1153396            1 7.341451e-01  0.003333333       FALSE
    ## 2  0.09868258           1.6672644            1 1.966253e-01  0.003333333       FALSE
    ## 3  0.10043376           0.1576254            1 6.913523e-01  0.003333333       FALSE
    ## 4  0.02783920           2.9046073            1 8.832676e-02  0.003333333       FALSE
    ## 5  0.06887758          23.1372171            1 1.508426e-06  0.003333333        TRUE
    ## 6  0.09338827           2.0650067            1 1.507143e-01  0.003333333       FALSE
    ## 7  0.10154432           0.3738531            1 5.409115e-01  0.003333333       FALSE
    ## 8  0.02738847           2.5281700            1 1.118298e-01  0.003333333       FALSE
    ## 9  0.10008312          22.4877050            1 2.114930e-06  0.003333333        TRUE
    ## 10 0.01094828           0.3696063            1 5.432189e-01  0.003333333       FALSE
    ## 11 0.03209514           4.2347393            1 3.960470e-02  0.003333333       FALSE
    ## 12 0.16680555          24.9593898            1 5.855067e-07  0.003333333        TRUE
    ## 13 0.04793327           3.1776718            1 7.465103e-02  0.003333333       FALSE
    ## 14 0.21480331          23.3775961            1 1.331200e-06  0.003333333        TRUE
    ## 15 0.34327189          12.2513375            1 4.649248e-04  0.003333333       FALSE

``` r

report_ttests(df=df_insurance,dv=7,iv=c(2,4))
```

    ##         DV       IV level1 level2  n1  n2          t         df            p       CI_l       CI_u alternative                  method    mean1     mean2       sd1       sd2 sd_pooled          d
    ## 1  charges      sex female   male 662 676 -2.1008878 1313.36032 3.584101e-02 -2682.4893  -91.85535   two.sided Welch Two Sample t-test 12569.58 13956.751 11128.704 12971.026 12085.023 0.11478442
    ## 2  charges children      0      1 574 324 -0.4417876  679.59012 6.587834e-01 -1988.2577 1257.86528   two.sided Welch Two Sample t-test 12365.98 12731.172 12023.294 11823.631 11923.881 0.03062730
    ## 3  charges children      0      2 574 240 -2.7863080  421.22473 5.572108e-03 -4617.6666 -797.50962   two.sided Welch Two Sample t-test 12365.98 15073.564 12023.294 12891.368 12464.890 0.21721717
    ## 4  charges children      0      3 574 157 -2.7060695  243.20548 7.290553e-03 -5165.3054 -813.38016   two.sided Welch Two Sample t-test 12365.98 15355.318 12023.294 12330.869 12178.053 0.24546968
    ## 5  charges children      0      4 574  25 -0.7832723   27.74801 4.401018e-01 -5368.9942 2399.63277   two.sided Welch Two Sample t-test 12365.98 13850.656 12023.294  9139.223 10679.068 0.13902718
    ## 6  charges children      0      5 574  18  3.4810329   29.20259 1.591976e-03  1477.2327 5682.64801   two.sided Welch Two Sample t-test 12365.98  8786.035 12023.294  3808.436  8918.065 0.40142567
    ## 7  charges children      1      2 324 240 -2.2094856  489.12306 2.760343e-02 -4425.4071 -259.37668   two.sided Welch Two Sample t-test 12731.17 15073.564 11823.631 12891.368 12369.027 0.18937561
    ## 8  charges children      1      3 324 157 -2.2178485  297.45198 2.732051e-02 -4952.6397 -295.65339   two.sided Welch Two Sample t-test 12731.17 15355.318 11823.631 12330.869 12079.913 0.21723224
    ## 9  charges children      1      4 324  25 -0.5763734   30.56138 5.685839e-01 -5083.1176 2844.14864   two.sided Welch Two Sample t-test 12731.17 13850.656 11823.631  9139.223 10567.016 0.10594140
    ## 10 charges children      1      5 324  18  3.5467523   39.48455 1.022814e-03  1696.1320 6194.14113   two.sided Welch Two Sample t-test 12731.17  8786.035 11823.631  3808.436  8783.577 0.44914921
    ## 11 charges children      2      3 240 157 -0.2186234  344.03032 8.270731e-01 -2816.6095 2253.10023   two.sided Welch Two Sample t-test 15073.56 15355.318 12891.368 12330.869 12614.232 0.02233625
    ## 12 charges children      2      4 240  25  0.6089120   34.82901 5.465342e-01 -2854.9724 5300.78722   two.sided Welch Two Sample t-test 15073.56 13850.656 12891.368  9139.223 11173.916 0.10944305
    ## 13 charges children      2      5 240  18  5.1367681   55.83856 3.683650e-06  3835.3569 8739.70006   two.sided Welch Two Sample t-test 15073.56  8786.035 12891.368  3808.436  9505.040 0.66149419
    ## 14 charges children      3      4 157  25  0.7248131   39.42099 4.728472e-01 -2692.8715 5702.19564   two.sided Welch Two Sample t-test 15355.32 13850.656 12330.869  9139.223 10853.012 0.13864004
    ## 15 charges children      3      5 157  18  4.9318423   71.21179 5.147633e-06  3913.4595 9225.10677   two.sided Welch Two Sample t-test 15355.32  8786.035 12330.869  3808.436  9125.638 0.71987114
    ## 16 charges children      4      5  25  18  2.4870826   34.16692 1.792165e-02   926.9633 9202.27882   two.sided Welch Two Sample t-test 13850.66  8786.035  9139.223  3808.436  7001.056 0.72340811
    ##             r k_squared[bartlett] df[bartlett]  p[bartlett] bonferroni_p significant
    ## 1  0.05733752          15.5852419            1 7.886777e-05     0.003125       FALSE
    ## 2  0.01472305           0.1153396            1 7.341451e-01     0.003125       FALSE
    ## 3  0.09868258           1.6672644            1 1.966253e-01     0.003125       FALSE
    ## 4  0.10043376           0.1576254            1 6.913523e-01     0.003125       FALSE
    ## 5  0.02783920           2.9046073            1 8.832676e-02     0.003125       FALSE
    ## 6  0.06887758          23.1372171            1 1.508426e-06     0.003125        TRUE
    ## 7  0.09338827           2.0650067            1 1.507143e-01     0.003125       FALSE
    ## 8  0.10154432           0.3738531            1 5.409115e-01     0.003125       FALSE
    ## 9  0.02738847           2.5281700            1 1.118298e-01     0.003125       FALSE
    ## 10 0.10008312          22.4877050            1 2.114930e-06     0.003125        TRUE
    ## 11 0.01094828           0.3696063            1 5.432189e-01     0.003125       FALSE
    ## 12 0.03209514           4.2347393            1 3.960470e-02     0.003125       FALSE
    ## 13 0.16680555          24.9593898            1 5.855067e-07     0.003125        TRUE
    ## 14 0.04793327           3.1776718            1 7.465103e-02     0.003125       FALSE
    ## 15 0.21480331          23.3775961            1 1.331200e-06     0.003125        TRUE
    ## 16 0.34327189          12.2513375            1 4.649248e-04     0.003125       FALSE

``` r

report_ttests(df=df_insurance,dv=7,iv=c(2,4),alternative="two.sided")
```

    ##         DV       IV level1 level2  n1  n2          t         df            p       CI_l       CI_u alternative                  method    mean1     mean2       sd1       sd2 sd_pooled          d
    ## 1  charges      sex female   male 662 676 -2.1008878 1313.36032 3.584101e-02 -2682.4893  -91.85535   two.sided Welch Two Sample t-test 12569.58 13956.751 11128.704 12971.026 12085.023 0.11478442
    ## 2  charges children      0      1 574 324 -0.4417876  679.59012 6.587834e-01 -1988.2577 1257.86528   two.sided Welch Two Sample t-test 12365.98 12731.172 12023.294 11823.631 11923.881 0.03062730
    ## 3  charges children      0      2 574 240 -2.7863080  421.22473 5.572108e-03 -4617.6666 -797.50962   two.sided Welch Two Sample t-test 12365.98 15073.564 12023.294 12891.368 12464.890 0.21721717
    ## 4  charges children      0      3 574 157 -2.7060695  243.20548 7.290553e-03 -5165.3054 -813.38016   two.sided Welch Two Sample t-test 12365.98 15355.318 12023.294 12330.869 12178.053 0.24546968
    ## 5  charges children      0      4 574  25 -0.7832723   27.74801 4.401018e-01 -5368.9942 2399.63277   two.sided Welch Two Sample t-test 12365.98 13850.656 12023.294  9139.223 10679.068 0.13902718
    ## 6  charges children      0      5 574  18  3.4810329   29.20259 1.591976e-03  1477.2327 5682.64801   two.sided Welch Two Sample t-test 12365.98  8786.035 12023.294  3808.436  8918.065 0.40142567
    ## 7  charges children      1      2 324 240 -2.2094856  489.12306 2.760343e-02 -4425.4071 -259.37668   two.sided Welch Two Sample t-test 12731.17 15073.564 11823.631 12891.368 12369.027 0.18937561
    ## 8  charges children      1      3 324 157 -2.2178485  297.45198 2.732051e-02 -4952.6397 -295.65339   two.sided Welch Two Sample t-test 12731.17 15355.318 11823.631 12330.869 12079.913 0.21723224
    ## 9  charges children      1      4 324  25 -0.5763734   30.56138 5.685839e-01 -5083.1176 2844.14864   two.sided Welch Two Sample t-test 12731.17 13850.656 11823.631  9139.223 10567.016 0.10594140
    ## 10 charges children      1      5 324  18  3.5467523   39.48455 1.022814e-03  1696.1320 6194.14113   two.sided Welch Two Sample t-test 12731.17  8786.035 11823.631  3808.436  8783.577 0.44914921
    ## 11 charges children      2      3 240 157 -0.2186234  344.03032 8.270731e-01 -2816.6095 2253.10023   two.sided Welch Two Sample t-test 15073.56 15355.318 12891.368 12330.869 12614.232 0.02233625
    ## 12 charges children      2      4 240  25  0.6089120   34.82901 5.465342e-01 -2854.9724 5300.78722   two.sided Welch Two Sample t-test 15073.56 13850.656 12891.368  9139.223 11173.916 0.10944305
    ## 13 charges children      2      5 240  18  5.1367681   55.83856 3.683650e-06  3835.3569 8739.70006   two.sided Welch Two Sample t-test 15073.56  8786.035 12891.368  3808.436  9505.040 0.66149419
    ## 14 charges children      3      4 157  25  0.7248131   39.42099 4.728472e-01 -2692.8715 5702.19564   two.sided Welch Two Sample t-test 15355.32 13850.656 12330.869  9139.223 10853.012 0.13864004
    ## 15 charges children      3      5 157  18  4.9318423   71.21179 5.147633e-06  3913.4595 9225.10677   two.sided Welch Two Sample t-test 15355.32  8786.035 12330.869  3808.436  9125.638 0.71987114
    ## 16 charges children      4      5  25  18  2.4870826   34.16692 1.792165e-02   926.9633 9202.27882   two.sided Welch Two Sample t-test 13850.66  8786.035  9139.223  3808.436  7001.056 0.72340811
    ##             r k_squared[bartlett] df[bartlett]  p[bartlett] bonferroni_p significant
    ## 1  0.05733752          15.5852419            1 7.886777e-05     0.003125       FALSE
    ## 2  0.01472305           0.1153396            1 7.341451e-01     0.003125       FALSE
    ## 3  0.09868258           1.6672644            1 1.966253e-01     0.003125       FALSE
    ## 4  0.10043376           0.1576254            1 6.913523e-01     0.003125       FALSE
    ## 5  0.02783920           2.9046073            1 8.832676e-02     0.003125       FALSE
    ## 6  0.06887758          23.1372171            1 1.508426e-06     0.003125        TRUE
    ## 7  0.09338827           2.0650067            1 1.507143e-01     0.003125       FALSE
    ## 8  0.10154432           0.3738531            1 5.409115e-01     0.003125       FALSE
    ## 9  0.02738847           2.5281700            1 1.118298e-01     0.003125       FALSE
    ## 10 0.10008312          22.4877050            1 2.114930e-06     0.003125        TRUE
    ## 11 0.01094828           0.3696063            1 5.432189e-01     0.003125       FALSE
    ## 12 0.03209514           4.2347393            1 3.960470e-02     0.003125       FALSE
    ## 13 0.16680555          24.9593898            1 5.855067e-07     0.003125        TRUE
    ## 14 0.04793327           3.1776718            1 7.465103e-02     0.003125       FALSE
    ## 15 0.21480331          23.3775961            1 1.331200e-06     0.003125        TRUE
    ## 16 0.34327189          12.2513375            1 4.649248e-04     0.003125       FALSE

``` r

report_ttests(df=df_insurance,dv=7,iv=c(2,4),alternative="less")
```

    ##         DV       IV level1 level2  n1  n2          t         df           p CI_l       CI_u alternative                  method    mean1     mean2       sd1       sd2 sd_pooled          d          r
    ## 1  charges      sex female   male 662 676 -2.1008878 1313.36032 0.017920507 -Inf  -300.3432        less Welch Two Sample t-test 12569.58 13956.751 11128.704 12971.026 12085.023 0.11478442 0.05733752
    ## 2  charges children      0      1 574 324 -0.4417876  679.59012 0.329391716 -Inf   996.3501        less Welch Two Sample t-test 12365.98 12731.172 12023.294 11823.631 11923.881 0.03062730 0.01472305
    ## 3  charges children      0      2 574 240 -2.7863080  421.22473 0.002786054 -Inf -1105.6825        less Welch Two Sample t-test 12365.98 15073.564 12023.294 12891.368 12464.890 0.21721717 0.09868258
    ## 4  charges children      0      3 574 157 -2.7060695  243.20548 0.003645277 -Inf -1165.3568        less Welch Two Sample t-test 12365.98 15355.318 12023.294 12330.869 12178.053 0.24546968 0.10043376
    ## 5  charges children      0      4 574  25 -0.7832723   27.74801 0.220050904 -Inf  1740.7887        less Welch Two Sample t-test 12365.98 13850.656 12023.294  9139.223 10679.068 0.13902718 0.02783920
    ## 6  charges children      0      5 574  18  3.4810329   29.20259 0.999204012 -Inf  5326.9454        less Welch Two Sample t-test 12365.98  8786.035 12023.294  3808.436  8918.065 0.40142567 0.06887758
    ## 7  charges children      1      2 324 240 -2.2094856  489.12306 0.013801715 -Inf  -595.2871        less Welch Two Sample t-test 12731.17 15073.564 11823.631 12891.368 12369.027 0.18937561 0.09338827
    ## 8  charges children      1      3 324 157 -2.2178485  297.45198 0.013660253 -Inf  -671.8843        less Welch Two Sample t-test 12731.17 15355.318 11823.631 12330.869 12079.913 0.21723224 0.10154432
    ## 9  charges children      1      4 324  25 -0.5763734   30.56138 0.284291937 -Inf  2175.1615        less Welch Two Sample t-test 12731.17 13850.656 11823.631  9139.223 10567.016 0.10594140 0.02738847
    ## 10 charges children      1      5 324  18  3.5467523   39.48455 0.999488593 -Inf  5818.7037        less Welch Two Sample t-test 12731.17  8786.035 11823.631  3808.436  8783.577 0.44914921 0.10008312
    ## 11 charges children      2      3 240 157 -0.2186234  344.03032 0.413536539 -Inf  1843.8025        less Welch Two Sample t-test 15073.56 15355.318 12891.368 12330.869 12614.232 0.02233625 0.01094828
    ## 12 charges children      2      4 240  25  0.6089120   34.82901 0.726732888 -Inf  4616.6105        less Welch Two Sample t-test 15073.56 13850.656 12891.368  9139.223 11173.916 0.10944305 0.03209514
    ## 13 charges children      2      5 240  18  5.1367681   55.83856 0.999998158 -Inf  8334.8358        less Welch Two Sample t-test 15073.56  8786.035 12891.368  3808.436  9505.040 0.66149419 0.16680555
    ## 14 charges children      3      4 157  25  0.7248131   39.42099 0.763576406 -Inf  5001.4381        less Welch Two Sample t-test 15355.32 13850.656 12330.869  9139.223 10853.012 0.13864004 0.04793327
    ## 15 charges children      3      5 157  18  4.9318423   71.21179 0.999997426 -Inf  8789.1300        less Welch Two Sample t-test 15355.32  8786.035 12330.869  3808.436  9125.638 0.71987114 0.21480331
    ## 16 charges children      4      5  25  18  2.4870826   34.16692 0.991039174 -Inf  8507.4980        less Welch Two Sample t-test 13850.66  8786.035  9139.223  3808.436  7001.056 0.72340811 0.34327189
    ##    k_squared[bartlett] df[bartlett]  p[bartlett] bonferroni_p significant
    ## 1           15.5852419            1 7.886777e-05     0.003125       FALSE
    ## 2            0.1153396            1 7.341451e-01     0.003125       FALSE
    ## 3            1.6672644            1 1.966253e-01     0.003125        TRUE
    ## 4            0.1576254            1 6.913523e-01     0.003125       FALSE
    ## 5            2.9046073            1 8.832676e-02     0.003125       FALSE
    ## 6           23.1372171            1 1.508426e-06     0.003125       FALSE
    ## 7            2.0650067            1 1.507143e-01     0.003125       FALSE
    ## 8            0.3738531            1 5.409115e-01     0.003125       FALSE
    ## 9            2.5281700            1 1.118298e-01     0.003125       FALSE
    ## 10          22.4877050            1 2.114930e-06     0.003125       FALSE
    ## 11           0.3696063            1 5.432189e-01     0.003125       FALSE
    ## 12           4.2347393            1 3.960470e-02     0.003125       FALSE
    ## 13          24.9593898            1 5.855067e-07     0.003125       FALSE
    ## 14           3.1776718            1 7.465103e-02     0.003125       FALSE
    ## 15          23.3775961            1 1.331200e-06     0.003125       FALSE
    ## 16          12.2513375            1 4.649248e-04     0.003125       FALSE

``` r

report_ttests(df=df_insurance,dv=7,iv=c(2,4),alternative="greater")
```

    ##         DV       IV level1 level2  n1  n2          t         df            p      CI_l CI_u alternative                  method    mean1     mean2       sd1       sd2 sd_pooled          d          r
    ## 1  charges      sex female   male 662 676 -2.1008878 1313.36032 9.820795e-01 -2474.001  Inf     greater Welch Two Sample t-test 12569.58 13956.751 11128.704 12971.026 12085.023 0.11478442 0.05733752
    ## 2  charges children      0      1 574 324 -0.4417876  679.59012 6.706083e-01 -1726.743  Inf     greater Welch Two Sample t-test 12365.98 12731.172 12023.294 11823.631 11923.881 0.03062730 0.01472305
    ## 3  charges children      0      2 574 240 -2.7863080  421.22473 9.972139e-01 -4309.494  Inf     greater Welch Two Sample t-test 12365.98 15073.564 12023.294 12891.368 12464.890 0.21721717 0.09868258
    ## 4  charges children      0      3 574 157 -2.7060695  243.20548 9.963547e-01 -4813.329  Inf     greater Welch Two Sample t-test 12365.98 15355.318 12023.294 12330.869 12178.053 0.24546968 0.10043376
    ## 5  charges children      0      4 574  25 -0.7832723   27.74801 7.799491e-01 -4710.150  Inf     greater Welch Two Sample t-test 12365.98 13850.656 12023.294  9139.223 10679.068 0.13902718 0.02783920
    ## 6  charges children      0      5 574  18  3.4810329   29.20259 7.959879e-04  1832.935  Inf     greater Welch Two Sample t-test 12365.98  8786.035 12023.294  3808.436  8918.065 0.40142567 0.06887758
    ## 7  charges children      1      2 324 240 -2.2094856  489.12306 9.861983e-01 -4089.497  Inf     greater Welch Two Sample t-test 12731.17 15073.564 11823.631 12891.368 12369.027 0.18937561 0.09338827
    ## 8  charges children      1      3 324 157 -2.2178485  297.45198 9.863397e-01 -4576.409  Inf     greater Welch Two Sample t-test 12731.17 15355.318 11823.631 12330.869 12079.913 0.21723224 0.10154432
    ## 9  charges children      1      4 324  25 -0.5763734   30.56138 7.157081e-01 -4414.130  Inf     greater Welch Two Sample t-test 12731.17 13850.656 11823.631  9139.223 10567.016 0.10594140 0.02738847
    ## 10 charges children      1      5 324  18  3.5467523   39.48455 5.114071e-04  2071.569  Inf     greater Welch Two Sample t-test 12731.17  8786.035 11823.631  3808.436  8783.577 0.44914921 0.10008312
    ## 11 charges children      2      3 240 157 -0.2186234  344.03032 5.864635e-01 -2407.312  Inf     greater Welch Two Sample t-test 15073.56 15355.318 12891.368 12330.869 12614.232 0.02233625 0.01094828
    ## 12 charges children      2      4 240  25  0.6089120   34.82901 2.732671e-01 -2170.796  Inf     greater Welch Two Sample t-test 15073.56 13850.656 12891.368  9139.223 11173.916 0.10944305 0.03209514
    ## 13 charges children      2      5 240  18  5.1367681   55.83856 1.841825e-06  4240.221  Inf     greater Welch Two Sample t-test 15073.56  8786.035 12891.368  3808.436  9505.040 0.66149419 0.16680555
    ## 14 charges children      3      4 157  25  0.7248131   39.42099 2.364236e-01 -1992.114  Inf     greater Welch Two Sample t-test 15355.32 13850.656 12330.869  9139.223 10853.012 0.13864004 0.04793327
    ## 15 charges children      3      5 157  18  4.9318423   71.21179 2.573816e-06  4349.436  Inf     greater Welch Two Sample t-test 15355.32  8786.035 12330.869  3808.436  9125.638 0.71987114 0.21480331
    ## 16 charges children      4      5  25  18  2.4870826   34.16692 8.960826e-03  1621.744  Inf     greater Welch Two Sample t-test 13850.66  8786.035  9139.223  3808.436  7001.056 0.72340811 0.34327189
    ##    k_squared[bartlett] df[bartlett]  p[bartlett] bonferroni_p significant
    ## 1           15.5852419            1 7.886777e-05     0.003125       FALSE
    ## 2            0.1153396            1 7.341451e-01     0.003125       FALSE
    ## 3            1.6672644            1 1.966253e-01     0.003125       FALSE
    ## 4            0.1576254            1 6.913523e-01     0.003125       FALSE
    ## 5            2.9046073            1 8.832676e-02     0.003125       FALSE
    ## 6           23.1372171            1 1.508426e-06     0.003125        TRUE
    ## 7            2.0650067            1 1.507143e-01     0.003125       FALSE
    ## 8            0.3738531            1 5.409115e-01     0.003125       FALSE
    ## 9            2.5281700            1 1.118298e-01     0.003125       FALSE
    ## 10          22.4877050            1 2.114930e-06     0.003125        TRUE
    ## 11           0.3696063            1 5.432189e-01     0.003125       FALSE
    ## 12           4.2347393            1 3.960470e-02     0.003125       FALSE
    ## 13          24.9593898            1 5.855067e-07     0.003125        TRUE
    ## 14           3.1776718            1 7.465103e-02     0.003125       FALSE
    ## 15          23.3775961            1 1.331200e-06     0.003125        TRUE
    ## 16          12.2513375            1 4.649248e-04     0.003125       FALSE

``` r

report_ttests(df=df_insurance,dv=7,iv=c(2,4),var.equal=TRUE)
```

    ##         DV       IV level1 level2  n1  n2          t   df           p       CI_l        CI_u alternative             method    mean1     mean2       sd1       sd2 sd_pooled          d          r
    ## 1  charges      sex female   male 662 676 -2.0975466 1336 0.036132721 -2684.5324   -89.81229   two.sided  Two Sample t-test 12569.58 13956.751 11128.704 12971.026 12085.023 0.11478442 0.05733752
    ## 2  charges children      0      1 574 324 -0.4397307  896 0.660238184 -1995.1475  1264.75500   two.sided  Two Sample t-test 12365.98 12731.172 12023.294 11823.631 11923.881 0.03062730 0.01472305
    ## 3  charges children      0      2 574 240 -2.8671524  812 0.004249042 -4561.2381  -853.93815   two.sided  Two Sample t-test 12365.98 15073.564 12023.294 12891.368 12464.890 0.21721717 0.09868258
    ## 4  charges children      0      3 574 157 -2.7453944  729 0.006192704 -5127.0130  -851.67252   two.sided  Two Sample t-test 12365.98 15355.318 12023.294 12330.869 12178.053 0.24546968 0.10043376
    ## 5  charges children      0      4 574  25 -0.6095923  597 0.542363858 -6267.9304  3298.56903   two.sided  Two Sample t-test 12365.98 13850.656 12023.294  9139.223 10679.068 0.13902718 0.02783920
    ## 6  charges children      0      5 574  18  1.2603377  590 0.208045787 -1998.7052  9158.58591   two.sided  Two Sample t-test 12365.98  8786.035 12023.294  3808.436  8918.065 0.40142567 0.06887758
    ## 7  charges children      1      2 324 240 -2.2381022  562 0.025605269 -4398.1122  -286.67159   two.sided  Two Sample t-test 12731.17 15073.564 11823.631 12891.368 12369.027 0.18937561 0.09338827
    ## 8  charges children      1      3 324 157 -2.2504833  479 0.024871150 -4915.3260  -332.96703   two.sided  Two Sample t-test 12731.17 15355.318 11823.631 12330.869 12079.913 0.21723224 0.10154432
    ## 9  charges children      1      4 324  25 -0.4626241  347 0.643923793 -5878.9186  3639.94967   two.sided  Two Sample t-test 12731.17 13850.656 11823.631  9139.223 10567.016 0.10594140 0.02738847
    ## 10 charges children      1      5 324  18  1.4098163  340 0.159507995 -1559.0899  9449.36310   two.sided  Two Sample t-test 12731.17  8786.035 11823.631  3808.436  8783.577 0.44914921 0.10008312
    ## 11 charges children      2      3 240 157 -0.2165972  395 0.828634069 -2839.1567  2275.64744   two.sided  Two Sample t-test 15073.56 15355.318 12891.368 12330.869 12614.232 0.02233625 0.01094828
    ## 12 charges children      2      4 240  25  0.4619919  263 0.644469077 -3989.1654  6434.98020   two.sided  Two Sample t-test 15073.56 13850.656 12891.368  9139.223 11173.916 0.10944305 0.03209514
    ## 13 charges children      2      5 240  18  2.0591602  256 0.040490438   274.4627 12300.59425   two.sided  Two Sample t-test 15073.56  8786.035 12891.368  3808.436  9505.040 0.66149419 0.16680555
    ## 14 charges children      3      4 157  25  0.5845023  180 0.559614317 -3574.9514  6584.27546   two.sided  Two Sample t-test 15355.32 13850.656 12330.869  9139.223 10853.012 0.13864004 0.04793327
    ## 15 charges children      3      5 157  18  2.2428822  173 0.026173925   788.2114 12350.35481   two.sided  Two Sample t-test 15355.32  8786.035 12330.869  3808.436  9125.638 0.71987114 0.21480331
    ## 16 charges children      4      5  25  18  2.2110865   41 0.032664986   438.7461  9690.49607   two.sided  Two Sample t-test 13850.66  8786.035  9139.223  3808.436  7001.056 0.72340811 0.34327189
    ##    k_squared[bartlett] df[bartlett]  p[bartlett] bonferroni_p significant
    ## 1           15.5852419            1 7.886777e-05     0.003125       FALSE
    ## 2            0.1153396            1 7.341451e-01     0.003125       FALSE
    ## 3            1.6672644            1 1.966253e-01     0.003125       FALSE
    ## 4            0.1576254            1 6.913523e-01     0.003125       FALSE
    ## 5            2.9046073            1 8.832676e-02     0.003125       FALSE
    ## 6           23.1372171            1 1.508426e-06     0.003125       FALSE
    ## 7            2.0650067            1 1.507143e-01     0.003125       FALSE
    ## 8            0.3738531            1 5.409115e-01     0.003125       FALSE
    ## 9            2.5281700            1 1.118298e-01     0.003125       FALSE
    ## 10          22.4877050            1 2.114930e-06     0.003125       FALSE
    ## 11           0.3696063            1 5.432189e-01     0.003125       FALSE
    ## 12           4.2347393            1 3.960470e-02     0.003125       FALSE
    ## 13          24.9593898            1 5.855067e-07     0.003125       FALSE
    ## 14           3.1776718            1 7.465103e-02     0.003125       FALSE
    ## 15          23.3775961            1 1.331200e-06     0.003125       FALSE
    ## 16          12.2513375            1 4.649248e-04     0.003125       FALSE

## Explanation of columns

| Column | Effect | Description | Reference |
|----|----|----|----|
| DV |  | dependent variable |  |
| IV |  | independent variable |  |
| level1 |  | level 1 |  |
| level2 |  | level 2 |  |
| n1 |  | sample size for level 1 |  |
| n2 |  | sample size for level 2 |  |
| t |  | t statistic |  |
| df |  | degrees of freedom for t statistic |  |
| p |  | p value |  |
| CI_l |  | confidence interval lower bound |  |
| CI_u |  | confidence interval upper bound |  |
| alternative |  | alternative hypothesis |  |
| method |  | name of method should be displayed here |  |
| mean1 |  | mean for level 1 |  |
| mean2 |  | mean for level 2 |  |
| sd1 |  | standard deviation for level 1 |  |
| sd2 |  | standard deviation for level 2 |  |
| sd_pooled |  | pooled standard deviation combined standard deviation of both levels |  |
| d |  | measure of effect size cohen’s d |  |
| d | Very small | 0.01 | Sawilowsky (2009) |
| d | Small | 0.20 | Cohen (1988) |
| d | Medium | 0.50 | Cohen (1988) |
| d | Large | 0.80 | Cohen (1988) |
| d | Very large | 1.20 | Sawilowsky (2009) |
| d | Huge | 12.0 | Sawilowsky (2009) |
| r |  | measure of effect size correlation effect size |  |
| k_squared bartlett |  | bartlett test for homogeneity of variances |  |
| df bartlett |  | bartlett test for homogeneity of variances |  |
| p bartlett |  | bartlett test for homogeneity of variances significant values indicate heteroscedasticity |  |
| bonferroni_p |  | bonferroni adjusted critical value for a=0.05 |  |
| significant |  | if TRUE result is significant after bonferroni adjustment |  |

## Wilcoxon Test

`report_wtests` runs the Wilcoxon rank-sum test (Mann-Whitney U), the
non-parametric equivalent of the independent-samples t-test. It makes no
assumption about the distribution of the data and compares group medians
via rank ordering. Use it when the normality assumption is violated or
the outcome is ordinal.

The calls mirror those in the T-Test section exactly, allowing direct
comparison of parametric and non-parametric results on the same data.
The key difference in the output is the **W statistic** (Wilcoxon
rank-sum) in place of t.

``` r

report_wtests(df=df_insurance,dv=7,iv=c(2))
```

    ##        DV  IV level1 level2  n1  n2      W         p      CI_l     CI_u alternative                                            method    mean1    mean2     sd1      sd2 sd_pooled         d
    ## 1 charges sex female   male 662 676 221304 0.7286511 -929.0673 566.9229   two.sided Wilcoxon rank sum test with continuity correction 12569.58 13956.75 11128.7 12971.03  12085.02 0.1147844
    ##             r k_squared[bartlett] df[bartlett]  p[bartlett] bonferroni_p significant
    ## 1 0.009484225            15.58524            1 7.886777e-05         0.05       FALSE

``` r

report_wtests(df=df_insurance,dv=7,iv=c(4))
```

    ##         DV       IV level1 level2  n1  n2     W            p         CI_l       CI_u alternative                                            method    mean1     mean2       sd1       sd2 sd_pooled
    ## 1  charges children      0      1 574 324 87794 1.641134e-01 -1563.034053   309.0238   two.sided Wilcoxon rank sum test with continuity correction 12365.98 12731.172 12023.294 11823.631 11923.881
    ## 2  charges children      0      2 574 240 57386 1.715982e-04 -3218.567028 -1185.6450   two.sided Wilcoxon rank sum test with continuity correction 12365.98 15073.564 12023.294 12891.368 12464.890
    ## 3  charges children      0      3 574 157 35692 6.471971e-05 -4120.046055 -1707.1083   two.sided Wilcoxon rank sum test with continuity correction 12365.98 15355.318 12023.294 12330.869 12178.053
    ## 4  charges children      0      4 574  25  5666 7.493225e-02 -5742.998924   332.2903   two.sided Wilcoxon rank sum test with continuity correction 12365.98 13850.656 12023.294  9139.223 10679.068
    ## 5  charges children      0      5 574  18  5334 8.146626e-01 -2829.260853  4259.0758   two.sided Wilcoxon rank sum test with continuity correction 12365.98  8786.035 12023.294  3808.436  8918.065
    ## 6  charges children      1      2 324 240 33821 8.200846e-03 -2396.954845  -345.2780   two.sided Wilcoxon rank sum test with continuity correction 12731.17 15073.564 11823.631 12891.368 12369.027
    ## 7  charges children      1      3 324 157 20460 5.024998e-04 -3335.248442  -966.4038   two.sided Wilcoxon rank sum test with continuity correction 12731.17 15355.318 11823.631 12330.869 12079.913
    ## 8  charges children      1      4 324  25  3133 5.935064e-02 -5161.038838   106.4191   two.sided Wilcoxon rank sum test with continuity correction 12731.17 13850.656 11823.631  9139.223 10567.016
    ## 9  charges children      1      5 324  18  3008 8.226739e-01 -1886.640741  3039.4562   two.sided Wilcoxon rank sum test with continuity correction 12731.17  8786.035 11823.631  3808.436  8783.577
    ## 10 charges children      2      3 240 157 17627 2.780925e-01 -2020.245025   560.7960   two.sided Wilcoxon rank sum test with continuity correction 15073.56 15355.318 12891.368 12330.869 12614.232
    ## 11 charges children      2      4 240  25  2745 4.852711e-01 -3793.245800  1929.9896   two.sided Wilcoxon rank sum test with continuity correction 15073.56 13850.656 12891.368  9139.223 11173.916
    ## 12 charges children      2      5 240  18  2549 2.032662e-01  -683.722031  5203.3642   two.sided Wilcoxon rank sum test with continuity correction 15073.56  8786.035 12891.368  3808.436  9505.040
    ## 13 charges children      3      4 157  25  1922 8.701285e-01 -3127.139397  2805.0320   two.sided Wilcoxon rank sum test with continuity correction 15355.32 13850.656 12330.869  9139.223 10853.012
    ## 14 charges children      3      5 157  18  1812 5.030207e-02    -1.259839  6184.4450   two.sided Wilcoxon rank sum test with continuity correction 15355.32  8786.035 12330.869  3808.436  9125.638
    ## 15 charges children      4      5  25  18   307 4.397189e-02   190.184050  6389.2020   two.sided                      Wilcoxon rank sum exact test 13850.66  8786.035  9139.223  3808.436  7001.056
    ##             d           r k_squared[bartlett] df[bartlett]  p[bartlett] bonferroni_p significant
    ## 1  0.03062730 0.046430600           0.1153396            1 7.341451e-01  0.003333333       FALSE
    ## 2  0.21721717 0.131701388           1.6672644            1 1.966253e-01  0.003333333        TRUE
    ## 3  0.24546968 0.147756965           0.1576254            1 6.913523e-01  0.003333333        TRUE
    ## 4  0.13902718 0.072764736           2.9046073            1 8.832676e-02  0.003333333       FALSE
    ## 5  0.40142567 0.009634408          23.1372171            1 1.508426e-06  0.003333333       FALSE
    ## 6  0.18937561 0.111319302           2.0650067            1 1.507143e-01  0.003333333       FALSE
    ## 7  0.21723224 0.158647911           0.3738531            1 5.409115e-01  0.003333333        TRUE
    ## 8  0.10594140 0.100933155           2.5281700            1 1.118298e-01  0.003333333       FALSE
    ## 9  0.44914921 0.012118332          22.4877050            1 2.114930e-06  0.003333333       FALSE
    ## 10 0.02233625 0.054435239           0.3696063            1 5.432189e-01  0.003333333       FALSE
    ## 11 0.10944305 0.042868573           4.2347393            1 3.960470e-02  0.003333333       FALSE
    ## 12 0.66149419 0.079210004          24.9593898            1 5.855067e-07  0.003333333       FALSE
    ## 13 0.13864004 0.012119077           3.1776718            1 7.465103e-02  0.003333333       FALSE
    ## 14 0.71987114 0.147964493          23.3775961            1 1.331200e-06  0.003333333       FALSE
    ## 15 0.72340811 0.307186821          12.2513375            1 4.649248e-04  0.003333333       FALSE

``` r

report_wtests(df=df_insurance,dv=7,iv=c(2,4))
```

    ##         DV       IV level1 level2  n1  n2      W            p         CI_l       CI_u alternative                                            method    mean1     mean2       sd1       sd2 sd_pooled
    ## 1  charges      sex female   male 662 676 221304 7.286511e-01  -929.067302   566.9229   two.sided Wilcoxon rank sum test with continuity correction 12569.58 13956.751 11128.704 12971.026 12085.023
    ## 2  charges children      0      1 574 324  87794 1.641134e-01 -1563.034053   309.0238   two.sided Wilcoxon rank sum test with continuity correction 12365.98 12731.172 12023.294 11823.631 11923.881
    ## 3  charges children      0      2 574 240  57386 1.715982e-04 -3218.567028 -1185.6450   two.sided Wilcoxon rank sum test with continuity correction 12365.98 15073.564 12023.294 12891.368 12464.890
    ## 4  charges children      0      3 574 157  35692 6.471971e-05 -4120.046055 -1707.1083   two.sided Wilcoxon rank sum test with continuity correction 12365.98 15355.318 12023.294 12330.869 12178.053
    ## 5  charges children      0      4 574  25   5666 7.493225e-02 -5742.998924   332.2903   two.sided Wilcoxon rank sum test with continuity correction 12365.98 13850.656 12023.294  9139.223 10679.068
    ## 6  charges children      0      5 574  18   5334 8.146626e-01 -2829.260853  4259.0758   two.sided Wilcoxon rank sum test with continuity correction 12365.98  8786.035 12023.294  3808.436  8918.065
    ## 7  charges children      1      2 324 240  33821 8.200846e-03 -2396.954845  -345.2780   two.sided Wilcoxon rank sum test with continuity correction 12731.17 15073.564 11823.631 12891.368 12369.027
    ## 8  charges children      1      3 324 157  20460 5.024998e-04 -3335.248442  -966.4038   two.sided Wilcoxon rank sum test with continuity correction 12731.17 15355.318 11823.631 12330.869 12079.913
    ## 9  charges children      1      4 324  25   3133 5.935064e-02 -5161.038838   106.4191   two.sided Wilcoxon rank sum test with continuity correction 12731.17 13850.656 11823.631  9139.223 10567.016
    ## 10 charges children      1      5 324  18   3008 8.226739e-01 -1886.640741  3039.4562   two.sided Wilcoxon rank sum test with continuity correction 12731.17  8786.035 11823.631  3808.436  8783.577
    ## 11 charges children      2      3 240 157  17627 2.780925e-01 -2020.245025   560.7960   two.sided Wilcoxon rank sum test with continuity correction 15073.56 15355.318 12891.368 12330.869 12614.232
    ## 12 charges children      2      4 240  25   2745 4.852711e-01 -3793.245800  1929.9896   two.sided Wilcoxon rank sum test with continuity correction 15073.56 13850.656 12891.368  9139.223 11173.916
    ## 13 charges children      2      5 240  18   2549 2.032662e-01  -683.722031  5203.3642   two.sided Wilcoxon rank sum test with continuity correction 15073.56  8786.035 12891.368  3808.436  9505.040
    ## 14 charges children      3      4 157  25   1922 8.701285e-01 -3127.139397  2805.0320   two.sided Wilcoxon rank sum test with continuity correction 15355.32 13850.656 12330.869  9139.223 10853.012
    ## 15 charges children      3      5 157  18   1812 5.030207e-02    -1.259839  6184.4450   two.sided Wilcoxon rank sum test with continuity correction 15355.32  8786.035 12330.869  3808.436  9125.638
    ## 16 charges children      4      5  25  18    307 4.397189e-02   190.184050  6389.2020   two.sided                      Wilcoxon rank sum exact test 13850.66  8786.035  9139.223  3808.436  7001.056
    ##             d           r k_squared[bartlett] df[bartlett]  p[bartlett] bonferroni_p significant
    ## 1  0.11478442 0.009484225          15.5852419            1 7.886777e-05     0.003125       FALSE
    ## 2  0.03062730 0.046430600           0.1153396            1 7.341451e-01     0.003125       FALSE
    ## 3  0.21721717 0.131701388           1.6672644            1 1.966253e-01     0.003125        TRUE
    ## 4  0.24546968 0.147756965           0.1576254            1 6.913523e-01     0.003125        TRUE
    ## 5  0.13902718 0.072764736           2.9046073            1 8.832676e-02     0.003125       FALSE
    ## 6  0.40142567 0.009634408          23.1372171            1 1.508426e-06     0.003125       FALSE
    ## 7  0.18937561 0.111319302           2.0650067            1 1.507143e-01     0.003125       FALSE
    ## 8  0.21723224 0.158647911           0.3738531            1 5.409115e-01     0.003125        TRUE
    ## 9  0.10594140 0.100933155           2.5281700            1 1.118298e-01     0.003125       FALSE
    ## 10 0.44914921 0.012118332          22.4877050            1 2.114930e-06     0.003125       FALSE
    ## 11 0.02233625 0.054435239           0.3696063            1 5.432189e-01     0.003125       FALSE
    ## 12 0.10944305 0.042868573           4.2347393            1 3.960470e-02     0.003125       FALSE
    ## 13 0.66149419 0.079210004          24.9593898            1 5.855067e-07     0.003125       FALSE
    ## 14 0.13864004 0.012119077           3.1776718            1 7.465103e-02     0.003125       FALSE
    ## 15 0.71987114 0.147964493          23.3775961            1 1.331200e-06     0.003125       FALSE
    ## 16 0.72340811 0.307186821          12.2513375            1 4.649248e-04     0.003125       FALSE

``` r

report_wtests(df=df_insurance,dv=7,iv=c(2,4),alternative="two.sided")
```

    ##         DV       IV level1 level2  n1  n2      W            p         CI_l       CI_u alternative                                            method    mean1     mean2       sd1       sd2 sd_pooled
    ## 1  charges      sex female   male 662 676 221304 7.286511e-01  -929.067302   566.9229   two.sided Wilcoxon rank sum test with continuity correction 12569.58 13956.751 11128.704 12971.026 12085.023
    ## 2  charges children      0      1 574 324  87794 1.641134e-01 -1563.034053   309.0238   two.sided Wilcoxon rank sum test with continuity correction 12365.98 12731.172 12023.294 11823.631 11923.881
    ## 3  charges children      0      2 574 240  57386 1.715982e-04 -3218.567028 -1185.6450   two.sided Wilcoxon rank sum test with continuity correction 12365.98 15073.564 12023.294 12891.368 12464.890
    ## 4  charges children      0      3 574 157  35692 6.471971e-05 -4120.046055 -1707.1083   two.sided Wilcoxon rank sum test with continuity correction 12365.98 15355.318 12023.294 12330.869 12178.053
    ## 5  charges children      0      4 574  25   5666 7.493225e-02 -5742.998924   332.2903   two.sided Wilcoxon rank sum test with continuity correction 12365.98 13850.656 12023.294  9139.223 10679.068
    ## 6  charges children      0      5 574  18   5334 8.146626e-01 -2829.260853  4259.0758   two.sided Wilcoxon rank sum test with continuity correction 12365.98  8786.035 12023.294  3808.436  8918.065
    ## 7  charges children      1      2 324 240  33821 8.200846e-03 -2396.954845  -345.2780   two.sided Wilcoxon rank sum test with continuity correction 12731.17 15073.564 11823.631 12891.368 12369.027
    ## 8  charges children      1      3 324 157  20460 5.024998e-04 -3335.248442  -966.4038   two.sided Wilcoxon rank sum test with continuity correction 12731.17 15355.318 11823.631 12330.869 12079.913
    ## 9  charges children      1      4 324  25   3133 5.935064e-02 -5161.038838   106.4191   two.sided Wilcoxon rank sum test with continuity correction 12731.17 13850.656 11823.631  9139.223 10567.016
    ## 10 charges children      1      5 324  18   3008 8.226739e-01 -1886.640741  3039.4562   two.sided Wilcoxon rank sum test with continuity correction 12731.17  8786.035 11823.631  3808.436  8783.577
    ## 11 charges children      2      3 240 157  17627 2.780925e-01 -2020.245025   560.7960   two.sided Wilcoxon rank sum test with continuity correction 15073.56 15355.318 12891.368 12330.869 12614.232
    ## 12 charges children      2      4 240  25   2745 4.852711e-01 -3793.245800  1929.9896   two.sided Wilcoxon rank sum test with continuity correction 15073.56 13850.656 12891.368  9139.223 11173.916
    ## 13 charges children      2      5 240  18   2549 2.032662e-01  -683.722031  5203.3642   two.sided Wilcoxon rank sum test with continuity correction 15073.56  8786.035 12891.368  3808.436  9505.040
    ## 14 charges children      3      4 157  25   1922 8.701285e-01 -3127.139397  2805.0320   two.sided Wilcoxon rank sum test with continuity correction 15355.32 13850.656 12330.869  9139.223 10853.012
    ## 15 charges children      3      5 157  18   1812 5.030207e-02    -1.259839  6184.4450   two.sided Wilcoxon rank sum test with continuity correction 15355.32  8786.035 12330.869  3808.436  9125.638
    ## 16 charges children      4      5  25  18    307 4.397189e-02   190.184050  6389.2020   two.sided                      Wilcoxon rank sum exact test 13850.66  8786.035  9139.223  3808.436  7001.056
    ##             d           r k_squared[bartlett] df[bartlett]  p[bartlett] bonferroni_p significant
    ## 1  0.11478442 0.009484225          15.5852419            1 7.886777e-05     0.003125       FALSE
    ## 2  0.03062730 0.046430600           0.1153396            1 7.341451e-01     0.003125       FALSE
    ## 3  0.21721717 0.131701388           1.6672644            1 1.966253e-01     0.003125        TRUE
    ## 4  0.24546968 0.147756965           0.1576254            1 6.913523e-01     0.003125        TRUE
    ## 5  0.13902718 0.072764736           2.9046073            1 8.832676e-02     0.003125       FALSE
    ## 6  0.40142567 0.009634408          23.1372171            1 1.508426e-06     0.003125       FALSE
    ## 7  0.18937561 0.111319302           2.0650067            1 1.507143e-01     0.003125       FALSE
    ## 8  0.21723224 0.158647911           0.3738531            1 5.409115e-01     0.003125        TRUE
    ## 9  0.10594140 0.100933155           2.5281700            1 1.118298e-01     0.003125       FALSE
    ## 10 0.44914921 0.012118332          22.4877050            1 2.114930e-06     0.003125       FALSE
    ## 11 0.02233625 0.054435239           0.3696063            1 5.432189e-01     0.003125       FALSE
    ## 12 0.10944305 0.042868573           4.2347393            1 3.960470e-02     0.003125       FALSE
    ## 13 0.66149419 0.079210004          24.9593898            1 5.855067e-07     0.003125       FALSE
    ## 14 0.13864004 0.012119077           3.1776718            1 7.465103e-02     0.003125       FALSE
    ## 15 0.71987114 0.147964493          23.3775961            1 1.331200e-06     0.003125       FALSE
    ## 16 0.72340811 0.307186821          12.2513375            1 4.649248e-04     0.003125       FALSE

``` r

report_wtests(df=df_insurance,dv=7,iv=c(2,4),alternative="less")
```

    ##         DV       IV level1 level2  n1  n2      W            p CI_l       CI_u alternative                                            method    mean1     mean2       sd1       sd2 sd_pooled          d
    ## 1  charges      sex female   male 662 676 221304 3.643255e-01 -Inf   480.1140        less Wilcoxon rank sum test with continuity correction 12569.58 13956.751 11128.704 12971.026 12085.023 0.11478442
    ## 2  charges children      0      1 574 324  87794 8.205671e-02 -Inf   141.8151        less Wilcoxon rank sum test with continuity correction 12365.98 12731.172 12023.294 11823.631 11923.881 0.03062730
    ## 3  charges children      0      2 574 240  57386 8.579911e-05 -Inf -1366.6764        less Wilcoxon rank sum test with continuity correction 12365.98 15073.564 12023.294 12891.368 12464.890 0.21721717
    ## 4  charges children      0      3 574 157  35692 3.235985e-05 -Inf -1894.6137        less Wilcoxon rank sum test with continuity correction 12365.98 15355.318 12023.294 12330.869 12178.053 0.24546968
    ## 5  charges children      0      4 574  25   5666 3.746613e-02 -Inf  -237.3114        less Wilcoxon rank sum test with continuity correction 12365.98 13850.656 12023.294  9139.223 10679.068 0.13902718
    ## 6  charges children      0      5 574  18   5334 5.932118e-01 -Inf  3673.1279        less Wilcoxon rank sum test with continuity correction 12365.98  8786.035 12023.294  3808.436  8918.065 0.40142567
    ## 7  charges children      1      2 324 240  33821 4.100423e-03 -Inf  -504.4227        less Wilcoxon rank sum test with continuity correction 12731.17 15073.564 11823.631 12891.368 12369.027 0.18937561
    ## 8  charges children      1      3 324 157  20460 2.512499e-04 -Inf -1167.0091        less Wilcoxon rank sum test with continuity correction 12731.17 15355.318 11823.631 12330.869 12079.913 0.21723224
    ## 9  charges children      1      4 324  25   3133 2.967532e-02 -Inf  -388.9395        less Wilcoxon rank sum test with continuity correction 12731.17 13850.656 11823.631  9139.223 10567.016 0.10594140
    ## 10 charges children      1      5 324  18   3008 5.896157e-01 -Inf  2591.8880        less Wilcoxon rank sum test with continuity correction 12731.17  8786.035 11823.631  3808.436  8783.577 0.44914921
    ## 11 charges children      2      3 240 157  17627 1.390462e-01 -Inf   385.9682        less Wilcoxon rank sum test with continuity correction 15073.56 15355.318 12891.368 12330.869 12614.232 0.02233625
    ## 12 charges children      2      4 240  25   2745 2.426356e-01 -Inf  1465.9181        less Wilcoxon rank sum test with continuity correction 15073.56 13850.656 12891.368  9139.223 11173.916 0.10944305
    ## 13 charges children      2      5 240  18   2549 8.989473e-01 -Inf  4352.8293        less Wilcoxon rank sum test with continuity correction 15073.56  8786.035 12891.368  3808.436  9505.040 0.66149419
    ## 14 charges children      3      4 157  25   1922 4.350642e-01 -Inf  2187.4027        less Wilcoxon rank sum test with continuity correction 15355.32 13850.656 12330.869  9139.223 10853.012 0.13864004
    ## 15 charges children      3      5 157  18   1812 9.751361e-01 -Inf  5455.1278        less Wilcoxon rank sum test with continuity correction 15355.32  8786.035 12330.869  3808.436  9125.638 0.71987114
    ## 16 charges children      4      5  25  18    307 9.793183e-01 -Inf  6118.6019        less                      Wilcoxon rank sum exact test 13850.66  8786.035  9139.223  3808.436  7001.056 0.72340811
    ##              r k_squared[bartlett] df[bartlett]  p[bartlett] bonferroni_p significant
    ## 1  0.009484225          15.5852419            1 7.886777e-05     0.003125       FALSE
    ## 2  0.046430600           0.1153396            1 7.341451e-01     0.003125       FALSE
    ## 3  0.131701388           1.6672644            1 1.966253e-01     0.003125        TRUE
    ## 4  0.147756965           0.1576254            1 6.913523e-01     0.003125        TRUE
    ## 5  0.072764736           2.9046073            1 8.832676e-02     0.003125       FALSE
    ## 6  0.009634408          23.1372171            1 1.508426e-06     0.003125       FALSE
    ## 7  0.111319302           2.0650067            1 1.507143e-01     0.003125       FALSE
    ## 8  0.158647911           0.3738531            1 5.409115e-01     0.003125        TRUE
    ## 9  0.100933155           2.5281700            1 1.118298e-01     0.003125       FALSE
    ## 10 0.012118332          22.4877050            1 2.114930e-06     0.003125       FALSE
    ## 11 0.054435239           0.3696063            1 5.432189e-01     0.003125       FALSE
    ## 12 0.042868573           4.2347393            1 3.960470e-02     0.003125       FALSE
    ## 13 0.079210004          24.9593898            1 5.855067e-07     0.003125       FALSE
    ## 14 0.012119077           3.1776718            1 7.465103e-02     0.003125       FALSE
    ## 15 0.147964493          23.3775961            1 1.331200e-06     0.003125       FALSE
    ## 16 0.307186821          12.2513375            1 4.649248e-04     0.003125       FALSE

``` r

report_wtests(df=df_insurance,dv=7,iv=c(2,4),alternative="greater")
```

    ##         DV       IV level1 level2  n1  n2      W          p       CI_l CI_u alternative                                            method    mean1     mean2       sd1       sd2 sd_pooled          d
    ## 1  charges      sex female   male 662 676 221304 0.63572761  -791.7764  Inf     greater Wilcoxon rank sum test with continuity correction 12569.58 13956.751 11128.704 12971.026 12085.023 0.11478442
    ## 2  charges children      0      1 574 324  87794 0.91798388 -1412.4132  Inf     greater Wilcoxon rank sum test with continuity correction 12365.98 12731.172 12023.294 11823.631 11923.881 0.03062730
    ## 3  charges children      0      2 574 240  57386 0.99991431 -3053.8243  Inf     greater Wilcoxon rank sum test with continuity correction 12365.98 15073.564 12023.294 12891.368 12464.890 0.21721717
    ## 4  charges children      0      3 574 157  35692 0.99996770 -3928.2216  Inf     greater Wilcoxon rank sum test with continuity correction 12365.98 15355.318 12023.294 12330.869 12178.053 0.24546968
    ## 5  charges children      0      4 574  25   5666 0.96263023 -5306.0104  Inf     greater Wilcoxon rank sum test with continuity correction 12365.98 13850.656 12023.294  9139.223 10679.068 0.13902718
    ## 6  charges children      0      5 574  18   5334 0.40733130 -2491.7828  Inf     greater Wilcoxon rank sum test with continuity correction 12365.98  8786.035 12023.294  3808.436  8918.065 0.40142567
    ## 7  charges children      1      2 324 240  33821 0.99590590 -2228.9913  Inf     greater Wilcoxon rank sum test with continuity correction 12731.17 15073.564 11823.631 12891.368 12369.027 0.18937561
    ## 8  charges children      1      3 324 157  20460 0.99974941 -3136.6651  Inf     greater Wilcoxon rank sum test with continuity correction 12731.17 15355.318 11823.631 12330.869 12079.913 0.21723224
    ## 9  charges children      1      4 324  25   3133 0.97046314 -4687.4514  Inf     greater Wilcoxon rank sum test with continuity correction 12731.17 13850.656 11823.631  9139.223 10567.016 0.10594140
    ## 10 charges children      1      5 324  18   3008 0.41133693 -1541.0272  Inf     greater Wilcoxon rank sum test with continuity correction 12731.17  8786.035 11823.631  3808.436  8783.577 0.44914921
    ## 11 charges children      2      3 240 157  17627 0.86115186 -1808.1586  Inf     greater Wilcoxon rank sum test with continuity correction 15073.56 15355.318 12891.368 12330.869 12614.232 0.02233625
    ## 12 charges children      2      4 240  25   2745 0.75822112 -3293.3247  Inf     greater Wilcoxon rank sum test with continuity correction 15073.56 13850.656 12891.368  9139.223 11173.916 0.10944305
    ## 13 charges children      2      5 240  18   2549 0.10163309  -358.7102  Inf     greater Wilcoxon rank sum test with continuity correction 15073.56  8786.035 12891.368  3808.436  9505.040 0.66149419
    ## 14 charges children      3      4 157  25   1922 0.56654420 -2665.3468  Inf     greater Wilcoxon rank sum test with continuity correction 15355.32 13850.656 12330.869  9139.223 10853.012 0.13864004
    ## 15 charges children      3      5 157  18   1812 0.02515104   410.5912  Inf     greater Wilcoxon rank sum test with continuity correction 15355.32  8786.035 12330.869  3808.436  9125.638 0.71987114
    ## 16 charges children      4      5  25  18    307 0.02198594   793.8072  Inf     greater                      Wilcoxon rank sum exact test 13850.66  8786.035  9139.223  3808.436  7001.056 0.72340811
    ##              r k_squared[bartlett] df[bartlett]  p[bartlett] bonferroni_p significant
    ## 1  0.009484225          15.5852419            1 7.886777e-05     0.003125       FALSE
    ## 2  0.046430600           0.1153396            1 7.341451e-01     0.003125       FALSE
    ## 3  0.131701388           1.6672644            1 1.966253e-01     0.003125       FALSE
    ## 4  0.147756965           0.1576254            1 6.913523e-01     0.003125       FALSE
    ## 5  0.072764736           2.9046073            1 8.832676e-02     0.003125       FALSE
    ## 6  0.009634408          23.1372171            1 1.508426e-06     0.003125       FALSE
    ## 7  0.111319302           2.0650067            1 1.507143e-01     0.003125       FALSE
    ## 8  0.158647911           0.3738531            1 5.409115e-01     0.003125       FALSE
    ## 9  0.100933155           2.5281700            1 1.118298e-01     0.003125       FALSE
    ## 10 0.012118332          22.4877050            1 2.114930e-06     0.003125       FALSE
    ## 11 0.054435239           0.3696063            1 5.432189e-01     0.003125       FALSE
    ## 12 0.042868573           4.2347393            1 3.960470e-02     0.003125       FALSE
    ## 13 0.079210004          24.9593898            1 5.855067e-07     0.003125       FALSE
    ## 14 0.012119077           3.1776718            1 7.465103e-02     0.003125       FALSE
    ## 15 0.147964493          23.3775961            1 1.331200e-06     0.003125       FALSE
    ## 16 0.307186821          12.2513375            1 4.649248e-04     0.003125       FALSE

``` r

report_wtests(df=df_insurance,dv=7,iv=c(2,4),var.equal=FALSE)
```

    ##         DV       IV level1 level2  n1  n2      W            p         CI_l       CI_u alternative                                            method    mean1     mean2       sd1       sd2 sd_pooled
    ## 1  charges      sex female   male 662 676 221304 7.286511e-01  -929.067302   566.9229   two.sided Wilcoxon rank sum test with continuity correction 12569.58 13956.751 11128.704 12971.026 12085.023
    ## 2  charges children      0      1 574 324  87794 1.641134e-01 -1563.034053   309.0238   two.sided Wilcoxon rank sum test with continuity correction 12365.98 12731.172 12023.294 11823.631 11923.881
    ## 3  charges children      0      2 574 240  57386 1.715982e-04 -3218.567028 -1185.6450   two.sided Wilcoxon rank sum test with continuity correction 12365.98 15073.564 12023.294 12891.368 12464.890
    ## 4  charges children      0      3 574 157  35692 6.471971e-05 -4120.046055 -1707.1083   two.sided Wilcoxon rank sum test with continuity correction 12365.98 15355.318 12023.294 12330.869 12178.053
    ## 5  charges children      0      4 574  25   5666 7.493225e-02 -5742.998924   332.2903   two.sided Wilcoxon rank sum test with continuity correction 12365.98 13850.656 12023.294  9139.223 10679.068
    ## 6  charges children      0      5 574  18   5334 8.146626e-01 -2829.260853  4259.0758   two.sided Wilcoxon rank sum test with continuity correction 12365.98  8786.035 12023.294  3808.436  8918.065
    ## 7  charges children      1      2 324 240  33821 8.200846e-03 -2396.954845  -345.2780   two.sided Wilcoxon rank sum test with continuity correction 12731.17 15073.564 11823.631 12891.368 12369.027
    ## 8  charges children      1      3 324 157  20460 5.024998e-04 -3335.248442  -966.4038   two.sided Wilcoxon rank sum test with continuity correction 12731.17 15355.318 11823.631 12330.869 12079.913
    ## 9  charges children      1      4 324  25   3133 5.935064e-02 -5161.038838   106.4191   two.sided Wilcoxon rank sum test with continuity correction 12731.17 13850.656 11823.631  9139.223 10567.016
    ## 10 charges children      1      5 324  18   3008 8.226739e-01 -1886.640741  3039.4562   two.sided Wilcoxon rank sum test with continuity correction 12731.17  8786.035 11823.631  3808.436  8783.577
    ## 11 charges children      2      3 240 157  17627 2.780925e-01 -2020.245025   560.7960   two.sided Wilcoxon rank sum test with continuity correction 15073.56 15355.318 12891.368 12330.869 12614.232
    ## 12 charges children      2      4 240  25   2745 4.852711e-01 -3793.245800  1929.9896   two.sided Wilcoxon rank sum test with continuity correction 15073.56 13850.656 12891.368  9139.223 11173.916
    ## 13 charges children      2      5 240  18   2549 2.032662e-01  -683.722031  5203.3642   two.sided Wilcoxon rank sum test with continuity correction 15073.56  8786.035 12891.368  3808.436  9505.040
    ## 14 charges children      3      4 157  25   1922 8.701285e-01 -3127.139397  2805.0320   two.sided Wilcoxon rank sum test with continuity correction 15355.32 13850.656 12330.869  9139.223 10853.012
    ## 15 charges children      3      5 157  18   1812 5.030207e-02    -1.259839  6184.4450   two.sided Wilcoxon rank sum test with continuity correction 15355.32  8786.035 12330.869  3808.436  9125.638
    ## 16 charges children      4      5  25  18    307 4.397189e-02   190.184050  6389.2020   two.sided                      Wilcoxon rank sum exact test 13850.66  8786.035  9139.223  3808.436  7001.056
    ##             d           r k_squared[bartlett] df[bartlett]  p[bartlett] bonferroni_p significant
    ## 1  0.11478442 0.009484225          15.5852419            1 7.886777e-05     0.003125       FALSE
    ## 2  0.03062730 0.046430600           0.1153396            1 7.341451e-01     0.003125       FALSE
    ## 3  0.21721717 0.131701388           1.6672644            1 1.966253e-01     0.003125        TRUE
    ## 4  0.24546968 0.147756965           0.1576254            1 6.913523e-01     0.003125        TRUE
    ## 5  0.13902718 0.072764736           2.9046073            1 8.832676e-02     0.003125       FALSE
    ## 6  0.40142567 0.009634408          23.1372171            1 1.508426e-06     0.003125       FALSE
    ## 7  0.18937561 0.111319302           2.0650067            1 1.507143e-01     0.003125       FALSE
    ## 8  0.21723224 0.158647911           0.3738531            1 5.409115e-01     0.003125        TRUE
    ## 9  0.10594140 0.100933155           2.5281700            1 1.118298e-01     0.003125       FALSE
    ## 10 0.44914921 0.012118332          22.4877050            1 2.114930e-06     0.003125       FALSE
    ## 11 0.02233625 0.054435239           0.3696063            1 5.432189e-01     0.003125       FALSE
    ## 12 0.10944305 0.042868573           4.2347393            1 3.960470e-02     0.003125       FALSE
    ## 13 0.66149419 0.079210004          24.9593898            1 5.855067e-07     0.003125       FALSE
    ## 14 0.13864004 0.012119077           3.1776718            1 7.465103e-02     0.003125       FALSE
    ## 15 0.71987114 0.147964493          23.3775961            1 1.331200e-06     0.003125       FALSE
    ## 16 0.72340811 0.307186821          12.2513375            1 4.649248e-04     0.003125       FALSE

## Explanation of columns

| Column | Effect | Description | Reference |
|----|----|----|----|
| DV |  | dependent variable |  |
| IV |  | independent variable |  |
| level1 |  | level 1 |  |
| level2 |  | level 2 |  |
| n1 |  | sample size for level 1 |  |
| n2 |  | sample size for level 2 |  |
| W |  | wilcoxon statistic |  |
| df |  | degrees of freedom for t statistic |  |
| p |  | p value |  |
| CI_l |  | confidence interval lower bound |  |
| CI_u |  | confidence interval upper bound |  |
| alternative |  | alternative hypothesis |  |
| method |  | name of method should be displayed here |  |
| mean1 |  | mean for level 1 |  |
| mean2 |  | mean for level 2 |  |
| sd1 |  | standard deviation for level 1 |  |
| sd2 |  | standard deviation for level 2 |  |
| sd_pooled |  | pooled standard deviation combined standard deviation of both levels |  |
| d |  | measure of effect size cohen’s d |  |
| d | Very small | 0.01 | Sawilowsky (2009) |
| d | Small | 0.20 | Cohen (1988) |
| d | Medium | 0.50 | Cohen (1988) |
| d | Large | 0.80 | Cohen (1988) |
| d | Very large | 1.20 | Sawilowsky (2009) |
| d | Huge | 12.0 | Sawilowsky (2009) |
| r |  | measure of effect size correlation effect size |  |
| k_squared bartlett |  | bartlett test for homogeneity of variances |  |
| df bartlett |  | bartlett test for homogeneity of variances |  |
| p bartlett |  | bartlett test for homogeneity of variances significant values indicate heteroscedasticity |  |
| bonferroni_p |  | bonferroni adjusted critical value for a=0.05 |  |
| significant |  | if TRUE result is significant after bonferroni adjustment |  |

## Formulas

Group 1 = `level1`, group 2 = `level2`; x\_{1i} (i=1,\dots,n_1) and
x\_{2j} (j=1,\dots,n_2) are the DV values of the complete cases in each
group, g_i is the IV value of case i; N=n_1+n_2; \alpha=0.05; m = number
of rows in the output table; \Phi, \varphi = standard normal CDF and
density, z_q=\Phi^{-1}(q); t\_{q,\\df} = q quantile of the t
distribution.

### report_ttests

**`n1`, `n2`**

n_1=\sum_i \mathbf{1}\[g_i=\text{level1}\],\qquad n_2=\sum_i
\mathbf{1}\[g_i=\text{level2}\]

------------------------------------------------------------------------

**`mean1`, `mean2`**

\bar{x}\_1=\frac{1}{n_1}\sum\_{i=1}^{n_1}x\_{1i},\qquad
\bar{x}\_2=\frac{1}{n_2}\sum\_{j=1}^{n_2}x\_{2j}

------------------------------------------------------------------------

**`sd1`, `sd2`**

s_1=\sqrt{\frac{1}{n_1-1}\sum\_{i=1}^{n_1}(x\_{1i}-\bar{x}\_1)^2},\qquad
s_2=\sqrt{\frac{1}{n_2-1}\sum\_{j=1}^{n_2}(x\_{2j}-\bar{x}\_2)^2}

------------------------------------------------------------------------

**`t`**

\text{Welch (default):}\quad t=\frac{\bar{x}\_1-\bar{x}\_2}{SE},\qquad
SE=\sqrt{\frac{s_1^2}{n_1}+\frac{s_2^2}{n_2}}

\text{Student (var.equal = TRUE):}\quad
t=\frac{\bar{x}\_1-\bar{x}\_2}{SE},\qquad
SE=s_p\sqrt{\frac{1}{n_1}+\frac{1}{n_2}},\qquad
s_p^2=\frac{(n_1-1)s_1^2+(n_2-1)s_2^2}{N-2}

------------------------------------------------------------------------

**`df`**

\text{Welch:}\quad
df=\frac{\left(\frac{s_1^2}{n_1}+\frac{s_2^2}{n_2}\right)^2}{\frac{(s_1^2/n_1)^2}{n_1-1}+\frac{(s_2^2/n_2)^2}{n_2-1}},\qquad
\text{Student:}\quad df=N-2

------------------------------------------------------------------------

**`p`**

p\_{\text{two.sided}}=2\\P(T\_{df}\ge\lvert t\rvert),\qquad
p\_{\text{less}}=P(T\_{df}\le t),\qquad p\_{\text{greater}}=P(T\_{df}\ge
t),\qquad T\_{df}\sim t(df)

------------------------------------------------------------------------

**`CI_l`, `CI_u`**

\text{two.sided:}\quad
\left\[(\bar{x}\_1-\bar{x}\_2)-t\_{1-\alpha/2,\\df}\\SE,\\ \\
(\bar{x}\_1-\bar{x}\_2)+t\_{1-\alpha/2,\\df}\\SE\right\]

\text{less:}\quad \left(-\infty,\\ \\
(\bar{x}\_1-\bar{x}\_2)+t\_{1-\alpha,\\df}\\SE\right\],\qquad
\text{greater:}\quad
\left\[(\bar{x}\_1-\bar{x}\_2)-t\_{1-\alpha,\\df}\\SE,\\ \\
\infty\right)

------------------------------------------------------------------------

**`sd_pooled`**

s\_{pooled}=\sqrt{\frac{s_1^2+s_2^2}{2}}

------------------------------------------------------------------------

**`d`**

d=\frac{\lvert\bar{x}\_2-\bar{x}\_1\rvert}{s\_{pooled}}

------------------------------------------------------------------------

**`r`**

r=\frac{d}{\sqrt{d^2+\frac{N^2}{n_1n_2}}}

------------------------------------------------------------------------

**`k_squared[bartlett]`**

K^2=\frac{(N-2)\ln s_p^2-(n_1-1)\ln s_1^2-(n_2-1)\ln
s_2^2}{1+\frac{1}{3}\left(\frac{1}{n_1-1}+\frac{1}{n_2-1}-\frac{1}{N-2}\right)},\qquad
s_p^2=\frac{(n_1-1)s_1^2+(n_2-1)s_2^2}{N-2}

------------------------------------------------------------------------

**`df[bartlett]`**

df\_{bartlett}=k-1=2-1=1

------------------------------------------------------------------------

**`p[bartlett]`**

p\_{bartlett}=P\left(\chi^2\_{1}\ge K^2\right)

------------------------------------------------------------------------

**`bonferroni_p`**

\alpha\_{bonferroni}=\frac{\alpha}{m}=\frac{0.05}{m}

------------------------------------------------------------------------

**`significant`**

\text{significant}=\begin{cases}\text{TRUE} & p\<\alpha\_{bonferroni}\\
\text{FALSE} & p\ge\alpha\_{bonferroni}\end{cases}

### report_wtests

`n1`, `n2`, `mean1`, `mean2`, `sd1`, `sd2`, `sd_pooled`, `d`,
`k_squared[bartlett]`, `df[bartlett]`, `p[bartlett]`, `bonferroni_p`,
`significant`: as in `report_ttests`.

------------------------------------------------------------------------

**`W`**

W=R_1-\frac{n_1(n_1+1)}{2},\qquad
R_1=\sum\_{i=1}^{n_1}\operatorname{rank}(x\_{1i})\\ \\ \text{(ranks in
the pooled sample of } N \text{ values, ties averaged)}

------------------------------------------------------------------------

**`p`**

\text{exact } (n_1\<50,\\ n_2\<50)\text{:}\quad
p\_{\text{two.sided}}=\min\\1,\\ 2P(W_0\le W),\\ 2P(W_0\ge W)\\,\qquad
p\_{\text{less}}=P(W_0\le W),\qquad p\_{\text{greater}}=P(W_0\ge W)

\text{normal approximation (otherwise):}\quad
p\_{\text{two.sided}}=2\min\\\Phi(z),\\ 1-\Phi(z)\\,\qquad
p\_{\text{less}}=\Phi(z),\qquad p\_{\text{greater}}=1-\Phi(z)

z=\frac{W-\frac{n_1n_2}{2}-c}{\sigma_W},\qquad
\sigma_W=\sqrt{\frac{n_1n_2}{12}\left\[(N+1)-\frac{\sum_k(t_k^3-t_k)}{N(N-1)}\right\]},\qquad
c=\begin{cases}0.5\\\operatorname{sign}\left(W-\frac{n_1n_2}{2}\right) &
\text{two.sided}\\ 0.5 & \text{greater}\\ -0.5 & \text{less}\end{cases}

W_0 = null distribution of W (conditional on the ties), t_k = number of
values in tie group k.

------------------------------------------------------------------------

**`CI_l`, `CI_u`**

\text{exact, no ties:}\quad \text{two.sided: }\left\[D\_{(k)},\\
D\_{(n_1n_2-k+1)}\right\],\quad \text{greater: }\left\[D\_{(k)},\\
\infty\right),\quad \text{less: }\left(-\infty,\\
D\_{(n_1n_2-k+1)}\right\]

k=\min\\w:\\ P(W_0\le w)\>\alpha/2\\\\ \text{(two.sided)},\qquad
k=\min\\w:\\ P(W_0\le w)\>\alpha\\\\ \text{(one-sided)}

\text{normal approximation:}\quad \text{two.sided: }
z(CI_l)=z\_{1-\alpha/2},\\ z(CI_u)=z\_{\alpha/2},\qquad \text{greater: }
z(CI_l)=z\_{1-\alpha},\qquad \text{less: } z(CI_u)=z\_{\alpha}

D\_{(1)}\le\dots\le D\_{(n_1n_2)} = sorted differences x\_{1i}-x\_{2j};
z(\Delta) = z computed on x\_{1i}-\Delta and x\_{2j}.

------------------------------------------------------------------------

**`r`**

r=\frac{\lvert Z\rvert}{\sqrt{N}},\qquad
Z=\Phi^{-1}\left(1-\frac{p}{2}\right)

### Between- and within-subjects designs

Between subjects: two independent groups, x\_{1i} (i=1,\dots,n_1) and
x\_{2j} (j=1,\dots,n_2), N=n_1+n_2. Within subjects: n paired
observations (x\_{1i},x\_{2i}) on the same cases, d_i=x\_{1i}-x\_{2i}
(i=1,\dots,n).

#### t-test

**Between subjects (independent samples)**

\text{Welch:}\quad
t=\frac{\bar{x}\_1-\bar{x}\_2}{\sqrt{\frac{s_1^2}{n_1}+\frac{s_2^2}{n_2}}},\qquad
df=\frac{\left(\frac{s_1^2}{n_1}+\frac{s_2^2}{n_2}\right)^2}{\frac{(s_1^2/n_1)^2}{n_1-1}+\frac{(s_2^2/n_2)^2}{n_2-1}}

\text{Student:}\quad
t=\frac{\bar{x}\_1-\bar{x}\_2}{s_p\sqrt{\frac{1}{n_1}+\frac{1}{n_2}}},\qquad
s_p^2=\frac{(n_1-1)s_1^2+(n_2-1)s_2^2}{N-2},\qquad df=N-2

d=\frac{\bar{x}\_1-\bar{x}\_2}{s_p}

------------------------------------------------------------------------

**Within subjects (paired samples)**

\bar{d}=\frac{1}{n}\sum\_{i=1}^{n}d_i,\qquad
s_d=\sqrt{\frac{1}{n-1}\sum\_{i=1}^{n}(d_i-\bar{d})^2},\qquad
SE=\frac{s_d}{\sqrt{n}}

t=\frac{\bar{d}}{s_d/\sqrt{n}},\qquad df=n-1

p\_{\text{two.sided}}=2\\P(T\_{n-1}\ge\lvert t\rvert),\qquad
p\_{\text{less}}=P(T\_{n-1}\le t),\qquad
p\_{\text{greater}}=P(T\_{n-1}\ge t)

\text{two.sided: }\left\[\bar{d}-t\_{1-\alpha/2,\\n-1}\\SE,\\ \\
\bar{d}+t\_{1-\alpha/2,\\n-1}\\SE\right\],\qquad \text{less:
}\left(-\infty,\\ \bar{d}+t\_{1-\alpha,\\n-1}\\SE\right\],\qquad
\text{greater: }\left\[\bar{d}-t\_{1-\alpha,\\n-1}\\SE,\\ \infty\right)

d_z=\frac{\bar{d}}{s_d}=\frac{t}{\sqrt{n}}

#### Wilcoxon test

**Between subjects (rank-sum test, Mann-Whitney U)**

W=\sum\_{i=1}^{n_1}\operatorname{rank}(x\_{1i})-\frac{n_1(n_1+1)}{2}\\
\\ \text{(ranks in the pooled sample of } N \text{ values)},\qquad
E(W)=\frac{n_1n_2}{2}

z=\frac{W-\frac{n_1n_2}{2}-c}{\sqrt{\frac{n_1n_2}{12}\left\[(N+1)-\frac{\sum_k(t_k^3-t_k)}{N(N-1)}\right\]}},\qquad
r=\frac{\lvert Z\rvert}{\sqrt{N}}

\text{CI: Hodges-Lehmann, from the sorted } n_1n_2 \text{ differences }
x\_{1i}-x\_{2j}

------------------------------------------------------------------------

**Within subjects (signed-rank test)**

V=\sum\_{i:\\d_i\>0}\operatorname{rank}\left(\lvert
d_i\rvert\right),\qquad E(V)=\frac{n'(n'+1)}{4}

\text{exact } (n\<50)\text{:}\quad p\_{\text{two.sided}}=\min\\1,\\
2P(V_0\le V),\\ 2P(V_0\ge V)\\,\qquad p\_{\text{less}}=P(V_0\le
V),\qquad p\_{\text{greater}}=P(V_0\ge V)

\text{normal approximation (otherwise):}\quad
z=\frac{V-\frac{n'(n'+1)}{4}-c}{\sigma_V},\qquad
\sigma_V=\sqrt{\frac{n'(n'+1)(2n'+1)}{24}-\frac{\sum_k(t_k^3-t_k)}{48}}

p\_{\text{two.sided}}=2\min\\\Phi(z),\\ 1-\Phi(z)\\,\qquad
p\_{\text{less}}=\Phi(z),\qquad p\_{\text{greater}}=1-\Phi(z)

\text{exact, no ties or zeros:}\quad \text{two.sided:
}\left\[A\_{(k)},\\ A\_{(M-k+1)}\right\],\quad \text{greater:
}\left\[A\_{(k)},\\ \infty\right),\quad \text{less: }\left(-\infty,\\
A\_{(M-k+1)}\right\],\qquad M=\frac{n(n+1)}{2}

k=\min\\v:\\ P(V_0\le v)\>\alpha/2\\\\ \text{(two.sided)},\qquad
k=\min\\v:\\ P(V_0\le v)\>\alpha\\\\ \text{(one-sided)}

r=\frac{\lvert Z\rvert}{\sqrt{n}},\qquad
Z=\Phi^{-1}\left(1-\frac{p}{2}\right)

n' = number of non-zero d_i (zero differences are dropped in the normal
approximation; the exact test ranks all n differences and conditions V_0
on their ranks), t_k = number of \lvert d_i\rvert in tie group k, c =
continuity correction (0.5\\\operatorname{sign}(V-E(V)) two.sided, 0.5
greater, -0.5 less), A\_{(1)}\le\dots\le A\_{(M)} = sorted Walsh
averages (d_i+d_j)/2, i\le j.

## References

Bartlett, M. S. (1937). Properties of sufficiency and statistical tests.
*Proceedings of the Royal Society of London. Series A, 160*(901),
268–282. <https://doi.org/10.1098/rspa.1937.0109>

Bonferroni, C. E. (1936). Teoria statistica delle classi e calcolo delle
probabilità. *Pubblicazioni del R Istituto Superiore di Scienze
Economiche e Commerciali di Firenze, 8*, 3–62.

Borenstein, M., Hedges, L. V., Higgins, J. P. T., & Rothstein, H. R.
(2009). *Introduction to meta-analysis*. Wiley.
<https://doi.org/10.1002/9780470743386>

Box, G. E. P. (1953). Non-normality and tests on variances. *Biometrika,
40*(3–4), 318–335. <https://doi.org/10.1093/biomet/40.3-4.318>

Cohen, J. (1988). *Statistical power analysis for the behavioral
sciences* (2nd ed.). Lawrence Erlbaum Associates.

Delacre, M., Lakens, D., & Leys, C. (2017). Why psychologists should by
default use Welch’s t-test instead of Student’s t-test. *International
Review of Social Psychology, 30*(1), 92–101.
<https://doi.org/10.5334/irsp.82>

Dunn, O. J. (1961). Multiple comparisons among means. *Journal of the
American Statistical Association, 56*(293), 52–64.
<https://doi.org/10.1080/01621459.1961.10482090>

Fagerland, M. W., & Sandvik, L. (2009). The Wilcoxon-Mann-Whitney test
under scrutiny. *Statistics in Medicine, 28*(10), 1487–1497.
<https://doi.org/10.1002/sim.3561>

Hodges, J. L., & Lehmann, E. L. (1963). Estimates of location based on
rank tests. *The Annals of Mathematical Statistics, 34*(2), 598–611.
<https://doi.org/10.1214/aoms/1177704172>

Mann, H. B., & Whitney, D. R. (1947). On a test of whether one of two
random variables is stochastically larger than the other. *The Annals of
Mathematical Statistics, 18*(1), 50–60.
<https://doi.org/10.1214/aoms/1177730491>

Rosenthal, R. (1991). *Meta-analytic procedures for social research*
(Rev. ed.). Sage. <https://doi.org/10.4135/9781412984997>

Satterthwaite, F. E. (1946). An approximate distribution of estimates of
variance components. *Biometrics Bulletin, 2*(6), 110–114.
<https://doi.org/10.2307/3002019>

Sawilowsky, S. S. (2009). New effect size rules of thumb. *Journal of
Modern Applied Statistical Methods, 8*(2), 597–599.
<https://doi.org/10.22237/jmasm/1257035100>

Shapiro, S. S., & Wilk, M. B. (1965). An analysis of variance test for
normality (complete samples). *Biometrika, 52*(3–4), 591–611.
<https://doi.org/10.1093/biomet/52.3-4.591>

Student. (1908). The probable error of a mean. *Biometrika, 6*(1), 1–25.
<https://doi.org/10.1093/biomet/6.1.1>

Welch, B. L. (1947). The generalization of “Student’s” problem when
several different population variances are involved. *Biometrika,
34*(1–2), 28–35. <https://doi.org/10.1093/biomet/34.1-2.28>

Wilcoxon, F. (1945). Individual comparisons by ranking methods.
*Biometrics Bulletin, 1*(6), 80–83. <https://doi.org/10.2307/3001968>
