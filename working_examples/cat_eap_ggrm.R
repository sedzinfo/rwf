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
#' @title compute category response probabilities and derivatives under the generalized graded response model
#' @description returns the category response probabilities for a given ability value and a \cr
#'              given matrix of item parameters under Muraki modified graded response \cr
#'              model which catR calls MGRM and mirt calls the graded rating scale model \cr
#'              and which this file calls the generalized graded response model \cr
#'              it is a restricted graded response model whose thresholds are b_j-c_k \cr
#'              and not an extension of it \cr
#'              returns the first derivatives of the category response probabilities
#' @param theta ability
#' @param bank item parameters one row per item \cr
#'             column 1 holds the item discrimination alpha_j \cr
#'             column 2 holds the item location b_j \cr
#'             columns 3 to ncol(bank) hold the category parameters c_1 to c_m \cr
#'             the category parameters are common to the items of a block so those \cr
#'             columns are identical in every row of the block which is what separates \cr
#'             this model from the graded response model where every item has its own \cr
#'             thresholds \cr
#'             a bank with a single block has the same category parameters in every row \cr
#'             the category parameters must be strictly decreasing so that the item \cr
#'             thresholds b_j-c_k are strictly increasing \cr
#'             two equal category parameters leave a category with probability zero so a \cr
#'             response there makes the EAP NaN and an increasing pair makes a \cr
#'             probability negative \cr
#'             items that do not share a rating scale form separate blocks with their own \cr
#'             category parameters which is always the case for items with a different \cr
#'             number of categories and the shorter rows are padded with NA \cr
#'             a mirt model fitted with itemtype="grsm" converts with \cr
#'             pars<-mirt::coef(model,simplify=TRUE)$items \cr
#'             cbind(pars[,"a1"],-pars[,"c"],pars[,grep("^b[0-9]",colnames(pars))]) \cr
#'             to be used with D=1 because mirt writes \cr
#'             Pstar_jk=P(X>=k|theta)=exp(a1*(theta+c+b_k))/(1+exp(a1*(theta+c+b_k)))
#' @param D metric constant can be 1 or 1.702
#' @note this function should return the same result as catR::Pi(model="MGRM") \cr
#'       the number of response categories is ncol(bank)-1 so a 5 point Likert scale \cr
#'       scored 0 1 2 3 4 needs a bank with 6 columns \cr
#'       the model is the graded response model with the item thresholds split into \cr
#'       an item location and category parameters shared by the items of a block \cr
#'       beta_jk=b_j-c_k \cr
#'       Pstar_jk=P(X>=k|theta)=exp(D*alpha_j*(theta-(b_j-c_k)))/(1+exp(D*alpha_j*(theta-(b_j-c_k)))) \cr
#'       with Pstar_j0=1 and Pstar_j(m+1)=0 \cr
#'       P(X=k|theta)=Pstar_jk-Pstar_j(k+1) \cr
#'       it relates to the graded response model as the rating scale model relates to \cr
#'       the partial credit model and it keeps the item discrimination \cr
#'       it stays a cumulative model while the rating scale model compares adjacent \cr
#'       categories and divides by a total \cr
#'       when theta is far above the thresholds both cumulative curves are close to 1 \cr
#'       and their difference loses precision so probabilities below about 1e-11 are \cr
#'       inaccurate and below about 1e-16 become exactly 0 \cr
#'       catR computes them the same way and only response patterns that contradict \cr
#'       theta strongly on very discriminating items are affected \cr
#'       adding the same constant to the b_j and to the c_k of a block leaves every \cr
#'       probability unchanged so a constraint is needed \cr
#'       Muraki centres the c_k of each block at zero while mirt sets b_j=0 for the \cr
#'       first item of each block and both give the same probabilities
#' @return Pi   category response probabilities one row per item one column per category \cr
#'         dPi  first derivatives of the category response probabilities
#' @export
#' @examples
#' bank<-matrix(c(1.227,0.845,1.694,1.012,2.103,
#'                -0.482,0.137,0.715,-0.936,0.298,
#'                rep(1.812,5),rep(0.603,5),rep(-0.452,5),rep(-1.963,5)),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alphaj","bj","c1","c2","c3","c4")))
#' catR::Pi(th=0,bank,model="MGRM") # this will work with catR package installed
#' Pi_ggrm(theta=0,bank)
#' bank[,2]-bank[,3:6] # the item thresholds beta_jk
#' v<-seq(-6,6,by=.1)
#' y_axis_response_probability<-list()
#' for(i in v) y_axis_response_probability[[toString(i)]]<-Pi_ggrm(theta=i,bank)$Pi[1,]
#' df_rp<-data.frame(x=v,
#'                   matrix(unlist(y_axis_response_probability),
#'                          nrow=length(y_axis_response_probability),byrow=TRUE))
#' plot(x=df_rp$x,y=df_rp$X1,xlab=expression(theta),ylab=expression(P(theta)),
#'      main="category response probabilities item 1",type="l",col="red",ylim=c(0,1))
#' lines(y=df_rp$X2,x=v,col="green")
#' lines(y=df_rp$X3,x=v,col="blue")
#' lines(y=df_rp$X4,x=v,col="yellow")
#' lines(y=df_rp$X5,x=v,col="orange")
Pi_ggrm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  ncat<-ncol(bank)-1
  Pi<-dPi<-matrix(NA,nrow(bank),ncat)
  for (i in 1:nrow(bank)) {
    aj<-bank[i,1]
    betaj<-bank[i,2]-bank[i,3:ncol(bank)]
    betaj<-betaj[!is.na(betaj)]
    ej<-exp(D*aj*(theta-betaj))
    Pjs<-c(1,ej/(1+ej),0)
    dPjs<-D*aj*Pjs*(1-Pjs)
    n<-length(Pjs)
    Pi[i,1:(n-1)]<-Pjs[1:(n-1)]-Pjs[2:n]
    dPi[i,1:(n-1)]<-dPjs[1:(n-1)]-dPjs[2:n]
  }
  colnames(Pi)<-colnames(dPi)<-paste("cat",0:(ncat-1),sep="")
  rownames(Pi)<-rownames(dPi)<-paste("Item",1:nrow(bank),sep="")
  result<-list(Pi=Pi,dPi=dPi)
  return(result)
}
##########################################################################################
# ITEM INFORMATION
##########################################################################################
#' @title compute item information under the generalized graded response model
#' @param theta ability
#' @param bank matrix of item parameters
#' @param D metric constant can be 1 or 1.702
#' @note this function should return the same result as catR::Ii(model="MGRM") \cr
#'       the polytomous item information is the sum over categories of the squared \cr
#'       first derivative divided by the probability \cr
#'       I_j(theta)=sum_k (dP_jk/dtheta)^2/P_jk \cr
#'       the items of a block share the same spacing of thresholds so two items of a \cr
#'       block with the same alpha_j have the same information curve shifted by the \cr
#'       difference of their b_j \cr
#'       a larger alpha_j gives a taller curve that grows roughly with alpha_j^2 and is \cr
#'       narrower around each threshold \cr
#'       test information is the sum of the item informations
#' @return Ii item information for each item
#' @export
#' @examples
#' bank<-matrix(c(1.227,0.845,1.694,1.012,2.103,
#'                -0.482,0.137,0.715,-0.936,0.298,
#'                rep(1.812,5),rep(0.603,5),rep(-0.452,5),rep(-1.963,5)),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alphaj","bj","c1","c2","c3","c4")))
#' catR::Ii(th=0,bank,model="MGRM") # this will work with catR package installed
#' Ii_ggrm(theta=0,bank)
#' sum(Ii_ggrm(theta=0,bank)$Ii) # test information
#' v<-seq(-4,4,by=.1)
#' info<-matrix(NA,length(v),nrow(bank))
#' for (i in 1:length(v)) info[i,]<-Ii_ggrm(theta=v[i],bank)$Ii
#' plot(x=v,y=info[,1],xlab=expression(theta),ylab="information",
#'      main="item information curves",type="l",col="red",ylim=c(0,max(info)))
#' lines(y=info[,2],x=v,col="green")
#' lines(y=info[,3],x=v,col="blue")
#' lines(y=info[,4],x=v,col="yellow")
#' lines(y=info[,5],x=v,col="orange")
#' plot(x=v,y=rowSums(info),xlab=expression(theta),ylab="information",
#'      main="test information",type="l")
Ii_ggrm<-function(theta,bank,D=1) {
  bank<-rbind(bank)
  prob<-Pi_ggrm(theta,bank,D=D)
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
#'       catR::nextItem(itemBank,model="MGRM",theta,out,criterion="MFI") when \cr
#'       randomesque is 1 and the most informative item is unique \cr
#'       when several items tie exactly catR draws one of them at random while this \cr
#'       function takes the first \cr
#'       with randomesque above 1 catR also keeps every item tied with the last one kept \cr
#'       so it can draw from more than randomesque items \cr
#'       when the items of a block have the same alpha_j their information curves are \cr
#'       copies of one another so the choice among them depends only on where theta \cr
#'       sits relative to each b_j \cr
#'       with different alpha_j the curves differ in height as well so the information \cr
#'       of every available item has to be computed at theta
#' @return item  index of the selected item in the bank \cr
#'         info  information of the selected item at theta \cr
#'         available indices of the items still available
#' @export
#' @examples
#' bank<-matrix(c(1.227,0.845,1.694,1.012,2.103,
#'                -0.482,0.137,0.715,-0.936,0.298,
#'                rep(1.812,5),rep(0.603,5),rep(-0.452,5),rep(-1.963,5)),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alphaj","bj","c1","c2","c3","c4")))
#' catR::nextItem(bank,model="MGRM",theta=0,criterion="MFI") # with catR installed
#' next_item_ggrm(theta=0,bank)
#' next_item_ggrm(theta=0,bank,out=c(5))
#' catR::nextItem(bank,model="MGRM",theta=3,criterion="MFI") # with catR installed
#' next_item_ggrm(theta=3,bank)
#' # a short adaptive test driven by the functions in this file
#' responses<-c()
#' administered<-c()
#' theta<-0
#' for (step in 1:4) {
#'   item<-next_item_ggrm(theta,bank,out=administered)$item
#'   administered<-c(administered,item)
#'   responses<-c(responses,3) # replace by the real response scored 0 to m
#'   theta<-eap_est_ggrm(bank[administered,,drop=FALSE],responses)
#'   cat("step",step,"item",item,"theta",round(theta,4),
#'       "se",round(eap_se_ggrm(theta,bank[administered,,drop=FALSE],responses),4),"\n")
#' }
next_item_ggrm<-function(theta,bank,out=NULL,D=1,randomesque=1) {
  bank<-rbind(bank)
  available<-setdiff(1:nrow(bank),out)
  if (length(available)==0) stop("no item left in the bank",call.=FALSE)
  info<-Ii_ggrm(theta,bank[available,,drop=FALSE],D=D)$Ii
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
#'       Pi_ggrm returns a matrix so the response of item i selects the column x[i]+1 \cr
#'       the +1 is index bookkeeping because categories start at 0 and R columns start \cr
#'       at 1 \cr
#'       the probabilities of the observed responses are multiplied across items under \cr
#'       the local independence assumption
#' @export
#' @examples
#' bank<-matrix(c(1.227,0.845,1.694,1.012,2.103,
#'                -0.482,0.137,0.715,-0.936,0.298,
#'                rep(1.812,5),rep(0.603,5),rep(-0.452,5),rep(-1.963,5)),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alphaj","bj","c1","c2","c3","c4")))
#' response<-c(4,3,2,1,0)
#' likelihood_ggrm(theta=0,bank=bank,x=response)
#' v<-seq(-4,4,by=.1)
#' lik<-c()
#' for (i in 1:length(v)) lik[i]<-likelihood_ggrm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=lik,xlab=expression(theta),ylab="likelihood",
#'      main="likelihood of the response pattern",type="l")
likelihood_ggrm<-function(theta,bank,x,D=1) {
  prob<-Pi_ggrm(theta,bank,D=D)$Pi
  result<-1
  for (i in 1:length(x)) result<-result*prob[i,x[i]+1]
  return(result)
}
##########################################################################################
# EAP ESTIMATION
##########################################################################################
#' @title compute theta EAP estimation under the generalized graded response model
#' @param bank matrix of item parameters
#' @param x vector of item responses scored 0 to m
#' @param D metric constant can be 1 or 1.702
#' @param priorPar mean and sd for normal distribution default is mean 0 and sd 1
#' @param lower lower bound for numerical integration
#' @param upper upper bound for numerical integration
#' @param nqp number of quadrature points
#' @note this function should return the same result as catR::eapEst(model="MGRM")
#' @export
#' @examples
#' bank<-matrix(c(1.227,0.845,1.694,1.012,2.103,
#'                -0.482,0.137,0.715,-0.936,0.298,
#'                rep(1.812,5),rep(0.603,5),rep(-0.452,5),rep(-1.963,5)),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alphaj","bj","c1","c2","c3","c4")))
#' response<-c(4,3,2,1,0)
#' catR::eapEst(bank,response,model="MGRM") # this will work with catR package installed
#' eap_est_ggrm(bank,response)
eap_est_ggrm<-function (bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-s[i]*density_function(s[i],priorPar[1],priorPar[2])*likelihood_ggrm(s[i],bank,x,D=D)
    return(res)
  }
  h<-function(s) {
    res<-NULL
    for (i in 1:length(s))
      res[i]<-density_function(s[i],priorPar[1],priorPar[2])*likelihood_ggrm(s[i],bank,x,D=D)
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
#' @title compute standard error of theta EAP estimation under the generalized graded response model
#' @param theta theta estimation
#' @param bank matrix of item parameters
#' @param x vector of item responses scored 0 to m
#' @param D metric constant can be 1 or 1.702
#' @param priorPar mean and sd for normal distribution default is mean 0 and sd 1
#' @param lower lower bound for numerical integration
#' @param upper upper bound for numerical integration
#' @param nqp number of quadrature points
#' @note this function should return the same result as catR::eapSem(model="MGRM") \cr
#'       pass the EAP estimate as theta to obtain the posterior standard deviation \cr
#'       any other value returns the posterior root mean squared deviation around it \cr
#'       so the curve is minimised at the EAP estimate
#' @export
#' @examples
#' bank<-matrix(c(1.227,0.845,1.694,1.012,2.103,
#'                -0.482,0.137,0.715,-0.936,0.298,
#'                rep(1.812,5),rep(0.603,5),rep(-0.452,5),rep(-1.963,5)),
#'              nrow=5,dimnames=list(c(1,2,3,4,5),
#'                                   c("alphaj","bj","c1","c2","c3","c4")))
#' response<-c(4,3,2,1,0)
#' catR::eapSem(0,bank,response,model="MGRM") # this will work with catR package installed
#' eap_se_ggrm(theta=0,bank=bank,x=response)
#' v<-seq(-3,3,by=.1)
#' se<-c()
#' for (i in 1:length(v)) se[i]<-eap_se_ggrm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error with a mixed response pattern")
#' response<-c(0,0,0,0,0)
#' for (i in 1:length(v)) se[i]<-eap_se_ggrm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error when all responses are in the lowest category")
#' response<-c(4,4,4,4,4)
#' for (i in 1:length(v)) se[i]<-eap_se_ggrm(theta=v[i],bank=bank,x=response)
#' plot(x=v,y=se,xlab=expression(theta),ylab="standard error",
#'      main="standard error when all responses are in the highest category")
eap_se_ggrm<-function(theta,bank,x,D=1,priorPar=c(0,1),lower=-4,upper=4,nqp=33) {
  g<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-(X[i]-theta)^2*density_function(X[i],priorPar[1],priorPar[2])*likelihood_ggrm(X[i],bank,x,D=D)
    return(res)
  }
  h<-function(X) {
    res<-NULL
    for (i in 1:length(X))
      res[i]<-density_function(X[i],priorPar[1],priorPar[2])*likelihood_ggrm(X[i],bank,x,D=D)
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
# with the discrimination set to alphaj and the difficulties set to bj-ck
# the difficulty sliders have narrow ranges so only items 2 and 5 of example 1 fit rounded to 0.1
##########################################################################################
# EXAMPLE 1
##########################################################################################
# 5 point Likert scale scored 0 1 2 3 4
# alphaj and bj are item specific and c1 to c4 are common to all items
alphaj<-c(1.227,0.845,1.694,1.012,2.103)
bj<-c(-0.482,0.137,0.715,-0.936,0.298)
c1<-rep(1.812,5)
c2<-rep(0.603,5)
c3<-rep(-0.452,5)
c4<-rep(-1.963,5)
bank<-matrix(c(alphaj,bj,c1,c2,c3,c4),nrow=5,
             dimnames=list(c(1,2,3,4,5),c("alphaj","bj","c1","c2","c3","c4")))
response_1<-c(0,0,0,0,0)
response_2<-c(1,1,1,1,1)
response_3<-c(2,2,2,2,2)
response_4<-c(3,3,3,3,3)
response_5<-c(4,4,4,4,4)
# ABILITY ESTIMATION
eap_est_ggrm(bank,response_1)
catR::eapEst(bank,response_1,model="MGRM")
eap_est_ggrm(bank,response_2)
catR::eapEst(bank,response_2,model="MGRM")
eap_est_ggrm(bank,response_3)
catR::eapEst(bank,response_3,model="MGRM")
eap_est_ggrm(bank,response_4)
catR::eapEst(bank,response_4,model="MGRM")
eap_est_ggrm(bank,response_5)
catR::eapEst(bank,response_5,model="MGRM")
# STANDARD ERROR ESTIMATION
eap_se_ggrm(eap_est_ggrm(bank,response_1),bank,response_1)
catR::eapSem(eap_est_ggrm(bank,response_1),bank,response_1,model="MGRM")
eap_se_ggrm(eap_est_ggrm(bank,response_2),bank,response_2)
catR::eapSem(eap_est_ggrm(bank,response_2),bank,response_2,model="MGRM")
eap_se_ggrm(eap_est_ggrm(bank,response_3),bank,response_3)
catR::eapSem(eap_est_ggrm(bank,response_3),bank,response_3,model="MGRM")
eap_se_ggrm(eap_est_ggrm(bank,response_4),bank,response_4)
catR::eapSem(eap_est_ggrm(bank,response_4),bank,response_4,model="MGRM")
eap_se_ggrm(eap_est_ggrm(bank,response_5),bank,response_5)
catR::eapSem(eap_est_ggrm(bank,response_5),bank,response_5,model="MGRM")
##########################################################################################
# EXAMPLE 2
##########################################################################################
# effect of the integration bounds and of the number of quadrature points
response_1<-c(4,4,4,4,4)
eap_est_ggrm(bank,response_1,lower=-4,upper=4)
eap_est_ggrm(bank,response_1,lower=-3,upper=3)
eap_est_ggrm(bank,response_1,nqp=33)
eap_est_ggrm(bank,response_1,nqp=101)
# effect of the prior
eap_est_ggrm(bank,response_1,priorPar=c(0,1))
eap_est_ggrm(bank,response_1,priorPar=c(0,2))
# effect of the metric constant
eap_est_ggrm(bank,response_1,D=1)
eap_est_ggrm(bank,response_1,D=1.702)
# the origin of bj and ck is arbitrary
# adding 0.5 to every bj and to every ck gives the same thresholds and the same estimate
response_1<-c(3,2,3,2,3)
bank_2<-bank
bank_2[,2:6]<-bank[,2:6]+0.5
bank[,2]-bank[,3:6]
bank_2[,2]-bank_2[,3:6]
eap_est_ggrm(bank,response_1)
eap_est_ggrm(bank_2,response_1)
##########################################################################################
# EXAMPLE 3
##########################################################################################
# the model is a graded response model whose thresholds are betajk=bj-ck
# so the GRM probabilities of the implied thresholds are the same
bank_grm<-cbind(alphaj,bank[,2]-bank[,3:6])
colnames(bank_grm)<-c("alphaj","betaj1","betaj2","betaj3","betaj4")
bank_grm
Pi_ggrm(theta=0,bank)$Pi
catR::Pi(th=0,bank_grm,model="GRM")$Pi
# items do not all need the same number of categories
# items 4 and 5 below are 4 point items so they form a second block with its own
# category parameters c1 to c3 and their last column is padded with NA
# their responses must then be scored 0 to 3
bank<-rbind(bank[1:3,],
            cbind(alphaj[4:5],bj[4:5],1.405,0.012,-1.417,NA))
rownames(bank)<-c(1,2,3,4,5)
bank
Pi_ggrm(theta=0,bank)$Pi
response_1<-c(4,3,2,1,3)
eap_est_ggrm(bank,response_1)
catR::eapEst(bank,response_1,model="MGRM")
eap_se_ggrm(eap_est_ggrm(bank,response_1),bank,response_1)

