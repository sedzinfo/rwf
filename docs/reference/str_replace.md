# Replace the first pattern match in a string

Replaces only the first occurrence of `pattern` in each element of
`string`. For replacing all occurrences use `str_replace_all`.

## Usage

``` r
str_replace(string, pattern, replacement)
```

## Arguments

- string:

  A character vector.

- pattern:

  A regular expression string or a literal string wrapped in
  [`fixed()`](https://sedzinfo.github.io/rwf/reference/fixed.md).

- replacement:

  A character string to replace the first match with.

## Value

A character vector the same length as `string`.

## Examples

``` r
# Only the first "o" is replaced
str_replace("hello world", "o", "0")
#> [1] "hell0 world"

# Remove leading zero (first match only)
str_replace("007 bond", "^0+", "")
#> [1] "7 bond"

# Fixed match: replace first literal dot
str_replace("a.b.c", fixed("."), "-")
#> [1] "a-b.c"
```
