# Write a matrix or data frame to an Excel worksheet with optional conditional formatting

Creates a new worksheet in an openxlsx workbook, writes the data, and
applies formatting via
[`excel_generic_format`](https://sedzinfo.github.io/rwf/reference/excel_generic_format.md).
Optionally adds a red-yellow-green colour scale for value ranges and
highlights the diagonal cells in red, which is useful for correlation
matrices.

## Usage

``` r
excel_matrix(
  df,
  workbook,
  sheet = "output",
  title = NULL,
  comment = NULL,
  numFmt = "#0.00",
  conditional_formatting = FALSE,
  diagonal = FALSE,
  diagonal_length = nrow(df)
)
```

## Arguments

- df:

  A data frame or matrix whose structure determines column formatting.
  Integer columns receive whole-number formatting; non-integer numeric
  columns receive the format specified by `numFmt`.

- workbook:

  An openxlsx workbook object created with
  [`openxlsx::createWorkbook()`](https://rdrr.io/pkg/openxlsx/man/createWorkbook.html).

- sheet:

  Character. Name of the worksheet to format. Must already exist in
  `workbook`. Default is `"output"`.

- title:

  Character or `NULL`. If provided, written as a hidden comment on cell
  A1. Default is `NULL`.

- comment:

  A named list or `NULL`. Each name should match a column name in `df`;
  the value is the comment text added to that column's header cell.
  Names not found in `df` are silently ignored. Default is `NULL`.

- numFmt:

  Character. Excel number format string applied to non-integer numeric
  columns. Default is `"#0.00"`.

- conditional_formatting:

  Logical. If `TRUE`, applies a red-yellow-green colour scale to all
  data cells, where low values are red, mid values yellow, and high
  values green. Default is `FALSE`.

- diagonal:

  Logical. If `TRUE`, fills diagonal cells with a red background. Only
  applied when the data frame is square (`nrow == ncol`). Default is
  `FALSE`.

- diagonal_length:

  Integer. Number of diagonal cells to highlight when `diagonal = TRUE`.
  Defaults to `nrow(df)`.

## Value

Called for its side effects. Adds a formatted worksheet to `workbook`;
returns `NULL` invisibly.

## Details

Unlike
[`excel_generic_format`](https://sedzinfo.github.io/rwf/reference/excel_generic_format.md),
this function creates the worksheet and writes the data internally — do
not call `addWorksheet()` or `writeData()` beforehand. The diagonal
highlight is skipped silently for non-square data frames.

## See also

[`excel_generic_format`](https://sedzinfo.github.io/rwf/reference/excel_generic_format.md)

## Examples

``` r
comment <- list(
  mpg = "Miles/(US) gallon",
  cyl = "Number of cylinders",
  disp = "Displacement (cu.in.)",
  hp = "Gross horsepower",
  drat = "Rear axle ratio",
  wt = "Weight (1000 lbs)",
  qsec = "1/4 mile time",
  vs = "Engine (0=V-shaped,1=straight)",
  am = "Transmission (0=automatic,1=manual)",
  gear = "Number of forward gears",
  carb = "Number of carburetors",
  extra_comment1 = "test1",
  extra_comment2 = "test2"
)
mtcor <- data.frame(cor(mtcars))
file <- file.path(tempdir(), "excel_matrix.xlsx")
if (file.exists(file)) file.remove(file)
wb <- openxlsx::createWorkbook()
excel_matrix(mtcars, wb,
  sheet = "matrix", comment = comment,
  conditional_formatting = TRUE, diagonal = FALSE
)
excel_matrix(mtcars, wb,
  sheet = "diagonal_non_square", comment = comment,
  conditional_formatting = FALSE, diagonal = TRUE
)
excel_matrix(mtcars[1:10, 1:10], wb,
  sheet = "diagonal_square", comment = comment[1:10],
  conditional_formatting = FALSE, diagonal = TRUE
)
excel_matrix(mtcars, wb,
  sheet = "matrix_diagonal_non_square", comment = comment,
  conditional_formatting = TRUE, diagonal = TRUE
)
excel_matrix(mtcars[1:10, 1:10], wb,
  sheet = "matrix_diagonal_square", comment = comment[1:10],
  conditional_formatting = TRUE, diagonal = TRUE
)
excel_matrix(mtcor, wb,
  sheet = "r", comment = comment,
  conditional_formatting = FALSE, diagonal = FALSE
)
excel_matrix(mtcor, wb,
  sheet = "conditional_formatting_r", comment = comment,
  conditional_formatting = TRUE, diagonal = TRUE
)
openxlsx::saveWorkbook(wb, file, TRUE)
```
