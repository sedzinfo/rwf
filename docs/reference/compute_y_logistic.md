# Compute y for logistic function

This function requires x range to produce a vector with y values

## Usage

``` r
compute_y_logistic(intercept, coefficient, x)
```

## Arguments

- intercept:

  Numeric

- coefficient:

  Numeric

- x:

  Numeric

## Examples

``` r
x <- -10:10
compute_y_logistic(0, 1, x)
#>  [1] 4.539787e-05 1.233946e-04 3.353501e-04 9.110512e-04 2.472623e-03 6.692851e-03 1.798621e-02 4.742587e-02 1.192029e-01 2.689414e-01 5.000000e-01 7.310586e-01 8.807971e-01 9.525741e-01 9.820138e-01
#> [16] 9.933071e-01 9.975274e-01 9.990889e-01 9.996646e-01 9.998766e-01 9.999546e-01
compute_y_logistic(0, 1, 1)
#> [1] 0.7310586
plot(x, compute_y_logistic(0, 1, x), type = "l")
grid()
abline(b = 0, a = .5)
```
