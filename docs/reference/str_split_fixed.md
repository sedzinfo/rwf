# Split strings into a fixed-width matrix of pieces

Splits each element of `string` by `pattern` and returns a character
matrix with exactly `n` columns. If a string produces fewer than `n`
pieces the remaining columns are filled with `""`.

## Usage

``` r
str_split_fixed(string, pattern, n)
```

## Arguments

- string:

  A character vector.

- pattern:

  A regular expression string or a literal string wrapped in
  [`fixed()`](https://sedzinfo.github.io/rwf/reference/fixed.md).

- n:

  Integer. Number of columns in the output matrix.

## Value

A character matrix with `length(string)` rows and `n` columns.

## Examples

``` r
# Split "trait.method" labels into two columns
str_split_fixed(c("speed.run", "height.jump", "weight.lift"), fixed("."), 2)
#>      [,1]     [,2]  
#> [1,] "speed"  "run" 
#> [2,] "height" "jump"
#> [3,] "weight" "lift"

# Split on a regex pattern
str_split_fixed(c("a1b", "c2d", "e3f"), "[0-9]", 2)
#>      [,1] [,2]
#> [1,] "a"  "b" 
#> [2,] "c"  "d" 
#> [3,] "e"  "f" 

# Fewer pieces than n: remainder filled with ""
str_split_fixed(c("a.b.c", "x.y"), fixed("."), 3)
#>      [,1] [,2] [,3]
#> [1,] "a"  "b"  "c" 
#> [2,] "x"  "y"  ""  
```
