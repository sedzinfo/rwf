##########################################################################################
# GENERATE MATRIX A
##########################################################################################
#' @title Generate Matrix A
#' @param blocks number of blocks
#' @param items number of items per block
#' @keywords tirt irt
#' @export
#' @examples
#' generate_matrix_A(blocks=3,items=3)
generate_matrix_A<-function(blocks=3,items=3) {
  comparison<-generate_comparisons_matrix(items)
  row_length<-nrow(comparison)
  alpha<-matrix(nrow=row_length*blocks,ncol=items*blocks)
  alpha[is.na(alpha)]<-0
  col_index<-increase_index(blocks=blocks,items=items)
  row_index<-increase_index(blocks=blocks,items=row_length)
  for(i in 1:blocks)
    alpha[row_index[i,],col_index[i,]]<-comparison
  return(alpha)
}
##########################################################################################
# GENERATE INDEX FOR ITEM COMPARISONS
##########################################################################################
#' @title Compute number of dummy comparisons
#' @param items number of items per block
#' @keywords tirt irt
#' @export
#' @examples
#' compute_dummy_comparisons(1)
#' compute_dummy_comparisons(2)
#' compute_dummy_comparisons(3)
#' compute_dummy_comparisons(4)
#' compute_dummy_comparisons(5)
#' compute_dummy_comparisons(6)
compute_dummy_comparisons<-function(items) {
  comparisons<-items*(items-1)/2
  return(comparisons)
}
##########################################################################################
# GENERATE INDEX FOR ITEM COMPARISONS
##########################################################################################
#' @title Generate index for unique comparisons
#' @param items number of items
#' @importFrom plyr rbind.fill
#' @keywords tirt irt
#' @export
#' @examples
#' generate_unique_comparisons_index(1)
#' generate_unique_comparisons_index(2)
#' generate_unique_comparisons_index(3)
#' generate_unique_comparisons_index(4)
#' generate_unique_comparisons_index(5)
#' generate_unique_comparisons_index(6)
generate_unique_comparisons_index<-function(items) {
  result<-data.frame()
  for (i1 in 1:items){
    for (i2 in 1:items)
      result<-plyr::rbind.fill(result,data.frame(i1=i1,i2=i2))
  }
  result<-result[apply(result,1,function(x) length(unique(x[!is.na(x)]))!=1),]
  result<-result[result$i1<result$i2,]
  return(as.matrix(result))
}
##########################################################################################
# INCREASE INDEX
##########################################################################################
#' @title index dataframe picks
#' @inheritParams generate_matrix_A
#' @keywords tirt irt
#' @export
#' @examples
#' increase_index(3,3)
increase_index<-function(blocks,items){
  start<-1
  stop<-items
  index<-matrix(seq(start,stop,1),ncol=items)
  for(i in 2:blocks){
    start<-start+items
    stop<-stop+items
    index<-rbind(index,seq(start,stop,1))
  }
  return(index)
}
##########################################################################################
# GENERATE COMPARISONS MATRIX
##########################################################################################
#' @title Generate comparisons matrix
#' @inheritParams generate_unique_comparisons_index
#' @keywords tirt irt
#' @export
#' @examples
#' generate_comparisons_matrix(2)
#' generate_comparisons_matrix(3)
#' generate_comparisons_matrix(4)
#' generate_comparisons_matrix(5)
#' generate_comparisons_matrix(6)
generate_comparisons_matrix<-function(items) {
  comparisons<-generate_unique_comparisons_index(items)
  result<-matrix(nrow=nrow(comparisons),ncol=items)
  result[is.na(result)]<-0
  for (i in 1:nrow(comparisons)){
    result[i,comparisons[i,1]]<-1
    result[i,comparisons[i,2]]<--1
  }
  return(result)
}
##########################################################################################
# GENERATE MATRIX lambda HAT
##########################################################################################
#' @title Generate matrix lambda for specified number of comparisons
#' @inheritParams generate_matrix_A
#' @keywords tirt irt
#' @export
#' @examples
#' generate_matrix_lambda_hat(blocks=3,items=4)
generate_matrix_lambda_hat<-function(blocks=3,items=3) {
  lambda<-matrix(nrow=0,ncol=items)
  for (i in 1:blocks)
    lambda<-rbind(lambda,generate_comparisons_matrix(items))
  return(lambda)
}
##########################################################################################
# RANK BLOCK TO BINARY
##########################################################################################
#' @title Convert scale to thurstonian binary with n items per ranking block
#' @param mydata dataframe
#' @param items number of items in block
#' @param reverse if TRUE assumes that the highest value is first item in rank if FALSE the lowest value is the first item in rank
#' @keywords tirt irt
#' @export
#' @examples
#' set.seed(12345)
#' mydata<-data.frame(i1=round(rnorm(10,mean=2,sd=1),2),
#'                    i2=round(rnorm(10,mean=2,sd=1),2),
#'                    i3=round(rnorm(10,mean=2,sd=1),2),
#'                    i4=round(rnorm(10,mean=2,sd=1),2),
#'                    i5=round(rnorm(10,mean=2,sd=1),2),
#'                    i6=round(rnorm(10,mean=2,sd=1),2))
#' rank_to_binary(mydata[,c("i1","i2","i3")],items=3)
#' rank_to_binary(mydata[,c("i1","i2","i3")],items=3,reverse=FALSE)
#' rank_to_binary(mydata,items=3)
rank_to_binary<-function(mydata,items,reverse=TRUE) {
  if(missing(items))
    items<-length(mydata)
  index<-generate_unique_comparisons_index(items)
  binary<-index_name<-list()
    for(i in 1:nrow(index)) {
      index_name[[i]]<-paste0("i",index[i,1],index[i,2])
      binary[[index_name[[i]]]]<-rep(0,nrow(mydata))
      binary[[index_name[[i]]]][which(mydata[,index[i,1]]>mydata[,index[i,2]])]<-1
    }
  binary<-matrix(unlist(binary),nrow=length(binary[[1]]),dimnames=list(NULL,names(binary)))
  if(!reverse)
    binary<-+(!binary)
  return(binary)
}
##########################################################################################
# RANK DATAFRAME TO BINARY
##########################################################################################
#' @title Convert scale to thurstonian binary with n items per block and n blocks
#' @inheritParams rank_to_binary
#' @keywords tirt irt
#' @export
#' @examples
#' set.seed(12345)
#' mydata<-data.frame(i1=rnorm(10,mean=2,sd=.5),
#'                    i2=rnorm(10,mean=2,sd=.5),
#'                    i3=rnorm(10,mean=2,sd=.5),
#'                    i4=rnorm(10,mean=2,sd=.5),
#'                    i5=rnorm(10,mean=2,sd=.5),
#'                    i6=rnorm(10,mean=2,sd=.5))
#' rank_df_to_binary(mydata[,c("i1","i2","i3","i4")],4)
#' rank_df_to_binary(mydata,3)
rank_df_to_binary<-function(mydata,items,reverse=TRUE) {
  binary<-data.frame(index=1:nrow(mydata))
  blocks<-length(mydata)/items
  index<-increase_index(blocks=blocks,items=items)
  for (i in 1:blocks)
    binary<-data.frame(binary,rank_to_binary(mydata[,index[i,]],items,reverse))
  binary$index<-NULL
  return(binary)
}
##########################################################################################
# TRIPLET PAIRS
##########################################################################################
#' @title Create Pair Labels from Consecutive Triplets of Items
#' @description Builds pair labels from items grouped in triplets.
#'
#' In simple terms:
#' items are taken 3 at a time, and for each triplet the function creates
#' the three pair combinations:
#' (1,2), (1,3), and (2,3).
#'
#' Labels are returned as strings such as \code{"i1i2"}, \code{"i1i3"},
#' \code{"i2i3"} (or with your chosen separator / prefix).
#'
#' @param n Either:
#' \itemize{
#'   \item A single integer (total number of items, e.g. \code{15}).
#'   \item A vector of item indices (e.g. \code{4:18}).
#' }
#' @param prefix Character prefix added before each item index.
#'   Default is \code{"i"}.
#' @param sep Character separator inserted between the two item labels.
#'   Default is \code{""}.
#' @param strict Logical. If \code{TRUE} (default), stop with an error when
#'   the number of items is not a multiple of 3. If \code{FALSE}, silently
#'   drops leftover items so only complete triplets are used.
#'
#' @return A character vector of pair labels.
#'
#' @details
#' If there are \eqn{T} triplets, output length is \eqn{3T}, because each
#' triplet contributes exactly 3 pairs.
#'
#' For one triplet \code{(a,b,c)}, the generated labels are:
#' \code{ab}, \code{ac}, \code{bc} (with chosen \code{prefix} and \code{sep}).
#'
#' @keywords utility labels triplets pairs
#' @export
#'
#' @examples
#' # 15 items -> 5 triplets -> 15 pair labels
#' name_triplet_pairs(15)
#'
#' # Custom separator
#' name_triplet_pairs(6, prefix = "i", sep = "_")
#'
#' # Start from specific indices
#' name_triplet_pairs(4:9)
#' # triplets are (4,5,6) and (7,8,9)
#'
#' # Non-multiple of 3 with strict=FALSE -> trims extras
#' name_triplet_pairs(10, strict = FALSE)
#'
#' # Vector input with trimming when needed
#' name_triplet_pairs(4:18, strict = FALSE)
name_triplet_pairs<-function(n,prefix="i",sep="",strict=TRUE) {
  if (length(n)==1L) {
    if (n %% 3 != 0) {
      if (strict) stop("n must be a multiple of 3") else n<-n-(n %% 3)
    }
    items<-seq_len(n)
  } else {
    # if a vector of indices is passed (e.g.,c(4:18)),use it directly
    items<-n
    if (length(items) %% 3 != 0) {
      if (strict) stop("length(items) must be a multiple of 3") 
      else items<-items[seq_len(length(items)-(length(items) %% 3))]
    }
  }
  # split into triplets and make pair labels
  triplets<-split(items,ceiling(seq_along(items) / 3))
  out<-unlist(lapply(triplets,function(g) {
    if (length(g)<3) return(character(0))
    # columns are c(1,2),c(1,3),c(2,3)
    pairs<-combn(g,2)
    paste0(prefix,pairs[1,],sep,prefix,pairs[2,])
  }),use.names=FALSE)
  out
}
##########################################################################################
# RANK BINARY TO TRIPLETS
##########################################################################################
#' @title Convert thurstonian binary triplets to scale
#' @param mydata dataframe
#' @keywords tirt irt
#' @export
#' @examples
#' set.seed(12345)
#' mydata<-data.frame(i1=rnorm(10,mean=2,sd=.5),
#'                    i2=rnorm(10,mean=2,sd=.5),
#'                    i3=rnorm(10,mean=2,sd=.5),
#'                    i4=rnorm(10,mean=2,sd=.5),
#'                    i5=rnorm(10,mean=2,sd=.5),
#'                    i6=rnorm(10,mean=2,sd=.5))
#' result<-rank_to_binary(mydata[,1:3])
#' rank3_to_triplets(result)
rank3_to_triplets<-function(mydata) {
  item1<-item2<-item3<-rep(NA,nrow(mydata))
  result<-data.frame(item1,item2,item3)
  result[mydata[,1]==1&mydata[,2]==1,]$item1<-3
  result[mydata[,1]==1&mydata[,2]==0,]$item1<-2
  result[mydata[,1]==0&mydata[,2]==1,]$item1<-2
  result[mydata[,1]==0&mydata[,2]==0,]$item1<-1
  result[mydata[,1]==0&mydata[,3]==1,]$item2<-3
  result[mydata[,1]==0&mydata[,3]==0,]$item2<-2
  result[mydata[,1]==1&mydata[,3]==1,]$item2<-2
  result[mydata[,1]==1&mydata[,3]==0,]$item2<-1
  result[mydata[,2]==0&mydata[,3]==0,]$item3<-3
  result[mydata[,2]==1&mydata[,3]==0,]$item3<-2
  result[mydata[,2]==0&mydata[,3]==1,]$item3<-2
  result[mydata[,2]==1&mydata[,3]==1,]$item3<-1
  return(result)
}
##########################################################################################
# RESPONSE DIMENSION
##########################################################################################
#' @title index parameter and items relative to their dimensions
#' @param response vector one to number of items
#' @param dimensions number of dimensions
#' @param items item comparisons
#' @keywords tirt irt
#' @export
#' @examples
#' response_dimension(c(1:18),3,c(1,2))
#' response_dimension(c(1:18),3,c(1,3))
#' response_dimension(c(1:18),3,c(2,3))
response_dimension<-function(response,dimensions,items) {
  response_vector<-c()
  for (i in 1:(length(response)/dimensions)) {
    response_vector<-c(response_vector,response[items])
    response<-response[dimensions+1:length(response)]
  }
  return(response_vector)
}
##########################################################################################
# INDEX FROM LAVAAN TO THURSTONIAN
##########################################################################################
#' @title index of items to convert from lavaan to thurstonian order for analysis
#' @param nitems number of items in the questionnaire
#' @param nfactors number of factors
#' @keywords tirt irt
#' @export
#' @examples
#' cfa_icc_index(nitems=18,nfactors=3)
cfa_icc_index<-function(nitems,nfactors=3) {
  index<-nitems/nfactors
  start_index<-list(1)
  for (i in 2:nfactors)
    start_index[[i]]<-index*(i-1)+1
  for(i in 1:length(start_index))
    start_index[[i]]<-start_index[[i]]:(start_index[[i]]+index-1)
  comparison_matrix<-matrix(unlist(start_index),ncol=nfactors,byrow=FALSE)
  index<-c()
  for(i in 1:nrow(comparison_matrix))
    index<-c(index,as.numeric(comparison_matrix[i,]))
  result<-list(index_vector=index,index_matrix=comparison_matrix)
  return(result)
}
##########################################################################################
# ITEM CHARACTERISTIC CURVE FOR CFA INPUT
##########################################################################################
#' @title Select responses for each dimension
#' @param eta eta or ability
#' @param gamma gamma or threshold
#' @param lambda lambda or loading
#' @param psi psi or error
#' @keywords tirt irt
#' @export
#' @examples
#' icc_cfa(seq(-6,6,.1),1,1,1)
icc_cfa<-function(eta,gamma,lambda,psi) {
  result<-pnorm((-gamma+lambda*eta)/(sqrt(psi)))
  return(result)
}
##########################################################################################
# PLOT ICC THURSTONIAN
##########################################################################################
#' @title Plot thurstonian icc
#' @description Plot icc curves for binary thurstonian coded items for a single dimension using the compute_icc_thurstonian function
#' @param mydata dataframe from compute_icc_thurstonian function
#' @param title plot title
#' @import ggplot2
#' @importFrom reshape2 melt
#' @keywords tirt irt
#' @export
#' @examples
#' gamma<-c(0.556,-1.253,-1.729,0.618,0.937,0.295,-0.672,-1.127,-0.446,0.632,1.147,0.498)
#' psi<-c(2.172,1.883,2.055,1.869,2.231,2.100,1.762,1.803,1.565,1.892,1.794,1.686)
#' lambda<-c(1.082,1.082,-1.297,-1.297,0.802,0.802,1.083,1.083)
#' gamma<-gamma[response_dimension(c(1:12),3,c(1,2))]
#' psi<-psi[response_dimension(c(1:12),3,c(1,2))]
#' eta<-seq(-6,6,by=1)
#' result<-compute_icc_thurstonian(eta=eta,gamma=gamma,lambda=lambda,psi=psi,plot=TRUE)
#' plot_icc_thurstonian(result$icc)
plot_icc_thurstonian<-function(mydata,title="Item Characteristic Curve") {
  value<-eta<-variable<-NULL
  mydata<-reshape2::melt(mydata,id.vars="eta")
  plot<-ggplot(mydata,aes(y=value,x=eta,group=variable,color=variable))+geom_point(alpha=.1)+geom_line()+theme_bw()+
    labs(y=expression(P(eta)),x=expression(eta),title=title)
  return(plot)
}
##########################################################################################
# COMPUTE ICC THURSTONIAN
##########################################################################################
#' @title Compute item characteristic curves for thurstonian models
#' @description Computes icc curves for binary thurstonian coded items for a single dimension
#' @param eta eta or ability
#' @param gamma gamma or threshold
#' @param lambda lambda or loading
#' @param psi psi or error
#' @param plot if TRUE plots icc curves using the plot_icc_thurstonian function
#' @keywords tirt irt
#' @export
#' @examples
#' gamma<-c(0.556,-1.253,-1.729,0.618,0.937,0.295,-0.672,-1.127,-0.446,0.632,1.147,0.498)
#' psi<-c(2.172,1.883,2.055,1.869,2.231,2.100,1.762,1.803,1.565,1.892,1.794,1.686)
#' lambda<-c(1.082,1.082,-1.297,-1.297,0.802,0.802,1.083,1.083)
#' gamma<-gamma[response_dimension(c(1:12),3,c(1,2))]
#' psi<-psi[response_dimension(c(1:12),3,c(1,2))]
#' eta<-seq(-6,6,by=0.01)
#' compute_icc_thurstonian(eta=eta,gamma=gamma,lambda=lambda,psi=psi,plot=FALSE)
compute_icc_thurstonian<-function(eta,gamma,lambda,psi,plot=FALSE) {
  result<-data.frame(eta)
  for(i in 1:length(lambda)) {
    item<-icc_cfa(eta,gamma[i],lambda[i],psi[i])
    result<-data.frame(result,item)
  }
  result<-result[,c(grep("item",names(result),value=TRUE),"eta")]
  names(result)[1:length(lambda)]<-paste0("item",1:length(lambda))
  if(plot)
    plot<-plot_icc_thurstonian(result,title="Item Characteristic Curve")
  return(list(icc=result,plot=plot))
}
##########################################################################################
# COMPUTE ABILITY
##########################################################################################
#' @title Compute subject ability for thurstonian models
#' @description Computes person ability for binary thurstonian coded items for a single dimension
#' @param eta eta or ability
#' @param gamma gamma or threshold
#' @param lambda lambda or loading
#' @param psi psi or error
#' @param plot if TRUE plots icc curves using the plot_icc_thurstonian function
#' @param response item responses
#' @param map vector from compute_map
#' @keywords tirt irt
#' @export
#' @examples
#' gamma<-c(0.556,-1.253,-1.729,0.618,0.937,0.295,-0.672,-1.127,-0.446,0.632,1.147,0.498)
#' psi<-c(2.172,1.883,2.055,1.869,2.231,2.100,1.762,1.803,1.565,1.892,1.794,1.686)
#' lambda<-c(1.082,1.082,-1.297,-1.297,0.802,0.802,1.083,1.083)
#' gamma<-gamma[response_dimension(c(1:12),3,c(1,2))]
#' psi<-psi[response_dimension(c(1:12),3,c(1,2))]
#' eta<-seq(-6,6,by=0.1)
#' response1<-c(0,0,0,0,0,0,0,0)
#' response2<-c(1,1,1,1,1,1,1,1)
#' response3<-c(1,0,1,0,1,0,1,0)
#' response4<-c(0,1,0,1,0,1,0,1)
#' map<-compute_map(eta=eta,mean=0,sd=1)
#' compute_ability(response1,eta,gamma,lambda,psi,map=map,plot=FALSE)
#' compute_ability(response2,eta,gamma,lambda,psi,map=map,plot=FALSE)
#' compute_ability(response3,eta,gamma,lambda,psi,map=map,plot=FALSE)
#' compute_ability(response4,eta,gamma,lambda,psi,map=map,plot=FALSE)
compute_ability<-function(response,eta,gamma,lambda,psi,plot=FALSE,map=compute_map(eta=eta,mean=0,sd=1)) {
  result<-compute_icc_thurstonian(eta,gamma,lambda,psi,plot=plot)
  product=1
  for(i in 1:length(response)) {
    product<-product*(result$icc[,i]^response[i])*((1-result$icc[,i])^(1-response[i]))
  }
  product_map=product*map
  ability_ml<-result$icc$eta[which(product==max(product))]
  ability_map<-result$icc$eta[which(product_map==max(product_map))]
  if(plot) {
    repeat {
      if(max(product)<.1)
        product<-product*10
      if(max(product)>=.1)
        break()
    }
    repeat {
      if(max(product_map)<.1)
        product_map<-product_map*10
      if(max(product_map)>=.1)
        break()
    }
    icc_df<-data.frame(product=product,map=product_map,result$icc)
    print(plot_icc_thurstonian(icc_df,title=paste(title="Item Characteristic Curve",
                                                  "ML:",round(ability_ml,2),
                                                  "MAP:",round(ability_map,2),
                                                  "\nResponse:",sum(response),
                                                  "Response Length:",length(response))))
  } else {
    icc_df<-data.frame(product=product,map=product_map,result$icc)
  }
  return(list(product=product,icc=icc_df,ability_ml=ability_ml,ability_map=ability_map))
}
##########################################################################################
# COMPUTE ICC THURSTONIAN
##########################################################################################
#' @title Compute subject ability for thurstonian models
#' @description Computes person ability for binary thurstonian coded items for a single dimension
#' @param mydata item responses
#' @param ... arguments passed to compute_ability
#' @keywords IRT Thurstonian
#' @export
#' @examples
#' gamma<-c(0.556,-1.253,-1.729,0.618,0.937,0.295,
#'         -0.672,-1.127,-0.446,0.632,1.147,0.498)
#' psi<-c(2.172,1.883,2.055,1.869,2.231,2.100,
#'        1.762,1.803,1.565,1.892,1.794,1.686)
#' lambda<-c(1.082,1.082,-1.297,-1.297,0.802,0.802,1.083,1.083)
#' gamma<-gamma[response_dimension(c(1:12),3,c(1,2))]
#' psi<-psi[response_dimension(c(1:12),3,c(1,2))]
#' eta<-seq(-6,6,by=0.1)
#' map<-compute_map(eta=eta,mean=0,sd=1)
#' response_df<-data.frame(matrix(nrow=0,ncol=8))
#' response_df[1,]<-c(0,0,0,0,0,0,0,0)
#' response_df[2,]<-c(1,1,1,1,1,1,1,1)
#' response_df[3,]<-c(1,0,1,0,1,0,1,0)
#' response_df[4,]<-c(0,1,0,1,0,1,0,1)
#' compute_scores(response_df,eta,gamma,lambda,psi,map=map,plot=FALSE)
compute_scores<-function(mydata,...) {
  pb<-txtProgressBar(min=0,max=nrow(mydata),style=3)
  ability<-c()
  for (i in 1:nrow(mydata)){
    setTxtProgressBar(pb,i)
    response<-as.numeric(mydata[i,])
    ability<-c(ability,compute_ability(response,...)$ability_map)
  }
  close(pb)
  return(ability)
}
##########################################################################################
# COMPUTE MAP
##########################################################################################
#' @title Simulate prior distribution
#' @param eta vector
#' @param mean numeric
#' @param sd numeric
#' @keywords tirt irt 
#' @export
#' @examples
#' eta<-seq(-6,6,by=0.1)
#' compute_map(eta=eta,mean=0,sd=1)
compute_map<-function(eta,mean=0,sd=1) {
  prior_density=stats::dnorm(eta,mean=mean,sd=sd)
  map<-prior_density/sum(prior_density)    # after division sum(AXr)=1
  return(map)
}
# ##########################################################################################
# # GET DATA FROM OUTPUT MODEL
# ##########################################################################################
# #' @title Simulate prior distribution
# #' @param model mplus thurstonian cfa model with 3 traits
# #' @import MplusAutomation
# #' @keywords tirt irt
# #' @export
# get_mplus_thu_3t<-function(model) {
#   names_model<-model$parameters$unstandardized[model$parameters$unstandardized$paramHeader %in% "Residual.Variances",]$param
#   psi<-model$parameters$unstandardized[model$parameters$unstandardized$paramHeader %in% "Residual.Variances",]$est #PSI
#   gamma<-model$parameters$unstandardized[model$parameters$unstandardized$paramHeader %in% "Thresholds",]$est #GAMMA
#   l1<-model$parameters$unstandardized[model$parameters$unstandardized$paramHeader %in% "TRAIT1.BY",]$est # LAMBDA
#   l2<-model$parameters$unstandardized[model$parameters$unstandardized$paramHeader %in% "TRAIT2.BY",]$est # LAMBDA
#   l3<-model$parameters$unstandardized[model$parameters$unstandardized$paramHeader %in% "TRAIT3.BY",]$est # LAMBDA
#   items<-length(names_model)
#   d1<-model$savedata[,response_dimension(c(1:items),3,c(1,2))]
#   d2<-model$savedata[,response_dimension(c(1:items),3,c(1,3))]
#   d3<-model$savedata[,response_dimension(c(1:items),3,c(2,3))]
#   g1<-gamma[response_dimension(c(1:items),3,c(1,2))]
#   g2<-gamma[response_dimension(c(1:items),3,c(1,3))]
#   g3<-gamma[response_dimension(c(1:items),3,c(2,3))]
#   psi1<-psi[response_dimension(c(1:items),3,c(1,2))]
#   psi2<-psi[response_dimension(c(1:items),3,c(1,3))]
#   psi3<-psi[response_dimension(c(1:items),3,c(2,3))]
#   result<-list(names_model=names_model,psi=psi,gamma=gamma,l1=l1,l2=l2,l3=l3,d1=d1,d2=d2,d3=d3,g1=g1,g2=g2,g3=g3,psi1=psi1,psi2=psi2,psi3=psi3)
#   return(result)
# }
##########################################################################################
# Pure base R Thurstonian IRT scoring (MAP / Empirical Bayes Modal)
# Reproduces thurstonianIRT::predict() for lavaan-fitted TIRT models.
##########################################################################################

##########################################################################################
# Extract TIRT parameters All pieces are aligned to the row order of Lambda
##########################################################################################
#' @title Extract Thurstonian IRT Parameters from a lavaan-Fitted Model
#' @description Extracts and aligns the core parameter blocks needed for
#' Thurstonian IRT scoring from a fitted lavaan object (as stored in
#' \code{fit_lavaan_obj$fit}). The returned pieces are aligned to the row
#' order of \code{Lambda}, which is critical for correct downstream scoring.
#'
#' Specifically, this function returns:
#' \itemize{
#' \item \code{Lambda}: factor loading matrix.
#' \item \code{theta_diag}: residual variances (diagonal of \code{theta}),
#' reordered to \code{rownames(Lambda)} when names are available.
#' \item \code{tau}: thresholds from \code{tau}, with row suffixes like
#' \code{"|t1"} removed and reordered to \code{rownames(Lambda)}.
#' \item \code{nu}: indicator intercepts; defaults to zero when unavailable.
#' \item \code{Psi}: latent covariance matrix (\code{psi}).
#' }
#'
#' @param fit_lavaan_obj A fitted object containing a lavaan fit in
#' \code{$fit}. For example, an object produced by a wrapper that stores
#' a lavaan model under \code{fit_lavaan_obj$fit}.
#'
#' @return A named list with elements:
#' \code{Lambda}, \code{theta_diag}, \code{tau}, \code{nu}, and \code{Psi}.
#'
#' @details Threshold rows in lavaan are often named like \code{"item|t1"}.
#' This function strips everything after \code{"|"} before matching thresholds
#' to indicators.
#'
#' @keywords tirt lavaan irt scoring
#' @export
#'
#' @examples
#' library(thurstonianIRT)
#' data("triplets")
#' # define the blocks of items
#' blocks <-
#'   set_block(c("i1", "i2", "i3"), traits = c("t1", "t2", "t3"),
#'             signs = c(1, 1, 1)) +
#'   set_block(c("i4", "i5", "i6"), traits = c("t1", "t2", "t3"),
#'             signs = c(-1, 1, 1)) +
#'   set_block(c("i7", "i8", "i9"), traits = c("t1", "t2", "t3"),
#'             signs = c(1, 1, -1)) +
#'   set_block(c("i10", "i11", "i12"), traits = c("t1", "t2", "t3"),
#'             signs = c(1, -1, 1))
#' # generate the data to be understood by 'thurstonianIRT'
#' triplets_long <- make_TIRT_data(
#'   data = triplets, blocks = blocks, direction = "larger",
#'   format = "pairwise", family = "bernoulli", range = c(0, 1)
#' )
#' # fit the data using lavaan
#' fit <- fit_TIRT_lavaan(triplets_long)
#' pars <- extract_tirt_params(fit)
extract_tirt_params<-function(fit_lavaan_obj) {
  est<-lavaan::lavInspect(fit_lavaan_obj$fit, "est")
  lambda<-est$lambda
  ind<-rownames(lambda)
  
  # residual variances -- align to lambda by indicator name
  theta_diag<-diag(est$theta)
  if(!is.null(names(theta_diag))) {
    theta_diag<-theta_diag[ind]
  }
  
  # thresholds -- tau rownames look like "i12b1|t1"; strip "|t..." and align
  tau_mat<-est$tau
  tau_names<-sub("\\|.*$", "", rownames(tau_mat))
  tau_vec<-as.numeric(tau_mat)
  names(tau_vec)<-tau_names
  tau_vec<-tau_vec[ind]
  
  # intercepts -- usually fixed at 0 for binary indicators, but check anyway
  nu_vec<-rep(0, length(ind))
  names(nu_vec)<-ind
  if (!is.null(est$nu)) {
    nu_named<-as.numeric(est$nu)
    names(nu_named)<-rownames(est$nu)
    if (all(ind %in% names(nu_named))) {
      nu_vec<-nu_named[ind]
    }
  }
  list(lambda=lambda,theta_diag=theta_diag,tau=tau_vec,nu=nu_vec,Psi=est$psi)
}
##########################################################################################
# SCORE RESPONSE PATTERN
##########################################################################################
#' @title Score a Single Thurstonian IRT Response Pattern (MAP / EBM)
#' @description Computes the maximum a posteriori (MAP), also called empirical
#' Bayes modal (EBM), estimate of latent traits for one binary / ordinal
#' response pattern under a Thurstonian IRT parameterization.
#'
#' Missing responses are allowed and are ignored in the likelihood.
#'
#' @param pattern Numeric vector of observed responses for one person, typically
#' coded 0/1, with optional NA values for missing responses. Its order must
#' match the row order of lambda (or be pre-aligned before calling).
#' @param lambda Matrix of factor loadings with rows as observed indicators and
#' columns as latent traits.
#' @param theta_diag Numeric vector of residual variances (diagonal of theta),
#' aligned to rows of lambda.
#' @param tau Numeric vector of thresholds, aligned to rows of lambda.
#' @param Psi Latent covariance matrix (traits x traits), positive definite.
#' @param nu Optional numeric vector of indicator intercepts aligned to rows of
#' lambda. If NULL, a zero vector is used.
#' @param init Optional numeric vector of starting values for optimization.
#' If NULL, starts at zeros.
#' @param control Named list of control arguments passed to optim, merged with
#' defaults reltol = 1e-10 and maxit = 500.
#'
#' @return Named numeric vector of latent trait MAP estimates, with names taken
#' from colnames(lambda).
#'
#' @details The function maximizes the posterior:
#' likelihood from a probit measurement model plus a multivariate normal
#' prior on traits with covariance Psi. Optimization uses BFGS via optim
#' with an analytic gradient.
#'
#' @importFrom stats optim
#' @importFrom utils modifyList
#' 
#' @keywords tirt irt map ebm scoring
#' @export
#'
#' @examples
#' library(thurstonianIRT)
#' data("triplets")
#' # define the blocks of items
#' blocks <-
#'   set_block(c("i1", "i2", "i3"), traits = c("t1", "t2", "t3"),
#'             signs = c(1, 1, 1)) +
#'   set_block(c("i4", "i5", "i6"), traits = c("t1", "t2", "t3"),
#'             signs = c(-1, 1, 1)) +
#'   set_block(c("i7", "i8", "i9"), traits = c("t1", "t2", "t3"),
#'             signs = c(1, 1, -1)) +
#'   set_block(c("i10", "i11", "i12"), traits = c("t1", "t2", "t3"),
#'             signs = c(1, -1, 1))
#' # generate the data to be understood by 'thurstonianIRT'
#' triplets_long <- make_TIRT_data(
#'   data = triplets, blocks = blocks, direction = "larger",
#'   format = "pairwise", family = "bernoulli", range = c(0, 1)
#' )
#' # fit the data using lavaan
#' fit <- fit_TIRT_lavaan(triplets_long)
#' pars <- extract_tirt_params(fit)
#' pattern<-as.numeric(triplets[1,])
#' score_tirt_pattern(pattern,lambda=pars$lambda,theta_diag=pars$theta_diag,
#'                    tau=pars$tau,Psi=pars$Psi,nu=NULL,init=NULL,
#'                    control=list())
score_tirt_pattern<-function(pattern,lambda,theta_diag,tau,Psi,nu=NULL,init=NULL,control=list()) {
  n_traits<-ncol(lambda)
  if (is.null(nu)) 
    nu<-rep(0,nrow(lambda))
  obs<-!is.na(pattern)
  L<-lambda[obs, , drop=FALSE]
  y<-as.numeric(pattern[obs])
  s<-sqrt(theta_diag[obs])
  th<-tau[obs]-nu[obs]
  # iPsi<-solve(Psi)
  iPsi<-compute_solve(Psi)
  nll<-function(eta) {
    z <-(as.numeric(L %*% eta) - th) / s
    p <-pmin(pmax(pnorm(z), 1e-15), 1 - 1e-15)
    ll<-sum(y * log(p) + (1 - y) * log1p(-p))
    lp<--0.5 * sum(eta * (iPsi %*% eta))
    -(ll + lp)
  }
  gnll<-function(eta) {
    z<-(as.numeric(L %*% eta) - th) / s
    p<-pmin(pmax(pnorm(z), 1e-15), 1 - 1e-15)
    phi<-stats::dnorm(z)
    w<-(y - p) * phi / (p * (1 - p)) / s
    -(as.numeric(crossprod(L, w)) - as.numeric(iPsi %*% eta))
  }
  
  if (is.null(init)) init<-rep(0, n_traits)
  ctrl<-utils::modifyList(list(reltol=1e-10, maxit=500), control)
  
  res<-stats::optim(init,nll,gr=gnll,hessian=TRUE,method="BFGS",control=ctrl)
  setNames(res$par, colnames(lambda))
}
##########################################################################################
# SOLVE
##########################################################################################
#' @title Solve Linear Systems or Invert a Matrix (Gauss-Jordan)
#' @description Solves matrix equations of the form A X = B using
#' Gauss-Jordan elimination with partial pivoting.
#'
#' In simple terms:
#' this function takes a square matrix A and finds X so that multiplying
#' A by X gives B.
#'
#' If B is not provided, it uses the identity matrix and returns
#' the inverse of A.
#'
#' @param a Numeric square matrix A.
#' @param b Optional numeric vector or matrix B. Must have the same number
#' of rows as A. If omitted, B is set to the identity matrix.
#'
#' @return
#' If b is a matrix, returns matrix X solving A X = B.
#'
#' If b is a vector, returns vector x solving A x = b.
#'
#' If b is missing, returns the inverse of A.
#'
#' @details
#' Mathematical meaning:
#' \deqn{A X = B}
#' where A is known, B is known, and X is unknown.
#'
#' Algebra meaning:
#' each column of X is the solution to one linear system with the same A.
#'
#' Computational method:
#' the function builds the augmented matrix [A | B], then applies
#' row operations until the left side becomes the identity matrix.
#' At that point, the right side is X.
#'
#' Partial pivoting is used for better numerical stability:
#' in each column, it swaps in the row with the largest absolute pivot.
#'
#' The function stops with an error if A is singular (non-invertible).
#'
#' @keywords algebra matrix linear-equations
#' @export
#'
#' @examples
#' # Example 1: solve A x = b
#' A <- matrix(c(2, 1,
#' 1, 3), nrow = 2, byrow = TRUE)
#' b <- c(1, 2)
#' x <- compute_solve(A, b)
#' x
#' # Check: A %% x should equal b
#' A %% x
#'
#' # Example 2: solve A X = B (multiple right-hand sides)
#' B <- cbind(c(1, 2), c(0, 1))
#' X <- compute_solve(A, B)
#' X
#' # Check: A %% X should equal B
#' A %% X
#'
#' # Example 3: inverse of A (when b is omitted)
#' A_inv <- compute_solve(A)
#' A_inv
#' # Check: A %% A_inv should be identity
#' A %% A_inv
compute_solve <- function(a, b) {
  a <- as.matrix(a)
  n <- nrow(a)
  if (ncol(a) != n) stop("'a' must be square")
  
  if (missing(b)) b <- diag(n)        # default: invert a
  b <- as.matrix(b)
  if (nrow(b) != n) stop("'a' and 'b' have incompatible dimensions")
  
  # Build augmented matrix [a | b]
  M <- cbind(a, b)
  
  # Gauss-Jordan elimination with partial pivoting
  for (i in seq_len(n)) {
    # Find pivot row (largest absolute value in column i, from row i down)
    pivot <- which.max(abs(M[i:n, i])) + i - 1
    if (M[pivot, i] == 0) stop("matrix is singular")
    
    # Swap rows if needed
    if (pivot != i) M[c(i, pivot), ] <- M[c(pivot, i), ]
    
    # Normalize pivot row
    M[i, ] <- M[i, ] / M[i, i]
    
    # Eliminate column i in all other rows
    for (j in seq_len(n)) {
      if (j != i) M[j, ] <- M[j, ] - M[j, i] * M[i, ]
    }
  }
  
  # Right half is the solution
  x <- M[, (n + 1):ncol(M)]
  if (ncol(b) == 1) x <- as.vector(x)
  x
}
##########################################################################################
# SCORE MULTIPLE RESPONSE PATTERNS
##########################################################################################
#' @title Score Multiple Thurstonian IRT Response Patterns (MAP / EBM)
#' @description Scores many respondents at once using Thurstonian IRT
#'   parameters and returns MAP (empirical Bayes modal) latent trait estimates
#'   for each row in patterns.
#'
#'   In simple terms:
#'   this function applies score_tirt_pattern to every respondent, after first
#'   checking and aligning item columns so they match lambda row order.
#'
#' @param patterns A matrix or data.frame of response patterns
#'   (rows = respondents, columns = pair / items).
#' @param lambda Loading matrix (rows = pair / items, columns = latent traits).
#' @param theta_diag Numeric vector of residual variances aligned to
#'   rows of lambda.
#' @param tau Numeric vector of thresholds aligned to rows of lambda.
#' @param Psi Latent covariance matrix (traits x traits).
#' @param nu Optional numeric vector of indicator intercepts aligned to rows
#'   of lambda. If NULL, zeros are used in score_tirt_pattern.
#'
#' @return A numeric matrix of latent scores:
#'   rows correspond to respondents in patterns,
#'   columns correspond to traits in colnames(lambda).
#'
#' @details
#' Name alignment is the key safeguard:
#' if both rownames(lambda) and colnames(patterns) are present,
#' patterns is reordered to match lambda row order before scoring.
#'
#' If required lambda names are missing from patterns, the function stops
#' with an informative error. If names are unavailable, positional alignment
#' is assumed and a warning is issued.
#'
#' @keywords tirt irt scoring map ebm
#' @export
#' @examples
#' library(thurstonianIRT)
#' data("triplets")
#' # define the blocks of items
#' blocks <-
#'   set_block(c("i1", "i2", "i3"), traits = c("t1", "t2", "t3"),
#'             signs = c(1, 1, 1)) +
#'   set_block(c("i4", "i5", "i6"), traits = c("t1", "t2", "t3"),
#'             signs = c(-1, 1, 1)) +
#'   set_block(c("i7", "i8", "i9"), traits = c("t1", "t2", "t3"),
#'             signs = c(1, 1, -1)) +
#'   set_block(c("i10", "i11", "i12"), traits = c("t1", "t2", "t3"),
#'             signs = c(1, -1, 1))
#' # generate the data to be understood by 'thurstonianIRT'
#' triplets_long <- make_TIRT_data(
#'   data = triplets, blocks = blocks, direction = "larger",
#'   format = "pairwise", family = "bernoulli", range = c(0, 1)
#' )
#' # fit the data using lavaan
#' fit <- fit_TIRT_lavaan(triplets_long)
#' pars <- extract_tirt_params(fit)
#' patterns<-as.matrix(triplets)
#' score_tirt(patterns,lambda=pars$lambda,theta_diag=pars$theta_diag,
#'            tau=pars$tau,Psi=pars$Psi,nu=NULL)
#' # Check same scores from thurstonianIRT package
#' triplets_long <- make_TIRT_data(data = triplets,
#'                                 blocks = blocks, 
#'                                 direction = "larger",
#'                                 format = "pairwise", 
#'                                 family = "bernoulli", 
#'                                 range = c(0, 1))
#' scores_thurstonianIRT<-predict(fit)
#' scores<-score_tirt(patterns,lambda=pars$lambda,theta_diag=pars$theta_diag,
#'         tau=pars$tau,Psi=pars$Psi,nu=NULL)
#' head(reshape2::recast(scores_thurstonianIRT,formula=id~trait,id.var=1:2))
#' head(scores)
score_tirt<-function(patterns, lambda, theta_diag, tau, Psi, nu=NULL) {
  patterns<-as.matrix(patterns)
  
  # align columns to lambda rows by name -- the critical step
  if (is.null(rownames(lambda)) || is.null(colnames(patterns))) {
    warning("lambda rows or pattern columns are unnamed; assuming positional alignment.")
  } else {
    miss<-setdiff(rownames(lambda), colnames(patterns))
    if (length(miss) > 0) {
      stop("Pair names in lambda not found in patterns:\n  ",
           paste(miss, collapse=", "))
    }
    patterns<-patterns[, rownames(lambda), drop=FALSE]
  }
  
  scores<-t(apply(patterns,1,score_tirt_pattern,
                  lambda=lambda,
                  theta_diag=theta_diag,
                  tau=tau,
                  Psi=Psi,
                  nu=nu))
  colnames(scores)<-colnames(lambda)
  scores
}
##########################################################################################
# Diagnostic -- run this first if scores still don't match predict()
##########################################################################################
# tirt_diagnose<-function(fit_lavaan_obj, df_rank) {
#   est<-lavaan::lavInspect(fit_lavaan_obj$fit, "est")
#   cat("lambda rows  (first 5):", head(rownames(est$lambda), 5), "\n")
#   cat("Tau    rows  (first 5):", head(rownames(est$tau),    5), "\n")
#   cat("Theta  rows  (first 5):", head(rownames(est$theta),  5), "\n")
#   cat("df_rank cols (first 5):", head(colnames(df_rank),    5), "\n\n")
#   
#   same_lt<-identical(rownames(est$lambda),sub("\\|.*$", "",rownames(est$tau)))
#   same_lr<-identical(rownames(est$lambda),colnames(df_rank))
#   cat("lambda vs tau   row order identical:", same_lt, "\n")
#   cat("lambda vs df_rank col order identical:", same_lr, "\n")
#   
#   cat("\nFactor mean (alpha) present?", !is.null(est$alpha), "\n")
#   if (!is.null(est$alpha)) {
#     cat("alpha:\n"); print(as.numeric(est$alpha))
#   }
#   cat("Indicator intercept (nu) max abs:",
#       if (is.null(est$nu)) 0 else max(abs(as.numeric(est$nu))), "\n")
# }
##########################################################################################
# CHECK HEYWOOD CASES AND MODEL ISSUES
##########################################################################################
#' @title Check for Heywood Cases and Related SEM Estimation Problems
#' @description Screens a fitted lavaan model for common warning signs such as
#'   negative variances, impossible standardized values, unusually large
#'   standard errors, and convergence failure.
#'
#'   In simple terms:
#'   this is a quick model health check. It tells you whether your solution
#'   contains suspicious estimates that often indicate misspecification,
#'   weak identification, or numerical instability.
#'
#' @param fit_model A fitted lavaan model object (for example, from
#'   \code{lavaan::cfa()}, \code{lavaan::sem()}, or related wrappers).
#' @param verbose Logical. If \code{TRUE} (default), prints diagnostic sections
#'   and a summary to the console. If \code{FALSE}, only returns results.
#'
#' @return An invisible list with:
#' \itemize{
#'   \item \code{has_issues}: Logical, \code{TRUE} if any issue was detected.
#'   \item \code{issues}: Named list of detected issue tables / messages.
#'   \item \code{converged}: Logical convergence flag from
#'     \code{lavaan::lavInspect(fit_model, "converged")}.
#' }
#'
#' @details
#' The function checks:
#' \itemize{
#'   \item Negative variances (\code{~~} with \code{lhs == rhs} and estimate < 0).
#'   \item Negative residual variances in Thurstonian style parameters
#'     (\code{~*~} with estimate < 0).
#'   \item Standardized loadings outside [-1, 1].
#'   \item Standardized correlations outside [-1, 1].
#'   \item Extremely large standard errors (\code{se > 10}).
#'   \item Non-convergence.
#' }
#'
#' A Heywood case usually refers to impossible estimates like negative
#' variances or standardized loadings greater than 1 in absolute value.
#'
#' @keywords lavaan sem cfa diagnostics heywood
#' @export
#'
#' @examples
#' library(lavaan)
#'
#' # Example model
#' HS.model <- '
#'   visual  =~ x1 + x2 + x3
#'   textual =~ x4 + x5 + x6
#'   speed   =~ x7 + x8 + x9
#' '
#'
#' fit <- cfa(HS.model, data = HolzingerSwineford1939)
#'
#' # Verbose diagnostic output
#' chk <- check_heywood(fit, verbose = TRUE)
#'
#' # Programmatic use
#' check_heywood(fit, verbose = TRUE)
check_heywood<-function(fit_model,verbose=TRUE) {
  # Initialize results
  issues<-list()
  has_issues<-FALSE
  
  # Get parameter estimates
  params<-lavaan::parameterEstimates(fit_model)
  std<-lavaan::standardizedSolution(fit_model)
  
  # 1. Check for negative variances (standard lavaan)
  neg_var<-params[params$op == "~~" & params$lhs == params$rhs & params$est < 0,]
  if (nrow(neg_var) > 0) {
    issues$negative_variances<-neg_var
    has_issues<-TRUE
    if (verbose) {
      cat("\n=== NEGATIVE VARIANCES (~~) ===\n")
      print(neg_var[,c("lhs","op","rhs","est","se","pvalue")])
    }
  }
  
  # 2. Check for negative residual variances (Thurstonian ~*~)
  neg_resid<-params[params$op == "~*~" & params$est < 0,]
  if (nrow(neg_resid) > 0) {
    issues$negative_residuals<-neg_resid
    has_issues<-TRUE
    if (verbose) {
      cat("\n=== NEGATIVE RESIDUAL VARIANCES (~*~) ===\n")
      print(neg_resid[,c("lhs","op","rhs","est","se","pvalue")])
    }
  }
  
  # 3. Check for standardized loadings > 1 or < -1
  problem_loadings<-std[std$op == "=~" & abs(std$est.std) > 1,]
  if (nrow(problem_loadings) > 0) {
    issues$extreme_loadings<-problem_loadings
    has_issues<-TRUE
    if (verbose) {
      cat("\n=== STANDARDIZED LOADINGS > 1 ===\n")
      print(problem_loadings[,c("lhs","op","rhs","est.std","pvalue")])
    }
  }
  
  # 4. Check for correlations outside [-1,1]
  extreme_cors<-std[std$op == "~~" & std$lhs != std$rhs & abs(std$est.std) > 1,]
  if (nrow(extreme_cors) > 0) {
    issues$extreme_correlations<-extreme_cors
    has_issues<-TRUE
    if (verbose) {
      cat("\n=== CORRELATIONS OUTSIDE [-1,1] ===\n")
      print(extreme_cors[,c("lhs","op","rhs","est.std","pvalue")])
    }
  }
  
  # 5. Check for extreme standard errors (might indicate identification issues)
  extreme_se<-params[!is.na(params$se) & params$se > 10,]
  if (nrow(extreme_se) > 0) {
    issues$extreme_se<-extreme_se
    has_issues<-TRUE
    if (verbose) {
      cat("\n=== EXTREME STANDARD ERRORS (> 10) ===\n")
      print(extreme_se[,c("lhs","op","rhs","est","se","pvalue")])
    }
  }
  
  # 6. Check convergence
  converged<-lavaan::lavInspect(fit_model,"converged")
  if (!converged) {
    issues$convergence<-"Model did not converge"
    has_issues<-TRUE
    if (verbose) {
      cat("\n=== CONVERGENCE ISSUE ===\n")
      cat("Model did not converge properly!\n")
    }
  }
  
  # Summary
  if (verbose) {
    cat("\n=== SUMMARY ===\n")
    if (has_issues) {
      cat("\u26a0\ufe0f  Issues found:\n")
      if (!is.null(issues$negative_variances)) 
        cat(sprintf(" -%d negative variance(s) (~~)\n",nrow(issues$negative_variances)))
      if (!is.null(issues$negative_residuals)) 
        cat(sprintf(" -%d negative residual variance(s) (~*~)\n",nrow(issues$negative_residuals)))
      if (!is.null(issues$extreme_loadings)) 
        cat(sprintf(" -%d extreme standardized loading(s)\n",nrow(issues$extreme_loadings)))
      if (!is.null(issues$extreme_correlations)) 
        cat(sprintf(" -%d extreme correlation(s)\n",nrow(issues$extreme_correlations)))
      if (!is.null(issues$extreme_se)) 
        cat(sprintf(" -%d extreme standard error(s)\n",nrow(issues$extreme_se)))
      if (!is.null(issues$convergence)) 
        cat(" -Convergence issue\n")
    } else {
      cat("\u2713 No Heywood cases or major issues detected!\n")
    }
  }
  
  # Return issues list invisibly
  invisible(list(
    has_issues=has_issues,
    issues=issues,
    converged=converged
  ))
}




