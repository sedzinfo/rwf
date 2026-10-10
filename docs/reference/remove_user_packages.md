# Remove all user-installed packages

Uninstalls every package that is not part of the R base or recommended
distribution. Packages installed in Microsoft R Open (MRO) library paths
are also preserved. Only packages with no `Priority` field (i.e. neither
`"base"` nor `"recommended"`) are removed. **Warning:** this operation
is irreversible. All third-party packages will need to be reinstalled
afterwards.

## Usage

``` r
remove_user_packages()
```

## Value

Invisibly returns a named list holding the result of
[`remove.packages()`](https://rdrr.io/r/utils/remove.packages.html) for
each removed package (one element per package). Called primarily for its
side effect of uninstalling packages.
