# Generate matrix lambda for specified number of comparisons

Generate matrix lambda for specified number of comparisons

## Usage

``` r
generate_matrix_lambda_hat(blocks = 3, items = 3)
```

## Arguments

- blocks:

  number of blocks

- items:

  number of items per block

## Examples

``` r
generate_matrix_lambda_hat(blocks=3,items=4)
#>       [,1] [,2] [,3] [,4]
#>  [1,]    1   -1    0    0
#>  [2,]    1    0   -1    0
#>  [3,]    1    0    0   -1
#>  [4,]    0    1   -1    0
#>  [5,]    0    1    0   -1
#>  [6,]    0    0    1   -1
#>  [7,]    1   -1    0    0
#>  [8,]    1    0   -1    0
#>  [9,]    1    0    0   -1
#> [10,]    0    1   -1    0
#> [11,]    0    1    0   -1
#> [12,]    0    0    1   -1
#> [13,]    1   -1    0    0
#> [14,]    1    0   -1    0
#> [15,]    1    0    0   -1
#> [16,]    0    1   -1    0
#> [17,]    0    1    0   -1
#> [18,]    0    0    1   -1
```
