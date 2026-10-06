##########################################################################################
# DIRECTORIES
##########################################################################################
directory<-paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/")
setwd(gsub("/working_functions/ENVIRONMENT/","",directory))
rm(list=ls())
lapply(paste0('package:',names(sessionInfo()$otherPkgs)),detach,character.only=TRUE,unload=TRUE)
graphics.off()
cat("\014")
# .rs.restartR()
library(rwf)
environment_options()
rstudioapi::getSourceEditorContext()$path
combine_files(input_dir = gsub("ENVIRONMENT/", "", directory),
              output_file = paste0(gsub("working_functions/ENVIRONMENT/", "", directory), "vignettes/R/code_rwf.R"),
              recursive = FALSE)
##########################################################################################
# SOURCE
##########################################################################################
r_files<-setdiff(list.files("working_functions",full.names=TRUE),
                 list.dirs("working_functions",recursive=FALSE))
r_irr_files<-setdiff(list.files("working_functions/IRR",full.names=TRUE),
                     list.dirs("working_functions/IRR",recursive=FALSE))
for (i in r_files)
  source(i)
directory<-paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/")
source(paste0(directory,"ENVIRONMENT_GENERATE_PACKAGE.R"))
##########################################################################################
# 
##########################################################################################
library(reticulate)
system2("python", "--version")
system2("R", "--version")
use_python("/opt/pyrepo/bin/python3")
use_virtualenv("/opt/pyrepo")
##########################################################################################
# SAVE
##########################################################################################
# savehistory(file="COMMAND.HISTORY.Rhistory")
# loadhistory(file="COMMAND.HISTORY.Rhistory")
# save.image("ENVIRONMENT.Renvironment") load("ENVIRONMENT.Renvironment")
##########################################################################################
#ENVIRONMENT CHECK
##########################################################################################
original_options<-options()
original_parameters<-par()
Sys.getenv()
sessionInfo()
getLoadedDLLs()
installed.packages()
options(java.parameters="-Xmx8192m")
Sys.getlocale(category="LC_ALL")
#Postscript Encoding Files
dir(file.path(system.file(package="grDevices"),"enc"))
# List the functions in a particular package
##########################################################################################
# MEMORY
##########################################################################################
gc()
system("free")
system("cat /proc/meminfo")
memory.size(max=32682) # WINDOWS
memory.limit(size=NA)  # WINDOWS
##########################################################################################
# FUNCTIONS CHECK
##########################################################################################
lsf.str("package:mirt")
psych::alpha
showMethods(alpha)
getMethod(alpha)
library(help="datasets")
##########################################################################################
# SHINY
##########################################################################################
# /var/log/shiny-server/
# sudo systemctl restart shiny-server
# scp -r admin@192.168.84.55:/srv/shiny-server/* /home/dimitrios/Desktop/shiny/.
# ssh admin@192.168.84.55
# install.packages("https://cran.r-project.org/src/contrib/Archive/varComp/varComp_0.2-0.tar.gz",type="source",repos=NULL,dependencies=TRUE)

