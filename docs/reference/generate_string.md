# Generate random strings

Produces a character vector of random strings by sampling from a
character pool.

## Usage

``` r
generate_string(
  vector = c(LETTERS, letters, 0:9),
  vector_length = 1,
  nchar = 5
)
```

## Arguments

- vector:

  Character vector. The pool of characters to sample from. Default is
  `c(LETTERS, letters, 0:9)`.

- vector_length:

  Integer. Number of strings to generate. Default is `1`.

- nchar:

  Integer. Length of each generated string. Default is `5`.

## Value

A character vector of length `vector_length`.

## Examples

``` r
generate_string(nchar = 10)
#> [1] "Hzb05boyCm"
generate_string(nchar = 10, vector_length = 10)
#>  [1] "so6QPQWylf" "R1nPUgm6YC" "7WoVOIss0v" "I0aSKjGQyj" "z4jRhpy26A" "XuJoPMgMLJ" "ka08cjDyxM" "JaXYjflqfB" "iN5BIpBK49" "PV9heTGcNU"
```
