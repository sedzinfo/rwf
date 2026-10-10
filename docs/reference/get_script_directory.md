# Get script directory

Returns the directory of the currently active script as a string with a
trailing slash. Works across multiple environments: RStudio, command
line execution, and generic R sessions.

## Usage

``` r
get_script_directory()
```

## Value

A character string with the directory path, always ending with "/"

## Details

The function tries three approaches in order:\
1. If RStudio is available, uses `rstudioapi` to get the active document
path\
2. If running from the command line via `Rscript --file=`, parses the
file argument\
3. Falls back to [`getwd()`](https://rdrr.io/r/base/getwd.html) as a
last resort

## Note

The fallback to [`getwd()`](https://rdrr.io/r/base/getwd.html) may not
reflect the script's actual location if the working directory has been
changed during the session.

## Examples

``` r
# Returns the directory of the active script in RStudio
directory <- get_script_directory()
directory
#> [1] "C:/Users/dzach/Documents/GitHub/rwf/docs/reference/"
```
