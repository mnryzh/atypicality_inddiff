##################################################################################################
# Groups of subjects based on the annotations:
##################################################################################################
rm(list=ls())
library(tidyr)
library(dplyr)
library(stringr)
library(stringi)
library(rstudioapi)
library(gtools)
library(plyr)
library(ggplot2)
library(ggpubr)
library(Rmisc)
library(dplyr)
library(RColorBrewer)
library(gridExtra)
library(grid)
library(gtools)

setwd(dirname(getActiveDocumentContext()$path)) #path to source file location
getwd()

pic.path = "pics/"


##################################################################################################
# Load data:
##################################################################################################
load("data.RData")


##################################################################################################
# PREPARE DATA:
##################################################################################################
data$q1 = as.numeric(as.character(data$q1))
targets = droplevels(data[data$condition=="with-IR",])


########################################################################################################
# Groups of subjects based on thresholding:
########################################################################################################
subjects     = targets[,c("workerid", "annotation")]
subjects     = as.data.frame(table(subjects$workerid,subjects$annotation))

colnames(subjects) = c("workerid","annotation","count")
subjects     = spread(subjects, "annotation", "count")

subjects$class = NA
subjects[subjects$normal>3,]$class      = "lit"
subjects[subjects$atypicality>3,]$class = "prag"
subjects[is.na(subjects$class),]$class  = "inc"

data  = merge(data, data.frame(workerid = subjects$workerid, class = subjects$class), by = "workerid")

summary.class        = summarySE(data = data, measurevar = "q1", groupvars = c("class","condition"))
summary.class[-1:-2] = round(summary.class[-1:-2],2)
summary.class

