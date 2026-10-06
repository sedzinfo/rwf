# Write matrix or dataframe to excel sheet

Usefull for correlation matrices since it uses conditional formatting
for matrices

## Usage

``` r
excel_confusion_matrix(
  df,
  workbook,
  title = "Rows: Expected Collumns: Observed"
)
```

## Arguments

- df:

  dataframe or matrix

- workbook:

  workbook

- title:

  comment

## Examples

``` r
filename <- "excel_confusion_matrix.xlsx"
if (file.exists(filename)) file.remove(filename)
#> [1] TRUE
observed <- factor(round(rnorm(10000, m = 10, sd = 1)))
predicted <- factor(round(rnorm(10000, m = 10, sd = 1)))
confusion(observed, predicted)
#>          observed
#> predicted    6    7    8    9   10   11   12   13   14
#>        6     0    0    0    1    2    0    1    0    0
#>        7     0    0    2   15   24   15    3    0    0
#>        8     0    4   38  170  246  136   47    4    0
#>        9     1   11  152  565  921  569  152   10    3
#>        10    1   19  229  900 1418  952  240   26    0
#>        11    2   12  158  619  891  592  134   13    0
#>        12    0    7   34  159  247  139   43    7    0
#>        13    0    0    5   16   18   20    5    1    0
#>        14    0    0    0    1    0    0    0    0    0
cm <- confusion_matrix_percent(observed, predicted)
wb <- openxlsx::createWorkbook()
excel_confusion_matrix(cm, wb)
openxlsx::saveWorkbook(wb, invisible(paste(filename)), TRUE)
```
