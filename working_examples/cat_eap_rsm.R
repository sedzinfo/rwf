##########################################################################################
# DENSITY FUNCTION
##########################################################################################
#' @title compute normal density function
#' @param x a vector of values at which the density is evaluated
#' @param mean mean for normal distribution this should be set to 0
#' @param sd standard deviation for normal distribution that should be set to 1
#' @note this function should return the same result as the stats::dnorm function \cr
#'       the literal 2.71828 is accurate to 6 significant digits only and shifts the \cr
#'       EAP estimate in the 7th decimal so exp(1) is used instead
#' @export
#' @examples
#' v<-seq(-3,3,by=.1)
#' plot(y=density_function(x=v),x=v)
#' data.frame(x1=dnorm(v),x2=density_function(v))
#' density_function(x=0)
#' dnorm(x=0)
density_function<-function(x,mean=0,sd=1) {
  e<-exp(1)
  # e<-2.71828
  result<-1/(sqrt(2*pi)*sd)*e^-((x-mean)^2/(2*sd^2))
  return(result)
}
##########################################################################################
# INTEGRATION
##########################################################################################
#' @title compute integral of f(x)
#' @param x a vector of x values for numerical integration
#' @param y a vector of numerical values corresponding to f(x) values
#' @note this function should return the same result as the catR::integrate.catR function
#' @export
#' @examples
#' x<-seq(from=-3,to=3,length=33)
#' y<-round(exp(x),2)
#' plot(x=x,y=y)
#' catR::integrate.catR(x,y) # this will work with catR package installed
#' integrate_cat(x=x,y=y)
integrate_cat<-function(x,y) {
  hauteur<-x[2:length(x)]-x[1:(length(x)-1)]
  base<-apply(cbind(y[1:(length(y)-1)],y[2:length(y)]),1,mean)
  result<-sum(base*hauteur)
  return(result)
}
##########################################################################################
# RESPONSE PROBABILITIES
##########################################################################################
#' @title compute category response probabilities and derivatives under the rating scale model
#' @description returns the category response probabilities for a given ability value and a \cr
#'              given matrix of item parameters under Andrich rating scale model (RSM) \cr
#'              returns the first derivatives of the category response probabilities
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
#'         dPi  first derivatives of the category response probabilities
#' @export
#' @examples
#' bank<-matrix(c(-0.560,-0.230,1.559,0.071,0.129,
#'                rep(1.715,5),rep(0.461,5),rep(-1.265,5),rep(-0.687,5)),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("lambdaj","delta1","delta2","delta3","delta4")))
#' catR::Pi(th=0,bank,model="RSM") # this will work with catR package installed
#' Pi_rsm(theta=0,bank)
#' v<-seq(-6,6,by=.1)
#' y_axis_response_probability<-list()
#' for(i in v) y_axis_response_probability[[toString(i)]]<-Pi_rsm(theta=i,bank)$Pi[1,]
#' df_rp<-data.frame(x=v,
#'                   matrix(unlist(y_axis_response_probability),
#'                          nrow=length(y_axis_response_probability),byrow=TRUE))
#' plot(x=df_rp$x,y=df_rp$X1,xlab=expression(theta),ylab=expression(P(theta)),
#'      main="category response probabilities item 1",type="l",col="red",ylim=c(0,1))
#' lines(y=df_rp$X2,x=v,col="green")
#' lines(y=df_rp$X3,x=v,col="blue")
#' lines(y=df_rp$X4,x=v,col="yellow")
#' lines(y=df_rp$X5,x=v,col="orange")
Pi_rsm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  ncat<-ncol(bank)
  Pi<-dPi<-matrix(NA,nrow(bank),ncat)
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
    sum_gamma<-sum(gamma)
    sum_dgamma<-sum(dgamma)
    n<-length(gamma)
    Pi[i,1:n]<-gamma/sum_gamma
    dPi[i,1:n]<-dgamma/sum_gamma-gamma*sum_dgamma/sum_gamma^2
  }
  colnames(Pi)<-colnames(dPi)<-paste("cat",0:(ncat-1),sep="")
  rownames(Pi)<-rownames(dPi)<-paste("Item",1:nrow(bank),sep="")
  result<-list(Pi=Pi,dPi=dPi)
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
#'       test information is the sum of the item informations
#' @return Ii item information for each item
#' @export
#' @examples
#' bank<-matrix(c(-0.560,-0.230,1.559,0.071,0.129,
#'                rep(1.715,5),rep(0.461,5),rep(-1.265,5),rep(-0.687,5)),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("lambdaj","delta1","delta2","delta3","delta4")))
#' catR::Ii(th=0,bank,model="RSM") # this will work with catR package installed
#' Ii_rsm(theta=0,bank)
#' sum(Ii_rsm(theta=0,bank)$Ii) # test information
#' v<-seq(-4,4,by=.1)
#' info<-matrix(NA,length(v),nrow(bank))
#' for (i in 1:length(v)) info[i,]<-Ii_rsm(theta=v[i],bank)$Ii
#' plot(x=v,y=info[,1],xlab=expression(theta),ylab="information",
#'      main="item information curves",type="l",col="red",ylim=c(0,max(info)))
#' lines(y=info[,2],x=v,col="green")
#' lines(y=info[,3],x=v,col="blue")
#' lines(y=info[,4],x=v,col="yellow")
#' lines(y=info[,5],x=v,col="orange")
#' plot(x=v,y=rowSums(info),xlab=expression(theta),ylab="information",
#'      main="test information",type="l")
Ii_rsm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  prob<-Pi_rsm(theta,bank,D=D)
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
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("lambdaj","delta1","delta2","delta3","delta4")))
#' catR::nextItem(bank,model="RSM",theta=0,criterion="MFI") # with catR installed
#' next_item_rsm(theta=0,bank)
#' next_item_rsm(theta=0,bank,out=c(4))
#' catR::nextItem(bank,model="RSM",theta=1.5,criterion="MFI") # with catR installed
#' next_item_rsm(theta=1.5,bank,out=c(4,5))
#' # a short adaptive test driven by the functions in this file
#' responses<-c()
#' administered<-c()
#' theta<-0
#' for (step in 1:4) {
#'   item<-next_item_rsm(theta,bank,out=administered)$item
#'   administered<-c(administered,item)
#'   responses<-c(responses,4) # replace by the real response scored 0 to m
#'   theta<-eap_est_rsm(bank[administered,,drop=FALSE],responses)
#'   cat("step",step,"item",item,"theta",round(theta,4),
#'       "se",round(eap_se_rsm(theta,bank[administered,,drop=FALSE],responses),4),"\n")
#' }
next_item_rsm<-function(theta,bank,out=NULL,D=1,randomesque=1) {
  bank<-rbind(bank)
  available<-setdiff(1:nrow(bank),out)
  if (length(available)==0) stop("no item left in the bank",call.=FALSE)
  info<-Ii_rsm(theta,bank[available,,drop=FALSE],D=D)$Ii
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
#'       Pi_rsm returns a matrix so the response of item i selects the column x[i]+1 \cr
#'       the +1 is index bookkeeping because categories start at 0 and R columns start \cr
#'       at 1 \cr
#'       the responses are multiplied across items under the local independence assumption
#' @export
#' @examples
#' bank<-matrix(c(-0.560,-0.230,1.559,0.071,0.129,
#'                rep(1.715,5),rep(0.461,5),rep(-1.265,5),rep(-0.687,5)),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("lambdaj","delta1","delta2","delta3","delta4")))
#' response<-c(4,3,2,1,0)
#' likelihood_rsm(theta=0,bank=bank,x=response)
#' v<-seq(-4,4,by=.1)
#' lik<-c()
#' for (i in 1:length(v)) lik[i]<-likelihood_rsm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=lik,xlab=expression(theta),ylab="likelihood",
#'      main="likelihood of the response pattern",type="l")
likelihood_rsm<-function(theta,bank,x,D=1) {
  prob<-Pi_rsm(theta,bank,D=D)$Pi
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
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("lambdaj","delta1","delta2","delta3","delta4")))
#' response<-c(4,3,2,1,0)
#' catR::eapEst(bank,response,model="RSM") # this will work with catR package installed
#' eap_est_rsm(bank,response)
eap_est_rsm<-function (bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-s[i]*density_function(s[i],priorPar[1],priorPar[2])*likelihood_rsm(s[i],bank,x,D=D)
    return(res)
  }
  h<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-density_function(s[i],priorPar[1],priorPar[2])*likelihood_rsm(s[i],bank,x,D=D)
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
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("lambdaj","delta1","delta2","delta3","delta4")))
#' response<-c(4,3,2,1,0)
#' catR::eapSem(0,bank,response,model="RSM") # this will work with catR package installed
#' eap_se_rsm(theta=0,bank=bank,x=response)
#' v<-seq(-3,3,by=.1)
#' se<-c()
#' for (i in 1:length(v)) se[i]<-eap_se_rsm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error with a mixed response pattern")
#' response<-c(0,0,0,0,0)
#' for (i in 1:length(v)) se[i]<-eap_se_rsm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error when all responses are in the lowest category")
#' response<-c(4,4,4,4,4)
#' for (i in 1:length(v)) se[i]<-eap_se_rsm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error when all responses are in the highest category")
eap_se_rsm<-function(theta,bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-(X[i]-theta)^2*density_function(X[i],priorPar[1],priorPar[2])*likelihood_rsm(X[i],bank,x,D=D)
    return(res)
  }
  h<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-density_function(X[i],priorPar[1],priorPar[2])*likelihood_rsm(X[i],bank,x,D=D)
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
# 5 point Likert scale scored 0 1 2 3 4
# lambdaj is item specific and delta1 to delta4 are common to all items
lambdaj<-c(-0.560,-0.230,1.559,0.071,0.129)
delta1<-rep(1.715,5)
delta2<-rep(0.461,5)
delta3<-rep(-1.265,5)
delta4<-rep(-0.687,5)
bank<-matrix(c(lambdaj,delta1,delta2,delta3,delta4),nrow=5,
             dimnames=list(c(1,2,3,4,5),c("lambdaj","delta1","delta2","delta3","delta4")))
response_1<-c(0,0,0,0,0)
response_2<-c(1,1,1,1,1)
response_3<-c(2,2,2,2,2)
response_4<-c(3,3,3,3,3)
response_5<-c(4,4,4,4,4)
# ABILITY ESTIMATION
eap_est_rsm(bank,response_1)
catR::eapEst(bank,response_1,model="RSM")
eap_est_rsm(bank,response_2)
catR::eapEst(bank,response_2,model="RSM")
eap_est_rsm(bank,response_3)
catR::eapEst(bank,response_3,model="RSM")
eap_est_rsm(bank,response_4)
catR::eapEst(bank,response_4,model="RSM")
eap_est_rsm(bank,response_5)
catR::eapEst(bank,response_5,model="RSM")
# STANDARD ERROR ESTIMATION
eap_se_rsm(eap_est_rsm(bank,response_1),bank,response_1)
catR::eapSem(eap_est_rsm(bank,response_1),bank,response_1,model="RSM")
eap_se_rsm(eap_est_rsm(bank,response_2),bank,response_2)
catR::eapSem(eap_est_rsm(bank,response_2),bank,response_2,model="RSM")
eap_se_rsm(eap_est_rsm(bank,response_3),bank,response_3)
catR::eapSem(eap_est_rsm(bank,response_3),bank,response_3,model="RSM")
eap_se_rsm(eap_est_rsm(bank,response_4),bank,response_4)
catR::eapSem(eap_est_rsm(bank,response_4),bank,response_4,model="RSM")
eap_se_rsm(eap_est_rsm(bank,response_5),bank,response_5)
catR::eapSem(eap_est_rsm(bank,response_5),bank,response_5,model="RSM")
##########################################################################################
# EXAMPLE 2
##########################################################################################
# effect of the integration bounds and of the number of quadrature points
response_1<-c(4,4,4,4,4)
eap_est_rsm(bank,response_1,lower=-4,upper=4)
eap_est_rsm(bank,response_1,lower=-3,upper=3)
eap_est_rsm(bank,response_1,nqp=33)
eap_est_rsm(bank,response_1,nqp=101)
# effect of the prior
eap_est_rsm(bank,response_1,priorPar=c(0,1))
eap_est_rsm(bank,response_1,priorPar=c(0,2))
# effect of the metric constant
eap_est_rsm(bank,response_1,D=1)
eap_est_rsm(bank,response_1,D=1.702)
##########################################################################################
# EXAMPLE 3
##########################################################################################
# items do not all need the same number of categories
# item 5 below is a 4 point item so its last threshold is padded with NA
# its responses must then be scored 0 to 3
bank<-matrix(c(lambdaj,delta1,delta2,delta3,c(delta4[1:4],NA)),nrow=5,
             dimnames=list(c(1,2,3,4,5),c("lambdaj","delta1","delta2","delta3","delta4")))
Pi_rsm(theta=0,bank)$Pi
response_1<-c(4,3,2,1,3)
eap_est_rsm(bank,response_1)
eap_se_rsm(eap_est_rsm(bank,response_1),bank,response_1)

