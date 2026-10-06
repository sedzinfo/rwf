# Check dataframe

Produces a column-level diagnostic summary of a dataframe, reporting
missing values, data types, range statistics, and optionally unique
values and factor levels. Returns a named list with a per-column table
and a whole-dataframe summary. Can optionally export results to an
`.xlsx` file.

## Usage

``` r
cdf(
  df,
  name_length = (getOption("width")/3),
  digits = 2,
  nuniques = 0,
  parralel = FALSE,
  file = NULL
)
```

## Arguments

- df:

  A `data.frame` to inspect. Accepts any column types: numeric, integer,
  character, factor, logical, `Date`, `POSIXct`.

- name_length:

  Integer. Maximum number of characters displayed for column names and
  MIN/MAX values in the printed output. Longer strings are truncated.
  Defaults to `getOption("width") / 3`.

- digits:

  Integer. Number of decimal places used when rounding MEAN, MEDIAN, and
  SD for numeric columns. Defaults to `2`.

- nuniques:

  Integer. If `> 0`, appends UNIQUES and LEVELS columns to the output.
  Columns with more distinct entries than `nuniques` are summarised as
  `"N Uniques"` / `"N Levels"`. Set to `0` to skip (faster). Defaults to
  `0`.

- parralel:

  Logical. If `TRUE`, uses `future.apply` with a `multisession` plan
  across all available cores. Recommended for wide dataframes (\> 100
  columns) or very large `n`. Defaults to `FALSE`.

- file:

  Character or `NULL`. If a string is provided, exports results to
  `<file>.xlsx` with two sheets: `variables` and `summary`. Any existing
  file with the same name is overwritten. Defaults to `NULL`.

## Value

A named `list` with two elements:

- `$summary`:

  A single-row `data.frame` with whole-dataframe counts: COLLUMNS, ROWS,
  TOTAL, EMPTY, null, NAN, na, INF, FIN, FACTOR.

- `$check`:

  A per-column `data.frame` with the following fields:

  NAMES

  : Column name (truncated to `name_length`).

  EMPTY

  : Count of `""` empty strings.

  null

  : Count of `NULL` values (always 0 for dataframe columns).

  na

  : Count of `NA` values.

  NOT_NA

  : Count of non-`NA` values.

  NAN

  : Count of `NaN` values.

  INF

  : Count of `Inf` and `-Inf` values.

  FIN

  : Count of finite values.

  RANGE

  : Number of distinct values.

  MEAN

  : Arithmetic mean, rounded to `digits`. `NA` for non-numeric columns.

  MEDIAN

  : Median, rounded to `digits`. `NA` for non-numeric columns.

  SD

  : Standard deviation, rounded to `digits`. `NA` for non-numeric
    columns.

  MIN

  : Minimum value or first label in sorted order.

  MAX

  : Maximum value or last label in sorted order.

  MODE

  : Storage mode as returned by
    [`mode()`](https://rdrr.io/r/base/mode.html).

  TYPE

  : Type as returned by
    [`typeof()`](https://rdrr.io/r/base/typeof.html).

  CLASS

  : Class as returned by [`class()`](https://rdrr.io/r/base/class.html).

  FACTOR

  : Logical; `TRUE` if the column is a factor.

## Note

MEAN, MEDIAN, and SD are `NA` for non-numeric columns. MIN and MAX for
non-double columns are derived from
[`sort()`](https://rdrr.io/r/base/sort.html) on character
representations — natural sort ordering is not guaranteed for mixed
alphanumeric strings.

## Examples

``` r
cdf(df = mtcars, parralel = TRUE)
#> $summary
#>   COLLUMNS ROWS TOTAL EMPTY null NAN na INF FIN FACTOR
#> 1       11   32   352     0    0   0  0   0 352      0
#> 
#> $check
#>    NAMES EMPTY null na NOT_NA NAN INF FIN RANGE   MEAN MEDIAN     SD   MIN   MAX    MODE   TYPE   CLASS FACTOR
#> 1    mpg     0    0  0     32   0   0  32    25  20.09   19.2   6.03  10.4  33.9 numeric double numeric  FALSE
#> 2    cyl     0    0  0     32   0   0  32     3   6.19      6   1.79     4     8 numeric double numeric  FALSE
#> 3   disp     0    0  0     32   0   0  32    27 230.72  196.3 123.94  71.1   472 numeric double numeric  FALSE
#> 4     hp     0    0  0     32   0   0  32    22 146.69    123  68.56    52   335 numeric double numeric  FALSE
#> 5   drat     0    0  0     32   0   0  32    22    3.6    3.7   0.53  2.76  4.93 numeric double numeric  FALSE
#> 6     wt     0    0  0     32   0   0  32    29   3.22   3.33   0.98 1.513 5.424 numeric double numeric  FALSE
#> 7   qsec     0    0  0     32   0   0  32    30  17.85  17.71   1.79  14.5  22.9 numeric double numeric  FALSE
#> 8     vs     0    0  0     32   0   0  32     2   0.44      0    0.5     0     1 numeric double numeric  FALSE
#> 9     am     0    0  0     32   0   0  32     2   0.41      0    0.5     0     1 numeric double numeric  FALSE
#> 10  gear     0    0  0     32   0   0  32     3   3.69      4   0.74     3     5 numeric double numeric  FALSE
#> 11  carb     0    0  0     32   0   0  32     6   2.81      2   1.62     1     8 numeric double numeric  FALSE
#> 
cdf(df = change_data_type(mtcars, "factor"), nuniques = 3)
#> $summary
#>   COLLUMNS ROWS TOTAL EMPTY null NAN na INF FIN FACTOR
#> 1       11   32   352     0    0   0  0   0 352     11
#> 
#> $check
#>    NAMES EMPTY null na NOT_NA NAN INF FIN RANGE MEAN MEDIAN SD   MIN   MAX    MODE    TYPE  CLASS FACTOR    UNIQUES    LEVELS
#> 1    mpg     0    0  0     32   0   0  32    25   NA     NA NA  10.4  33.9 numeric integer factor   TRUE 25 Uniques 25 Levels
#> 2    cyl     0    0  0     32   0   0  32     3   NA     NA NA     4     8 numeric integer factor   TRUE    4, 6, 8   4, 6, 8
#> 3   disp     0    0  0     32   0   0  32    27   NA     NA NA  71.1   472 numeric integer factor   TRUE 27 Uniques 27 Levels
#> 4     hp     0    0  0     32   0   0  32    22   NA     NA NA    52   335 numeric integer factor   TRUE 22 Uniques 22 Levels
#> 5   drat     0    0  0     32   0   0  32    22   NA     NA NA  2.76  4.93 numeric integer factor   TRUE 22 Uniques 22 Levels
#> 6     wt     0    0  0     32   0   0  32    29   NA     NA NA 1.513 5.424 numeric integer factor   TRUE 29 Uniques 29 Levels
#> 7   qsec     0    0  0     32   0   0  32    30   NA     NA NA  14.5  22.9 numeric integer factor   TRUE 30 Uniques 30 Levels
#> 8     vs     0    0  0     32   0   0  32     2   NA     NA NA     0     1 numeric integer factor   TRUE       0, 1      0, 1
#> 9     am     0    0  0     32   0   0  32     2   NA     NA NA     0     1 numeric integer factor   TRUE       0, 1      0, 1
#> 10  gear     0    0  0     32   0   0  32     3   NA     NA NA     3     5 numeric integer factor   TRUE    3, 4, 5   3, 4, 5
#> 11  carb     0    0  0     32   0   0  32     6   NA     NA NA     1     8 numeric integer factor   TRUE  6 Uniques  6 Levels
#> 
cdf(df = data.frame(t(mtcars)), file = "mtcars", nuniques = 10)
#> $summary
#>   COLLUMNS ROWS TOTAL EMPTY null NAN na INF FIN FACTOR
#> 1       32   11   352     0    0   0  0   0 352      0
#> 
#> $check
#>                  NAMES EMPTY null na NOT_NA NAN INF FIN RANGE  MEAN MEDIAN     SD MIN   MAX    MODE   TYPE   CLASS FACTOR                                        UNIQUES
#> 1            Mazda.RX4     0    0  0     11   0   0  11    10 29.91      4  53.54   0   160 numeric double numeric  FALSE     0, 1, 2.62, 3.9, 4, 6, 16.46, 21, 110, 160
#> 2        Mazda.RX4.Wag     0    0  0     11   0   0  11    10 29.98      4  53.51   0   160 numeric double numeric  FALSE    0, 1, 2.875, 3.9, 4, 6, 17.02, 21, 110, 160
#> 3           Datsun.710     0    0  0     11   0   0  11     8  23.6      4  38.87   1   108 numeric double numeric  FALSE         1, 2.32, 3.85, 4, 18.61, 22.8, 93, 108
#> 4       Hornet.4.Drive     0    0  0     11   0   0  11    10 38.74   3.21  79.41   0   258 numeric double numeric  FALSE 0, 1, 3, 3.08, 3.215, 6, 19.44, 21.4, 110, 258
#> 5    Hornet.Sportabout     0    0  0     11   0   0  11    10 53.66   3.44  113.7   0   360 numeric double numeric  FALSE  0, 2, 3, 3.15, 3.44, 8, 17.02, 18.7, 175, 360
#> 6              Valiant     0    0  0     11   0   0  11    10 35.05   3.46  69.96   0   225 numeric double numeric  FALSE  0, 1, 2.76, 3, 3.46, 6, 18.1, 20.22, 105, 225
#> 7           Duster.360     0    0  0     11   0   0  11    10 59.72      4 122.87   0   360 numeric double numeric  FALSE  0, 3, 3.21, 3.57, 4, 8, 14.3, 15.84, 245, 360
#> 8            Merc.240D     0    0  0     11   0   0  11    10 24.63      4  44.44   0 146.7 numeric double numeric  FALSE    0, 1, 2, 3.19, 3.69, 4, 20, 24.4, 62, 146.7
#> 9             Merc.230     0    0  0     11   0   0  11    10 27.23      4  46.69   0 140.8 numeric double numeric  FALSE  0, 1, 2, 3.15, 3.92, 4, 22.8, 22.9, 95, 140.8
#> 10            Merc.280     0    0  0     11   0   0  11    10 31.86      4  57.32   0 167.6 numeric double numeric  FALSE 0, 1, 3.44, 3.92, 4, 6, 18.3, 19.2, 123, 167.6
#> 11           Merc.280C     0    0  0     11   0   0  11    10 31.79      4  57.34   0 167.6 numeric double numeric  FALSE 0, 1, 3.44, 3.92, 4, 6, 17.8, 18.9, 123, 167.6
#> 12          Merc.450SE     0    0  0     11   0   0  11     9 46.43   4.07  92.43   0 275.8 numeric double numeric  FALSE    0, 3, 3.07, 4.07, 8, 16.4, 17.4, 180, 275.8
#> 13          Merc.450SL     0    0  0     11   0   0  11     9  46.5   3.73  92.41   0 275.8 numeric double numeric  FALSE    0, 3, 3.07, 3.73, 8, 17.3, 17.6, 180, 275.8
#> 14         Merc.450SLC     0    0  0     11   0   0  11     9 46.35   3.78  92.46   0 275.8 numeric double numeric  FALSE      0, 3, 3.07, 3.78, 8, 15.2, 18, 180, 275.8
#> 15  Cadillac.Fleetwood     0    0  0     11   0   0  11    10 66.23   5.25 147.35   0   472 numeric double numeric  FALSE  0, 2.93, 3, 4, 5.25, 8, 10.4, 17.98, 205, 472
#> 16 Lincoln.Continental     0    0  0     11   0   0  11     9 66.06   5.42 145.04   0   460 numeric double numeric  FALSE       0, 3, 4, 5.424, 8, 10.4, 17.82, 215, 460
#> 17   Chrysler.Imperial     0    0  0     11   0   0  11    10 65.97   5.34 141.16   0   440 numeric double numeric  FALSE 0, 3, 3.23, 4, 5.345, 8, 14.7, 17.42, 230, 440
#> 18            Fiat.128     0    0  0     11   0   0  11     8 19.44      4  28.07   1  78.7 numeric double numeric  FALSE         1, 2.2, 4, 4.08, 19.47, 32.4, 66, 78.7
#> 19         Honda.Civic     0    0  0     11   0   0  11     9 17.74      4  25.11   1  75.7 numeric double numeric  FALSE    1, 1.615, 2, 4, 4.93, 18.52, 30.4, 52, 75.7
#> 20      Toyota.Corolla     0    0  0     11   0   0  11     8 18.81      4  26.43   1  71.1 numeric double numeric  FALSE        1, 1.835, 4, 4.22, 19.9, 33.9, 65, 71.1
#> 21       Toyota.Corona     0    0  0     11   0   0  11    10 24.89    3.7  42.34   0 120.1 numeric double numeric  FALSE 0, 1, 2.465, 3, 3.7, 4, 20.01, 21.5, 97, 120.1
#> 22    Dodge.Challenger     0    0  0     11   0   0  11    10 47.24   3.52  99.85   0   318 numeric double numeric  FALSE  0, 2, 2.76, 3, 3.52, 8, 15.5, 16.87, 150, 318
#> 23         AMC.Javelin     0    0  0     11   0   0  11    10 46.01   3.44  96.05   0   304 numeric double numeric  FALSE  0, 2, 3, 3.15, 3.435, 8, 15.2, 17.3, 150, 304
#> 24          Camaro.Z28     0    0  0     11   0   0  11    10 58.75      4 120.45   0   350 numeric double numeric  FALSE  0, 3, 3.73, 3.84, 4, 8, 13.3, 15.41, 245, 350
#> 25    Pontiac.Firebird     0    0  0     11   0   0  11    10 57.38   3.85 124.57   0   400 numeric double numeric  FALSE 0, 2, 3, 3.08, 3.845, 8, 17.05, 19.2, 175, 400
#> 26           Fiat.X1.9     0    0  0     11   0   0  11     8 18.93      4  27.95   1    79 numeric double numeric  FALSE          1, 1.935, 4, 4.08, 18.9, 27.3, 66, 79
#> 27       Porsche.914.2     0    0  0     11   0   0  11    11 24.78   4.43  41.26   0 120.3 numeric double numeric  FALSE                                     11 Uniques
#> 28        Lotus.Europa     0    0  0     11   0   0  11    10 24.88      4  40.34   1   113 numeric double numeric  FALSE 1, 1.513, 2, 3.77, 4, 5, 16.9, 30.4, 95.1, 113
#> 29      Ford.Pantera.L     0    0  0     11   0   0  11    11 60.97      5 123.53   0   351 numeric double numeric  FALSE                                     11 Uniques
#> 30        Ferrari.Dino     0    0  0     11   0   0  11    10 34.51      6  62.69   0   175 numeric double numeric  FALSE   0, 1, 2.77, 3.62, 5, 6, 15.5, 19.7, 145, 175
#> 31       Maserati.Bora     0    0  0     11   0   0  11    10 63.16      8 126.32   0   335 numeric double numeric  FALSE     0, 1, 3.54, 3.57, 5, 8, 14.6, 15, 301, 335
#> 32          Volvo.142E     0    0  0     11   0   0  11     9 26.26      4   44.5   1   121 numeric double numeric  FALSE      1, 2, 2.78, 4, 4.11, 18.6, 21.4, 109, 121
#> 
cdf(df = mtcars)
#> $summary
#>   COLLUMNS ROWS TOTAL EMPTY null NAN na INF FIN FACTOR
#> 1       11   32   352     0    0   0  0   0 352      0
#> 
#> $check
#>    NAMES EMPTY null na NOT_NA NAN INF FIN RANGE   MEAN MEDIAN     SD   MIN   MAX    MODE   TYPE   CLASS FACTOR
#> 1    mpg     0    0  0     32   0   0  32    25  20.09   19.2   6.03  10.4  33.9 numeric double numeric  FALSE
#> 2    cyl     0    0  0     32   0   0  32     3   6.19      6   1.79     4     8 numeric double numeric  FALSE
#> 3   disp     0    0  0     32   0   0  32    27 230.72  196.3 123.94  71.1   472 numeric double numeric  FALSE
#> 4     hp     0    0  0     32   0   0  32    22 146.69    123  68.56    52   335 numeric double numeric  FALSE
#> 5   drat     0    0  0     32   0   0  32    22    3.6    3.7   0.53  2.76  4.93 numeric double numeric  FALSE
#> 6     wt     0    0  0     32   0   0  32    29   3.22   3.33   0.98 1.513 5.424 numeric double numeric  FALSE
#> 7   qsec     0    0  0     32   0   0  32    30  17.85  17.71   1.79  14.5  22.9 numeric double numeric  FALSE
#> 8     vs     0    0  0     32   0   0  32     2   0.44      0    0.5     0     1 numeric double numeric  FALSE
#> 9     am     0    0  0     32   0   0  32     2   0.41      0    0.5     0     1 numeric double numeric  FALSE
#> 10  gear     0    0  0     32   0   0  32     3   3.69      4   0.74     3     5 numeric double numeric  FALSE
#> 11  carb     0    0  0     32   0   0  32     6   2.81      2   1.62     1     8 numeric double numeric  FALSE
#> 
cdf(df = generate_missing(mtcars))
#> $summary
#>   COLLUMNS ROWS TOTAL EMPTY null NAN na INF FIN FACTOR
#> 1       11   32   352     0    0   0 55   0 297      0
#> 
#> $check
#>    NAMES EMPTY null na NOT_NA NAN INF FIN RANGE   MEAN MEDIAN     SD   MIN   MAX    MODE   TYPE   CLASS FACTOR
#> 1    mpg     0    0  5     27   0   0  27    22  20.07   19.2   5.96  10.4  33.9 numeric double numeric  FALSE
#> 2    cyl     0    0  5     27   0   0  27     4   6.22      6   1.78     4     8 numeric double numeric  FALSE
#> 3   disp     0    0  5     27   0   0  27    23 225.38  167.6 117.06  71.1   460 numeric double numeric  FALSE
#> 4     hp     0    0  5     27   0   0  27    21 145.11    123  67.02    52   335 numeric double numeric  FALSE
#> 5   drat     0    0  5     27   0   0  27    20   3.64   3.73   0.54  2.76  4.93 numeric double numeric  FALSE
#> 6     wt     0    0  5     27   0   0  27    25   3.28   3.44   1.01 1.513 5.424 numeric double numeric  FALSE
#> 7   qsec     0    0  5     27   0   0  27    27  17.86  17.82   1.93  14.5  22.9 numeric double numeric  FALSE
#> 8     vs     0    0  5     27   0   0  27     3   0.44      0   0.51     0     1 numeric double numeric  FALSE
#> 9     am     0    0  5     27   0   0  27     3   0.41      0    0.5     0     1 numeric double numeric  FALSE
#> 10  gear     0    0  5     27   0   0  27     4   3.67      3   0.78     3     5 numeric double numeric  FALSE
#> 11  carb     0    0  5     27   0   0  27     7   2.85      2   1.68     1     8 numeric double numeric  FALSE
#> 
cdf(df = infert, nuniques = 10)
#> $summary
#>   COLLUMNS ROWS TOTAL EMPTY null NAN na INF  FIN FACTOR
#> 1        8  248  1984     0    0   0  0   0 1984      1
#> 
#> $check
#>            NAMES EMPTY null na NOT_NA NAN INF FIN RANGE  MEAN MEDIAN    SD    MIN     MAX    MODE    TYPE   CLASS FACTOR                  UNIQUES                   LEVELS
#> 1      education     0    0  0    248   0   0 248     3    NA     NA    NA 0-5yrs 12+ yrs numeric integer  factor   TRUE 0-5yrs, 12+ yrs, 6-11yrs 0-5yrs, 6-11yrs, 12+ yrs
#> 2            age     0    0  0    248   0   0 248    21  31.5     31  5.25     21      44 numeric  double numeric  FALSE               21 Uniques                         
#> 3         parity     0    0  0    248   0   0 248     6  2.09      2  1.25      1       6 numeric  double numeric  FALSE         1, 2, 3, 4, 5, 6                         
#> 4        induced     0    0  0    248   0   0 248     3  0.57      0  0.74      0       2 numeric  double numeric  FALSE                  0, 1, 2                         
#> 5           case     0    0  0    248   0   0 248     2  0.33      0  0.47      0       1 numeric  double numeric  FALSE                     0, 1                         
#> 6    spontaneous     0    0  0    248   0   0 248     3  0.58      0  0.73      0       2 numeric  double numeric  FALSE                  0, 1, 2                         
#> 7        stratum     0    0  0    248   0   0 248    83 41.87     42 23.97      1      83 numeric integer integer  FALSE               83 Uniques                         
#> 8 pooled.stratum     0    0  0    248   0   0 248    63 33.58     36 17.27      1      63 numeric  double numeric  FALSE               63 Uniques                         
#> 
cdf(df = infert)
#> $summary
#>   COLLUMNS ROWS TOTAL EMPTY null NAN na INF  FIN FACTOR
#> 1        8  248  1984     0    0   0  0   0 1984      1
#> 
#> $check
#>            NAMES EMPTY null na NOT_NA NAN INF FIN RANGE  MEAN MEDIAN    SD    MIN     MAX    MODE    TYPE   CLASS FACTOR
#> 1      education     0    0  0    248   0   0 248     3    NA     NA    NA 0-5yrs 12+ yrs numeric integer  factor   TRUE
#> 2            age     0    0  0    248   0   0 248    21  31.5     31  5.25     21      44 numeric  double numeric  FALSE
#> 3         parity     0    0  0    248   0   0 248     6  2.09      2  1.25      1       6 numeric  double numeric  FALSE
#> 4        induced     0    0  0    248   0   0 248     3  0.57      0  0.74      0       2 numeric  double numeric  FALSE
#> 5           case     0    0  0    248   0   0 248     2  0.33      0  0.47      0       1 numeric  double numeric  FALSE
#> 6    spontaneous     0    0  0    248   0   0 248     3  0.58      0  0.73      0       2 numeric  double numeric  FALSE
#> 7        stratum     0    0  0    248   0   0 248    83 41.87     42 23.97      1      83 numeric integer integer  FALSE
#> 8 pooled.stratum     0    0  0    248   0   0 248    63 33.58     36 17.27      1      63 numeric  double numeric  FALSE
#> 
df <- data.frame(infert,
  date = seq(as.Date("2010-1-1"),
    as.Date("2020-1-1"),
    length.out = nrow(infert)
  )
)
cdf(df = df)
#> $summary
#>   COLLUMNS ROWS TOTAL EMPTY null NAN na INF  FIN FACTOR
#> 1        9  248  2232     0    0   0  0   0 2232      1
#> 
#> $check
#>            NAMES EMPTY null na NOT_NA NAN INF FIN RANGE  MEAN MEDIAN    SD    MIN     MAX    MODE    TYPE   CLASS FACTOR
#> 1      education     0    0  0    248   0   0 248     3    NA     NA    NA 0-5yrs 12+ yrs numeric integer  factor   TRUE
#> 2            age     0    0  0    248   0   0 248    21  31.5     31  5.25     21      44 numeric  double numeric  FALSE
#> 3         parity     0    0  0    248   0   0 248     6  2.09      2  1.25      1       6 numeric  double numeric  FALSE
#> 4        induced     0    0  0    248   0   0 248     3  0.57      0  0.74      0       2 numeric  double numeric  FALSE
#> 5           case     0    0  0    248   0   0 248     2  0.33      0  0.47      0       1 numeric  double numeric  FALSE
#> 6    spontaneous     0    0  0    248   0   0 248     3  0.58      0  0.73      0       2 numeric  double numeric  FALSE
#> 7        stratum     0    0  0    248   0   0 248    83 41.87     42 23.97      1      83 numeric integer integer  FALSE
#> 8 pooled.stratum     0    0  0    248   0   0 248    63 33.58     36 17.27      1      63 numeric  double numeric  FALSE
#> 9           date     0    0  0    248   0   0 248   248    NA     NA    NA  14610   18262 numeric  double    Date  FALSE
#> 
```
