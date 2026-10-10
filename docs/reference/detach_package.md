# Detach and unload a package

Removes a package from the R search path and unloads its namespace. If
the package was attached more than once, all instances are removed. Does
nothing if the package is not currently attached.

## Usage

``` r
detach_package(package)
```

## Arguments

- package:

  Character string, the name of the package to detach (without the
  `"package:"` prefix), e.g. `"ggplot2"`.

## Value

Invisibly returns `NULL`. Called for its side effect of detaching the
package.
