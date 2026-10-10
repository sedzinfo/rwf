# Write a data frame to Excel with per-column conditional formatting thresholds

Creates a new worksheet, writes the data, and applies
[`excel_generic_format`](https://sedzinfo.github.io/rwf/reference/excel_generic_format.md).
Additionally highlights cells in specified columns that meet one or two
threshold conditions, making it easy to flag critical or out-of-range
values.

## Usage

``` r
excel_critical_value(
  df,
  workbook,
  sheet = "output",
  title = NULL,
  comment = NULL,
  numFmt = "#0.00",
  critical = NULL
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

- critical:

  A named list or `NULL`. Each name must match a column in `df`. The
  value is either:

  - A single character string with an Excel expression (e.g. `"<0.05"`,
    `">20"`, `"=0"`). Matching cells are highlighted in red.

  - A character vector of length 2 with two expressions, for example
    `c(">20", "<11")`. The first condition highlights in red, the second
    in purple.

  `NA` cells in the target column are skipped. Default is `NULL`.

## Value

Called for its side effects. Adds a formatted worksheet to `workbook`;
returns `NULL` invisibly.

## Details

Unlike
[`excel_generic_format`](https://sedzinfo.github.io/rwf/reference/excel_generic_format.md),
this function creates the worksheet and writes the data internally — do
not call `addWorksheet()` or `writeData()` beforehand.

Threshold expressions follow Excel conditional formatting syntax and are
applied row by row, skipping `NA` values.

## See also

[`excel_generic_format`](https://sedzinfo.github.io/rwf/reference/excel_generic_format.md),
[`excel_matrix`](https://sedzinfo.github.io/rwf/reference/excel_matrix.md)

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
filename <- "excel_critical_value.xlsx"
if (file.exists(filename)) file.remove(filename)
#> [1] TRUE
wb <- openxlsx::createWorkbook()
df <- generate_missing(generate_correlation_matrix())
critical <- list(X1 = "<0.05", X5 = "<0")
excel_critical_value(
  df = df, workbook = wb, sheet = "critical", comment = list(X1 = "test"),
  numFmt = "#0.00", critical = critical
)
openxlsx::saveWorkbook(wb, invisible(paste(filename)), TRUE)
filename <- "excel_critical_value_comment.xlsx"
if (file.exists(filename)) file.remove(filename)
#> [1] TRUE
wb <- openxlsx::createWorkbook()
df <- generate_missing(mtcars)
critical <- list(mpg = ">20", am = "=0")
excel_critical_value(
  df = df, workbook = wb, sheet = "critical", comment = comment,
  numFmt = "#0.00", critical = critical
)
openxlsx::saveWorkbook(wb, invisible(paste(filename)), TRUE)
filename <- "excel_critical_value_comment_min_max.xlsx"
if (file.exists(filename)) file.remove(filename)
#> [1] TRUE
wb <- openxlsx::createWorkbook()
df <- generate_missing(mtcars)
critical <- list(mpg = c(">20", "<11"), am = "=0")
excel_critical_value(
  df = df, workbook = wb, sheet = "critical", comment = comment,
  numFmt = "#0.00", critical = critical
)
openxlsx::saveWorkbook(wb, invisible(paste(filename)), TRUE)
```
