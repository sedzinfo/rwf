#########################################################################################
# TREE PLOT
#########################################################################################
#' @title Plot trees for xgboost::xgb.train
#' @description Draws the trees of an xgboost model combined into one diagram
#'   (\code{xgboost::xgb.plot.multi.trees}, keeping the 10 most important
#'   features) and saves it as a self-contained \code{<file>.html} in the
#'   working directory. Works with xgboost 3 and with older versions.
#' @param model object from xgboost::xgb.train
#' @param train Train dataset; its column names label the features. With
#'   xgboost 3 they are used only when the model itself has no feature names
#'   and the number of columns matches the number of model features.
#' @param file output filename
#' @return Called for its side effect of writing \code{<file>.html}; returns
#'   the value of \code{htmlwidgets::saveWidget} invisibly.
#' @importFrom xgboost xgb.plot.multi.trees
#' @keywords ML
#' @export
#' @examples
#' infert_formula<-formula(case~education+spontaneous+induced)
#' boston_formula<-formula(medv~crim+zn+indus+chas+nox+rm+age+dis+rad+tax+ptratio+black+lstat)
#' train_test_classification<-k_fold(df=infert,model_formula=infert_formula)
#' train_test_regression<-k_fold(df=MASS::Boston,model_formula=boston_formula)
#' xgb_classification<-xgboost::xgb.train(
#'                     data=train_test_classification$xgb$f1$train,
#'                     watchlist=train_test_classification$xgb$f1$watchlist,
#'                     eta=.1,
#'                     nthread=8,
#'                     nround=20,
#'                     objective="binary:logistic")
#' xgb_regression<-xgboost::xgb.train(
#'                 data=train_test_regression$xgb$f1$train,
#'                 watchlist=train_test_regression$xgb$f1$watchlist,
#'                 eta=.3,
#'                 nthread=8,
#'                 nround=20)
#' # xgboost::xgb.plot.multi.trees(model=xgb_classification,features_keep=2)
#' # plot_trees_xgboost(model=xgb_classification,
#' #                    train=train_test_classification$xgb$f1,
#' #                    file="Classification")
#' # plot_trees_xgboost(model=xgb_regression,
#' #                    train=train_test_regression$xbg$f1,
#' #                    file="Regression")
plot_trees_xgboost<-function(model,train,file="xgboost") {
  if ("feature_names" %in% names(formals(xgboost::xgb.plot.multi.trees))) {
    # xgboost < 3: labels, fill and names are arguments of xgb.plot.multi.trees
    xgboost_trees<-xgboost::xgb.plot.multi.trees(model=model,feature_names=colnames(train),features_keep=10,fill=TRUE,use.names=FALSE)
  } else {
    # xgboost >= 3 takes the feature names from the model and no longer accepts feature_names,
    # fill or use.names; a model without names is labelled with the columns of train on a copy
    if (length(xgboost::getinfo(model,"feature_name"))==0 && !is.null(colnames(train))) {
      n_features<-tryCatch(as.integer(xgboost::xgb.config(model)$learner$learner_model_param$num_feature),error=function(e) NA_integer_)
      if (isTRUE(n_features==ncol(train))) {
        model<-xgboost::xgb.copy.Booster(model)
        xgboost::setinfo(model,"feature_name",colnames(train))
      }
    }
    xgboost_trees<-xgboost::xgb.plot.multi.trees(model=model,features_keep=10)
  }
  htmlwidgets::saveWidget(xgboost_trees,invisible(paste0(toString(getwd()),"/",file,".html")),selfcontained=TRUE)
}
##########################################################################################
# XGBOOST
##########################################################################################
#' @title Report for xgboost::xgb.train
#' @param model object from xgboost::xgb.train
#' @param validation_data validation data
#' @param label outcome variable name
#' @param file output filename
#' @param w width of pdf file
#' @param h height of pdf file
#' @param base_size base font size
#' @param title plot title
#' @param fast if TRUE error values are not saved in output
#' @details Works with xgboost 3, which stores the call, parameters and
#'   evaluation log as attributes of the model, and with older versions that
#'   store them as list elements. Validation predictions use the model's own
#'   feature order. When \code{file} is given, the plots are written to
#'   \code{<file>.pdf} and the tables to \code{<file>.xlsx} (sheets: confusion
#'   matrix for classification, Model Summary, Validation Metrics, Feature
#'   Importance, Hyperparameters and, unless \code{fast = TRUE}, Evaluation Log).
#' @return Invisibly, a list with
#'   \describe{
#'     \item{plots}{ggplot objects: \code{regression} (observed vs predicted on
#'       the validation data), \code{performance} (cut-point diagnostics, not for
#'       regression objectives), \code{depth}, \code{cover}, \code{weight}
#'       (tree structure), \code{error} (training log) and \code{importance}.}
#'     \item{result}{tables: \code{parameters} (hyperparameters),
#'       \code{model_call}, \code{evaluation_log}, \code{importance}
#'       (\code{xgboost::xgb.importance}), \code{model_summary} (objective,
#'       boosting rounds, number of features, and with early stopping the best
#'       iteration and score) and, with validation data, \code{validation_metrics}
#'       (regression: N, RMSE, MAE, mean error, R squared; binary
#'       classification: N, AUC, log loss and accuracy at a 0.5 cut-off).}
#'     \item{observed, predicted}{validation outcome and predictions
#'       (\code{NULL} without \code{validation_data}).}
#'     \item{feature_names}{the model's features, in the model's order.}
#'   }
#' @import ggplot2
#' @importFrom openxlsx createWorkbook saveWorkbook
#' @importFrom stringr str_replace_all fixed
#' @importFrom xgboost xgb.DMatrix xgb.plot.deepness xgb.importance xgb.ggplot.importance
#' @importFrom reshape2 melt
#' @keywords ML
#' @export
#' @examples
#' infert_formula<-formula(case~education+spontaneous+induced)
#' boston_formula<-formula(medv~crim+zn+indus+chas+nox+rm+age+dis+rad+tax+ptratio+black+lstat)
#' train_test_classification<-k_fold(df=infert,model_formula=infert_formula)
#' train_test_regression<-k_fold(df=MASS::Boston,model_formula=boston_formula)
#' xgb_classification<-xgboost::xgb.train(
#'                     params=xgboost::xgb.params(objective="binary:logistic"),
#'                     data=train_test_classification$xgb$f1$train,
#'                     evals=train_test_classification$xgb$f1$watchlist,
#'                     nround=20)
#' xgb_regression<-xgboost::xgb.train(
#'                 data=train_test_regression$xgb$f1$train,
#'                 evals=train_test_regression$xgb$f1$watchlist,
#'                 nround=20)
#' report_xgboost(model=xgb_classification,
#'                validation_data=train_test_classification$f$test$f1,
#'                label=train_test_classification$outcome,
#'                file="Classification")
#' report_xgboost(model=xgb_regression,
#'                validation_data=train_test_regression$f$test$f1,
#'                label=train_test_regression$outcome,
#'                file="Regression")
report_xgboost <- function(model,
                           validation_data = NULL,
                           label = NULL,
                           file = "xgboost",
                           w = 10,
                           h = 10,
                           base_size = 10,
                           title = "",
                           fast = FALSE) {
  Depth <- Tree <- Cover <- Weight <- value <- Iteration <- Metric <- Factor <- NULL
  
  if (!inherits(model, "xgb.Booster")) {
    stop("model must be an xgboost booster object from xgboost::xgb.train")
  }
  
  plots <- list()
  result <- list()
  observed <- predicted <- NULL

  # xgboost >= 3 keeps call, params, evaluation_log and early_stop as attributes of the model;
  # older versions keep them as list elements
  model_info <- function(name) {
    value <- attr(model, name, exact = TRUE)
    if (is.null(value)) value <- tryCatch(model[[name]], error = function(e) NULL)
    value
  }
  
  objective <- tryCatch(xgboost::xgb.config(model)$learner$objective$name, error = function(e) NULL)
  if (is.null(objective)) objective <- model_info("params")$objective
  is_regression <- !is.null(objective) && grepl("^reg:|^count:|^survival:", objective)
  
  # helper: robust feature-name resolution
  resolve_feature_names <- function(model, validation_data = NULL, label = NULL) {
    # the model's own feature order (xgboost >= 3), then the older list element
    fn <- tryCatch(xgboost::getinfo(model, "feature_name"), error = function(e) NULL)
    if (is.null(fn) || length(fn) == 0) fn <- tryCatch(model$feature_names, error = function(e) NULL)
    if (!is.null(fn) && length(fn) > 0) return(fn)
    
    # fallback from tree dump
    fn_tree <- tryCatch({
      dt <- xgboost::xgb.model.dt.tree(model = model)
      unique(dt$Feature[dt$Feature != "Leaf"])
    }, error = function(e) NULL)
    if (!is.null(fn_tree) && length(fn_tree) > 0) return(fn_tree)
    
    # fallback from validation data
    if (!is.null(validation_data)) {
      if (!is.null(label) && label %in% names(validation_data)) {
        return(setdiff(names(validation_data), label))
      }
      return(names(validation_data))
    }
    
    character(0)
  }
  
  feature_names <- resolve_feature_names(model, validation_data, label)
  
  if (!is.null(validation_data)) {
    if (is.null(label) || !(label %in% names(validation_data))) {
      stop("label must be provided and exist in validation_data")
    }
    if (length(feature_names) == 0) {
      stop("Could not infer predictor columns. Provide validation_data with predictor columns and label.")
    }
    
    missing_features <- setdiff(feature_names, names(validation_data))
    if (length(missing_features) > 0) {
      stop("validation_data is missing required features: ",
           paste(missing_features, collapse = ", "))
    }
    
    observed <- validation_data[, label]
    vx <- data.matrix(validation_data[, feature_names, drop = FALSE])
    predicted <- predict(model, newdata = xgboost::xgb.DMatrix(data = vx))
    
    plots$regression <- plot_scatterplot(data.frame(observed = observed, predicted = predicted))

    # validation metrics: error measures for regression; AUC, log loss and accuracy for a
    # binary outcome predicted as probabilities
    comparable <- is.numeric(observed) && length(predicted) == length(observed)
    if (comparable && is_regression) {
      error <- predicted - observed
      result$validation_metrics <- data.frame(
        Metric = c("N", "RMSE", "MAE", "Mean error", "R squared"),
        value = c(sum(!is.na(error)), sqrt(mean(error^2, na.rm = TRUE)), mean(abs(error), na.rm = TRUE),
                  mean(error, na.rm = TRUE), stats::cor(observed, predicted, use = "complete.obs")^2),
        stringsAsFactors = FALSE
      )
    } else if (comparable && all(observed %in% c(0, 1, NA)) && all(predicted >= 0 & predicted <= 1, na.rm = TRUE)) {
      keep <- !is.na(observed) & !is.na(predicted)
      y <- observed[keep]
      p <- pmin(pmax(predicted[keep], 1e-15), 1 - 1e-15)
      auc <- tryCatch(as.numeric(pROC::auc(y, p, levels = c(0, 1), direction = "<", quiet = TRUE)), error = function(e) NA_real_)
      result$validation_metrics <- data.frame(
        Metric = c("N", "AUC", "Log loss", "Accuracy (cut-off 0.5)"),
        value = c(length(y), auc, -mean(y * log(p) + (1 - y) * log(1 - p)), mean((p >= 0.5) == y)),
        stringsAsFactors = FALSE
      )
    }
    
    if (!is_regression) {
      perf_obj <- tryCatch(
        result_confusion_performance(observed = observed, predicted = predicted),
        error = function(e) NULL
      )
      if (!is.null(perf_obj)) plots$performance <- perf_obj
    }
  }
  
  params_vec <- tryCatch(unlist(model_info("params")), error = function(e) NULL)
  if (!is.null(params_vec) && length(params_vec) > 0) {
    result$parameters <- data.frame(
      Hyperparameter = names(params_vec),
      value = as.character(params_vec),
      stringsAsFactors = FALSE
    )
  } else {
    result$parameters <- data.frame(Hyperparameter = character(0), value = character(0))
  }
  
  result$model_call <- tryCatch(
    data.frame(
      Parameters = "Call",
      value = gsub(" ", "", paste(deparse(model_info("call")), collapse = "")),
      stringsAsFactors = FALSE
    ),
    error = function(e) data.frame(Parameters = "Call", value = NA_character_)
  )
  
  evaluation_log <- tryCatch(data.frame(model_info("evaluation_log")), error = function(e) data.frame())
  result$evaluation_log <- evaluation_log

  # model summary: objective, size of the model and, with early stopping, the best iteration
  # (the early_stop attribute counts iterations from 1, like the evaluation log)
  early_stop <- model_info("early_stop")
  best_iteration <- if (!is.null(early_stop$best_iteration)) early_stop$best_iteration else model_info("best_iteration")
  best_score <- if (!is.null(early_stop$best_score)) early_stop$best_score else model_info("best_score")
  n_rounds <- tryCatch(xgboost::xgb.get.num.boosted.rounds(model), error = function(e) nrow(evaluation_log))
  result$model_summary <- data.frame(
    Statistic = c("Objective", "Boosting rounds", "Features", "Best iteration", "Best score"),
    value = c(
      if (is.null(objective)) NA_character_ else objective,
      n_rounds,
      length(feature_names),
      if (is.null(best_iteration)) NA_character_ else best_iteration,
      if (is.null(best_score)) NA_character_ else paste0(if (!is.null(names(best_score))) paste0(names(best_score), ": "), signif(best_score, 4))
    ),
    stringsAsFactors = FALSE
  )
  
  xgboost_model_depth <- tryCatch(
    data.frame(xgboost::xgb.plot.deepness(model, which = "max.depth", plot = FALSE)),
    error = function(e) NULL
  )
  
  if (!is.null(xgboost_model_depth) && nrow(xgboost_model_depth) > 0) {
    plots$depth <- ggplot2::ggplot(xgboost_model_depth, ggplot2::aes(y = Depth, x = Tree)) +
      ggplot2::geom_point(alpha = 0.1) +
      ggplot2::labs(x = "Tree", y = "Depth", title = "") +
      ggplot2::theme_bw(base_size = base_size)
    
    plots$cover <- ggplot2::ggplot(xgboost_model_depth, ggplot2::aes(y = Cover, x = Tree)) +
      ggplot2::geom_point(alpha = 0.1) +
      ggplot2::labs(x = "Tree", y = "Cover", title = "") +
      ggplot2::theme_bw(base_size = base_size)
    
    plots$weight <- ggplot2::ggplot(xgboost_model_depth, ggplot2::aes(y = Weight, x = Tree)) +
      ggplot2::geom_point(alpha = 0.1) +
      ggplot2::labs(x = "Tree", y = "Weight", title = "") +
      ggplot2::theme_bw(base_size = base_size)
  }
  
  if (nrow(evaluation_log) > 0 && "iter" %in% names(evaluation_log)) {
    error_df <- reshape2::melt(evaluation_log, id.vars = "iter", variable.name = "Metric")
    names(error_df) <- c("Iteration", "Metric", "value")
    error_df$Metric <- str_aes(error_df$Metric)
    
    plots$error <- ggplot2::ggplot(error_df, ggplot2::aes(y = value, x = Iteration, color = Metric)) +
      ggplot2::geom_line(linewidth = base_size / 15) +
      ggplot2::labs(x = "Iteration", y = "Metric Value", title = paste0("Training Log: ", title)) +
      ggplot2::theme_bw(base_size = base_size)
  }
  
  importance_data <- tryCatch(
    as.data.frame(xgboost::xgb.importance(model = model, feature_names = feature_names)),
    error = function(e) data.frame()
  )
  result$importance <- importance_data
  
  if (nrow(importance_data) > 0) {
    if (!("Feature" %in% names(importance_data))) {
      names(importance_data)[1] <- "Feature"
    }
    
    metric_cols <- intersect(
      c("Importance", "Gain", "Cover", "Frequency", "Weight", "TotalGain", "TotalCover"),
      names(importance_data)
    )
    
    if (length(metric_cols) > 0) {
      ord_col <- metric_cols[1]
      importance_data$Feature <- factor(
        importance_data$Feature,
        levels = importance_data[order(importance_data[[ord_col]]), "Feature"]
      )
      
      importance_long <- reshape2::melt(
        importance_data[, c("Feature", metric_cols), drop = FALSE],
        id.vars = "Feature"
      )
      names(importance_long)[1:2] <- c("Factor", "Metric")
      
      plots$importance <- ggplot2::ggplot(importance_long, ggplot2::aes(y = value, x = Factor, fill = Metric)) +
        ggplot2::geom_bar(stat = "identity", position = ggplot2::position_dodge(), colour = "white") +
        ggplot2::labs(x = "Predictor", y = "Relative Importance", title = paste("Importance", title)) +
        ggplot2::theme_bw(base_size = base_size) +
        ggplot2::coord_flip()
    }
  }
  
  if (!is.null(file) && length(plots) > 0) {
    report_pdf(plotlist = plots, file = file, title = title, w = w, h = h, print_plot = TRUE)
  }
  
  if (!is.null(file)) {
    filename <- paste0(file, ".xlsx")
    if (file.exists(filename)) file.remove(filename)
    wb <- openxlsx::createWorkbook()
    
    if (!is.null(plots$performance) && !is.null(plots$performance$confusion_matrix)) {
      excel_confusion_matrix(plots$performance$confusion_matrix, wb)
    }
    
    excel_critical_value(result$model_summary, wb, "Model Summary", numFmt = "#0.00")

    if (!is.null(result$validation_metrics)) {
      excel_critical_value(result$validation_metrics, wb, "Validation Metrics", numFmt = "#0.000")
    }

    if (nrow(importance_data) > 0) {
      excel_critical_value(importance_data, wb, "Feature Importance", numFmt = "#0.00")
    }
    
    if (nrow(result$parameters) > 0) {
      excel_critical_value(result$parameters, wb, "Hyperparameters", numFmt = "#0.00")
    }
    
    if (!fast && nrow(result$evaluation_log) > 0) {
      excel_critical_value(result$evaluation_log, wb, "Evaluation Log", numFmt = "#0.00")
    }
    
    openxlsx::saveWorkbook(wb = wb, file = filename, overwrite = TRUE)
  }
  
  invisible(list(
    plots = plots,
    result = result,
    observed = observed,
    predicted = predicted,
    feature_names = feature_names
  ))
}
