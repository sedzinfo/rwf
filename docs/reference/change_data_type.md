# Convert column data types in a data frame

Converts all or selected columns in a data frame to a specified data
type. Whitespace (tabs, carriage returns, newlines) is trimmed
automatically when converting to `"character"` or `"numeric"`.

## Usage

``` r
change_data_type(df, type)
```

## Arguments

- df:

  A data frame whose columns will be converted.

- type:

  Character string specifying the conversion to apply:

  `"character"`

  : Converts all columns to character, trimming leading and trailing
    whitespace.

  `"numeric"`

  : Converts all columns to numeric (via character with whitespace
    trimming). Non-numeric strings become `NA`.

  `"factor"`

  : Converts all columns to factor.

  `"factor_character"`

  : Converts only factor columns to character; all other columns are
    left unchanged.

  `"character_factor"`

  : Converts only character columns to factor; all other columns are
    left unchanged.

## Value

A data frame with the same dimensions as `df` with column types
converted as specified.

## Examples

``` r
cdf(df = change_data_type(df = mtcars, "character"))
#> $summary
#>   COLLUMNS ROWS TOTAL EMPTY null NAN na INF FIN FACTOR
#> 1       11   32   352     0    0   0  0   0   0      0
#> 
#> $check
#>    NAMES EMPTY null na NOT_NA NAN INF FIN RANGE MEAN MEDIAN SD   MIN   MAX      MODE      TYPE     CLASS FACTOR
#> 1    mpg     0    0  0     32   0   0   0    25   NA     NA NA  10.4  33.9 character character character  FALSE
#> 2    cyl     0    0  0     32   0   0   0     3   NA     NA NA     4     8 character character character  FALSE
#> 3   disp     0    0  0     32   0   0   0    27   NA     NA NA  71.1   472 character character character  FALSE
#> 4     hp     0    0  0     32   0   0   0    22   NA     NA NA    52   335 character character character  FALSE
#> 5   drat     0    0  0     32   0   0   0    22   NA     NA NA  2.76  4.93 character character character  FALSE
#> 6     wt     0    0  0     32   0   0   0    29   NA     NA NA 1.513 5.424 character character character  FALSE
#> 7   qsec     0    0  0     32   0   0   0    30   NA     NA NA  14.5  22.9 character character character  FALSE
#> 8     vs     0    0  0     32   0   0   0     2   NA     NA NA     0     1 character character character  FALSE
#> 9     am     0    0  0     32   0   0   0     2   NA     NA NA     0     1 character character character  FALSE
#> 10  gear     0    0  0     32   0   0   0     3   NA     NA NA     3     5 character character character  FALSE
#> 11  carb     0    0  0     32   0   0   0     6   NA     NA NA     1     8 character character character  FALSE
#> 
cdf(df = change_data_type(df = mtcars, "numeric"))
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
cdf(df = change_data_type(df = mtcars, "factor"))
#> $summary
#>   COLLUMNS ROWS TOTAL EMPTY null NAN na INF FIN FACTOR
#> 1       11   32   352     0    0   0  0   0 352     11
#> 
#> $check
#>    NAMES EMPTY null na NOT_NA NAN INF FIN RANGE MEAN MEDIAN SD   MIN   MAX    MODE    TYPE  CLASS FACTOR
#> 1    mpg     0    0  0     32   0   0  32    25   NA     NA NA  10.4  33.9 numeric integer factor   TRUE
#> 2    cyl     0    0  0     32   0   0  32     3   NA     NA NA     4     8 numeric integer factor   TRUE
#> 3   disp     0    0  0     32   0   0  32    27   NA     NA NA  71.1   472 numeric integer factor   TRUE
#> 4     hp     0    0  0     32   0   0  32    22   NA     NA NA    52   335 numeric integer factor   TRUE
#> 5   drat     0    0  0     32   0   0  32    22   NA     NA NA  2.76  4.93 numeric integer factor   TRUE
#> 6     wt     0    0  0     32   0   0  32    29   NA     NA NA 1.513 5.424 numeric integer factor   TRUE
#> 7   qsec     0    0  0     32   0   0  32    30   NA     NA NA  14.5  22.9 numeric integer factor   TRUE
#> 8     vs     0    0  0     32   0   0  32     2   NA     NA NA     0     1 numeric integer factor   TRUE
#> 9     am     0    0  0     32   0   0  32     2   NA     NA NA     0     1 numeric integer factor   TRUE
#> 10  gear     0    0  0     32   0   0  32     3   NA     NA NA     3     5 numeric integer factor   TRUE
#> 11  carb     0    0  0     32   0   0  32     6   NA     NA NA     1     8 numeric integer factor   TRUE
#> 
df <- change_data_type(df = mtcars, "factor")
cdf(df = change_data_type(df = df, "factor_character"))
#> $summary
#>   COLLUMNS ROWS TOTAL EMPTY null NAN na INF FIN FACTOR
#> 1       11   32   352     0    0   0  0   0   0      0
#> 
#> $check
#>    NAMES EMPTY null na NOT_NA NAN INF FIN RANGE MEAN MEDIAN SD   MIN   MAX      MODE      TYPE     CLASS FACTOR
#> 1    mpg     0    0  0     32   0   0   0    25   NA     NA NA  10.4  33.9 character character character  FALSE
#> 2    cyl     0    0  0     32   0   0   0     3   NA     NA NA     4     8 character character character  FALSE
#> 3   disp     0    0  0     32   0   0   0    27   NA     NA NA  71.1   472 character character character  FALSE
#> 4     hp     0    0  0     32   0   0   0    22   NA     NA NA    52   335 character character character  FALSE
#> 5   drat     0    0  0     32   0   0   0    22   NA     NA NA  2.76  4.93 character character character  FALSE
#> 6     wt     0    0  0     32   0   0   0    29   NA     NA NA 1.513 5.424 character character character  FALSE
#> 7   qsec     0    0  0     32   0   0   0    30   NA     NA NA  14.5  22.9 character character character  FALSE
#> 8     vs     0    0  0     32   0   0   0     2   NA     NA NA     0     1 character character character  FALSE
#> 9     am     0    0  0     32   0   0   0     2   NA     NA NA     0     1 character character character  FALSE
#> 10  gear     0    0  0     32   0   0   0     3   NA     NA NA     3     5 character character character  FALSE
#> 11  carb     0    0  0     32   0   0   0     6   NA     NA NA     1     8 character character character  FALSE
#> 
```
