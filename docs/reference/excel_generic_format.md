# Format an Excel worksheet with styles, comments, and frozen panes

Applies consistent formatting to an existing worksheet in an openxlsx
workbook. Handles header styling, cell borders, number formatting,
column auto-widths, frozen panes, and optional comments on column
headers.

## Usage

``` r
excel_generic_format(
  df,
  workbook,
  sheet = "output",
  title = NULL,
  comment = NULL,
  numFmt = "#0.00"
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

## Value

Called for its side effects. Modifies `workbook` in place; returns
`NULL` invisibly.

## Details

The function assumes that
[`openxlsx::writeData()`](https://rdrr.io/pkg/openxlsx/man/writeData.html)
has already been used to write the data to the worksheet, with both
`colNames = TRUE` and `rowNames = TRUE`, as it offsets column indices by
1 to account for the row name column.

Formatting applied:

- Thin gray borders on all data cells

- Thin black borders on the header row and row name column

- Column widths set to auto

- First row and first column frozen

- Base font set to Liberation Sans 10pt

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
filename <- "excel_generic.xlsx"
if (file.exists(filename)) file.remove(filename)
#> [1] TRUE
wb <- openxlsx::createWorkbook()
openxlsx::addWorksheet(wb, "sheet")
openxlsx::addWorksheet(wb, "correlation")
openxlsx::writeData(wb, sheet = "sheet", x = mtcars, colNames = TRUE, rowNames = TRUE)
openxlsx::writeData(wb, sheet = "correlation", x = mtcor, colNames = TRUE, rowNames = TRUE)
excel_generic_format(
  df = mtcars, workbook = wb, sheet = "sheet", title = "test",
  comment = comment, numFmt = "#0.00"
)
excel_generic_format(
  df = mtcor, workbook = wb, sheet = "correlation", title = "correlation",
  comment = comment, numFmt = "#0.00"
)
openxlsx::saveWorkbook(wb, invisible(paste(filename)), TRUE)
```
