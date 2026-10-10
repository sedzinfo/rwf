# Replace and remove non-computable values

Cleans a data frame by replacing non-computable values (`NA`, `NaN`,
`Inf`, `-Inf`, and empty strings) with a chosen replacement, then
optionally drops rows or columns that still contain missing values or
have zero variance.

## Usage

``` r
remove_nc(
  df,
  value = NA,
  remove_rows = FALSE,
  aggressive = FALSE,
  remove_cols = FALSE,
  remove_zero_variance = FALSE
)
```

## Arguments

- df:

  A data frame to clean.

- value:

  The replacement value for all non-computable entries. Default is `NA`.

- remove_rows:

  Logical. When `TRUE`, rows containing `NA` after replacement are
  removed according to the `aggressive` setting. Default is `FALSE`.

- aggressive:

  Logical. Only used when `remove_rows = TRUE`.

  - `TRUE` — remove a row if *any* value is `NA`.

  - `FALSE` — remove a row only if *all* values are `NA`.

  Default is `FALSE`.

- remove_cols:

  Logical. When `TRUE`, columns where *all* values are `NA` are dropped.
  Default is `FALSE`.

- remove_zero_variance:

  Logical. Only used when `remove_cols = TRUE`. When `TRUE`, columns
  with only one unique non-missing value (zero variance) are also
  dropped. Default is `FALSE`.

## Value

A data frame with non-computable values replaced and, depending on the
flags, rows and / or columns removed.

## Examples

``` r
df <- mtcars
df[1, ] <- as.numeric(NaN)
df[2, ] <- as.numeric(Inf)
df[3, ] <- as.numeric(-Inf)
df[4, ] <- as.numeric(NA)
df[5, ] <- ""
remove_nc(df = df, value = NA)
#>                      mpg  cyl  disp   hp drat    wt  qsec   vs   am gear carb
#> Mazda RX4           <NA> <NA>  <NA> <NA> <NA>  <NA>  <NA> <NA> <NA> <NA> <NA>
#> Mazda RX4 Wag       <NA> <NA>  <NA> <NA> <NA>  <NA>  <NA> <NA> <NA> <NA> <NA>
#> Datsun 710          <NA> <NA>  <NA> <NA> <NA>  <NA>  <NA> <NA> <NA> <NA> <NA>
#> Hornet 4 Drive      <NA> <NA>  <NA> <NA> <NA>  <NA>  <NA> <NA> <NA> <NA> <NA>
#> Hornet Sportabout   <NA> <NA>  <NA> <NA> <NA>  <NA>  <NA> <NA> <NA> <NA> <NA>
#> Valiant             18.1    6   225  105 2.76  3.46 20.22    1    0    3    1
#> Duster 360          14.3    8   360  245 3.21  3.57 15.84    0    0    3    4
#> Merc 240D           24.4    4 146.7   62 3.69  3.19    20    1    0    4    2
#> Merc 230            22.8    4 140.8   95 3.92  3.15  22.9    1    0    4    2
#> Merc 280            19.2    6 167.6  123 3.92  3.44  18.3    1    0    4    4
#> Merc 280C           17.8    6 167.6  123 3.92  3.44  18.9    1    0    4    4
#> Merc 450SE          16.4    8 275.8  180 3.07  4.07  17.4    0    0    3    3
#> Merc 450SL          17.3    8 275.8  180 3.07  3.73  17.6    0    0    3    3
#> Merc 450SLC         15.2    8 275.8  180 3.07  3.78    18    0    0    3    3
#> Cadillac Fleetwood  10.4    8   472  205 2.93  5.25 17.98    0    0    3    4
#> Lincoln Continental 10.4    8   460  215    3 5.424 17.82    0    0    3    4
#> Chrysler Imperial   14.7    8   440  230 3.23 5.345 17.42    0    0    3    4
#> Fiat 128            32.4    4  78.7   66 4.08   2.2 19.47    1    1    4    1
#> Honda Civic         30.4    4  75.7   52 4.93 1.615 18.52    1    1    4    2
#> Toyota Corolla      33.9    4  71.1   65 4.22 1.835  19.9    1    1    4    1
#> Toyota Corona       21.5    4 120.1   97  3.7 2.465 20.01    1    0    3    1
#> Dodge Challenger    15.5    8   318  150 2.76  3.52 16.87    0    0    3    2
#> AMC Javelin         15.2    8   304  150 3.15 3.435  17.3    0    0    3    2
#> Camaro Z28          13.3    8   350  245 3.73  3.84 15.41    0    0    3    4
#> Pontiac Firebird    19.2    8   400  175 3.08 3.845 17.05    0    0    3    2
#> Fiat X1-9           27.3    4    79   66 4.08 1.935  18.9    1    1    4    1
#> Porsche 914-2         26    4 120.3   91 4.43  2.14  16.7    0    1    5    2
#> Lotus Europa        30.4    4  95.1  113 3.77 1.513  16.9    1    1    5    2
#> Ford Pantera L      15.8    8   351  264 4.22  3.17  14.5    0    1    5    4
#> Ferrari Dino        19.7    6   145  175 3.62  2.77  15.5    0    1    5    6
#> Maserati Bora         15    8   301  335 3.54  3.57  14.6    0    1    5    8
#> Volvo 142E          21.4    4   121  109 4.11  2.78  18.6    1    1    4    2
cdf(remove_nc(df = df, value = NA))
#> $summary
#>   COLLUMNS ROWS TOTAL EMPTY null NAN na INF FIN FACTOR
#> 1       11   32   352     0    0   0 55   0   0      0
#> 
#> $check
#>    NAMES EMPTY null na NOT_NA NAN INF FIN RANGE MEAN MEDIAN SD   MIN   MAX      MODE      TYPE     CLASS FACTOR
#> 1    mpg     0    0  5     27   0   0   0    24   NA     NA NA  10.4  33.9 character character character  FALSE
#> 2    cyl     0    0  5     27   0   0   0     4   NA     NA NA     4     8 character character character  FALSE
#> 3   disp     0    0  5     27   0   0   0    25   NA     NA NA  71.1   472 character character character  FALSE
#> 4     hp     0    0  5     27   0   0   0    21   NA     NA NA    52   335 character character character  FALSE
#> 5   drat     0    0  5     27   0   0   0    21   NA     NA NA  2.76  4.93 character character character  FALSE
#> 6     wt     0    0  5     27   0   0   0    26   NA     NA NA 1.513 5.424 character character character  FALSE
#> 7   qsec     0    0  5     27   0   0   0    27   NA     NA NA  14.5  22.9 character character character  FALSE
#> 8     vs     0    0  5     27   0   0   0     3   NA     NA NA     0     1 character character character  FALSE
#> 9     am     0    0  5     27   0   0   0     3   NA     NA NA     0     1 character character character  FALSE
#> 10  gear     0    0  5     27   0   0   0     4   NA     NA NA     3     5 character character character  FALSE
#> 11  carb     0    0  5     27   0   0   0     7   NA     NA NA     1     8 character character character  FALSE
#> 
df <- generate_missing(mtcars, missing = 5)
remove_nc(df, remove_rows = TRUE, aggressive = FALSE)
#>                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4             NA   6    NA 110   NA 2.620 16.46  0  1   NA    4
#> Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
#> Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> Hornet 4 Drive      21.4   6 258.0  NA 3.08 3.215 19.44  1  0    3   NA
#> Hornet Sportabout     NA   8 360.0  NA 3.15 3.440    NA  0 NA    3    2
#> Valiant             18.1   6 225.0  NA 2.76 3.460 20.22  1  0    3    1
#> Duster 360          14.3  NA 360.0 245 3.21 3.570 15.84  0  0    3    4
#> Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
#> Merc 280C           17.8  NA 167.6 123   NA 3.440 18.90  1 NA    4    4
#> Merc 450SE          16.4  NA 275.8 180 3.07 4.070 17.40 NA  0    3   NA
#> Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0 NA    3    3
#> Merc 450SLC         15.2   8 275.8 180 3.07 3.780    NA  0  0    3    3
#> Cadillac Fleetwood    NA   8 472.0 205   NA 5.250 17.98  0  0   NA   NA
#> Lincoln Continental 10.4   8    NA 215 3.00    NA    NA  0 NA    3    4
#> Chrysler Imperial   14.7   8 440.0 230 3.23    NA 17.42 NA  0    3    4
#> Fiat 128              NA   4  78.7  NA 4.08 2.200 19.47  1 NA    4    1
#> Honda Civic           NA  NA  75.7  52 4.93 1.615 18.52 NA  1   NA    2
#> Toyota Corolla      33.9   4    NA  65 4.22 1.835 19.90 NA  1    4    1
#> Toyota Corona       21.5   4 120.1  97 3.70 2.465    NA  1  0    3   NA
#> Dodge Challenger    15.5   8    NA 150 2.76 3.520 16.87  0  0    3    2
#> AMC Javelin         15.2   8 304.0 150   NA    NA 17.30  0  0    3    2
#> Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
#> Pontiac Firebird    19.2   8 400.0  NA 3.08    NA    NA  0  0    3    2
#> Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> Porsche 914-2       26.0  NA 120.3  91 4.43 2.140 16.70  0  1    5    2
#> Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90 NA  1   NA   NA
#> Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
#> Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
#> Maserati Bora       15.0   8    NA 335   NA    NA 14.60  0  1   NA    8
#> Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
remove_nc(df, remove_rows = TRUE, aggressive = TRUE)
#>                 mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4 Wag  21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
#> Datsun 710     22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> Merc 240D      24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> Merc 230       22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> Merc 280       19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
#> Camaro Z28     13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
#> Fiat X1-9      27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> Ford Pantera L 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
#> Ferrari Dino   19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
#> Volvo 142E     21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
df <- generate_missing(generate_correlation_matrix(nrows = 5), missing = 2)
df$X2 <- NA
df$X3 <- 1
remove_nc(df, remove_cols = TRUE, remove_zero_variance = FALSE)
#>        X1 X3     X4      X5
#> 1  1.6199  1     NA -0.7410
#> 2      NA  1 1.5681  0.2735
#> 3  0.2812  1 0.5300      NA
#> 4      NA  1 0.4941  0.1853
#> 5 -0.5881  1     NA      NA
remove_nc(df, remove_cols = TRUE, remove_zero_variance = TRUE)
#>        X1     X4      X5
#> 1  1.6199     NA -0.7410
#> 2      NA 1.5681  0.2735
#> 3  0.2812 0.5300      NA
#> 4      NA 0.4941  0.1853
#> 5 -0.5881     NA      NA
```
