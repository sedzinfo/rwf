# Q-Q plots against the normal distribution

Produces one quantile-quantile plot per numeric column of `df`,
comparing the empirical distribution to the theoretical normal. A
reference line is fitted through the 25th and 75th percentiles (the same
convention used by [`qqline`](https://rdrr.io/r/stats/qqnorm.html)).
Non-numeric columns are skipped silently. A progress bar is printed to
the console.

## Usage

``` r
plot_qq(df, title = "", base_size = 10, pb = FALSE)
```

## Arguments

- df:

  Data frame or vector. Non-numeric columns are skipped.

- title:

  Character string used as the plot title. Default is `""`.

- base_size:

  Base font size passed to `theme_bw()`. Default is `10`.

- pb:

  Logical; whether to display a progress bar in the console. Default is
  `FALSE`.

## Value

A named list of `ggplot` objects, one per numeric column.

## Examples

``` r
vector <- generate_missing(rnorm(50), missing = 10)
df <- generate_missing(mtcars[, 1:2], missing = 10)
plot_qq(df = vector)

plot_qq(df = df)


plot_multiplot(plotlist = plot_qq(df = mtcars[,1:4]), cols = 2)




```
