##########################################################################################
# LDA
##########################################################################################
#' @title Report for MASS::lda
#' @param model object from MASS::lda
#' @param file output filename
#' @importFrom stats get_all_vars
#' @importFrom openxlsx createWorkbook saveWorkbook
#' @keywords ML
#' @export
#' @examples
#' model<-MASS::lda(case~.,data=infert)
#' result<-report_lda(model=model)
#' result<-report_lda(model=model,file="lda")
#' model<-MASS::lda(Species~.,data=iris)
#' result<-report_lda(model=model,file="lda")
report_lda<-function(model,file=NULL) {
  prior_counts<-data.frame(prior=model$prior,counts=model$counts,mean=model$means)
  terms<-model$terms
  scaling<-model$scaling
  model_description<-data.frame(Observations=model$N,SDV=model$svd)
  call<-data.frame(call=stringr::str_replace_all(toString(deparse(model$call)),stringr::fixed(" "),""))
  predicted<-predict(model)
  observed<-stats::get_all_vars(model$call,model.frame(model))[,1]
  cmatrix<-confusion_matrix_percent(observed=observed,predicted=predicted$class)
  result<-list(prior_counts=prior_counts,means=model$means,coeficients=scaling,terms=terms,model_description=model_description,cmatrix=cmatrix,call=call)
  if(!is.null(file)) {
    filename<-paste0(file,".xlsx")
    if (file.exists(filename)) file.remove(filename)
    wb<-openxlsx::createWorkbook()
    excel_critical_value(result$coeficients,workbook=wb,sheet="Coefficients",numFmt="#0.00")
    excel_confusion_matrix(cmatrix,wb)
    excel_critical_value(result$prior_counts,workbook=wb,sheet="Priors and Counts",numFmt="#0.00")
    excel_critical_value(result$means,workbook=wb,sheet="Means",numFmt="#0.00")
    excel_critical_value(result$model_description,workbook=wb,sheet="Descriptives",numFmt="#0.00")
    excel_critical_value(result$call,workbook=wb,sheet="Call",numFmt="#0.00")
    openxlsx::saveWorkbook(wb,invisible(paste0(filename)),TRUE)
  }
  return(result)
}
##########################################################################################
# NOTES
##########################################################################################
# plot(model)
##########################################################################################
# NOTES
##########################################################################################
# model$prior
# model$counts
# model$means
# model$scaling
# model$lev
# model$svd
# model$N
# model$call
# model$terms
# model$xlevels
