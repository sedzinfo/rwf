# Batch-plot CFA across layouts and display modes

Drop-in replacement for `plot_cfa()` - same signature, returns a named
list of ggplot objects instead of base-graphics recordings.

## Usage

``` r
plot_cfa(model, ...)
```

## Arguments

- model:

  A fitted lavaan object

- ...:

  Extra arguments forwarded to
  [`plot_cfa_gg()`](https://sedzinfo.github.io/rwf/reference/plot_cfa_gg.md)

## Value

Named list of ggplot objects (same keys as the original `plot_cfa`)
