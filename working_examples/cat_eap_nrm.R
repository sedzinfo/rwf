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
#' @title compute category response probabilities and derivatives under the nominal response model
#' @description returns the category response probabilities for a given ability value and a \cr
#'              given matrix of item parameters under Bock nominal response model (NRM) \cr
#'              returns the first derivatives of the category response probabilities
#' @param theta ability
#' @param bank item parameters one row per item \cr
#'             the columns come in pairs alpha_jk and c_jk for the categories 1 to m \cr
#'             so the columns are alpha1 c1 alpha2 c2 up to alpham cm \cr
#'             alpha_jk is the slope and c_jk the intercept of category k \cr
#'             category 0 is the reference category with slope 0 and intercept 0 so it \cr
#'             has no columns \cr
#'             the categories do not need to be ordered which is what makes the model \cr
#'             nominal \cr
#'             an item with fewer categories than the widest item is padded with NA pairs \cr
#'             a mirt model fitted with itemtype="nominal" converts with \cr
#'             pars<-coef(model,simplify=TRUE)$items \cr
#'             alpha<-pars[,"a1"]*pars[,paste("ak",1:m,sep="")] \cr
#'             cj<-pars[,paste("d",1:m,sep="")] \cr
#'             bank<-cbind(alpha,cj)[,order(rep(1:m,2))]
#' @param D metric constant kept for the same interface as the other files \cr
#'          the nominal response model has no metric constant because any constant is \cr
#'          absorbed in the slopes so D is not used and catR ignores it too
#' @note this function should return the same result as catR::Pi(model="NRM") \cr
#'       the number of response categories is ncol(bank)/2+1 so a 5 point Likert scale \cr
#'       scored 0 1 2 3 4 needs a bank with 8 columns \cr
#'       the probability of category k is \cr
#'       P(X=k|theta)=exp(alpha_jk*theta+c_jk)/sum over all categories \cr
#'       with alpha_j0*theta+c_j0 equal to zero \cr
#'       log(P(X=k)/P(X=0))=alpha_jk*theta+c_jk is a straight line so the most \cr
#'       probable category at theta is the category with the highest line \cr
#'       at very high theta that is the category with the largest slope and at very low \cr
#'       theta the category with the smallest slope \cr
#'       a category whose line is never on top is never the most probable category \cr
#'       the partial credit model is the nominal model with alpha_jk=k and \cr
#'       c_jk=-(delta_j1+...+delta_jk) and the generalized partial credit model \cr
#'       multiplies both by the item discrimination \cr
#'       the exponent of category k grows by alpha_jk when theta grows by one so the \cr
#'       derivative uses gamma*alpha_jk and is exact
#' @return Pi   category response probabilities one row per item one column per category \cr
#'         dPi  first derivatives of the category response probabilities
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
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")))
#' catR::Pi(th=0,bank,model="NRM") # this will work with catR package installed
#' Pi_nrm(theta=0,bank)
#' v<-seq(-6,6,by=.1)
#' y_axis_response_probability<-list()
#' for(i in v) y_axis_response_probability[[toString(i)]]<-Pi_nrm(theta=i,bank)$Pi[1,]
#' df_rp<-data.frame(x=v,
#'                   matrix(unlist(y_axis_response_probability),
#'                          nrow=length(y_axis_response_probability),byrow=TRUE))
#' plot(x=df_rp$x,y=df_rp$X1,xlab=expression(theta),ylab=expression(P(theta)),
#'      main="category response probabilities item 1",type="l",col="red",ylim=c(0,1))
#' lines(y=df_rp$X2,x=v,col="green")
#' lines(y=df_rp$X3,x=v,col="blue")
#' lines(y=df_rp$X4,x=v,col="yellow")
#' lines(y=df_rp$X5,x=v,col="orange")
Pi_nrm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  ncat<-ncol(bank)/2+1
  Pi<-dPi<-matrix(NA,nrow(bank),ncat)
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
#'       test information is the sum of the item informations
#' @return Ii item information for each item
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
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")))
#' catR::Ii(th=0,bank,model="NRM") # this will work with catR package installed
#' Ii_nrm(theta=0,bank)
#' sum(Ii_nrm(theta=0,bank)$Ii) # test information
#' # the information is the variance of the slope of the category chosen
#' P<-Pi_nrm(theta=0,bank)$Pi
#' slopes<-cbind(0,bank[,c(1,3,5,7)])
#' rowSums(P*slopes^2)-rowSums(P*slopes)^2
#' v<-seq(-4,4,by=.1)
#' info<-matrix(NA,length(v),nrow(bank))
#' for (i in 1:length(v)) info[i,]<-Ii_nrm(theta=v[i],bank)$Ii
#' plot(x=v,y=info[,1],xlab=expression(theta),ylab="information",
#'      main="item information curves",type="l",col="red",ylim=c(0,max(info)))
#' lines(y=info[,2],x=v,col="green")
#' lines(y=info[,3],x=v,col="blue")
#' lines(y=info[,4],x=v,col="yellow")
#' lines(y=info[,5],x=v,col="orange")
#' plot(x=v,y=rowSums(info),xlab=expression(theta),ylab="information",
#'      main="test information",type="l")
Ii_nrm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  prob<-Pi_nrm(theta,bank,D=D)
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
#' @param D metric constant kept for the same interface as the other files and not used
#' @param randomesque number of most informative items to draw at random from \cr
#'                    1 is pure maximum information and 3 to 5 spreads item exposure
#' @note this function should return the same result as \cr
#'       catR::nextItem(itemBank,model="NRM",theta,out,criterion="MFI") when \cr
#'       randomesque is 1 and the most informative item is unique \cr
#'       when several items tie exactly catR draws one of them at random while this \cr
#'       function takes the first \cr
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
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")))
#' catR::nextItem(bank,model="NRM",theta=0,criterion="MFI") # with catR installed
#' next_item_nrm(theta=0,bank)
#' next_item_nrm(theta=0,bank,out=c(2))
#' catR::nextItem(bank,model="NRM",theta=1.5,criterion="MFI") # with catR installed
#' next_item_nrm(theta=1.5,bank)
#' # a short adaptive test driven by the functions in this file
#' responses<-c()
#' administered<-c()
#' theta<-0
#' for (step in 1:4) {
#'   item<-next_item_nrm(theta,bank,out=administered)$item
#'   administered<-c(administered,item)
#'   responses<-c(responses,3) # replace by the real response scored 0 to m
#'   theta<-eap_est_nrm(bank[administered,,drop=FALSE],responses)
#'   cat("step",step,"item",item,"theta",round(theta,4),
#'       "se",round(eap_se_nrm(theta,bank[administered,,drop=FALSE],responses),4),"\n")
#' }
next_item_nrm<-function(theta,bank,out=NULL,D=1,randomesque=1) {
  bank<-rbind(bank)
  available<-setdiff(1:nrow(bank),out)
  if (length(available)==0) stop("no item left in the bank",call.=FALSE)
  info<-Ii_nrm(theta,bank[available,,drop=FALSE],D=D)$Ii
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
#' @param D metric constant kept for the same interface as the other files and not used
#' @note this is the polytomous counterpart of prod(Pi^x*(1-Pi)^(1-x)) used for the 4PL \cr
#'       model \cr
#'       Pi_nrm returns a matrix so the response of item i selects the column x[i]+1 \cr
#'       the +1 is index bookkeeping because categories start at 0 and R columns start \cr
#'       at 1 \cr
#'       the responses are multiplied across items under the local independence assumption \cr
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
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")))
#' response<-c(4,3,2,1,0)
#' likelihood_nrm(theta=0,bank=bank,x=response)
#' v<-seq(-4,4,by=.1)
#' lik<-c()
#' for (i in 1:length(v)) lik[i]<-likelihood_nrm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=lik,xlab=expression(theta),ylab="likelihood",
#'      main="likelihood of the response pattern",type="l")
likelihood_nrm<-function(theta,bank,x,D=1) {
  prob<-Pi_nrm(theta,bank,D=D)$Pi
  result<-1
  for (i in 1:length(x)) result<-result*prob[i,x[i]+1]
  return(result)
}
##########################################################################################
# EAP ESTIMATION
##########################################################################################
#' @title compute theta EAP estimation under the nominal response model
#' @param bank matrix of item parameters
#' @param x vector of item responses scored 0 to m
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
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")))
#' response<-c(4,3,2,1,0)
#' catR::eapEst(bank,response,model="NRM") # this will work with catR package installed
#' eap_est_nrm(bank,response)
eap_est_nrm<-function (bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-s[i]*density_function(s[i],priorPar[1],priorPar[2])*likelihood_nrm(s[i],bank,x,D=D)
    return(res)
  }
  h<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-density_function(s[i],priorPar[1],priorPar[2])*likelihood_nrm(s[i],bank,x,D=D)
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
#' @param x vector of item responses scored 0 to m
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
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")))
#' response<-c(4,3,2,1,0)
#' catR::eapSem(0,bank,response,model="NRM") # this will work with catR package installed
#' eap_se_nrm(theta=0,bank=bank,x=response)
#' v<-seq(-3,3,by=.1)
#' se<-c()
#' for (i in 1:length(v)) se[i]<-eap_se_nrm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error with a mixed response pattern")
#' response<-c(0,0,0,0,0)
#' for (i in 1:length(v)) se[i]<-eap_se_nrm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error when all responses are in category 0")
#' response<-c(4,4,4,4,4)
#' for (i in 1:length(v)) se[i]<-eap_se_nrm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error when all responses are in category 4")
eap_se_nrm<-function(theta,bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-(X[i]-theta)^2*density_function(X[i],priorPar[1],priorPar[2])*likelihood_nrm(X[i],bank,x,D=D)
    return(res)
  }
  h<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-density_function(X[i],priorPar[1],priorPar[2])*likelihood_nrm(X[i],bank,x,D=D)
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
# 5 response categories coded 0 1 2 3 4
# every category except the reference category 0 has its own slope and intercept
alpha1<-c(0.614,0.782,0.297,1.036,0.521)
c1<-c(1.187,0.906,1.523,0.418,0.694)
alpha2<-c(1.395,1.487,1.103,0.688,1.214)
c2<-c(1.812,1.093,2.176,1.407,1.032)
alpha3<-c(2.106,2.391,1.724,2.012,1.873)
c3<-c(1.264,0.517,1.936,0.793,0.186)
alpha4<-c(2.918,3.087,2.215,2.604,3.382)
c4<-c(0.097,-0.814,1.012,-0.296,-1.618)
bank<-matrix(c(alpha1,c1,alpha2,c2,alpha3,c3,alpha4,c4),nrow=5,
             dimnames=list(c(1,2,3,4,5),c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")))
response_1<-c(0,0,0,0,0)
response_2<-c(1,1,1,1,1)
response_3<-c(2,2,2,2,2)
response_4<-c(3,3,3,3,3)
response_5<-c(4,4,4,4,4)
# ABILITY ESTIMATION
eap_est_nrm(bank,response_1)
catR::eapEst(bank,response_1,model="NRM")
eap_est_nrm(bank,response_2)
catR::eapEst(bank,response_2,model="NRM")
eap_est_nrm(bank,response_3)
catR::eapEst(bank,response_3,model="NRM")
eap_est_nrm(bank,response_4)
catR::eapEst(bank,response_4,model="NRM")
eap_est_nrm(bank,response_5)
catR::eapEst(bank,response_5,model="NRM")
# STANDARD ERROR ESTIMATION
eap_se_nrm(eap_est_nrm(bank,response_1),bank,response_1)
catR::eapSem(eap_est_nrm(bank,response_1),bank,response_1,model="NRM")
eap_se_nrm(eap_est_nrm(bank,response_2),bank,response_2)
catR::eapSem(eap_est_nrm(bank,response_2),bank,response_2,model="NRM")
eap_se_nrm(eap_est_nrm(bank,response_3),bank,response_3)
catR::eapSem(eap_est_nrm(bank,response_3),bank,response_3,model="NRM")
eap_se_nrm(eap_est_nrm(bank,response_4),bank,response_4)
catR::eapSem(eap_est_nrm(bank,response_4),bank,response_4,model="NRM")
eap_se_nrm(eap_est_nrm(bank,response_5),bank,response_5)
catR::eapSem(eap_est_nrm(bank,response_5),bank,response_5,model="NRM")
##########################################################################################
# EXAMPLE 2
##########################################################################################
# effect of the integration bounds and of the number of quadrature points
response_1<-c(4,4,4,4,4)
eap_est_nrm(bank,response_1,lower=-4,upper=4)
eap_est_nrm(bank,response_1,lower=-3,upper=3)
eap_est_nrm(bank,response_1,nqp=33)
eap_est_nrm(bank,response_1,nqp=101)
# effect of the prior
eap_est_nrm(bank,response_1,priorPar=c(0,1))
eap_est_nrm(bank,response_1,priorPar=c(0,2))
# the metric constant has no effect because the slopes absorb it
eap_est_nrm(bank,response_1,D=1)
eap_est_nrm(bank,response_1,D=1.702)
##########################################################################################
# EXAMPLE 3
##########################################################################################
# item 4 has alpha2<alpha1 so its categories are not ordered
# its category 1 line alpha1*theta+c1 is never on top so category 1 is never the most
# probable category at any theta although its probability stays positive
v<-seq(-4,4,by=.01)
modal<-c()
for (i in 1:length(v)) modal[i]<-which.max(Pi_nrm(theta=v[i],bank)$Pi[4,])-1
table(modal)
max(sapply(v,function(t) Pi_nrm(theta=t,bank)$Pi[4,2]))
# the partial credit model is the nominal model with alphajk=k and cjk=-(deltaj1+...+deltajk)
# the PCM bank of cat_eap_pcm.R gives the same probabilities and estimates through Pi_nrm
bank_pcm<-matrix(c(-1.853,-2.214,-0.936,-1.508,-0.412,
                   -0.627,-0.504,-1.215,-0.183,0.338,
                   0.418,0.692,0.284,0.735,1.102,
                   1.636,1.927,1.405,2.118,2.285),nrow=5,
                 dimnames=list(c(1,2,3,4,5),c("deltaj1","deltaj2","deltaj3","deltaj4")))
bank_nrm<-cbind(1,-bank_pcm[,1],2,-rowSums(bank_pcm[,1:2]),
                3,-rowSums(bank_pcm[,1:3]),4,-rowSums(bank_pcm[,1:4]))
colnames(bank_nrm)<-c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")
bank_nrm
Pi_nrm(theta=0,bank_nrm)$Pi
catR::Pi(th=0,bank_pcm,model="PCM")$Pi
response_1<-c(4,3,2,1,0)
eap_est_nrm(bank_nrm,response_1)
catR::eapEst(bank_pcm,response_1,model="PCM")
# items do not all need the same number of categories
# item 5 below has 4 categories so its last pair is padded with NA
# its responses must then be coded 0 to 3
bank<-matrix(c(alpha1,c1,alpha2,c2,alpha3,c3,c(alpha4[1:4],NA),c(c4[1:4],NA)),nrow=5,
             dimnames=list(c(1,2,3,4,5),c("alpha1","c1","alpha2","c2","alpha3","c3","alpha4","c4")))
Pi_nrm(theta=0,bank)$Pi
response_1<-c(4,3,2,1,3)
eap_est_nrm(bank,response_1)
catR::eapEst(bank,response_1,model="NRM")
eap_se_nrm(eap_est_nrm(bank,response_1),bank,response_1)

