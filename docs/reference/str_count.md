# Count the number of pattern matches in a string

Returns the number of times `pattern` appears in each element of
`string`. Supports both regular expressions and literal string matching
via [`fixed()`](https://sedzinfo.github.io/rwf/reference/fixed.md).

## Usage

``` r
str_count(string, pattern)
```

## Arguments

- string:

  A character vector.

- pattern:

  A regular expression string or a literal string wrapped in
  [`fixed()`](https://sedzinfo.github.io/rwf/reference/fixed.md).

## Value

An integer vector the same length as `string`.

## Examples

``` r
# Count vowels
str_count(c("banana", "apple", "cherry"), "[aeiou]")
#> [1] 3 2 1

# Count literal semicolons (useful for delimited data)
str_count(c("a;b;c", "x;y", "z"), fixed(";"))
#> [1] 2 1 0

# Count digits
str_count(c("abc123", "99bottles", "none"), "[0-9]")
#> [1] 3 2 0
```
