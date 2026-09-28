##########################################################################################
# CATR ACKNOWLEDGEMENT
##########################################################################################
# integrate_cat in this file is adapted from integrate.catR of the catR package
# version 3.17 by David Magis Gilles Raiche and Juan Ramon Barrada
# https://CRAN.R-project.org/package=catR
# Magis D and Raiche G (2012) Journal of Statistical Software 48(8) 1-31
# doi:10.18637/jss.v048.i08
# Magis D and Barrada JR (2017) Journal of Statistical Software Code Snippets 76(1) 1-19
# doi:10.18637/jss.v076.c01
# catR is licensed under GPL (>= 3) and this file is distributed under the same license
# density_function is not taken from catR it writes out the normal density that catR
# obtains from stats::dnorm
# modified by Dimitrios Zacharatos 2023-2026 renamed and documented
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
#' v<-seq(-3,3,by=.001)
#' plot(y=density_function(x=v),x=v)
#' data.frame(x1=dnorm(v),x2=density_function(v))
#' density_function(x=0)
#' dnorm(x=0)
density_function<-function(x,mean=0,sd=1) {
  # e<-2.718282
  e<-exp(1)
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
  height<-x[2:length(x)]-x[1:(length(x)-1)]
  base<-apply(cbind(y[1:(length(y)-1)],y[2:length(y)]),1,mean)
  result<-sum(base*height)
  return(result)
}
