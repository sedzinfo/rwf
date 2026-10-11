#' @title Exploratory and confirmatory factor analysis for each dimension
#' @description For every dimension of a questionnaire, fits three exploratory
#'   factor analysis (EFA) models with \code{psych::fa} and two one-factor
#'   confirmatory factor analysis (CFA) models with \code{lavaan::cfa}, and
#'   collects their loadings, fit indices, modification indices, residuals,
#'   factor scores and score correlations. All results are also written to an
#'   Excel workbook.
#' @param dimensions Data frame with one row per item and the columns
#'   \code{dimension} (the dimension the item belongs to),
#'   \code{subquestion_text} (the name of the item's column in
#'   \code{df_response}) and \code{key} (\code{1} for an item that is reverse
#'   scored, \code{-1} for an item scored as it is; see Details).
#' @param df_response Data frame of numeric item responses with one column per
#'   item, named as in \code{dimensions$subquestion_text}. Missing responses
#'   must be \code{NA}; recode missing-data codes (such as 0) to \code{NA}
#'   first.
#' @param filename Path of the Excel file to write. Its folder is created if
#'   it does not exist. Default \code{"efa_cfa_models.xlsx"} in the working
#'   directory.
#' @param mini,maxi Lowest and highest possible response. They are used to
#'   reverse score items (\code{mini + maxi - x}). Defaults \code{1} and
#'   \code{5}.
#' @details The models fitted for each dimension are
#'   \enumerate{
#'     \item Model 1: one-factor EFA (maximum likelihood).
#'     \item Model 2: two-factor EFA (maximum likelihood, oblimin rotation).
#'     \item Model 3: three-factor EFA (maximum likelihood, oblimin rotation).
#'     \item Model 4: one-factor CFA (\code{missing = "ML"}, with means).
#'     \item Model 5: Model 4 plus a random intercept factor \code{RI}, with
#'       all its loadings fixed to 1 and unrelated to the dimension's factor.
#'   }
#'   An EFA model that is not identified for the number of items (negative
#'   degrees of freedom), or that fails, is reported as \code{NA}: the
#'   one-factor model needs at least 3 items, the two-factor model 5 and the
#'   three-factor model 6. The CFA models need at least 4 items, because with
#'   3 items the random intercept model has more parameters than the data can
#'   identify (lavaan fits it without a warning, so the function skips it).
#'
#'   The EFA and CFA models use the responses as they are, so items worded in
#'   the opposite direction have negative loadings. The mean scores and the
#'   correlation sheets use reverse scored items: \code{psych::reverse.code} is
#'   called with \code{key * -1}, so the items with \code{key = 1} are
#'   reversed.
#'
#'   Warnings from lavaan (for example about respondents without any answer)
#'   are shown as messages and do not stop the CFA. If a CFA model stops with
#'   an error or does not converge, the CFA columns of that dimension are
#'   \code{NA} and the function continues with the next dimension. In the
#'   lavaan models, a dimension name that is not a syntactically valid R name
#'   (for example one with spaces) is changed with \code{make.names}.
#'
#'   The function stops with an error if \code{dimensions} lacks one of its
#'   columns, if \code{key} has values other than 1 and -1, or if an item is
#'   not a numeric column of \code{df_response}. It warns about responses
#'   outside \code{mini} to \code{maxi} and about items without variance (no
#'   responses, or the same response from everyone), because the EFA and CFA
#'   of their dimension fail.
#'
#'   The function needs the rwf functions \code{model_loadings},
#'   \code{c_bind}, \code{change_data_type}, \code{matrix_triangle},
#'   \code{excel_critical_value} and \code{excel_matrix}.
#' @return A list with
#'   \describe{
#'     \item{efa_cfa_models}{One row per item with n, dimension, variable and
#'       F1 (Model 1 loadings); S2F1, S2F2 (Model 2 structure matrix, the
#'       correlations of the items with the rotated factors); P2F1, P2F2
#'       (Model 2 pattern matrix, the regression weights of the rotated
#'       factors); S3F1 to S3F3 and P3F1 to P3F3 (the same for Model 3); index
#'       with f1_v, f2_v, f3_v (EFA fit of Models 1 to 3: RMSEA with its lower
#'       and upper limits and confidence level, RMS, CFI, TLI); unstandardized
#'       and standardized (Model 4 loadings); unstandardized_RI,
#'       standardized_RI, RI_u and RI_s (Model 5 loadings and random intercept
#'       loadings); index_cfa with fit_CFA and fit_CFA_RI (CFA fit of Models 4
#'       and 5: RMSEA with its limits, SRMR, CFI, TLI). A dimension with fewer
#'       than 7 items gets extra rows (without a variable) for the EFA fit
#'       indices.}
#'     \item{cfa_scores}{Factor scores of Model 4
#'       (\code{lavaan::lavPredict}), one column per dimension whose CFA ran
#'       and one row per row of \code{df_response} (\code{NA} for respondents
#'       without any answer in that dimension).}
#'     \item{plots_scree}{An empty list (the scree plot code is switched
#'       off).}
#'     \item{cfa_coefficients}{Model 4 loadings (lambda), residual variances
#'       (theta) and intercepts, standardized and unstandardized, one row per
#'       item.}
#'   }
#'   The Excel file has the sheets critical (efa_cfa_models, with loadings
#'   beyond 0.32 or below -0.32 highlighted), CFA_Modification_Indexes
#'   (Model 4 modification indices of 10 or more), EFA1F_Residuals (Model 1
#'   residual correlations beyond 0.1 in absolute value), CFA_Coefficients,
#'   CFA_RI_Coefficients, used_items (correlations of the items with the
#'   dimension mean scores), used_items_item_correlation (item pairs sorted by
#'   the size of their correlation), used_items_mean_score and
#'   used_items_cfa_score (correlations between the dimension mean scores and
#'   between the CFA scores). A sheet without any content (for example when no
#'   CFA ran) is not written.
#' @note Most of the run time is spent writing the Excel file, because
#'   \code{excel_critical_value} adds conditional formatting one cell at a
#'   time.
#' @importFrom psych fa reverse.code
#' @importFrom lavaan cfa inspect lavInspect modindices lavPredict
#' @importFrom plyr rbind.fill
#' @importFrom reshape2 melt
#' @importFrom stats cor complete.cases na.omit
#' @importFrom openxlsx createWorkbook saveWorkbook
#' @keywords EFA CFA
#' @export
#' @examples
#' \donttest{
#' items<-c(paste0("E",1:10),paste0("N",1:10),paste0("A",1:10),
#'          paste0("C",1:10),paste0("O",1:10))
#' reverse_items<-c("E2","E4","E6","E8","E10","N2","N4","A1","A3","A5",
#'                  "A7","C2","C4","C6","C8","O2","O4","O6")
#' df<-df_ocean[,items]
#' df[df==0]<-NA # 0 is the missing-data code of df_ocean
#' dimensions<-data.frame(dimension=substr(items,1,1),
#'                        subquestion_text=items,
#'                        key=ifelse(items%in%reverse_items,1,-1))
#' result<-compute_efa_cfa(dimensions=dimensions,
#'                         df_response=df[1:2000,],
#'                         filename=file.path(tempdir(),"efa_cfa_ocean.xlsx"))
#' head(result$efa_cfa_models)
#' round(cor(result$cfa_scores,use="pairwise.complete.obs"),2)
#' }
compute_efa_cfa<-function(dimensions,df_response,filename="efa_cfa_models.xlsx",mini=1,maxi=5) {
  dimensions<-as.data.frame(dimensions)
  df_response<-as.data.frame(df_response)
  missing_columns<-setdiff(c("dimension","subquestion_text","key"),names(dimensions))
  if(length(missing_columns)>0)
    stop("dimensions is missing the column(s): ",paste(missing_columns,collapse=", "))
  if(!is.numeric(dimensions$key)||!all(dimensions$key%in%c(-1,1)))
    stop("dimensions$key must be 1 (reverse scored item) or -1 (item scored as it is)")
  items<-dimensions$subquestion_text
  missing_items<-setdiff(items,names(df_response))
  if(length(missing_items)>0)
    stop("these items of dimensions$subquestion_text are not columns of df_response: ",paste(missing_items,collapse=", "))
  # an item without any response is often read as logical (NA); as numeric it affects only its own dimension
  df_response[items]<-lapply(df_response[items],function(x) if(all(is.na(x))) as.numeric(x) else x)
  if(!all(sapply(df_response[items],is.numeric)))
    stop("the items in df_response must be numeric")
  no_variance<-items[sapply(df_response[items],function(x) length(unique(stats::na.omit(x)))<2)]
  if(length(no_variance)>0)
    warning("these items have no responses or the same response from everyone, so the EFA and CFA of their dimension will fail: ",paste(no_variance,collapse=", "))
  # values outside mini-maxi (such as a missing-data code 0) would be reverse scored to impossible values
  responses<-unlist(df_response[items])
  if(any(responses<mini|responses>maxi,na.rm=TRUE))
    warning("some responses are outside ",mini,"-",maxi," (for example a missing-data code such as 0); recode them to NA first")
  dimensions$dimension_name<-paste0(dimensions$dimension,"_",dimensions$subquestion_text)
  dimensions<-dimensions[order(dimensions$dimension),]
  efa_cfa_models<-temp_efa_cfa<-model_one_residuals_df<-modification_index_df<-df_coef_cfa_all<-df_coef_cfa_all_ri<-cfa_scores<-data.frame()
  cfa_scores<-data.frame(matrix(ncol=0,nrow=nrow(df_response)))
  plots_scree<-list()
  # EFA model with nfactors factors, or NULL when the model is not identified or fails
  fit_efa<-function(data,nfactors) {
    p<-ncol(data)
    if(nfactors>=p||((p-nfactors)^2-(p+nfactors))/2<0)
      return(NULL)
    tryCatch(psych::fa(data,nfactors=nfactors,rotate="oblimin",fm="ml",residuals=TRUE),
             error=function(e) {
               message("EFA of ",i," with ",nfactors," factor(s) failed: ",gsub("\\s+"," ",conditionMessage(e)))
               NULL
             })
  }
  # RMSEA, its limits and confidence level, RMS, CFI and TLI of an EFA model
  # (NA when missing or not finite, such as the TLI of a model without degrees of freedom)
  efa_fit<-function(model) {
    value<-function(x) { x<-as.numeric(x)[1]; if(is.finite(x)) x else NA_real_ }
    if(is.null(model))
      return(rep(NA_real_,7))
    c(value(model$RMSEA["RMSEA"]),value(model$RMSEA["lower"]),value(model$RMSEA["upper"]),
      value(model$RMSEA["confidence"]),value(model$rms),value(model$CFI),value(model$TLI))
  }
  # loadings of an EFA model with the given column labels (NA columns when the model is NULL)
  efa_loadings<-function(model,matrix_type,labels,variables) {
    if(is.null(model)) {
      result<-data.frame(variable=variables)
      result[labels]<-NA
      return(result)
    }
    result<-model_loadings(model,matrix_type=matrix_type,cut=0.001,sort=TRUE)
    result$Matrix<-NULL
    names(result)[-1]<-labels
    result
  }
  for(i in unique(dimensions$dimension)) {
    message("Dimension: ",i)
    temp_df<-df_response[,dimensions[dimensions$dimension%in%i,"subquestion_text"],drop=FALSE]
    # plots_scree[[i]]<-plot_scree(df=temp_df,title=i,base_size=15)
    # fa.parallel(temp_df,fm="ml",use="pairwise",fa="pc")
    model_one<-fit_efa(temp_df,1)
    model_two<-fit_efa(temp_df,2)
    model_three<-fit_efa(temp_df,3)

    if(!is.null(model_one)) {
      model_one_residuals<-model_one$residual
      model_one_residuals<-matrix_triangle(m=model_one_residuals,diagonal=NA,type="lower")
      model_one_residuals<-reshape2::melt(model_one_residuals)
      model_one_residuals<-model_one_residuals[!is.na(model_one_residuals$value),]
      model_one_residuals<-model_one_residuals[abs(model_one_residuals$value)>0.1,]
      model_one_residuals<-model_one_residuals[order(abs(model_one_residuals$value),decreasing=TRUE),]
      names(model_one_residuals)<-c("Q1","Q2","Residual")
      # a dimension without any residual beyond 0.1 adds no rows (data.frame() fails with 0 rows)
      if(nrow(model_one_residuals)>0)
        model_one_residuals_df<-plyr::rbind.fill(model_one_residuals_df,data.frame(dimension=i,model_one_residuals))
    }
    # model_three<-psych::fa(temp_df,nfactors=2,rotate="oblique",fm="ml",residuals=TRUE)
    # report_efa(model=model_one,df=temp_df,w=20,file=paste0(directory,"output/efa/",i,"one_factor"))
    # report_efa(model=model_two,df=temp_df,w=20,file=paste0(directory,"output/efa/",i,"two_factor"))

    name_fit<-c("RMSEA","RMSEA.CI.LOWER","RMSEA.CI.UPPER","RMSEA_CONF","RMS","CFI","TLI")
    f1<-data.frame(name_fit,v=efa_fit(model_one))
    f2<-data.frame(v=efa_fit(model_two))
    f3<-data.frame(v=efa_fit(model_three))

    # S = structure matrix (item-factor correlations), P = pattern matrix (regression weights), both after rotation
    lm1<-efa_loadings(model_one,"pattern","F1",names(temp_df))
    lm2<-efa_loadings(model_two,"structure",c("S2F1","S2F2"),names(temp_df))
    lm3<-efa_loadings(model_two,"pattern",c("P2F1","P2F2"),names(temp_df))
    lm4<-efa_loadings(model_three,"structure",c("S3F1","S3F2","S3F3"),names(temp_df))
    lm5<-efa_loadings(model_three,"pattern",c("P3F1","P3F2","P3F3"),names(temp_df))
    u_efa<-Reduce(function(x,y) merge(x,y,by=c("variable"),sort=FALSE),list(lm1,lm2,lm3,lm4,lm5))
    u_efa<-c_bind(u_efa,f1,f2,f3)
    names(u_efa)<-gsub("u_efa_","",names(u_efa))
    names(u_efa)[grep("f1_name_fit",names(u_efa))]<-"index"
    u_efa<-data.frame(n=1:nrow(u_efa),u_efa)
    # the EFA results are kept for this dimension even if its CFA is skipped or fails
    temp_efa_cfa<-u_efa

    # lavaan needs a syntactically valid name for the factor (for example without spaces)
    latent<-make.names(i)
    model_spesification=paste0(latent,"=~",paste0(names(temp_df),collapse=" + "))
    model_spesification_RI<-paste(model_spesification,
                                  paste("RI=~",paste("1*",names(temp_df),collapse=" + ")),
                                  paste("RI~0*",latent),
                                  sep="\n")

    # the CFA needs at least 4 items; a lavaan warning is shown but does not stop it, an error skips it
    if(ncol(temp_df)<4) {
      message("Skipping the CFA of ",i,": the random intercept model needs at least 4 items")
    } else tryCatch(withCallingHandlers({
      model_cfa<-lavaan::cfa(model_spesification,data=temp_df,missing="ML",meanstructure=TRUE)
      model_cfa_ri<-lavaan::cfa(model_spesification_RI,data=temp_df,missing="ML",meanstructure=TRUE)
      if(!lavaan::lavInspect(model_cfa,"converged")||!lavaan::lavInspect(model_cfa_ri,"converged"))
        stop("the CFA did not converge")
      # placed by row number, because some lavaan versions leave out respondents without any answer
      cfa_score<-rep(NA_real_,nrow(temp_df))
      cfa_score[lavaan::lavInspect(model_cfa,"case.idx")]<-lavaan::lavPredict(model_cfa)[,1]

      modification_indices<-lavaan::modindices(model_cfa,minimum.value=10,sort.=TRUE)
      if(nrow(modification_indices)>0){
        temp_model_cfa_modindices<-data.frame(dimension=i,modification_indices)
      } else {
        temp_model_cfa_modindices<-data.frame(modification_indices)
        temp_model_cfa_modindices[1,]<-NA
        temp_model_cfa_modindices<-data.frame(dimension=i,temp_model_cfa_modindices)
      }

      unstandardized_estimates<-lavaan::inspect(model_cfa,"est")
      standardized_estimates<-lavaan::inspect(model_cfa,"std")
      unstandardized_estimates_ri<-lavaan::inspect(model_cfa_ri,"est")
      standardized_estimates_ri<-lavaan::inspect(model_cfa_ri,"std")

      df_lambda<-data.frame(q=names(unstandardized_estimates$lambda[,1]),lambda=unstandardized_estimates$lambda[,1])
      df_theta<-data.frame(q=names(diag(unstandardized_estimates$theta)),theta=diag(unstandardized_estimates$theta))
      df_nu<-data.frame(q=names(unstandardized_estimates$nu[,1]),intercept=unstandardized_estimates$nu[,1])
      df_lambda_std<-data.frame(q=names(standardized_estimates$lambda[,1]),lambda_std=standardized_estimates$lambda[,1])
      df_theta_std<-data.frame(q=names(diag(standardized_estimates$theta)),theta_std=diag(standardized_estimates$theta))
      df_nu_std<-data.frame(q=names(standardized_estimates$nu[,1]),intercept_std=standardized_estimates$nu[,1])

      df_lambda_ri<-data.frame(q=names(unstandardized_estimates_ri$lambda[,1]),lambda=unstandardized_estimates_ri$lambda[,1],ri=unstandardized_estimates_ri$lambda[,2])
      df_theta_ri<-data.frame(q=names(diag(unstandardized_estimates_ri$theta)),theta=diag(unstandardized_estimates_ri$theta))
      df_nu_ri<-data.frame(q=names(unstandardized_estimates_ri$nu[,1]),intercept=unstandardized_estimates_ri$nu[,1])
      df_lambda_std_ri<-data.frame(q=names(standardized_estimates_ri$lambda[,1]),lambda_std=standardized_estimates_ri$lambda[,1],ri=standardized_estimates_ri$lambda[,2])
      df_theta_std_ri<-data.frame(q=names(diag(standardized_estimates_ri$theta)),theta_std=diag(standardized_estimates_ri$theta))
      df_nu_std_ri<-data.frame(q=names(standardized_estimates_ri$nu[,1]),intercept_std=standardized_estimates_ri$nu[,1])

      df_coef_cfa<-Reduce(function(x,y) merge(x,y,by="q",all=TRUE),list(df_lambda,df_theta,df_nu))
      df_coef_cfa_std<-Reduce(function(x,y) merge(x,y,by="q",all=TRUE),list(df_lambda_std,df_theta_std,df_nu_std))
      df_coef_cfa_ri<-Reduce(function(x,y) merge(x,y,by="q",all=TRUE),list(df_lambda_ri,df_theta_ri,df_nu_ri))
      df_coef_cfa_std_ri<-Reduce(function(x,y) merge(x,y,by="q",all=TRUE),list(df_lambda_std_ri,df_theta_std_ri,df_nu_std_ri))

      temp_df_coef_cfa<-merge(df_coef_cfa_std,df_coef_cfa,by="q")
      temp_df_coef_cfa<-data.frame(dimension=i,temp_df_coef_cfa[order(temp_df_coef_cfa$lambda),])

      temp_df_coef_cfa_ri<-merge(df_coef_cfa_ri,df_coef_cfa_std_ri,by="q")
      temp_df_coef_cfa_ri<-data.frame(dimension=i,temp_df_coef_cfa_ri[order(temp_df_coef_cfa_ri$lambda),])

      unstandardized<-data.frame(dimension=i,variable=row.names(unstandardized_estimates$lambda),unstandardized_estimates$lambda)
      names(unstandardized)[3]<-"unstandardized"
      standardized<-data.frame(dimension=i,variable=row.names(standardized_estimates$lambda),standardized_estimates$lambda)
      names(standardized)[3]<-"standardized"
      u_cfa<-merge(unstandardized,standardized,by=c("dimension","variable"))

      unstandardized<-data.frame(dimension=i,variable=row.names(unstandardized_estimates_ri$lambda),unstandardized_estimates_ri$lambda)
      names(unstandardized)[3]<-"unstandardized"
      standardized<-data.frame(dimension=i,variable=row.names(standardized_estimates_ri$lambda),standardized_estimates_ri$lambda)
      names(standardized)[3]<-"standardized"

      df_theta_ri<-data.frame(dimension=i,variable=names(diag(unstandardized_estimates_ri$theta)),theta=diag(unstandardized_estimates_ri$theta))
      df_nu_ri<-data.frame(dimension=i,variable=row.names(unstandardized_estimates_ri$nu),intercept=unstandardized_estimates_ri$nu[,1])
      u_cfa_ri<-Reduce(function(x,y) merge(x,y,by=c("dimension","variable"),all=TRUE),list(unstandardized,standardized,df_theta_ri,df_nu_ri))
      names(u_cfa_ri)[names(u_cfa_ri)%in%c("unstandardized","RI.x","standardized","RI.y")]<-c("unstandardized_RI","RI_u","standardized_RI","RI_s")
      u_cfanri<-merge(u_cfa,u_cfa_ri,by=c("dimension","variable"),sort=FALSE)

      # cfa_models<-plyr::rbind.fill(cfa_models,unidimensional_cfa)

      names_fit<-c("cfi","tli","rmsea","rmsea.ci.lower","rmsea.ci.upper","tli","cfi","srmr")
      fit_indices<-data.frame(fit=lavaan::inspect(model_cfa,"fit"))
      fit_indices_ri<-data.frame(fit=lavaan::inspect(model_cfa_ri,"fit"))
      fit_indices$index<-row.names(fit_indices)
      fit_indices_ri$index<-row.names(fit_indices_ri)
      fit_indices<-fit_indices[fit_indices$index%in%names_fit,c("index","fit")]
      fit_indices_ri<-fit_indices_ri[fit_indices_ri$index%in%names_fit,c("index","fit")]
      fit_indices_cfa<-merge(fit_indices,fit_indices_ri,by="index",sort=FALSE)
      desired_order<-c("rmsea","rmsea.ci.lower","rmsea.ci.upper","srmr","cfi","tli")
      fit_indices_cfa<-fit_indices_cfa[stats::na.omit(match(desired_order,fit_indices_cfa$index)),]
      row.names(fit_indices_cfa)<-NULL
      fit_indices_cfa$index<-toupper(fit_indices_cfa$index)

      # all.x keeps the EFA fit rows of a dimension with fewer than 7 items
      temp_efa_cfa<-merge(u_efa,u_cfanri,by=c("variable"),all.x=TRUE,sort=FALSE)
      temp_efa_cfa<-temp_efa_cfa[order(temp_efa_cfa$n),]
      temp_efa_cfa<-c_bind(temp_efa_cfa,fit_indices_cfa)
      names(temp_efa_cfa)<-gsub("temp_efa_cfa_","",names(temp_efa_cfa))
      names(temp_efa_cfa)[names(temp_efa_cfa)%in%c("fit_indices_cfa_index","fit_indices_cfa_fit.x","fit_indices_cfa_fit.y")]<-c("index_cfa","fit_CFA","fit_CFA_RI")

      # added only at the end, so a CFA that fails halfway adds nothing to the results
      cfa_scores[[i]]<-cfa_score
      modification_index_df<-plyr::rbind.fill(modification_index_df,temp_model_cfa_modindices)
      df_coef_cfa_all<-plyr::rbind.fill(df_coef_cfa_all,temp_df_coef_cfa)
      df_coef_cfa_all_ri<-plyr::rbind.fill(df_coef_cfa_all_ri,temp_df_coef_cfa_ri)
    },
    warning=function(w) {
      message("Warning in the CFA of ",i,": ",gsub("\\s+"," ",conditionMessage(w)))
      invokeRestart("muffleWarning")
    }),
    error=function(e) {
      message("Skipping the CFA of ",i," due to an error: ",gsub("\\s+"," ",conditionMessage(e)))
      NULL
    })
    temp_efa_cfa$dimension<-i
    efa_cfa_models<-plyr::rbind.fill(efa_cfa_models,temp_efa_cfa)
  }

  names_all<-c("n","dimension","variable","F1","S2F1","S2F2","P2F1","P2F2","S3F1","S3F2","S3F3","P3F1","P3F2","P3F3","index","f1_v","f2_v","f3_v",
               "unstandardized","standardized","unstandardized_RI","RI_u","standardized_RI","RI_s","index_cfa","fit_CFA","fit_CFA_RI")

  names_numeric<-c("n","F1","S2F1","S2F2","P2F1","P2F2","S3F1","S3F2","S3F3","P3F1","P3F2","P3F3","f1_v","f2_v","f3_v",
                   "unstandardized","standardized","unstandardized_RI","RI_u","standardized_RI","RI_s","fit_CFA","fit_CFA_RI")
  # columns of models that never ran (for example when every CFA was skipped) are kept as NA
  efa_cfa_models[setdiff(names_all,names(efa_cfa_models))]<-NA
  efa_cfa_models[,names_numeric]<-change_data_type(efa_cfa_models[,names_numeric],"numeric")

  efa_cfa_models<-efa_cfa_models[,names_all]
  row.names(efa_cfa_models)<-NULL

  comment<-list(dimension="",
                variable="",
                F1="Model 1: Factor Loadings for EFA One Factor Model",
                S2F1="Model 2: Factor Loadings\nStructure Matrix (item-factor correlations after rotation)\nfor EFA Two Factor Model 1st Factor",
                S2F2="Model 2: Factor Loadings\nStructure Matrix (item-factor correlations after rotation)\nfor EFA Two Factor Model 2nd Factor",
                P2F1="Model 2: Factor Loadings\nPattern Matrix (regression weights after rotation)\nfor EFA Two Factor Model 1st Factor",
                P2F2="Model 2: Factor Loadings\nPattern Matrix (regression weights after rotation)\nfor EFA Two Factor Model 2nd Factor",
                S3F1="Model 3: Factor Loadings\nStructure Matrix (item-factor correlations after rotation)\nfor EFA Three Factor Model 1st Factor",
                S3F2="Model 3: Factor Loadings\nStructure Matrix (item-factor correlations after rotation)\nfor EFA Three Factor Model 2nd Factor",
                S3F3="Model 3: Factor Loadings\nStructure Matrix (item-factor correlations after rotation)\nfor EFA Three Factor Model 3rd Factor",
                P3F1="Model 3: Factor Loadings\nPattern Matrix (regression weights after rotation)\nfor EFA Three Factor Model 1st Factor",
                P3F2="Model 3: Factor Loadings\nPattern Matrix (regression weights after rotation)\nfor EFA Three Factor Model 2nd Factor",
                P3F3="Model 3: Factor Loadings\nPattern Matrix (regression weights after rotation)\nfor EFA Three Factor Model 3rd Factor",
                index="Fit Index For EFA Models",
                f1_v="Model 1: Fit Index Value",
                f2_v="Model 2: Fit Index Value",
                f3_v="Model 3: Fit Index Value",
                standardized="Model 4: Standardized Factor Loadings for CFA 1 Factor Model",
                unstandardized="Model 4: Unstandardized Factor Loadings for CFA 1 Factor Model",
                standardized_RI="Model 5: Standardized Factor Loadings for CFA 1 Factor Random Intercept Model",
                unstandardized_RI="Model 5: Unstandardized Factor Loadings for CFA 1 Factor Random Intercept Model",
                RI_u="Model 5: Random Intercept Parameter Unstandardized",
                RI_s="Model 5: Random Intercept Parameter Standardized",
                index_cfa="Fit Index for CFA Models",
                fit_CFA="Model 4: Fit Index Value",
                fit_CFA_RI="Model 5: Fit Index Value")

  key<-dimensions$key
  key<-key*-1
  df_response_reversed<-psych::reverse.code(keys=key,items=df_response[,dimensions$subquestion_text,drop=FALSE],mini=mini,maxi=maxi)
  # reverse.code adds "-" to the end of the names of reversed items
  colnames(df_response_reversed)<-sub("-$","",colnames(df_response_reversed))
  df_meanr<-as.data.frame(matrix(nrow=nrow(df_response_reversed),ncol=0))
  for(i in unique(dimensions$dimension))
    df_meanr[,i]<-rowMeans(df_response_reversed[,dimensions[dimensions$dimension%in%i,"subquestion_text"],drop=FALSE],na.rm=TRUE)

  df_used<-data.frame(df_response_reversed,check.names=FALSE)
  df_used<-df_used[,dimensions[dimensions$subquestion_text%in%names(df_used),"subquestion_text"],drop=FALSE]
  names(df_used)<-dimensions[dimensions$subquestion_text%in%names(df_used),"dimension_name"]
  # pairwise correlations, so that missing responses do not turn whole rows of the matrices into NA
  cor_used_items<-cor(df_used,df_meanr,use="pairwise.complete.obs")

  result_item_correlation<-cor(df_used,use="pairwise.complete.obs")
  mtrc<-matrix_triangle(result_item_correlation,diagonal=NA)
  mtrc<-reshape2::melt(mtrc)
  mtrc<-mtrc[complete.cases(mtrc),]
  mtrc<-mtrc[order(-abs(mtrc$value)),]

  mean_score_correlation<-matrix_triangle(cor(df_meanr,use="pairwise.complete.obs"))

  if(!dir.exists(dirname(filename)))
    dir.create(dirname(filename),recursive=TRUE)
  if (file.exists(filename)) file.remove(filename)
  wb<-openxlsx::createWorkbook()
  c1<-c(">0.32","<-0.32")
  critical<-list(F1=c1,S2F1=c1,S2F2=c1,P2F1=c1,P2F2=c1,
                 S3F1=c1,S3F2=c1,S3F3=c1,P3F1=c1,P3F2=c1,P3F3=c1,
                 standardized=c1,standardized_RI=c1)
  excel_critical_value(df=efa_cfa_models,workbook=wb,sheet="critical",comment=comment,numFmt="#0.00",critical=critical)
  # a sheet is written only when it has content (for example the CFA sheets need at least one CFA that ran)
  if(nrow(modification_index_df)>0)
    excel_critical_value(df=modification_index_df,workbook=wb,sheet="CFA_Modification_Indexes",numFmt="#0.00")
  if(nrow(model_one_residuals_df)>0)
    excel_critical_value(df=model_one_residuals_df,workbook=wb,sheet="EFA1F_Residuals",numFmt="#0.00")
  if(nrow(df_coef_cfa_all)>0)
    excel_critical_value(df=df_coef_cfa_all,workbook=wb,sheet="CFA_Coefficients",numFmt="#0.00")
  if(nrow(df_coef_cfa_all_ri)>0)
    excel_critical_value(df=df_coef_cfa_all_ri,workbook=wb,sheet="CFA_RI_Coefficients",numFmt="#0.00")
  excel_matrix(cor_used_items,wb,sheet="used_items",comment=NULL,conditional_formatting=TRUE,diagonal=FALSE)
  if(nrow(mtrc)>0)
    excel_matrix(mtrc,wb,sheet="used_items_item_correlation")
  excel_matrix(mean_score_correlation,wb,sheet="used_items_mean_score",comment=NULL,conditional_formatting=TRUE,diagonal=FALSE)
  if(ncol(cfa_scores)>0) {
    cfa_score_correlation<-matrix_triangle(cor(cfa_scores,use="pairwise.complete.obs"))
    excel_matrix(cfa_score_correlation,wb,sheet="used_items_cfa_score",comment=NULL,conditional_formatting=TRUE,diagonal=FALSE)
  }
  openxlsx::saveWorkbook(wb,filename,overwrite=TRUE)
  result<-list(efa_cfa_models=efa_cfa_models,cfa_scores=cfa_scores,plots_scree=plots_scree,cfa_coefficients=df_coef_cfa_all)
  return(result)
}
