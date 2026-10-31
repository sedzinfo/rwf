##########################################################################################
# MPLUS
##########################################################################################
#source("https://www.statmodel.com/mplus-R/mplus.R")
##########################################################################################
# INSTALL OLDER PACKAGES
##########################################################################################
# packageurl<-"http://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_0.9.1.tar.gz"
# install.packages(packageurl,repos=NULL,type="source")
##########################################################################################
# CRAN REPOSITORY PACKAGES
##########################################################################################
packages1<-c("DescTools","mvoutlier","corpcor","pastecs","mvtnorm","RHRV","car","psych","mice","Matrix","astsa","splines","forecast","Rmisc","QuantPsyc","irr","Rcsdp","bindata")
environment<-c("devtools","git2r","roxygen","getPass","rsconnect","Rcpp","doSNOW","future.apply")
glm<-c("boot","pwr","nlme","lme4","sjstats","lmerTest","emmeans","rcompanion","lsr","mixlm")
factor<-c("GPArotation","lavaan","sem","semPlot")
irt<-c("mirt","irtDemo","catR")
machine_learning<-c("neuralnet","nnet","RSNNS","tree","party","rpart","randomForest","ggRandomForests","randomForestSRC","gbm","xgboost","gamlss.add")
strings<-c("stringi","stringr","BBmisc","NLP","openNLP","tcR","tm","spelling","corpus")
graphics<-c("ggpubr","ggExtra","ggfortify","ggrepel","tidyverse","gridExtra","RColorBrewer","png","grImport","pixmap","raster","corrplot","igraph","plotly","rgl","animation")
manipulation<-c("plyr","reshape","reshape2")
interface<-c("rjson","jsonlite","openxlsx","xlsx")

packages<-c(packages1,environment,glm,factor,irt,machine_learning,graphics,strings,manipulation,interface)
packages[duplicated(packages)]
installed_packages<-data.frame(installed.packages(),stringsAsFactors=FALSE)
missing_packages<-setdiff(packages,installed_packages$Package)
install.packages(missing_packages,Ncpus=1)

session.information<-sessionInfo()
names.base.packages<-sort(session.information$basePkgs)
names.other.packages<-sort(names(session.information$otherPkgs))
names.loaded.only.packages<-sort(names(session.information$loadedOnly))
update.packages(ask=FALSE,dependencies=TRUE)

