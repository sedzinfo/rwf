# Tukey and Games-Howell Post Hoc Tests

Compares every pair of group means after a one-way ANOVA with two post
hoc tests:

- `tukey`: the Tukey-Kramer test, which pools the variances of all
  groups and assumes they are equal

- `games.howell`: the Games-Howell test, which uses the variances of the
  two groups being compared and does not assume equal variances

In simple terms, after an ANOVA shows that the group means differ, this
shows which pairs of groups differ, while keeping the chance of any
false positive across all the pairs at 5%.

## Usage

``` r
compute_posthoc(y, x)
```

## Source

Adapted from `posthocTGH()` in the `userfriendlyscience` package by
Gjalt-Jorn Peters (Open University of the Netherlands) and Jeff Baggett
(University of Wisconsin - La Crosse), licensed GPL (\>= 3),
<https://github.com/Matherion/userfriendlyscience>. `posthocTGH()` was
in turn based on `games_howell.R`, a script hosted on the course page of
Robert Cribbie (York University) at
`http://www.psych.yorku.ca/cribbie/6130/games_howell.R`, which is no
longer available.

## Arguments

- y:

  A numeric vector with the outcome.

- x:

  A vector with the group of each value of `y`, a factor or a vector
  that can be converted to one.

## Value

A list with:

- `input`: list with the `x` and `y` supplied

- `output`: list with two matrices, `tukey` and `games.howell`, each
  with one row per pair of groups (named `"group1:group2"` in the order
  of the factor levels) and the columns:

  - `t`: absolute t statistic of the pair

  - `df`: degrees of freedom

  - `p`: p-value, adjusted for all the pairwise comparisons

## Details

For groups \\i\\ and \\j\\ with means \\\bar{y}\\, variances \\s^2\\ and
sizes \\n\\, out of \\k\\ groups and \\N\\ observations:

Tukey-Kramer (Tukey, 1953; Kramer, 1956) uses the pooled error variance
\\MS\_{error}=\sum (n_j-1)s_j^2/(N-k)\\:
\$\$t\_{ij}=\frac{\|\bar{y}\_i-\bar{y}\_j\|}{\sqrt{MS\_{error}(1/n_i+1/n_j)}},\qquad
df=N-k\$\$

Games-Howell (Games & Howell, 1976) uses the two group variances and the
Welch-Satterthwaite degrees of freedom for each pair:
\$\$t\_{ij}=\frac{\|\bar{y}\_i-\bar{y}\_j\|}{\sqrt{s_i^2/n_i+s_j^2/n_j}},\qquad
df\_{ij}=\frac{(s_i^2/n_i+s_j^2/n_j)^2}{\frac{(s_i^2/n_i)^2}{n_i-1}+\frac{(s_j^2/n_j)^2}{n_j-1}}\$\$

In both tests the p-value comes from the studentized range distribution,
\\p=P(q\_{k,df}\ge\sqrt{2}\\t\_{ij})\\, which already accounts for the
number of groups. Do not adjust these p-values again.

Use Tukey after Fisher's F test
(`compute_one_way_test(var.equal = TRUE)`) and Games-Howell after
Welch's F test (`var.equal = FALSE`). Games-Howell is the safer choice
when the group variances or sizes differ.

`t` is an absolute value; the direction of a difference comes from the
group means. The p-values match
[`stats::TukeyHSD`](https://rdrr.io/r/stats/TukeyHSD.html) and
[`rstatix::games_howell_test`](https://rpkgs.datanovia.com/rstatix/reference/games_howell_test.html).

Missing values are not removed: a missing value in `y` makes every
result `NA`. Remove incomplete cases before calling the function, as
`report_oneway` does.

## References

Games, P. A., & Howell, J. F. (1976). Pairwise multiple comparison
procedures with unequal n's and/or variances: A Monte Carlo study.
Journal of Educational Statistics, 1(2), 113-125.
[doi:10.3102/10769986001002113](https://doi.org/10.3102/10769986001002113)

Kramer, C. Y. (1956). Extension of multiple range tests to group means
with unequal numbers of replications. Biometrics, 12(3), 307-310.
[doi:10.2307/3001469](https://doi.org/10.2307/3001469)

Peters, G.-J. Y. userfriendlyscience: Quantitative analysis made
accessible (R package version 0.7.2).
<https://github.com/Matherion/userfriendlyscience>

Tukey, J. W. (1953). The problem of multiple comparisons. Unpublished
manuscript, Princeton University.

## Examples

``` r
TukeyHSD(aov(bp_before ~ agegrp, data = df_blood_pressure))
#>   Tukey multiple comparisons of means
#>     95% family-wise confidence level
#> 
#> Fit: aov(formula = bp_before ~ agegrp, data = df_blood_pressure)
#> 
#> $agegrp
#>               diff       lwr       upr     p adj
#> 46-59-30-45  3.425 -2.160056  9.010056 0.3160217
#> 60+-30-45   10.900  5.314944 16.485056 0.0000279
#> 60+-46-59    7.475  1.889944 13.060056 0.0053646
#> 
rstatix::games_howell_test(df_blood_pressure, bp_before ~ agegrp)
#> # A tibble: 3 × 8
#>   .y.       group1 group2 estimate conf.low conf.high     p.adj p.adj.signif
#> * <chr>     <chr>  <chr>     <dbl>    <dbl>     <dbl>     <dbl> <chr>       
#> 1 bp_before 30-45  46-59      3.42    -2.15      9.00 0.311     ns          
#> 2 bp_before 30-45  60+       10.9      5.54     16.3  0.0000178 ****        
#> 3 bp_before 46-59  60+        7.47     1.54     13.4  0.00970   **          
compute_posthoc(y = df_blood_pressure$bp_before, x = df_blood_pressure$agegrp)
#> $input
#> $input$x
#>   [1] "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "46-59" "46-59" "46-59" "46-59"
#>  [25] "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"  
#>  [49] "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45"
#>  [73] "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59"
#>  [97] "46-59" "46-59" "46-59" "46-59" "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"  
#> 
#> $input$y
#>   [1] 143 163 153 153 146 150 148 153 153 158 149 173 165 145 143 152 141 176 143 162 149 156 151 159 164 154 152 142 162 155 175 184 167 148 170 159 149 140 185 160 157 158 162 160 180 155 172 157
#>  [49] 171 170 175 175 172 173 170 164 147 154 172 162 152 147 144 144 158 147 154 151 149 138 162 157 141 167 147 143 142 166 147 142 157 170 150 150 167 154 143 157 149 161 142 162 144 142 159 140
#>  [97] 144 142 145 145 168 142 147 148 162 170 173 151 155 163 183 159 148 151 165 152 161 165 149 185
#> 
#> 
#> $output
#> $output$tukey
#>                    t  df            p
#> 30-45:46-59 1.455786 117 3.160217e-01
#> 30-45:60+   4.633013 117 2.794141e-05
#> 46-59:60+   3.177227 117 5.364605e-03
#> 
#> $output$games.howell
#>                    t       df            p
#> 30-45:46-59 1.470366 74.70085 3.109171e-01
#> 30-45:60+   4.865110 76.36720 1.779247e-05
#> 46-59:60+   3.011799 77.66212 9.703539e-03
#> 
#> 
compute_posthoc(y = df_blood_pressure$bp_after, x = df_blood_pressure$agegrp)
#> $input
#> $input$x
#>   [1] "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "46-59" "46-59" "46-59" "46-59"
#>  [25] "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"  
#>  [49] "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45"
#>  [73] "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "30-45" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59" "46-59"
#>  [97] "46-59" "46-59" "46-59" "46-59" "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"   "60+"  
#> 
#> $input$y
#>   [1] 153 170 168 142 141 147 133 141 131 125 164 159 135 159 153 126 162 134 136 150 168 155 136 132 160 160 136 183 152 162 151 139 175 184 151 171 157 159 140 174 167 158 168 159 153 164 169 148
#>  [49] 185 163 146 160 175 163 185 146 176 147 161 164 149 142 146 138 131 145 134 135 131 135 133 135 168 144 147 151 149 147 149 135 127 150 138 147 157 146 148 136 146 132 145 132 157 140 137 154
#>  [97] 169 145 137 143 178 141 149 148 138 143 167 158 152 154 161 143 159 177 142 152 152 174 151 163
#> 
#> 
#> $output
#> $output$tukey
#>                    t  df            p
#> 30-45:46-59 2.228256 117 7.063057e-02
#> 30-45:60+   5.061078 117 4.664260e-06
#> 46-59:60+   2.832822 117 1.491311e-02
#> 
#> $output$games.howell
#>                    t       df            p
#> 30-45:46-59 2.174948 75.12034 8.213330e-02
#> 30-45:60+   5.418463 77.91789 1.933602e-06
#> 46-59:60+   2.728484 75.94801 2.131734e-02
#> 
#> 
```
