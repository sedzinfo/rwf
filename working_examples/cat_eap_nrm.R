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
# and extended with the fourth derivative of the response probabilities and the third
# derivative of the item information which catR does not compute
##########################################################################################
# RESPONSE PROBABILITIES
##########################################################################################
#' @title compute category response probabilities and derivatives under the nominal response model
#' @description returns the category response probabilities for a given ability value and a \cr
#'              given matrix of item parameters under Bock nominal response model (NRM) \cr
#'              returns the first second and third derivatives of the category response \cr
#'              probabilities
#' @param theta ability
#' @param bank item parameters one row per item \cr
#'             the columns come in pairs alpha_jk and c_jk for the categories 1 to m \cr
#'             so the columns are alpha1 c1 alpha2 c2 up to alpha_m c_m \cr
#'             alpha_jk is the slope and c_jk the intercept of category k \cr
#'             category 0 is the reference category with slope 0 and intercept 0 so it \cr
#'             has no columns \cr
#'             the categories do not need to be ordered which is what makes the model \cr
#'             nominal \cr
#'             an item with fewer categories than the widest item is padded with NA pairs \cr
#'             a mirt model fitted with itemtype="nominal" converts with \cr
#'             pars<-mirt::coef(model,simplify=TRUE)$items \cr
#'             m<-length(grep("^ak",colnames(pars)))-1 \cr
#'             alpha<-pars[,"a1"]*pars[,paste("ak",1:m,sep="")] \cr
#'             cj<-pars[,paste("d",1:m,sep="")] \cr
#'             bank<-cbind(alpha,cj)[,order(rep(1:m,2))] \cr
#'             colnames(bank)<-paste(c("alpha","c"),rep(1:m,each=2),sep="") \cr
#'             mirt renumbers the observed categories of each item from 0 so the \cr
#'             responses must be coded the same way
#' @param D metric constant kept for the same interface as the other files \cr
#'          the nominal response model has no metric constant because any constant \cr
#'          multiplying the exponent is absorbed in the slopes and the intercepts so D \cr
#'          is not used and catR ignores it too
#' @note this function should return the same result as catR::Pi(model="NRM") \cr
#'       the number of response categories is ncol(bank)/2+1 so 5 response categories \cr
#'       coded 0 1 2 3 4 need a bank with 8 columns \cr
#'       the probability of category k is \cr
#'       P(X=k|theta)=exp(alpha_jk*theta+c_jk)/sum over all categories \cr
#'       with alpha_j0*theta+c_j0 equal to zero \cr
#'       log(P(X=k)/P(X=0))=alpha_jk*theta+c_jk is a straight line so the most \cr
#'       probable category at theta is the category with the highest line \cr
#'       at very high theta that is the category with the largest slope and at very low \cr
#'       theta the category with the smallest slope \cr
#'       when two categories share that slope their lines are parallel and the one \cr
#'       with the larger intercept wins \cr
#'       as theta grows the categories take turns being the most probable in the order \cr
#'       of their slopes and not of their codes \cr
#'       a category is skipped when the next category overtakes it before it overtakes \cr
#'       the previous one and this can happen with ordered slopes too \cr
#'       with D=1 the partial credit model is the nominal model with alpha_jk=k and \cr
#'       c_jk=-(delta_j1+...+delta_jk) and the generalized partial credit model \cr
#'       multiplies both by the item discrimination \cr
#'       for a bank used with D=1.702 both are multiplied by D as well because the \cr
#'       nominal model ignores D \cr
#'       in the code dj holds alpha_jk*theta+c_jk and gamma holds exp(dj) for each \cr
#'       category while v holds the slope alpha_jk \cr
#'       the exponent of category k grows by alpha_jk when theta grows by one so the \cr
#'       derivative of gamma is gamma*v and is exact \cr
#'       each further derivative multiplies by v again so gamma*v^2 and gamma*v^3 give \cr
#'       the second and third derivatives of Pi through the quotient rule
#' @return Pi   category response probabilities one row per item one column per category \cr
#'         dPi  first derivatives of the category response probabilities \cr
#'         d2Pi second derivatives of the category response probabilities \cr
#'         d3Pi third derivatives of the category response probabilities \cr
#'         d4Pi fourth derivatives of the category response probabilities which catR \cr
#'              does not return and which the third derivative of the information needs
#' @export
#' @examples
#' bank<-matrix(c(0.614,0.782,0.297,1.036,0.521,
#'                1.187,0.906,1.523,0.418,0.694,
#'                1.395,1.487,1.103,0.688,1.214,
#'                1.812,1.093,2.176,1.407,1.032,
#'                2.106,2.391,1.724,2.012,1.873,
#'                1.264,0.517,1.936,0.793,0.186,
#'                2.918,3.087,2.215,2.604,3.382,
#'                0.097,-0.814,1.012,-0.296,-1.618),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")))
#' pi_cat<-catR::Pi(th=0,bank,model="NRM") # this will work with catR package installed
#' pi<-compute_pi_nrm(theta=0,bank)
#' pi_cat
#' pi
#' isTRUE(all.equal(pi_cat[[1]], pi[[1]]))
#' isTRUE(all.equal(pi_cat[[2]], pi[[2]]))
#' isTRUE(all.equal(pi_cat[[3]], pi[[3]]))
#' isTRUE(all.equal(pi_cat[[4]], pi[[4]]))
compute_pi_nrm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  ncat<-ncol(bank)/2+1
  Pi<-dPi<-d2Pi<-d3Pi<-d4Pi<-matrix(NA,nrow(bank),ncat)
  for (i in 1:nrow(bank)) {
    dj<-v<-0
    for (t in 1:(ncat-1)) {
      dj<-c(dj,bank[i,2*t-1]*theta+bank[i,2*t])
      v<-c(v,bank[i,2*t-1])
    }
    v<-v[!is.na(dj)]
    dj<-dj[!is.na(dj)]
    gamma<-exp(dj)
    dgamma<-gamma*v
    d2gamma<-gamma*v^2
    d3gamma<-gamma*v^3
    d4gamma<-gamma*v^4
    sum_gamma<-sum(gamma)
    sum_dgamma<-sum(dgamma)
    sum_d2gamma<-sum(d2gamma)
    sum_d3gamma<-sum(d3gamma)
    sum_d4gamma<-sum(d4gamma)
    n<-length(gamma)
    Pi[i,1:n]<-gamma/sum_gamma
    dPi[i,1:n]<-dgamma/sum_gamma-gamma*sum_dgamma/sum_gamma^2
    d2Pi[i,1:n]<-d2gamma/sum_gamma-2*dgamma*sum_dgamma/sum_gamma^2-
      gamma*sum_d2gamma/sum_gamma^2+2*gamma*sum_dgamma^2/sum_gamma^3
    d3Pi[i,1:n]<-d3gamma/sum_gamma-
      (gamma*sum_d3gamma+3*dgamma*sum_d2gamma+3*d2gamma*sum_dgamma)/sum_gamma^2+
      (6*gamma*sum_dgamma*sum_d2gamma+6*dgamma*sum_dgamma^2)/sum_gamma^3-
      6*gamma*sum_dgamma^3/sum_gamma^4
    d4Pi[i,1:n]<-d4gamma/sum_gamma-
      (gamma*sum_d4gamma+4*dgamma*sum_d3gamma+6*d2gamma*sum_d2gamma+4*d3gamma*sum_dgamma)/sum_gamma^2+
      (12*d2gamma*sum_dgamma^2+24*dgamma*sum_dgamma*sum_d2gamma+
         8*gamma*sum_dgamma*sum_d3gamma+6*gamma*sum_d2gamma^2)/sum_gamma^3-
      (24*dgamma*sum_dgamma^3+36*gamma*sum_dgamma^2*sum_d2gamma)/sum_gamma^4+
      24*gamma*sum_dgamma^4/sum_gamma^5
  }
  colnames(Pi)<-colnames(dPi)<-colnames(d2Pi)<-colnames(d3Pi)<-colnames(d4Pi)<-paste("cat",0:(ncat-1),sep="")
  rownames(Pi)<-rownames(dPi)<-rownames(d2Pi)<-rownames(d3Pi)<-rownames(d4Pi)<-paste("Item",1:nrow(bank),sep="")
  result<-list(Pi=Pi,dPi=dPi,d2Pi=d2Pi,d3Pi=d3Pi,d4Pi=d4Pi)
  return(result)
}
##########################################################################################
# ITEM INFORMATION
##########################################################################################
#' @title compute item information under the nominal response model
#' @param theta ability
#' @param bank matrix of item parameters
#' @param D metric constant kept for the same interface as the other files and not used
#' @note this function should return the same result as catR::Ii(model="NRM") \cr
#'       the polytomous item information is the sum over categories of the squared \cr
#'       first derivative divided by the probability \cr
#'       I_j(theta)=sum_k (dP_jk/dtheta)^2/P_jk \cr
#'       under the nominal response model this sum is the variance at theta of the \cr
#'       slope alpha_jk of the category chosen \cr
#'       the information is therefore large where categories with very different \cr
#'       slopes are both probable and it depends on the gaps between the slopes rather \cr
#'       than on their order \cr
#'       test information is the sum of the item informations \cr
#'       dIi and d2Ii are the first and second derivatives of the item information \cr
#'       with respect to theta obtained by differentiating each category term \cr
#'       dP_jk^2/P_jk and summing over categories \cr
#'       dIi=sum_k 2*dP*d2P/P-dP^3/P^2 \cr
#'       d2Ii=sum_k (2*d2P^2+2*dP*d3P)/P-5*dP^2*d2P/P^2+2*dP^4/P^3 \cr
#'       d3Ii=sum_k (6*d2P*d3P+2*dP*d4P)/P-(12*dP*d2P^2+7*dP^2*d3P)/P^2+ \cr
#'                  18*dP^3*d2P/P^3-6*dP^5/P^4 \cr
#'       catR stops at d2Ii so d3Ii has no catR counterpart
#' @return Ii   item information for each item \cr
#'         dIi  first derivative of the item information for each item \cr
#'         d2Ii second derivative of the item information for each item \cr
#'         d3Ii third derivative of the item information for each item
#' @export
#' @examples
#' bank<-matrix(c(0.614,0.782,0.297,1.036,0.521,
#'                1.187,0.906,1.523,0.418,0.694,
#'                1.395,1.487,1.103,0.688,1.214,
#'                1.812,1.093,2.176,1.407,1.032,
#'                2.106,2.391,1.724,2.012,1.873,
#'                1.264,0.517,1.936,0.793,0.186,
#'                2.918,3.087,2.215,2.604,3.382,
#'                0.097,-0.814,1.012,-0.296,-1.618),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")))
#' li_catr<-catR::Ii(th=0,bank,model="NRM") # this will work with catR package installed
#' li<-compute_ii_nrm(theta=0,bank)
#' li_catr
#' li
#' data.frame(catr=li_catr[[1]],li=li[[1]],equal=li_catr[[1]]==li[[1]])
#' data.frame(catr=li_catr[[2]],li=li[[2]],equal=li_catr[[2]]==li[[2]])
#' data.frame(catr=li_catr[[3]],li=li[[3]],equal=li_catr[[3]]==li[[3]])
compute_ii_nrm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  prob<-compute_pi_nrm(theta,bank,D=D)
  P<-prob$Pi
  dP<-prob$dPi
  d2P<-prob$d2Pi
  d3P<-prob$d3Pi
  d4P<-prob$d4Pi
  Ii<-as.numeric(rowSums(dP^2/P,na.rm=TRUE))
  dIi<-as.numeric(rowSums(2*dP*d2P/P-dP^3/P^2,na.rm=TRUE))
  d2Ii<-as.numeric(rowSums((2*d2P^2+2*dP*d3P)/P-5*dP^2*d2P/P^2+2*dP^4/P^3,na.rm=TRUE))
  d3Ii<-as.numeric(rowSums((6*d2P*d3P+2*dP*d4P)/P-(12*dP*d2P^2+7*dP^2*d3P)/P^2+
                             18*dP^3*d2P/P^3-6*dP^5/P^4,na.rm=TRUE))
  result<-list(Ii=Ii,dIi=dIi,d2Ii=d2Ii,d3Ii=d3Ii)
  return(result)
}
##########################################################################################
# NEXT ITEM SELECTION
##########################################################################################
#' @title select the next item by maximum Fisher information
#' @param theta current ability estimate
#' @param bank matrix of item parameters
#' @param out vector of the indices of the items already administered
#' @param D metric constant kept for the same interface as the other files and not used
#' @param randomesque number of most informative items to draw at random from \cr
#'                    1 is pure maximum information and 3 to 5 spreads item exposure
#' @note this function should return the same result as \cr
#'       catR::nextItem(itemBank,model="NRM",theta,out,criterion="MFI") when \cr
#'       randomesque is 1 and the most informative item is unique \cr
#'       when several items tie exactly catR draws one of them at random while this \cr
#'       function takes the first \cr
#'       with randomesque above 1 catR also keeps every item tied with the last one kept \cr
#'       so it can draw from more than randomesque items \cr
#'       every item has its own slopes and intercepts so the information curves differ \cr
#'       in height and shape and the information of every available item has to be \cr
#'       computed at theta
#' @return item  index of the selected item in the bank \cr
#'         info  information of the selected item at theta \cr
#'         available indices of the items still available
#' @export
#' @examples
#' bank<-matrix(c(0.614,0.782,0.297,1.036,0.521,
#'                1.187,0.906,1.523,0.418,0.694,
#'                1.395,1.487,1.103,0.688,1.214,
#'                1.812,1.093,2.176,1.407,1.032,
#'                2.106,2.391,1.724,2.012,1.873,
#'                1.264,0.517,1.936,0.793,0.186,
#'                2.918,3.087,2.215,2.604,3.382,
#'                0.097,-0.814,1.012,-0.296,-1.618),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")))
#' catR::nextItem(bank,model="NRM",theta=0,criterion="MFI") # with catR installed
#' compute_next_item_nrm(theta=0,bank)
compute_next_item_nrm<-function(theta,bank,out=NULL,D=1,randomesque=1) {
  bank<-rbind(bank)
  available<-setdiff(1:nrow(bank),out)
  if (length(available)==0) stop("no item left in the bank",call.=FALSE)
  info<-compute_ii_nrm(theta,bank[available,,drop=FALSE],D=D)$Ii
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
#' @param x vector of item responses coded 0 to m
#' @param D metric constant kept for the same interface as the other files and not used
#' @note this is the polytomous counterpart of prod(Pi^x*(1-Pi)^(1-x)) used for the 4PL \cr
#'       model \cr
#'       compute_pi_nrm returns a matrix so the response of item i selects the column x[i]+1 \cr
#'       the +1 is index bookkeeping because categories start at 0 and R columns start \cr
#'       at 1 \cr
#'       the probabilities of the observed responses are multiplied across items under \cr
#'       the local independence assumption \cr
#'       the codes 0 to m only label the categories and carry no order so the response \cr
#'       enters the likelihood only through the slope and intercept of its category
#' @export
#' @examples
#' bank<-matrix(c(0.614,0.782,0.297,1.036,0.521,
#'                1.187,0.906,1.523,0.418,0.694,
#'                1.395,1.487,1.103,0.688,1.214,
#'                1.812,1.093,2.176,1.407,1.032,
#'                2.106,2.391,1.724,2.012,1.873,
#'                1.264,0.517,1.936,0.793,0.186,
#'                2.918,3.087,2.215,2.604,3.382,
#'                0.097,-0.814,1.012,-0.296,-1.618),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")))
#' response<-c(4,3,2,1,0)
#' compute_likelihood_nrm(theta=0,bank=bank,x=response)
compute_likelihood_nrm<-function(theta,bank,x,D=1) {
  prob<-compute_pi_nrm(theta,bank,D=D)$Pi
  result<-1
  for (i in 1:length(x)) result<-result*prob[i,x[i]+1]
  return(result)
}
##########################################################################################
# EAP ESTIMATION
##########################################################################################
#' @title compute theta EAP estimation under the nominal response model
#' @param bank matrix of item parameters
#' @param x vector of item responses coded 0 to m
#' @param D metric constant kept for the same interface as the other files and not used
#' @param priorPar mean and sd for normal distribution default is mean 0 and sd 1
#' @param lower lower bound for numerical integration
#' @param upper upper bound for numerical integration
#' @param nqp number of quadrature points
#' @note this function should return the same result as catR::eapEst(model="NRM") \cr
#'       the sufficient statistic for theta is the sum of the slopes alpha_jk of the \cr
#'       categories chosen so two response patterns on the same items with the same \cr
#'       sum of slopes give the same EAP estimate
#' @export
#' @examples
#' bank<-matrix(c(0.614,0.782,0.297,1.036,0.521,
#'                1.187,0.906,1.523,0.418,0.694,
#'                1.395,1.487,1.103,0.688,1.214,
#'                1.812,1.093,2.176,1.407,1.032,
#'                2.106,2.391,1.724,2.012,1.873,
#'                1.264,0.517,1.936,0.793,0.186,
#'                2.918,3.087,2.215,2.604,3.382,
#'                0.097,-0.814,1.012,-0.296,-1.618),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")))
#' response<-c(4,3,2,1,0)
#' catR::eapEst(bank,response,model="NRM") # this will work with catR package installed
#' compute_eap_nrm(bank,response)
compute_eap_nrm<-function (bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-s[i]*density_function(s[i],priorPar[1],priorPar[2])*compute_likelihood_nrm(s[i],bank,x,D=D)
    return(res)
  }
  h<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-density_function(s[i],priorPar[1],priorPar[2])*compute_likelihood_nrm(s[i],bank,x,D=D)
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
#' @title compute standard error of theta EAP estimation under the nominal response model
#' @param theta theta estimation
#' @param bank matrix of item parameters
#' @param x vector of item responses coded 0 to m
#' @param D metric constant kept for the same interface as the other files and not used
#' @param priorPar mean and sd for normal distribution default is mean 0 and sd 1
#' @param lower lower bound for numerical integration
#' @param upper upper bound for numerical integration
#' @param nqp number of quadrature points
#' @note this function should return the same result as catR::eapSem(model="NRM") \cr
#'       pass the EAP estimate as theta to obtain the posterior standard deviation \cr
#'       any other value returns the posterior root mean squared deviation around it \cr
#'       so the curve is minimised at the EAP estimate
#' @export
#' @examples
#' bank<-matrix(c(0.614,0.782,0.297,1.036,0.521,
#'                1.187,0.906,1.523,0.418,0.694,
#'                1.395,1.487,1.103,0.688,1.214,
#'                1.812,1.093,2.176,1.407,1.032,
#'                2.106,2.391,1.724,2.012,1.873,
#'                1.264,0.517,1.936,0.793,0.186,
#'                2.918,3.087,2.215,2.604,3.382,
#'                0.097,-0.814,1.012,-0.296,-1.618),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")))
#' response<-c(4,3,2,1,0)
#' catR::eapSem(0,bank,response,model="NRM") # this will work with catR package installed
#' compute_eap_se_nrm(theta=0,bank=bank,x=response)
compute_eap_se_nrm<-function(theta,bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-(X[i]-theta)^2*density_function(X[i],priorPar[1],priorPar[2])*compute_likelihood_nrm(X[i],bank,x,D=D)
    return(res)
  }
  h<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-density_function(X[i],priorPar[1],priorPar[2])*compute_likelihood_nrm(X[i],bank,x,D=D)
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
# https://dimitrios.shinyapps.io/modelsirt/ check the NRM tab to see the ability response probability curve
##########################################################################################
# EXAMPLE 1
##########################################################################################
# # 5 response categories coded 0 1 2 3 4
# # every category except the reference category 0 has its own slope and intercept
# alpha1<-c(0.614,0.782,0.297,1.036,0.521)
# c1<-c(1.187,0.906,1.523,0.418,0.694)
# alpha2<-c(1.395,1.487,1.103,0.688,1.214)
# c2<-c(1.812,1.093,2.176,1.407,1.032)
# alpha3<-c(2.106,2.391,1.724,2.012,1.873)
# c3<-c(1.264,0.517,1.936,0.793,0.186)
# alpha4<-c(2.918,3.087,2.215,2.604,3.382)
# c4<-c(0.097,-0.814,1.012,-0.296,-1.618)
# bank<-matrix(c(alpha1,c1,alpha2,c2,alpha3,c3,alpha4,c4),nrow=5,
#              dimnames=list(c(1,2,3,4,5),c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")))
# response_1<-c(0,0,0,0,0)
# response_2<-c(1,1,1,1,1)
# response_3<-c(2,2,2,2,2)
# response_4<-c(3,3,3,3,3)
# response_5<-c(4,4,4,4,4)
# # ABILITY ESTIMATION
# compute_eap_nrm(bank,response_1)
# catR::eapEst(bank,response_1,model="NRM")
# compute_eap_nrm(bank,response_2)
# catR::eapEst(bank,response_2,model="NRM")
# compute_eap_nrm(bank,response_3)
# catR::eapEst(bank,response_3,model="NRM")
# compute_eap_nrm(bank,response_4)
# catR::eapEst(bank,response_4,model="NRM")
# compute_eap_nrm(bank,response_5)
# catR::eapEst(bank,response_5,model="NRM")
# # STANDARD ERROR ESTIMATION
# compute_eap_se_nrm(compute_eap_nrm(bank,response_1),bank,response_1)
# catR::eapSem(compute_eap_nrm(bank,response_1),bank,response_1,model="NRM")
# compute_eap_se_nrm(compute_eap_nrm(bank,response_2),bank,response_2)
# catR::eapSem(compute_eap_nrm(bank,response_2),bank,response_2,model="NRM")
# compute_eap_se_nrm(compute_eap_nrm(bank,response_3),bank,response_3)
# catR::eapSem(compute_eap_nrm(bank,response_3),bank,response_3,model="NRM")
# compute_eap_se_nrm(compute_eap_nrm(bank,response_4),bank,response_4)
# catR::eapSem(compute_eap_nrm(bank,response_4),bank,response_4,model="NRM")
# compute_eap_se_nrm(compute_eap_nrm(bank,response_5),bank,response_5)
# catR::eapSem(compute_eap_nrm(bank,response_5),bank,response_5,model="NRM")
