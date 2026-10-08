# Print a formatted console output block with separators

Prints a heading, optional instructions, and optional output to the
console, surrounded by `#` separator lines for visual clarity.

## Usage

``` r
output_separator(
  string,
  output = NULL,
  instruction = NULL,
  length = getOption("width")/4
)
```

## Arguments

- string:

  Character. The title displayed between the main separators.

- output:

  Object or `NULL`. The main content to print below the heading. If
  `NULL`, nothing is printed in its place. Default is `NULL`.

- instruction:

  Character or `NULL`. Explanatory text printed between the heading and
  the output, followed by a shorter separator. Default is `NULL`.

- length:

  Numeric. Width of the main separator in characters. Default is one
  quarter of the current console width (`getOption("width") / 4`).

## Value

Called for its side effects. Returns `NULL` invisibly.

## Examples

``` r
output_separator(string = "TEST", output = "TEST", instruction = "TEST", length = 100)
#> [1] "####################################################################################################"
#> [1] "TEST"
#> [1] "####################################################################################################"
#> [1] "TEST"
#> [1] "##################################################"
#> [1] "TEST"
output_separator(string = "TEST", instruction = "TEST", length = 100)
#> [1] "####################################################################################################"
#> [1] "TEST"
#> [1] "####################################################################################################"
#> [1] "TEST"
#> [1] "##################################################"
output_separator(string = "TEST", output = "TEST", length = 100)
#> [1] "####################################################################################################"
#> [1] "TEST"
#> [1] "####################################################################################################"
#> [1] "TEST"
output_separator(string = "TEST")
#> [1] "##################################################"
#> [1] "TEST"
#> [1] "##################################################"
```
