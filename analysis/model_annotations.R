#######################################################################################################
# Model of annotations (whether the atypicality inference was drawn)
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
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

pic.path  = "pics/"


#######################################################################################################
# load data:
#######################################################################################################
load(file = "data.RData")


#######################################################################################################
# Select cognitive measures:
#######################################################################################################
cog.measures.scaled = cog.measures.orig %>% dplyr::mutate(aq    = scale(aq.total),
                                                          art   = scale(art),
                                                          crt   = scale(crt),
                                                          iq    = scale(iq),
                                                          rspan = scale(rspan))

cog.measures.scaled = cog.measures.scaled  %>% dplyr::select(workerid, aq, art, crt, iq, rspan)

# calculate a composite score from IQ and CRT scores:
cog.measures.scaled$CSiqcrt = cog.measures.scaled$iq + cog.measures.scaled$crt


#######################################################################################################
# Prepare data for modelling:
#######################################################################################################
dt = data %>% dplyr::select(workerid, story, condition, q1, annotation)
dt = dt %>% dplyr::filter(condition =="with-IR")

# exclude annotation tags where it is not clear if the inference was drawn or not:
# notice_reject is considered as 'atypicality inference was not drawn':
dt = dt[!dt$annotation %in% c("other","not_sure"),]

# calculate dependent measure:
dt$is.atyp = ifelse(dt$annotation=="atypicality",1,0)

table(dt$annotation,dt$is.atyp)

# include cognitive measures:
dt = merge(x = dt, y = cog.measures.scaled, by = "workerid", all = T)


#######################################################################################################
# Modelling:
#######################################################################################################
mod.full = glmer(data    = dt,
                 formula = is.atyp ~ aq + CSiqcrt + rspan + art +
                           (1 | workerid) + (1|story),
                  family = binomial)

summary(mod.full)

mod.min = glmer(data    = dt,
                formula = is.atyp ~ aq + CSiqcrt + 
                          (1 | workerid) + (1|story),
                family = binomial)

summary(mod.min)

