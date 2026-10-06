# Plot a confusion matrix with the full set of derived measures

Draws a 2x2 confusion matrix (raw counts, sequential-blue by magnitude)
alongside the row/column/overall measures:

- Total measures:

  Accuracy, Prevalence, Proportion Incorrectly Classified

- Horizontal measures:

  Sensitivity/Miss Rate (observed positive column), Specificity/Fall-out
  (observed negative column)

- Vertical measures:

  Precision/False Discovery Rate (predicted positive row), Negative
  Predictive Value/False Omission Rate (predicted negative row)

## Usage

``` r
plot_confusion_extended(
  observed,
  predicted,
  positive = NULL,
  base_size = 10,
  title = ""
)
```

## Arguments

- observed:

  Vector of true class labels (2 unique values).

- predicted:

  Vector of predicted class labels (2 unique values, same domain).

- positive:

  Value treated as the positive class. Defaults to the second sorted
  level (matches rwf's
  [`confusion()`](https://sedzinfo.github.io/rwf/reference/confusion.md)
  convention).

- base_size:

  Base font size. Default 12.

- title:

  Plot title suffix.

## Examples

``` r
plot_confusion_extended(observed=c(0,0,0,1,1,1),predicted=c(0,0,0,1,1,1))
```
