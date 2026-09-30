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
# modified by Dimitrios Zacharatos 2023-2026 split into one file per model with the
# functions renamed rewritten for readability and documented
##########################################################################################
# RESPONSE PROBABILITIES
##########################################################################################
#' @title compute response probabilities and derivatives
#' @description returns the item response probabilities for a given ability value and a given matrix of item parameters under the 4PL model \cr
#'              returns the first and second derivatives of the response probabilities
#' @param theta ability
#' @param bank item parameters
#' @param D metric constant can be 1 or 1.702
#' @note this function should return the same result as the catR::Pi function \cr
#'       response probabilities exactly equal to zero are returned as 1e-10 values \cr
#'       response probabilities exactly equal to one are returned as 1-1e-10 values \cr
#' @return Pi   response probabilities for each item \cr
#'         dPi  first derivatives of the response probabilities for each item \cr
#'         d2Pi	second derivatives of the response probabilities for each item \cr
#'         d3Pi	third derivatives of the response probabilities for each item \cr
#' @export
#' @examples
#' bank<-matrix(c(1.75,1.80,1.85,1.90,1.95,
#'               -3,-2,0,2,3,
#'                0.1,0.1,0.1,0.1,0.1,
#'                0.9,0.9,0.9,0.9,0.9),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("a","b","c","d")))
#' pi_cat<-catR::Pi(th=0,bank)
#' pi<-compute_pi_dichotomous(theta=0,bank)
#' data.frame(catr=pi_cat[[1]],pi=pi[[1]],equal=pi_cat[[1]]==pi[[1]])
#' data.frame(catr=pi_cat[[2]],pi=pi[[2]],equal=pi_cat[[2]]==pi[[2]])
#' data.frame(catr=pi_cat[[3]],pi=pi[[3]],equal=pi_cat[[3]]==pi[[3]])
#' data.frame(catr=pi_cat[[4]],pi=pi[[4]],equal=pi_cat[[4]]==pi[[4]])
compute_pi_dichotomous<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  a<-bank[,1]
  b<-bank[,2]
  c<-bank[,3]
  d<-bank[,4]
  e<-exp(D*a*(theta-b))
  Pi<-c+(d-c)*e/(1+e)
  Pi[Pi==0]<-1e-10
  Pi[Pi==1]<-1-1e-10
  dPi<-D*a*e*(d-c)/(1+e)^2
  d2Pi<-D^2*a^2*e*(1-e)*(d-c)/(1+e)^3
  d3Pi<-D^3*a^3*e*(d-c)*(e^2-4*e+1)/(1+e)^4
  result<-list(Pi=Pi,dPi=dPi,d2Pi=d2Pi,d3Pi=d3Pi)
  return(result)
}
##########################################################################################
# ITEM INFORMATION
##########################################################################################
#' @title compute item information under the 4PL model
#' @param theta ability
#' @param bank item parameters
#' @param D metric constant can be 1 or 1.702
#' @note this function should return the same result as the catR::Ii function \cr
#'       the item information is the squared first derivative divided by the \cr
#'       variance of the response \cr
#'       I_j(theta)=dP_j^2/(P_j*(1-P_j)) \cr
#'       this is the polytomous sum_k (dP_jk/dtheta)^2/P_jk with the two categories \cr
#'       P_j and 1-P_j \cr
#'       for the 2PL with c=0 and d=1 it becomes D^2*a^2*P_j*(1-P_j) which peaks at \cr
#'       theta=b with a height of D^2*a^2/4 \cr
#'       a guessing parameter c above 0 or a slipping parameter d below 1 lowers the \cr
#'       information and with d=1 the peak moves above b to \cr
#'       b+log((1+sqrt(1+8*c))/2)/(D*a) \cr
#'       Pi returns 1e-10 and 1-1e-10 instead of 0 and 1 so the information stays \cr
#'       finite when a probability rounds to 0 or 1 \cr
#'       test information is the sum of the item informations \cr
#'       dIi and d2Ii are the first and second derivatives of the item information \cr
#'       with respect to theta
#' @return Ii   item information for each item \cr
#'         dIi  first derivative of the item information for each item \cr
#'         d2Ii second derivative of the item information for each item
#' @export
#' @examples
#' bank<-matrix(c(1.75,1.80,1.85,1.90,1.95,
#'               -3,-2,0,2,3,
#'                0.1,0.1,0.1,0.1,0.1,
#'                0.9,0.9,0.9,0.9,0.9),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("a","b","c","d")))
#' li_catr<-catR::Ii(th=0,bank)
#' li<-Ii(theta=0,bank)
#' data.frame(catr=li_catr[[1]],li=li[[1]],equal=li_catr[[1]]==li[[1]])
#' data.frame(catr=li_catr[[2]],li=li[[2]],equal=li_catr[[2]]==li[[2]])
#' data.frame(catr=li_catr[[3]],li=li[[3]],equal=li_catr[[3]]==li[[3]])
compute_ii_dichotomous<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  prob<-compute_pi_dichotomous(theta,bank,D=D)
  P<-prob$Pi
  Q<-1-P
  dP<-prob$dPi
  d2P<-prob$d2Pi
  d3P<-prob$d3Pi
  Ii<-dP^2/(P*Q)
  dIi<-dP*(2*P*Q*d2P-dP^2*(Q-P))/(P^2*Q^2)
  d2Ii<-(2*P*Q*(d2P^2+dP*d3P)-2*dP^2*d2P*(Q-P))/(P^2*Q^2)-
    (3*P^2*Q*dP^2*d2P-P*dP^4*(2*Q-P))/(P^4*Q^2)+
    (3*P*Q^2*dP^2*d2P-Q*dP^4*(Q-2*P))/(P^2*Q^4)
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
#'       catR::nextItem(itemBank,theta,out,criterion="MFI") when randomesque is 1 and \cr
#'       the most informative item is unique \cr
#'       when several items tie exactly catR draws one of them at random while this \cr
#'       function takes the first \cr
#'       with randomesque above 1 catR also keeps every item tied with the last one kept \cr
#'       so it can draw from more than randomesque items \cr
#'       when every item has the same a with c=0 and d=1 the information curves are \cr
#'       copies of one another shifted by b and symmetric around it so the most \cr
#'       informative item is the one whose b is closest to theta \cr
#'       with different a c or d the curves differ in height and shape so the \cr
#'       information of every available item has to be computed at theta
#' @return item  index of the selected item in the bank \cr
#'         info  information of the selected item at theta \cr
#'         available indices of the items still available
#' @export
#' @examples
#' bank<-matrix(c(1.75,1.80,1.85,1.90,1.95,
#'               -3,-2,0,2,3,
#'                0.1,0.1,0.1,0.1,0.1,
#'                0.9,0.9,0.9,0.9,0.9),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("a","b","c","d")))
#' catR::nextItem(bank,theta=0,criterion="MFI")
#' compute_next_item_dichotomous(theta=0,bank)
compute_next_item_dichotomous<-function(theta,bank,out=NULL,D=1,randomesque=1) {
  bank<-rbind(bank)
  available<-setdiff(1:nrow(bank),out)
  if (length(available)==0) stop("no item left in the bank",call.=FALSE)
  info<-compute_ii_dichotomous(theta,bank[available,,drop=FALSE],D=D)$Ii
  k<-max(1,min(floor(randomesque),length(available)))
  top<-order(info,decreasing=TRUE)[1:k]
  pick<-if (k==1) top else top[sample.int(k,1)]
  result<-list(item=available[pick],info=info[pick],available=available)
  return(result)
}
##########################################################################################
# LIKELIHOOD
##########################################################################################
#' @title compute the likelihood of a dichotomous response pattern
#' @param theta ability
#' @param bank matrix of item parameters
#' @param x vector of item responses scored 0 or 1
#' @param D metric constant can be 1 or 1.702
#' @note L(theta)=prod(P^x*(1-P)^(1-x)) \cr
#'       a correct response contributes P and a wrong response 1-P \cr
#'       the probabilities of the observed responses are multiplied across items under \cr
#'       the local independence assumption \cr
#'       eap_est and eap_se compute the same product inside their own L function \cr
#'       catR does not export a standalone likelihood function this product is the L \cr
#'       function defined inside catR::eapEst so it is reproduced here with catR::Pi
#' @export
#' @examples
#' bank<-matrix(c(1.75,1.80,1.85,1.90,1.95,
#'               -3,-2,0,2,3,
#'                0.1,0.1,0.1,0.1,0.1,
#'                0.9,0.9,0.9,0.9,0.9),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("a","b","c","d")))
#' response<-c(1,1,1,0,0)
#' P<-catR::Pi(th=0,bank)$Pi
#' prod(P^response*(1-P)^(1-response))
#' compute_likelihood_dichotomous(theta=0,bank=bank,x=response)
compute_likelihood_dichotomous<-function(theta,bank,x,D=1) {
  P<-compute_pi_dichotomous(theta,bank,D=D)$Pi
  result<-prod(P^x*(1-P)^(1-x))
  return(result)
}
##########################################################################################
# EAP ESTIMATION
##########################################################################################
#' @title compute theta EAP estimation
#' @param bank matrix of item parameters
#' @param x vector of item responses
#' @param D metric constant can be 1 or 1.702
#' @param priorPar mean and sd for normal distribution default is mean 0 and sd 1
#' @param lower lower bound for numerical integration
#' @param upper upper bound for numerical integration
#' @param nqp number of quadrature points
#' @note this function should return the same result as the catR::eapEst function
#' @export
#' @examples
#' bank<-matrix(c(1.75,1.80,1.85,1.90,1.95,
#'               -3,-2,0,2,3,
#'                0.1,0.1,0.1,0.1,0.1,
#'                0.9,0.9,0.9,0.9,0.9),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("a","b","c","d")))
#' response<-c(1,0,0,0,0)
#' catR::eapEst(bank,response)
#' compute_eap_dichotomous(bank,response)
compute_eap_dichotomous<-function (bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  L<-function(th,bank,x)
    prod(compute_pi_dichotomous(th,bank,D=D)$Pi^x*(1-compute_pi_dichotomous(th,bank,D=D)$Pi)^(1-x))
  g<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-s[i]*density_function(s[i],priorPar[1],priorPar[2])*L(s[i],bank,x)
    return(res)
  }
  h<-function(s) {
    res<-NULL
    for (i in 1:length(s)) 
      res[i]<-density_function(s[i],priorPar[1],priorPar[2])*L(s[i],bank,x)
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
#' @title compute standard error of theta EAP estimation
#' @param theta theta estimation
#' @param bank matrix of item parameters
#' @param x vector of item responses
#' @param D metric constant can be 1 or 1.702
#' @param priorPar mean and sd for normal distribution default is mean 0 and sd 1
#' @param lower lower bound for numerical integration
#' @param upper upper bound for numerical integration
#' @param nqp number of quadrature points
#' @note this function should return the same result as the catR::eapSem function
#' @export
#' @examples
#' bank<-matrix(c(1.75,1.80,1.85,1.90,1.95,
#'               -3,-2,0,2,3,
#'                0.1,0.1,0.1,0.1,0.1,
#'                0.9,0.9,0.9,0.9,0.9),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("a","b","c","d")))
#' response<-c(0,0,0,0,0)
#' catR::eapSem(0,bank,response)
#' compute_eap_se_dichotomous(theta=0,bank=bank,x=response)
compute_eap_se_dichotomous<-function(theta,bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  L<-function(theta,bank,x) {
    res<-NULL
    res<-compute_pi_dichotomous(theta,bank,D=D)$Pi
    prod(res^x*(1-res)^(1-x))
  }
  g<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-(X[i]-theta)^2*density_function(X[i],priorPar[1],priorPar[2])*L(X[i],bank,x)
    return(res)
  }
  h<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-density_function(X[i],priorPar[1],priorPar[2])*L(X[i],bank,x) # here we use  parameters 0, 1
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
# https://dimitrios.shinyapps.io/modelsirt/ check the Rasch-$PL tab to see the ability response probability curve
##########################################################################################
# EXAMPLE 1
##########################################################################################
# bank<-matrix(c(1.75,1.80,1.85,1.90,1.95,
#               -3,-2,0,2,3,
#                0.1,0.1,0.1,0.1,0.1,
#                0.9,0.9,0.9,0.9,0.9),
#              nrow=5,
#              dimnames=list(c(1,2,3,4,5),
#                            c("a","b","c","d")))
# response_1<-c(1,0,0,0,0)
# response_2<-c(1,1,0,0,0)
# response_3<-c(1,1,1,0,0)
# response_4<-c(1,1,1,1,0)
# response_5<-c(1,1,1,1,1)
# # ABILITY ESTIMATION
# compute_eap_dichotomous(bank,response_1)
# catR::eapEst(bank,response_1)
# compute_eap_dichotomous(bank,response_2)
# catR::eapEst(bank,response_2)
# compute_eap_dichotomous(bank,response_3)
# catR::eapEst(bank,response_3)
# compute_eap_dichotomous(bank,response_4)
# catR::eapEst(bank,response_4)
# compute_eap_dichotomous(bank,response_5)
# catR::eapEst(bank,response_5)
# # STANDARD ERROR ESTIMATION
# compute_eap_se_dichotomous(0,bank,response_1)
# catR::eapSem(0,bank,response_1)
# compute_eap_se_dichotomous(0,bank,response_2)
# catR::eapSem(0,bank,response_2)
# compute_eap_se_dichotomous(0,bank,response_3)
# catR::eapSem(0,bank,response_3)
# compute_eap_se_dichotomous(0,bank,response_4)
# catR::eapSem(0,bank,response_4)
# compute_eap_se_dichotomous(0,bank,response_5)
# catR::eapSem(0,bank,response_5)
