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
#>          X1      X2       X3       X4       X5
#> 1  -1.35425  0.1780 -1.36158 -0.09007  0.86388
#> 2   0.49502 -0.4461  0.17216  1.50686 -0.01736
#> 3  -0.96206  0.1041  0.52451 -0.82594 -0.47750
#> 4   1.27902  0.2451  0.69042  0.30143  0.86276
#> 5  -0.71837 -1.9401  1.60314  0.20996 -1.22168
#> 6  -0.50149  1.7288  0.78945  0.05910 -0.12231
#> 7   0.54220  1.1423  0.18049 -0.45310  1.35633
#> 8   0.64862 -0.6098 -0.46896 -1.67255  0.39254
#> 9  -0.03785 -0.6122  1.04389 -0.10907  0.33079
#> 10 -0.74429 -0.2995 -0.03384 -0.18950 -1.65038
generate_data(nrows = 10, ncols = 5, min = 1, max = 5, type = "uniform")
#>    X1 X2 X3 X4 X5
#> 1   5  4  4  4  2
#> 2   3  5  1  5  3
#> 3   4  2  4  5  1
#> 4   2  1  2  1  2
#> 5   5  3  5  4  1
#> 6   3  4  1  4  2
#> 7   5  4  4  3  2
#> 8   2  1  5  4  5
#> 9   1  5  5  3  2
#> 10  3  1  5  4  2
```
