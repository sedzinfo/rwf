# Create Pair Labels from Consecutive Triplets of Items

Builds pair labels from items grouped in triplets.

In simple terms: items are taken 3 at a time, and for each triplet the
function creates the three pair combinations: (1,2), (1,3), and (2,3).

Labels are returned as strings such as `"i1i2"`, `"i1i3"`, `"i2i3"` (or
with your chosen separator / prefix).

## Usage

``` r
name_triplet_pairs(n, prefix = "i", sep = "", strict = TRUE)
```

## Arguments

- n:

  Either:

  - A single integer (total number of items, e.g. `15`).

  - A vector of item indices (e.g. `4:18`).

- prefix:

  Character prefix added before each item index. Default is `"i"`.

- sep:

  Character separator inserted between the two item labels. Default is
  `""`.

- strict:

  Logical. If `TRUE` (default), stop with an error when the number of
  items is not a multiple of 3. If `FALSE`, silently drops leftover
  items so only complete triplets are used.

## Value

A character vector of pair labels.

## Details

If there are \\T\\ triplets, output length is \\3T\\, because each
triplet contributes exactly 3 pairs.

For one triplet `(a,b,c)`, the generated labels are: `ab`, `ac`, `bc`
(with chosen `prefix` and `sep`).

## Examples

``` r
# 15 items -> 5 triplets -> 15 pair labels
name_triplet_pairs(15)
#>  [1] "i1i2"   "i1i3"   "i2i3"   "i4i5"   "i4i6"   "i5i6"   "i7i8"   "i7i9"   "i8i9"   "i10i11" "i10i12" "i11i12" "i13i14" "i13i15" "i14i15"

# Custom separator
name_triplet_pairs(6, prefix = "i", sep = "_")
#> [1] "i1_i2" "i1_i3" "i2_i3" "i4_i5" "i4_i6" "i5_i6"

# Start from specific indices
name_triplet_pairs(4:9)
#> [1] "i4i5" "i4i6" "i5i6" "i7i8" "i7i9" "i8i9"
# triplets are (4,5,6) and (7,8,9)

# Non-multiple of 3 with strict=FALSE -> trims extras
name_triplet_pairs(10, strict = FALSE)
#> [1] "i1i2" "i1i3" "i2i3" "i4i5" "i4i6" "i5i6" "i7i8" "i7i9" "i8i9"

# Vector input with trimming when needed
name_triplet_pairs(4:18, strict = FALSE)
#>  [1] "i4i5"   "i4i6"   "i5i6"   "i7i8"   "i7i9"   "i8i9"   "i10i11" "i10i12" "i11i12" "i13i14" "i13i15" "i14i15" "i16i17" "i16i18" "i17i18"
```
