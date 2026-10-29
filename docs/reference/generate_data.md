# Generate a data frame of random numbers

Creates a data frame populated with either normally or uniformly
distributed random values, useful for testing and simulation.

## Usage

``` r
generate_data(
  nrows = 10,
  ncols = 5,
  mean = 0,
  sd = 1,
  min = 1,
  max = 5,
  type = "normal"
)
```

## Arguments

- nrows:

  Integer. Number of rows to generate. Default is `10`.

- ncols:

  Integer. Number of columns to generate. Default is `5`.

- mean:

  Numeric. Mean of the normal distribution. Only used when
  `type = "normal"`. Default is `0`.

- sd:

  Numeric. Standard deviation of the normal distribution. Only used when
  `type = "normal"`. Default is `1`.

- min:

  Integer. Minimum value of the uniform distribution. Only used when
  `type = "uniform"`. Default is `1`.

- max:

  Integer. Maximum value of the uniform distribution. Only used when
  `type = "uniform"`. Default is `5`.

- type:

  Character. Distribution to sample from. One of `"normal"` or
  `"uniform"`. Default is `"normal"`.

## Value

A data frame with `nrows` rows and `ncols` columns of randomly generated
numeric values.

## Examples

``` r
generate_data(nrows = 10, ncols = 5, mean = 0, sd = 1, type = "normal")
#>          X1      X2        X3       X4       X5
#> 1   0.94488  1.2176  0.766118  1.31139 -0.18585
#> 2  -1.25487 -1.2320  0.218231  0.94533 -0.74540
#> 3  -1.01280 -0.1099  1.824803  1.20204 -1.58977
#> 4   0.06982  0.6903 -2.686737  0.29194  0.05546
#> 5   1.73867  0.6826  2.080771 -1.44722  0.66852
#> 6  -0.54204 -0.4290 -0.670133 -0.30420  0.35398
#> 7  -0.48568 -0.8877 -0.172634 -0.08002  0.77175
#> 8  -0.40318  1.1987 -0.852113  0.22825  0.56622
#> 9   0.10913  0.5136  0.783902 -1.04528 -1.42042
#> 10 -0.09981  1.3459  0.008476 -1.20273 -1.19551
generate_data(nrows = 10, ncols = 5, min = 1, max = 5, type = "uniform")
#>    X1 X2 X3 X4 X5
#> 1   5  5  2  1  4
#> 2   1  4  2  4  4
#> 3   3  3  4  5  2
#> 4   2  1  3  2  4
#> 5   4  3  3  4  1
#> 6   1  4  2  4  2
#> 7   4  1  3  2  4
#> 8   4  3  4  1  3
#> 9   1  4  4  5  4
#> 10  4  5  4  3  1
```
