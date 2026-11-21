# Round numeric columns in a data frame

Applies a rounding or transformation function to every numeric column in
a data frame, leaving non-numeric columns (factor, character, etc.)
unchanged.

## Usage

``` r
round_dataframe(df, digits = 0, type = "round")
```

## Arguments

- df:

  A data frame containing a mix of numeric and non-numeric columns.

- digits:

  Integer number of decimal places. Only used with `type = "round"` and
  `type = "tenth"`. Default is `0`.

- type:

  Character string specifying the transformation to apply to numeric
  columns:

  `"round"`

  : Round to `digits` decimal places using
    [`round()`](https://rdrr.io/r/base/Round.html) (default).

  `"ceiling"`

  : Round up to the nearest integer using
    [`ceiling()`](https://rdrr.io/r/base/Round.html).

  `"floor"`

  : Round down to the nearest integer using
    [`floor()`](https://rdrr.io/r/base/Round.html).

  `"tenth"`

  : Divide each value by 10 then round to `digits` decimal places —
    useful for rescaling values that were multiplied by 10 (e.g.
    converting tenths back to units).

## Value

A data frame with the same structure as `df` where all numeric columns
have been rounded or transformed according to `type`.

## Examples

``` r
round_dataframe(df = change_data_type(df = mtcars, type = "factor"), digits = 0)
#>                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4             21   6   160 110  3.9  2.62 16.46  0  1    4    4
#> Mazda RX4 Wag         21   6   160 110  3.9 2.875 17.02  0  1    4    4
#> Datsun 710          22.8   4   108  93 3.85  2.32 18.61  1  1    4    1
#> Hornet 4 Drive      21.4   6   258 110 3.08 3.215 19.44  1  0    3    1
#> Hornet Sportabout   18.7   8   360 175 3.15  3.44 17.02  0  0    3    2
#> Valiant             18.1   6   225 105 2.76  3.46 20.22  1  0    3    1
#> Duster 360          14.3   8   360 245 3.21  3.57 15.84  0  0    3    4
#> Merc 240D           24.4   4 146.7  62 3.69  3.19    20  1  0    4    2
#> Merc 230            22.8   4 140.8  95 3.92  3.15  22.9  1  0    4    2
#> Merc 280            19.2   6 167.6 123 3.92  3.44  18.3  1  0    4    4
#> Merc 280C           17.8   6 167.6 123 3.92  3.44  18.9  1  0    4    4
#> Merc 450SE          16.4   8 275.8 180 3.07  4.07  17.4  0  0    3    3
#> Merc 450SL          17.3   8 275.8 180 3.07  3.73  17.6  0  0    3    3
#> Merc 450SLC         15.2   8 275.8 180 3.07  3.78    18  0  0    3    3
#> Cadillac Fleetwood  10.4   8   472 205 2.93  5.25 17.98  0  0    3    4
#> Lincoln Continental 10.4   8   460 215    3 5.424 17.82  0  0    3    4
#> Chrysler Imperial   14.7   8   440 230 3.23 5.345 17.42  0  0    3    4
#> Fiat 128            32.4   4  78.7  66 4.08   2.2 19.47  1  1    4    1
#> Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> Toyota Corolla      33.9   4  71.1  65 4.22 1.835  19.9  1  1    4    1
#> Toyota Corona       21.5   4 120.1  97  3.7 2.465 20.01  1  0    3    1
#> Dodge Challenger    15.5   8   318 150 2.76  3.52 16.87  0  0    3    2
#> AMC Javelin         15.2   8   304 150 3.15 3.435  17.3  0  0    3    2
#> Camaro Z28          13.3   8   350 245 3.73  3.84 15.41  0  0    3    4
#> Pontiac Firebird    19.2   8   400 175 3.08 3.845 17.05  0  0    3    2
#> Fiat X1-9           27.3   4    79  66 4.08 1.935  18.9  1  1    4    1
#> Porsche 914-2         26   4 120.3  91 4.43  2.14  16.7  0  1    5    2
#> Lotus Europa        30.4   4  95.1 113 3.77 1.513  16.9  1  1    5    2
#> Ford Pantera L      15.8   8   351 264 4.22  3.17  14.5  0  1    5    4
#> Ferrari Dino        19.7   6   145 175 3.62  2.77  15.5  0  1    5    6
#> Maserati Bora         15   8   301 335 3.54  3.57  14.6  0  1    5    8
#> Volvo 142E          21.4   4   121 109 4.11  2.78  18.6  1  1    4    2
round_dataframe(df = change_data_type(df = mtcars, type = "character"), digits = 0)
#>                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4             21   6   160 110  3.9  2.62 16.46  0  1    4    4
#> Mazda RX4 Wag         21   6   160 110  3.9 2.875 17.02  0  1    4    4
#> Datsun 710          22.8   4   108  93 3.85  2.32 18.61  1  1    4    1
#> Hornet 4 Drive      21.4   6   258 110 3.08 3.215 19.44  1  0    3    1
#> Hornet Sportabout   18.7   8   360 175 3.15  3.44 17.02  0  0    3    2
#> Valiant             18.1   6   225 105 2.76  3.46 20.22  1  0    3    1
#> Duster 360          14.3   8   360 245 3.21  3.57 15.84  0  0    3    4
#> Merc 240D           24.4   4 146.7  62 3.69  3.19    20  1  0    4    2
#> Merc 230            22.8   4 140.8  95 3.92  3.15  22.9  1  0    4    2
#> Merc 280            19.2   6 167.6 123 3.92  3.44  18.3  1  0    4    4
#> Merc 280C           17.8   6 167.6 123 3.92  3.44  18.9  1  0    4    4
#> Merc 450SE          16.4   8 275.8 180 3.07  4.07  17.4  0  0    3    3
#> Merc 450SL          17.3   8 275.8 180 3.07  3.73  17.6  0  0    3    3
#> Merc 450SLC         15.2   8 275.8 180 3.07  3.78    18  0  0    3    3
#> Cadillac Fleetwood  10.4   8   472 205 2.93  5.25 17.98  0  0    3    4
#> Lincoln Continental 10.4   8   460 215    3 5.424 17.82  0  0    3    4
#> Chrysler Imperial   14.7   8   440 230 3.23 5.345 17.42  0  0    3    4
#> Fiat 128            32.4   4  78.7  66 4.08   2.2 19.47  1  1    4    1
#> Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> Toyota Corolla      33.9   4  71.1  65 4.22 1.835  19.9  1  1    4    1
#> Toyota Corona       21.5   4 120.1  97  3.7 2.465 20.01  1  0    3    1
#> Dodge Challenger    15.5   8   318 150 2.76  3.52 16.87  0  0    3    2
#> AMC Javelin         15.2   8   304 150 3.15 3.435  17.3  0  0    3    2
#> Camaro Z28          13.3   8   350 245 3.73  3.84 15.41  0  0    3    4
#> Pontiac Firebird    19.2   8   400 175 3.08 3.845 17.05  0  0    3    2
#> Fiat X1-9           27.3   4    79  66 4.08 1.935  18.9  1  1    4    1
#> Porsche 914-2         26   4 120.3  91 4.43  2.14  16.7  0  1    5    2
#> Lotus Europa        30.4   4  95.1 113 3.77 1.513  16.9  1  1    5    2
#> Ford Pantera L      15.8   8   351 264 4.22  3.17  14.5  0  1    5    4
#> Ferrari Dino        19.7   6   145 175 3.62  2.77  15.5  0  1    5    6
#> Maserati Bora         15   8   301 335 3.54  3.57  14.6  0  1    5    8
#> Volvo 142E          21.4   4   121 109 4.11  2.78  18.6  1  1    4    2
round_dataframe(df = mtcars, digits = 0)
#>                     mpg cyl disp  hp drat wt qsec vs am gear carb
#> Mazda RX4            21   6  160 110    4  3   16  0  1    4    4
#> Mazda RX4 Wag        21   6  160 110    4  3   17  0  1    4    4
#> Datsun 710           23   4  108  93    4  2   19  1  1    4    1
#> Hornet 4 Drive       21   6  258 110    3  3   19  1  0    3    1
#> Hornet Sportabout    19   8  360 175    3  3   17  0  0    3    2
#> Valiant              18   6  225 105    3  3   20  1  0    3    1
#> Duster 360           14   8  360 245    3  4   16  0  0    3    4
#> Merc 240D            24   4  147  62    4  3   20  1  0    4    2
#> Merc 230             23   4  141  95    4  3   23  1  0    4    2
#> Merc 280             19   6  168 123    4  3   18  1  0    4    4
#> Merc 280C            18   6  168 123    4  3   19  1  0    4    4
#> Merc 450SE           16   8  276 180    3  4   17  0  0    3    3
#> Merc 450SL           17   8  276 180    3  4   18  0  0    3    3
#> Merc 450SLC          15   8  276 180    3  4   18  0  0    3    3
#> Cadillac Fleetwood   10   8  472 205    3  5   18  0  0    3    4
#> Lincoln Continental  10   8  460 215    3  5   18  0  0    3    4
#> Chrysler Imperial    15   8  440 230    3  5   17  0  0    3    4
#> Fiat 128             32   4   79  66    4  2   19  1  1    4    1
#> Honda Civic          30   4   76  52    5  2   19  1  1    4    2
#> Toyota Corolla       34   4   71  65    4  2   20  1  1    4    1
#> Toyota Corona        22   4  120  97    4  2   20  1  0    3    1
#> Dodge Challenger     16   8  318 150    3  4   17  0  0    3    2
#> AMC Javelin          15   8  304 150    3  3   17  0  0    3    2
#> Camaro Z28           13   8  350 245    4  4   15  0  0    3    4
#> Pontiac Firebird     19   8  400 175    3  4   17  0  0    3    2
#> Fiat X1-9            27   4   79  66    4  2   19  1  1    4    1
#> Porsche 914-2        26   4  120  91    4  2   17  0  1    5    2
#> Lotus Europa         30   4   95 113    4  2   17  1  1    5    2
#> Ford Pantera L       16   8  351 264    4  3   14  0  1    5    4
#> Ferrari Dino         20   6  145 175    4  3   16  0  1    5    6
#> Maserati Bora        15   8  301 335    4  4   15  0  1    5    8
#> Volvo 142E           21   4  121 109    4  3   19  1  1    4    2
round_dataframe(df = mtcars, digits = 0, type = "ceiling")
#>                     mpg cyl disp  hp drat wt qsec vs am gear carb
#> Mazda RX4            21   6  160 110    4  3   17  0  1    4    4
#> Mazda RX4 Wag        21   6  160 110    4  3   18  0  1    4    4
#> Datsun 710           23   4  108  93    4  3   19  1  1    4    1
#> Hornet 4 Drive       22   6  258 110    4  4   20  1  0    3    1
#> Hornet Sportabout    19   8  360 175    4  4   18  0  0    3    2
#> Valiant              19   6  225 105    3  4   21  1  0    3    1
#> Duster 360           15   8  360 245    4  4   16  0  0    3    4
#> Merc 240D            25   4  147  62    4  4   20  1  0    4    2
#> Merc 230             23   4  141  95    4  4   23  1  0    4    2
#> Merc 280             20   6  168 123    4  4   19  1  0    4    4
#> Merc 280C            18   6  168 123    4  4   19  1  0    4    4
#> Merc 450SE           17   8  276 180    4  5   18  0  0    3    3
#> Merc 450SL           18   8  276 180    4  4   18  0  0    3    3
#> Merc 450SLC          16   8  276 180    4  4   18  0  0    3    3
#> Cadillac Fleetwood   11   8  472 205    3  6   18  0  0    3    4
#> Lincoln Continental  11   8  460 215    3  6   18  0  0    3    4
#> Chrysler Imperial    15   8  440 230    4  6   18  0  0    3    4
#> Fiat 128             33   4   79  66    5  3   20  1  1    4    1
#> Honda Civic          31   4   76  52    5  2   19  1  1    4    2
#> Toyota Corolla       34   4   72  65    5  2   20  1  1    4    1
#> Toyota Corona        22   4  121  97    4  3   21  1  0    3    1
#> Dodge Challenger     16   8  318 150    3  4   17  0  0    3    2
#> AMC Javelin          16   8  304 150    4  4   18  0  0    3    2
#> Camaro Z28           14   8  350 245    4  4   16  0  0    3    4
#> Pontiac Firebird     20   8  400 175    4  4   18  0  0    3    2
#> Fiat X1-9            28   4   79  66    5  2   19  1  1    4    1
#> Porsche 914-2        26   4  121  91    5  3   17  0  1    5    2
#> Lotus Europa         31   4   96 113    4  2   17  1  1    5    2
#> Ford Pantera L       16   8  351 264    5  4   15  0  1    5    4
#> Ferrari Dino         20   6  145 175    4  3   16  0  1    5    6
#> Maserati Bora        15   8  301 335    4  4   15  0  1    5    8
#> Volvo 142E           22   4  121 109    5  3   19  1  1    4    2
round_dataframe(df = mtcars, digits = 0, type = "floor")
#>                     mpg cyl disp  hp drat wt qsec vs am gear carb
#> Mazda RX4            21   6  160 110    3  2   16  0  1    4    4
#> Mazda RX4 Wag        21   6  160 110    3  2   17  0  1    4    4
#> Datsun 710           22   4  108  93    3  2   18  1  1    4    1
#> Hornet 4 Drive       21   6  258 110    3  3   19  1  0    3    1
#> Hornet Sportabout    18   8  360 175    3  3   17  0  0    3    2
#> Valiant              18   6  225 105    2  3   20  1  0    3    1
#> Duster 360           14   8  360 245    3  3   15  0  0    3    4
#> Merc 240D            24   4  146  62    3  3   20  1  0    4    2
#> Merc 230             22   4  140  95    3  3   22  1  0    4    2
#> Merc 280             19   6  167 123    3  3   18  1  0    4    4
#> Merc 280C            17   6  167 123    3  3   18  1  0    4    4
#> Merc 450SE           16   8  275 180    3  4   17  0  0    3    3
#> Merc 450SL           17   8  275 180    3  3   17  0  0    3    3
#> Merc 450SLC          15   8  275 180    3  3   18  0  0    3    3
#> Cadillac Fleetwood   10   8  472 205    2  5   17  0  0    3    4
#> Lincoln Continental  10   8  460 215    3  5   17  0  0    3    4
#> Chrysler Imperial    14   8  440 230    3  5   17  0  0    3    4
#> Fiat 128             32   4   78  66    4  2   19  1  1    4    1
#> Honda Civic          30   4   75  52    4  1   18  1  1    4    2
#> Toyota Corolla       33   4   71  65    4  1   19  1  1    4    1
#> Toyota Corona        21   4  120  97    3  2   20  1  0    3    1
#> Dodge Challenger     15   8  318 150    2  3   16  0  0    3    2
#> AMC Javelin          15   8  304 150    3  3   17  0  0    3    2
#> Camaro Z28           13   8  350 245    3  3   15  0  0    3    4
#> Pontiac Firebird     19   8  400 175    3  3   17  0  0    3    2
#> Fiat X1-9            27   4   79  66    4  1   18  1  1    4    1
#> Porsche 914-2        26   4  120  91    4  2   16  0  1    5    2
#> Lotus Europa         30   4   95 113    3  1   16  1  1    5    2
#> Ford Pantera L       15   8  351 264    4  3   14  0  1    5    4
#> Ferrari Dino         19   6  145 175    3  2   15  0  1    5    6
#> Maserati Bora        15   8  301 335    3  3   14  0  1    5    8
#> Volvo 142E           21   4  121 109    4  2   18  1  1    4    2
round_dataframe(df = mtcars * 100, digits = 2, type = "tenth")
#>                     mpg cyl disp   hp drat    wt  qsec vs am gear carb
#> Mazda RX4           210  60 1600 1100 39.0 26.20 164.6  0 10   40   40
#> Mazda RX4 Wag       210  60 1600 1100 39.0 28.75 170.2  0 10   40   40
#> Datsun 710          228  40 1080  930 38.5 23.20 186.1 10 10   40   10
#> Hornet 4 Drive      214  60 2580 1100 30.8 32.15 194.4 10  0   30   10
#> Hornet Sportabout   187  80 3600 1750 31.5 34.40 170.2  0  0   30   20
#> Valiant             181  60 2250 1050 27.6 34.60 202.2 10  0   30   10
#> Duster 360          143  80 3600 2450 32.1 35.70 158.4  0  0   30   40
#> Merc 240D           244  40 1467  620 36.9 31.90 200.0 10  0   40   20
#> Merc 230            228  40 1408  950 39.2 31.50 229.0 10  0   40   20
#> Merc 280            192  60 1676 1230 39.2 34.40 183.0 10  0   40   40
#> Merc 280C           178  60 1676 1230 39.2 34.40 189.0 10  0   40   40
#> Merc 450SE          164  80 2758 1800 30.7 40.70 174.0  0  0   30   30
#> Merc 450SL          173  80 2758 1800 30.7 37.30 176.0  0  0   30   30
#> Merc 450SLC         152  80 2758 1800 30.7 37.80 180.0  0  0   30   30
#> Cadillac Fleetwood  104  80 4720 2050 29.3 52.50 179.8  0  0   30   40
#> Lincoln Continental 104  80 4600 2150 30.0 54.24 178.2  0  0   30   40
#> Chrysler Imperial   147  80 4400 2300 32.3 53.45 174.2  0  0   30   40
#> Fiat 128            324  40  787  660 40.8 22.00 194.7 10 10   40   10
#> Honda Civic         304  40  757  520 49.3 16.15 185.2 10 10   40   20
#> Toyota Corolla      339  40  711  650 42.2 18.35 199.0 10 10   40   10
#> Toyota Corona       215  40 1201  970 37.0 24.65 200.1 10  0   30   10
#> Dodge Challenger    155  80 3180 1500 27.6 35.20 168.7  0  0   30   20
#> AMC Javelin         152  80 3040 1500 31.5 34.35 173.0  0  0   30   20
#> Camaro Z28          133  80 3500 2450 37.3 38.40 154.1  0  0   30   40
#> Pontiac Firebird    192  80 4000 1750 30.8 38.45 170.5  0  0   30   20
#> Fiat X1-9           273  40  790  660 40.8 19.35 189.0 10 10   40   10
#> Porsche 914-2       260  40 1203  910 44.3 21.40 167.0  0 10   50   20
#> Lotus Europa        304  40  951 1130 37.7 15.13 169.0 10 10   50   20
#> Ford Pantera L      158  80 3510 2640 42.2 31.70 145.0  0 10   50   40
#> Ferrari Dino        197  60 1450 1750 36.2 27.70 155.0  0 10   50   60
#> Maserati Bora       150  80 3010 3350 35.4 35.70 146.0  0 10   50   80
#> Volvo 142E          214  40 1210 1090 41.1 27.80 186.0 10 10   40   20
```
