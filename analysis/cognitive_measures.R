#######################################################################################################
# COGNITIVE MEASURES CORRELATION ANALYSIS 
# CONTENT:
#   - plot of pairwise correlations
#   - descriptive statistics of the measures (mean/SD, range, skewness, kurtosis)
#######################################################################################################
rm(list=ls())
library(ggplot2)
library(ggpubr)
library(scales)
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
library(RcmdrMisc) # for Holm correction
library(moments) # for skewness and kurtosis

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

pic.path = "pics/"


#######################################################################################################
# load data and pre-process:
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

cog.measures.scaled = cog.measures.scaled  %>% dplyr::select(aq, art, crt, iq, rspan)


#######################################################################################################
# Edit rowsnames and colnames for the paper: 
#######################################################################################################
colnames(cog.measures.scaled)
colnames(cog.measures.scaled) = c("AQ", "ART","CRT","Raven's IQ","RSpan")

 
#######################################################################################################
# Pairwise correlation plot with # Holm correction for p-values:
#######################################################################################################
p.matrix              = rcorr.adjust(as.matrix(cog.measures.scaled), use="complete.obs") # holm correction
p.matrix$P.plot       = p.matrix$P
p.matrix$P.plot[p.matrix$P.plot=="<.0001"] = ".0001"
p.matrix$P.plot           = apply(p.matrix$P.plot, 2, as.numeric)
rownames(p.matrix$P.plot) = colnames(p.matrix$P.plot)

# save plot:
png(paste(pic.path, "ids_all_corr_paper.png", sep = ""), width = 2000, height = 2*571)
ggcorrplot(cor(cog.measures.scaled, use="complete.obs"),
           sig.level   = 0.05,
           hc.order    = TRUE, 
           type        = "lower",
           outline.col = "white",
           ggtheme     = ggplot2::theme_gray,
           lab_size    = 12,
           lab     = T,
           tl.srt  = 40,
           tl.col  = 40,
           tl.cex  = 40,
           pch.cex = 40,
           colors  = c("#6D9EC1", "white", "#E46726"),
           p.mat   = p.matrix$P.plot) + 
  theme(legend.text     = element_text(size=30),
        legend.key.size = unit(2.5, 'cm'),
        legend.title    = element_blank(),
        plot.title      = element_text(size = 40))
dev.off()


#######################################################################################################
# Descriptive statistics of the measures (mean/SD, range, skewness, kurtosis):
#######################################################################################################
cog.measures.selected = cog.measures.orig      %>% dplyr::select(art, aq.total, crt, iq, rspan)
cog.measures.selected = cog.measures.selected  %>% dplyr::rename(aq = aq.total)

round(apply(cog.measures.selected, 2, mean,     na.rm=TRUE),2)
round(apply(cog.measures.selected, 2, sd,       na.rm=TRUE),2)
round(apply(cog.measures.selected, 2, min,      na.rm=TRUE),2)
round(apply(cog.measures.selected, 2, max,      na.rm=TRUE),2)
round(apply(cog.measures.selected, 2, skewness, na.rm=TRUE),2)
round(apply(cog.measures.selected, 2, kurtosis, na.rm=TRUE),2)

