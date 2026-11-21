# Plot performance of confusion matrix for different cut off points

This function generates a plot to visualize the performance of a
confusion matrix at various cut-off points. It evaluates the proportion
of correct classifications and identifies the optimal cut-off point.

## Usage

``` r
result_confusion_performance(
  observed,
  predicted,
  step = 0.1,
  base_size = 10,
  title = ""
)
```

## Arguments

- observed:

  Vector of observed outcomes. These are the true class labels.

- predicted:

  Vector of predicted outcome probabilities. These are the predicted
  probabilities for the positive class.

- step:

  Numeric value representing the stepping for tested cut values.
  Defaults to 0.1.

- base_size:

  Integer value representing the base font size for the plot. Defaults
  to 10.

- title:

  String representing the title of the plot. Defaults to an empty
  string.

## Details

This function evaluates the performance of a confusion matrix at
different cut-off points. It iterates through a range of cut-off points,
calculates the confusion matrix,and evaluates the proportion of correct
classifications for each cut-off.

The function generates a plot that includes: -The proportion of correct
classifications for different cut-off points. -Vertical lines indicating
the optimal cut-off point. -A legend representing different performance
metrics. -A caption showing the number of observations and the optimal
cut-off point.

The function returns a list containing the plot,the data frame with
cut-off performance,the optimal cut-off point, and the confusion matrix
at the optimal cut-off.

## Examples

``` r
# Example with numeric class labels
df<-data.frame(matrix(.999,ncol=2,nrow=2))
correlation_matrix<-as.matrix(df)
diag(correlation_matrix)<-1
df<-generate_correlation_matrix(correlation_matrix,nrows=1000)
df$X1<-ifelse(abs(df$X1) < 1,0,1)
df$X2<-abs(df$X2)
df$X2<-(df$X2-min(df$X2))/(max(df$X2)-min(df$X2))
result_confusion_performance(observed=round(abs(df$X1),0),
                             predicted=abs(df$X2),
                             step=0.01)
#> $plot_performance

#> 
#> $cut_performance
#>     cut_point Overall Collumn_Observed.1 Collumn_Observed.2 Row_Predicted.1 Row_Predicted.2 Mean_proportion
#> 1        0.00    0.34               1.00               0.34            0.00            1.00          0.5850
#> 2        0.01    0.37               1.00               0.35            0.04            1.00          0.5975
#> 3        0.02    0.40               1.00               0.36            0.09            1.00          0.6125
#> 4        0.03    0.43               1.00               0.38            0.14            1.00          0.6300
#> 5        0.04    0.46               1.00               0.39            0.18            1.00          0.6425
#> 6        0.05    0.48               1.00               0.40            0.21            1.00          0.6525
#> 7        0.06    0.51               1.00               0.41            0.26            1.00          0.6675
#> 8        0.07    0.54               1.00               0.42            0.29            1.00          0.6775
#> 9        0.08    0.56               1.00               0.44            0.33            1.00          0.6925
#> 10       0.09    0.60               1.00               0.46            0.39            1.00          0.7125
#> 11       0.10    0.62               1.00               0.48            0.42            1.00          0.7250
#> 12       0.11    0.65               1.00               0.50            0.47            1.00          0.7425
#> 13       0.12    0.68               1.00               0.52            0.51            1.00          0.7575
#> 14       0.13    0.71               1.00               0.54            0.56            1.00          0.7750
#> 15       0.14    0.73               1.00               0.56            0.59            1.00          0.7875
#> 16       0.15    0.76               1.00               0.59            0.64            1.00          0.8075
#> 17       0.16    0.78               1.00               0.61            0.67            1.00          0.8200
#> 18       0.17    0.80               1.00               0.64            0.70            1.00          0.8350
#> 19       0.18    0.82               1.00               0.66            0.73            1.00          0.8475
#> 20       0.19    0.83               1.00               0.67            0.75            1.00          0.8550
#> 21       0.20    0.86               1.00               0.71            0.78            1.00          0.8725
#> 22       0.21    0.88               1.00               0.74            0.82            1.00          0.8900
#> 23       0.22    0.90               1.00               0.77            0.85            1.00          0.9050
#> 24       0.23    0.92               1.00               0.81            0.88            1.00          0.9225
#> 25       0.24    0.94               1.00               0.85            0.91            1.00          0.9400
#> 26       0.25    0.95               1.00               0.88            0.93            1.00          0.9525
#> 27       0.26    0.97               1.00               0.91            0.95            1.00          0.9650
#> 28       0.27    0.99               1.00               0.97            0.99            0.99          0.9875
#> 29       0.28    0.98               0.98               0.99            1.00            0.96          0.9825
#> 30       0.29    0.98               0.96               1.00            1.00            0.93          0.9725
#> 31       0.30    0.96               0.94               1.00            1.00            0.88          0.9550
#> 32       0.31    0.94               0.92               1.00            1.00            0.84          0.9400
#> 33       0.32    0.93               0.90               1.00            1.00            0.79          0.9225
#> 34       0.33    0.91               0.88               1.00            1.00            0.73          0.9025
#> 35       0.34    0.89               0.85               1.00            1.00            0.67          0.8800
#> 36       0.35    0.87               0.84               1.00            1.00            0.63          0.8675
#> 37       0.36    0.86               0.82               1.00            1.00            0.58          0.8500
#> 38       0.37    0.84               0.81               1.00            1.00            0.54          0.8375
#> 39       0.38    0.83               0.80               1.00            1.00            0.51          0.8275
#> 40       0.39    0.82               0.78               1.00            1.00            0.46          0.8100
#> 41       0.40    0.81               0.78               1.00            1.00            0.45          0.8075
#> 42       0.41    0.80               0.76               1.00            1.00            0.41          0.7925
#> 43       0.42    0.79               0.76               1.00            1.00            0.38          0.7850
#> 44       0.43    0.78               0.75               1.00            1.00            0.36          0.7775
#> 45       0.44    0.78               0.74               1.00            1.00            0.34          0.7700
#> 46       0.45    0.77               0.74               1.00            1.00            0.32          0.7650
#> 47       0.46    0.76               0.73               1.00            1.00            0.30          0.7575
#> 48       0.47    0.75               0.73               1.00            1.00            0.27          0.7500
#> 49       0.48    0.74               0.72               1.00            1.00            0.25          0.7425
#> 50       0.49    0.73               0.71               1.00            1.00            0.22          0.7325
#> 51       0.50    0.73               0.71               1.00            1.00            0.22          0.7325
#> 52       0.51    0.72               0.70               1.00            1.00            0.18          0.7200
#> 53       0.52    0.72               0.70               1.00            1.00            0.17          0.7175
#> 54       0.53    0.71               0.70               1.00            1.00            0.16          0.7150
#> 55       0.54    0.71               0.69               1.00            1.00            0.14          0.7075
#> 56       0.55    0.70               0.69               1.00            1.00            0.14          0.7075
#> 57       0.56    0.70               0.69               1.00            1.00            0.13          0.7050
#> 58       0.57    0.69               0.68               1.00            1.00            0.10          0.6950
#> 59       0.58    0.69               0.68               1.00            1.00            0.10          0.6950
#> 60       0.59    0.68               0.68               1.00            1.00            0.08          0.6900
#> 61       0.60    0.68               0.67               1.00            1.00            0.08          0.6875
#> 62       0.61    0.68               0.67               1.00            1.00            0.07          0.6850
#> 63       0.62    0.68               0.67               1.00            1.00            0.07          0.6850
#> 64       0.63    0.68               0.67               1.00            1.00            0.06          0.6825
#> 65       0.64    0.68               0.67               1.00            1.00            0.06          0.6825
#> 66       0.65    0.68               0.67               1.00            1.00            0.05          0.6800
#> 67       0.66    0.67               0.67               1.00            1.00            0.04          0.6775
#> 68       0.67    0.67               0.66               1.00            1.00            0.03          0.6725
#> 69       0.68    0.67               0.66               1.00            1.00            0.03          0.6725
#> 70       0.69    0.67               0.66               1.00            1.00            0.03          0.6725
#> 71       0.70    0.67               0.66               1.00            1.00            0.03          0.6725
#> 72       0.71    0.67               0.66               1.00            1.00            0.03          0.6725
#> 73       0.72    0.66               0.66               1.00            1.00            0.02          0.6700
#> 74       0.73    0.66               0.66               1.00            1.00            0.02          0.6700
#> 75       0.74    0.66               0.66               1.00            1.00            0.02          0.6700
#> 76       0.75    0.66               0.66               1.00            1.00            0.02          0.6700
#> 77       0.76    0.66               0.66               1.00            1.00            0.02          0.6700
#> 78       0.77    0.66               0.66               1.00            1.00            0.02          0.6700
#> 79       0.78    0.66               0.66               1.00            1.00            0.01          0.6675
#> 80       0.79    0.66               0.66               1.00            1.00            0.01          0.6675
#> 81       0.80    0.66               0.66               1.00            1.00            0.01          0.6675
#> 82       0.81    0.66               0.66               1.00            1.00            0.01          0.6675
#> 83       0.82    0.66               0.66               1.00            1.00            0.01          0.6675
#> 84       0.83    0.66               0.66               1.00            1.00            0.00          0.6650
#> 85       0.84    0.66               0.66               1.00            1.00            0.00          0.6650
#> 86       0.85    0.66               0.66               1.00            1.00            0.00          0.6650
#> 87       0.86    0.66               0.66               1.00            1.00            0.00          0.6650
#> 88       0.87    0.66               0.66               1.00            1.00            0.00          0.6650
#> 89       0.88    0.66               0.66               1.00            1.00            0.00          0.6650
#> 90       0.89    0.66               0.66               1.00            1.00            0.00          0.6650
#> 91       0.90    0.66               0.66               1.00            1.00            0.00          0.6650
#> 92       0.91    0.66               0.66               1.00            1.00            0.00          0.6650
#> 93       0.92    0.66               0.66               1.00            1.00            0.00          0.6650
#> 94       0.93    0.66               0.66               1.00            1.00            0.00          0.6650
#> 95       0.94    0.66               0.66               1.00            1.00            0.00          0.6650
#> 96       0.95    0.66               0.66               1.00            1.00            0.00          0.6650
#> 97       0.96    0.66               0.66               1.00            1.00            0.00          0.6650
#> 98       0.97    0.66               0.66               1.00            1.00            0.00          0.6650
#> 99       0.98    0.66               0.66               1.00            1.00            0.00          0.6650
#> 100      0.99    0.66               0.66               1.00            1.00            0.00          0.6650
#> 101      1.00    0.66               0.66               0.00            1.00            0.00          0.4150
#> 
#> $cut
#> [1] 0.27
#> 
#> $confusion_matrix
#>          0      1     sum    p
#> 0   648.00   2.00  650.00 1.00
#> 1     9.00 341.00  350.00 0.97
#> sum 657.00 343.00 1000.00 1.00
#> p     0.99   0.99    1.00 0.99
#> 
```
