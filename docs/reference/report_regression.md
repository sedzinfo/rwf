# Regression

Regression

## Usage

``` r
report_regression(
  model,
  base_size = 10,
  title = "",
  file = NULL,
  w = 10,
  h = 10,
  plot_diagnostics = TRUE
)
```

## Arguments

- model:

  object ml

- base_size:

  base font size

- title:

  plot title

- file:

  output filename

- w:

  width of pdf file. Relevant only when file string is not empty

- h:

  height of pdf file. Relevant only when file string is not empty

- plot_diagnostics:

  if TRUE it will output linear model diagnostics plots

## Note

1.  Problematic values for standardized residuals \> +-1.96\
    **Standardized residuals** are residuals divided by an estimated
    standard deviation and they can be interpreted as z scores in that:

    - 95.00% of z-scores lie between -1.96 and +1.96

    - 99.00% of z-scores lie between -2.58 and +2.58

    - 99.99% of z-scores lie between -3.29 and +3.29

2.  **Studentized residuals**: indicate the ability of the model to
    predict that case. They follow a t distribution.

3.  **DFFits**: indicate the difference between the adjusted predicted
    value and the original predicted value. Adjusted predicted value for
    a case refers to the predicted value of that case, when that case is
    excluded from model fit.

4.  **Cook's distance**: indicates leverage. Problematic values for
    cook's distance \> 1 Cook and Weisberg (1982).

5.  **Hat values**: indicate leverage. Problematic values for Hat values
    2 or 3 times the average (k+1/n) The average leverage value is
    defined as (k+1)/n, k=number of predictors, n=number of
    participants. Leverage values lie between 0 (no influence) and 1
    (complete influence over prediction).

    - Hoaglin and Welsch (1978) recommends investigating cases with
      values greater than twice the average (2(k+1)/n)

    - Stevens (2002) recommends investigating cases with values greater
      than three times the average (3(k+1)/n)

**T-tests**: test the hypothesis that b's are different from 0\
**Multiple R^2**: Variance Explained\
**Adjusted R^2**: Indicates how much variance in Y would be accounted
for if the model is derived from the population from which the sample
was taken. Ideally, R^2 = Adjusted R^2\
**F-Statistic**: tests the null hypothesis is that the overall model has
no effect\
**Covariance ratios**: critical values CVR\>1+\[3(k+1)/n\]
CRV\<1-\[3(k+1)/n\]. In general we should obtain small values or we may
have to remove cases\
\
\
**ASSUMPTIONS**

1.  variable types: All predictors must be quantitative or categorical
    (with two levels), and the outcome variable must be quantitative
    (interval data), continuous and unbounded (no constraints on the
    variability of the outcome)

2.  Non-zero variance

3.  No perfect multicollinearity

4.  Predictors are uncorrelated with -external variables-

5.  Homoscedasticity: At each level of the predictor variable(s), the
    variance of the residual terms should be constant. Residuals at each
    level of the predictor(s) should have similar variance
    (homoscedasticity)

6.  Independent errors: For any two observations the residual terms
    should be uncorrelated (or independent)\
    This eventuality is sometimes described as a lack of
    autocorrelation. This assumption can be tested with the
    Durbin-Watson test,which tests for serial correlations between
    errors. Specifically, it tests whether adjacent residuals are
    correlated The size of the Durbin-Watson statistic depends upon the
    number of predictors in the model and the number of observations As
    a very conservative rule of thumb, values less than 1 or greater
    than 3 are definitely cause for concern; however,values closer to 2
    may still be problematic depending on your sample and model R also
    provides a p-value of the autocorrelation. Be very careful with the
    Durbin-Watson test, though, as it depends on the order of the data:
    if you reorder your data, you-ll get a different value

7.  Normally distributed errors: It is assumed that the residuals in the
    model are random, normally distributed variables with a mean of 0

8.  Independence: It is assumed that all of the values of the outcome
    variable are independent (in other words, each value of the outcome
    variable comes from a separate entity)

9.  Linearity: The mean values of the outcome variable for each
    increment of the predictor(s) lie along a straight line

## Examples

``` r
form <- formula(mpg ~ qsec)
regressionmodel <- lm(form, data = mtcars)
multipleregressionmodel <- lm(mpg ~ qsec * hp * wt * drat, data = mtcars)
res <- report_regression(model = regressionmodel, plot_diagnostics = TRUE)
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
res <- report_regression(model = multipleregressionmodel)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
res <- report_regression(model = regressionmodel, file = file.path(tempdir(), "regression"))
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
res <- report_regression(
  model = multipleregressionmodel,
  file = file.path(tempdir(), "regression"),
  plot_diagnostics = TRUE
)
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
```
