# Plot trees for xgboost::xgb.train

Plot trees for xgboost::xgb.train

## Usage

``` r
plot_trees_xgboost(model, train, file = "xgboost")
```

## Arguments

- model:

  object from xgboost::xgb.train

- train:

  Train dataset

- file:

  output filename

## Examples

``` r
infert_formula<-formula(case~education+spontaneous+induced)
boston_formula<-formula(medv~crim+zn+indus+chas+nox+rm+age+dis+rad+tax+ptratio+black+lstat)
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
#> [1]  train-logloss:0.610296  test-logloss:0.711680 
#> [2]  train-logloss:0.594738  test-logloss:0.709760 
#> [3]  train-logloss:0.581698  test-logloss:0.709494 
#> [4]  train-logloss:0.570702  test-logloss:0.710505 
#> [5]  train-logloss:0.561382  test-logloss:0.712583 
#> [6]  train-logloss:0.553414  test-logloss:0.713634 
#> [7]  train-logloss:0.546567  test-logloss:0.715436 
#> [8]  train-logloss:0.540652  test-logloss:0.718083 
#> [9]  train-logloss:0.535502  test-logloss:0.721219 
#> [10] train-logloss:0.531007  test-logloss:0.724739 
#> [11] train-logloss:0.527073  test-logloss:0.728557 
#> [12] train-logloss:0.523576  test-logloss:0.732111 
#> [13] train-logloss:0.520376  test-logloss:0.736233 
#> [14] train-logloss:0.517542  test-logloss:0.740436 
#> [15] train-logloss:0.515390  test-logloss:0.744895 
#> [16] train-logloss:0.513455  test-logloss:0.748832 
#> [17] train-logloss:0.511741  test-logloss:0.752671 
#> [18] train-logloss:0.510266  test-logloss:0.755962 
#> [19] train-logloss:0.508954  test-logloss:0.759177 
#> [20] train-logloss:0.507783  test-logloss:0.762312 
xgb_regression<-xgboost::xgb.train(
                data=train_test_regression$xgb$f1$train,
                watchlist=train_test_regression$xgb$f1$watchlist,
                eta=.3,
                nthread=8,
                nround=20)
#> Warning: Passed invalid function arguments: eta, nthread. These should be passed as a list to argument 'params'. Conversion from argument to 'params' entry will be done automatically, but this behavior will become an error in a future version.
#> Warning: Parameter 'watchlist' has been renamed to 'evals'. This warning will become an error in a future version.
#> [1]  train-rmse:6.889171 test-rmse:6.079216 
#> [2]  train-rmse:5.202736 test-rmse:4.907566 
#> [3]  train-rmse:3.987855 test-rmse:4.129179 
#> [4]  train-rmse:3.148291 test-rmse:3.586540 
#> [5]  train-rmse:2.543125 test-rmse:3.378345 
#> [6]  train-rmse:2.113914 test-rmse:3.301242 
#> [7]  train-rmse:1.738537 test-rmse:3.143354 
#> [8]  train-rmse:1.504925 test-rmse:3.095502 
#> [9]  train-rmse:1.314920 test-rmse:3.052375 
#> [10] train-rmse:1.198185 test-rmse:3.008031 
#> [11] train-rmse:1.099226 test-rmse:2.986951 
#> [12] train-rmse:1.014451 test-rmse:2.955034 
#> [13] train-rmse:0.947164 test-rmse:2.945596 
#> [14] train-rmse:0.868464 test-rmse:2.942617 
#> [15] train-rmse:0.811166 test-rmse:2.971191 
#> [16] train-rmse:0.767436 test-rmse:2.971298 
#> [17] train-rmse:0.714092 test-rmse:2.957072 
#> [18] train-rmse:0.683534 test-rmse:2.975358 
#> [19] train-rmse:0.644037 test-rmse:2.973739 
#> [20] train-rmse:0.595661 test-rmse:2.955901 
# xgboost::xgb.plot.multi.trees(model=xgb_classification,features_keep=2)
# plot_trees_xgboost(model=xgb_classification,
#                    train=train_test_classification$xgb$f1,
#                    file="Classification")
# plot_trees_xgboost(model=xgb_regression,
#                    train=train_test_regression$xbg$f1,
#                    file="Regression")
```
