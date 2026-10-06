# Generate a multiple response vector

Creates a character vector where each element contains a comma-separated
string of randomly sampled categories, simulating multiple response
survey data.

## Usage

``` r
generate_multiple_responce_vector(
  responces = 1:4,
  responded = 1:4,
  length = 10
)
```

## Arguments

- responces:

  Integer or character vector. The pool of unique response categories to
  sample from. Default is `1:4`.

- responded:

  Integer vector. Controls how many categories are selected per
  observation — one value is sampled from this vector at each iteration.
  Default is `1:4`.

- length:

  Integer. Number of observations to generate. Default is `10`.

## Value

A character vector of length `length`, where each element is a
comma-separated string of sampled response categories.

## Examples

``` r
generate_multiple_responce_vector(responces = 1:4, responded = 1:4, length = 10)
#>  [1] "1"          "2, 4, 1, 3" "1, 2"       "4, 2, 3, 1" "4, 3, 2, 1" "3, 1, 2"    "4, 1, 3, 2" "2, 3, 1, 4" "2, 4, 1"    "2, 3"      
```
