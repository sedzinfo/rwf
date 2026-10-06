##########################################################################################
# PLOT ROC
##########################################################################################
#' @title Plot Receiver Operating Characteristic (ROC) curve 
#' @description Generates a ROC curve from observed outcomes and predicted probabilities.
#' @param observed Vector of observed outcomes. These are the true class labels.
#' @param predicted Vector of predicted outcome probabilities. These are the predicted probabilities for the positive class.
#' @param base_size Integer value representing the base font size for the plot. Defaults to 10.
#' @param title String representing the title of the plot. Defaults to an empty string.
#' @importFrom pROC roc ggroc
#' @keywords functions
#' @export
#' @details
#' This function generates a ROC curve to evaluate the performance of a binary classification model. 
#' The ROC curve is a plot of the true positive rate (TPR) against the false positive rate (FPR) at various threshold settings.
#'
#' The function performs the following steps:
#' 1. Computes the ROC curve and its confidence interval using `pROC::roc`.
#' 2. Generates ROC plots for both reversed and non-reversed order of class levels.
#' 3. Creates a list of ROC plots,each with an AUC value,control level,and direction.
#'
#' The output is a list of ggplot objects representing the ROC curves for different class level orders.
#' @examples
#' # Example with random observed and predicted values
#' observed<-round(abs(rnorm(100,m=0,sd=0.5)))
#' predicted<-abs(rnorm(100,m=0,sd=0.5))
#' plot_roc(observed=observed,predicted=predicted)
#'
#' # Example with generated correlation matrix
#' df1<-data.frame(matrix(0.999,ncol=2,nrow=2))
#' correlation_matrix<-as.matrix(df1)
#' diag(correlation_matrix)<-1
#' df1<-generate_correlation_matrix(correlation_matrix,nrows=1000)
#' df1$X1<-ifelse(abs(df1$X1) < 1,0,1)
#' df1$X2<-abs(df1$X2)
#' df1$X2<-(df1$X2-min(df1$X2))/(max(df1$X2)-min(df1$X2))
#' plot_roc(observed=round(abs(df1$X1),0),predicted=abs(df1$X2))
plot_roc<-function(observed,predicted,base_size=10,title="") {
  plotlist<-list()
  rco1<-pROC::roc(observed,predicted,ci=TRUE,levels=as.factor(rev(sort(unique(observed)))),quiet=TRUE)
  rco2<-pROC::roc(observed,predicted,ci=TRUE,levels=as.factor(sort(unique(observed))),quiet=TRUE)
  rp<-function(rco) {
    plot<-pROC::ggroc(rco,alpha=0.5)+
      geom_abline(intercept=1,slope=1)+
      labs(title=paste("ROC",title),
           caption=paste0("Observations:",length(observed),
                          "\nAUC:",round(as.numeric(as.character(rco$auc))*100,2),"%",
                          "\nControl Level:",as.character(rco$levels),
                          "\nDirection:",rco$direction))+
      theme_bw(base_size=base_size)+
      coord_fixed()
    return(plot)
  }
  plotlist[[toString(rco1$levels)]]<-rp(rco1)
  plotlist[[toString(rco2$levels)]]<-rp(rco2)
  invisible(lapply(plotlist,print))
  return(invisible(plotlist))
}
##########################################################################################
# PLOT CONFUSION
##########################################################################################
#' @title Plot confusion matrix
#' @description This function creates a confusion matrix plot with observed and predicted outcomes,including row and column percentages,and various accuracy metrics.
#' @param observed Vector of observed outcomes. This can be numeric or factor values representing the true class labels.
#' @param predicted Vector of predicted outcomes. This should have the same length as the observed vector and represent the predicted class labels.
#' @param base_size Integer value representing the base font size for the plot. Defaults to 10.
#' @param title String representing the title of the plot. Defaults to an empty string.
#' @importFrom reshape2 melt
#' @keywords functions
#' @export
#' @details
#' This function generates a confusion matrix plot using ggplot2. It provides a visual representation of the
#' confusion matrix with observed outcomes on the x-axis and predicted outcomes on the y-axis. The cells of the
#' matrix are filled with the count of observations and annotated with the corresponding values.
#'
#' The plot also includes various accuracy metrics in the caption,such as:
#'-Overall Accuracy: Proportion of correctly classified observations (diagonal elements).
#'-Off-diagonal Accuracy: Proportion of misclassified observations (off-diagonal elements).
#'-Cohen's Kappa (Unweighted,Linear,and Squared): Measures the agreement between observed and predicted outcomes.
#' @examples
#' # Example with numeric class labels
#' plot_confusion(observed=c(1,2,3,1,2,3),predicted=c(1,2,3,1,2,3))
#'
#' # Example with factor class labels
#' observed<-c(rep("male",10),rep("female",10),"male","male")
#' predicted<-c(rep("male",10),rep("female",10),"female","female")
#' plot_confusion(observed=observed,predicted=predicted)
plot_confusion<-function(observed,predicted,base_size=10,title="") {
  value<-NULL
  cmatrixp<-confusion_matrix_percent(observed=observed,predicted=predicted)
  cmatrix<-confusion(observed=observed,predicted=predicted)
  pa<-proportion_accurate(observed=observed,predicted=predicted)
  observations<-sum(cmatrix)
  cmatrix<-reshape2::melt(cmatrix)
  cmatrix$observed<-factor(cmatrix$observed,levels=rev(sort(unique(cmatrix$observed))))
  cmatrix$predicted<-factor(cmatrix$predicted,levels=sort(unique(cmatrix$predicted)))
  plot_confusion<-ggplot(cmatrix,aes(x=observed,y=predicted,fill=value))+
    geom_tile(color="white")+
    geom_text(aes(x=observed,y=predicted,label=value),color="black",size=base_size/2)+
    theme_bw(base_size=base_size)+
    theme(axis.ticks.x=element_blank(),
          axis.ticks.y=element_blank(),
          panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),
          panel.border=element_blank(),
          panel.background=element_blank(),
          legend.position="none")+
    scale_fill_continuous(low="#fafaff")+
    scale_x_discrete(position="top")+
    labs(title=paste("Confusion Matrix",title),
         caption=paste0("Observations:",observations,
                        "\nAccuracy:",round(pa$cm_diagonal,2),
                        "\nAccuracy with off diagonals:",round(pa$cm_off_diagonal,2),
                        "\nKappa unweighted:",round(pa$kappa_unweighted,2),
                        "\nKappa linear:",round(pa$kappa_linear,2),
                        "\nKappa squared:",round(pa$kappa_squared,2)))+
    coord_fixed()
  return(plot_confusion)
}
##########################################################################################
# PLOT SEPARABILITY
##########################################################################################
#' @title Plot separability
#' @description This function creates a separability plot showing the density distribution of predicted probabilities for different observed categories.
#' @param observed Vector of observed outcomes. This can be numeric or factor values representing the true class labels.
#' @param predicted Vector of predicted outcome probabilities. This should have the same length as the observed vector and represent the predicted probabilities.
#' @param base_size Integer value representing the base font size for the plot. Defaults to 10.
#' @param title String representing the title of the plot. Defaults to an empty string.
#' @keywords functions
#' @export
#' @details
#' This function generates a separability plot using ggplot2. It shows the density distribution of predicted probabilities for different observed categories.
#' The plot helps to visualize how well the predicted probabilities separate the different observed categories.
#'
#' The plot includes the following components:
#'-Density curves for each observed category,representing the distribution of predicted probabilities.
#'-A legend indicating the observed categories.
#'-The total number of observations is included in the plot caption.
#' @examples
#' # Example with numeric class labels
#' df1<-data.frame(matrix(.999,ncol=2,nrow=2))
#' correlation_matrix<-as.matrix(df1)
#' diag(correlation_matrix)<-1
#' df1<-generate_correlation_matrix(correlation_matrix,nrows=1000)
#' df1$X1<-ifelse(abs(df1$X1) < 1,0,1)
#' df1$X2<-abs(df1$X2)
#' df1$X2<-(df1$X2-min(df1$X2))/(max(df1$X2)-min(df1$X2))
#' plot_separability(observed=round(abs(df1$X1),0),predicted=abs(df1$X2))
plot_separability<-function(observed,predicted,base_size=10,title="") {
  df<-data.frame(observed=as.factor(observed),predicted=predicted)
  plot<-ggplot(df,aes(x=predicted,color=factor(observed)))+
    geom_density(linewidth=1)+
    labs(title=paste("Predicted proportion vs Observed category",title),
         color="observed",
         caption=paste0("Observations:",nrow(df)))+
    theme_bw(base_size=base_size)
  return(plot)
}
##########################################################################################
# PLOT CONFUSION PERFORMANCE
##########################################################################################
#' @title Plot performance of confusion matrix for different cut off points
#' @description This function generates a plot to visualize the performance of a confusion matrix at various cut-off points. 
#' It evaluates the proportion of correct classifications and identifies the optimal cut-off point.
#' @inheritParams plot_roc
#' @param step Numeric value representing the stepping for tested cut values. Defaults to 0.1.
#' @importFrom plyr rbind.fill
#' @importFrom reshape2 melt
#' @keywords functions
#' @export
#' @details
#' This function evaluates the performance of a confusion matrix at different cut-off points. It iterates through a range of cut-off points,
#' calculates the confusion matrix,and evaluates the proportion of correct classifications for each cut-off.
#'
#' The function generates a plot that includes:
#'-The proportion of correct classifications for different cut-off points.
#'-Vertical lines indicating the optimal cut-off point.
#'-A legend representing different performance metrics.
#'-A caption showing the number of observations and the optimal cut-off point.
#'
#' The function returns a list containing the plot,the data frame with cut-off performance,the optimal cut-off point,
#' and the confusion matrix at the optimal cut-off.
#' @examples
#' # Example with numeric class labels
#' df<-data.frame(matrix(.999,ncol=2,nrow=2))
#' correlation_matrix<-as.matrix(df)
#' diag(correlation_matrix)<-1
#' df<-generate_correlation_matrix(correlation_matrix,nrows=1000)
#' df$X1<-ifelse(abs(df$X1) < 1,0,1)
#' df$X2<-abs(df$X2)
#' df$X2<-(df$X2-min(df$X2))/(max(df$X2)-min(df$X2))
#' result_confusion_performance(observed=round(abs(df$X1),0),
#'                              predicted=abs(df$X2),
#'                              step=0.01)
result_confusion_performance<-function(observed,predicted,step=.1,base_size=10,title="") {
  cut_point<-value<-variable<-NULL
  df_cut_performance<-data.frame()
  min_predicted<-min(predicted,na.rm=TRUE)
  max_predicted<-max(predicted,na.rm=TRUE)
  for(i in seq(min_predicted,max_predicted,by=step)) {
    confusion(observed=observed,predicted=ifelse(predicted>i,1,0))
    cmatrix<-confusion_matrix_percent(observed=observed,predicted=ifelse(predicted>i,1,0))
    collumn_proportion<-data.frame(Collumn_Observed=t(as.numeric(cmatrix[1:(nrow(cmatrix)-2),length(cmatrix)])))
    row_proportion<-data.frame(Row_Predicted=t(as.numeric(cmatrix[nrow(cmatrix),1:(length(cmatrix)-2)])))
    overall<-as.numeric(cmatrix[nrow(cmatrix),length(cmatrix)])
    result<-data.frame(cut_point=i,Overall=overall,collumn_proportion,row_proportion)
    df_cut_performance<-plyr::rbind.fill(df_cut_performance,result)
  }
  cp<-reshape2::melt(df_cut_performance,id.vars="cut_point")
  df_cut_performance$Mean_proportion<-rowMeans(df_cut_performance[,3:length(df_cut_performance)],na.rm=TRUE)
  mcp<-df_cut_performance[df_cut_performance$Mean_proportion %in% max(df_cut_performance$Mean_proportion),"cut_point"]
  cmatrix<-confusion(observed=observed,predicted=ifelse(predicted>mean(mcp,na.rm=TRUE),1,0))
  cmatrixp<-confusion_matrix_percent(observed=observed,predicted=ifelse(predicted>mean(mcp,na.rm=TRUE),1,0))
  plot_performance<-ggplot(cp,aes(x=cut_point,y=value,color=variable,linetype=variable))+
    geom_line(size=1)+
    geom_vline(xintercept=mcp,size=1)+
    labs(title=paste("Confusion Matrix Performance",title),
         x="Cut Point",
         y="Proportion Correct",
         caption=paste0("Observations:",nrow(df_cut_performance),"\nCut point:",round(mcp,4)))+
    theme(legend.title=element_blank())+
    scale_color_discrete(name="")+
    scale_linetype(name="")+
    theme_bw(base_size=base_size)
  result<-list(plot_performance=plot_performance,
               cut_performance=df_cut_performance,
               cut=mcp,
               confusion_matrix=cmatrixp)
  return(result)
}
##########################################################################################
# TRAIN TEST DATAFRAME WITH RESPONSES
##########################################################################################
#' @title K-Fold train test sampling
#' @description Splits a dataframe into train and test dataframes for model evaluation. Prepared data include data objects for xgboost.
#' @param df Dataframe containing the dataset to be split.
#' @param model_formula Model formula specifying the predictors and outcome variable.
#' @param k Integer value representing the number of folds. Defaults to 10.
#' @importFrom xgboost xgb.DMatrix
#' @importFrom stats get_all_vars
#' @keywords functions
#' @export
#' @details
#' This function performs k-fold cross-validation by splitting the input dataframe into k folds. 
#' Each fold serves as a test set once,while the remaining k-1 folds form the training set.
#'
#' The function prepares data objects for xgboost model training and evaluation,including train/test datasets and xgboost DMatrix objects.
#'
#' The output is a list containing the following elements:
#'-`f`: List of train and test datasets for each fold.
#'-`index`: Vector of fold indices.
#'-`model_formula`: Model formula used for generating the datasets.
#'-`variables`: Names of the variables in the model formula.
#'-`predictors`: Names of the predictor variables.
#'-`outcome`: Name of the outcome variable.
#'-`xgb`: List of xgboost DMatrix objects for training and testing.
#' @examples
#' # Example with the 'infert' dataset
#' infert_formula<-formula(case~education+spontaneous+induced)
#' result<-k_fold(infert,k=10,model_formula=infert_formula)
#'
#' # Example with the 'mtcars' dataset
#' model_formula<-as.formula(mpg~cyl+disp+hp+drat+wt+qsec+vs+am+gear+carb)
#' result<-k_fold(mtcars,k=2,model_formula=model_formula)
k_fold<-function(df,model_formula,k=10) {
  variable_names<-names(stats::get_all_vars(model_formula,data=df))
  index<-sample(cut(1:nrow(df),breaks=k,labels=FALSE))
  rows<-1:nrow(df)
  fold<-xgboost<-list()
  df<-stats::get_all_vars(model_formula,df)
  predictors<-all.vars(model_formula[[3]])
  outcome<-all.vars(model_formula[[2]])
  for (i in 1:k) {
    k_index<-paste0("f",i)
    fold[["index"]][[k_index]]<-iteration_index<-which(index==i)
    fold[["train"]][[k_index]]<-train<-df[rows[-iteration_index],]
    fold[["test"]][[k_index]]<-test<-df[rows[iteration_index],]
    fold[["x_test"]][[k_index]]<-test[,predictors]
    fold[["y_test"]][[k_index]]<-test[,outcome]
    xgbtrain<-xgboost::xgb.DMatrix(data=data.matrix(train[,predictors]),label=train[,outcome])
    xgbtest<-xgboost::xgb.DMatrix(data=data.matrix(test[,predictors]),label=test[,outcome])
    evals<-list(train=xgbtrain,test=xgbtest)
    xgboost[[k_index]]<-list(train=xgbtrain,test=xgbtest,
                 evals=evals,
                 watchlist=evals,
                             ytrain=fold$train[[k_index]][,outcome],
                             ytest=fold$test[[k_index]][,outcome])
    cat("Fold Cases:",i,
        "Train:",nrow(train),
        "Test:",nrow(test),
        "Total:",sum(nrow(train),nrow(test)),
        "Unique Train:",length(unique(row.names(train))),
        "Unique Test:",length(unique(row.names(test))),"\n")
  }
  result<-list(f=fold,
               index=index,
               model_formula=model_formula,
               variables=variable_names,
               predictors=predictors,
               outcome=outcome,
               xgb=xgboost)
  return(result)
}
##########################################################################################
# TRAIN TEST DATAFRAME WITH RESPONSES
##########################################################################################
#' @title Train test sampling
#' @description Splits a dataframe into train and test dataframes for model evaluation. Prepared data include data objects for xgboost.
#' @param df Dataframe containing the dataset to be split.
#' @param model_formula Model formula specifying the predictors and outcome variable.
#' @param k Integer value representing the number of folds. Defaults to 1 (train-test split).
#' @importFrom xgboost xgb.DMatrix
#' @importFrom stats get_all_vars
#' @keywords functions
#' @export
#' @details
#' This function performs k-fold cross-validation or a simple train-test split (if k=1) by splitting the input dataframe into k folds. 
#' Each fold serves as a test set once,while the remaining k-1 folds form the training set.
#'
#' The function prepares data objects for xgboost model training and evaluation,including train,test,and validation datasets and xgboost DMatrix objects.
#'
#' The output is a list containing the following elements:
#'-`f`: List of train,test,and validation datasets for each fold.
#'-`index`: Vector of fold indices.
#'-`model_formula`: Model formula used for generating the datasets.
#'-`variables`: Names of the variables in the model formula.
#'-`predictors`: Names of the predictor variables.
#'-`outcome`: Name of the outcome variable.
#'-`xgb`: List of xgboost DMatrix objects for training,testing,and validation.
#' @examples
#' # Example with the 'infert' dataset
#' infert_formula<-formula(case~education+spontaneous+induced)
#' result<-k_sample(df=infert,k=10,model_formula=infert_formula)
#'
#' # Example with the 'mtcars' dataset
#' model_formula<-formula(mpg~cyl+disp+hp+drat+wt+qsec+vs+am+gear+carb)
#' result<-k_sample(df=mtcars,k=10,model_formula=model_formula)
k_sample<-function(df,model_formula,k=1) {
  sv<-function(vector)
    split(vector,ceiling(seq_along(vector)/(length(vector)/2)))
  variable_names<-names(stats::get_all_vars(model_formula,data=df))
  if(k>1) {
    index<-sample(cut(1:nrow(df),breaks=k,labels=FALSE))
  } else {
    index<-rep(1,nrow(df))
  }
  rows<-1:nrow(df)
  fold<-xgb<-list()
  df<-stats::get_all_vars(model_formula,df)
  predictors<-all.vars(model_formula[[3]])
  outcome<-all.vars(model_formula[[2]])
  for (i in 1:k) {
    k_index<-paste0("fold",i)
    iteration_index<-sample(which(index==i))
    train_index<-as.numeric(sv(iteration_index)[[1]])
    test_validation_index<-as.numeric(sv(iteration_index)[[2]])
    test_index<-as.numeric(sv(test_validation_index)[[1]])
    validation_index<-as.numeric(sv(test_validation_index)[[2]])
    fold[["index"]][["train"]][[k_index]]<-rows[train_index]
    fold[["index"]][["test"]][[k_index]]<-rows[test_index]
    fold[["index"]][["validation"]][[k_index]]<-rows[validation_index]
    fold[["train"]][[k_index]]<-train<-df[rows[train_index],]
    fold[["test"]][[k_index]]<-test<-df[rows[test_index],]
    fold[["validation"]][[k_index]]<-validation<-df[rows[validation_index],]
    fold[["x_test"]][[k_index]]<-test[,predictors]
    fold[["y_test"]][[k_index]]<-test[,outcome]
    fold[["x_validation"]][[k_index]]<-validation[,predictors]
    fold[["y_validation"]][[k_index]]<-validation[,outcome]
    xgbtrain<-xgboost::xgb.DMatrix(data=data.matrix(train[,predictors]),label=train[,outcome])
    xgbtest<-xgboost::xgb.DMatrix(data=data.matrix(test[,predictors]),label=test[,outcome])
    xgbvalidation<-xgboost::xgb.DMatrix(data=data.matrix(validation[,predictors]),label=validation[,outcome])
    evals<-list(train=xgbtrain,test=xgbtest)
    xgb[[k_index]]<-list(train=xgbtrain,
                         test=xgbtest,
                         validation=xgbvalidation,
               evals=evals,
               watchlist=evals,
                         ytrain=fold$train[[k_index]][,outcome],
                         ytest=fold$test[[k_index]][,outcome],
                         yvalidation=fold$test[[k_index]][,outcome])
    cat("Fold Cases:",i,
        "Train:",nrow(train),
        "Test:",nrow(test),
        "Validation:",nrow(test),
        "Total:",sum(nrow(train),nrow(test),nrow(validation)),
        "Unique Train:",length(unique(row.names(train))),
        "Unique Test:",length(unique(row.names(test))),
        "Unique Validation:",length(unique(row.names(validation))),
        "\n")
  }
  result<-list(f=fold,
               index=index,
               model_formula=model_formula,
               variables=variable_names,
               predictors=predictors,
               outcome=outcome,
               xgb=xgb)
  
  return(result)
}
##########################################################################################
# SCALE
##########################################################################################
#' @title Scale and dummy code
#' @description Scales numeric variables between 0 and 1 and creates dummy coding for character and factor variables.
#' @param df Dataframe containing the dataset to be scaled and dummy coded.
#' @param categories Numeric value representing the number of unique values a vector must have to perform dummy coding. Defaults to 10.
#' @importFrom psych dummy.code
#' @keywords functions
#' @export
#' @details
#' This function processes a dataframe by scaling numeric variables and creating dummy codes for character and factor variables. 
#' The numeric variables are scaled between 0 and 1,while the character and factor variables are converted to dummy variables if they have fewer unique values than 
#' the specified `categories` parameter.
#'
#' The function performs the following steps:
#' 1. Identifies numeric variables in the dataframe and scales them.
#' 2. Identifies character and factor variables and creates dummy variables if they meet the criteria.
#' 3. Combines the scaled numeric variables and dummy variables into a single dataframe.
#'
#' The output is a dataframe with scaled numeric variables and dummy-coded character/factor variables.
#' @examples
#' # Example with the 'infert' dataset
#' recode_scale_dummy(infert)
#'
#' # Example with a custom dataframe
#' df<-data.frame(numeric_var=c(1,2,3,4,5),
#'                factor_var=factor(c('A','B','A','B','C')))
#' recode_scale_dummy(df)
recode_scale_dummy<-function(df,categories=10) {
  index_numeric<-names(df[,sapply(df,is.numeric)])
  if(sum(sapply(df,function(x) is.character(x)|is.factor(x)))>1){
    index<-apply(df[,sapply(df,function(x) is.character(x)|is.factor(x))],2,function(x) length(table(x)))<categories
    index<-names(index)[index]
    dummy<-do.call(data.frame,sapply(df[,index],psych::dummy.code,na.rm=TRUE))
  }
  if(sum(sapply(df,function(x) is.character(x)|is.factor(x)))==1){
    index<-sapply(df,function(x) length(unique(x))<categories&&is.character(x)|is.factor(x))
    index<-names(index)[index]
    dummy<-psych::dummy.code(df[,index],na.rm=TRUE)
  }
  if(sum(sapply(df,function(x) is.character(x)|is.factor(x)))==0)
    dummy<-NULL
  maxs<-apply(df[,index_numeric],2,max,na.rm=TRUE)
  mins<-apply(df[,index_numeric],2,min,na.rm=TRUE)
  scale<-as.data.frame(scale(df[,index_numeric],center=mins,scale=maxs-mins))
  if(!is.null(dummy))
    result<-data.frame(dummy,scale)
  else
    result<-scale
  row.names(result)<-row.names(df)
  return(result)
}
##########################################################################################
# PROPORTION ACCURATE
##########################################################################################
#' @title Proportion overall accuracy of a confusion matrix
#' @description Calculates the overall accuracy and Cohen's kappa statistics of a confusion matrix.
#' @inheritParams confusion
#' @importFrom irr kappa2
#' @keywords functions
#' @export
#' @details
#' This function evaluates the performance of a confusion matrix by calculating the overall accuracy and Cohen's kappa statistics.
#'
#' The function performs the following steps:
#' 1. Computes the confusion matrix from the observed and predicted values.
#' 2. Calculates the diagonal proportion (overall accuracy) and the off-diagonal proportion.
#' 3. Computes Cohen's kappa statistics (unweighted,linear,and squared weights).
#' 
#' The output is a data.frame containing the following metrics:
#'-`cm_diagonal`: Proportion of correct classifications (diagonal elements).
#'-`cm_off_diagonal`: Proportion of misclassified observations (off-diagonal elements).
#'-`kappa_unweighted`: Cohen's kappa statistic with no weights.
#'-`kappa_linear`: Cohen's kappa statistic with linear weights.
#'-`kappa_squared`: Cohen's kappa statistic with squared weights.
#' @examples
#' # Example with numeric observed and predicted values
#' proportion_accurate(observed=c(1,2,3,4,5,10),predicted=c(1,2,3,4,5,11))
proportion_accurate<-function(observed,predicted) {
  cmatrix<-confusion(observed=observed,predicted=predicted)
  train_test<-data.frame(observed=observed,predicted=predicted)
  cm_diagonal<-sum(diag(cmatrix))/sum(matrix(cmatrix,ncol=1))
  index<-off_diagonal_index(nrow(cmatrix))
  data<-c()
  for (i in 1:nrow(cmatrix)){
    data<-c(data,cmatrix[index[i,1],index[i,2]])
    if(index[i,3]>0 && index[i,3]<=nrow(cmatrix))
      data<-c(data,cmatrix[index[i,1],index[i,3]])
    if(index[i,4]>0 && index[i,4]<=nrow(cmatrix))
      data<-c(data,cmatrix[index[i,1],index[i,4]])
  }
  cm_off_diagonal<-sum(data)/sum(matrix(cmatrix,ncol=1))
  kappa_squared<-irr::kappa2(train_test,"squared",sort.levels=TRUE)
  kappa_linear<-irr::kappa2(train_test,"equal",sort.levels=TRUE)
  kappa_unweighted<-irr::kappa2(train_test,"unweighted",sort.levels=TRUE)
  result<-data.frame(cm_diagonal=cm_diagonal,
                     cm_off_diagonal=cm_off_diagonal,
                     kappa_unweighted=kappa_unweighted$value,
                     kappa_linear=kappa_linear$value,
                     kappa_squared=kappa_squared$value)
  return(result)
}
##########################################################################################
# CONFUSION MATRIX
##########################################################################################
#' @title Create a confusion matrix from observed and predicted vectors
#' @description Generates a confusion matrix from observed and predicted values.
#' @param observed Vector of observed variables. These are the true class labels.
#' @param predicted Vector of predicted variables. These are the predicted class labels.
#' @importFrom gtools mixedsort
#' @keywords functions
#' @export
#' @details
#' This function creates a confusion matrix by comparing the observed (true) class labels with the predicted class labels.
#' The confusion matrix is a table that is often used to describe the performance of a classification model.
#' The function performs the following steps:
#' 1. Identifies the unique class labels from both the observed and predicted vectors.
#' 2. Sorts the class labels in a mixed order (if they are character variables) using `gtools::mixedsort`.
#' 3. Constructs a table to represent the confusion matrix with the sorted class labels as levels.
#' The output is a confusion matrix,where rows represent the predicted class labels and columns represent the observed class labels.
#' @examples
#' # Example with numeric observed and predicted values
#' confusion(observed=c(1,2,3,4,5,10),predicted=c(1,2,3,4,5,11))
#' # Example with repeated observed and predicted values
#' confusion(observed=c(1,2,2,2,2),predicted=c(1,1,2,2,2))
confusion<-function(observed,predicted) {
  levels<-gtools::mixedsort(as.character(unique(c(observed,predicted))),decreasing=FALSE)
  result<-table(predicted=factor(as.character(predicted),levels=levels),
                observed=factor(as.character(observed),levels=levels))
  return(result)
}
##########################################################################################
# CONFUSION MATRIX PERCENT
##########################################################################################
#' @title Confusion matrix with row and column percent
#' @description Generates a confusion matrix from observed and predicted values,including row and column percentages.
#' @inheritParams confusion
#' @keywords functions
#' @note
#' Total measures-Accuracy: (TP+TN)/total\cr
#' Total measures-Prevalence: (TP+FN)/total\cr
#' Total measures-Proportion Incorrectly Classified: (FN+FP)/total\cr
#' Horizontal measures-True Positive Rate-Sensitivity: TP/(TP+FN)\cr
#' Horizontal measures-True Negative Rate-Specificity: TN/(FP+TN)\cr
#' Horizontal measures-False Negative Rate-Miss Rate: FN/(TP+FN)\cr
#' Horizontal measures-False Positive Rate-Fall-out: FP/(FP+TN)\cr
#' Vertical measures-Positive Predictive value-Precision: TP/(TP+FP)\cr
#' Vertical measures-Negative Predictive value: TN/(FN+TN)\cr
#' Vertical measures-False Omission Rate: FN/(FN+TN)\cr
#' Vertical measures-False Discovery Rate: FP/(TP+FP)\cr
#' @export
#' @details
#' This function creates a confusion matrix by comparing the observed (true) class labels with the predicted class labels. Additionally,
#' it calculates row and column percentages to provide a more detailed performance analysis.
#'
#' The function performs the following steps:
#' 1. Computes the confusion matrix from the observed and predicted values.
#' 2. Calculates the overall accuracy by dividing the sum of diagonal elements by the total number of observations.
#' 3. Appends row and column sums to the confusion matrix.
#' 4. Computes precision and recall for each class and appends these metrics to the matrix.
#' 5. Returns a formatted data frame with the confusion matrix,row and column percentages,and overall accuracy.
#' @examples
#' # Example with numeric observed and predicted values
#' confusion_matrix_percent(observed=c(1,2,3,4,5,10),predicted=c(1,2,3,4,5,11))
#'
#' # Example with repeated observed and predicted values
#' confusion_matrix_percent(observed=c(1,2,2,2,2),predicted=c(1,1,2,2,2))
#'
#' # Example with random observed and predicted values
#' observed<-factor(round(rnorm(10000,m=10,sd=1)))
#' predicted<-factor(round(rnorm(10000,m=10,sd=1)))
#' confusion_matrix_percent(observed,predicted)
confusion_matrix_percent<-function(observed,predicted) {
  cmatrix<-confusion(observed=observed,predicted=predicted)
  overall_accuracy<-sum(as.numeric(diag(cmatrix)))/sum(as.numeric(matrix(cmatrix,ncol=1)))
  cmatrix<-cbind(cmatrix,sum=(apply(cmatrix[,1:ncol(cmatrix)],1,sum,na.rm=TRUE)))
  cmatrix<-rbind(cmatrix,sum=(apply(cmatrix[1:nrow(cmatrix),],2,sum,na.rm=TRUE)))
  dimensions<-dim(cmatrix)
  recall<-precision<-c()
  for (i in 1:dimensions[1]) {
    precision<-c(precision,cmatrix[i,i]/cmatrix[i,ncol(cmatrix)])
    recall<-c(recall,(cmatrix[i,i]/cmatrix[nrow(cmatrix),i]))
  }
  cmatrix<-rbind(cbind(cmatrix,precision),c(recall,overall_accuracy))
  row.names(cmatrix)[nrow(cmatrix)]<-"p"
  colnames(cmatrix)[dim(cmatrix)[[1]]]<-"p"
  cmatrix[is.nan(cmatrix)]<-0
  result<-data.frame(cmatrix,check.names=FALSE)
  result<-format(round(result,2),nsmall=2)
  return(result)
}
##########################################################################################
# EXTENDED CONFUSION MATRIX PLOT (binary)
##########################################################################################
#' Plot a confusion matrix with the full set of derived measures
#'
#' Draws a 2x2 confusion matrix (raw counts, sequential-blue by magnitude)
#' alongside the row/column/overall measures:
#' \describe{
#'   \item{Total measures}{Accuracy, Prevalence, Proportion Incorrectly Classified}
#'   \item{Horizontal measures}{Sensitivity/Miss Rate (observed positive column),
#'     Specificity/Fall-out (observed negative column)}
#'   \item{Vertical measures}{Precision/False Discovery Rate (predicted positive row),
#'     Negative Predictive Value/False Omission Rate (predicted negative row)}
#' }
#'
#' @details
#' With \eqn{TP}, \eqn{TN}, \eqn{FP} and \eqn{FN} the numbers of true positives,
#' true negatives, false positives and false negatives, and
#' \eqn{N = TP + TN + FP + FN} the total number of cases:
#' \describe{
#'   \item{Accuracy}{\eqn{\frac{TP + TN}{N}}{(TP + TN) / N}}
#'   \item{Prevalence}{\eqn{\frac{TP + FN}{N}}{(TP + FN) / N}}
#'   \item{Proportion Incorrectly Classified}{\eqn{\frac{FN + FP}{N} = 1 - \mathrm{Accuracy}}{(FN + FP) / N = 1 - Accuracy}}
#'   \item{Sensitivity (true positive rate, recall)}{\eqn{\frac{TP}{TP + FN}}{TP / (TP + FN)}}
#'   \item{Miss Rate (false negative rate)}{\eqn{\frac{FN}{TP + FN} = 1 - \mathrm{Sensitivity}}{FN / (TP + FN) = 1 - Sensitivity}}
#'   \item{Specificity (true negative rate)}{\eqn{\frac{TN}{FP + TN}}{TN / (FP + TN)}}
#'   \item{Fall-out (false positive rate)}{\eqn{\frac{FP}{FP + TN} = 1 - \mathrm{Specificity}}{FP / (FP + TN) = 1 - Specificity}}
#'   \item{Precision (positive predictive value)}{\eqn{\frac{TP}{TP + FP}}{TP / (TP + FP)}}
#'   \item{False Discovery Rate}{\eqn{\frac{FP}{TP + FP} = 1 - \mathrm{Precision}}{FP / (TP + FP) = 1 - Precision}}
#'   \item{Negative Predictive Value}{\eqn{\frac{TN}{FN + TN}}{TN / (FN + TN)}}
#'   \item{False Omission Rate}{\eqn{\frac{FN}{FN + TN} = 1 - \mathrm{NPV}}{FN / (FN + TN) = 1 - NPV}}
#' }
#'
#' @param observed  Vector of true class labels (2 unique values).
#' @param predicted Vector of predicted class labels (2 unique values, same domain).
#' @param positive  Value treated as the positive class. Defaults to the second
#'   sorted level (matches rwf's \code{confusion()} convention).
#' @param base_size Base font size. Default 10.
#' @param title     Plot title suffix.
#' @export
#' @importFrom rlang .data
#' @examples
#' plot_confusion_extended(observed=c(0,0,0,1,1,1,1),
#'                         predicted=c(0,0,0,1,1,1,1))
#' plot_confusion_extended(observed=c(0,0,0,1,1,1,1),
#'                         predicted=c(0,0,0,1,1,1,0),
#'                         positive=0)
#' plot_confusion_extended(observed=c(0,0,0,1,1,1,1),
#'                         predicted=c(0,0,0,1,1,1,0),
#'                         positive=1)
plot_confusion_extended <- function(observed, predicted, positive = NULL, base_size = 10, title = "") {
  observed  <- as.character(observed)
  predicted <- as.character(predicted)
  lvls <- sort(unique(c(observed, predicted)))
  if (length(lvls) != 2) stop("plot_confusion_extended() only supports a binary (2-class) confusion matrix")
  if (is.null(positive)) positive <- lvls[2]
  negative <- setdiff(lvls, positive)
  
  TP <- sum(predicted == positive & observed == positive)
  TN <- sum(predicted == negative & observed == negative)
  FP <- sum(predicted == positive & observed == negative)
  FN <- sum(predicted == negative & observed == positive)
  total <- TP + TN + FP + FN
  
  accuracy    <- (TP + TN) / total
  prevalence  <- (TP + FN) / total
  picc        <- (FN + FP) / total
  sensitivity <- TP / (TP + FN)
  specificity <- TN / (FP + TN)
  miss_rate   <- FN / (TP + FN)
  fallout     <- FP / (FP + TN)
  precision   <- TP / (TP + FP)
  npv         <- TN / (FN + TN)
  for_rate    <- FN / (FN + TN)
  fdr         <- FP / (TP + FP)
  
  pct <- function(x) paste0(sprintf("%.1f", x * 100), "%")
  seq_ramp <- grDevices::colorRampPalette(c("#cde2fb", "#0d366b"))(100)
  fill_for <- function(n) seq_ramp[pmax(1, pmin(100, round(n / total * 99) + 1))]
  
  ink_primary   <- "#0b0b0b"
  ink_secondary <- "#52514e"
  margin_fill   <- "#f0efec"
  
  cells <- data.frame(
    col   = c(1, 2, 3, 1, 2, 3, 1, 2, 3),
    row   = c(3, 3, 3, 2, 2, 2, 1, 1, 1),
    kind  = c("main", "main", "margin", "main", "main", "margin", "margin", "margin", "corner"),
    n     = c(TP, FP, NA, FN, TN, NA, NA, NA, NA),
    label = c(
      paste0("TP\n", TP, "\n(", pct(TP / total), ")"),
      paste0("FP\n", FP, "\n(", pct(FP / total), ")"),
      paste0("Precision\n", pct(precision), "\nFDR ", pct(fdr)),
      paste0("FN\n", FN, "\n(", pct(FN / total), ")"),
      paste0("TN\n", TN, "\n(", pct(TN / total), ")"),
      paste0("NPV\n", pct(npv), "\nFOR ", pct(for_rate)),
      paste0("Sensitivity\n", pct(sensitivity), "\nMiss Rate ", pct(miss_rate)),
      paste0("Specificity\n", pct(specificity), "\nFall-out ", pct(fallout)),
      paste0("Accuracy ", pct(accuracy), "\nPrevalence ", pct(prevalence), "\nIncorrect ", pct(picc))
    ),
    stringsAsFactors = FALSE
  )
  cells$fill       <- ifelse(cells$kind == "main", fill_for(cells$n), margin_fill)
  cells$text_color <- ifelse(cells$kind == "main" & !is.na(cells$n) & cells$n / total > 0.5, "#ffffff", ink_primary)
  
  col_label_vec <- c(paste0("Observed: ", positive), paste0("Observed: ", negative), "")
  row_label_vec <- c("", paste0("Predicted: ", negative), paste0("Predicted: ", positive))
  
  ggplot2::ggplot(cells, ggplot2::aes(x = .data$col, y = .data$row)) +
    ggplot2::geom_tile(ggplot2::aes(fill = .data$fill), color = "#fcfcfb", linewidth = 2, width = 0.96, height = 0.96) +
    ggplot2::geom_text(ggplot2::aes(label = .data$label, color = .data$text_color), size = base_size / 3, lineheight = 0.95, fontface = "bold") +
    ggplot2::scale_fill_identity() +
    ggplot2::scale_color_identity() +
    ggplot2::scale_x_continuous(breaks = 1:3, labels = col_label_vec, position = "top", expand = c(0.02, 0.02)) +
    ggplot2::scale_y_continuous(breaks = 1:3, labels = row_label_vec, expand = c(0.02, 0.02)) +
    ggplot2::coord_fixed() +
    ggplot2::labs(title = paste("Confusion Matrix", title), x = NULL, y = NULL,
                  caption = paste0("Observations: ", total)) +
    ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      axis.text    = ggplot2::element_text(color = ink_secondary, face = "bold"),
      axis.ticks   = ggplot2::element_blank(),
      panel.grid   = ggplot2::element_blank(),
      plot.title   = ggplot2::element_text(color = ink_primary, face = "bold"),
      plot.caption = ggplot2::element_text(color = ink_secondary)
    )
}

