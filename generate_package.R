##########################################################################################
# DIRECTORIES
##########################################################################################
# R CMD check rwf
# R CMD Rd2pdf rwf
# R CMD build rwf --resave-data
# pkgdown::build_site("/home/dimitrios/GitHub/rwf/rwf")
library(devtools)
library(roxygen2)
rm(list = ls())
graphics.off()
cat("\014")
##########################################################################################
# FUNCTIONS PACKAGE
##########################################################################################
directory <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/")
working_directory <- gsub("working_functions/ENVIRONMENT/", "", directory)
# source(paste0(working_directory,"ENVIRONMENT/ENVIRONMENT_DATA.R"))
setwd(working_directory)
# usethis::create_package("rwf")
setwd("rwf")
dir.create(file.path("data"), showWarnings = FALSE)
filestocopy <- setdiff(
  list.files(file.path(working_directory, "working_functions"), full.names = TRUE),
  list.dirs(file.path(working_directory, "working_functions"), recursive = FALSE)
)
file.copy(from = filestocopy, to = file.path(working_directory, "rwf/R"), recursive = TRUE, copy.mode = TRUE)
document()
setwd("..")
remove.packages("rwf")
install("rwf")
library(rwf)

pkgdown::build_site(file.path(getwd(), "/rwf"))
system("R CMD Rd2pdf rwf --force")
system("evince rwf.pdf")
system("R CMD build rwf --resave-data")




