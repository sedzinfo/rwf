# Generate a data frame of random factor vectors

Creates a data frame (or single factor) populated with factor values
sampled from a supplied pool, either randomly or in a balanced
distribution across levels.

## Usage

``` r
generate_factor(vector = LETTERS[1:5], nrows = 2, ncols = 10, type = "random")
```

## Arguments

- vector:

  Character vector. The pool of factor levels to sample from. Default is
  `LETTERS[1:5]`.

- nrows:

  Integer. Number of rows to generate. For `type = "balanced"`, `nrows`
  should be divisible by `length(vector)`. Default is `2`.

- ncols:

  Integer. Number of columns to generate. When `ncols = 1`, a single
  factor vector is returned instead of a data frame. Default is `10`.

- type:

  Character. Sampling method. One of:

  - `"random"` — each value is sampled independently with replacement.

  - `"balanced"` — each level appears exactly `nrows / length(vector)`
    times per column.

  Default is `"random"`.

## Value

A data frame of factors with `nrows` rows and `ncols` columns, or a
single factor vector when `ncols = 1`.

## Examples

``` r
generate_factor(vector = LETTERS[1:5], ncols = 5, nrows = 10, type = "random")
#>    X1 X2 X3 X4 X5
#> 1   C  D  B  A  B
#> 2   B  D  E  B  E
#> 3   A  B  C  C  D
#> 4   B  E  D  A  A
#> 5   A  B  B  B  D
#> 6   A  A  C  A  C
#> 7   E  C  D  B  B
#> 8   C  C  A  A  E
#> 9   A  A  B  E  D
#> 10  B  D  B  E  D
generate_factor(vector = LETTERS[1:5], ncols = 5, nrows = 10, type = "balanced")
#>    X1 X2 X3 X4 X5
#> 1   A  A  A  A  A
#> 2   A  A  A  A  A
#> 3   B  B  B  B  B
#> 4   B  B  B  B  B
#> 5   C  C  C  C  C
#> 6   C  C  C  C  C
#> 7   D  D  D  D  D
#> 8   D  D  D  D  D
#> 9   E  E  E  E  E
#> 10  E  E  E  E  E
generate_factor(vector = LETTERS[1:5], ncols = 1, nrows = 10, type = "balanced")
#>  [1] A A B B C C D D E E
#> Levels: A B C D E
generate_factor(vector = LETTERS[1:5], ncols = 1, nrows = 10, type = "random")
#>  [1] E C E C E A D A A B
#> Levels: A B C D E
```
