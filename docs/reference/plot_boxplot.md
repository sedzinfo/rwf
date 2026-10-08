# Side-by-side boxplots for all numeric columns

Melts all numeric columns of `df` into a single long format and draws
them as side-by-side horizontal boxplots on one plot. Non-numeric
columns are silently dropped.

## Usage

``` r
plot_boxplot(df, title = "", base_size = 10)
```

## Arguments

- df:

  Data frame or numeric vector. Non-numeric columns are silently
  dropped.

- title:

  Character string used as the plot title. Default is `""`.

- base_size:

  Base font size passed to `theme_bw()`. Default is `10`.

## Value

A single `ggplot` object.

## Examples

``` r
vector <- generate_missing(rnorm(50), missing = 10)
df <- generate_missing(mtcars[, 1:2], missing = 10)
plot_boxplot(df = vector)

plot_boxplot(df = df)
```
