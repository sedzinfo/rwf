##########################################################################################
# XGBOOST with df_titanic: classification (survived) + regression (fare)
# Uses rwf helpers: k_fold() builds folds + xgb.DMatrix objects,
# report_xgboost() produces plots/tables from a trained xgboost::xgb.train model.
##########################################################################################
suppressMessages(library(rwf))
suppressMessages(library(xgboost))

data(df_titanic)

df_titanic$sex                                 <- factor(df_titanic$sex)
df_titanic$embarked[df_titanic$embarked == ""] <- NA
df_titanic$embarked                            <- factor(df_titanic$embarked)

##########################################################################################
# CLASSIFICATION: survived ~ predictors
##########################################################################################
classification_formula <- formula(survived ~ pclass + sex + age + sibsp + parch + fare + embarked)
df_class <- df_titanic[stats::complete.cases(df_titanic[, all.vars(classification_formula)]), ]

train_test_classification <- k_fold(df = df_class, model_formula = classification_formula, k = 5)

xgb_classification <- xgboost::xgb.train(
  params  = xgboost::xgb.params(objective = "binary:logistic", eta = 0.1),
  data    = train_test_classification$xgb$f1$train,
  evals   = train_test_classification$xgb$f1$evals,
  nrounds = 50
)

report_classification <- report_xgboost(
  model           = xgb_classification,
  validation_data = train_test_classification$f$test$f1,
  label           = train_test_classification$outcome,
  file            = "xgb_titanic_classification"
)

##########################################################################################
# REGRESSION: fare ~ predictors
##########################################################################################
regression_formula <- formula(fare ~ pclass + sex + age + sibsp + parch + survived + embarked)
df_reg <- df_titanic[stats::complete.cases(df_titanic[, all.vars(regression_formula)]), ]

train_test_regression <- k_fold(df = df_reg, model_formula = regression_formula, k = 5)

xgb_regression <- xgboost::xgb.train(
  params  = xgboost::xgb.params(objective = "reg:squarederror", eta = 0.1),
  data    = train_test_regression$xgb$f1$train,
  evals   = train_test_regression$xgb$f1$evals,
  nrounds = 50
)

report_regression <- report_xgboost(
  model           = xgb_regression,
  validation_data = train_test_regression$f$test$f1,
  label           = train_test_regression$outcome,
  file            = "xgb_titanic_regression"
)
