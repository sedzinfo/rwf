##########################################################################################
# LOADINGS PLOT STACKED WITH CORRELATION
##########################################################################################
#' @title Plot loadings
#' @param model psych EFA model
#' @param matrix_type "pattern" "structure"
#' @param title plot title
#' @param base_size base font size
#' @param color color ranges for heatmap
#' @param sort TRUE or FALSE sort loadings
#' @import ggplot2
#' @import grid
#' @importFrom reshape2 melt
#' @importFrom ggpubr ggarrange
#' @importFrom grDevices colorRampPalette
#' @keywords EFA
#' @export
#' @examples
#' model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="pa",oblique.scores=TRUE)
#' plot_loadings(model=model,matrix_type="structure")
#' plot_loadings(model=model,matrix_type="pattern")
#' cm<-matrix(c(1,.8,.8,.1,.1,.1,
#'              .8,1,.8,.1,.1,.1,
#'              .8,.8,1,.1,.1,.1,
#'              .1,.1,.1,1,.8,.8,
#'              .1,.1,.1,.8,1,.8,
#'              .1,.1,.1,.8,.8,1),
#'              ncol=6,nrow=6)
#' df1<-generate_correlation_matrix(cm,nrows=10000)
#' model1<-psych::fa(df1,nfactors=2,rotate="oblimin",fm="pa",oblique.scores=TRUE)
#' plot_loadings(model=model1,matrix_type="pattern",base_size=30)
#' cm<-matrix(c(1,.1,.1,.1,.1,.1,
#'              .1,1,.1,.1,.1,.1,
#'              .1,.1,1,.1,.1,.1,
#'              .1,.1,.1,1,.8,.8,
#'              .1,.1,.1,.8,1,.8,
#'              .1,.1,.1,.8,.8,1),
#'              ncol=6,nrow=6)
#' df1<-generate_correlation_matrix(cm,nrows=10000)
#' model2<-psych::fa(df1,nfactors=2,rotate="oblimin",fm="pa",oblique.scores=TRUE)
#' plot_loadings(model=model2,matrix_type="pattern",base_size=30)
#' cm<-matrix(c(1,.01,.01,.01,.01,.01,
#'              .01,1,.01,.01,.01,.01,
#'              .01,.01,1,.01,.01,.01,
#'              .01,.01,.01,1,.01,.01,
#'              .01,.01,.01,.01,1,.01,
#'              .01,.01,.01,.01,.01,1),
#'              ncol=6,nrow=6)
#' df1<-generate_correlation_matrix(cm,nrows=10000)
#' model3<-psych::fa(df1,nfactors=2,rotate="oblimin",fm="pa",oblique.scores=TRUE)
#' plot_loadings(model=model3,matrix_type="pattern",base_size=10)
plot_loadings<-function(model,matrix_type=NULL,title="",base_size=10,color=c("#5E912C","white","#5F2C91"),sort=TRUE) {
  ncolours<-30
  colfunc<-colorRampPalette(color[c(1,3)])
  palette_color_complementary<-colfunc(ncolours)
  Relation<-variable<-Correlation<-Loading<-Factor<-NULL
  if(is.null(matrix_type))
    stop("specify matrix_type either pattern or structure")
  load<-model_loadings(model,cut=0,matrix_type=matrix_type,sort=sort)
  correlation_matrix<-data.frame(model$r,variable=row.names(model$r))
  correlation_matrix<-correlation_matrix[order(row.names(correlation_matrix)),order(names(correlation_matrix))]
  if(!sort)
    load<-load[order(row.names(load)),order(names(load))]
  factor_names<-setdiff(names(load),c("Matrix","variable"))
  names_order<-row.names(model$r)
  load<-load[,c(c("Matrix","variable"),factor_names)]
  loadings<-reshape2::melt(load,id="variable",variable.name="Factor",value.name="Loading",measure=factor_names,factorsAsStrings=TRUE)
  # loadings<-reshape2::melt(load,id="variable",measure=factor_names,variable.name="Factor",value.name="Loading")
  correlations<-reshape2::melt(correlation_matrix,id="variable",variable.name="Relation",value.name="Correlation")
  # levels(loadings$variable)<-levels(correlations$variable)<-levels(correlations$Relation)<-names_order
  if(is.null(xlim))
    xlim<-max(loadings$Loading)
  correlation_plot<-ggplot(correlations,aes(Relation,variable,fill=Correlation))+
    geom_tile()+
    scale_fill_gradient2(low=color[1],mid=color[2],high=color[3],midpoint=0)+
    geom_text(aes(label=round(Correlation,2)),size=base_size/4)+
    labs(y="Loading",title="Correlation Matrix")+
    theme_bw(base_size=base_size)+
    theme(axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          axis.text.x=element_text(color="white"),
          legend.position="none")
  stacked_loadings<-ggplot(loadings,aes(variable,abs(Loading),fill=Factor))+
    geom_bar(stat="identity")+
    coord_flip()+
    labs(y="Loading",title=paste(str_proper(matrix_type),"Matrix Loadings"))+
    # scale_fill_manual(values=sample(palette_color_complementary,ncolours/4))+
    theme_bw(base_size=base_size)+
    # lims(y=c(0,1))+
    theme(axis.title.y=element_blank(),
          axis.title.x=element_blank(),
          axis.ticks.y=element_blank(),
          axis.text.y=element_blank())
  correlation_loadings<-ggpubr::ggarrange(plotlist=list(correlation_plot,stacked_loadings))
  plot_barplot<-ggplot(loadings,aes(variable,abs(Loading),fill=Loading))+
    facet_wrap(~Factor,nrow=1)+
    geom_bar(stat="identity")+
    scale_fill_gradient2(name="Loading",high=color[1],mid=color[2],low=color[3],midpoint=0)+
    coord_flip()+
    labs(y="Loading",x="",title=paste(str_proper(matrix_type),"Matrix",title))+
    theme_bw(base_size=base_size)+
    lims(y=c(0,1))
  plotlist<-list(correlation_loadings=correlation_loadings,plot_barplot=plot_barplot)
  invisible(lapply(plotlist,print))
  return(invisible(plotlist))
}
##########################################################################################
# PLOT SCREE
##########################################################################################
#' @title Scree plot displaying the Kaiser and Jolife criteria for factor extraction
#' @param df dataframe
#' @param title plot title
#' @param base_size base font size
#' @param color color of line and point outline
#' @import ggplot2
#' @importFrom reshape2 melt
#' @keywords EFA
#' @export
#' @examples
#' plot_scree(df=mtcars,title="",base_size=15)
plot_scree<-function(df,base_size=15,title="",color=c("#5F2C91","#5E912C")) {
  x<-NULL
  eigenvalues<-data.frame(eigenvalues=eigen(cor(df,use="pairwise.complete.obs"))$values)
  eigenvalues$x<-as.numeric(row.names(eigenvalues))
  kaiser<-length(eigenvalues$eigenvalues[eigenvalues$eigenvalues>1])
  jolliffe<-length(eigenvalues$eigenvalues[eigenvalues$eigenvalues>.7])
  scree_plot<-ggplot(eigenvalues,aes(x=x,y=eigenvalues))+
    geom_hline(yintercept=1,colour=color[1])+
    geom_hline(yintercept=0.7,colour=color[2])+
    geom_line(color=color[1])+
    geom_point(aes(y=eigenvalues),size=base_size/4,color=color[1])+
    scale_x_continuous(labels=eigenvalues$x,breaks=eigenvalues$x)+
    theme_bw(base_size=base_size)+
    labs(x="index",y="Eigenvalue",title=paste("Scree plot",title))+
    annotate("text",x=nrow(eigenvalues),y=max(eigenvalues$eigenvalues),
             label=paste0("Top line: Kaiser criterion:",kaiser,
                          "\nBottom line: Jolliffe criterion:",jolliffe),
             hjust=1,vjust=1,size=base_size/4)+
    theme(legend.title=element_blank(),legend.position="bottom",axis.title.x=element_blank())
  return(scree_plot)
}
##########################################################################################
# FACTOR PATTERN STRUCTURE MATRIX
##########################################################################################
#' @title Pattern and structure matrix
#' @param model psych EFA model
#' @param cut cut point for loadings
#' @param matrix_type "pattern" "structure" "all"
#' @param sort if TRUE it will sort loadings
#' @param ... arguments passed to psych::fa.sort
#' @note Check to see if you have multicolinearity values above .8 in the matrix are problematic \cr
#' Structure matrix represents Loadings after rotation \cr
#' Pattern matrix represents Loadings before rotation \cr
#' @importFrom psych fa.sort
#' @keywords EFA
#' @export
#' @examples
#' model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="pa",oblique.scores=TRUE)
#' model_loadings(model=model,cut=NULL,matrix_type="pattern")
#' model_loadings(model=model,cut=0.4,matrix_type="structure")
#' model_loadings(model=model,cut=0.4,matrix_type="all",sort=FALSE)
model_loadings<-function(model,cut=NULL,matrix_type="pattern",sort=TRUE,...) {
  loading_critical<-data.frame(sample=c(50,60,70,85,100,120,150,200,250,350),
                               critical_loading=c(.75,.70,.65,.60,.55,.50,.45,.40,.35,.30))
  n<-model$n.obs
  if(is.null(cut))
    cut<-loading_critical[which(abs(loading_critical$sample-n)==min(abs(loading_critical$sample-n))),2]
  if(length(model$values)>0){
    loading_matrix_pattern<-round(model$loadings,2)
    loading_matrix_structure<-round(model$Structure,2)
    if(sort){
      loading_matrix_pattern<-psych::fa.sort(round(model$loadings,2),...)
      loading_matrix_structure<-psych::fa.sort(round(model$Structure,2),...)
    }
    loading_matrix_pattern<-data.frame(Matrix="Pattern",
                                       variable=row.names(loading_matrix_pattern),
                                       ifelse(abs(loading_matrix_pattern)<cut,"",loading_matrix_pattern))
    loading_matrix_structure<-data.frame(Matrix="Structure",
                                         variable=row.names(loading_matrix_structure),
                                         ifelse(abs(loading_matrix_structure)<cut,"",loading_matrix_structure))
    switch(matrix_type,
           pattern={
             loading_matrix<-loading_matrix_pattern
           },structure={
             loading_matrix<-loading_matrix_structure
           },all={
             loading_matrix<-rbind(loading_matrix_pattern,loading_matrix_structure,make.row.names=FALSE)
           })
  }
  # loading_matrix[,3:length(loading_matrix)]<-change_data_type(loading_matrix[,3:length(loading_matrix)],type="numeric")
  return(loading_matrix)
}
##########################################################################################
# EFA OBSERVED AND EXPECTED CORRELATION MATRIX RESIDUALS
##########################################################################################
#' @title Residuals for matrices
#' @description Root Mean Squared Residual Number of absolute residuals > 0.05  Proportion of absolute residuals > 0.05. It can either accept a psych EFA model or it can compare two correlation or covariance matrices
#' @param model psych EFA model. It has to be a correlation or covariance matrix if data is not NULL
#' @param data correlation or covariance matrix
#' @keywords EFA
#' @export
#' @examples
#' model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="pa",oblique.scores=TRUE)
#' compute_residual_stats(model)
compute_residual_stats<-function(model,data=NULL) {
  if(!is.null(data))
    residuals<-model-data
  else
    residuals<-as.matrix(model$residual[upper.tri(model$residual)])
  large_residuals<-abs(residuals)>0.05
  n_large_residuals<-sum(large_residuals)
  propLargeResid<-n_large_residuals/nrow(residuals)
  rmsr<-sqrt(mean(residuals^2))
  result<-data.frame(residual_statistics=c("Root Mean Squared Residual",
                                           "Number of absolute residuals > 0.05",
                                           "Proportion of absolute residuals > 0.05"),
                     value=c(rmsr,n_large_residuals,propLargeResid),
                     critical=c(NA,NA,.5),
                     formula=c("sqrt(mean(residuals^2))",
                               "abs(residuals)>0.05",
                               "numberLargeResiduals/nrow(residuals)"))
  return(result)
}
##########################################################################################
# REPORT EFA
##########################################################################################
#' @title Output EFA model
#' @param model psych EFA model
#' @param df dataframe
#' @param file output filename
#' @param w width of pdf file
#' @param h height of pdf file
#' @param cut cut point for loadings
#' @param base_size base font size
#' @param scores if TRUE it will output factor scores in excel file
#' @note Orthogonal=varimax, Oblique=oblimin
#' @keywords EFA
#' @export
#' @examples
#' model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="minres",oblique.scores=TRUE)
#' report_efa(model=model,df=mtcars,file="efa")
#' model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="uls",oblique.scores=TRUE)
#' report_efa(model=model,df=mtcars)
#' model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="ols",oblique.scores=TRUE)
#' report_efa(model=model,df=mtcars)
#' model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="wls",oblique.scores=TRUE)
#' report_efa(model=model,df=mtcars)
#' model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="gls",oblique.scores=TRUE)
#' report_efa(model=model,df=mtcars)
#' model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="pa",oblique.scores=TRUE)
#' report_efa(model=model,df=mtcars)
#' model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="ml",oblique.scores=TRUE)
#' report_efa(model=model,df=mtcars)
#' model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="minchi",oblique.scores=TRUE)
#' report_efa(model=model,df=mtcars)
#' model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="minrank",oblique.scores=TRUE)
#' report_efa(model=model,df=mtcars)
#' model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="old.min",oblique.scores=TRUE)
#' report_efa(model=model,df=mtcars)
#' model<-psych::fa(mtcars,nfactors=2,rotate="oblimin",fm="alpha",oblique.scores=TRUE)
#' #report_efa(model=model,df=mtcars)
report_efa<-function(model,df,file=NULL,w=10,h=5,cut=0,base_size=10,scores=FALSE) {
  comment<-list("p[bartlett]"=toString(c("Bartlett's test, tests for identity matrix",
                                         "\nAn identity matrix indicates no correlations among data",
                                         "\nSignificance indicates a non identity matrix")),
                determinant="Determinant should be > 0.00001. Lower values indicate problematic correlation matrices if subjected to calculations",
                complexity="Hoffman's index of complexity for each item. {(SUM a_i^2)^2}/{SUM a_i^4} where a_i is the factor loading on the ith factor. Hofmann (1978)",
                communality="communality estimates for each item. These are merely the sum of squared factor loadings for that item",
                uniquenesses="",
                values="eigen values of the common factor solution",
                e.values="eigen values of the original matrix",
                RMSEA="root mean square error of approximation",
                lower="lower bound for rmsea",
                upper="upper bound for rmsea",
                confidence="confidence level for rmsea",
                rms="root mean square error",
                crms="rms adjusted for degrees of freedom",
                tli="tucker lewis index",
                bic="",
                ebic="",
                esabic="",
                fit="",
                fit.off="")
  
  instruction_kaiser<-"Kaiser's criterion is accurate for fewer than 30 variables and communalities greater than .7 or when the sample size exceeds 250 and average communality is greater than .6\n The eigenvalues associated with each factor represent the variance explained by that particular linear component\n Histogram of residuals may show outliers or a bad model fit it may also indicate that we may have to remove items\n"
  instruction_loadings<-"The correlation coefficients between each variable and factor\n Pattern Loadings: Loadings before rotation\n Structure Loadings: Loadings after rotation"
  instruction_communalities<-"h2: Communality, Communality is the proportion of common variance within a variable"
  instruction_loading_critical_values<-data.frame(sample=c(50,60,70,85,100,120,150,200,250,350),
                                                  critical_loading=c(.75,.70,.65,.60,.55,.50,.45,.40,.35,.30))
  ##########################################################################################
  instruction_kmo<-data.frame(value=c("between .0 and .5","between .5 and .7","between .7 and .8","between .8 and .9","between .9 and  1"),
                              "Kaiser (1974)"=c("Unacceptable","Mediocre","Good","Great","Superb"),
                              Source="Hutcheson & Sofroniou (1999)",
                              check.names=FALSE)
  correlationmatrix<-stats::cor(df,use="pairwise.complete.obs")
  bartlett<-psych::cortest.bartlett(correlationmatrix,nrow(df))
  determinant_test<-data.frame(determinant=det(correlationmatrix),above_critical=det(correlationmatrix)>0.00001)
  kmo<-psych::KMO(df)
  kmo_test<-data.frame(Overall_MSA=kmo$MSA,MSA=kmo$MSAi)
  kmo_test$Kaiser_1974<-NA
  
  # if(nrow(kmo_test[kmo_test$MSA<=.5,])>0)
  #   kmo_test[kmo_test$MSA<.5,]$Kaiser_1974<-"Unacceptable"
  # if(nrow(kmo_test[kmo_test$MSA>.5&kmo_test$MSA<=.7,])>0)
  #   kmo_test[kmo_test$MSA>=.5&kmo_test$MSA<=.7,]$Kaiser_1974<-"Mediocre"
  # if(nrow(kmo_test[kmo_test$MSA>.7&kmo_test$MSA<=.8,])>0)
  #   kmo_test[kmo_test$MSA>.7&kmo_test$MSA<=.8,]$Kaiser_1974<-"Good"
  # if(nrow(kmo_test[kmo_test$MSA>.8&kmo_test$MSA<=.9,])>0)
  #   kmo_test[kmo_test$MSA>.8&kmo_test$MSA<=.9,]$Kaiser_1974<-"Great"
  # if(nrow(kmo_test[kmo_test$MSA>.9,])>0)
  #   kmo_test[kmo_test$MSA>.9,]$Kaiser_1974<-"Superb"
  bartlett_test<-data.frame("x_squared[bartlett]"=bartlett$chisq,"df[bartlett]"=bartlett$df,"p[bartlett]"=bartlett$p.value,check.names=FALSE)
  ##########################################################################################
  fit_index<-data.frame(t(model$RMSEA),
                        RMS=model$rms,
                        CRMS=model$crms,
                        TLI=model$TLI,
                        CFI=model$CFI,
                        BIC=model$BIC,
                        SABIC=model$SABIC,
                        EBIC=model$EBIC,
                        ESABIC=model$ESABIC,
                        fit=model$fit,
                        fit.off=model$fit.off)
  
  plot<-list()
  filename<-paste0(file,".xlsx")
  if(length(model$values)>0){
    #parallel<-psych::fa.parallel(df,n.obs=NULL,fm="minres",fa="both",main="Parallel Analysis Scree Plots",n.iter=20,error.bars=TRUE,se.bars=TRUE,SMC=FALSE,ylabel=NULL,show.legend=TRUE,sim=TRUE,quant=.95,cor="cor",use="pairwise")
    plot[["plot_scree"]]<-plot_scree(df,base_size=base_size,title="")
    plot[["plot_loadings_structure"]]<-plot_loadings(model,matrix_type="structure",base_size=base_size)
    plot[["plot_loadings_pattern"]]<-plot_loadings(model,matrix_type="pattern",base_size=base_size)
  }
  plot[["plot_residual_histogram"]]<-plot_histogram(data.frame(data=model$residual[upper.tri(model$residual)])$data,bins=30,title="Histogram of residuals",base_size=base_size)
  report_pdf(plotlist=plot,file=file,w=w,h=h,print_plot=TRUE)
  
  residual_stats<-compute_residual_stats(model)

  model_communality<-data.frame(complexity=model$complexity,
                                communality=model$communality,
                                communalities=model$communalities,
                                uniquenesses=model$uniquenesses,
                                values=model$values,
                                e.values=model$e.values)
  
  correlations<-rbind(data.frame(type="reproduced correlations",model$model),
                      data.frame(type="observed correlations",model$r),
                      data.frame(type="residual correlations",model$residual))
  loadings<-plyr::rbind.fill(model_loadings(model,cut,matrix_type="all"),
                             # data.frame(type="Phi",model$Phi),
                             data.frame(type="variance accounted",row.names(model$Vaccounted),model$Vaccounted))
  model_call<-data.frame(call=call_to_string(model))
  
  result<-list(correlations=correlations,npobs=model$np.obs,residual_stats=residual_stats,determinant_test=determinant_test,bartlett_test=bartlett_test,kmo_test=kmo_test)
  if(length(model$values)>0) {
    result[["loadings"]]<-loadings
    result[["instruction_loading_critical_values"]]<-instruction_loading_critical_values
    result[["weights"]]<-model$weights
  }
  if(scores) {
    result[["scores"]]<-model$scores
  }
  if(!is.null(file)) {
    if(file.exists(filename)) file.remove(filename)
    wb<-openxlsx::createWorkbook()
    excel_matrix(correlations,wb,sheet="r",conditional_formatting=TRUE,numFmt="#0.00")
    excel_matrix(model$np.obs,wb,sheet="n",conditional_formatting=TRUE,numFmt="#0.00")
    excel_matrix(residual_stats,wb,sheet="residual stats",conditional_formatting=FALSE)
    excel_critical_value(fit_index,wb,sheet="fit_index")
    
    if(length(model$values)>0) {
      excel_matrix(loadings,wb,sheet="loadings",conditional_formatting=TRUE,title="structure loadings: loadings after rotation, pattern loadings: loadings before rotation")
      excel_matrix(instruction_loading_critical_values,wb,sheet="loading critical values",conditional_formatting=TRUE)
      excel_matrix(model$weights,wb,sheet="weights",conditional_formatting=FALSE)
    }
    
    excel_critical_value(determinant_test,wb,sheet="determinant")
    excel_critical_value(bartlett_test,wb,sheet="bartlett test")
    excel_critical_value(kmo_test,wb,sheet="msa")
    
    excel_matrix(model_communality,wb,sheet="communalities",conditional_formatting=FALSE)
    if(scores)
      excel_matrix(model$scores,wb,sheet="scores",conditional_formatting=TRUE)
    excel_matrix(model_call,wb,sheet="call")
    openxlsx::saveWorkbook(wb,filename)
  }
  return(result)
}
##########################################################################################
# LOADINGS PLOT STACKED WRAPPED
##########################################################################################
# plot_loadings<-function(model) {
#   sorted.model<-psych::fa.sort(model,polar=FALSE)
#   pattern_matrix<-data.frame(sorted.model$loadings[,1:model$factors],stringsAsFactors=FALSE)
#   loadings<-data.frame(pattern_matrix,variable=row.names(pattern_matrix),stringsAsFactors=FALSE)
#   loadings<-reshape2::melt(loadings,id="variable",measure=names(data.frame(model$Structure[])),variable.name="Factor",value.name="Loading",factorsAsStrings=TRUE)
#   loadings$variable<-factor(loadings$variable,levels=loadings$variable)
#   wrapped_loadings<-ggplot(loadings,aes(variable,abs(Loading),fill=Loading))+facet_wrap(~Factor,nrow=1)+geom_bar(stat="identity")+scale_fill_gradient2(name="Loading",high="blue",mid="white",low="red",midpoint=0)+
#     coord_flip()+labs(y="Loading Strength",x="")+theme_bw()
#   stacked_loadings<-ggplot(loadings,aes(variable,abs(Loading),fill=Factor))+geom_bar(stat="identity")+coord_flip()+labs(y="Loading Strength")+theme_bw(base_size=10)+theme(axis.title.y=element_blank())
#   print(wrapped_loadings)
#   print(stacked_loadings)
# }
# plot_loadings(model)
##########################################################################################
# NOTES
##########################################################################################
# model$complexity
# model$communality
# model$communalities
# model$uniquenesses
# model$values
# model$e.values
# model$residual
# model$model
# model$r
# model$np.obs
# model$scores
# model$RMSEA
# model$rms
# model$crms
# model$TLI
# model$BIC
# model$SABIC
# model$EBIC
# model$ESABIC
# model$fit
# model$fit.off
# model$weights
# model$Call
# model$Phi
# model$loadings
# model$Structure
# model$r.scores
# model$score.cor
# model$rot.mat
# model$Vaccounted
# model$communality.iterations
# model$R2
# model$valid
# model$criteria
# model$R2.scores
# model$dof
# model$chi
# model$null.model
# model$null.dof
# model$null.chisq
# model$nh
# model$EPVAL
# model$sd
# model$factors
# model$n.obs
# model$objective
# model$STATISTIC
# model$PVAL
# model$rotation
# model$fm
# model$method
# model$fn
##########################################################################################
# 
##########################################################################################
# This function for obtaining reproduced correlations and residuals, suggested in the literature, is not right at the moment but they may fix it in future.
# reproducedcorrelations<-factor.model(model$loadings)
# residuals<-factor.residuals(correlationmatrix,model$loadings)
# Factor loading = The pearson correlation between a factor and a variable
# If we square a factor loading we obtain a measure of substantive importance of a particular variable to a factor
# Communality = The proportion of common variance of a variable
# A communality of 1 has 0 random variance and 0 unique variance
##########################################################################################
# 
##########################################################################################
# parallel<-psych::fa.parallel(personality,n.obs=NULL,fm="minres",fa="both",main="Parallel Analysis Scree Plots",n.iter=20,error.bars=TRUE,se.bars=TRUE,SMC=TRUE,ylabel=NULL,show.legend=TRUE,sim=TRUE,quant=.95,cor="cor",use="pairwise")
# psych::vss(personality,n=20,rotate="varimax",diagonal=FALSE,fm="minres",n.obs=NULL,plot=TRUE,title="Very Simple Structure",use="pairwise",cor="cor")
