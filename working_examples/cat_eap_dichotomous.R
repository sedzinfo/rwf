##########################################################################################
# DENSITY FUNCTION
##########################################################################################
#' @title compute normal density function
#' @param x 
#' @param mean mean for normal distribution this should be set to 0
#' @param sd standard deviation for normal distribution that should be set to 1
#' @note this function should return the same result as the stats::dnorm function
#' @export
#' @examples
#' v<-seq(-3,3,by=.1)
#' plot(y=density_function(x=v),x=v)
#' plot(y=density_function(x=v,mean=1),x=v)
#' plot(y=density_function(x=v,mean=0,sd=2),x=v)
#' plot(y=dnorm(v),x=v,main="normal curve")
#' data.frame(x1=dnorm(v),x2=density_function(v))
#' density_function(x=0)
#' dnorm(x=0)
density_function<-function(x,mean=0,sd=1) {
  e<-2.71828
  # e<-exp(1)
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
#' bank<-matrix(c(0.7521,0.8083,1.1857,0.5481,0.5695,-1.5521,-0.9083,0.1857,0.5481,1.5695,
#'                0,0,0,0,0,1,1,1,1,1),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),c("a","b","c","d")))
#' catR::Pi(th=0,bank) # this will work with catR package installed
#' Pi(theta=0,bank)
#' v<-seq(-6,6,by=.1)
#' y_axis_response_probability<-y_axis_d1<-y_axis_d2<-list()
#' for(i in v) {
#'   y_axis_response_probability[[toString(i)]]<-Pi(theta=i,bank)$Pi
#'   y_axis_d1[[toString(i)]]<-Pi(theta=i,bank)$dPi
#'   y_axis_d2[[toString(i)]]<-Pi(theta=i,bank)$d2Pi
#' }
#' df_rp<-data.frame(x=v,
#'                   matrix(unlist(y_axis_response_probability),
#'                          nrow=length(y_axis_response_probability),byrow=T))
#' plot(x=df_rp$x,y=df_rp$X1,xlab=expression(theta),ylab=expression(P(theta)),
#'      main="response probability",type="l",col="red")
#' lines(y=df_rp$X2,x=v,col="green")
#' lines(y=df_rp$X3,x=v,col="blue")
#' lines(y=df_rp$X4,x=v,col="yellow")
#' lines(y=df_rp$X5,x=v,col="orange")
#' df_1d<-data.frame(x=v,
#'                   matrix(unlist(y_axis_d1),
#'                          nrow=length(y_axis_d1),byrow=T))
#' plot(x=df_1d$x,y=df_1d$X1,xlab=expression(theta),ylab=expression(P(theta)),
#'      main="response probabilities and first derivatives ",type="l",col="red",ylim=c(0,1))
#' lines(y=df_1d$X2,x=v,col="green")
#' lines(y=df_1d$X3,x=v,col="blue")
#' lines(y=df_1d$X4,x=v,col="yellow")
#' lines(y=df_1d$X5,x=v,col="orange")
#' lines(y=df_rp$X1,x=v,col="red")
#' lines(y=df_rp$X2,x=v,col="green")
#' lines(y=df_rp$X3,x=v,col="blue")
#' lines(y=df_rp$X4,x=v,col="yellow")
#' lines(y=df_rp$X5,x=v,col="orange")
Pi<-function(theta,bank,D=1) {
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
  # d2Pi<-D^2*a^2*e*(1-e)*(d-c)/(1+e)^3
  # d3Pi<-D^3*a^3*e*(d-c)*(e^2-4*e+1)/(1+e)^4
  result<-list(Pi=Pi,dPi=dPi)
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
#' bank<-matrix(c(0.7521,0.8083,1.1857,0.5481,0.5695,-1.5521,-0.9083,0.1857,0.5481,1.5695,
#'                0,0,0,0,0,1,1,1,1,1),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),c("a","b","c","d")))
#' response<-c(1,0,0,0,0)
#' catR::eapEst(bank,response) # this will work with catR package installed
#' eap_est(bank,response)
eap_est<-function (bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  L<-function(th,bank,x)
    prod(Pi(th,bank,D=D)$Pi^x*(1-Pi(th,bank,D=D)$Pi)^(1-x))
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
#' bank<-matrix(c(0.7521,0.8083,1.1857,0.5481,0.5695,-1.5521,-0.9083,0.1857,0.5481,1.5695,
#'                0,0,0,0,0,1,1,1,1,1),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),c("a","b","c","d")))
#' response<-c(0,0,0,0,0)
#' catR::eapSem(0,bank,response) # this will work with catR package installed
#' eap_se(theta=0,bank=bank,x=response)
#' v<-seq(-3,3,by=.1)
#' se<-c()
#' for (i in 1:length(v))
#'   se[i]<-eap_se(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error when all responses are wrong")
#' response<-c(1,1,1,1,1)
#' for (i in 1:length(v))
#'   se[i]<-eap_se(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error when all responses are correct")
#' response<-c(1,0,1,0,0)
#' for (i in 1:length(v))
#'   se[i]<-eap_se(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error with 2 correct responses")
eap_se<-function(theta,bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  L<-function(theta,bank,x) {
    res<-NULL
    res<-Pi(theta,bank,D=D)$Pi
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
a<-c(0.7521,0.8083,1.1857,0.5481,0.5695)
b<-c(-1.5521,-0.9083,0.1857,0.5481,1.5695)
c<-c(0,0,0,0,0)
d<-c(1,1,1,1,1)
bank<-matrix(c(a,b,c,d),nrow=5,dimnames=list(c(1,2,3,4,5),c("a","b","c","d")))
response_1<-c(1,0,0,0,0)
response_2<-c(1,1,0,0,0)
response_3<-c(1,1,1,0,0)
response_4<-c(1,1,1,1,0)
response_5<-c(1,1,1,1,1)
# ABILITY ESTIMATION
eap_est(bank,response_1)
eap_est(bank,response_2)
eap_est(bank,response_3)
eap_est(bank,response_4)
eap_est(bank,response_5)
# STANDARD ERROR ESTIMATION
eap_se(0,bank,response_1)
eap_se(0,bank,response_2)
eap_se(0,bank,response_3)
eap_se(0,bank,response_4)
eap_se(0,bank,response_5)
##########################################################################################
# EXAMPLE 2
##########################################################################################
a<-c(1,1,1,1,1)
b<-c(-1.5521,-0.9083,0.1857,0.5481,1.5695)
c<-c(0,0,0,0,0)
d<-c(1,1,1,1,1)
bank<-matrix(c(a,b,c,d),nrow=5,dimnames=list(c(1,2,3,4,5),c("a","b","c","d")))
response_1<-c(1,0,0,0,0)
response_2<-c(1,1,0,0,0)
response_3<-c(1,1,1,0,0)
response_4<-c(1,1,1,1,0)
response_5<-c(1,1,1,1,1)
# ABILITY ESTIMATION
eap_est(bank,response_1)
eap_est(bank,response_2)
eap_est(bank,response_3)
eap_est(bank,response_4)
eap_est(bank,response_5)
# STANDARD ERROR ESTIMATION
eap_se(0,bank,response_1)
eap_se(0,bank,response_2)
eap_se(0,bank,response_3)
eap_se(0,bank,response_4)
eap_se(0,bank,response_5)
##########################################################################################
# EXAMPLE 3
##########################################################################################
a<-c(1,1,1,1,1)
b<-c(-1.3958,0.5154,0.7498,0.1761,0.4889)
c<-c(0,0,0,0,0)
d<-c(1,1,1,1,1)
response_1<-c(1,1,1,1,1)
bank<-matrix(c(a,b,c,d),nrow=5,dimnames=list(c(1,2,3,4,5),c("a","b","c","d")))
eap_est(bank,response_1)
eap_se(eap_est(bank,response_1),bank,response_1)

a<-c(1,1,1,1)
b<-c(-1.3958,0.5154,0.7498,0.1761)
c<-c(0,0,0,0)
d<-c(1,1,1,1)
response_1<-c(1,1,1,1)
bank<-matrix(c(a,b,c,d),nrow=4,dimnames=list(c(1,2,3,4),c("a","b","c","d")))
eap_est(bank,response_1)
eap_se(eap_est(bank,response_1),bank,response_1)

a<-c(1,1,1)
b<-c(-1.3958,0.5154,0.7498)
c<-c(0,0,0)
d<-c(1,1,1)
response_1<-c(1,1,1)
bank<-matrix(c(a,b,c,d),nrow=3,dimnames=list(c(1,2,3),c("a","b","c","d")))
eap_est(bank,response_1)
eap_se(eap_est(bank,response_1),bank,response_1)

a<-c(1,1,1)
b<-c(1.3958,-0.5154,-0.7498)
c<-c(0,0,0)
d<-c(1,1,1)
response_1<-c(1,1,1)
bank<-matrix(c(a,b,c,d),nrow=3,dimnames=list(c(1,2,3),c("a","b","c","d")))
eap_est(bank,response_1)
eap_se(eap_est(bank,response_1),bank,response_1)

a<-c(1,1)
b<-c(-1.3958,0.5154)
c<-c(0,0)
d<-c(1,1)
response_1<-c(1,1)
bank<-matrix(c(a,b,c,d),nrow=2,dimnames=list(c(1,2),c("a","b","c","d")))
eap_est(bank,response_1)
eap_se(eap_est(bank,response_1),bank,response_1)

a<-c(1,1)
b<-c(0.5154,0.7498)
c<-c(0,0)
d<-c(1,1)
response_1<-c(1,1)
bank<-matrix(c(a,b,c,d),nrow=2,dimnames=list(c(1,2),c("a","b","c","d")))
eap_est(bank,response_1)
eap_se(eap_est(bank,response_1),bank,response_1)

a<-c(1,1,1)
b<-c(-1,0,1)
c<-c(0,0,0)
d<-c(1,1,1)
response_1<-c(1,1,1)
bank<-matrix(c(a,b,c,d),nrow=3,dimnames=list(c(1,2,3),c("a","b","c","d")))
eap_est(bank,response_1)
eap_se(eap_est(bank,response_1),bank,response_1)

a<-c(1,1,1)
b<-c(-1.3958,0.5154,0.7498)
c<-c(0,0,0)
d<-c(1,1,1)
response_1<-c(1,1,1)
bank<-matrix(c(a,b,c,d),nrow=3,dimnames=list(c(1,2,3),c("a","b","c","d")))
eap_est(bank,response_1,lower=-4,upper=4)
eap_est(bank,response_1,lower=-3,upper=3)
eap_se(eap_est(bank,response_1),bank,response_1)

