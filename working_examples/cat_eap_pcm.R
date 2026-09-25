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
#'             columns of coef(model,IRTpars=TRUE,simplify=TRUE)$items to be used with D=1 \cr
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
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("deltaj1","deltaj2","deltaj3","deltaj4")))
#' catR::Pi(th=0,bank,model="PCM") # this will work with catR package installed
#' Pi_pcm(theta=0,bank)
#' v<-seq(-6,6,by=.1)
#' y_axis_response_probability<-list()
#' for(i in v) y_axis_response_probability[[toString(i)]]<-Pi_pcm(theta=i,bank)$Pi[1,]
#' df_rp<-data.frame(x=v,
#'                   matrix(unlist(y_axis_response_probability),
#'                          nrow=length(y_axis_response_probability),byrow=TRUE))
#' plot(x=df_rp$x,y=df_rp$X1,xlab=expression(theta),ylab=expression(P(theta)),
#'      main="category response probabilities item 1",type="l",col="red",ylim=c(0,1))
#' lines(y=df_rp$X2,x=v,col="green")
#' lines(y=df_rp$X3,x=v,col="blue")
#' lines(y=df_rp$X4,x=v,col="yellow")
#' lines(y=df_rp$X5,x=v,col="orange")
#' abline(v=bank[1,],lty=2) # the curves of adjacent categories cross at the steps
Pi_pcm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  ncat<-ncol(bank)+1
  Pi<-dPi<-matrix(NA,nrow(bank),ncat)
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
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("deltaj1","deltaj2","deltaj3","deltaj4")))
#' catR::Ii(th=0,bank,model="PCM") # this will work with catR package installed
#' Ii_pcm(theta=0,bank)
#' sum(Ii_pcm(theta=0,bank)$Ii) # test information
#' # the information is the variance of the item score
#' P<-Pi_pcm(theta=0,bank)$Pi
#' as.numeric(P%*%(0:4)^2-(P%*%(0:4))^2)
#' v<-seq(-4,4,by=.1)
#' info<-matrix(NA,length(v),nrow(bank))
#' for (i in 1:length(v)) info[i,]<-Ii_pcm(theta=v[i],bank)$Ii
#' plot(x=v,y=info[,1],xlab=expression(theta),ylab="information",
#'      main="item information curves",type="l",col="red",ylim=c(0,max(info)))
#' lines(y=info[,2],x=v,col="green")
#' lines(y=info[,3],x=v,col="blue")
#' lines(y=info[,4],x=v,col="yellow")
#' lines(y=info[,5],x=v,col="orange")
#' plot(x=v,y=rowSums(info),xlab=expression(theta),ylab="information",
#'      main="test information",type="l")
Ii_pcm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  prob<-Pi_pcm(theta,bank,D=D)
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
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("deltaj1","deltaj2","deltaj3","deltaj4")))
#' catR::nextItem(bank,model="PCM",theta=0,criterion="MFI") # with catR installed
#' next_item_pcm(theta=0,bank)
#' next_item_pcm(theta=0,bank,out=c(5))
#' catR::nextItem(bank,model="PCM",theta=-1.5,criterion="MFI") # with catR installed
#' next_item_pcm(theta=-1.5,bank)
#' # a short adaptive test driven by the functions in this file
#' responses<-c()
#' administered<-c()
#' theta<-0
#' for (step in 1:4) {
#'   item<-next_item_pcm(theta,bank,out=administered)$item
#'   administered<-c(administered,item)
#'   responses<-c(responses,3) # replace by the real response scored 0 to m
#'   theta<-eap_est_pcm(bank[administered,,drop=FALSE],responses)
#'   cat("step",step,"item",item,"theta",round(theta,4),
#'       "se",round(eap_se_pcm(theta,bank[administered,,drop=FALSE],responses),4),"\n")
#' }
next_item_pcm<-function(theta,bank,out=NULL,D=1,randomesque=1) {
  bank<-rbind(bank)
  available<-setdiff(1:nrow(bank),out)
  if (length(available)==0) stop("no item left in the bank",call.=FALSE)
  info<-Ii_pcm(theta,bank[available,,drop=FALSE],D=D)$Ii
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
#'       Pi_pcm returns a matrix so the response of item i selects the column x[i]+1 \cr
#'       the +1 is index bookkeeping because categories start at 0 and R columns start \cr
#'       at 1 \cr
#'       the responses are multiplied across items under the local independence assumption \cr
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
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("deltaj1","deltaj2","deltaj3","deltaj4")))
#' response<-c(4,3,2,1,0)
#' likelihood_pcm(theta=0,bank=bank,x=response)
#' v<-seq(-4,4,by=.1)
#' lik<-c()
#' for (i in 1:length(v)) lik[i]<-likelihood_pcm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=lik,xlab=expression(theta),ylab="likelihood",
#'      main="likelihood of the response pattern",type="l")
likelihood_pcm<-function(theta,bank,x,D=1) {
  prob<-Pi_pcm(theta,bank,D=D)$Pi
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
#'       pars<-coef(model,IRTpars=TRUE,simplify=TRUE)
#' @export
#' @examples
#' bank<-matrix(c(-1.853,-2.214,-0.936,-1.508,-0.412,
#'                -0.627,-0.504,-1.215,-0.183,0.338,
#'                0.418,0.692,0.284,0.735,1.102,
#'                1.636,1.927,1.405,2.118,2.285),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("deltaj1","deltaj2","deltaj3","deltaj4")))
#' response<-c(4,3,2,1,0)
#' catR::eapEst(bank,response,model="PCM") # this will work with catR package installed
#' eap_est_pcm(bank,response)
eap_est_pcm<-function (bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-s[i]*density_function(s[i],priorPar[1],priorPar[2])*likelihood_pcm(s[i],bank,x,D=D)
    return(res)
  }
  h<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-density_function(s[i],priorPar[1],priorPar[2])*likelihood_pcm(s[i],bank,x,D=D)
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
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("deltaj1","deltaj2","deltaj3","deltaj4")))
#' response<-c(4,3,2,1,0)
#' catR::eapSem(0,bank,response,model="PCM") # this will work with catR package installed
#' eap_se_pcm(theta=0,bank=bank,x=response)
#' v<-seq(-3,3,by=.1)
#' se<-c()
#' for (i in 1:length(v)) se[i]<-eap_se_pcm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error with a mixed response pattern")
#' response<-c(0,0,0,0,0)
#' for (i in 1:length(v)) se[i]<-eap_se_pcm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error when all responses are in the lowest category")
#' response<-c(4,4,4,4,4)
#' for (i in 1:length(v)) se[i]<-eap_se_pcm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error when all responses are in the highest category")
eap_se_pcm<-function(theta,bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-(X[i]-theta)^2*density_function(X[i],priorPar[1],priorPar[2])*likelihood_pcm(X[i],bank,x,D=D)
    return(res)
  }
  h<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-density_function(X[i],priorPar[1],priorPar[2])*likelihood_pcm(X[i],bank,x,D=D)
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
# 5 point Likert scale scored 0 1 2 3 4
# deltaj1 to deltaj4 are all item specific
deltaj1<-c(-1.853,-2.214,-0.936,-1.508,-0.412)
deltaj2<-c(-0.627,-0.504,-1.215,-0.183,0.338)
deltaj3<-c(0.418,0.692,0.284,0.735,1.102)
deltaj4<-c(1.636,1.927,1.405,2.118,2.285)
bank<-matrix(c(deltaj1,deltaj2,deltaj3,deltaj4),nrow=5,
             dimnames=list(c(1,2,3,4,5),c("deltaj1","deltaj2","deltaj3","deltaj4")))
response_1<-c(0,0,0,0,0)
response_2<-c(1,1,1,1,1)
response_3<-c(2,2,2,2,2)
response_4<-c(3,3,3,3,3)
response_5<-c(4,4,4,4,4)
# ABILITY ESTIMATION
eap_est_pcm(bank,response_1)
catR::eapEst(bank,response_1,model="PCM")
eap_est_pcm(bank,response_2)
catR::eapEst(bank,response_2,model="PCM")
eap_est_pcm(bank,response_3)
catR::eapEst(bank,response_3,model="PCM")
eap_est_pcm(bank,response_4)
catR::eapEst(bank,response_4,model="PCM")
eap_est_pcm(bank,response_5)
catR::eapEst(bank,response_5,model="PCM")
# STANDARD ERROR ESTIMATION
eap_se_pcm(eap_est_pcm(bank,response_1),bank,response_1)
catR::eapSem(eap_est_pcm(bank,response_1),bank,response_1,model="PCM")
eap_se_pcm(eap_est_pcm(bank,response_2),bank,response_2)
catR::eapSem(eap_est_pcm(bank,response_2),bank,response_2,model="PCM")
eap_se_pcm(eap_est_pcm(bank,response_3),bank,response_3)
catR::eapSem(eap_est_pcm(bank,response_3),bank,response_3,model="PCM")
eap_se_pcm(eap_est_pcm(bank,response_4),bank,response_4)
catR::eapSem(eap_est_pcm(bank,response_4),bank,response_4,model="PCM")
eap_se_pcm(eap_est_pcm(bank,response_5),bank,response_5)
catR::eapSem(eap_est_pcm(bank,response_5),bank,response_5,model="PCM")
##########################################################################################
# EXAMPLE 2
##########################################################################################
# effect of the integration bounds and of the number of quadrature points
response_1<-c(4,4,4,4,4)
eap_est_pcm(bank,response_1,lower=-4,upper=4)
eap_est_pcm(bank,response_1,lower=-3,upper=3)
eap_est_pcm(bank,response_1,nqp=33)
eap_est_pcm(bank,response_1,nqp=101)
# effect of the prior
eap_est_pcm(bank,response_1,priorPar=c(0,1))
eap_est_pcm(bank,response_1,priorPar=c(0,2))
# effect of the metric constant
eap_est_pcm(bank,response_1,D=1)
eap_est_pcm(bank,response_1,D=1.702)
# the total score is a sufficient statistic
# three different patterns with a total score of 10 give the same estimate and standard error
response_1<-c(2,2,2,2,2)
response_2<-c(4,0,2,2,2)
response_3<-c(0,4,4,1,1)
eap_est_pcm(bank,response_1)
eap_est_pcm(bank,response_2)
eap_est_pcm(bank,response_3)
eap_se_pcm(eap_est_pcm(bank,response_1),bank,response_1)
eap_se_pcm(eap_est_pcm(bank,response_2),bank,response_2)
eap_se_pcm(eap_est_pcm(bank,response_3),bank,response_3)
##########################################################################################
# EXAMPLE 3
##########################################################################################
# item 3 has reversed steps deltaj2<deltaj1 so its category 1 is never the most probable
# category at any theta although its probability stays positive
v<-seq(-4,4,by=.01)
modal<-c()
for (i in 1:length(v)) modal[i]<-which.max(Pi_pcm(theta=v[i],bank)$Pi[3,])-1
table(modal)
max(sapply(v,function(t) Pi_pcm(theta=t,bank)$Pi[3,2]))
# the rating scale model is the partial credit model with deltajk=lambdaj+deltak
# the RSM bank of cat_eap_rsm.R gives the same probabilities through Pi_pcm
bank_rsm<-matrix(c(-0.560,-0.230,1.559,0.071,0.129,
                   rep(1.715,5),rep(0.461,5),rep(-1.265,5),rep(-0.687,5)),nrow=5,
                 dimnames=list(c(1,2,3,4,5),c("lambdaj","delta1","delta2","delta3","delta4")))
bank_pcm<-bank_rsm[,1]+bank_rsm[,2:5]
colnames(bank_pcm)<-c("deltaj1","deltaj2","deltaj3","deltaj4")
bank_pcm
Pi_pcm(theta=0,bank_pcm)$Pi
catR::Pi(th=0,bank_rsm,model="RSM")$Pi
# items do not all need the same number of categories
# item 5 below is a 4 point item so its last step is padded with NA
# its responses must then be scored 0 to 3
bank<-matrix(c(deltaj1,deltaj2,deltaj3,c(deltaj4[1:4],NA)),nrow=5,
             dimnames=list(c(1,2,3,4,5),c("deltaj1","deltaj2","deltaj3","deltaj4")))
Pi_pcm(theta=0,bank)$Pi
response_1<-c(4,3,2,1,3)
eap_est_pcm(bank,response_1)
catR::eapEst(bank,response_1,model="PCM")
eap_se_pcm(eap_est_pcm(bank,response_1),bank,response_1)

