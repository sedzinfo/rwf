# Convert a key vector to a list of question indices by dimension

Takes a scoring key that maps each question to a dimension and returns a
list where each element contains the indices of questions belonging to
that dimension.

## Usage

``` r
questions_by_keys(key)
```

## Arguments

- key:

  Integer vector. Each element indicates which dimension the
  corresponding question belongs to. Values must be consecutive integers
  starting from 1 up to the number of dimensions.

## Value

A named list of length `max(key)`, where element `i` contains the
integer indices of all questions assigned to dimension `i`.

## Examples

``` r
key <- c(1, 2, 3, 4, 5, 1, 2, 3, 4, 5)
questions_by_keys(key)
#> [[1]]
#> [1] 1 6
#> 
#> [[2]]
#> [1] 2 7
#> 
#> [[3]]
#> [1] 3 8
#> 
#> [[4]]
#> [1] 4 9
#> 
#> [[5]]
#> [1]  5 10
#> 
```
