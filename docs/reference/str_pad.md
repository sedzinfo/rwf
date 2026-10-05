# Pad a string to a minimum width

Pads `string` with `pad` characters on the left, right, or both sides
until it reaches at least `width` characters. Strings already at or
exceeding `width` are returned unchanged.

## Usage

``` r
str_pad(string, width, side = "right", pad = " ")
```

## Arguments

- string:

  A character vector.

- width:

  Integer. Minimum total width of the output string.

- side:

  One of `"right"` (default), `"left"`, or `"both"`.

- pad:

  A single character to use for padding. Default `" "`.

## Value

A character vector the same length as `string`.

## Examples

``` r
# Zero-pad single digit numbers on the left
str_pad(c("1", "10", "100"), width = 3, side = "left", pad = "0")
#> [1] "001" "010" "100"

# Right-pad to align labels
str_pad(c("Name", "Age", "Score"), width = 10)
#> [1] "Name      " "Age       " "Score     "

# Pad on both sides (centers the string)
str_pad("hello", width = 11, side = "both")
#> [1] "   hello   "
```
