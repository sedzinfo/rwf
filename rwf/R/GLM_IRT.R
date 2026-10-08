##########################################################################################
# PLOT MODEL
##########################################################################################
#' @title Return data for irt plots
#' @param model object mirt
#' @param theta theta
#' @param title plot title 
#' @param base_size base size
#' @import ggplot2 
#' @importFrom mirt testinfo extract.mirt expected.test
#' @importFrom plyr rbind.fill
#' @importFrom reshape2 melt
#' @keywords IRT
#' @export
#' @examples
#' cormatrix<-psych::sim.rasch(nvar=5,n=50000,low=-4,high=4,d=NULL,a=1,mu=0,sd=1)$items
#' model<-mirt::mirt(cormatrix,1,empiricalhist=TRUE,calcNull=TRUE)
#' plot_irt_onefactor(model=model,base_size=10,title="Normal Test")
#' cormatrix<-psych::sim.rasch(nvar=5,n=50000,low=-6,high=-4,d=NULL,a=1,mu=0,sd=1)$items
#' model<-mirt::mirt(cormatrix,1,empiricalhist=TRUE,calcNull=TRUE)
#' plot_irt_onefactor(model=model,base_size=10,title="Easy Items")
#' cormatrix<-psych::sim.rasch(nvar=5,n=50000,low=4,high=6,d=NULL,a=1,mu=0,sd=1)$items
#' model<-mirt::mirt(cormatrix,1,empiricalhist=TRUE,calcNull=TRUE)
#' plot_irt_onefactor(model=model,base_size=10,title="Difficult Items")
#' cormatrix<-psych::sim.rasch(nvar=5,n=50000,low=-4,high=-4,d=NULL,a=0.01,mu=0,sd=1)$items
#' model<-mirt::mirt(cormatrix,1,empiricalhist=TRUE,calcNull=TRUE)
#' plot_irt_onefactor(model=model,base_size=10,title="Low Discrimination")
#' cormatrix<-psych::sim.poly(nvar=5,n=50000,low=-4,high=4,a=1,c=0,z=1,d=NULL, 
#'                            mu=0,sd=1,cat=5,mod="logistic",theta=NULL)$items
#' model<-mirt::mirt(cormatrix,1,itemtype="graded")
#' plot_irt_onefactor(model=model,base_size=10,title="graded response")
plot_irt_onefactor<-function(model,theta=seq(-6,6,.1),title="",base_size=10) {
  value<-variable<-NULL
  model_names<-names(data.frame(model@Data$data))
  info_item<-data.frame(theta=theta,type="Item Information")
  for(i in model_names)
    info_item[,i]<-testinfo(x=model,Theta=theta,degrees= NULL,group=NULL,individual=FALSE,which.items=grep(i,model_names))
  expected_item<-data.frame(theta=theta,
                            type="Expected Score",
                            expected.test(x=model,Theta=matrix(theta),group=NULL,mins=TRUE,individual=TRUE,which.items=1:extract.mirt(model,"nitems")))
  names(info_item)<-names(expected_item)<-c("theta","type",model_names)
  
  df_total<-data.frame(theta=theta,
                       information=testinfo(x=model,Theta=theta,degrees= NULL,group=NULL,individual=FALSE,which.items=1:extract.mirt(model,"nitems")),
                       expected_score=expected.test(x=model,Theta=matrix(theta),group=NULL,mins=TRUE,individual=FALSE,which.items=NULL))
  
  df_total_melt<-data.frame(type="total",reshape2::melt(df_total,id.vars=c("theta")))
  info_item_melt<-reshape2::melt(info_item,id.vars=c("theta","type"))
  expected_item_melt<-reshape2::melt(expected_item,id.vars=c("theta","type"))
  
  df_result<-plyr::rbind.fill(df_total_melt,info_item_melt,expected_item_melt)

  total<-ggplot(df_result,aes(x=theta,y=value,group=variable,color=variable))+
    geom_line()+
    geom_point()+
    theme_bw(base_size=base_size)+
    theme(legend.position="bottom")+
    labs(title=paste("Total Score / Information",title),y="",x=expression(theta))+
    facet_wrap(type~.,scales="free")
  return(total)
}
##########################################################################################
# REPORT
##########################################################################################
#' @title Output for irt model
#' @param model object mirt
#' @param file output filename
#' @importFrom mirt coef residuals itemfit M2
#' @importFrom openxlsx createWorkbook saveWorkbook
#' @keywords IRT
#' @export
#' @examples
#' set.seed(12345)
#' cormatrix<-psych::sim.rasch(nvar=5,n=50000,low=-4,high=4,d=NULL,a=1,mu=0,sd=1)$items
#' irt_onefactor<-mirt::mirt(cormatrix,1,empiricalhist=TRUE,calcNull=TRUE)
#' irt_twofactor<-mirt::mirt(cormatrix,2,empiricalhist=TRUE,calcNull=TRUE)
#' irt_threefactor<-mirt::mirt(cormatrix,3,empiricalhist=TRUE,calcNull=TRUE)
#' report_irt(model=irt_onefactor,file="one_factor")
#' report_irt(model=irt_twofactor,file="two_factors")
#' report_irt(model=irt_threefactor,file="three_factors")
report_irt<-function(model,file=NULL) {
  comment<-list(a1="discrimination",
                d="difficulty",
                g="guessing",
                u="inattentiveness",
                G2="PARSCALE's G^2",
                # p="",
                TLI="Tucker Lewis Index TLI>0.95",
                CFI="Comparative Fit Index CFI>0.95",
                RMSEA="Root Mean Square Error of Approximation RMSEA<0.07",
                df="degrees of freedom",
                AIC="Akaike Information Criterion",
                AICc="small-sample-size adjusted Akaike Information Criterion",
                BIC="Bayesian Information Criterion",
                SABIC="sample-size adjusted Bayesian Information Criterion",
                DIC="Deviance Information Criterion",
                # HQ="",
                # logLik="",
                # logPrior="",
                # SElogLik="",
                # F1="",
                # h2="",
                "SRMR(SRMSR)"="Standardized Root Mean Square Residual SRMR(SRMSR)<0.08")
  pt<-options(fit.indices=c("GFI","AGFI","RMSEA","NFI","NNFI","CFI","RNI","IFI","SRMR","AIC","AICc","BIC","CAIC"))
  model_coefficients<-data.frame(coef(model,CI=0.95,printSE=FALSE,verbose=FALSE,rotate="none",as.data.frame=FALSE,simplify=TRUE,unique=FALSE)$items)
  model_coefficients_oblimin<-data.frame(flatten_list(coef(model,CI=0.95,printSE=FALSE,verbose=FALSE,rotate="oblimin",as.data.frame=FALSE,simplify=TRUE,unique=FALSE)))
  row.names(model_coefficients_oblimin)[1:length(row.names(model_coefficients))]<-row.names(model_coefficients)
  q3_matrix<-residuals(model,digits=3,type="Q3",QMC=TRUE)
  q3_matrix<-data.frame(matrix_triangle(q3_matrix,off_diagonal=NA,diagonal=NA,type="lower"),check.names=FALSE)
  q3_matrix$min<-remove_nc(apply(q3_matrix,1,min,na.rm=TRUE),value=NA)
  q3_matrix$max<-remove_nc(apply(q3_matrix,1,max,na.rm=TRUE),value=NA)
  q3_matrix<-rbind(q3_matrix,
                   min=apply(q3_matrix,2,min,na.rm=TRUE),
                   max=apply(q3_matrix,2,max,na.rm=TRUE))
  m2_fit<-try(M2(model,type="M2*",calcNull=TRUE,na.rm=TRUE,quadpts=NULL,theta_lim=c(-6,6),CI=0.9,residmat=FALSE,QMC=TRUE),silent=TRUE)
  exp_residuals<-data.frame(residuals(model,digits=3,type="exp",QMC=TRUE),check.names=FALSE)
  item_fit=itemfit(model,na.rm=TRUE)
  g2_fit<-remove_nc(data.frame(model@Fit,check.names=FALSE))
  result<-list(model_coefficients=model_coefficients,
               model_coefficients_oblimin=model_coefficients_oblimin,
               model_options=data.frame(Options=unlist(model@Options),check.names=FALSE),
               model_call=call_to_string(model@Call),
               q3_matrix=q3_matrix,
               exp_residuals=exp_residuals,
               item_fit=item_fit,
               g2_fit=g2_fit,
               m2_fit=m2_fit)
  if(!is.null(file)) {
    filename<-paste0(file,".xlsx")
    if (file.exists(filename)) file.remove(filename)
    wb<-openxlsx::createWorkbook()
    excel_critical_value(result$model_coefficients,wb,"Coefficients",numFmt="#0.00",comment=comment)
    excel_critical_value(result$model_coefficients_oblimin,wb,"Coefficients Oblimin",numFmt="#0.00",comment=comment)
    excel_critical_value(result$item_fit,wb,"item fit",numFmt="#0.00",comment=comment)
    excel_critical_value(result$g2_fit,wb,"G2",numFmt="#0.00",comment=comment)
    if(is.data.frame(result$m2_fit))
      excel_critical_value(result$m2_fit,wb,"M2",numFmt="#0.00",title="M2 (Maydeu-Olivares & Joe, 2006) statistic\n when all data are dichotomous",comment=comment)
    excel_matrix(result$q3_matrix,wb,"Q3",title="Test for local independence:\nThere is no consensus about the critical values.\nCritical values may range from absolute of .7 to .1",numFmt="#0.00",conditional_formatting=TRUE)
    excel_critical_value(result$exp_residuals,wb,"Residuals",numFmt="#0.00")
    excel_critical_value(result$model_options,wb,"Model Options",numFmt="#0.00")
    openxlsx::saveWorkbook(wb,filename,overwrite=TRUE)
  }
  return(result)
}
##########################################################################################
# NOTES
##########################################################################################
# Coefficients for item characteristic curves: Item difficulty=b -Item discrimination=a -Guessing=c
# ax=item slopes for factor x, d=item intercept, g=guessing parameter in slope -intercept form, use b=-d/a to obtain traditional metric
# original IRT metric for all items can be obtained using guessing parameter for item 1 hits the lower bound of 0, use a logit prior for g parameters instead
##########################################################################################
# 
##########################################################################################
# irt_onefactor@Call
# irt_onefactor@Data$data
# irt_onefactor@Data$grsm.block
# irt_onefactor@Data$rsm.block
# irt_onefactor@Data$group
# irt_onefactor@Data$groupNames
# irt_onefactor@Data$ngroups
# irt_onefactor@Data$nitems
# irt_onefactor@Data$N
# irt_onefactor@Data$mins
# irt_onefactor@Data$model
# irt_onefactor@Data$tabdatalong
# irt_onefactor@Data$tabdata
# irt_onefactor@Data$fulldata
# irt_onefactor@Data$Freq
# irt_onefactor@Data$K
# irt_onefactor@Options
# irt_onefactor@Fit
# irt_onefactor@Model$model
# irt_onefactor@Model$factorNames
# irt_onefactor@Model$itemtype
# irt_onefactor@Model$itemloc
# irt_onefactor@Model$nfact
# irt_onefactor@Model$Theta
# irt_onefactor@Model$constrain
# irt_onefactor@Model$parprior
# irt_onefactor@Model$nest
# irt_onefactor@Model$invariance
# irt_onefactor@Model$lrPars
# irt_onefactor@Model$formulas
# irt_onefactor@Model$prodlist
# irt_onefactor@Parobjects
# irt_onefactor@OptimInfo
# irt_onefactor@Internals$collectLL
# irt_onefactor@Internals$Prior
# irt_onefactor@Internals$shortpars
# irt_onefactor@Internals$key
# irt_onefactor@Internals$bfactor
# irt_onefactor@Internals$CUSTOM.IND
# irt_onefactor@Internals$SLOW.IND
# irt_onefactor@Internals$survey.weights
# irt_onefactor@vcov
# irt_onefactor@time
