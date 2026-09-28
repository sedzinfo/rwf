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
#' @title compute category response probabilities and derivatives under the partial credit model
#' @description returns the category response probabilities for a given ability value and a \cr
#'              given matrix of item parameters under Masters partial credit model (PCM) \cr
#'              returns the first derivatives of the category response probabilities
#' @param theta ability
#' @param bank item parameters one row per item \cr
#'             columns 1 to m hold the step parameters delta_j1 to delta_jm \cr
#'             there is no discrimination column because the partial credit model is a \cr
#'             Rasch model \cr
#'             the steps are free for every item which is what separates this model from \cr
#'             the rating scale model where the steps of item j are lambda_j+delta_k so \cr
#'             all the items have the same spacing of steps and differ only by lambda_j \cr
#'             delta_jk is the value of theta where the curves of the categories k-1 and \cr
#'             k cross \cr
#'             the steps do not need to be ordered \cr
#'             when delta_j2 is below delta_j1 category 1 is never the most probable \cr
#'             category but every probability stays positive which is not the case for \cr
#'             the graded response model \cr
#'             an item with fewer categories than the widest item is padded with NA \cr
#'             a mirt model fitted with itemtype="Rasch" gives the bank with the b1 to bm \cr
#'             columns of mirt::coef(model,IRTpars=TRUE,simplify=TRUE)$items to be used with D=1 \cr
#'             mirt stores a dichotomous item in column b instead of b1 so it has to be \cr
#'             moved to the first column
#' @param D metric constant can be 1 or 1.702
#' @note this function should return the same result as catR::Pi(model="PCM") \cr
#'       the number of response categories is ncol(bank)+1 so a 5 point Likert scale \cr
#'       scored 0 1 2 3 4 needs a bank with 4 columns \cr
#'       the probability of category k is \cr
#'       P(X=k|theta)=exp(sum_t=1^k D*(theta-delta_jt))/sum over all categories \cr
#'       with the empty sum for category 0 equal to zero \cr
#'       the rating scale model is the partial credit model with \cr
#'       delta_jk=lambda_j+delta_k \cr
#'       adding an item discrimination to the partial credit model gives the \cr
#'       generalized partial credit model \cr
#'       in the code gamma holds exp(sum_t=1^k D*(theta-delta_jt)) for each category and \cr
#'       v holds the category score k \cr
#'       the exponent of category k grows by D*k when theta grows by one so the exact \cr
#'       derivative of gamma is gamma*D*v \cr
#'       catR uses gamma*v and so does this function to return the same result \cr
#'       with D=1 the two are identical and with D=1.702 dPi is too small by a factor \cr
#'       of D and the information by a factor of D^2 which leaves the item selection \cr
#'       and the EAP estimates unchanged
#' @return Pi   category response probabilities one row per item one column per category \cr
#'         dPi  first derivatives of the category response probabilities exact when D=1 \cr
#'              and divided by D as in catR otherwise
#' @export
#' @examples
#' bank<-matrix(c(-1.853,-2.214,-0.936,-1.508,-0.412,
#'                -0.627,-0.504,-1.215,-0.183,0.338,
#'                0.418,0.692,0.284,0.735,1.102,
#'                1.636,1.927,1.405,2.118,2.285),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("deltaj1","deltaj2","deltaj3","deltaj4")))
#' pi_cat<-catR::Pi(th=0,bank,model="PCM")
#' pi<-compute_pi_pcm(theta=0,bank)
#' pi_cat
#' pi
#' isTRUE(all.equal(pi_cat[[1]], pi[[1]]))
#' isTRUE(all.equal(pi_cat[[2]], pi[[2]]))
#' isTRUE(all.equal(pi_cat[[3]], pi[[3]]))
#' isTRUE(all.equal(pi_cat[[4]], pi[[4]]))
compute_pi_pcm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  ncat<-ncol(bank)+1
  Pi<-dPi<-d2Pi<-d3Pi<-matrix(NA,nrow(bank),ncat)
  for (i in 1:nrow(bank)) {
    dj<-v<-0
    for (t in 1:(ncat-1)) {
      dj<-c(dj,dj[t]+D*(theta-bank[i,t]))
      v<-c(v,t)
    }
    v<-v[!is.na(dj)]
    dj<-dj[!is.na(dj)]
    gamma<-exp(dj)
    dgamma<-gamma*v
    # dgamma<-gamma*D*v
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
#' @title compute item information under the partial credit model
#' @param theta ability
#' @param bank matrix of item parameters
#' @param D metric constant can be 1 or 1.702
#' @note this function should return the same result as catR::Ii(model="PCM") \cr
#'       the polytomous item information is the sum over categories of the squared \cr
#'       first derivative divided by the probability \cr
#'       I_j(theta)=sum_k (dP_jk/dtheta)^2/P_jk \cr
#'       under the partial credit model this sum is the variance of the item score at \cr
#'       theta times D^2 and with the catR derivative the D^2 is left out \cr
#'       there is no discrimination so for a given D the height and the shape of the \cr
#'       curve depend only on the number of steps and on their spacing and the mean of \cr
#'       the steps only moves the curve \cr
#'       steps spread over a short range of theta or reversed give a taller curve \cr
#'       around their mean and steps spread over a long range give a lower and wider \cr
#'       curve that splits into one bump per step when the gaps are large \cr
#'       the variance of a score from 0 to m is at most m^2/4 which caps the height \cr
#'       test information is the sum of the item informations
#' @return Ii item information for each item
#' @export
#' @examples
#' bank<-matrix(c(-1.853,-2.214,-0.936,-1.508,-0.412,
#'                -0.627,-0.504,-1.215,-0.183,0.338,
#'                0.418,0.692,0.284,0.735,1.102,
#'                1.636,1.927,1.405,2.118,2.285),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("deltaj1","deltaj2","deltaj3","deltaj4")))
#' li_catr<-catR::Ii(th=0,bank,model="PCM")
#' li<-compute_ii_pcm(theta=0,bank)
#' li_catr
#' li
#' data.frame(catr=li_catr[[1]],li=li[[1]],equal=li_catr[[1]]==li[[1]])
#' data.frame(catr=li_catr[[2]],li=li[[2]],equal=li_catr[[2]]==li[[2]])
#' data.frame(catr=li_catr[[3]],li=li[[3]],equal=li_catr[[3]]==li[[3]])
compute_ii_pcm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  prob<-compute_pi_pcm(theta,bank,D=D)
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
#'       catR::nextItem(itemBank,model="PCM",theta,out,criterion="MFI") when \cr
#'       randomesque is 1 and the most informative item is unique \cr
#'       when several items tie exactly catR draws one of them at random while this \cr
#'       function takes the first \cr
#'       with randomesque above 1 catR also keeps every item tied with the last one kept \cr
#'       so it can draw from more than randomesque items \cr
#'       every item has its own steps so the information curves differ in height and \cr
#'       shape and the information of every available item has to be computed at theta
#' @return item  index of the selected item in the bank \cr
#'         info  information of the selected item at theta \cr
#'         available indices of the items still available
#' @export
#' @examples
#' bank<-matrix(c(-1.853,-2.214,-0.936,-1.508,-0.412,
#'                -0.627,-0.504,-1.215,-0.183,0.338,
#'                0.418,0.692,0.284,0.735,1.102,
#'                1.636,1.927,1.405,2.118,2.285),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("deltaj1","deltaj2","deltaj3","deltaj4")))
#' catR::nextItem(bank,model="PCM",theta=0,criterion="MFI") # with catR installed
#' compute_next_item_pcm(theta=0,bank)
compute_next_item_pcm<-function(theta,bank,out=NULL,D=1,randomesque=1) {
  bank<-rbind(bank)
  available<-setdiff(1:nrow(bank),out)
  if (length(available)==0) stop("no item left in the bank",call.=FALSE)
  info<-compute_ii_pcm(theta,bank[available,,drop=FALSE],D=D)$Ii
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
#'       compute_pi_pcm returns a matrix so the response of item i selects the column x[i]+1 \cr
#'       the +1 is index bookkeeping because categories start at 0 and R columns start \cr
#'       at 1 \cr
#'       the probabilities of the observed responses are multiplied across items under \cr
#'       the local independence assumption \cr
#'       under the partial credit model the only part of the likelihood that depends on \cr
#'       both theta and the responses is exp(D*theta*sum(x)) \cr
#'       the denominators depend on theta but not on the responses so two patterns with \cr
#'       the same total score on the same items have likelihoods that differ by a \cr
#'       constant factor
#' @export
#' @examples
#' bank<-matrix(c(-1.853,-2.214,-0.936,-1.508,-0.412,
#'                -0.627,-0.504,-1.215,-0.183,0.338,
#'                0.418,0.692,0.284,0.735,1.102,
#'                1.636,1.927,1.405,2.118,2.285),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("deltaj1","deltaj2","deltaj3","deltaj4")))
#' response<-c(4,3,2,1,0)
#' compute_likelihood_pcm(theta=0,bank=bank,x=response)
compute_likelihood_pcm<-function(theta,bank,x,D=1) {
  prob<-compute_pi_pcm(theta,bank,D=D)$Pi
  result<-1
  for (i in 1:length(x)) result<-result*prob[i,x[i]+1]
  return(result)
}
##########################################################################################
# EAP ESTIMATION
##########################################################################################
#' @title compute theta EAP estimation under the partial credit model
#' @param bank matrix of item parameters
#' @param x vector of item responses scored 0 to m
#' @param D metric constant can be 1 or 1.702
#' @param priorPar mean and sd for normal distribution default is mean 0 and sd 1
#' @param lower lower bound for numerical integration
#' @param upper upper bound for numerical integration
#' @param nqp number of quadrature points
#' @note this function should return the same result as catR::eapEst(model="PCM") \cr
#'       the total score sum(x) is a sufficient statistic so two response patterns \cr
#'       with the same total score on the same items give the same EAP estimate \cr
#'       mirt estimates the variance of theta for a Rasch model so a bank taken from \cr
#'       mirt is used with priorPar=c(0,sqrt(pars$cov)) where \cr
#'       pars<-mirt::coef(model,IRTpars=TRUE,simplify=TRUE)
#' @export
#' @examples
#' bank<-matrix(c(-1.853,-2.214,-0.936,-1.508,-0.412,
#'                -0.627,-0.504,-1.215,-0.183,0.338,
#'                0.418,0.692,0.284,0.735,1.102,
#'                1.636,1.927,1.405,2.118,2.285),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("deltaj1","deltaj2","deltaj3","deltaj4")))
#' response<-c(4,3,2,1,0)
#' catR::eapEst(bank,response,model="PCM")
#' compute_eap_pcm(bank,response)
compute_eap_pcm<-function (bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-s[i]*density_function(s[i],priorPar[1],priorPar[2])*compute_likelihood_pcm(s[i],bank,x,D=D)
    return(res)
  }
  h<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-density_function(s[i],priorPar[1],priorPar[2])*compute_likelihood_pcm(s[i],bank,x,D=D)
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
#' @title compute standard error of theta EAP estimation under the partial credit model
#' @param theta theta estimation
#' @param bank matrix of item parameters
#' @param x vector of item responses scored 0 to m
#' @param D metric constant can be 1 or 1.702
#' @param priorPar mean and sd for normal distribution default is mean 0 and sd 1
#' @param lower lower bound for numerical integration
#' @param upper upper bound for numerical integration
#' @param nqp number of quadrature points
#' @note this function should return the same result as catR::eapSem(model="PCM") \cr
#'       pass the EAP estimate as theta to obtain the posterior standard deviation \cr
#'       any other value returns the posterior root mean squared deviation around it \cr
#'       so the curve is minimised at the EAP estimate
#' @export
#' @examples
#' bank<-matrix(c(-1.853,-2.214,-0.936,-1.508,-0.412,
#'                -0.627,-0.504,-1.215,-0.183,0.338,
#'                0.418,0.692,0.284,0.735,1.102,
#'                1.636,1.927,1.405,2.118,2.285),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("deltaj1","deltaj2","deltaj3","deltaj4")))
#' response<-c(4,3,2,1,0)
#' catR::eapSem(0,bank,response,model="PCM")
#' compute_eap_se_pcm(theta=0,bank=bank,x=response)
compute_eap_se_pcm<-function(theta,bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-(X[i]-theta)^2*density_function(X[i],priorPar[1],priorPar[2])*compute_likelihood_pcm(X[i],bank,x,D=D)
    return(res)
  }
  h<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-density_function(X[i],priorPar[1],priorPar[2])*compute_likelihood_pcm(X[i],bank,x,D=D)
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
# https://dimitrios.shinyapps.io/modelsirt/ check the PCM-GPCM tab to see the ability response probability curve
##########################################################################################
# EXAMPLE 1
##########################################################################################
# # 5 point Likert scale scored 0 1 2 3 4
# # deltaj1 to deltaj4 are all item specific
# deltaj1<-c(-1.853,-2.214,-0.936,-1.508,-0.412)
# deltaj2<-c(-0.627,-0.504,-1.215,-0.183,0.338)
# deltaj3<-c(0.418,0.692,0.284,0.735,1.102)
# deltaj4<-c(1.636,1.927,1.405,2.118,2.285)
# bank<-matrix(c(deltaj1,deltaj2,deltaj3,deltaj4),nrow=5,
#              dimnames=list(c(1,2,3,4,5),c("deltaj1","deltaj2","deltaj3","deltaj4")))
# response_1<-c(0,0,0,0,0)
# response_2<-c(1,1,1,1,1)
# response_3<-c(2,2,2,2,2)
# response_4<-c(3,3,3,3,3)
# response_5<-c(4,4,4,4,4)
# # ABILITY ESTIMATION
# compute_eap_pcm(bank,response_1)
# catR::eapEst(bank,response_1,model="PCM")
# compute_eap_pcm(bank,response_2)
# catR::eapEst(bank,response_2,model="PCM")
# compute_eap_pcm(bank,response_3)
# catR::eapEst(bank,response_3,model="PCM")
# compute_eap_pcm(bank,response_4)
# catR::eapEst(bank,response_4,model="PCM")
# compute_eap_pcm(bank,response_5)
# catR::eapEst(bank,response_5,model="PCM")
# # STANDARD ERROR ESTIMATION
# compute_eap_se_pcm(compute_eap_pcm(bank,response_1),bank,response_1)
# catR::eapSem(compute_eap_pcm(bank,response_1),bank,response_1,model="PCM")
# compute_eap_se_pcm(compute_eap_pcm(bank,response_2),bank,response_2)
# catR::eapSem(compute_eap_pcm(bank,response_2),bank,response_2,model="PCM")
# compute_eap_se_pcm(compute_eap_pcm(bank,response_3),bank,response_3)
# catR::eapSem(compute_eap_pcm(bank,response_3),bank,response_3,model="PCM")
# compute_eap_se_pcm(compute_eap_pcm(bank,response_4),bank,response_4)
# catR::eapSem(compute_eap_pcm(bank,response_4),bank,response_4,model="PCM")
# compute_eap_se_pcm(compute_eap_pcm(bank,response_5),bank,response_5)
# catR::eapSem(compute_eap_pcm(bank,response_5),bank,response_5,model="PCM")
