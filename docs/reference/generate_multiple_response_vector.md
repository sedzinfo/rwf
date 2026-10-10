# Generate a multiple response vector

Creates a character vector where each element contains a comma-separated
string of randomly sampled categories, simulating multiple response
survey data.

## Usage

``` r
generate_multiple_response_vector(
  responses = 1:4,
  responded = 1:4,
  length = 10
)
```

## Arguments

- responses:

  Integer or character vector. The pool of unique response categories to
  sample from. A single number `n` means the categories `1:n` (e.g.
  `responses = 4` is the same as `1:4`). Default is `1:4`.

- responded:

  Integer vector. Controls how many categories are selected per
  observation — one value is sampled from this vector at each iteration.
  A single number `k` means "up to `k`": each observation gets a random
  number of categories between 1 and `k` (e.g. `responded = 3` gives 1,
  2 or 3 categories). The values should not exceed the number of
  categories in `responses`. Default is `1:4`.

- length:

  Integer. Number of observations to generate. Default is `10`.

## Value

A character vector of length `length`, where each element is a
comma-separated string of sampled response categories.

## Examples

``` r
generate_multiple_response_vector(responses = 1:4, responded = 1:4, length = 10)
#>  [1] "1"          "2, 4, 1, 3" "1, 2"       "4, 2, 3, 1" "4, 3, 2, 1" "3, 1, 2"    "4, 1, 3, 2" "2, 3, 1, 4" "2, 4, 1"    "2, 3"      
```
