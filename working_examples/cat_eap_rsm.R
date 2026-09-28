##########################################################################################
# CATR ACKNOWLEDGEMENT
##########################################################################################
# the response probability item information likelihood and EAP functions in this file
# are adapted from the source code of the catR package version 3.17 by David Magis
# Gilles Raiche and Juan Ramon Barrada and the item selection follows catR::nextItem
# with criterion="MFI"
# https://CRAN.R-project.org/package=catR
# Magis D and Raiche G (2012) Journal of Statistical Software 48(8) 1-31
# doi:10.18637/jss.v048.i08
# Magis D and Barrada JR (2017) Journal of Statistical Software Code Snippets 76(1) 1-19
# doi:10.18637/jss.v076.c01
# catR is licensed under GPL (>= 3) and this file is distributed under the same license
# modified by Dimitrios Zacharatos 2026 split into one file per model with the
# functions renamed rewritten for readability and documented
##########################################################################################
# RESPONSE PROBABILITIES
##########################################################################################
#' @title compute category response probabilities and derivatives under the rating scale model
#' @description returns the category response probabilities for a given ability value and a \cr
#'              given matrix of item parameters under Andrich rating scale model (RSM) \cr
#'              returns the first second and third derivatives of the category response \cr
#'              probabilities
#' @param theta ability
#' @param bank item parameters one row per item \cr
#'             column 1 holds the item location lambda_j \cr
#'             columns 2 to ncat hold the category thresholds delta_1 to delta_m \cr
#'             the thresholds are common to all items so those columns are identical \cr
#'             in every row which is what makes this the rating scale and not the \cr
#'             partial credit model \cr
#'             an item with fewer categories than the widest item is padded with NA
#' @param D metric constant can be 1 or 1.702
#' @note this function should return the same result as catR::Pi(model="RSM") \cr
#'       the number of response categories is ncol(bank) so a 5 point Likert scale \cr
#'       scored 0 1 2 3 4 needs a bank with 5 columns \cr
#'       the probability of category k is \cr
#'       P(X=k|theta)=exp(sum_t=1^k D*(theta-(lambda_j+delta_t)))/sum over all categories \cr
#'       with the empty sum for category 0 equal to zero
#' @return Pi   category response probabilities one row per item one column per category \cr
#'         dPi  first derivatives of the category response probabilities \cr
#'         d2Pi second derivatives of the category response probabilities \cr
#'         d3Pi third derivatives of the category response probabilities
#' @export
#' @examples
#' bank<-matrix(c(-0.560,-0.230,1.559,0.071,0.129,
#'                rep(1.715,5),rep(0.461,5),rep(-1.265,5),rep(-0.687,5)),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("lambdaj","delta1","delta2","delta3","delta4")))
#' pi_cat<-catR::Pi(th=0,bank,model="RSM")
#' pi<-compute_pi_rsm(theta=0,bank)
#' pi_cat
#' pi
#' isTRUE(all.equal(pi_cat[[1]], pi[[1]]))
#' isTRUE(all.equal(pi_cat[[2]], pi[[2]]))
#' isTRUE(all.equal(pi_cat[[3]], pi[[3]]))
#' isTRUE(all.equal(pi_cat[[4]], pi[[4]]))
compute_pi_rsm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  ncat<-ncol(bank)
  Pi<-dPi<-d2Pi<-d3Pi<-matrix(NA,nrow(bank),ncat)
  for (i in 1:nrow(bank)) {
    dj<-v<-0
    for (t in 1:(ncat-1)) {
      dj<-c(dj,dj[t]+D*(theta-(bank[i,1]+bank[i,t+1])))
      v<-c(v,t)
    }
    v<-v[!is.na(dj)]
    dj<-dj[!is.na(dj)]
    gamma<-exp(dj)
    dgamma<-gamma*v
    d2gamma<-gamma*v^2
    d3gamma<-gamma*v^3
    sum_gamma<-sum(gamma)
    sum_dgamma<-sum(dgamma)
    sum_d2gamma<-sum(d2gamma)
    sum_d3gamma<-sum(d3gamma)
    n<-length(gamma)
    Pi[i,1:n]<-gamma/sum_gamma
    dPi[i,1:n]<-dgamma/sum_gamma-gamma*sum_dgamma/sum_gamma^2
    d2Pi[i,1:n]<-d2gamma/sum_gamma-2*dgamma*sum_dgamma/sum_gamma^2-
      gamma*sum_d2gamma/sum_gamma^2+2*gamma*sum_dgamma^2/sum_gamma^3
    d3Pi[i,1:n]<-d3gamma/sum_gamma-
      (gamma*sum_d3gamma+3*dgamma*sum_d2gamma+3*d2gamma*sum_dgamma)/sum_gamma^2+
      (6*gamma*sum_dgamma*sum_d2gamma+6*dgamma*sum_dgamma^2)/sum_gamma^3-
      6*gamma*sum_dgamma^3/sum_gamma^4
  }
  colnames(Pi)<-colnames(dPi)<-colnames(d2Pi)<-colnames(d3Pi)<-paste("cat",0:(ncat-1),sep="")
  rownames(Pi)<-rownames(dPi)<-rownames(d2Pi)<-rownames(d3Pi)<-paste("Item",1:nrow(bank),sep="")
  result<-list(Pi=Pi,dPi=dPi,d2Pi=d2Pi,d3Pi=d3Pi)
  return(result)
}
##########################################################################################
# ITEM INFORMATION
##########################################################################################
#' @title compute item information under the rating scale model
#' @param theta ability
#' @param bank matrix of item parameters
#' @param D metric constant can be 1 or 1.702
#' @note this function should return the same result as catR::Ii(model="RSM") \cr
#'       the polytomous item information is the sum over categories of the squared \cr
#'       first derivative divided by the probability \cr
#'       I_j(theta)=sum_k (dP_jk/dtheta)^2/P_jk \cr
#'       for a dichotomous item the two categories are P and 1-P with derivatives \cr
#'       dP and -dP so the sum collapses to dP^2/P+dP^2/(1-P)=dP^2/(P*(1-P)) which is \cr
#'       the familiar 4PL formula so this is the same quantity not a different one \cr
#'       under the rating scale model every item shares the same delta thresholds so \cr
#'       every information curve has the same shape and the same maximum and differs \cr
#'       only by a shift of lambdaj \cr
#'       test information is the sum of the item informations \cr
#'       dIi and d2Ii are the first and second derivatives of the item information \cr
#'       with respect to theta obtained by differentiating each category term \cr
#'       dP_jk^2/P_jk and summing over categories \cr
#'       dIi=sum_k 2*dP*d2P/P-dP^3/P^2 \cr
#'       d2Ii=sum_k (2*d2P^2+2*dP*d3P)/P-5*dP^2*d2P/P^2+2*dP^4/P^3
#' @return Ii   item information for each item \cr
#'         dIi  first derivative of the item information for each item \cr
#'         d2Ii second derivative of the item information for each item
#' @export
#' @examples
#' bank<-matrix(c(-0.560,-0.230,1.559,0.071,0.129,
#'                rep(1.715,5),rep(0.461,5),rep(-1.265,5),rep(-0.687,5)),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("lambdaj","delta1","delta2","delta3","delta4")))
#' li_catr<-catR::Ii(th=0,bank,model="RSM")
#' li<-compute_ii_rsm(theta=0,bank)
#' data.frame(catr=li_catr[[1]],li=li[[1]],equal=li_catr[[1]]==li[[1]])
#' data.frame(catr=li_catr[[2]],li=li[[2]],equal=li_catr[[2]]==li[[2]])
#' data.frame(catr=li_catr[[3]],li=li[[3]],equal=li_catr[[3]]==li[[3]])
compute_ii_rsm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  prob<-compute_pi_rsm(theta,bank,D=D)
  P<-prob$Pi
  dP<-prob$dPi
  d2P<-prob$d2Pi
  d3P<-prob$d3Pi
  Ii<-as.numeric(rowSums(dP^2/P,na.rm=TRUE))
  dIi<-as.numeric(rowSums(2*dP*d2P/P-dP^3/P^2,na.rm=TRUE))
  d2Ii<-as.numeric(rowSums((2*d2P^2+2*dP*d3P)/P-5*dP^2*d2P/P^2+2*dP^4/P^3,na.rm=TRUE))
  result<-list(Ii=Ii,dIi=dIi,d2Ii=d2Ii)
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
#'       catR::nextItem(itemBank,model="RSM",theta,out,criterion="MFI") when \cr
#'       randomesque is 1 \cr
#'       under the rating scale model this is equivalent to picking the item whose \cr
#'       lambdaj sits closest to theta because all information curves are identical \cr
#'       in shape so the maximum is a pure nearest neighbour lookup on lambdaj
#' @return item  index of the selected item in the bank \cr
#'         info  information of the selected item at theta \cr
#'         available indices of the items still available
#' @export
#' @examples
#' bank<-matrix(c(-0.560,-0.230,1.559,0.071,0.129,
#'                rep(1.715,5),rep(0.461,5),rep(-1.265,5),rep(-0.687,5)),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("lambdaj","delta1","delta2","delta3","delta4")))
#' catR::nextItem(bank,model="RSM",theta=0,criterion="MFI") # with catR installed
#' compute_next_item_rsm(theta=0,bank)
compute_next_item_rsm<-function(theta,bank,out=NULL,D=1,randomesque=1) {
  bank<-rbind(bank)
  available<-setdiff(1:nrow(bank),out)
  if (length(available)==0) stop("no item left in the bank",call.=FALSE)
  info<-compute_ii_rsm(theta,bank[available,,drop=FALSE],D=D)$Ii
  k<-min(randomesque,length(available))
  top<-order(info,decreasing=TRUE)[1:k]
  pick<-if (k==1) top else sample(top,1)
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
#'       compute_pi_rsm returns a matrix so the response of item i selects the column x[i]+1 \cr
#'       the +1 is index bookkeeping because categories start at 0 and R columns start \cr
#'       at 1 \cr
#'       the responses are multiplied across items under the local independence assumption
#' @export
#' @examples
#' bank<-matrix(c(-0.560,-0.230,1.559,0.071,0.129,
#'                rep(1.715,5),rep(0.461,5),rep(-1.265,5),rep(-0.687,5)),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("lambdaj","delta1","delta2","delta3","delta4")))
#' response<-c(4,3,2,1,0)
#' compute_likelihood_rsm(theta=0,bank=bank,x=response)
compute_likelihood_rsm<-function(theta,bank,x,D=1) {
  prob<-compute_pi_rsm(theta,bank,D=D)$Pi
  result<-1
  for (i in 1:length(x)) result<-result*prob[i,x[i]+1]
  return(result)
}
##########################################################################################
# EAP ESTIMATION
##########################################################################################
#' @title compute theta EAP estimation under the rating scale model
#' @param bank matrix of item parameters
#' @param x vector of item responses scored 0 to m
#' @param D metric constant can be 1 or 1.702
#' @param priorPar mean and sd for normal distribution default is mean 0 and sd 1
#' @param lower lower bound for numerical integration
#' @param upper upper bound for numerical integration
#' @param nqp number of quadrature points
#' @note this function should return the same result as catR::eapEst(model="RSM")
#' @export
#' @examples
#' bank<-matrix(c(-0.560,-0.230,1.559,0.071,0.129,
#'                rep(1.715,5),rep(0.461,5),rep(-1.265,5),rep(-0.687,5)),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("lambdaj","delta1","delta2","delta3","delta4")))
#' response<-c(4,3,2,1,0)
#' catR::eapEst(bank,response,model="RSM")
#' compute_eap_rsm(bank=bank,x=response)
compute_eap_rsm<-function (bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-s[i]*density_function(s[i],priorPar[1],priorPar[2])*compute_likelihood_rsm(s[i],bank,x,D=D)
    return(res)
  }
  h<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-density_function(s[i],priorPar[1],priorPar[2])*compute_likelihood_rsm(s[i],bank,x,D=D)
    return(res)
  }
  X<-seq(from=lower,to=upper,length=nqp)
  Y1<-g(s=X)
  Y2<-h(s=X)
  result<-integrate_cat(X,Y1)/integrate_cat(X,Y2)
  return(result)
}
##########################################################################################
# STANDARD ERROR ESTIMATION
##########################################################################################
#' @title compute standard error of theta EAP estimation under the rating scale model
#' @param theta theta estimation
#' @param bank matrix of item parameters
#' @param x vector of item responses scored 0 to m
#' @param D metric constant can be 1 or 1.702
#' @param priorPar mean and sd for normal distribution default is mean 0 and sd 1
#' @param lower lower bound for numerical integration
#' @param upper upper bound for numerical integration
#' @param nqp number of quadrature points
#' @note this function should return the same result as catR::eapSem(model="RSM") \cr
#'       pass the EAP estimate as theta to obtain the posterior standard deviation \cr
#'       any other value returns the posterior root mean squared deviation around it \cr
#'       so the curve is minimised at the EAP estimate
#' @export
#' @examples
#' bank<-matrix(c(-0.560,-0.230,1.559,0.071,0.129,
#'                rep(1.715,5),rep(0.461,5),rep(-1.265,5),rep(-0.687,5)),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("lambdaj","delta1","delta2","delta3","delta4")))
#' response<-c(4,3,2,1,0)
#' catR::eapSem(0,bank,response,model="RSM")
#' compute_eap_se_rsm(theta=0,bank=bank,x=response)
compute_eap_se_rsm<-function(theta,bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-(X[i]-theta)^2*density_function(X[i],priorPar[1],priorPar[2])*compute_likelihood_rsm(X[i],bank,x,D=D)
    return(res)
  }
  h<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-density_function(X[i],priorPar[1],priorPar[2])*compute_likelihood_rsm(X[i],bank,x,D=D)
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
# https://dimitrios.shinyapps.io/modelsirt/ check the RSM tab to see the ability response probability curve
##########################################################################################
# EXAMPLE 1
##########################################################################################
# # 5 point Likert scale scored 0 1 2 3 4
# # lambdaj is item specific and delta1 to delta4 are common to all items
# lambdaj<-c(-0.560,-0.230,1.559,0.071,0.129)
# delta1<-rep(1.715,5)
# delta2<-rep(0.461,5)
# delta3<-rep(-1.265,5)
# delta4<-rep(-0.687,5)
# bank<-matrix(c(lambdaj,delta1,delta2,delta3,delta4),nrow=5,
#              dimnames=list(c(1,2,3,4,5),c("lambdaj","delta1","delta2","delta3","delta4")))
# response_1<-c(0,0,0,0,0)
# response_2<-c(1,1,1,1,1)
# response_3<-c(2,2,2,2,2)
# response_4<-c(3,3,3,3,3)
# response_5<-c(4,4,4,4,4)
# # ABILITY ESTIMATION
# compute_eap_rsm(bank,response_1)
# catR::eapEst(bank,response_1,model="RSM")
# compute_eap_rsm(bank,response_2)
# catR::eapEst(bank,response_2,model="RSM")
# compute_eap_rsm(bank,response_3)
# catR::eapEst(bank,response_3,model="RSM")
# compute_eap_rsm(bank,response_4)
# catR::eapEst(bank,response_4,model="RSM")
# compute_eap_rsm(bank,response_5)
# catR::eapEst(bank,response_5,model="RSM")
# # STANDARD ERROR ESTIMATION
# compute_eap_se_rsm(compute_eap_rsm(bank,response_1),bank,response_1)
# catR::eapSem(compute_eap_rsm(bank,response_1),bank,response_1,model="RSM")
# compute_eap_se_rsm(compute_eap_rsm(bank,response_2),bank,response_2)
# catR::eapSem(compute_eap_rsm(bank,response_2),bank,response_2,model="RSM")
# compute_eap_se_rsm(compute_eap_rsm(bank,response_3),bank,response_3)
# catR::eapSem(compute_eap_rsm(bank,response_3),bank,response_3,model="RSM")
# compute_eap_se_rsm(compute_eap_rsm(bank,response_4),bank,response_4)
# catR::eapSem(compute_eap_rsm(bank,response_4),bank,response_4,model="RSM")
# compute_eap_se_rsm(compute_eap_rsm(bank,response_5),bank,response_5)
# catR::eapSem(compute_eap_rsm(bank,response_5),bank,response_5,model="RSM")
