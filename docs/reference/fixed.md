# Mark a pattern as a fixed string

Flags a pattern to be interpreted as a literal string rather than a
regular expression. Pass the result to `str_replace`, `str_replace_all`,
`str_count`, or `str_split_fixed` wherever you want exact character
matching instead of regex matching.

## Usage

``` r
fixed(pattern)
```

## Arguments

- pattern:

  A character string to match literally.

## Value

The same character string with class `"fixed_pattern"`.

## Examples

``` r
# Without fixed(), "." matches any character (regex)
str_replace_all("a.b.c", ".", "-")
#> [1] "-----"

# With fixed(), "." matches only a literal dot
str_replace_all("a.b.c", fixed("."), "-")
#> [1] "a-b-c"
```
