# Get the names of objects passed through dots

Returns the unevaluated expressions passed in `...` as character
strings. Internal helper used by
[`c_bind`](https://sedzinfo.github.io/rwf/reference/c_bind.md) to name
the columns of its output.

## Usage

``` r
dotnames(...)
```

## Arguments

- ...:

  Objects whose expressions should be returned as names.

## Value

A character vector with one element per argument in `...`.

## Author

Ananda Mahto
