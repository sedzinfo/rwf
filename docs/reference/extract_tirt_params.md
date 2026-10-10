# Extract Thurstonian IRT Parameters from a lavaan-Fitted Model

Extracts and aligns the core parameter blocks needed for Thurstonian IRT
scoring from a fitted lavaan object (as stored in `fit_lavaan_obj$fit`).
The returned pieces are aligned to the row order of `Lambda`, which is
critical for correct downstream scoring.

Specifically, this function returns:

- `Lambda`: factor loading matrix.

- `theta_diag`: residual variances (diagonal of `theta`), reordered to
  `rownames(Lambda)` when names are available.

- `tau`: thresholds from `tau`, reordered to `rownames(Lambda)` and with
  row suffixes like `"|t1"` removed.

- `nu`: indicator intercepts; defaults to zero when unavailable.

- `Psi`: latent covariance matrix (`psi`).

## Usage

``` r
extract_tirt_params(fit_lavaan_obj)
```

## Arguments

- fit_lavaan_obj:

  A fitted object containing a lavaan fit in `$fit`. For example, an
  object produced by a wrapper that stores a lavaan model under
  `fit_lavaan_obj$fit`.

## Value

A named list with elements: `Lambda`, `theta_diag`, `tau`, `nu`, and
`Psi`.

## Details

Threshold rows in lavaan are often named like `"item|t1"`. This function
strips everything after `"|"` before matching thresholds to indicators.

## Examples

``` r
library(thurstonianIRT)
#> Loading required package: Rcpp
data("triplets")
# define the blocks of items
blocks <-
  set_block(c("i1", "i2", "i3"), traits = c("t1", "t2", "t3"),
            signs = c(1, 1, 1)) +
  set_block(c("i4", "i5", "i6"), traits = c("t1", "t2", "t3"),
            signs = c(-1, 1, 1)) +
  set_block(c("i7", "i8", "i9"), traits = c("t1", "t2", "t3"),
            signs = c(1, 1, -1)) +
  set_block(c("i10", "i11", "i12"), traits = c("t1", "t2", "t3"),
            signs = c(1, -1, 1))
# generate the data to be understood by 'thurstonianIRT'
triplets_long <- make_TIRT_data(
  data = triplets, blocks = blocks, direction = "larger",
  format = "pairwise", family = "bernoulli", range = c(0, 1)
)
# fit the data using lavaan
fit <- fit_TIRT_lavaan(triplets_long)
pars <- extract_tirt_params(fit)
```
