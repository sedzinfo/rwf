# Extract and plot variance components from a mixed model

Extracts variance components from a mixed linear model fitted with
[`mixlm::lm()`](https://rdrr.io/pkg/mixlm/man/lm.html) and computes each
component's percentage contribution to total variance. Results are
returned as both a summary data frame and a horizontal bar chart, making
it easy to identify which sources of variance (e.g. person, item, time,
interactions) dominate the measurement design.

## Usage

``` r
extract_components(model, title = "")
```

## Arguments

- model:

  A mixed model object returned by
  [`mixlm::lm()`](https://rdrr.io/pkg/mixlm/man/lm.html). The model must
  include random effects specified with `r()` so that variance
  components are available via
  [`mixlm::Anova()`](https://rdrr.io/pkg/car/man/Anova.html).

- title:

  Character string used as the plot title. Default is `""`.

## Value

A named list with two elements:

- components:

  A data frame with one row per variance component containing columns
  `component` (effect name), `VC` (estimated variance component), and
  `vc_percent` (percentage of total absolute variance explained by that
  component).

- plot:

  A `ggplot` horizontal bar chart displaying `vc_percent` for each
  component, with a line and points overlaid to show the profile across
  components.

## Examples

``` r
design <- expand.grid(time = 1:3, item = 1:3, person = 1:10)
design <- change_data_type(design, type = "factor")
design$response <- rowSums(change_data_type(design[, 1:2], type = "numeric")) + rnorm(90, 0, 0.1)
model <- mixlm::lm(response ~ r(time) * r(person) + r(item) * r(person), data = design)
extract_components(model)
#> $components
#>     component          VC vc_percent
#> 1        time  1.01979173  50.106421
#> 2      person -0.00011694   0.005746
#> 3        item  1.00340773  49.301410
#> 4 time:person  0.00005982   0.002939
#> 5 person:item -0.00093142   0.045764
#> 6   Residuals  0.01094395   0.537720
#> 
#> $plot

#> 
```
