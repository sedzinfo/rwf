# Row and column indices around the diagonal of a square matrix

For each diagonal position `i` of a `length` x `length` matrix, returns
the indices of the diagonal cell and of its two neighbours in the same
row: the cell to the right (just above the diagonal, column `i + 1`) and
the cell to the left (just below the diagonal, column `i - 1`).

## Usage

``` r
off_diagonal_index(length)
```

## Arguments

- length:

  Integer (at least 1). Number of rows and columns of the square matrix.

## Value

A data frame (not a matrix) with `length` rows and four numeric columns:

- x1:

  Row index `i`.

- x2:

  Column index of the diagonal cell (same as `x1`).

- x3:

  Column index of the cell to the right, `i + 1`; in the last row this
  is `length + 1`, outside the matrix.

- x4:

  Column index of the cell to the left, `i - 1`; in the first row this
  is `0`, outside the matrix.

## See also

[`matrix_triangle`](https://sedzinfo.github.io/rwf/reference/matrix_triangle.md)

## Examples

``` r
off_diagonal_index(length=6)
#>   x1 x2 x3 x4
#> 1  1  1  2  0
#> 2  2  2  3  1
#> 3  3  3  4  2
#> 4  4  4  5  3
#> 5  5  5  6  4
#> 6  6  6  7  5
```
