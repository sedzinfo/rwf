##########################################################################################
# CORRELATION MATRIX PLOT
##########################################################################################
#' @title Correlation matrix plots
#' @param mydata correlation matrix
#' @param title plot title
#' @param base_size base font size
#' @param fill_limits lower and upper limit for fill
#' @import ggplot2
#' @importFrom reshape2 melt
#' @keywords correlation
#' @export
#' @examples
#' plot_corrplot(stats::cor(mtcars),title="Correlation")
#' plot_corrplot(stats::cor(mtcars),base_size=20)
plot_corrplot<-function(mydata,title="",base_size=10,fill_limits=c(-1,0,1)) {
  Var1<-Var2<-value<-NULL
  mydata<-round(mydata,2)
  upper_tri<-matrix_triangle(mydata,type="upper")
  melted_cormat<-reshape2::melt(upper_tri,na.rm=TRUE)
  plot<-ggplot(melted_cormat,aes(Var2,Var1,fill=value))+
    geom_tile(color="white")+
    scale_fill_gradient2(midpoint=fill_limits[2],limit=fill_limits[c(1,3)])+
    geom_text(aes(Var2,Var1,label=value),color="black",size=base_size/4)+
    theme_bw(base_size=base_size)+
    theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1),
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),
          panel.border=element_blank(),
          panel.background=element_blank(),
          legend.justification=c(1,0),
          legend.position="none")+
    guides(fill=guide_colorbar(barwidth=7,barheight=1,title.position="top",title.hjust=0.5))+
    labs(title=title)
  return(plot)
}
##########################################################################################
# POWER
##########################################################################################
#' @title Compute r power curve
#' @param n number of observations
#' @param r correlation coefficient
#' @param sig.level alpha (type I error probability)
#' @param alternative a character string specifying the alternative hypothesis, must be one of "two.sided" (default), "greater" or "less"
#' @param title plot title
#' @param base_size base font size
#' @import ggplot2
#' @importFrom pwr pwr.r.test
#' @importFrom plyr rbind.fill
#' @keywords correlation
#' @export
#' @examples
#' compute_power_r(n=100,r=.5,sig.level=.05,alternative=c("two.sided"))
compute_power_r<-function(n=100,r=NULL,sig.level=0.05,alternative=c("two.sided","less","greater"),title="",base_size=10) {
  power<-NULL
  df_power<-data.frame()
  for (i in 10:n) {
    result<-pwr::pwr.r.test(n=i,r=r,sig.level=sig.level,power=NULL,alternative=alternative)
    df_result<-data.frame(n=result$n,r=result$r,p=result$sig.level,power=result$power,alternative=result$alternative,method=result$method)
    df_power<-plyr::rbind.fill(df_power,df_result)
  }
  plot<-ggplot(df_power,aes(x=n,y=power))+
    geom_point(alpha=1)+
    geom_line()+
    labs(x="Observations",y="Power",
         title=title,
         caption=paste0("r power curve:"," r = ",round(r,2),", alpha = ",sig.level))+
    lims(y=c(0,1))+
    theme_bw(base_size=base_size)
  result<-list(plot=plot,power_table=df_power)
  return(result)
}
##########################################################################################
# POWER
##########################################################################################
#' @title Compute correlation matrix 
#' @param m correlation matrix
#' @param ... arguments passed to compute_power_r
#' @keywords correlation
#' @export
#' @examples
#' compute_power_r_matrix(m=stats::cor(mtcars,use="pairwise.complete.obs"),n=100)
compute_power_r_matrix<-function(m,...) {
  diag(m)<-NA
  minimum<-compute_power_r(r=min(abs(m),na.rm=TRUE),title="Min absolute r in Correlation Matrix",...)
  maximum<-compute_power_r(r=max(abs(m),na.rm=TRUE),title="Max absolute r in Correlation Matrix",...)
  mean<-compute_power_r(r=mean(abs(m),na.rm=TRUE),title="Mean absolute r in Correlation Matrix",...)
  median<-compute_power_r(r=stats::median(abs(m),na.rm=TRUE),title="Median absolute r in Correlation Matrix",...)
  df_power<-rbind(minimum$power_table,maximum$power_table,mean$power_table,median$power_table)
  plot<-plot_multiplot(minimum$plot,maximum$plot,mean$plot,median$plot)
  result<-list(plot=plot,power_table=df_power)
  return(result)
}
##########################################################################################
# BIVARIATE CORRELATION
##########################################################################################
# Assumptions: For Pearson one variable can be categorical provided there are only two categories
# result<-stats::cor(generate_correlation_matrix())
# result<-rcorr(generate_correlation_matrix())
# result<-cor.test(generate_correlation_matrix())
# result<-rcorr.adjust(cordata,type="pearson",use="complete") # Corrected values for multiple bivariate correlations
##########################################################################################
# CORRELATION MATRIX
##########################################################################################
#' @title Report correlation matrix
#' @param x	matrix or dataframe
#' @param y	a second matrix or dataframe with the same number of rows as x
#' @param file output filename
#' @param w width of pdf file
#' @param h height of pdf file
#' @param base_size base font size
#' @param use "pairwise" is the default value and will do pairwise deletion of cases. "complete" will select just complete cases
#' @param method "pearson" "spearman" "kendall"
#' @param adjust "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"
#' @param alpha	alpha level of confidence intervals
#' @param ci By default, confidence intervals are found. However, this leads to a great slowdown of speed. So, for just the rs, ts and ps, set ci=FALSE
#' @param scatterplot if TRUE it will output scatterplots
#' @importFrom psych corr.test
#' @importFrom openxlsx createWorkbook saveWorkbook
#' @keywords correlation
#' @export
#' @examples
#' report_correlation(x=generate_missing(mtcars[,1:3],10))
#' report_correlation(x=generate_missing(mtcars[,1:3],10),
#'                    file="correlation",scatterplot=TRUE)
#' report_correlation(x=mtcars[,1:3],file="correlation")
report_correlation<-function(x,y=NULL,use="pairwise",method="pearson",adjust="holm",alpha=.05,ci=TRUE,file=NULL,w=10,h=10,base_size=20,scatterplot=TRUE) {
  function_arguments<-c("Use","Method","Adjustment for Probability values","Alpha","Confidence Interval")
  function_values<-c(use,method,adjust,alpha,ci)
  x<-data.frame(change_data_type(x,type="numeric"))
  result<-psych::corr.test(x,y,use,method,adjust,alpha,ci)
  n_lower<-matrix_triangle(result$n,off_diagonal=NA,diagonal=NA,type="lower")
  if(length(n_lower)==1) {
    n_lower[1,1]<-result$n
    n_lower<-data.frame(n_lower)
    names(n_lower)<-"n"
  }
  correlation_result<-list(r_lower=data.frame(matrix_triangle(result$r,off_diagonal=NA,diagonal=NA,type="lower")),
                           r_squared_lower=data.frame(matrix_triangle(result$r*result$r,off_diagonal=NA,diagonal=NA,type="lower")),
                           p_lower=data.frame(matrix_triangle(result$p,off_diagonal=NA,diagonal=NA,type="lower")),
                           p_lower_adjusted=data.frame(matrix_triangle(symmetric_matrix(matrix_triangle(result$p,off_diagonal=NA,diagonal=NA,type="upper"),duplicate="upper",diagonal=NA),type="lower")),
                           t_lower=data.frame(matrix_triangle(result$t,off_diagonal=NA,diagonal=NA,type="lower")),
                           n_lower=n_lower,
                           se_lower=data.frame(matrix_triangle(result$se,off_diagonal=NA,diagonal=NA,type="lower")),
                           ci=data.frame(result$ci,result$ci.adj),
                           call=data.frame(function_arguments,function_values))
  
  corrplot<-plot_corrplot(result$r,base_size=base_size)
  report_pdf(corrplot,file=file,title="corrplot",w=w,h=h)
  if(scatterplot) {
    scatterplot<-plot_scatterplot(x,base_size=base_size,coord_equal=FALSE,all_orders=FALSE,title="",combinations=NULL)
    report_pdf(plotlist=scatterplot,file=file,title="scatterplot",w=w,h=h)
    results=list(scatterplot,correlation_result)
  }
  if(!is.null(file)) {
    filename<-paste0(file,".xlsx")
    if (file.exists(filename)) file.remove(filename)
    wb<-openxlsx::createWorkbook()
    excel_matrix(correlation_result$r_lower,wb,sheet="r",conditional_formatting=TRUE,numFmt="#0.00",comment=NULL)
    excel_matrix(correlation_result$r_squared_lower,wb,sheet="r_squared",conditional_formatting=TRUE,numFmt="#0.00",comment=NULL)
    excel_matrix(correlation_result$p_lower,wb,sheet="p",conditional_formatting=TRUE,numFmt="#0.00",comment=NULL)
    excel_matrix(correlation_result$p_lower_adjusted,wb,sheet="p_adjusted",conditional_formatting=TRUE,numFmt="#0.00",comment=NULL)
    excel_matrix(correlation_result$t_lower,wb,sheet="t",conditional_formatting=TRUE,numFmt="#0.00")
    excel_matrix(correlation_result$n_lower,wb,sheet="N",conditional_formatting=TRUE,numFmt="#0")
    excel_matrix(correlation_result$se_lower,wb,sheet="SE",conditional_formatting=TRUE,numFmt="#0.00")
    excel_matrix(correlation_result$ci,wb,sheet="CI",numFmt="#0.00")
    excel_matrix(correlation_result$call,wb,sheet="Call")
    openxlsx::saveWorkbook(wb,file=filename,overwrite=TRUE)
  }
  return(correlation_result)
}
##########################################################################################
# TETRACHORIC POLYCHORIC CORRELATION
##########################################################################################
# Same as above with one variable being dichotomous
# Point Biserial when there is a Discrete dichotomy
# Biserial when there is a Continuous dichotomy
##########################################################################################
# TETRACHORIC POLYCHORIC BISERIAL POLYSERIAL
##########################################################################################
#' @title Report polychoric tetrachoric polyserial biserial correlation
#' @param x The input may be in one of four forms:\cr
#' a) a data frame or matrix of dichotomous data (e.g., the lsat6 from the bock data set) or discrete numerical (i.e., not too many levels, e.g., the big 5 data set, bfi) for polychoric, or continuous for the case of biserial and polyserial\cr
#' b) a 2 x 2 table of cell counts or cell frequencies (for tetrachoric) or an n x m table of cell counts (for both tetrachoric and polychoric)\cr
#' c) a vector with elements corresponding to the four cell frequencies (for tetrachoric)\cr
#' d) a vector with elements of the two marginal frequencies (row and column) and the comorbidity (for tetrachoric)\cr
#' @param y matrix or dataframe of discrete scores. In the case of tetrachoric, these should be dichotomous, for polychoric not too many levels, for biserial they should be discrete (e.g., item responses) with not too many (<10?) categories
#' @param file output filename
#' @param w width of pdf file
#' @param h height of pdf file
#' @param type "tetrachoric" "polychoric" "polyserial" "biserial"
#' @param ... arguments passed to psych::polychoric
#' @importFrom psych tetrachoric polyserial
#' @importFrom openxlsx createWorkbook saveWorkbook
#' @keywords correlation
#' @export
#' @examples
#' report_choric_serial(generate_data(min=0,max=1,type="uniform"),
#'               type="tetrachoric",file="tetrachoric")
#' report_choric_serial(generate_data(min=1,max=5,type="uniform"),
#'               type="polychoric")
#' report_choric_serial(x=psych::lsat6,y=psych::lsat6,
#'                      type="polyserial",file="polyserial")
#' report_choric_serial(x=psych::lsat6,y=psych::lsat6,
#'                      type="biserial",file="biserial")
report_choric_serial<-function(x,y=NULL,file=NULL,w=10,h=10,type="tetrachoric",...) {
  if(type=="tetrachoric")
    result<-psych::tetrachoric(x,...)
  if(type=="polychoric")
    result<-psych::polychoric(x,...)
  if(type=="polyserial")
    result<-data.frame(psych::polyserial(x,y,...))
  if(type=="biserial")
    result<-data.frame(psych::biserial(x,y,...))
  
  if(type=="biserial"||type=="biserial") {
    report_pdf(plot_corrplot(result,title=type),w=w,h=h,file=file,title=type)
    report_dataframe(result,sheet=type,file=file)
  }
  
  if(type=="tetrachoric"||type=="polychoric") {
    report_pdf(plot_corrplot(result$rho,title=type),w=w,h=h,file=file,title=type)
    if(!is.null(file)) {
      filename<-paste0(file,".xlsx")
      if (file.exists(filename)) file.remove(filename)
      wb<-openxlsx::createWorkbook()
      excel_matrix(data.frame(result$rho),wb,sheet="R",conditional_formatting=TRUE,comment=NULL)
      excel_matrix(data.frame(result$rho*result$rho),wb,sheet="R Squared",conditional_formatting=TRUE,comment=NULL)
      excel_matrix(data.frame(result$tau),wb,sheet="Tau",comment=NULL)
      excel_matrix(data.frame(Observations=result$n.obs),wb,sheet="Observations",comment=NULL)
      excel_matrix(data.frame(call=toString(result$Call)),wb,sheet="Call",comment=NULL)
      openxlsx::saveWorkbook(wb,file=filename,overwrite=TRUE)
    }
  }
  return(result)
}
##########################################################################################
# PARTIAL CORRELATION
##########################################################################################
# The first two variables are for the correlation,the rest are the control variables
# partial.results<-pstats::cor(c("V1","V2","V3","V4"),var(cordata))
# partial.results
# pcor.test(partial.results,2,numberofcases)
##########################################################################################
# SEMI PARTIAL CORRELATION
##########################################################################################
