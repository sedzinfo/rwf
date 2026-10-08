##########################################################################################
# COMPUTE THETA
##########################################################################################
#' @title Compute theta for unidimensional models
#' @param a numeric discrimination parameter
#' @param b numeric difficulty parameter
#' @param g numeric guessing parameter
#' @param i numeric inattentiveness parameter
#' @param d numeric scaling constant usually a value 1.749 or 1.702
#' @param theta numeric or vector theta
#' @note when scaling constant=1 it has no effect in equation\cr
#'       when inattentiveness=1 and guessing=0 function computes a 2PL score\cr
#'       when inattentiveness=1 and guessing!=0 function computes a 3PL score\cr
#'       when inattentiveness!=1 and guessing!=0 function computes a 4PL score\cr
#' @keywords IRT unidimensional
#' @export
#' @examples
#' compute_unidimensional_theta(a=10,b=0)
#' x<-seq(-3,3,by=.01)
#' plot(compute_unidimensional_theta(a=5,b=0,theta=x),x=x)
#' plot(compute_unidimensional_theta(a=5,b=-1,theta=x),x=x)
#' plot(compute_unidimensional_theta(a=5,b=1,theta=x),x=x)
#' plot(compute_unidimensional_theta(a=.1,b=0,theta=x),x=x)
#' plot(compute_unidimensional_theta(a=1,b=0,theta=x),x=x)
#' plot(compute_unidimensional_theta(a=10,b=0,theta=x),x=x)
#' plot(compute_unidimensional_theta(a=10,b=0,g=0,theta=x),x=x)
#' plot(compute_unidimensional_theta(a=10,b=0,g=.1,theta=x),x=x)
#' plot(compute_unidimensional_theta(a=10,b=0,g=.5,theta=x),x=x)
#' plot(compute_unidimensional_theta(a=10,b=0,g=0,i=1,theta=x),x=x)
#' plot(compute_unidimensional_theta(a=10,b=0,g=0,i=.9,theta=x),x=x)
#' plot(compute_unidimensional_theta(a=10,b=0,g=0,i=.6,theta=x),x=x)
compute_unidimensional_theta<-function(a,b=0,g=0,i=1,d=1.702,theta=0) {
  e<-exp(-a*d*(theta-b))
  denom<-1+e
  renum<-1-g
  denom[denom==0]<-1e-22
  result<-g+renum/denom
  return(result)
}
##########################################################################################
# ESTIMATE ABILITY
##########################################################################################
#' @title Compute theta for unidimensional models
#' @param a numeric vector discrimination parameters
#' @param b numeric vector difficulty parameters
#' @param g numeric vector guessing parameters
#' @param d numeric scaling constant usually it is a value that approximating 1.749
#' @param u numeric vector responses
#' @param lim_theta vector minimum and maximum value of theta
#' @keywords IRT unidimensional
#' @export
#' @examples
#' a<-c(0.39,0.45,0.52,0.3,0.35,0.43,0.42,0.44,0.34,0.42)
#' b<-c(-1.96,-1.9,-1.38,-0.58,0.48,-0.81,-0.35,1.59,1.33,2.93)
#' u<-c(1,1,1,1,0,0,1,0,1,0)
#' # SHOULD RETURN 0.48402574251176
#' compute_unidimensional_ability(a=a,b=b,u=u,d=1.7,g=NULL)
#' a<-c(1.27,0.9,0.94,0.95,0.55,0.6,0.44,0.4)
#' b<-c(-0.54,0.18,0.21,1.26,1.73,-0.87,1.72,2.67)
#' u<-c(1,1,1,1,0,0,0,0)
#' # SHOULD RETURN 1.04621621510192
#' compute_unidimensional_ability(a=a,b=b,u=u,d=1.7,g=NULL)
#' a<-c(0.41,0.32,0.33,1.2,0.63,0.62,0.7,0.61,0.38,0.53,0.6,1.16)
#' b<-c(-1.4,-1.3,-1.17,0.2,0.71,0.86,-0.12,0.12,2.06,1.38,1.18,-0.33)
#' u<-c(1,0,1,1,0,0,0,1,1,0,1,0)
#' # SHOULD RETURN 0.0860506282671103
#' compute_unidimensional_ability(a=a,b=b,u=u,d=1.7,g=NULL)
compute_unidimensional_ability<-function(a,b,g=NULL,d=1.702,u,lim_theta=c(-6,6)) {
  temp_theta<-0
  computations<-data.frame()
  first_derivative<-function(a,g,d,u,p) {
    result<-(d*a*(u-p)*(p-g))/(p*(1-g))
    return(result)
  }
  second_derivative<-function(a,g,d,u,p) {
    result<-((d*a)/(1-g))^2*((p-g)*(1-p)*(u*g-p^2))/(p*p)
    return(result)
  }
  if(is.null(g))
    g<-rep(0,length(u))
  counter<-1
  repeat {
    counter<-counter+1
    sum_num<-sum_den<-0
    for (i in 1:length(u)) {
      itemtheta<-compute_unidimensional_theta(a=a[i],b=b[i],g=g[i],d=d,theta=temp_theta)
      deriv1<-first_derivative(a=a[i],g=g[i],d=d,u=u[i],itemtheta)
      deriv2<-second_derivative(a=a[i],g=g[i],d=d,u=u[i],itemtheta)
      sum_num<-sum_num+deriv1 # calculate delta for newton-raphson estimation for current item
      sum_den<-sum_den+deriv2 # calculate delta for newton-raphson estimation for current item
      # computations<-plyr::rbind.fill(computations,data.frame(itemtheta=itemtheta,
      #                            temp_theta=temp_theta,
      #                            deriv1=deriv1,
      #                            deriv2=deriv2,
      #                            sum_num=sum_num,
      #                            sum_den=sum_den,
      #                            a=a[i],g=g[i],d=d,u=u[i]))
    }
    delta<-sum_num/sum_den # newton-raphson correction
    difference<-temp_theta-delta
    if(is.nan(abs(difference-temp_theta)))
      break
    if(abs(temp_theta-difference)<0.0001)
      break
    if(counter>10)
      break
    temp_theta<-temp_theta-delta
  }
  if(temp_theta>lim_theta[2])
    temp_theta<-lim_theta[2]
  if(temp_theta<lim_theta[1])
    temp_theta<-lim_theta[1]
  return(temp_theta)
}
##########################################################################################
# COMPUTE ITEM INFORMATION 1PL
##########################################################################################
#' @title Compute item information for 1PL model
#' @param b numeric difficulty parameter
#' @param theta numeric theta
#' @keywords IRT unidimensional
#' @export
#' @examples
#' compute_info_1pl(b=1,theta=-3)
#' compute_info_1pl(b=1,theta=-2)
#' compute_info_1pl(b=1,theta=-1)
#' compute_info_1pl(b=1,theta=0)
#' compute_info_1pl(b=1,theta=1)
#' compute_info_1pl(b=1,theta=2)
#' compute_info_1pl(b=1,theta=3)
#' ti<-compute_info_1pl(b=1,theta=seq(-6,6,by=.01)) # test information
#' plot(ti,x=seq(-6,6,by=.01))
compute_info_1pl<-function(b,theta) {
  p_theta<-1/(1+exp(-(theta-b)))
  q<-1-p_theta
  info<-p_theta*q
  return(info)
}
##########################################################################################
# COMPUTE ITEM INFORMATION 2PL
##########################################################################################
#' @title Compute item information for 2PL model
#' @param a numeric discrimination parameter
#' @param b numeric difficulty parameter
#' @param theta numeric theta
#' @keywords IRT unidimensional
#' @export
#' @examples
#' compute_info_2pl(a=1.5,b=1,theta=-3)
#' compute_info_2pl(a=1.5,b=1,theta=-2)
#' compute_info_2pl(a=1.5,b=1,theta=-1)
#' compute_info_2pl(a=1.5,b=1,theta=0)
#' compute_info_2pl(a=1.5,b=1,theta=1)
#' compute_info_2pl(a=1.5,b=1,theta=2)
#' compute_info_2pl(a=1.5,b=1,theta=3)
#' ti<-compute_info_2pl(a=1,b=-2,theta=seq(-6,6,by=.01)) # test information
#' plot(ti,x=seq(-6,6,by=.01))
#' ti<-compute_info_2pl(a=2,b=0,theta=seq(-6,6,by=.01)) # test information
#' plot(ti,x=seq(-6,6,by=.01))
#' ti<-compute_info_2pl(a=3,b=2,theta=seq(-6,6,by=.01)) # test information
#' plot(ti,x=seq(-6,6,by=.01))
compute_info_2pl<-function(a,b,theta) {
  p_theta<-1/(1+exp(-a*(theta-b)))
  q<-1-p_theta
  info<-(a^2)*p_theta*q
  return(info)
}
##########################################################################################
# COMPUTE ITEM INFORMATION 3PL
##########################################################################################
#' @title Compute item information for 3PL model
#' @param a numeric discrimination parameter
#' @param b numeric difficulty parameter
#' @param g numeric guessing parameter
#' @param theta numeric theta
#' @keywords IRT unidimensional
#' @export
#' @examples
#' compute_info_3pl(a=1.5,b=1,g=.2,theta=-3)
#' compute_info_3pl(a=1.5,b=1,g=.2,theta=-2)
#' compute_info_3pl(a=1.5,b=1,g=.2,theta=-1)
#' compute_info_3pl(a=1.5,b=1,g=.2,theta=0)
#' compute_info_3pl(a=1.5,b=1,g=.2,theta=1)
#' compute_info_3pl(a=1.5,b=1,g=.2,theta=2)
#' compute_info_3pl(a=1.5,b=1,g=.2,theta=3)
#' ti<-compute_info_3pl(a=1.5,b=1,g=.2,theta=seq(-6,6,by=.01)) # test information
#' plot(ti,x=seq(-6,6,by=.01))
compute_info_3pl<-function(a,b,g,theta) {
  p_theta<-g+(1-g)*(1/(1+exp(-a*(theta-b))))
  q<-1-p_theta
  info<-a^2*q/p_theta*(p_theta-g)^2/(1-g)^2
  return(info)
}
##########################################################################################
# COMPUTE SE THETA
##########################################################################################
#' @title Compute the SE of theta
#' @param info numeric information
#' @keywords IRT unidimensional
#' @export
#' @examples
#' compute_se_theta(1)
#' ti<-compute_info_2pl(a=10,b=0,theta=seq(-3,3,by=.01)) # test information
#' plot(compute_se_theta(ti),x=seq(-3,3,by=.01))
compute_se_theta<-function(info){
  result<-1/(sqrt(info))
  return(result)
}
