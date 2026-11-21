# Report for xgboost::xgb.train

Report for xgboost::xgb.train

## Usage

``` r
report_xgboost(
  model,
  validation_data = NULL,
  label = NULL,
  file = "xgboost",
  w = 10,
  h = 10,
  base_size = 10,
  title = "",
  fast = FALSE
)
```

## Arguments

- model:

  object from xgboost::xgb.train

- validation_data:

  validation data

- label:

  outcome variable name

- file:

  output filename

- w:

  width of pdf file

- h:

  height of pdf file

- base_size:

  base font size

- title:

  plot title

- fast:

  if TRUE error values are not saved in output

## Value

Invisibly, a list with

- plots:

  ggplot objects: `regression` (observed vs predicted on the validation
  data), `performance` (cut-point diagnostics, not for regression
  objectives), `depth`, `cover`, `weight` (tree structure), `error`
  (training log) and `importance`.

- result:

  tables: `importance` (from
  [`xgboost::xgb.importance`](https://rdrr.io/pkg/xgboost/man/xgb.importance.html)),
  `parameters` (hyperparameters), `model_call`, `evaluation_log`,
  `model_summary` (objective, boosting rounds, number of features, and
  with early stopping the best iteration and score). With validation
  data, there is also `validation_metrics` (regression: N, RMSE, MAE,
  mean error, R squared; binary classification: N, AUC, log loss and
  accuracy at a 0.5 cut-off).

- observed, predicted:

  validation outcome and predictions (`NULL` without `validation_data`).

- feature_names:

  the model's features, in the model's order.

## Details

Works with xgboost 3, which stores the call, parameters and evaluation
log as attributes of the model, and with older versions that store them
as list elements. Validation predictions use the model's own feature
order. When `file` is given, the plots are written to `<file>.pdf` and
the tables to `<file>.xlsx` (sheets: confusion matrix for
classification, Model Summary, Validation Metrics, Feature Importance,
Hyperparameters and, unless `fast = TRUE`, Evaluation Log).

## Examples

``` r
infert_formula<-formula(case~education+spontaneous+induced)
boston_formula<-formula(medv~crim+zn+indus+chas+nox+rm+age+
                         dis+rad+tax+ptratio+black+lstat)
train_test_classification<-k_fold(df=infert,model_formula=infert_formula)
#> Fold Cases: 1 Train: 223 Test: 25 Total: 248 Unique Train: 223 Unique Test: 25 
#> Fold Cases: 2 Train: 223 Test: 25 Total: 248 Unique Train: 223 Unique Test: 25 
#> Fold Cases: 3 Train: 223 Test: 25 Total: 248 Unique Train: 223 Unique Test: 25 
#> Fold Cases: 4 Train: 224 Test: 24 Total: 248 Unique Train: 224 Unique Test: 24 
#> Fold Cases: 5 Train: 223 Test: 25 Total: 248 Unique Train: 223 Unique Test: 25 
#> Fold Cases: 6 Train: 223 Test: 25 Total: 248 Unique Train: 223 Unique Test: 25 
#> Fold Cases: 7 Train: 224 Test: 24 Total: 248 Unique Train: 224 Unique Test: 24 
#> Fold Cases: 8 Train: 223 Test: 25 Total: 248 Unique Train: 223 Unique Test: 25 
#> Fold Cases: 9 Train: 223 Test: 25 Total: 248 Unique Train: 223 Unique Test: 25 
#> Fold Cases: 10 Train: 223 Test: 25 Total: 248 Unique Train: 223 Unique Test: 25 
train_test_regression<-k_fold(df=MASS::Boston,model_formula=boston_formula)
#> Fold Cases: 1 Train: 455 Test: 51 Total: 506 Unique Train: 455 Unique Test: 51 
#> Fold Cases: 2 Train: 455 Test: 51 Total: 506 Unique Train: 455 Unique Test: 51 
#> Fold Cases: 3 Train: 456 Test: 50 Total: 506 Unique Train: 456 Unique Test: 50 
#> Fold Cases: 4 Train: 455 Test: 51 Total: 506 Unique Train: 455 Unique Test: 51 
#> Fold Cases: 5 Train: 456 Test: 50 Total: 506 Unique Train: 456 Unique Test: 50 
#> Fold Cases: 6 Train: 455 Test: 51 Total: 506 Unique Train: 455 Unique Test: 51 
#> Fold Cases: 7 Train: 456 Test: 50 Total: 506 Unique Train: 456 Unique Test: 50 
#> Fold Cases: 8 Train: 455 Test: 51 Total: 506 Unique Train: 455 Unique Test: 51 
#> Fold Cases: 9 Train: 456 Test: 50 Total: 506 Unique Train: 456 Unique Test: 50 
#> Fold Cases: 10 Train: 455 Test: 51 Total: 506 Unique Train: 455 Unique Test: 51 
xgb_classification<-xgboost::xgb.train(
                    params=xgboost::xgb.params(objective="binary:logistic"),
                    data=train_test_classification$xgb$f1$train,
                    evals=train_test_classification$xgb$f1$watchlist,
                    nround=20)
#> [1]  train-logloss:0.591452  test-logloss:0.612299 
#> [2]  train-logloss:0.567817  test-logloss:0.594450 
#> [3]  train-logloss:0.551699  test-logloss:0.584122 
#> [4]  train-logloss:0.541590  test-logloss:0.580610 
#> [5]  train-logloss:0.534795  test-logloss:0.577169 
#> [6]  train-logloss:0.530139  test-logloss:0.576748 
#> [7]  train-logloss:0.527660  test-logloss:0.574108 
#> [8]  train-logloss:0.525916  test-logloss:0.571550 
#> [9]  train-logloss:0.524702  test-logloss:0.573293 
#> [10] train-logloss:0.523779  test-logloss:0.572424 
#> [11] train-logloss:0.523133  test-logloss:0.571744 
#> [12] train-logloss:0.522428  test-logloss:0.570725 
#> [13] train-logloss:0.521823  test-logloss:0.568952 
#> [14] train-logloss:0.521453  test-logloss:0.567706 
#> [15] train-logloss:0.521048  test-logloss:0.570858 
#> [16] train-logloss:0.520781  test-logloss:0.571206 
#> [17] train-logloss:0.520570  test-logloss:0.570251 
#> [18] train-logloss:0.520210  test-logloss:0.573325 
#> [19] train-logloss:0.520024  test-logloss:0.573604 
#> [20] train-logloss:0.519850  test-logloss:0.573921 
xgb_regression<-xgboost::xgb.train(
                data=train_test_regression$xgb$f1$train,
                evals=train_test_regression$xgb$f1$watchlist,
                nround=20)
#> [1]  train-rmse:6.932495 test-rmse:6.170404 
#> [2]  train-rmse:5.231546 test-rmse:5.448754 
#> [3]  train-rmse:4.043074 test-rmse:5.077008 
#> [4]  train-rmse:3.174738 test-rmse:4.642024 
#> [5]  train-rmse:2.547561 test-rmse:4.538237 
#> [6]  train-rmse:2.112099 test-rmse:4.426193 
#> [7]  train-rmse:1.797579 test-rmse:4.329764 
#> [8]  train-rmse:1.562939 test-rmse:4.386720 
#> [9]  train-rmse:1.383725 test-rmse:4.347521 
#> [10] train-rmse:1.254522 test-rmse:4.321362 
#> [11] train-rmse:1.135862 test-rmse:4.312929 
#> [12] train-rmse:1.054336 test-rmse:4.287460 
#> [13] train-rmse:0.951440 test-rmse:4.255665 
#> [14] train-rmse:0.913182 test-rmse:4.248794 
#> [15] train-rmse:0.855071 test-rmse:4.233847 
#> [16] train-rmse:0.800970 test-rmse:4.249786 
#> [17] train-rmse:0.764507 test-rmse:4.240963 
#> [18] train-rmse:0.735382 test-rmse:4.246517 
#> [19] train-rmse:0.677213 test-rmse:4.205235 
#> [20] train-rmse:0.659834 test-rmse:4.204043 
report_xgboost(model=xgb_classification,
               validation_data=train_test_classification$f$test$f1,
               label=train_test_classification$outcome,
               file=file.path(tempdir(),"Classification"))
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
report_xgboost(model=xgb_regression,
               validation_data=train_test_regression$f$test$f1,
               label=train_test_regression$outcome,
               file=file.path(tempdir(),"Regression"))
#> Warning: restarting interrupted promise evaluation
#> Error: cannot open file 'C:/Users/dzach/AppData/Local/R/win-library/4.6/rwf/R/rwf.rdb': No such file or directory
```
