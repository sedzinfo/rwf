# Check for Heywood Cases and Related SEM Estimation Problems

Screens a fitted lavaan model for common warning signs such as negative
variances, impossible standardized values, unusually large standard
errors, and convergence failure.

In simple terms: this is a quick model health check. It tells you
whether your solution contains suspicious estimates that often indicate
misspecification, weak identification, or numerical instability.

## Usage

``` r
check_heywood(fit_model, verbose = TRUE)
```

## Arguments

- fit_model:

  A fitted lavaan model object, for example the result of a call to
  [`lavaan::cfa()`](https://rdrr.io/pkg/lavaan/man/cfa.html),
  [`lavaan::sem()`](https://rdrr.io/pkg/lavaan/man/sem.html) or related
  wrappers.

- verbose:

  Logical. If `TRUE` (default), prints diagnostic sections and a summary
  to the console. If `FALSE`, only returns results.

## Value

An invisible list with:

- `has_issues`: Logical, `TRUE` if any issue was detected.

- `issues`: Named list of detected issue tables / messages.

- `converged`: `lavaan::lavInspect(fit_model, "converged")`, the logical
  convergence flag of the fit.

## Details

The function checks:

- Negative variances (`~~` with `lhs == rhs` and estimate \< 0).

- Negative residual variances in Thurstonian style parameters (`~*~`
  with estimate \< 0).

- Standardized loadings outside \[-1, 1\].

- Standardized correlations outside \[-1, 1\].

- Extremely large standard errors (`se > 10`).

- Non-convergence.

A Heywood case usually refers to impossible estimates like negative
variances or standardized loadings greater than 1 in absolute value.

## Examples

``` r
library(lavaan)
#> This is lavaan 0.7-3
#> lavaan is FREE software! Please report any bugs.

# Example model
HS.model <- '
  visual  =~ x1 + x2 + x3
  textual =~ x4 + x5 + x6
  speed   =~ x7 + x8 + x9
'

fit <- cfa(HS.model, data = HolzingerSwineford1939)

# Verbose diagnostic output
chk <- check_heywood(fit, verbose = TRUE)
#> 
#> === SUMMARY ===
#> ✓ No Heywood cases or major issues detected!

# Programmatic use
check_heywood(fit, verbose = TRUE)
#> 
#> === SUMMARY ===
#> ✓ No Heywood cases or major issues detected!
```
