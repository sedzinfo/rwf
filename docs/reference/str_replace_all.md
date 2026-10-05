# Replace all pattern matches in a string

Replaces every occurrence of `pattern` in `string` with `replacement`.
Supports both regular expressions and literal string matching via
[`fixed()`](https://sedzinfo.github.io/rwf/reference/fixed.md).

## Usage

``` r
str_replace_all(string, pattern, replacement)
```

## Arguments

- string:

  A character vector.

- pattern:

  A regular expression string, or a literal string wrapped in
  [`fixed()`](https://sedzinfo.github.io/rwf/reference/fixed.md), or a
  named character vector where names are regex patterns and values are
  replacements (applied sequentially).

- replacement:

  A character string to replace each match with. Use `""` to delete
  matches.

## Value

A character vector the same length as `string`.

## Examples

``` r
# Regex replacement
str_replace_all("hello world", "o", "0")
#> [1] "hell0 w0rld"

# Fixed (literal) replacement
str_replace_all("a.b.c", fixed("."), "-")
#> [1] "a-b-c"

# Remove all spaces
str_replace_all("remove all spaces", fixed(" "), "")
#> [1] "removeallspaces"

# Named vector: multiple replacements applied in order
str_replace_all("aabbcc", c("a" = "X", "b" = "Y"))
#> [1] "XXYYcc"
```
