##########################################################################################
# PREPARE DATA
##########################################################################################
# infert_formula<-formula(case~parity+induced+spontaneous)
##########################################################################################
# THEME
##########################################################################################
# line=element_line(colour=NULL,size=NULL,linetype=NULL,lineend=NULL)
# rect=element_rect(fill=NULL,colour=NULL,size=NULL,linetype=NULL)
# text=element_text(family=font,face=face,colour=NULL,size=NULL,hjust=NULL,vjust=NULL,angle=NULL,lineheight=NULL)
# title=element_text(family=font,face=face,colour=NULL,size=NULL,hjust=NULL,vjust=NULL,angle=NULL,lineheight=NULL)
##########################################################################################
# axis.title=element_text(family=font,face=face,colour=NULL,size=NULL,hjust=NULL,vjust=NULL,angle=NULL,lineheight=NULL)
# axis.title.x=element_text(family=font,face=face,colour=NULL,size=NULL,hjust=NULL,vjust=NULL,angle=NULL,lineheight=NULL)
# axis.title.y=element_text(family=font,face=face,colour=NULL,size=NULL,hjust=NULL,vjust=NULL,angle=NULL,lineheight=NULL)
# axis.text=element_text(family=font,face=face,colour=NULL,size=NULL,hjust=NULL,vjust=NULL,angle=NULL,lineheight=NULL)
# axis.text.x=element_text(family=font,face=face,colour=NULL,size=NULL,hjust=NULL,vjust=NULL,angle=NULL,lineheight=NULL)
# axis.text.y=element_text(family=font,face=face,colour=NULL,size=NULL,hjust=NULL,vjust=NULL,angle=NULL,lineheight=NULL)
# axis.ticks=element_line(colour=NULL,size=NULL,linetype=NULL,lineend=NULL)
# axis.ticks.x=element_line(colour=NULL,size=NULL,linetype=NULL,lineend=NULL)
# axis.ticks.y=element_line(colour=NULL,size=NULL,linetype=NULL,lineend=NULL)
# axis.ticks.length=(unit)
# axis.ticks.margin=(unit)
# axis.line=element_line(colour=NULL,size=NULL,linetype=NULL,lineend=NULL)
# axis.line.x=element_line(colour=NULL,size=NULL,linetype=NULL,lineend=NULL)
# axis.line.y=element_line(colour=NULL,size=NULL,linetype=NULL,lineend=NULL)
##########################################################################################
# legend.background=element_rect(fill=NULL,colour=NULL,size=NULL,linetype=NULL)
# legend.margin=(unit)
# legend.key=element_rect(fill=NULL,colour=NULL,size=NULL,linetype=NULL)
# legend.key.size=(unit; inherits from legend.key.size)
# legend.key.height=(unit; inherits from legend.key.size)
# legend.key.width=(unit; inherits from legend.key.size)
# legend.text=element_text(family=font,face=face,colour=NULL,size=NULL,hjust=NULL,vjust=NULL,angle=NULL,lineheight=NULL)
# legend.text.align=(number from 0 (left) to 1 (right))
# legend.title=element_text(family=font,face=face,colour=NULL,size=NULL,hjust=NULL,vjust=NULL,angle=NULL,lineheight=NULL)
# legend.position=("left","right","bottom","top",or two-element numeric vector)
# legend.direction=("horizontal" or "vertical")
# legend.justification=("center" or two-element numeric vector)
# legend.box=("horizontal" or "vertical")
# legend.box.just=("top","bottom","left",or "right")
##########################################################################################
# panel.background=element_rect(fill=NULL,colour=NULL,size=NULL,linetype=NULL)
# panel.border=element_rect(fill=NULL,colour=NULL,size=NULL,linetype=NULL)
# panel.spacing=(unit)
# panel.grid=element_line(colour=NULL,size=NULL,linetype=NULL,lineend=NULL)
# panel.grid.major=element_line(colour=NULL,size=NULL,linetype=NULL,lineend=NULL)
# panel.grid.minor=element_line(colour=NULL,size=NULL,linetype=NULL,lineend=NULL)
# panel.grid.major.x=element_line(colour=NULL,size=NULL,linetype=NULL,lineend=NULL)
# panel.grid.major.y=element_line(colour=NULL,size=NULL,linetype=NULL,lineend=NULL)
# panel.grid.minor.x=element_line(colour=NULL,size=NULL,linetype=NULL,lineend=NULL)
# panel.grid.minor.y=element_line(colour=NULL,size=NULL,linetype=NULL,lineend=NULL)
##########################################################################################
# plot.background=element_rect(fill=NULL,colour=NULL,size=NULL,linetype=NULL)
# plot.title=element_text(family=font,face=face,colour=NULL,size=NULL,hjust=NULL,vjust=NULL,angle=NULL,lineheight=NULL)
# plot.margin=(unit with the sizes of the top,right,bottom,and left margins)
##########################################################################################
# strip.background=element_rect(fill=NULL,colour=NULL,size=NULL,linetype=NULL)
# strip.text=element_text(family=font,face=face,colour=NULL,size=NULL,hjust=NULL,vjust=NULL,angle=NULL,lineheight=NULL)
# strip.text.x=element_text(family=font,face=face,colour=NULL,size=NULL,hjust=NULL,vjust=NULL,angle=NULL,lineheight=NULL)
# strip.text.y=element_text(family=font,face=face,colour=NULL,size=NULL,hjust=NULL,vjust=NULL,angle=NULL,lineheight=NULL)

directory<-paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/")
directory<-gsub("working_functions/ENVIRONMENT/","",directory)

df_admission<-read.csv("https://raw.githubusercontent.com/researchpy/Data-sets/master/admission.csv",
                       check.names=FALSE)
df_automotive_data<-read.csv("https://raw.githubusercontent.com/researchpy/Data-sets/master/automotive_data.csv",
                             check.names=FALSE,na.strings="?")
df_blood_pressure<-read.csv("https://raw.githubusercontent.com/researchpy/Data-sets/master/blood_pressure.csv",
                            check.names=FALSE)
df_crop_yield<-read.csv("https://raw.githubusercontent.com/researchpy/Data-sets/master/crop_yield.csv",
                        check.names=FALSE)
df_difficile<-read.csv("https://raw.githubusercontent.com/researchpy/Data-sets/master/difficile.csv",
                       check.names=FALSE)
df_insurance<-read.csv("https://raw.githubusercontent.com/researchpy/Data-sets/master/insurance.csv",
                       check.names=FALSE)
df_responses<-read.csv("https://raw.githubusercontent.com/researchpy/Data-sets/master/responses.csv",
                       check.names=FALSE)
df_responses_state<-read.csv("https://raw.githubusercontent.com/researchpy/Data-sets/master/responses_state.csv",
                             check.names=FALSE)
df_sexual_comp<-read.csv("https://raw.githubusercontent.com/researchpy/Data-sets/master/sexual_comp.csv",
                         check.names=FALSE)
df_personality<-read.csv(paste0(directory,"data/personality.csv"),
                         check.names=FALSE)
df_titanic<-read.csv(paste0(directory,"data/titanic.csv"),
                     check.names=FALSE)
df_co2<-read.csv(paste0(directory,"data/co2.csv"),
                 check.names=FALSE)
df_ocean<-read.csv(paste0(directory,"data/ocean.csv"),
                 check.names=FALSE,sep="\t")
save(df_admission,file=paste0(directory,"rwf/data/df_admission.rda"))
save(df_automotive_data,file=paste0(directory,"rwf/data/df_automotive_data.rda"))
save(df_blood_pressure,file=paste0(directory,"rwf/data/df_blood_pressure.rda"))
save(df_crop_yield,file=paste0(directory,"rwf/data/df_crop_yield.rda"))
save(df_difficile,file=paste0(directory,"rwf/data/df_difficile.rda"))
save(df_insurance,file=paste0(directory,"rwf/data/df_insurance.rda"))
save(df_responses,file=paste0(directory,"rwf/data/df_responses.rda"))
save(df_responses_state,file=paste0(directory,"rwf/data/df_responses_state.rda"))
save(df_sexual_comp,file=paste0(directory,"rwf/data/df_sexual_comp.rda"))
save(df_personality,file=paste0(directory,"rwf/data/df_personality.rda"))
save(df_titanic,file=paste0(directory,"rwf/data/df_titanic.rda"))
save(df_co2,file=paste0(directory,"rwf/data/df_co2.rda"))
save(df_ocean,file=paste0(directory,"rwf/data/df_ocean.rda"))
tools::resaveRdaFiles(paste0(directory,"rwf/data"),compress="auto")

write.csv(df_admission,file=paste0(directory,"/data/admission.csv"),
          row.names=FALSE)
write.csv(df_automotive_data,file=paste0(directory,"/data/automotive_data.csv"),
          row.names=FALSE)
write.csv(df_blood_pressure,file=paste0(directory,"/data/blood_pressure.csv"),
          row.names=FALSE)
write.csv(df_crop_yield,file=paste0(directory,"/data/crop_yield.csv"),
          row.names=FALSE)
write.csv(df_difficile,file=paste0(directory,"/data/difficile.csv"),
          row.names=FALSE)
write.csv(df_insurance,file=paste0(directory,"/data/insurance.csv"),
          row.names=FALSE)
write.csv(df_responses,file=paste0(directory,"/data/responses.csv"),
          row.names=FALSE)
write.csv(df_responses_state,file=paste0(directory,"/data/responses_state.csv"),
          row.names=FALSE)
write.csv(df_sexual_comp,file=paste0(directory,"/data/sexual_comp.csv"),
          row.names=FALSE)
write.csv(df_personality,file=paste0(directory,"/data/personality.csv"),
          row.names=FALSE)
write.csv(df_titanic,file=paste0(directory,"/data/titanic.csv"),
          row.names=FALSE)





