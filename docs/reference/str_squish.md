# Remove leading, trailing, and internal extra whitespace

Strips leading and trailing whitespace and collapses any internal
sequences of whitespace (spaces, tabs, newlines) down to a single space.

## Usage

``` r
str_squish(string)
```

## Arguments

- string:

  A character vector.

## Value

A character vector the same length as `string`.

## Examples

``` r
# Remove extra internal spaces
str_squish("  hello   world  ")
#> [1] "hello world"

# Clean up messy column names or labels
str_squish(c("  first  name ", "last  name", "  age"))
#> [1] "first name" "last name"  "age"       

# Handles tabs and newlines too
str_squish("line1\n\nline2\t\tword")
#> [1] "line1 line2 word"
```
