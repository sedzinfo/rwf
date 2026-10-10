# Decompose datetime objects to dataframe collumns

Decompose datetime objects to dataframe collumns

## Usage

``` r
decompose_datetime(
  x,
  format = "",
  origin = "1970-01-01",
  tz = "GMT",
  extended = FALSE,
  breaks = c(-1, 5, 13, 16, 20, 23),
  ...
)
```

## Arguments

- x:

  datetime object

- format:

  date time format

- origin:

  Starting date. The default is the unix time origin "1970-01-01"

- tz:

  Timezone

- extended:

  if TRUE it will display additional day time categories\
  WEEKDAY MONTH JULIAN QUARTER DAY_PERIOD

- breaks:

  Numeric vector Breaks define hour of day for classifying into\
  "Night", "Morning", "Noon", "Afternoon", "Evening".\

- ...:

  arguments passed to as.POSIXct This argument is used if extended=TRUE

## Examples

``` r
timestamp1 <- as.numeric(as.POSIXct(Sys.Date()))
timestamp2 <- as.numeric(as.POSIXct(Sys.time()))
d1 <- Sys.Date()
d2 <- Sys.time()
decompose_datetime(x = d1)
#>   YEAR MONTH_NUMERIC DAY_NUMERIC  FULL_DATE
#> 1 2026            10          10 2026-10-10
decompose_datetime(x = d2)
#>   YEAR MONTH_NUMERIC DAY_NUMERIC HOUR MINUTE SECOND MILLISECOND  FULL_DATE FULL_TIME
#> 1 2026            10          10   10     46     29      794617 2026-10-10     10:46
decompose_datetime(x = d1, extended = TRUE)
#>   QUARTER   MONTH     JULIAN  WEEKDAY DAY_PERIOD YEAR MONTH_NUMERIC DAY_NUMERIC  FULL_DATE
#> 1      Q4 October 20736 days Saturday       <NA> 2026            10          10 2026-10-10
decompose_datetime(x = d2, extended = TRUE)
#>   QUARTER   MONTH        JULIAN  WEEKDAY DAY_PERIOD YEAR MONTH_NUMERIC DAY_NUMERIC HOUR MINUTE SECOND MILLISECOND  FULL_DATE FULL_TIME
#> 1      Q4 October 20736.45 days Saturday    Morning 2026            10          10   10     46     29      794617 2026-10-10     10:46
decompose_datetime(x = "01/15/1900", format = "%m/%e/%Y")
#>   YEAR MONTH_NUMERIC DAY_NUMERIC  FULL_DATE
#> 1 1900            01          15 1900-01-15
decompose_datetime(x = "01/15/1900", format = "%m/%e/%Y", extended = TRUE)
#>   QUARTER   MONTH      JULIAN WEEKDAY DAY_PERIOD YEAR MONTH_NUMERIC DAY_NUMERIC  FULL_DATE
#> 1      Q1 January -25553 days  Monday       <NA> 1900            01          15 1900-01-15
decompose_datetime(x = as.Date(as.POSIXct(10000, origin = "1970-01-01")))
#>   YEAR MONTH_NUMERIC DAY_NUMERIC  FULL_DATE
#> 1 1970            01          01 1970-01-01
decompose_datetime(
  x = as.Date(as.POSIXct(timestamp1, origin = "1970-01-01")),
  format = "%m/%e/%Y"
)
#>   YEAR MONTH_NUMERIC DAY_NUMERIC  FULL_DATE
#> 1 2026            10          10 2026-10-10
decompose_datetime(
  x = as.Date(as.POSIXct(timestamp2, origin = "1970-01-01")),
  format = "%m/%e/%Y"
)
#>   YEAR MONTH_NUMERIC DAY_NUMERIC  FULL_DATE
#> 1 2026            10          10 2026-10-10
```
