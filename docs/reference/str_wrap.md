# Wrap long strings to a specified line width

Breaks a character string into multiple lines so that no line exceeds
`width` characters. Words are kept intact; lines are joined with `"\n"`.

## Usage

``` r
str_wrap(string, width = 80)
```

## Arguments

- string:

  A character vector.

- width:

  Maximum number of characters per line. Default `80`.

## Value

A character vector the same length as `string`, with embedded newlines
inserted at word boundaries.

## Examples

``` r
# Wrap at 30 characters
cat(str_wrap("The quick brown fox jumped over the lazy dog", width = 30))
#> The quick brown fox jumped
#> over the lazy dog

# Wrap a vector of strings
labels <- c("Short label", "A much longer label that needs wrapping")
str_wrap(labels, width = 20)
#> [1] "Short label"                              "A much longer label\nthat needs wrapping"
```
