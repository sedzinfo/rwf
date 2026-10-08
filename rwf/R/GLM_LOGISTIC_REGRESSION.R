##########################################################################################
# LOGISTIC REGRESSION
##########################################################################################
# Maximum likelihood estimation selects coefficients that make observed variables most likely to have occurred
# Deviance=-2LL=-2xloglikelihood has a chi square distribution and thus can be tested for significance
# Likelihood ratio=(model deviance) - (deviance for the baseline model where the constant is removed)
# R statistic=partial correlation between the outcome variable and each of the predictor variables range=-1,1 R=sqrt((z^2-2df)/-2LL(baseline))
# R^2L is the proportional reduction in the absolute value of the log likelihood measure R^2L=-2LL(model)/-2LL(baseline)
# Akaike Information Criterion: AIC=-2LL+2k k=number of predictors
# Bayesian Information Criterion: BIC=-2LL+2k log(n) k=number of predictors
# z=b/SEb tells is whether the b coefficient differs significantly from zero also called wald statistic
# The Z statistic should be interpreted cautiously when b is large the standard error inflates resulting in underestimated z statistic
# The Null deviance describes the model with no predictors=-2LL(baseline)
# The Residual deviance is the deviance of the model=-2LL(new)
# A non significant deviance suggests the amount of unexplained data is minimal
##########################################################################################
# LOGISTIC FUNCTION
##########################################################################################
#' @title Compute y for logistic function
#' @description This function requires x range to produce a vector with y values
#' @param intercept Numeric
#' @param coefficient Numeric
#' @param x Numeric
#' @keywords logistic regression
#' @export
#' @examples
#' x<--10:10
#' compute_y_logistic(0,1,x)
#' compute_y_logistic(0,1,1)
#' plot(x,compute_y_logistic(0,1,x),type="l");grid();abline(b=0,a=.5)
compute_y_logistic<-function(intercept,coefficient,x) {
  y=1/(1+exp(-(intercept+coefficient*x)))
  return(y)
}
##########################################################################################
# PLOT MODEL
##########################################################################################
#' @title Logistic model plot
#' @param df dataframe with predictor and outcome outcome should be last
#' @param outcome name of outcome variable
#' @param title Character plot title
#' @param base_size base font size
#' @import ggplot2
#' @keywords logistic regression
#' @export
#' @examples
#' df<-data.frame(outcome=c(rep(1,10),rep(0,10)),
#'                pd1=c(rep(1,11),rep(0,9)),
#'                pd2=c(rep(1,9),rep(0,11)),
#'                pc1=c(rnorm(10,mean=5),rnorm(10,mean=10)),
#'                pc2=c(rnorm(10,mean=5),rnorm(10,mean=20)))
#' plot_logistic_model(df=df,base_size=15)
plot_logistic_model<-function(df,outcome="outcome",title="",base_size=10) {
  Value<-Predictor<-NULL
  temp<-melt(df,id.vars=outcome)
  names(temp)<-c(outcome,"Predictor","Value")
  plot<-ggplot(temp,aes(x=Value,y=outcome,color=Predictor))+
    labs(x="Observed value",y=paste("Outcome"),title=paste("Logistic function"),caption=paste0("Observations:",nrow(df)))+
    stat_smooth(method="glm",method.args=list(family="binomial"),se=FALSE,alpha=0.1)+
    geom_count(alpha=.5)+
    theme_bw(base_size=base_size)
  return(plot)
}
##########################################################################################
# COMPARE MODELS
##########################################################################################
#' @title Compare logistic regression models models
#' @param model1 object glm model
#' @param model2 object glm model
#' @importFrom stats pchisq
#' @keywords logistic regression
#' @export
#' @examples
#' modelcategoricalpredictor<-glm(case~education,data=infert,family=binomial)
#' modelcontinuouspredictor<-glm(case~age,data=infert,family=binomial)
#' modeltwopredictors<-glm(case~education*age,data=infert,family=binomial)
#' modelmultiple<-glm(case~education*age*parity,data=infert,family=binomial)
#' anova(modelcategoricalpredictor,modelcontinuouspredictor)
#' output_compare_model_logistic(model1=modelcategoricalpredictor,
#'                               model2=modeltwopredictors)
#' output_compare_model_logistic(model1=modelcontinuouspredictor,
#'                               model2=modeltwopredictors)
#' output_compare_model_logistic(model1=modelcontinuouspredictor,
#'                               model2=modelcategoricalpredictor)
output_compare_model_logistic<-function(model1,model2) {
  x2<-model1$deviance-model2$deviance
  x2df<-model1$df.residual-model2$df.residual
  x2p<-1-stats::pchisq(x2,x2df)
  result<-data.frame("X^2"=x2,df=x2df,p=x2p)
  return(result)
}
##########################################################################################
# LOGISTIC
##########################################################################################
#' @title Report logistic regression
#' @param model object glm
#' @param validation_data validation data
#' @param base_size base font size
#' @param title plot title
#' @param w width of pdf file. Relevant only when file string is not empty
#' @param h height of pdf file. Relevant only when file string is not empty
#' @param file output filename
#' @param fast if TRUE it will not output individual scores and residuals
#' @note
#' (1) Problematic values for standardized residuals > +-1.96 \cr
#' Standardized residuals are residuals divided by an estimated standard deviation and they can be interpreted as z scores in that: \cr
#' 95% of z-scores should lie between -1.96 and +1.96 \cr
#' 99% of z-scores should lie between -2.58 and +2.58 \cr 
#' 99.99% of z-scores should lie between -3.29 and +3.29 \cr
#' (2) Problematic values for dfBeta >=1 \cr
#' dfBeta estimates coefficients if the respective case is removed from the dataset \cr
#' (3) Problematic values for Hat values (leverage) 2 or 3 times the average (k+1/n) \cr
#' Hat values (leverage),gauge the influence of the observed value of the outcome variable over the predicted values \cr
#' The average leverage value is defined as (k+1)/n, k=number of predictors, n=number of participants. Leverage values lie between 0 (no influence) and 1 (complete influence over prediction) \cr
#' If no cases exert undue influence over the model then all leverage values should be close to (k+1)/n \cr
#' Hoaglin and Welsch (1978) recommends investigating cases with values greater than twice the average (2(k+1)/n) \cr
#' Stevens (2002) recommends investigating cases with values greater than three times the average (3(k+1)/n) \cr
#' (4) Problematic values for VIFs > 10 \cr
#' ASSUMPTIONS  \cr
#' (1) Linearity between continuous predictors and the logit (test whether the interaction term between the predictor and its log transformation is significant) \cr
#' (2) Independence of errors \cr
#' (3) No multicolinearity \cr
#' @import ggfortify
#' @keywords logistic regression
#' @export
#' @examples
#' modelcategoricalpredictor0<-glm(case~education,data=infert,family=binomial)
#' modelcategoricalpredictor1<-glm(case~education,data=infert,family=gaussian)
#' #modelcategoricalpredictor2<-glm(case~education,data=infert,family=Gamma)
#' #modelcategoricalpredictor3<-glm(case~education,data=infert,family=inverse.gaussian)
#' modelcategoricalpredictor4<-glm(case~education,data=infert,family=poisson)
#' modelcategoricalpredictor5<-glm(case~education,data=infert,family=quasi)
#' modelcategoricalpredictor6<-glm(case~education,data=infert,family=quasibinomial)
#' modelcategoricalpredictor7<-glm(case~education,data=infert,family=quasipoisson)
#' modelcontinuouspredictor0<-glm(case~stratum,data=infert,family=binomial)
#' modeltwopredictors0<-glm(case~education+stratum,data=infert,family=binomial)
#' modeltwopredictors1<-glm(case~education+stratum,data=infert,family=gaussian)
#' #modeltwopredictors2<-glm(case~education+stratum,data=infert,family=Gamma)
#' #modeltwopredictors3<-glm(case~education+stratum,data=infert,family=inverse.gaussian)
#' modeltwopredictors4<-glm(case~education+stratum,data=infert,family=poisson)
#' modeltwopredictors5<-glm(case~education+stratum,data=infert,family=quasi)
#' modeltwopredictors6<-glm(case~education+stratum,data=infert,family=quasibinomial)
#' modeltwopredictors7<-glm(case~education+stratum,data=infert,family=quasipoisson)
#' report_logistic(model=modelcategoricalpredictor0)
#' report_logistic(model=modelcategoricalpredictor1)
#' #report_logistic(model=modelcategoricalpredictor2)
#' #report_logistic(model=modelcategoricalpredictor3)
#' report_logistic(model=modelcategoricalpredictor4)
#' report_logistic(model=modelcategoricalpredictor5)
#' report_logistic(model=modelcategoricalpredictor6)
#' report_logistic(model=modelcategoricalpredictor7)
#' report_logistic(model=modelcontinuouspredictor0)
#' report_logistic(model=modeltwopredictors0)
#' report_logistic(model=modelcategoricalpredictor0,
#'                 file="logistic_categorical_predictor",
#'                 validation_data=infert)
#' report_logistic(model=modelcontinuouspredictor0,
#'                 file="logistic_continuous_predictor",
#'                 validation_data=infert)
#' report_logistic(model=modeltwopredictors0,
#'                 file="logistic_two_predictors",
#'                 validation_data=infert[1:10,])
report_logistic<-function(model,validation_data=NULL,file=NULL,title="",w=10,h=10,base_size=10,fast=FALSE) {
  rstandard<-rstudent<-dfbeta<-dffits<-hatvalues<-NULL
  score_notes<-c("Problematic values for standardized residuals > +-1.96",
                 "Problematic values for dfbeta >= 1",
                 "Problematic values for Hat values (leverage) 2 or 3 times the average (k+1/n) where k=number of predictors n=number of participants")
  modelchisquare<-model$null.deviance-model$deviance
  R2<-modelchisquare/model$null.deviance
  modeldf<-model$df.null-model$df.residual
  modelprobability<-1-pchisq(modelchisquare,modeldf)
  chisquare<-data.frame(Chi.Squared=modelchisquare,
                        df=modeldf,
                        p=modelprobability,
                        R2=R2,
                        Note=c("Significance indicates that the model is better than chance at predicting the outcome"))
  R.l<-1-(model$deviance/model$null.deviance)
  R.cs<-1-exp((model$deviance-model$null.deviance)/length(model$fitted.values))
  R.n<-R.cs/(1-(exp(-(model$null.deviance/length(model$fitted.values)))))
  pseudor2<-data.frame(rbind(data.frame(Test="Hosmer and Lemeshow R^2",Statistic=R.l,Notes=""),
                             data.frame(Test="Cox and Snell R^2",Statistic=R.cs,Notes="Cox and Snell R^2 never reaches maximum of 1"),
                             data.frame(Test="Nagelkerke R^2",Statistic=R.n,Notes="")))
  model_summary<-summary(model)
  model_call<-data.frame(call=call_to_string(model))
  VIF<-data.frame()
  if(ncol(model$model)>2)
    try({VIF=car::vif(model)})
  
  scores<-data.frame(variable=model$model,
                     weights=model$weights,
                     prior_weights=model$prior.weights,
                     linear_predictors=model$linear.predictors,
                     effects=model$effects,
                     fitted=model$fitted.values,
                     residuals=model$residuals,
                     standardized_residuals=rstandard(model),
                     student_residuals=rstudent(model),
                     dfbeta=dfbeta(model),
                     dffits=dffits(model),
                     hatvalues=hatvalues(model),
                     check.names=FALSE)
  
  result<-list(model_summary=model_summary,
               result_R2_logistic=pseudor2,
               result_X2_logistic=chisquare,
               coefficients=data.frame(model_summary$coefficients,
                                       "Odds Ratio"=exp(coef(model)),
                                       #  confidence_intervals=confint(model),
                                       check.names=FALSE),
               logistic_output=data.frame(AIC=model$aic,
                                          df.residual=model$df.residual,
                                          df.null=model$df.null,
                                          deviance=model$deviance,
                                          null.deviance=model$null.deviance,
                                          epsilon=model$control$epsilon,
                                          tol=model$qr$tol,
                                          qr.rank=model$qr$rank,
                                          rank=model$rank,
                                          maxit=model$control$maxit,
                                          iteration=model$iter,
                                          method=model$method,
                                          converged=model$converged,
                                          boundary=model$boundary,
                                          trace=model$control$trace),
               scores=scores,
               score_descriptives=compute_descriptives(scores[,sapply(scores,is.numeric)]),
               VIF=data.frame(VIF=VIF,check.names=FALSE),
               model_call=model_call)
  
  if(is.null(validation_data)) {
    predicted<-as.numeric(model$fitted.values)
    observed<-as.numeric(model$model[,1])
  } else {
    predicted<-as.numeric(predict(model,newdata=validation_data))
    observed<-as.numeric(get_all_vars(model,data=validation_data)[,1])
  }
  diagnostics<-autoplot(model)+
    labs(title=title,caption=paste0(deparse(model$terms),"\nobservations=",nrow(model$model)))+
    theme_bw(base_size=base_size)+
    theme(axis.text.x=element_text(angle=20,hjust=1))
  confusion_performance<-result_confusion_performance(observed=observed,predicted=predicted,base_size=base_size,title=title,step=.01)
  separability<-plot_separability(observed=observed,predicted=predicted,base_size=base_size,title=title)
  plotlist<-list(diagnostics,
                 confusion_performance$plot_performance,
                 separability)
  report_pdf(plotlist=plotlist,file=file,title=title,w=w,h=h,print_plot=TRUE)
  cmatrix<-confusion_matrix_percent(observed=observed,predicted=ifelse(predicted>mean(confusion_performance$cut,na.rm=TRUE),1,0))
  write_txt({
    output_separator("Model Summary",output=summary(model))
    output_separator("Summary",output=result$logistic_output)
    output_separator("Confusion Matrix",output=cmatrix)
    output_separator("Confusion Matrix Performance",output=confusion_performance$cut_performance)
    output_separator("Confusion Matrix Best Cut",output=confusion_performance$cut)
    output_separator("Pseudo R^2",output=result$result_R2_logistic)
    output_separator("X^2",output=result$result_X2_logistic)
    output_separator("Variance Inflation Factor",output=result$VIF)
    output_separator("Outlier Descriptives",output=result$score_descriptives,instruction=score_notes)
    output_separator("Call",output=result$model_call)
  },file=file)
  if(!is.null(file)) {
    filename<-paste0(file,".xlsx")
    if (file.exists(filename)) file.remove(filename)
    wb<-openxlsx::createWorkbook()
    excel_critical_value(result$logistic_output,wb,"summary",numFmt="#0.00")
    excel_critical_value(result$coefficients,wb,"coefficients",numFmt="#0.00",critical=list("Pr(>|z|)"="<0.05"))
    excel_confusion_matrix(cmatrix,wb)
    excel_critical_value(confusion_performance$cut_performance,wb,"confusion matrix performance",numFmt="#0.00")
    excel_critical_value(result$result_X2_logistic,wb,"X^2",numFmt="#0.00")
    excel_critical_value(result$result_R2_logistic,wb,"pseudo R^2",numFmt="#0.00")
    if(!fast)
      excel_critical_value(result$scores,wb,"scores residuals",comment=toString(score_notes),numFmt="#0.00")
    excel_critical_value(result$score_descriptives,wb,"score residual descriptives",comment=toString(score_notes),numFmt="#0.00")
    if(nrow(result$VIF)>0)
      excel_critical_value(result$VIF,wb,"VIF",comment="VIFs over 10 are problematic",numFmt="#0.00")
    excel_critical_value(result$model_call,wb,"Call",numFmt="#0.00")
    openxlsx::saveWorkbook(wb=wb,file=filename,overwrite=TRUE)
  }
}
##########################################################################################
# TESTING FOR LINEARITY OF THE LOGIT
##########################################################################################
# initialmodel<-glm(df$binoutcome1~df$continous1+df$continous2+df$continous3,data=df,family=binomial)
# # Create the interaction terms with each of the variables
# df$testlinearity1<-log(df$continous1)*df$continous1
# df$testlinearity2<-log(df$continous2)*df$continous2
# # Create the model with the interactions
# model<-glm(df$binoutcome1~df$continous1+df$continous2+df$continous3+df$testlinearity1+df$testlinearity2+df$testlinearity3,df,family=binomial)
# # Significant interaction coefficients indicate that the main effect has violated the linearity of the logit
# summary(model)
##########################################################################################
# MULTINOMIAL REGRESSION
##########################################################################################
# multinomialdf<-data.frame(df$catoutcome1,df$continous1,df$binpredictor1)
# names(multinomialdf)<-c("catoutcome1","continous1","binpredictor1")
# names(multinomialdf)
# multinomialdf<-mlogit::mlogit.data(multinomial,choice="catoutcome1",shape="wide")
# multinomialdf$catoutcome1<-as.factor(multinomialdf$catoutcome1)
# multinomialdf$binpredictor1<-as.factor(multinomialdf$binpredictor1)
# multinomialdf$catoutcome1<-as.numeric(multinomialdf$catoutcome1)
# multinomialdf$binpredictor1<-as.numeric(multinomialdf$binpredictor1)
# is.factor(multinomialdf$catoutcome1)
# is.factor(multinomialdf$binpredictor1)
# is.factor(multinomialdf$continous2)
# multinomialmodel<-mlogit(catoutcome1~1|continous1+binpredictor1+binpredictor1:continous1,multinomialdf,reflevel=1)
# data.frame(exp(multinomialmodel$coefficients))
# summary(multinomialmodel)
# result_R2_logistic(multinomialmodel)
# #Test for linearity of the model
# multinomialdf$logcontinous1<-log(multinomialdf$continous1+1)*multinomialdf$continous1
# multinomialdf$logbinpredictor1<-log(multinomialdf$binpredictor1+1)*multinomialdf$continous1
# head(multinomialdf)
# multinomialdftest<-mlogit(catoutcome1~1 | continous1:logcontinous1+binpredictor1:logbinpredictor1,data=multinomialdf,reflevel=1)
# summary(multinomialdftest)
# chatTest.1<-mlogit(Success ~ 1 | Good_Mate+Funny+Sex+Funny:logFunny+Good_Mate:logGood+Sex:logSex,data=mlChat,reflevel=1)
# tetrachoric(df$binoutcome1,df$binpredictor1)
# summary(multinomialdftest)
##########################################################################################
# NOTES
##########################################################################################
# model$coefficients
# model$residuals
# model$fitted.values
# model$effects
# model$R
# model$rank
# model$qr$qr
# model$qr$rank
# model$qr$qraux
# model$qr$pivot
# model$qr$tol
# model$family
# model$linear.predictors
# model$deviance
# model$aic
# model$null.deviance
# model$iter
# model$weights
# model$prior.weights
# model$df.residual
# model$df.null
# model$y
# model$converged
# model$boundary
# model$model
# model$call
# model$formula
# model$terms
# model$data
# model$offset
# model$control
# model$control$epsilon
# model$control$maxit
# model$control$trace
# model$method
# model$contrasts
# model$xlevels
