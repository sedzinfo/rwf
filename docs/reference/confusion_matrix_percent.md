# Confusion matrix with row and column percent

Generates a confusion matrix from observed and predicted
values,including row and column percentages.

## Usage

``` r
confusion_matrix_percent(observed, predicted)
```

## Arguments

- observed:

  Vector of observed variables. These are the true class labels.

- predicted:

  Vector of predicted variables. These are the predicted class labels.

## Details

This function creates a confusion matrix by comparing the observed
(true) class labels with the predicted class labels. Additionally, it
calculates row and column percentages to provide a more detailed
performance analysis.

The function performs the following steps: 1. Computes the confusion
matrix from the observed and predicted values. 2. Calculates the overall
accuracy by dividing the sum of diagonal elements by the total number of
observations. 3. Appends row and column sums to the confusion matrix. 4.
Computes precision and recall for each class and appends these metrics
to the matrix. 5. Returns a formatted data frame with the confusion
matrix,row and column percentages,and overall accuracy.

## Note

Total measures-Accuracy: (TP+TN)/total\
Total measures-Prevalence: (TP+FN)/total\
Total measures-Proportion Incorrectly Classified: (FN+FP)/total\
Horizontal measures-True Positive Rate-Sensitivity: TP/(TP+FN)\
Horizontal measures-True Negative Rate-Specificity: TN/(FP+TN)\
Horizontal measures-False Negative Rate-Miss Rate: FN/(TP+FN)\
Horizontal measures-False Positive Rate-Fall-out: FP/(FP+TN)\
Vertical measures-Positive Predictive value-Precision: TP/(TP+FP)\
Vertical measures-Negative Predictive value: TN/(FN+TN)\
Vertical measures-False Omission Rate: FN/(FN+TN)\
Vertical measures-False Discovery Rate: FP/(TP+FP)\

## Examples

``` r
# Example with numeric observed and predicted values
confusion_matrix_percent(observed=c(1,2,3,4,5,10),predicted=c(1,2,3,4,5,11))
#>        1    2    3    4    5   10   11  sum    p
#> 1   1.00 0.00 0.00 0.00 0.00 0.00 0.00 1.00 1.00
#> 2   0.00 1.00 0.00 0.00 0.00 0.00 0.00 1.00 1.00
#> 3   0.00 0.00 1.00 0.00 0.00 0.00 0.00 1.00 1.00
#> 4   0.00 0.00 0.00 1.00 0.00 0.00 0.00 1.00 1.00
#> 5   0.00 0.00 0.00 0.00 1.00 0.00 0.00 1.00 1.00
#> 10  0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00
#> 11  0.00 0.00 0.00 0.00 0.00 1.00 0.00 1.00 0.00
#> sum 1.00 1.00 1.00 1.00 1.00 1.00 0.00 6.00 1.00
#> p   1.00 1.00 1.00 1.00 1.00 0.00 0.00 1.00 0.83

# Example with repeated observed and predicted values
confusion_matrix_percent(observed=c(1,2,2,2,2),predicted=c(1,1,2,2,2))
#>        1    2  sum    p
#> 1   1.00 1.00 2.00 0.50
#> 2   0.00 3.00 3.00 1.00
#> sum 1.00 4.00 5.00 1.00
#> p   1.00 0.75 1.00 0.80

# Example with random observed and predicted values
observed<-factor(round(rnorm(10000,m=10,sd=1)))
predicted<-factor(round(rnorm(10000,m=10,sd=1)))
confusion_matrix_percent(observed,predicted)
#>        6     7      8       9      10      11     12    13   14      sum    p
#> 6   0.00  0.00   0.00    0.00    1.00    0.00   0.00  0.00 0.00     1.00 0.00
#> 7   0.00  0.00   3.00    6.00   25.00   13.00   5.00  0.00 0.00    52.00 0.00
#> 8   0.00  5.00  43.00  123.00  238.00  142.00  27.00  3.00 0.00   581.00 0.07
#> 9   0.00 20.00 152.00  621.00  931.00  589.00 161.00 10.00 1.00  2485.00 0.25
#> 10  2.00 34.00 225.00  894.00 1485.00  943.00 232.00 18.00 1.00  3834.00 0.39
#> 11  1.00 12.00 150.00  585.00  914.00  551.00 131.00 13.00 0.00  2357.00 0.23
#> 12  0.00  1.00  36.00  152.00  235.00  143.00  48.00  4.00 0.00   619.00 0.08
#> 13  0.00  0.00   0.00   20.00   31.00   13.00   4.00  0.00 0.00    68.00 0.00
#> 14  0.00  0.00   0.00    0.00    2.00    1.00   0.00  0.00 0.00     3.00 0.00
#> sum 3.00 72.00 609.00 2401.00 3862.00 2395.00 608.00 48.00 2.00 10000.00 1.00
#> p   0.00  0.00   0.07    0.26    0.38    0.23   0.08  0.00 0.00     1.00 0.27
```
