# Train test sampling

Splits a dataframe into train and test dataframes for model evaluation.
Prepared data include data objects for xgboost.

## Usage

``` r
k_sample(df, model_formula, k = 1)
```

## Arguments

- df:

  Dataframe containing the dataset to be split.

- model_formula:

  Model formula specifying the predictors and outcome variable.

- k:

  Integer value representing the number of folds. Defaults to 1
  (train-test split).

## Details

This function performs k-fold cross-validation or a simple train-test
split (if k=1) by splitting the input dataframe into k folds. Each fold
serves as a test set once,while the remaining k-1 folds form the
training set.

The function prepares data objects for xgboost model training and
evaluation, including train, test, and validation datasets and xgboost
DMatrix objects.

The output is a list containing the following elements: -\`f\`: List of
train,test,and validation datasets for each fold. -\`index\`: Vector of
fold indices. -\`model_formula\`: Model formula used for generating the
datasets. -\`variables\`: Names of the variables in the model formula.
-\`predictors\`: Names of the predictor variables. -\`outcome\`: Name of
the outcome variable. -\`xgb\`: List of xgboost DMatrix objects for
training,testing,and validation.

## Examples

``` r
# Example with the 'infert' dataset
infert_formula<-formula(case~education+spontaneous+induced)
result<-k_sample(df=infert,k=10,model_formula=infert_formula)
#> Fold Cases: 1 Train: 12 Test: 6 Validation: 6 Total: 25 Unique Train: 12 Unique Test: 6 Unique Validation: 7 
#> Fold Cases: 2 Train: 12 Test: 6 Validation: 6 Total: 25 Unique Train: 12 Unique Test: 6 Unique Validation: 7 
#> Fold Cases: 3 Train: 12 Test: 6 Validation: 6 Total: 25 Unique Train: 12 Unique Test: 6 Unique Validation: 7 
#> Fold Cases: 4 Train: 12 Test: 6 Validation: 6 Total: 24 Unique Train: 12 Unique Test: 6 Unique Validation: 6 
#> Fold Cases: 5 Train: 12 Test: 6 Validation: 6 Total: 25 Unique Train: 12 Unique Test: 6 Unique Validation: 7 
#> Fold Cases: 6 Train: 12 Test: 6 Validation: 6 Total: 25 Unique Train: 12 Unique Test: 6 Unique Validation: 7 
#> Fold Cases: 7 Train: 12 Test: 6 Validation: 6 Total: 24 Unique Train: 12 Unique Test: 6 Unique Validation: 6 
#> Fold Cases: 8 Train: 12 Test: 6 Validation: 6 Total: 25 Unique Train: 12 Unique Test: 6 Unique Validation: 7 
#> Fold Cases: 9 Train: 12 Test: 6 Validation: 6 Total: 25 Unique Train: 12 Unique Test: 6 Unique Validation: 7 
#> Fold Cases: 10 Train: 12 Test: 6 Validation: 6 Total: 25 Unique Train: 12 Unique Test: 6 Unique Validation: 7 

# Example with the 'mtcars' dataset
model_formula<-formula(mpg~cyl+disp+hp+drat+wt+qsec+vs+am+gear+carb)
result<-k_sample(df=mtcars,k=10,model_formula=model_formula)
#> Fold Cases: 1 Train: 2 Test: 1 Validation: 1 Total: 4 Unique Train: 2 Unique Test: 1 Unique Validation: 1 
#> Fold Cases: 2 Train: 1 Test: 1 Validation: 1 Total: 3 Unique Train: 1 Unique Test: 1 Unique Validation: 1 
#> Fold Cases: 3 Train: 1 Test: 1 Validation: 1 Total: 3 Unique Train: 1 Unique Test: 1 Unique Validation: 1 
#> Fold Cases: 4 Train: 1 Test: 1 Validation: 1 Total: 3 Unique Train: 1 Unique Test: 1 Unique Validation: 1 
#> Fold Cases: 5 Train: 1 Test: 1 Validation: 1 Total: 3 Unique Train: 1 Unique Test: 1 Unique Validation: 1 
#> Fold Cases: 6 Train: 1 Test: 1 Validation: 1 Total: 3 Unique Train: 1 Unique Test: 1 Unique Validation: 1 
#> Fold Cases: 7 Train: 1 Test: 1 Validation: 1 Total: 3 Unique Train: 1 Unique Test: 1 Unique Validation: 1 
#> Fold Cases: 8 Train: 1 Test: 1 Validation: 1 Total: 3 Unique Train: 1 Unique Test: 1 Unique Validation: 1 
#> Fold Cases: 9 Train: 1 Test: 1 Validation: 1 Total: 3 Unique Train: 1 Unique Test: 1 Unique Validation: 1 
#> Fold Cases: 10 Train: 2 Test: 1 Validation: 1 Total: 4 Unique Train: 2 Unique Test: 1 Unique Validation: 1 
```
