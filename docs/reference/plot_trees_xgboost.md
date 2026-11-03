# Plot trees for xgboost::xgb.train

Uses
[`xgboost::xgb.plot.multi.trees`](https://rdrr.io/pkg/xgboost/man/xgb.plot.multi.trees.html)
to draw the trees of an xgboost model combined into one diagram (keeping
the 10 most important features) and saves it as a self-contained
`<file>.html` in the working directory. Works with xgboost 3 and with
older versions.

## Usage

``` r
plot_trees_xgboost(model, train, file = "xgboost")
```

## Arguments

- model:

  object from xgboost::xgb.train

- train:

  Train dataset; its column names label the features. With xgboost 3
  they are used only when the model itself has no feature names and the
  number of columns matches the number of model features.

- file:

  output filename

## Value

Called for its side effect of writing `<file>.html`; returns the value
of
[`htmlwidgets::saveWidget`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html)
invisibly.

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
                    data=train_test_classification$xgb$f1$train,
                    watchlist=train_test_classification$xgb$f1$watchlist,
                    eta=.1,
                    nthread=8,
                    nround=20,
                    objective="binary:logistic")
#> Warning: Passed invalid function arguments: eta, nthread. These should be passed as a list to argument 'params'. Conversion from argument to 'params' entry will be done automatically, but this behavior will become an error in a future version.
#> Warning: Parameter 'watchlist' has been renamed to 'evals'. This warning will become an error in a future version.
#> Warning: Argument 'objective' is only for custom objectives. For built-in objectives, pass the objective under 'params'. This warning will become an error in a future version.
#> [1]  train-logloss:0.623291  test-logloss:0.609430 
#> [2]  train-logloss:0.610430  test-logloss:0.594147 
#> [3]  train-logloss:0.599550  test-logloss:0.581131 
#> [4]  train-logloss:0.590313  test-logloss:0.569995 
#> [5]  train-logloss:0.582449  test-logloss:0.560434 
#> [6]  train-logloss:0.575737  test-logloss:0.552200 
#> [7]  train-logloss:0.569691  test-logloss:0.546798 
#> [8]  train-logloss:0.564481  test-logloss:0.542105 
#> [9]  train-logloss:0.559988  test-logloss:0.538070 
#> [10] train-logloss:0.556108  test-logloss:0.534651 
#> [11] train-logloss:0.552753  test-logloss:0.531704 
#> [12] train-logloss:0.549850  test-logloss:0.529162 
#> [13] train-logloss:0.547327  test-logloss:0.526742 
#> [14] train-logloss:0.545126  test-logloss:0.524816 
#> [15] train-logloss:0.543198  test-logloss:0.523113 
#> [16] train-logloss:0.541496  test-logloss:0.521395 
#> [17] train-logloss:0.540006  test-logloss:0.520055 
#> [18] train-logloss:0.538688  test-logloss:0.518639 
#> [19] train-logloss:0.537530  test-logloss:0.517579 
#> [20] train-logloss:0.536511  test-logloss:0.516631 
xgb_regression<-xgboost::xgb.train(
                data=train_test_regression$xgb$f1$train,
                watchlist=train_test_regression$xgb$f1$watchlist,
                eta=.3,
                nthread=8,
                nround=20)
#> Warning: Passed invalid function arguments: eta, nthread. These should be passed as a list to argument 'params'. Conversion from argument to 'params' entry will be done automatically, but this behavior will become an error in a future version.
#> Warning: Parameter 'watchlist' has been renamed to 'evals'. This warning will become an error in a future version.
#> [1]  train-rmse:6.767778 test-rmse:7.630684 
#> [2]  train-rmse:5.114918 test-rmse:6.449245 
#> [3]  train-rmse:3.928255 test-rmse:5.401588 
#> [4]  train-rmse:3.083216 test-rmse:4.988108 
#> [5]  train-rmse:2.470609 test-rmse:4.503503 
#> [6]  train-rmse:2.049778 test-rmse:4.237325 
#> [7]  train-rmse:1.744310 test-rmse:4.010582 
#> [8]  train-rmse:1.514668 test-rmse:3.857252 
#> [9]  train-rmse:1.344581 test-rmse:3.776074 
#> [10] train-rmse:1.215704 test-rmse:3.664431 
#> [11] train-rmse:1.111102 test-rmse:3.596719 
#> [12] train-rmse:1.030294 test-rmse:3.556190 
#> [13] train-rmse:0.975636 test-rmse:3.540136 
#> [14] train-rmse:0.887905 test-rmse:3.511208 
#> [15] train-rmse:0.806829 test-rmse:3.482421 
#> [16] train-rmse:0.762177 test-rmse:3.430239 
#> [17] train-rmse:0.732005 test-rmse:3.423874 
#> [18] train-rmse:0.685723 test-rmse:3.425488 
#> [19] train-rmse:0.636018 test-rmse:3.413766 
#> [20] train-rmse:0.600641 test-rmse:3.422413 
# xgboost::xgb.plot.multi.trees(model=xgb_classification,features_keep=2)
# plot_trees_xgboost(model=xgb_classification,
#                    train=train_test_classification$xgb$f1,
#                    file=file.path(tempdir(),"Classification"))
# plot_trees_xgboost(model=xgb_regression,
#                    train=train_test_regression$xbg$f1,
#                    file=file.path(tempdir(),"Regression"))
```
