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
#' @title compute category response probabilities and derivatives under the graded response model
#' @description returns the category response probabilities for a given ability value and a \cr
#'              given matrix of item parameters under Samejima graded response model (GRM) \cr
#'              returns the first second and third derivatives of the category response \cr
#'              probabilities
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
#'       differentiating again gives D*alpha_j*dPstar_jk*(1-2*Pstar_jk) for the second \cr
#'       derivative and D*alpha_j*(d2Pstar_jk-2*dPstar_jk^2-2*Pstar_jk*d2Pstar_jk) for \cr
#'       the third and the boundary curves Pstar_j0=1 and Pstar_j(m+1)=0 have zero \cr
#'       derivatives of every order \cr
#'       when theta is far above the thresholds both cumulative curves are close to 1 \cr
#'       and their difference loses precision so probabilities below about 1e-11 are \cr
#'       inaccurate and below about 1e-16 they are rounding noise that is 0 or a \cr
#'       multiple of 1.1e-16 and can even be slightly negative \cr
#'       catR computes them the same way and only response patterns that contradict \cr
#'       theta strongly on very discriminating items are affected
#' @return Pi   category response probabilities one row per item one column per category \cr
#'         dPi  first derivatives of the category response probabilities \cr
#'         d2Pi second derivatives of the category response probabilities \cr
#'         d3Pi third derivatives of the category response probabilities
#' @export
#' @examples
#' bank<-matrix(c(1.227,0.845,1.694,1.012,2.103,
#'                -2.183,-1.542,-1.021,-2.460,-0.812,
#'                -0.874,-0.415,-0.231,-1.105,0.094,
#'                0.316,0.783,0.652,0.047,0.881,
#'                1.592,2.064,1.438,1.271,1.736),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("alphaj","betaj1","betaj2","betaj3","betaj4")))
#' pi_cat<-catR::Pi(th=0,bank,model="GRM")
#' pi<-compute_pi_grm(theta=0,bank)
#' pi_cat
#' pi
#' isTRUE(all.equal(pi_cat[[1]], pi[[1]]))
#' isTRUE(all.equal(pi_cat[[2]], pi[[2]]))
#' isTRUE(all.equal(pi_cat[[3]], pi[[3]]))
#' isTRUE(all.equal(pi_cat[[4]], pi[[4]]))
compute_pi_grm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  ncat<-ncol(bank)
  Pi<-dPi<-d2Pi<-d3Pi<-matrix(NA,nrow(bank),ncat)
  for (i in 1:nrow(bank)) {
    aj<-bank[i,1]
    bj<-bank[i,2:ncat]
    bj<-bj[!is.na(bj)]
    ej<-exp(D*aj*(theta-bj))
    Pjs<-c(1,ej/(1+ej),0)
    dPjs<-D*aj*Pjs*(1-Pjs)
    d2Pjs<-D*aj*(dPjs-2*Pjs*dPjs)
    d3Pjs<-D*aj*(d2Pjs-2*dPjs^2-2*Pjs*d2Pjs)
    n<-length(Pjs)
    Pi[i,1:(n-1)]<-Pjs[1:(n-1)]-Pjs[2:n]
    dPi[i,1:(n-1)]<-dPjs[1:(n-1)]-dPjs[2:n]
    d2Pi[i,1:(n-1)]<-d2Pjs[1:(n-1)]-d2Pjs[2:n]
    d3Pi[i,1:(n-1)]<-d3Pjs[1:(n-1)]-d3Pjs[2:n]
  }
  colnames(Pi)<-colnames(dPi)<-colnames(d2Pi)<-colnames(d3Pi)<-paste("cat",0:(ncat-1),sep="")
  rownames(Pi)<-rownames(dPi)<-rownames(d2Pi)<-rownames(d3Pi)<-paste("Item",1:nrow(bank),sep="")
  result<-list(Pi=Pi,dPi=dPi,d2Pi=d2Pi,d3Pi=d3Pi)
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
#' bank<-matrix(c(1.227,0.845,1.694,1.012,2.103,
#'                -2.183,-1.542,-1.021,-2.460,-0.812,
#'                -0.874,-0.415,-0.231,-1.105,0.094,
#'                0.316,0.783,0.652,0.047,0.881,
#'                1.592,2.064,1.438,1.271,1.736),
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("alphaj","betaj1","betaj2","betaj3","betaj4")))
#' li_catr<-catR::Ii(th=0,bank,model="GRM")
#' li<-compute_ii_grm(theta=0,bank)
#' li_catr
#' li
#' data.frame(catr=li_catr[[1]],li=li[[1]],equal=li_catr[[1]]==li[[1]])
#' data.frame(catr=li_catr[[2]],li=li[[2]],equal=li_catr[[2]]==li[[2]])
#' data.frame(catr=li_catr[[3]],li=li[[3]],equal=li_catr[[3]]==li[[3]])
compute_ii_grm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  prob<-compute_pi_grm(theta,bank,D=D)
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
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("alphaj","betaj1","betaj2","betaj3","betaj4")))
#' catR::nextItem(bank,model="GRM",theta=0,criterion="MFI") # with catR installed
#' compute_next_item_grm(theta=0,bank)
compute_next_item_grm<-function(theta,bank,out=NULL,D=1,randomesque=1) {
  bank<-rbind(bank)
  available<-setdiff(1:nrow(bank),out)
  if (length(available)==0) stop("no item left in the bank",call.=FALSE)
  info<-compute_ii_grm(theta,bank[available,,drop=FALSE],D=D)$Ii
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
#'       compute_pi_grm returns a matrix so the response of item i selects the column x[i]+1 \cr
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
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("alphaj","betaj1","betaj2","betaj3","betaj4")))
#' response<-c(4,3,2,1,0)
#' compute_likelihood_grm(theta=0,bank=bank,x=response)
compute_likelihood_grm<-function(theta,bank,x,D=1) {
  prob<-compute_pi_grm(theta,bank,D=D)$Pi
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
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("alphaj","betaj1","betaj2","betaj3","betaj4")))
#' response<-c(4,3,2,1,0)
#' catR::eapEst(bank,response,model="GRM")
#' compute_eap_grm(bank,response)
compute_eap_grm<-function (bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-s[i]*density_function(s[i],priorPar[1],priorPar[2])*compute_likelihood_grm(s[i],bank,x,D=D)
    return(res)
  }
  h<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-density_function(s[i],priorPar[1],priorPar[2])*compute_likelihood_grm(s[i],bank,x,D=D)
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
#'              nrow=5,
#'              dimnames=list(c(1,2,3,4,5),
#'                            c("alphaj","betaj1","betaj2","betaj3","betaj4")))
#' response<-c(4,3,2,1,0)
#' catR::eapSem(0,bank,response,model="GRM")
#' compute_eap_se_grm(theta=0,bank=bank,x=response)
compute_eap_se_grm<-function(theta,bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-(X[i]-theta)^2*density_function(X[i],priorPar[1],priorPar[2])*compute_likelihood_grm(X[i],bank,x,D=D)
    return(res)
  }
  h<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-density_function(X[i],priorPar[1],priorPar[2])*compute_likelihood_grm(X[i],bank,x,D=D)
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
# # 5 point Likert scale scored 0 1 2 3 4
# # alphaj and betaj1 to betaj4 are all item specific
# alphaj<-c(1.227,0.845,1.694,1.012,2.103)
# betaj1<-c(-2.183,-1.542,-1.021,-2.460,-0.812)
# betaj2<-c(-0.874,-0.415,-0.231,-1.105,0.094)
# betaj3<-c(0.316,0.783,0.652,0.047,0.881)
# betaj4<-c(1.592,2.064,1.438,1.271,1.736)
# bank<-matrix(c(alphaj,betaj1,betaj2,betaj3,betaj4),
#              nrow=5,
#              dimnames=list(c(1,2,3,4,5),c("alphaj","betaj1","betaj2","betaj3","betaj4")))
# response_1<-c(0,0,0,0,0)
# response_2<-c(1,1,1,1,1)
# response_3<-c(2,2,2,2,2)
# response_4<-c(3,3,3,3,3)
# response_5<-c(4,4,4,4,4)
# # ABILITY ESTIMATION
# compute_eap_grm(bank,response_1)
# catR::eapEst(bank,response_1,model="GRM")
# compute_eap_grm(bank,response_2)
# catR::eapEst(bank,response_2,model="GRM")
# compute_eap_grm(bank,response_3)
# catR::eapEst(bank,response_3,model="GRM")
# compute_eap_grm(bank,response_4)
# catR::eapEst(bank,response_4,model="GRM")
# compute_eap_grm(bank,response_5)
# catR::eapEst(bank,response_5,model="GRM")
# # STANDARD ERROR ESTIMATION
# compute_eap_se_grm(compute_eap_grm(bank,response_1),bank,response_1)
# catR::eapSem(compute_eap_grm(bank,response_1),bank,response_1,model="GRM")
# compute_eap_se_grm(compute_eap_grm(bank,response_2),bank,response_2)
# catR::eapSem(compute_eap_grm(bank,response_2),bank,response_2,model="GRM")
# compute_eap_se_grm(compute_eap_grm(bank,response_3),bank,response_3)
# catR::eapSem(compute_eap_grm(bank,response_3),bank,response_3,model="GRM")
# compute_eap_se_grm(compute_eap_grm(bank,response_4),bank,response_4)
# catR::eapSem(compute_eap_grm(bank,response_4),bank,response_4,model="GRM")
# compute_eap_se_grm(compute_eap_grm(bank,response_5),bank,response_5)
# catR::eapSem(compute_eap_grm(bank,response_5),bank,response_5,model="GRM")

