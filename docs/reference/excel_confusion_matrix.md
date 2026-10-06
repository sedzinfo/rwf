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
#>        6     0    0    0    0    1    1    0    0    0
#>        7     0    0    2    6   22   20    0    0    0
#>        8     0    2   32  156  240  149   34    3    0
#>        9     1   19  125  604  932  610  146   15    1
#>        10    1   32  237  908 1441  948  264   25    0
#>        11    0   12  147  578  905  558  150   17    1
#>        12    0    4   41  156  214  158   25    1    0
#>        13    0    0    5   16   23    9    2    0    0
#>        14    0    0    0    0    0    1    0    0    0
cm <- confusion_matrix_percent(observed, predicted)
wb <- openxlsx::createWorkbook()
excel_confusion_matrix(cm, wb)
openxlsx::saveWorkbook(wb, invisible(paste(filename)), TRUE)
```
