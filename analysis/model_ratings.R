#######################################################################################################
# BETA MIXED EFFECTS REGRESSION MODEL OF TYPICALITY RATINGS
#######################################################################################################
rm(list=ls())
library(ggplot2)
library(ggpubr)
library(tidyverse)
library(careless)
library(psych)
library(gridExtra)
library(lmerTest)
library(plyr)
library(MASS)
library(gtools)
library(Rmisc)
library(reshape2) # FOR WIDE TO LONG FORMAT
library("Hmisc")  # correlation matrix with significance levels 
library(corrplot)
library(ggcorrplot)
library(tidyverse)
library(RColorBrewer)
library(dplyr)
library(glmmTMB)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

pic.path = "pics/"

#######################################################################################################
# load data:
#######################################################################################################
load(file = "data.RData")


#######################################################################################################
# Select cognitive measures:
#######################################################################################################
cog.measures.scaled  = cog.measures.orig %>% dplyr::mutate(aq  = scale(aq.total),
                                                           art = scale(art),
                                                           crt = scale(crt),
                                                           iq  = scale(iq),
                                                           rspan = scale(rspan))

cog.measures.scaled = cog.measures.scaled  %>% dplyr::select(workerid, aq, art, crt, iq, rspan)

# create composite score of IQ and CRT:
cog.measures.scaled$CSiqcrt = cog.measures.scaled$iq + cog.measures.scaled$crt


#######################################################################################################
# Prepare data for modelling:
#######################################################################################################
dt = data %>% dplyr::select(workerid, orderGlobal, story, condition, q1)

dt$q1 = as.numeric(as.character(dt$q1))

# sum-code the story condition:
dt$cCond  = ifelse(dt$condition=="with-IR", 0.5, -0.5)

# transform for beta modelling:
dt$q1beta = dt$q1/100
dt[dt$q1beta==0,]$q1beta = 0.001
dt[dt$q1beta==1,]$q1beta = 0.999

dt$orderGlobal = as.numeric(as.character(dt$orderGlobal))

# merge with cognitive measures:
dt = merge(x = dt, y = cog.measures.scaled, by = "workerid", all = T)


#######################################################################################################
# INDIVIDUAL DIFFERENCES MODEL (composite score and with interactions):
#######################################################################################################
mod.full = glmmTMB::glmmTMB(data    = dt,
                            formula = q1beta ~ cCond*aq + cCond*art + cCond*CSiqcrt + cCond*rspan + 
                                      orderGlobal + 
                                      (1|workerid) + (cCond|story),
                             family = glmmTMB::beta_family())

summary(mod.full)


# Model from Table 5 (only significant predictors were left compared to model mod.full):
mod.min = glmmTMB::glmmTMB(data    = dt,
                           formula = q1beta ~ cCond + aq + CSiqcrt + art + cCond:aq + cCond:CSiqcrt +
                                     (1|workerid) + (cCond|story),
                            family = glmmTMB::beta_family())

summary(mod.min)

