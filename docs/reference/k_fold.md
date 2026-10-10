# K-Fold train test sampling

Splits a dataframe into train and test dataframes for model evaluation.
Prepared data include data objects for xgboost.

## Usage

``` r
k_fold(df, model_formula, k = 10)
```

## Arguments

- df:

  Dataframe containing the dataset to be split.

- model_formula:

  Model formula specifying the predictors and outcome variable.

- k:

  Integer value representing the number of folds. Defaults to 10.

## Details

This function performs k-fold cross-validation by splitting the input
dataframe into k folds. Each fold serves as a test set once,while the
remaining k-1 folds form the training set.

The function prepares data objects for xgboost model training and
evaluation, including train / test datasets and xgboost DMatrix objects.

The output is a list containing the following elements: -\`f\`: List of
train and test datasets for each fold. -\`index\`: Vector of fold
indices. -\`model_formula\`: Model formula used for generating the
datasets. -\`variables\`: Names of the variables in the model formula.
-\`predictors\`: Names of the predictor variables. -\`outcome\`: Name of
the outcome variable. -\`xgb\`: List of xgboost DMatrix objects for
training and testing.

## Examples

``` r
# Example with the 'infert' dataset
infert_formula<-formula(case~education+spontaneous+induced)
result<-k_fold(infert,k=10,model_formula=infert_formula)
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

# Example with the 'mtcars' dataset
model_formula<-as.formula(mpg~cyl+disp+hp+drat+wt+qsec+vs+am+gear+carb)
result<-k_fold(mtcars,k=2,model_formula=model_formula)
#> Fold Cases: 1 Train: 16 Test: 16 Total: 32 Unique Train: 16 Unique Test: 16 
#> Fold Cases: 2 Train: 16 Test: 16 Total: 32 Unique Train: 16 Unique Test: 16 
```
