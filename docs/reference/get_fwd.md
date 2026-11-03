# Get the file path of the currently running script

Returns the normalised absolute path of the R script that is currently
executing. The function tries the following methods in order:

1.  The `--file=` command-line argument (set when running via
    `Rscript script.R`).

2.  The `fileName` variable in the first call-stack frame (set by some
    IDEs).

3.  The `ofile` variable in the first call-stack frame (set when the
    script is loaded with
    [`source()`](https://rdrr.io/r/base/source.html)).

4.  The active document path from `rstudioapi` (RStudio only).

5.  The source editor path from `rstudioapi` as a fallback.

## Usage

``` r
get_fwd()
```

## Value

A character string containing the normalised absolute path of the
current script, or an empty string (`""`) if the path cannot be
determined.

## Examples

``` r
filename<-get_fwd()
filename
#> [1] ""
```
