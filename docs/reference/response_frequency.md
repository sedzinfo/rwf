# Response frequency table for ordinal or Likert-scale variables

Tabulates how often each response category was chosen for one or more
ordinal variables (e.g. Likert scale items). For each variable the
function returns the count, proportion, or percentage of respondents who
selected each response option, along with the number of missing or
out-of-range responses. The function is a guard against accidental use
on continuous variables: if the number of unique values exceeds `max`
the function returns `NULL`.

## Usage

``` r
response_frequency(
  df,
  max = 10,
  uniqueitems = NULL,
  type = "percent",
  file = NULL
)
```

## Arguments

- df:

  A data frame whose columns are the ordinal variables to tabulate.

- max:

  Integer. Maximum number of unique response options allowed before the
  function returns `NULL`. Use this to prevent accidentally tabulating
  continuous variables. Default is `10`.

- uniqueitems:

  Vector of all valid response values (e.g. `1:5` for a 5-point Likert
  scale). When `NULL` (default) the unique values observed in `df` are
  used.

- type:

  Character string controlling the metric returned. One of `"frequency"`
  (raw counts), `"proportion"` (counts divided by valid responses),
  `"percent"` (proportion multiplied by 100, default), or `"all"` (all
  three metrics stacked row-wise).

- file:

  Character string naming the output Excel file (without extension).
  When `NULL` (default) no file is written.

## Value

A data frame with one row per variable (three rows per variable when
`type = "all"`) containing the following columns:

- type:

  `"Frequency"`, `"Proportion"`, or `"Percent"`.

- variable:

  Name of the column from `df`.

- (response columns):

  One column per value in `uniqueitems`, named by the response value,
  containing the frequency, proportion, or percent of respondents who
  chose that category.

- miss:

  Observations with values outside `uniqueitems`. For proportions this
  is the missing rate; for percent it is the missing percentage.

- responses:

  Total number of valid (non-missing) responses.

Returns `NULL` if the number of unique values exceeds `max`.

## Examples

``` r
df_ocean_N<-df_ocean[,grep("N",names(df_ocean))]
response_frequency(df_ocean_N)
#>       type variable        0      1     2     3     4     5 miss responses
#> 1  Percent       N1 0.005071 11.446 19.68 21.93 25.10 21.85    0     19719
#> 2  Percent       N2 0.005071  8.144 20.07 27.69 28.33 15.75    0     19719
#> 3  Percent       N3 0.005071  4.366 10.61 15.87 34.67 34.48    0     19719
#> 4  Percent       N4 0.005071 17.450 27.29 27.43 17.81 10.02    0     19719
#> 5  Percent       N5 0.005071 14.996 25.19 22.76 23.72 13.33    0     19719
#> 6  Percent       N6 0.005071 16.086 23.85 22.03 21.99 16.04    0     19719
#> 7  Percent       N7 0.005071 12.369 22.22 21.93 24.79 18.69    0     19719
#> 8  Percent       N8 0.005071 21.654 24.06 20.49 19.86 13.93    0     19719
#> 9  Percent       N9 0.005071 13.104 21.67 21.24 26.53 17.45    0     19719
#> 10 Percent      N10 0.005071 19.367 24.56 22.58 20.29 13.20    0     19719
response_frequency(df_ocean_N,
                   uniqueitems = 1:5)
#>       type variable      1     2     3     4     5     miss responses
#> 1  Percent       N1 11.446 19.68 21.93 25.10 21.85 0.005071     19718
#> 2  Percent       N2  8.145 20.07 27.70 28.33 15.75 0.005071     19718
#> 3  Percent       N3  4.367 10.61 15.87 34.67 34.48 0.005071     19718
#> 4  Percent       N4 17.451 27.29 27.43 17.81 10.02 0.005071     19718
#> 5  Percent       N5 14.996 25.20 22.76 23.72 13.33 0.005071     19718
#> 6  Percent       N6 16.087 23.85 22.04 21.99 16.04 0.005071     19718
#> 7  Percent       N7 12.369 22.22 21.93 24.79 18.69 0.005071     19718
#> 8  Percent       N8 21.655 24.06 20.49 19.86 13.93 0.005071     19718
#> 9  Percent       N9 13.105 21.68 21.24 26.53 17.45 0.005071     19718
#> 10 Percent      N10 19.368 24.56 22.58 20.29 13.20 0.005071     19718
response_frequency(df_ocean_N,
                   uniqueitems = 1:5,
                   type = "proportion")
#>          type variable       1      2      3      4      5       miss responses
#> 1  Proportion       N1 0.11446 0.1968 0.2193 0.2510 0.2185 0.00005071     19718
#> 2  Proportion       N2 0.08145 0.2007 0.2770 0.2833 0.1575 0.00005071     19718
#> 3  Proportion       N3 0.04367 0.1061 0.1587 0.3467 0.3448 0.00005071     19718
#> 4  Proportion       N4 0.17451 0.2729 0.2743 0.1781 0.1002 0.00005071     19718
#> 5  Proportion       N5 0.14996 0.2520 0.2276 0.2372 0.1333 0.00005071     19718
#> 6  Proportion       N6 0.16087 0.2385 0.2204 0.2199 0.1604 0.00005071     19718
#> 7  Proportion       N7 0.12369 0.2222 0.2193 0.2479 0.1869 0.00005071     19718
#> 8  Proportion       N8 0.21655 0.2406 0.2049 0.1986 0.1393 0.00005071     19718
#> 9  Proportion       N9 0.13105 0.2168 0.2124 0.2653 0.1745 0.00005071     19718
#> 10 Proportion      N10 0.19368 0.2456 0.2258 0.2029 0.1320 0.00005071     19718
response_frequency(df_ocean_N,
                   uniqueitems = 1:5,
                   type = "percent")
#>       type variable      1     2     3     4     5     miss responses
#> 1  Percent       N1 11.446 19.68 21.93 25.10 21.85 0.005071     19718
#> 2  Percent       N2  8.145 20.07 27.70 28.33 15.75 0.005071     19718
#> 3  Percent       N3  4.367 10.61 15.87 34.67 34.48 0.005071     19718
#> 4  Percent       N4 17.451 27.29 27.43 17.81 10.02 0.005071     19718
#> 5  Percent       N5 14.996 25.20 22.76 23.72 13.33 0.005071     19718
#> 6  Percent       N6 16.087 23.85 22.04 21.99 16.04 0.005071     19718
#> 7  Percent       N7 12.369 22.22 21.93 24.79 18.69 0.005071     19718
#> 8  Percent       N8 21.655 24.06 20.49 19.86 13.93 0.005071     19718
#> 9  Percent       N9 13.105 21.68 21.24 26.53 17.45 0.005071     19718
#> 10 Percent      N10 19.368 24.56 22.58 20.29 13.20 0.005071     19718
response_frequency(df_ocean_N,
                   uniqueitems = 1:5,
                   type = "all")
#>          type variable          1         2         3         4         5       miss responses
#> 1   Frequency       N1 2257.00000 3880.0000 4324.0000 4949.0000 4308.0000 1.00000000     19718
#> 2   Frequency       N2 1606.00000 3958.0000 5461.0000 5587.0000 3106.0000 1.00000000     19718
#> 3   Frequency       N3  861.00000 2092.0000 3130.0000 6836.0000 6799.0000 1.00000000     19718
#> 4   Frequency       N4 3441.00000 5382.0000 5409.0000 3511.0000 1975.0000 1.00000000     19718
#> 5   Frequency       N5 2957.00000 4968.0000 4488.0000 4677.0000 2628.0000 1.00000000     19718
#> 6   Frequency       N6 3172.00000 4702.0000 4345.0000 4336.0000 3163.0000 1.00000000     19718
#> 7   Frequency       N7 2439.00000 4381.0000 4325.0000 4888.0000 3685.0000 1.00000000     19718
#> 8   Frequency       N8 4270.00000 4745.0000 4041.0000 3916.0000 2746.0000 1.00000000     19718
#> 9   Frequency       N9 2584.00000 4274.0000 4188.0000 5232.0000 3440.0000 1.00000000     19718
#> 10  Frequency      N10 3819.00000 4843.0000 4453.0000 4000.0000 2603.0000 1.00000000     19718
#> 11 Proportion       N1    0.11446    0.1968    0.2193    0.2510    0.2185 0.00005071     19718
#> 12 Proportion       N2    0.08145    0.2007    0.2770    0.2833    0.1575 0.00005071     19718
#> 13 Proportion       N3    0.04367    0.1061    0.1587    0.3467    0.3448 0.00005071     19718
#> 14 Proportion       N4    0.17451    0.2729    0.2743    0.1781    0.1002 0.00005071     19718
#> 15 Proportion       N5    0.14996    0.2520    0.2276    0.2372    0.1333 0.00005071     19718
#> 16 Proportion       N6    0.16087    0.2385    0.2204    0.2199    0.1604 0.00005071     19718
#> 17 Proportion       N7    0.12369    0.2222    0.2193    0.2479    0.1869 0.00005071     19718
#> 18 Proportion       N8    0.21655    0.2406    0.2049    0.1986    0.1393 0.00005071     19718
#> 19 Proportion       N9    0.13105    0.2168    0.2124    0.2653    0.1745 0.00005071     19718
#> 20 Proportion      N10    0.19368    0.2456    0.2258    0.2029    0.1320 0.00005071     19718
#> 21    Percent       N1   11.44639   19.6775   21.9292   25.0989   21.8481 0.00507125     19718
#> 22    Percent       N2    8.14484   20.0730   27.6955   28.3345   15.7521 0.00507125     19718
#> 23    Percent       N3    4.36657   10.6096   15.8738   34.6688   34.4812 0.00507125     19718
#> 24    Percent       N4   17.45106   27.2949   27.4318   17.8061   10.0162 0.00507125     19718
#> 25    Percent       N5   14.99645   25.1953   22.7609   23.7194   13.3279 0.00507125     19718
#> 26    Percent       N6   16.08682   23.8462   22.0357   21.9901   16.0412 0.00507125     19718
#> 27    Percent       N7   12.36941   22.2183   21.9343   24.7895   18.6885 0.00507125     19718
#> 28    Percent       N8   21.65534   24.0643   20.4940   19.8600   13.9264 0.00507125     19718
#> 29    Percent       N9   13.10478   21.6756   21.2395   26.5341   17.4460 0.00507125     19718
#> 30    Percent      N10   19.36809   24.5613   22.5834   20.2860   13.2011 0.00507125     19718
response_frequency(df_ocean_N,
                   uniqueitems = 1:5,
                   type = "all",
  file = "descriptives")
#>          type variable          1         2         3         4         5       miss responses
#> 1   Frequency       N1 2257.00000 3880.0000 4324.0000 4949.0000 4308.0000 1.00000000     19718
#> 2   Frequency       N2 1606.00000 3958.0000 5461.0000 5587.0000 3106.0000 1.00000000     19718
#> 3   Frequency       N3  861.00000 2092.0000 3130.0000 6836.0000 6799.0000 1.00000000     19718
#> 4   Frequency       N4 3441.00000 5382.0000 5409.0000 3511.0000 1975.0000 1.00000000     19718
#> 5   Frequency       N5 2957.00000 4968.0000 4488.0000 4677.0000 2628.0000 1.00000000     19718
#> 6   Frequency       N6 3172.00000 4702.0000 4345.0000 4336.0000 3163.0000 1.00000000     19718
#> 7   Frequency       N7 2439.00000 4381.0000 4325.0000 4888.0000 3685.0000 1.00000000     19718
#> 8   Frequency       N8 4270.00000 4745.0000 4041.0000 3916.0000 2746.0000 1.00000000     19718
#> 9   Frequency       N9 2584.00000 4274.0000 4188.0000 5232.0000 3440.0000 1.00000000     19718
#> 10  Frequency      N10 3819.00000 4843.0000 4453.0000 4000.0000 2603.0000 1.00000000     19718
#> 11 Proportion       N1    0.11446    0.1968    0.2193    0.2510    0.2185 0.00005071     19718
#> 12 Proportion       N2    0.08145    0.2007    0.2770    0.2833    0.1575 0.00005071     19718
#> 13 Proportion       N3    0.04367    0.1061    0.1587    0.3467    0.3448 0.00005071     19718
#> 14 Proportion       N4    0.17451    0.2729    0.2743    0.1781    0.1002 0.00005071     19718
#> 15 Proportion       N5    0.14996    0.2520    0.2276    0.2372    0.1333 0.00005071     19718
#> 16 Proportion       N6    0.16087    0.2385    0.2204    0.2199    0.1604 0.00005071     19718
#> 17 Proportion       N7    0.12369    0.2222    0.2193    0.2479    0.1869 0.00005071     19718
#> 18 Proportion       N8    0.21655    0.2406    0.2049    0.1986    0.1393 0.00005071     19718
#> 19 Proportion       N9    0.13105    0.2168    0.2124    0.2653    0.1745 0.00005071     19718
#> 20 Proportion      N10    0.19368    0.2456    0.2258    0.2029    0.1320 0.00005071     19718
#> 21    Percent       N1   11.44639   19.6775   21.9292   25.0989   21.8481 0.00507125     19718
#> 22    Percent       N2    8.14484   20.0730   27.6955   28.3345   15.7521 0.00507125     19718
#> 23    Percent       N3    4.36657   10.6096   15.8738   34.6688   34.4812 0.00507125     19718
#> 24    Percent       N4   17.45106   27.2949   27.4318   17.8061   10.0162 0.00507125     19718
#> 25    Percent       N5   14.99645   25.1953   22.7609   23.7194   13.3279 0.00507125     19718
#> 26    Percent       N6   16.08682   23.8462   22.0357   21.9901   16.0412 0.00507125     19718
#> 27    Percent       N7   12.36941   22.2183   21.9343   24.7895   18.6885 0.00507125     19718
#> 28    Percent       N8   21.65534   24.0643   20.4940   19.8600   13.9264 0.00507125     19718
#> 29    Percent       N9   13.10478   21.6756   21.2395   26.5341   17.4460 0.00507125     19718
#> 30    Percent      N10   19.36809   24.5613   22.5834   20.2860   13.2011 0.00507125     19718
```
