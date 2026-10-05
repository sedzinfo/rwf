# Convert a string to proper case

Capitalises the first character and lowercases the rest of each element.

## Usage

``` r
str_proper(x)
```

## Arguments

- x:

  Character vector.

## Value

A character vector of the same length as `x`.

## Examples

``` r
x <- generate_string(nchar = 10, vector = LETTERS, vector_length = 10)
str_proper(x)
#>  [1] "Spjddiwzhb" "Gqlakpqinr" "Psokpfjdwv" "Cajebczuoz" "Idotyzzere" "Trulkkmmdn" "Alkhdlxhcf" "Onesqtshed" "Kizmlzmwpo" "Ezzkyludqq"
```
