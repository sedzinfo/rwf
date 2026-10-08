# Horizontal bar charts of response frequencies

Creates one horizontal bar chart per variable showing the frequency
count of each observed level. Missing values are excluded before
tabulation. Variables with no valid observations are silently dropped
from the output.

## Usage

``` r
plot_response_frequencies(
  df,
  factor_index,
  base_size = 10,
  title = "",
  width = 100,
  reorder = FALSE
)
```

## Arguments

- df:

  A data frame containing the variables to plot.

- factor_index:

  Integer vector of column indices identifying the variables to plot.

- base_size:

  Base font size passed to `theme_bw()`. Default is `10`.

- title:

  Character string prepended to each plot title. Default is `""`.

- width:

  Integer controlling the character wrap width applied to the variable
  name in the plot title. Default is `100`.

- reorder:

  Logical. When `TRUE` bars are ordered by frequency in ascending order
  (longest bar at the top). When `FALSE` (default) the original level
  order is preserved.

## Value

A named list of `ggplot` objects, one per variable, named by the column
name. Each plot is a horizontal bar chart with counts on the x-axis and
total observations shown in the caption.

## Examples

``` r
df_ocean_N<-df_ocean[,grep("N",names(df_ocean))]
plot_response_frequencies(df = df_ocean_N)










plot_response_frequencies(df = df_ocean_N, factor_index = 1)
```
