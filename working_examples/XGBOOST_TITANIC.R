rm(list = ls())
##########################################################################################
# XGBOOST with df_titanic: classification (survived) + regression (fare)
# Uses rwf's own helpers: k_fold() builds folds + xgb.DMatrix objects,
# report_xgboost() produces plots/tables from a trained xgboost::xgb.train model.
##########################################################################################
suppressMessages(library(rwf))
suppressMessages(library(xgboost))

data(df_titanic)

# sex/embarked are character -> factor so data.matrix() encodes them numerically
df_titanic$sex      <- factor(df_titanic$sex)
df_titanic$embarked <- factor(df_titanic$embarked)

##########################################################################################
# CLASSIFICATION: survived ~ predictors
##########################################################################################
classification_formula <- formula(survived ~ pclass + sex + age + sibsp + parch + fare + embarked)
df_class <- df_titanic[stats::complete.cases(df_titanic[, all.vars(classification_formula)]), ]

train_test_classification <- k_fold(df = df_class, model_formula = classification_formula, k = 5)

xgb_classification <- xgboost::xgb.train(
  params = xgboost::xgb.params(objective = "binary:logistic", eta = 0.1),
  data   = train_test_classification$xgb$f1$train,
  evals  = train_test_classification$xgb$f1$evals,
  nrounds = 50
)



report_classification <- report_xgboost(
  model           = xgb_classification,
  validation_data = train_test_classification$f$test$f1,
  label           = "survived",
  file            = "xgb_titanic_classification"
)

##########################################################################################
# REGRESSION: fare ~ predictors (same dataset, continuous outcome)
##########################################################################################
regression_formula <- formula(fare ~ pclass + sex + age + sibsp + parch + survived + embarked)
df_reg <- df_titanic[, all.vars(regression_formula)]
df_reg <- df_reg[complete.cases(df_reg),]

train_test_regression <- k_fold(df = df_reg, model_formula = regression_formula, k = 2)

xgb_regression <- xgboost::xgb.train(
  params = xgboost::xgb.params(objective = "reg:squarederror", eta = 0.1),
  data   = train_test_regression$xgb$f1$train,
  evals  = train_test_regression$xgb$f1$evals,
  nrounds = 50
)

# NOTE: report_xgboost() infers classification vs regression from model$params$objective.
# With xgboost >= 3.x this returns NULL (objective is only reachable via attr(model,"params")),
# so report_xgboost currently misclassifies regression models as classification and tries to
# build a confusion matrix over the continuous `fare` values. That's a bug in
# rwf/R/ML_XGBOOST.R (report_xgboost), not something to fix here. For the regression case we
# report predicted-vs-observed and importance ourselves instead of relying on report_xgboost().
test_reg    <- train_test_regression$f$test$f1
predictors  <- train_test_regression$predictors
observed    <- test_reg[[train_test_regression$outcome]]
predicted   <- predict(xgb_regression, xgboost::xgb.DMatrix(data = data.matrix(test_reg[, predictors])))

rmse <- sqrt(mean((observed - predicted)^2))
mae  <- mean(abs(observed - predicted))
cat("Regression (fare) test RMSE:", round(rmse, 2), " MAE:", round(mae, 2), "\n")

regression_plot <- plot_scatterplot(data.frame(observed = observed, predicted = predicted))
importance_regression <- xgboost::xgb.importance(model = xgb_regression, feature_names = predictors)
print(importance_regression)

cat("\n--- Classification (survived) evaluation log tail ---\n")
print(tail(report_classification$result$evaluation_log, 3))
