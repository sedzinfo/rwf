##########################################################################################
# RESPONSE PROBABILITIES
##########################################################################################
#' @title compute category response probabilities and derivatives under the graded response model
#' @description returns the category response probabilities for a given ability value and a \cr
#'              given matrix of item parameters under Samejima graded response model (GRM) \cr
#'              returns the first derivatives of the category response probabilities
#' @param theta ability
#' @param bank item parameters one row per item \cr
#'             column 1 holds the item discrimination alpha_j \cr
#'             columns 2 to ncat hold the item thresholds beta_j1 to beta_jm \cr
#'             both the discrimination and the thresholds are item specific \cr
#'             a graded model whose thresholds have the same spacing for every item so \cr
#'             that beta_jk=b_j-c_k with c_k common to the items is the \cr
#'             modified graded response model of cat_eap_ggrm.R \cr
#'             the thresholds of an item must be strictly increasing \cr
#'             two equal thresholds leave a category with probability zero so a response \cr
#'             there makes the EAP NaN and a decreasing pair makes a probability negative \cr
#'             an item with fewer categories than the widest item is padded with NA \cr
#'             a mirt model fitted with itemtype="graded" gives the bank with \cr
#'             mirt::coef(model,IRTpars=TRUE,simplify=TRUE)$items to be used with D=1
#' @param D metric constant can be 1 or 1.702
#' @note this function should return the same result as catR::Pi(model="GRM") \cr
#'       the number of response categories is ncol(bank) so a 5 point Likert scale \cr
#'       scored 0 1 2 3 4 needs a bank with 5 columns \cr
#'       the model works in two steps \cr
#'       first the cumulative probability of responding in category k or above is a 2PL \cr
#'       curve with the item discrimination and the threshold beta_jk \cr
#'       Pstar_jk=P(X>=k|theta)=exp(D*alpha_j*(theta-beta_jk))/(1+exp(D*alpha_j*(theta-beta_jk))) \cr
#'       with Pstar_j0=1 and Pstar_j(m+1)=0 \cr
#'       then the probability of category k is the difference of two adjacent curves \cr
#'       P(X=k|theta)=Pstar_jk-Pstar_j(k+1) \cr
#'       this is a cumulative model while the rating scale and the partial credit models \cr
#'       compare adjacent categories and divide by a total \cr
#'       the derivative of a 2PL curve is D*alpha_j*Pstar_jk*(1-Pstar_jk) so the \cr
#'       derivative of a category is the same difference of two adjacent derivatives \cr
#'       when theta is far above the thresholds both cumulative curves are close to 1 \cr
#'       and their difference loses precision so probabilities below about 1e-11 are \cr
#'       inaccurate and below about 1e-16 they are rounding noise that is 0 or a \cr
#'       multiple of 1.1e-16 and can even be slightly negative \cr
#'       catR computes them the same way and only response patterns that contradict \cr
#'       theta strongly on very discriminating items are affected
#' @return Pi   category response probabilities one row per item one column per category \cr
#'         dPi  first derivatives of the category response probabilities
#' @export
#' @examples
#' bank<-matrix(c(1.227,0.845,1.694,1.012,2.103,
#'                -2.183,-1.542,-1.021,-2.460,-0.812,
#'                -0.874,-0.415,-0.231,-1.105,0.094,
#'                0.316,0.783,0.652,0.047,0.881,
#'                1.592,2.064,1.438,1.271,1.736),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alphaj","betaj1","betaj2","betaj3","betaj4")))
#' catR::Pi(th=0,bank,model="GRM") # this will work with catR package installed
#' Pi_grm(theta=0,bank)
#' v<-seq(-6,6,by=.1)
#' y_axis_response_probability<-list()
#' for(i in v) y_axis_response_probability[[toString(i)]]<-Pi_grm(theta=i,bank)$Pi[1,]
#' df_rp<-data.frame(x=v,
#'                   matrix(unlist(y_axis_response_probability),
#'                          nrow=length(y_axis_response_probability),byrow=TRUE))
#' plot(x=df_rp$x,y=df_rp$X1,xlab=expression(theta),ylab=expression(P(theta)),
#'      main="category response probabilities item 1",type="l",col="red",ylim=c(0,1))
#' lines(y=df_rp$X2,x=v,col="green")
#' lines(y=df_rp$X3,x=v,col="blue")
#' lines(y=df_rp$X4,x=v,col="yellow")
#' lines(y=df_rp$X5,x=v,col="orange")
#' # the cumulative curves Pstar_jk=P(X>=k) are the sums of the category probabilities from k up
#' plot(x=v,y=rowSums(df_rp[,3:6]),xlab=expression(theta),ylab=expression(P^"*"*(theta)),
#'      main="cumulative response probabilities item 1",type="l",col="green",ylim=c(0,1))
#' lines(y=rowSums(df_rp[,4:6]),x=v,col="blue")
#' lines(y=rowSums(df_rp[,5:6]),x=v,col="yellow")
#' lines(y=df_rp$X5,x=v,col="orange")
Pi_grm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  ncat<-ncol(bank)
  Pi<-dPi<-matrix(NA,nrow(bank),ncat)
  for (i in 1:nrow(bank)) {
    aj<-bank[i,1]
    bj<-bank[i,2:ncat]
    bj<-bj[!is.na(bj)]
    ej<-exp(D*aj*(theta-bj))
    Pjs<-c(1,ej/(1+ej),0)
    dPjs<-D*aj*Pjs*(1-Pjs)
    n<-length(Pjs)
    Pi[i,1:(n-1)]<-Pjs[1:(n-1)]-Pjs[2:n]
    dPi[i,1:(n-1)]<-dPjs[1:(n-1)]-dPjs[2:n]
  }
  colnames(Pi)<-colnames(dPi)<-paste("cat",0:(ncat-1),sep="")
  rownames(Pi)<-rownames(dPi)<-paste("Item",1:nrow(bank),sep="")
  result<-list(Pi=Pi,dPi=dPi)
  return(result)
}
##########################################################################################
# ITEM INFORMATION
##########################################################################################
#' @title compute item information under the graded response model
#' @param theta ability
#' @param bank matrix of item parameters
#' @param D metric constant can be 1 or 1.702
#' @note this function should return the same result as catR::Ii(model="GRM") \cr
#'       the polytomous item information is the sum over categories of the squared \cr
#'       first derivative divided by the probability \cr
#'       I_j(theta)=sum_k (dP_jk/dtheta)^2/P_jk \cr
#'       an item with a single threshold is a 2PL item and the sum collapses to \cr
#'       D^2*alpha_j^2*P_j1*(1-P_j1) \cr
#'       under the graded response model every item has its own discrimination and \cr
#'       thresholds so the information curves differ in height and in shape \cr
#'       the height grows roughly with alpha_j^2 and exactly only for a single threshold \cr
#'       a larger alpha_j also narrows the curve around each threshold \cr
#'       widely spaced thresholds spread the information over a wider range of theta \cr
#'       and when the spacing is large compared with 1/alpha_j the curve shows one bump \cr
#'       per threshold \cr
#'       test information is the sum of the item informations
#' @return Ii item information for each item
#' @export
#' @examples
#' bank<-matrix(c(1.227,0.845,1.694,1.012,2.103,
#'                -2.183,-1.542,-1.021,-2.460,-0.812,
#'                -0.874,-0.415,-0.231,-1.105,0.094,
#'                0.316,0.783,0.652,0.047,0.881,
#'                1.592,2.064,1.438,1.271,1.736),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alphaj","betaj1","betaj2","betaj3","betaj4")))
#' catR::Ii(th=0,bank,model="GRM") # this will work with catR package installed
#' Ii_grm(theta=0,bank)
#' sum(Ii_grm(theta=0,bank)$Ii) # test information
#' v<-seq(-4,4,by=.1)
#' info<-matrix(NA,length(v),nrow(bank))
#' for (i in 1:length(v)) info[i,]<-Ii_grm(theta=v[i],bank)$Ii
#' plot(x=v,y=info[,1],xlab=expression(theta),ylab="information",
#'      main="item information curves",type="l",col="red",ylim=c(0,max(info)))
#' lines(y=info[,2],x=v,col="green")
#' lines(y=info[,3],x=v,col="blue")
#' lines(y=info[,4],x=v,col="yellow")
#' lines(y=info[,5],x=v,col="orange")
#' plot(x=v,y=rowSums(info),xlab=expression(theta),ylab="information",
#'      main="test information",type="l")
Ii_grm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  prob<-Pi_grm(theta,bank,D=D)
  P<-prob$Pi
  dP<-prob$dPi
  Ii<-as.numeric(rowSums(dP^2/P,na.rm=TRUE))
  result<-list(Ii=Ii)
  return(result)
}
##########################################################################################
# NEXT ITEM SELECTION
##########################################################################################
#' @title select the next item by maximum Fisher information
#' @param theta current ability estimate
#' @param bank matrix of item parameters
#' @param out vector of the indices of the items already administered
#' @param D metric constant can be 1 or 1.702
#' @param randomesque number of most informative items to draw at random from \cr
#'                    1 is pure maximum information and 3 to 5 spreads item exposure
#' @note this function should return the same result as \cr
#'       catR::nextItem(itemBank,model="GRM",theta,out,criterion="MFI") when \cr
#'       randomesque is 1 and the most informative item is unique \cr
#'       when several items tie exactly catR draws one of them at random while this \cr
#'       function takes the first \cr
#'       with randomesque above 1 catR also keeps every item tied with the last one kept \cr
#'       so it can draw from more than randomesque items \cr
#'       under the graded response model there is no nearest neighbour shortcut because \cr
#'       the information curves differ in height and shape so the information of every \cr
#'       available item has to be computed at theta \cr
#'       an item with a large alpha_j whose thresholds cover the current theta wins most \cr
#'       of the comparisons and is used far more often than the rest of the bank which \cr
#'       is why randomesque matters more here than under the rating scale model
#' @return item  index of the selected item in the bank \cr
#'         info  information of the selected item at theta \cr
#'         available indices of the items still available
#' @export
#' @examples
#' bank<-matrix(c(1.227,0.845,1.694,1.012,2.103,
#'                -2.183,-1.542,-1.021,-2.460,-0.812,
#'                -0.874,-0.415,-0.231,-1.105,0.094,
#'                0.316,0.783,0.652,0.047,0.881,
#'                1.592,2.064,1.438,1.271,1.736),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alphaj","betaj1","betaj2","betaj3","betaj4")))
#' catR::nextItem(bank,model="GRM",theta=0,criterion="MFI") # with catR installed
#' next_item_grm(theta=0,bank)
#' next_item_grm(theta=0,bank,out=c(5))
#' catR::nextItem(bank,model="GRM",theta=-2.5,criterion="MFI") # with catR installed
#' next_item_grm(theta=-2.5,bank)
#' # a short adaptive test driven by the functions in this file
#' responses<-c()
#' administered<-c()
#' theta<-0
#' for (step in 1:4) {
#'   item<-next_item_grm(theta,bank,out=administered)$item
#'   administered<-c(administered,item)
#'   responses<-c(responses,3) # replace by the real response scored 0 to m
#'   theta<-eap_est_grm(bank[administered,,drop=FALSE],responses)
#'   cat("step",step,"item",item,"theta",round(theta,4),
#'       "se",round(eap_se_grm(theta,bank[administered,,drop=FALSE],responses),4),"\n")
#' }
next_item_grm<-function(theta,bank,out=NULL,D=1,randomesque=1) {
  bank<-rbind(bank)
  available<-setdiff(1:nrow(bank),out)
  if (length(available)==0) stop("no item left in the bank",call.=FALSE)
  info<-Ii_grm(theta,bank[available,,drop=FALSE],D=D)$Ii
  k<-max(1,min(floor(randomesque),length(available)))
  top<-order(info,decreasing=TRUE)[1:k]
  pick<-if (k==1) top else top[sample.int(k,1)]
  result<-list(item=available[pick],info=info[pick],available=available)
  return(result)
}
##########################################################################################
# LIKELIHOOD
##########################################################################################
#' @title compute the likelihood of a polytomous response pattern
#' @param theta ability
#' @param bank matrix of item parameters
#' @param x vector of item responses scored 0 to m
#' @param D metric constant can be 1 or 1.702
#' @note this is the polytomous counterpart of prod(Pi^x*(1-Pi)^(1-x)) used for the 4PL \cr
#'       model \cr
#'       Pi_grm returns a matrix so the response of item i selects the column x[i]+1 \cr
#'       the +1 is index bookkeeping because categories start at 0 and R columns start \cr
#'       at 1 \cr
#'       the probabilities of the observed responses are multiplied across items under \cr
#'       the local independence assumption
#' @export
#' @examples
#' bank<-matrix(c(1.227,0.845,1.694,1.012,2.103,
#'                -2.183,-1.542,-1.021,-2.460,-0.812,
#'                -0.874,-0.415,-0.231,-1.105,0.094,
#'                0.316,0.783,0.652,0.047,0.881,
#'                1.592,2.064,1.438,1.271,1.736),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alphaj","betaj1","betaj2","betaj3","betaj4")))
#' response<-c(4,3,2,1,0)
#' likelihood_grm(theta=0,bank=bank,x=response)
#' v<-seq(-4,4,by=.1)
#' lik<-c()
#' for (i in 1:length(v)) lik[i]<-likelihood_grm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=lik,xlab=expression(theta),ylab="likelihood",
#'      main="likelihood of the response pattern",type="l")
likelihood_grm<-function(theta,bank,x,D=1) {
  prob<-Pi_grm(theta,bank,D=D)$Pi
  result<-1
  for (i in 1:length(x)) result<-result*prob[i,x[i]+1]
  return(result)
}
##########################################################################################
# EAP ESTIMATION
##########################################################################################
#' @title compute theta EAP estimation under the graded response model
#' @param bank matrix of item parameters
#' @param x vector of item responses scored 0 to m
#' @param D metric constant can be 1 or 1.702
#' @param priorPar mean and sd for normal distribution default is mean 0 and sd 1
#' @param lower lower bound for numerical integration
#' @param upper upper bound for numerical integration
#' @param nqp number of quadrature points
#' @note this function should return the same result as catR::eapEst(model="GRM")
#' @export
#' @examples
#' bank<-matrix(c(1.227,0.845,1.694,1.012,2.103,
#'                -2.183,-1.542,-1.021,-2.460,-0.812,
#'                -0.874,-0.415,-0.231,-1.105,0.094,
#'                0.316,0.783,0.652,0.047,0.881,
#'                1.592,2.064,1.438,1.271,1.736),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alphaj","betaj1","betaj2","betaj3","betaj4")))
#' response<-c(4,3,2,1,0)
#' catR::eapEst(bank,response,model="GRM") # this will work with catR package installed
#' eap_est_grm(bank,response)
eap_est_grm<-function (bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-s[i]*density_function(s[i],priorPar[1],priorPar[2])*likelihood_grm(s[i],bank,x,D=D)
    return(res)
  }
  h<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-density_function(s[i],priorPar[1],priorPar[2])*likelihood_grm(s[i],bank,x,D=D)
    return(res)
  }
  X<-seq(from=lower,to=upper,length=nqp)
  Y1<-g(X)
  Y2<-h(X)
  result<-integrate_cat(X,Y1)/integrate_cat(X,Y2)
  return(result)
}
##########################################################################################
# STANDARD ERROR ESTIMATION
##########################################################################################
#' @title compute standard error of theta EAP estimation under the graded response model
#' @param theta theta estimation
#' @param bank matrix of item parameters
#' @param x vector of item responses scored 0 to m
#' @param D metric constant can be 1 or 1.702
#' @param priorPar mean and sd for normal distribution default is mean 0 and sd 1
#' @param lower lower bound for numerical integration
#' @param upper upper bound for numerical integration
#' @param nqp number of quadrature points
#' @note this function should return the same result as catR::eapSem(model="GRM") \cr
#'       pass the EAP estimate as theta to obtain the posterior standard deviation \cr
#'       any other value returns the posterior root mean squared deviation around it \cr
#'       so the curve is minimised at the EAP estimate
#' @export
#' @examples
#' bank<-matrix(c(1.227,0.845,1.694,1.012,2.103,
#'                -2.183,-1.542,-1.021,-2.460,-0.812,
#'                -0.874,-0.415,-0.231,-1.105,0.094,
#'                0.316,0.783,0.652,0.047,0.881,
#'                1.592,2.064,1.438,1.271,1.736),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alphaj","betaj1","betaj2","betaj3","betaj4")))
#' response<-c(4,3,2,1,0)
#' catR::eapSem(0,bank,response,model="GRM") # this will work with catR package installed
#' eap_se_grm(theta=0,bank=bank,x=response)
#' v<-seq(-3,3,by=.1)
#' se<-c()
#' for (i in 1:length(v)) se[i]<-eap_se_grm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error with a mixed response pattern")
#' response<-c(0,0,0,0,0)
#' for (i in 1:length(v)) se[i]<-eap_se_grm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error when all responses are in the lowest category")
#' response<-c(4,4,4,4,4)
#' for (i in 1:length(v)) se[i]<-eap_se_grm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error when all responses are in the highest category")
eap_se_grm<-function(theta,bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-(X[i]-theta)^2*density_function(X[i],priorPar[1],priorPar[2])*likelihood_grm(X[i],bank,x,D=D)
    return(res)
  }
  h<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-density_function(X[i],priorPar[1],priorPar[2])*likelihood_grm(X[i],bank,x,D=D)
    return(res)
  }
  X<-seq(from=lower,to=upper,length=nqp)
  Y1<-g(X)
  Y2<-h(X)
  result<-sqrt(integrate_cat(X,Y1)/integrate_cat(X,Y2))
  return(result)
}
##########################################################################################
# EXAMPLES
##########################################################################################
# https://dimitrios.shinyapps.io/mleirt/ check the EAP-MAP Rasch tab to see the effect of prior parameters and quadratures on estimation
# https://dimitrios.shinyapps.io/modelsirt/ check the GRM tab to see the ability response probability curve
##########################################################################################
# EXAMPLE 1
##########################################################################################
# 5 point Likert scale scored 0 1 2 3 4
# alphaj and betaj1 to betaj4 are all item specific
alphaj<-c(1.227,0.845,1.694,1.012,2.103)
betaj1<-c(-2.183,-1.542,-1.021,-2.460,-0.812)
betaj2<-c(-0.874,-0.415,-0.231,-1.105,0.094)
betaj3<-c(0.316,0.783,0.652,0.047,0.881)
betaj4<-c(1.592,2.064,1.438,1.271,1.736)
bank<-matrix(c(alphaj,betaj1,betaj2,betaj3,betaj4),nrow=5,
             dimnames=list(c(1,2,3,4,5),c("alphaj","betaj1","betaj2","betaj3","betaj4")))
response_1<-c(0,0,0,0,0)
response_2<-c(1,1,1,1,1)
response_3<-c(2,2,2,2,2)
response_4<-c(3,3,3,3,3)
response_5<-c(4,4,4,4,4)
# ABILITY ESTIMATION
eap_est_grm(bank,response_1)
catR::eapEst(bank,response_1,model="GRM")
eap_est_grm(bank,response_2)
catR::eapEst(bank,response_2,model="GRM")
eap_est_grm(bank,response_3)
catR::eapEst(bank,response_3,model="GRM")
eap_est_grm(bank,response_4)
catR::eapEst(bank,response_4,model="GRM")
eap_est_grm(bank,response_5)
catR::eapEst(bank,response_5,model="GRM")
# STANDARD ERROR ESTIMATION
eap_se_grm(eap_est_grm(bank,response_1),bank,response_1)
catR::eapSem(eap_est_grm(bank,response_1),bank,response_1,model="GRM")
eap_se_grm(eap_est_grm(bank,response_2),bank,response_2)
catR::eapSem(eap_est_grm(bank,response_2),bank,response_2,model="GRM")
eap_se_grm(eap_est_grm(bank,response_3),bank,response_3)
catR::eapSem(eap_est_grm(bank,response_3),bank,response_3,model="GRM")
eap_se_grm(eap_est_grm(bank,response_4),bank,response_4)
catR::eapSem(eap_est_grm(bank,response_4),bank,response_4,model="GRM")
eap_se_grm(eap_est_grm(bank,response_5),bank,response_5)
catR::eapSem(eap_est_grm(bank,response_5),bank,response_5,model="GRM")
##########################################################################################
# EXAMPLE 2
##########################################################################################
# effect of the integration bounds and of the number of quadrature points
response_1<-c(4,4,4,4,4)
eap_est_grm(bank,response_1,lower=-4,upper=4)
eap_est_grm(bank,response_1,lower=-3,upper=3)
eap_est_grm(bank,response_1,nqp=33)
eap_est_grm(bank,response_1,nqp=101)
# effect of the prior
eap_est_grm(bank,response_1,priorPar=c(0,1))
eap_est_grm(bank,response_1,priorPar=c(0,2))
# effect of the metric constant
eap_est_grm(bank,response_1,D=1)
eap_est_grm(bank,response_1,D=1.702)
# effect of the discrimination
# the same thresholds with every alphaj doubled give a smaller standard error
response_1<-c(3,2,3,2,3)
bank_2<-bank
bank_2[,1]<-2*bank[,1]
eap_se_grm(eap_est_grm(bank,response_1),bank,response_1)
eap_se_grm(eap_est_grm(bank_2,response_1),bank_2,response_1)
##########################################################################################
# EXAMPLE 3
##########################################################################################
# items do not all need the same number of categories
# item 5 below is a 4 point item so its last threshold is padded with NA
# its responses must then be scored 0 to 3
bank<-matrix(c(alphaj,betaj1,betaj2,betaj3,c(betaj4[1:4],NA)),nrow=5,
             dimnames=list(c(1,2,3,4,5),c("alphaj","betaj1","betaj2","betaj3","betaj4")))
Pi_grm(theta=0,bank)$Pi
response_1<-c(4,3,2,1,3)
eap_est_grm(bank,response_1)
eap_se_grm(eap_est_grm(bank,response_1),bank,response_1)
# an item with a single threshold is a 2PL item
# the probability of category 1 is the 2PL probability of a correct response
bank<-matrix(c(alphaj,betaj1),nrow=5,dimnames=list(c(1,2,3,4,5),c("alphaj","betaj1")))
Pi_grm(theta=0,bank)$Pi[,2]
catR::Pi(th=0,cbind(alphaj,betaj1,0,1))$Pi

