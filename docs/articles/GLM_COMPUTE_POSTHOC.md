# Post hoc comparisons

## Description

This shows the output of `compute_posthoc` from the package rwf, which
compares every pair of group means after a one-way ANOVA with two post
hoc tests: the Tukey-Kramer test (Tukey, 1953; Kramer, 1956), which
assumes equal variances, and the Games-Howell test (Games & Howell,
1976), which does not. For each pair of groups the function returns the
t statistic, the degrees of freedom and a p value adjusted for all the
pairwise comparisons. Each section gives the formulas the function uses,
computes them by hand and checks the results against `stats`, `emmeans`
and `rstatix`.

`compute_posthoc` is adapted from `posthocTGH()` in the
`userfriendlyscience` package by Gjalt-Jorn Peters (Open University of
the Netherlands) and Jeff Baggett (University of Wisconsin - La Crosse),
which was in turn based on `games_howell.R`, a script hosted on the
course page of Robert Cribbie (York University) that is no longer
available.

Installation instructions for rwf can be found
[here](https://github.com/sedzinfo/rwf)

The code can be found
[here](https://github.com/sedzinfo/rwf/blob/main/rwf/R/GLM_ANOVA.R)

## Notation

There are k independent groups and N observations. Group j has n_j
observations, mean \bar{y}\_j and sample variance s_j^2. There are
m=k(k-1)/2 pairs of groups.
MS\_{\text{error}}=\sum\_{j=1}^{k}(n_j-1)s_j^2/(N-k) is the pooled error
variance of the one-way ANOVA. q\_{k,df} is the studentized range
distribution for k means and df degrees of freedom.

## Why post hoc tests

A significant one-way ANOVA says that at least one group mean differs
from the others, not which ones. The obvious next step, a t test for
every pair, inflates the chance of a false positive. Each test has a 5%
chance of a Type I error, and with m tests the chance that **at least
one** of them is a false positive, the family-wise error rate, is up to

\text{FWER}=1-(1-\alpha)^m

``` r

k <- 2:8
data.frame(groups = k, pairs = k * (k - 1) / 2, fwer = 1 - (1 - 0.05)^(k * (k - 1) / 2))
```

    ##   groups pairs      fwer
    ## 1      2     1 0.0500000
    ## 2      3     3 0.1426250
    ## 3      4     6 0.2649081
    ## 4      5    10 0.4012631
    ## 5      6    15 0.5367088
    ## 6      7    21 0.6594384
    ## 7      8    28 0.7621731

The formula assumes independent tests. Pairwise comparisons share
groups, so the real rate is somewhat lower, but it still grows quickly
([simulation below](#family-wise-error-rate)). Post hoc tests keep the
family-wise error rate at 5% across all the pairs.

## The tests

### The studentized range

If k group means come from the same population, the studentized range
compares the largest difference between them with the standard error of
a mean:

q=\frac{\bar{y}\_{\max}-\bar{y}\_{\min}}{\sqrt{MS\_{\text{error}}/n}}

and follows the distribution q\_{k,df}. Tukey’s idea was to judge every
pair against this distribution of the **largest** difference among k
means. If even the largest difference expected by chance is rarely as
large as the observed one, the error rate holds for all the pairs
together. For a pair, q=\sqrt{2}\\t, so

p=P\left(q\_{k,df}\ge\sqrt{2}\\t\_{ij}\right)

This p value already accounts for the number of groups. Do not adjust it
again.

### Tukey-Kramer

The Tukey-Kramer test uses the pooled error variance of all k groups and
the error degrees of freedom of the ANOVA. Kramer’s (1956) extension to
groups of different sizes uses 1/n_i+1/n_j:

t\_{ij}=\frac{\left\|\bar{y}\_i-\bar{y}\_j\right\|}{\sqrt{MS\_{\text{error}}\left(\frac{1}{n_i}+\frac{1}{n_j}\right)}},\qquad
df=N-k

### Games-Howell

The Games-Howell test uses only the variances of the two groups being
compared, and the Welch-Satterthwaite degrees of freedom of the pair:

t\_{ij}=\frac{\left\|\bar{y}\_i-\bar{y}\_j\right\|}{\sqrt{\frac{s_i^2}{n_i}+\frac{s_j^2}{n_j}}},\qquad
df\_{ij}=\frac{\left(\frac{s_i^2}{n_i}+\frac{s_j^2}{n_j}\right)^2}{\frac{\left(s_i^2/n_i\right)^2}{n_i-1}+\frac{\left(s_j^2/n_j\right)^2}{n_j-1}}

t\_{ij} and df\_{ij} are those of a Welch t test of the two groups. Only
the p value differs, because it comes from q\_{k,df\_{ij}} rather than
from the t distribution.

## When to use it and assumptions

### Which test

- **Tukey-Kramer** after Fisher’s F test
  (`compute_one_way_test(var.equal = TRUE)`), when the group variances
  are similar. With groups of different sizes it is slightly
  conservative.
- **Games-Howell** after Welch’s F test
  (`compute_one_way_test(var.equal = FALSE)`), when the variances
  differ, and especially when the groups also differ in size. It can be
  somewhat liberal when the groups are very small.

When in doubt, Games-Howell is the safer choice: with equal variances
the two tests give similar results, and with unequal variances Tukey’s
error rate can be far from 5% ([simulation below](#unequal-variances)).

Tukey’s procedure controls the family-wise error rate on its own, so it
does not need a significant ANOVA first. In practice it is usually
reported after one.

Use a different procedure when:

- **Only some comparisons are of interest**, such as each treatment
  against one control. Dunnett’s test, or a Bonferroni or Holm
  adjustment for just those comparisons, has more power.
- **The outcome is ordinal or clearly not normal with small groups.**
  Use the Kruskal-Wallis test (`compute_kruskal_wallis_test`) followed
  by Dunn’s test.
- **The same participants are measured more than once.** Use paired
  comparisons after a repeated measures ANOVA, or Wilcoxon signed-rank
  tests after the Friedman test (`compute_friedman_test`).

### Assumptions

1.  **Independent observations.** Each observation belongs to one group
    only and does not depend on any other observation.
2.  **Normally distributed outcome within each group**, or groups large
    enough for the means to be close to normal.
3.  **Equal variances (Tukey-Kramer only).** Games-Howell does not make
    this assumption.

## Data

`df_blood_pressure` records the blood pressure of 120 patients in three
age groups of 40, with similar variances. `chickwts` records the weight
of 71 chicks fed six different feeds, with group sizes from 10 to 14 and
different variances, giving 15 pairs.

``` r

data.frame(n = tapply(df_blood_pressure$bp_before, df_blood_pressure$agegrp, length),
           mean = tapply(df_blood_pressure$bp_before, df_blood_pressure$agegrp, mean),
           sd = tapply(df_blood_pressure$bp_before, df_blood_pressure$agegrp, sd))
```

    ##        n    mean        sd
    ## 30-45 40 151.675  9.258087
    ## 46-59 40 155.100 11.459628
    ## 60+   40 162.575 10.727122

``` r

data.frame(n = tapply(chickwts$weight, chickwts$feed, length),
           mean = tapply(chickwts$weight, chickwts$feed, mean),
           sd = tapply(chickwts$weight, chickwts$feed, sd))
```

    ##            n     mean       sd
    ## casein    12 323.5833 64.43384
    ## horsebean 10 160.2000 38.62584
    ## linseed   12 218.7500 52.23570
    ## meatmeal  11 276.9091 64.90062
    ## soybean   14 246.4286 54.12907
    ## sunflower 12 328.9167 48.83638

## compute_posthoc

``` r

result <- compute_posthoc(y = df_blood_pressure$bp_before, x = df_blood_pressure$agegrp)
result$output
```

    ## $tukey
    ##                    t  df            p
    ## 30-45:46-59 1.455786 117 3.160217e-01
    ## 30-45:60+   4.633013 117 2.794141e-05
    ## 46-59:60+   3.177227 117 5.364605e-03
    ## 
    ## $games.howell
    ##                    t       df            p
    ## 30-45:46-59 1.470366 74.70085 3.109171e-01
    ## 30-45:60+   4.865110 76.36720 1.779247e-05
    ## 46-59:60+   3.011799 77.66212 9.703539e-03

The function returns a list. `input` holds the `x` and `y` supplied, and
`output` holds two matrices, `tukey` and `games.howell`, each with one
row per pair of groups, named `group1:group2` in the order of the factor
levels:

| Column | Tukey-Kramer | Games-Howell |
|----|----|----|
| `t` | \lvert\bar{y}\_i-\bar{y}\_j\rvert/\sqrt{MS\_{\text{error}}(1/n_i+1/n_j)} | \lvert\bar{y}\_i-\bar{y}\_j\rvert/\sqrt{s_i^2/n_i+s_j^2/n_j} |
| `df` | N-k | df\_{ij}, Welch-Satterthwaite |
| `p` | P(q\_{k,N-k}\ge\sqrt{2}\\t) | P(q\_{k,df\_{ij}}\ge\sqrt{2}\\t) |

`t` is an absolute value, so the direction of a difference comes from
the group means. The function does not return the mean differences or
their confidence intervals;
[`stats::TukeyHSD`](https://rdrr.io/r/stats/TukeyHSD.html) gives them
for the Tukey-Kramer test:

``` r

stats::TukeyHSD(stats::aov(bp_before ~ agegrp, data = df_blood_pressure))
```

    ##   Tukey multiple comparisons of means
    ##     95% family-wise confidence level
    ## 
    ## Fit: stats::aov(formula = bp_before ~ agegrp, data = df_blood_pressure)
    ## 
    ## $agegrp
    ##               diff       lwr       upr     p adj
    ## 46-59-30-45  3.425 -2.160056  9.010056 0.3160217
    ## 60+-30-45   10.900  5.314944 16.485056 0.0000279
    ## 60+-46-59    7.475  1.889944 13.060056 0.0053646

With six groups and unequal variances, the two tests disagree more.
Games-Howell gives larger p values for every pair that includes casein
or meatmeal, the two feeds with the largest standard deviations, because
their own variances are larger than the pooled one. At the 0.05 level
both tests find the same 8 pairs significant here:

``` r

chick <- compute_posthoc(y = chickwts$weight, x = chickwts$feed)$output
data.frame(t_tukey = chick$tukey[, "t"], p_tukey = chick$tukey[, "p"],
           t_games_howell = chick$games.howell[, "t"], df_games_howell = chick$games.howell[, "df"],
           p_games_howell = chick$games.howell[, "p"])
```

    ##                       t_tukey      p_tukey t_games_howell df_games_howell p_games_howell
    ## casein:horsebean    6.9567776 3.070197e-08      7.3422577        18.35975   9.435900e-06
    ## casein:linseed      4.6816194 2.100151e-04      4.3781104        21.09735   3.101580e-03
    ## casein:meatmeal     2.0385502 3.324584e-01      1.7288013        20.79857   5.292701e-01
    ## casein:soybean      3.5756235 8.365309e-03      3.2742727        21.63451   3.604278e-02
    ## casein:sunflower    0.2381746 9.998902e-01      0.2285123        20.50231   9.999000e-01
    ## horsebean:linseed   2.4930286 1.413329e-01      3.0171746        19.76872   6.493843e-02
    ## horsebean:meatmeal  4.8698150 1.062092e-04      5.0594439        16.52352   1.237409e-03
    ## horsebean:soybean   3.7969132 4.216654e-03      4.5542814        21.99541   1.901477e-03
    ## horsebean:sunflower 7.1838681 1.219887e-08      9.0448784        19.96372   2.307160e-07
    ## linseed:meatmeal    2.5401639 1.276965e-01      2.3542177        19.23610   2.209307e-01
    ## linseed:soybean     1.2827225 7.932853e-01      1.3245561        23.62952   7.688997e-01
    ## linseed:sunflower   4.9197940 8.843233e-05      5.3367779        21.90113   3.042414e-04
    ## meatmeal:soybean    1.3792208 7.391356e-01      1.2525301        19.44908   8.059985e-01
    ## meatmeal:sunflower  2.2714895 2.206962e-01      2.1564009        18.53531   3.030031e-01
    ## soybean:sunflower   3.8227890 3.884521e-03      4.0836094        23.92031   5.088115e-03

## Step by step

Every quantity from the formulas above, computed by hand:

``` r

y <- df_blood_pressure$bp_before
x <- factor(df_blood_pressure$agegrp)
k <- nlevels(x)
n_j <- tapply(y, x, length)
mean_j <- tapply(y, x, mean)
var_j <- tapply(y, x, var)
N <- sum(n_j)
ms_error <- sum((n_j - 1) * var_j) / (N - k)
pairs <- utils::combn(k, 2)
pair_names <- utils::combn(levels(x), 2, paste, collapse = ":")
```

Tukey-Kramer:

``` r

t_tukey <- apply(pairs, 2, function(p) abs(diff(mean_j[p])) / sqrt(ms_error * sum(1 / n_j[p])))
tukey <- cbind(t = t_tukey,
               df = N - k,
               p = ptukey(sqrt(2) * t_tukey, nmeans = k, df = N - k, lower.tail = FALSE))
rownames(tukey) <- pair_names
tukey
```

    ##                    t  df            p
    ## 30-45:46-59 1.455786 117 3.160217e-01
    ## 30-45:60+   4.633013 117 2.794141e-05
    ## 46-59:60+   3.177227 117 5.364605e-03

``` r

all.equal(tukey, result$output$tukey)
```

    ## [1] TRUE

Games-Howell:

``` r

se2 <- var_j / n_j
t_gh <- apply(pairs, 2, function(p) abs(diff(mean_j[p])) / sqrt(sum(se2[p])))
df_gh <- apply(pairs, 2, function(p) sum(se2[p])^2 / sum(se2[p]^2 / (n_j[p] - 1)))
games_howell <- cbind(t = t_gh,
                      df = df_gh,
                      p = ptukey(sqrt(2) * t_gh, nmeans = k, df = df_gh, lower.tail = FALSE))
rownames(games_howell) <- pair_names
games_howell
```

    ##                    t       df            p
    ## 30-45:46-59 1.470366 74.70085 3.109171e-01
    ## 30-45:60+   4.865110 76.36720 1.779247e-05
    ## 46-59:60+   3.011799 77.66212 9.703539e-03

``` r

all.equal(games_howell, result$output$games.howell)
```

    ## [1] TRUE

## Checks against other packages

### stats, emmeans and rstatix

[`stats::TukeyHSD`](https://rdrr.io/r/stats/TukeyHSD.html), `emmeans`
with `adjust = "tukey"` and
[`rstatix::tukey_hsd`](https://rpkgs.datanovia.com/rstatix/reference/tukey_hsd.html)
give the Tukey-Kramer p values, and `emmeans` also gives the t
statistics and degrees of freedom.
[`rstatix::games_howell_test`](https://rpkgs.datanovia.com/rstatix/reference/games_howell_test.html)
gives the Games-Howell p values:

``` r

model <- stats::aov(bp_before ~ agegrp, data = df_blood_pressure)
stats::TukeyHSD(model)
```

    ##   Tukey multiple comparisons of means
    ##     95% family-wise confidence level
    ## 
    ## Fit: stats::aov(formula = bp_before ~ agegrp, data = df_blood_pressure)
    ## 
    ## $agegrp
    ##               diff       lwr       upr     p adj
    ## 46-59-30-45  3.425 -2.160056  9.010056 0.3160217
    ## 60+-30-45   10.900  5.314944 16.485056 0.0000279
    ## 60+-46-59    7.475  1.889944 13.060056 0.0053646

``` r

summary(graphics::pairs(emmeans::emmeans(model, ~agegrp), adjust = "tukey"))
```

    ##  contrast          estimate   SE  df t.ratio p.value
    ##  (30-45) - (46-59)    -3.42 2.35 117  -1.456  0.3160
    ##  (30-45) - (60+)     -10.90 2.35 117  -4.633 <0.0001
    ##  (46-59) - (60+)      -7.47 2.35 117  -3.177  0.0054
    ## 
    ## P value adjustment: tukey method for comparing a family of 3 estimates

``` r

rstatix::tukey_hsd(df_blood_pressure, bp_before ~ agegrp)
```

    ## # A tibble: 3 × 9
    ##   term   group1 group2 null.value estimate conf.low conf.high     p.adj p.adj.signif
    ## * <chr>  <chr>  <chr>       <dbl>    <dbl>    <dbl>     <dbl>     <dbl> <chr>       
    ## 1 agegrp 59     46              0     3.43    -2.16      9.01 0.316     ns          
    ## 2 agegrp 30     60+             0    10.9      5.31     16.5  0.0000279 ****        
    ## 3 agegrp 46     60+             0     7.47     1.89     13.1  0.00536   **

``` r

rstatix::games_howell_test(df_blood_pressure, bp_before ~ agegrp)
```

    ## # A tibble: 3 × 8
    ##   .y.       group1 group2 estimate conf.low conf.high     p.adj p.adj.signif
    ## * <chr>     <chr>  <chr>     <dbl>    <dbl>     <dbl>     <dbl> <chr>       
    ## 1 bp_before 30-45  46-59      3.42    -2.15      9.00 0.311     ns          
    ## 2 bp_before 30-45  60+       10.9      5.54     16.3  0.0000178 ****        
    ## 3 bp_before 46-59  60+        7.47     1.54     13.4  0.00970   **

The Games-Howell t statistic and degrees of freedom of each pair are
those of a Welch t test of the two groups:

``` r

t.test(bp_before ~ agegrp, data = df_blood_pressure[df_blood_pressure$agegrp %in% c("30-45", "60+"), ], var.equal = FALSE)
```

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  bp_before by agegrp
    ## t = -4.8651, df = 76.367, p-value = 6.006e-06
    ## alternative hypothesis: true difference in means between group 30-45 and group 60+ is not equal to 0
    ## 95 percent confidence interval:
    ##  -15.361881  -6.438119
    ## sample estimates:
    ## mean in group 30-45   mean in group 60+ 
    ##             151.675             162.575

``` r

result$output$games.howell["30-45:60+", ]
```

    ##            t           df            p 
    ## 4.865110e+00 7.636720e+01 1.779247e-05

### A test function

`check_posthoc` puts each rwf value next to the value from the other
packages and returns the differences, one row per pair. All the packages
list the pairs in the same order as rwf.

``` r

check_posthoc <- function(y, x) {
  x <- factor(x)
  rwf <- compute_posthoc(y = y, x = x)$output
  pairs <- utils::combn(levels(x), 2)
  model <- stats::aov(y ~ x)
  tukey_hsd <- stats::TukeyHSD(model)$x
  emmeans_tukey <- as.data.frame(summary(graphics::pairs(emmeans::emmeans(model, ~x), adjust = "tukey")))
  df <- data.frame(y = y, x = x)
  rstatix_tukey <- as.data.frame(rstatix::tukey_hsd(df, y ~ x))
  rstatix_games_howell <- as.data.frame(rstatix::games_howell_test(df, y ~ x))
  welch <- apply(pairs, 2, function(p) {
    welch_t <- stats::t.test(y[x == p[1]], y[x == p[2]], var.equal = FALSE)
    c(abs(unname(welch_t$statistic)), unname(welch_t$parameter))
  })
  data.frame(pair = rownames(rwf$tukey),
             tukey_t_emmeans = rwf$tukey[, "t"] - abs(emmeans_tukey$t.ratio),
             tukey_df_emmeans = rwf$tukey[, "df"] - emmeans_tukey$df,
             tukey_p_TukeyHSD = rwf$tukey[, "p"] - tukey_hsd[, "p adj"],
             tukey_p_emmeans = rwf$tukey[, "p"] - emmeans_tukey$p.value,
             tukey_p_rstatix = rwf$tukey[, "p"] - rstatix_tukey$p.adj,
             games_howell_t_welch = rwf$games.howell[, "t"] - welch[1, ],
             games_howell_df_welch = rwf$games.howell[, "df"] - welch[2, ],
             games_howell_p_rstatix = rwf$games.howell[, "p"] - rstatix_games_howell$p.adj,
             row.names = NULL)
}
check_posthoc(y = df_blood_pressure$bp_before, x = df_blood_pressure$agegrp)
```

    ##          pair tukey_t_emmeans tukey_df_emmeans tukey_p_TukeyHSD tukey_p_emmeans tukey_p_rstatix games_howell_t_welch games_howell_df_welch games_howell_p_rstatix
    ## 1 30-45:46-59   -1.509903e-14                0     5.440093e-15    7.438494e-15    5.440093e-15         0.000000e+00          1.421085e-14                      0
    ## 2   30-45:60+   -1.776357e-14                0     0.000000e+00    0.000000e+00    0.000000e+00         0.000000e+00         -4.263256e-14                      0
    ## 3   46-59:60+   -1.332268e-15                0     0.000000e+00    2.220446e-16    0.000000e+00         8.881784e-16         -5.684342e-14                      0

The same check on seven datasets with different numbers of groups, equal
and unequal group sizes, and equal and unequal variances.
`max_abs_difference` is the largest absolute difference across all the
comparisons and pairs for that dataset:

``` r

datasets <- list(
  list(name = "bp_before ~ agegrp", y = df_blood_pressure$bp_before, x = df_blood_pressure$agegrp),
  list(name = "bp_after ~ agegrp", y = df_blood_pressure$bp_after, x = df_blood_pressure$agegrp),
  list(name = "weight ~ feed", y = chickwts$weight, x = chickwts$feed),
  list(name = "count ~ spray", y = InsectSprays$count, x = InsectSprays$spray),
  list(name = "weight ~ group", y = PlantGrowth$weight, x = PlantGrowth$group),
  list(name = "Sepal.Length ~ Species", y = iris$Sepal.Length, x = iris$Species),
  list(name = "qsec ~ cyl", y = mtcars$qsec, x = mtcars$cyl)
)
do.call(rbind, lapply(datasets, function(d) {
  check <- check_posthoc(y = d$y, x = d$x)
  data.frame(formula = d$name,
             N = length(d$y),
             k = length(unique(d$x)),
             pairs = nrow(check),
             max_abs_difference = max(abs(as.matrix(check[, -1]))))
}))
```

    ##                  formula   N k pairs max_abs_difference
    ## 1     bp_before ~ agegrp 120 3     3       5.684342e-14
    ## 2      bp_after ~ agegrp 120 3     3       2.842171e-14
    ## 3          weight ~ feed  71 6    15       7.105427e-15
    ## 4          count ~ spray  72 6    15       1.065814e-14
    ## 5         weight ~ group  30 3     3       1.065814e-14
    ## 6 Sepal.Length ~ Species 150 3     3       3.552714e-15
    ## 7             qsec ~ cyl  32 3     3       9.769963e-15

## Family-wise error rate

Five groups of 10 come from the **same** population, so every
significant pair is a false positive. The table shows how often at least
one of the 10 pairs is significant at 0.05 with unadjusted t tests
([`stats::pairwise.t.test`](https://rdrr.io/r/stats/pairwise.t.test.html)
with a pooled standard deviation and `p.adjust.method = "none"`),
Tukey-Kramer and Games-Howell:

``` r

set.seed(1)
any_significant <- t(replicate(2000, {
  sim <- data.frame(group = rep(letters[1:5], each = 10), score = rnorm(50))
  unadjusted <- stats::pairwise.t.test(sim$score, sim$group, p.adjust.method = "none")$p.value
  posthoc <- compute_posthoc(y = sim$score, x = sim$group)$output
  c(unadjusted = any(unadjusted < 0.05, na.rm = TRUE),
    tukey = any(posthoc$tukey[, "p"] < 0.05),
    games_howell = any(posthoc$games.howell[, "p"] < 0.05))
}))
colMeans(any_significant)
```

    ##   unadjusted        tukey games_howell 
    ##       0.2775       0.0445       0.0530

Unadjusted t tests find a “significant” difference in about a quarter of
the studies where none exists. Both post hoc tests stay close to 5%.

## Unequal variances

Three groups have the same population mean, the smallest group has the
largest standard deviation, and the largest group the smallest:

``` r

set.seed(1)
any_significant <- t(replicate(2000, {
  sim <- data.frame(group = rep(c("a", "b", "c"), times = c(10, 20, 40)),
                    score = rnorm(70, mean = 0, sd = rep(c(4, 2, 1), times = c(10, 20, 40))))
  posthoc <- compute_posthoc(y = sim$score, x = sim$group)$output
  c(tukey = any(posthoc$tukey[, "p"] < 0.05),
    games_howell = any(posthoc$games.howell[, "p"] < 0.05))
}))
colMeans(any_significant)
```

    ##        tukey games_howell 
    ##       0.2525       0.0470

Tukey-Kramer pools the variances, so it underestimates the standard
error of the pairs that involve the small, variable group and rejects
far more often than 5%. Games-Howell stays close to 5%.

## Missing values

`compute_posthoc` does not remove missing values: a missing value in `y`
makes every result `NA`. Remove incomplete cases before the call, as
`report_oneway` does:

``` r

y_missing <- df_blood_pressure$bp_before
y_missing[1] <- NA
compute_posthoc(y = y_missing, x = df_blood_pressure$agegrp)$output$tukey
```

    ##              t  df  p
    ## 30-45:46-59 NA 117 NA
    ## 30-45:60+   NA 117 NA
    ## 46-59:60+   NA 117 NA

``` r

complete <- stats::complete.cases(y_missing, df_blood_pressure$agegrp)
compute_posthoc(y = y_missing[complete], x = df_blood_pressure$agegrp[complete])$output
```

    ## $tukey
    ##                    t  df            p
    ## 30-45:46-59 1.350836 116 3.702077e-01
    ## 30-45:60+   4.503777 116 4.735527e-05
    ## 46-59:60+   3.173088 116 5.444254e-03
    ## 
    ## $games.howell
    ##                    t       df            p
    ## 30-45:46-59 1.367247 74.48389 3.632124e-01
    ## 30-45:60+   4.737272 75.91500 2.921321e-05
    ## 46-59:60+   3.011799 77.66212 9.703539e-03

## References

Games, P. A., & Howell, J. F. (1976). Pairwise multiple comparison
procedures with unequal n’s and/or variances: A Monte Carlo study.
*Journal of Educational Statistics, 1*(2), 113–125.
<https://doi.org/10.3102/10769986001002113>

Kramer, C. Y. (1956). Extension of multiple range tests to group means
with unequal numbers of replications. *Biometrics, 12*(3), 307–310.
<https://doi.org/10.2307/3001469>

Peters, G.-J. Y. *userfriendlyscience: Quantitative analysis made
accessible* (R package version 0.7.2).
<https://github.com/Matherion/userfriendlyscience>

Tukey, J. W. (1953). *The problem of multiple comparisons*. Unpublished
manuscript, Princeton University.
