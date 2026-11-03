# Compare logistic regression models models

Compare logistic regression models models

## Usage

``` r
output_compare_model_logistic(model1, model2)
```

## Arguments

- model1:

  object glm model

- model2:

  object glm model

## Examples

``` r
modelcategoricalpredictor <- glm(case ~ education, data = infert, family = binomial)
modelcontinuouspredictor <- glm(case ~ age, data = infert, family = binomial)
modeltwopredictors <- glm(case ~ education * age, data = infert, family = binomial)
modelmultiple <- glm(case ~ education * age * parity, data = infert, family = binomial)
anova(modelcategoricalpredictor, modelcontinuouspredictor)
#> Analysis of Deviance Table
#> 
#> Model 1: case ~ education
#> Model 2: case ~ age
#>   Resid. Df Resid. Dev Df Deviance Pr(>Chi)
#> 1       245        316                     
#> 2       246        316 -1 0.000801         
output_compare_model_logistic(
  model1 = modelcategoricalpredictor,
  model2 = modeltwopredictors
)
#>       X.2 df      p
#> 1 0.01544  3 0.9995
output_compare_model_logistic(
  model1 = modelcontinuouspredictor,
  model2 = modeltwopredictors
)
#>       X.2 df p
#> 1 0.01464  4 1
output_compare_model_logistic(
  model1 = modelcontinuouspredictor,
  model2 = modelcategoricalpredictor
)
#>          X.2 df p
#> 1 -0.0008011  1 1
```
