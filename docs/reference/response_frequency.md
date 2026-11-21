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
file = file.path(tempdir(), "descriptives")
df_ocean_N<-df_ocean[,grep("N",names(df_ocean))]
response_frequency(df_ocean_N)
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
response_frequency(df_ocean_N,
                   uniqueitems = 1:5)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
response_frequency(df_ocean_N,
                   uniqueitems = 1:5,
                   type = "proportion")
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
response_frequency(df_ocean_N,
                   uniqueitems = 1:5,
                   type = "percent")
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
response_frequency(df_ocean_N,
                   uniqueitems = 1:5,
                   type = "all")
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
response_frequency(df_ocean_N,
                   uniqueitems = 1:5,
                   type = "all",
  file = file)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
```
