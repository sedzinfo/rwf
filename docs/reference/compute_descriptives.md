# Descriptive statistics

Computes a comprehensive set of descriptive statistics for one or more
continuous variables, optionally stratified by one or more grouping
(independent) variables. When `iv` is supplied the statistics are
computed separately for each combination of dependent and independent
variable levels. Results can be exported to an Excel file.

## Usage

``` r
compute_descriptives(df, dv, iv = NULL, file = NULL)
```

## Arguments

- df:

  A data frame containing the variables of interest.

- dv:

  Integer vector of column indices identifying the dependent
  (continuous) variables to summarise.

- iv:

  Integer vector of column indices identifying the independent
  (grouping) variables used to stratify the output. When `NULL`
  (default) the statistics are computed on the full sample.

- file:

  Character string naming the output Excel file (without extension).
  When `NULL` (default) no file is written.

## Value

A data frame with one row per variable (and per group level when `iv` is
supplied) containing the following columns:

- factor:

  Name of the grouping variable (`iv` only).

- levels:

  Level of the grouping variable (`iv` only).

- variable:

  Name of the dependent variable.

- n:

  Sample size (non-missing observations).

- mean:

  Arithmetic mean.

- sd:

  Standard deviation.

- median:

  Median.

- trimmed:

  10% trimmed mean.

- mad:

  Median absolute deviation.

- min:

  Minimum observed value.

- max:

  Maximum observed value.

- range:

  Difference between maximum and minimum.

- skew:

  Skewness; deviations from 0 indicate departure from symmetry.

- kurtosis:

  Excess kurtosis; deviations from 0 indicate departure from normality.

- se:

  Standard error of the mean.

- IQR:

  Interquartile range (Q0.75 - Q0.25).

- Q0.1, Q0.25, Q0.5, Q0.75, Q0.9:

  Percentiles at 10, 25, 50, 75, and 90.

## Examples

``` r
file = file.path(tempdir(), "descriptives_factor")
compute_descriptives(df = mtcars, dv = 1:5)
#>   variable  n       mean          sd  median    trimmed        mad   min    max  range       skew   kurtosis          se     IQR   Q0.1   Q0.25    Q0.5  Q0.75    Q0.9
#> 1      mpg 32  20.090625   6.0269481  19.200  19.696154   5.411490 10.40  33.90  23.50  0.6106550 -0.3727660  1.06542396   7.375 14.340  15.425  19.200  22.80  30.090
#> 2      cyl 32   6.187500   1.7859216   6.000   6.230769   2.965200  4.00   8.00   4.00 -0.1746119 -1.7621198  0.31570933   4.000  4.000   4.000   6.000   8.00   8.000
#> 3     disp 32 230.721875 123.9386938 196.300 222.523077 140.476350 71.10 472.00 400.90  0.3816570 -1.2072119 21.90947271 205.175 80.610 120.825 196.300 326.00 396.000
#> 4       hp 32 146.687500  68.5628685 123.000 141.192308  77.095200 52.00 335.00 283.00  0.7260237 -0.1355511 12.12031731  83.500 66.000  96.500 123.000 180.00 243.500
#> 5     drat 32   3.596563   0.5346787   3.695   3.579231   0.704235  2.76   4.93   2.17  0.2659039 -0.7147006  0.09451874   0.840  3.007   3.080   3.695   3.92   4.209
compute_descriptives(df = mtcars, dv = 1:2, iv = 9:10)
#>    factor variable levels  n      mean        sd median   trimmed     mad  min  max range        skew   kurtosis        se    IQR  Q0.1 Q0.25 Q0.5  Q0.75  Q0.9
#> 1      am      mpg      0 19 17.147368 3.8339664   17.3 17.117647 3.11346 10.4 24.4  14.0  0.01395038 -0.8031783 0.8795722  4.250 12.72 14.95 17.3 19.200 21.76
#> 2      am      mpg      1 13 24.392308 6.1665038   22.8 24.381818 6.67170 15.0 33.9  18.9  0.05256118 -1.4553520 1.7102804  9.400 16.58 21.00 22.8 30.400 32.00
#> 3    gear      mpg      3 15 16.106667 3.3716182   15.5 16.130769 3.26172 10.4 21.5  11.1 -0.07358952 -0.9441784 0.8705481  3.900 11.56 14.50 15.5 18.400 20.52
#> 4    gear      mpg      4 12 24.533333 5.2767644   22.8 24.270000 4.00302 17.8 33.9  16.1  0.53615833 -1.2736877 1.5232707  7.075 19.38 21.00 22.8 28.075 32.20
#> 5    gear      mpg      5  5 21.380000 6.6589789   19.7 21.380000 6.96822 15.0 30.4  15.4  0.26707885 -2.0123768 2.9779859 10.200 15.32 15.80 19.7 26.000 28.64
#> 6      am      cyl      0 19  6.947368 1.5446569    8.0  7.058824 0.00000  4.0  8.0   4.0 -0.94561358 -0.7409637 0.3543686  2.000  4.00  6.00  8.0  8.000  8.00
#> 7      am      cyl      1 13  5.076923 1.5525001    4.0  4.909091 0.00000  4.0  8.0   4.0  0.86996660 -0.8952805 0.4305860  2.000  4.00  4.00  4.0  6.000  7.60
#> 8    gear      cyl      3 15  7.466667 1.1872337    8.0  7.692308 0.00000  4.0  8.0   4.0 -1.83857893  2.1894424 0.3065424  0.000  6.00  8.00  8.0  8.000  8.00
#> 9    gear      cyl      4 12  4.666667 0.9847319    4.0  4.600000 0.00000  4.0  6.0   2.0  0.62058627 -1.7395833 0.2842676  2.000  4.00  4.00  4.0  6.000  6.00
#> 10   gear      cyl      5  5  6.000000 2.0000000    6.0  6.000000 2.96520  4.0  8.0   4.0  0.00000000 -2.2000000 0.8944272  4.000  4.00  4.00  6.0  8.000  8.00
compute_descriptives(df = mtcars, dv = 1:2)
#>   variable  n     mean       sd median   trimmed     mad  min  max range       skew  kurtosis        se   IQR  Q0.1  Q0.25 Q0.5 Q0.75  Q0.9
#> 1      mpg 32 20.09062 6.026948   19.2 19.696154 5.41149 10.4 33.9  23.5  0.6106550 -0.372766 1.0654240 7.375 14.34 15.425 19.2  22.8 30.09
#> 2      cyl 32  6.18750 1.785922    6.0  6.230769 2.96520  4.0  8.0   4.0 -0.1746119 -1.762120 0.3157093 4.000  4.00  4.000  6.0   8.0  8.00
compute_descriptives(df = mtcars, dv = 1:2, iv = 9:10, file = file)
#>    factor variable levels  n      mean        sd median   trimmed     mad  min  max range        skew   kurtosis        se    IQR  Q0.1 Q0.25 Q0.5  Q0.75  Q0.9
#> 1      am      mpg      0 19 17.147368 3.8339664   17.3 17.117647 3.11346 10.4 24.4  14.0  0.01395038 -0.8031783 0.8795722  4.250 12.72 14.95 17.3 19.200 21.76
#> 2      am      mpg      1 13 24.392308 6.1665038   22.8 24.381818 6.67170 15.0 33.9  18.9  0.05256118 -1.4553520 1.7102804  9.400 16.58 21.00 22.8 30.400 32.00
#> 3    gear      mpg      3 15 16.106667 3.3716182   15.5 16.130769 3.26172 10.4 21.5  11.1 -0.07358952 -0.9441784 0.8705481  3.900 11.56 14.50 15.5 18.400 20.52
#> 4    gear      mpg      4 12 24.533333 5.2767644   22.8 24.270000 4.00302 17.8 33.9  16.1  0.53615833 -1.2736877 1.5232707  7.075 19.38 21.00 22.8 28.075 32.20
#> 5    gear      mpg      5  5 21.380000 6.6589789   19.7 21.380000 6.96822 15.0 30.4  15.4  0.26707885 -2.0123768 2.9779859 10.200 15.32 15.80 19.7 26.000 28.64
#> 6      am      cyl      0 19  6.947368 1.5446569    8.0  7.058824 0.00000  4.0  8.0   4.0 -0.94561358 -0.7409637 0.3543686  2.000  4.00  6.00  8.0  8.000  8.00
#> 7      am      cyl      1 13  5.076923 1.5525001    4.0  4.909091 0.00000  4.0  8.0   4.0  0.86996660 -0.8952805 0.4305860  2.000  4.00  4.00  4.0  6.000  7.60
#> 8    gear      cyl      3 15  7.466667 1.1872337    8.0  7.692308 0.00000  4.0  8.0   4.0 -1.83857893  2.1894424 0.3065424  0.000  6.00  8.00  8.0  8.000  8.00
#> 9    gear      cyl      4 12  4.666667 0.9847319    4.0  4.600000 0.00000  4.0  6.0   2.0  0.62058627 -1.7395833 0.2842676  2.000  4.00  4.00  4.0  6.000  6.00
#> 10   gear      cyl      5  5  6.000000 2.0000000    6.0  6.000000 2.96520  4.0  8.0   4.0  0.00000000 -2.2000000 0.8944272  4.000  4.00  4.00  6.0  8.000  8.00
```
