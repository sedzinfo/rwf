# Last observation carried forward (LOCF) imputation

Replaces each `NA` in a vector with the most recent preceding non-`NA`
value (last observation carried forward, LOCF). If the first element is
`NA`, it is replaced with the first non-`NA` value found anywhere in the
vector. To apply LOCF to every column of a data frame use
`df[] <- lapply(df, replace_na_with_previous)`.

## Usage

``` r
replace_na_with_previous(vector)
```

## Arguments

- vector:

  A vector of any type that may contain `NA` values.

## Value

A vector of the same length and type as `vector` with `NA` values
replaced by the preceding non-`NA` element. Returns the original vector
unchanged if it contains no `NA` values.

## Examples

``` r
df1 <- generate_missing(rnorm(10), missing = 5)
df2 <- generate_missing(rnorm(10), missing = 5)
df3 <- generate_missing(rnorm(10), missing = 5)
df4 <- generate_missing(rnorm(10), missing = 5)
df5 <- generate_missing(rnorm(10), missing = 5)
df <- data.frame(df1, df2, df3, df4, df5)
row.names(df) <- paste0("A", row.names(df))
replace_na_with_previous(df1)
#>  [1] -0.3821 -0.3821 -0.3821 -0.3821  1.6417  1.2351  1.2351  1.2351  0.6362  0.6985
df[] <- lapply(df, replace_na_with_previous)
```
