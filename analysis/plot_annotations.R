##################################################################################################
# Plot mean typicality rating per annotation and frequency of occurrence for each annotation (counts) 
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


##################################################################################################
# with-IR condition plots (ratings vs. annotations and annotation frequency):
# mean ratings (Figure 2, upper panel in the paper)
# frequency    (Figure 2, lower panel in the paper)
##################################################################################################
plot_ratings <- function(ann, columnAnn, type){
  ann = ann %>% dplyr::rename(tag = eval(columnAnn))
  
  ordered_annotations = c("atypicality",
                          "normal",
                          "notice_reject",
                          "not_sure",
                          "other")
  
  colorPalette = data.frame(ann   = ordered_annotations,
                            color = c(brewer.pal(9, "BuGn")[8],
                                      brewer.pal(9, "YlOrRd")[7],
                                      brewer.pal(9, "YlOrRd")[9],
                                      brewer.pal(9, "Greys")[5],
                                      brewer.pal(9, "Blues")[8]))
  
  if(type == "mean"){
    sAnn     = summarySE(data = ann, measurevar = "q1", groupvars = c("tag"))
    sAnn$tag = factor(sAnn$tag, levels = ordered_annotations)
    sAnn
    
    plot.out = ggplot(sAnn, aes(x = tag, y = q1, fill = tag)) + 
      geom_bar(position = position_dodge(), stat = "identity") + 
      geom_errorbar(aes(ymin = q1-se, ymax = q1+se), width = .2, 
                    position = position_dodge(.9)) +
      scale_fill_manual(values=as.character(colorPalette$color))+
      labs(x = "Annotation", y = "Mean activity typicality estimates")+
      ggtitle("WITH-IR CONDTION: Mean typicality ratings per annotation") +
      theme(legend.position = "none") +
      ylim(0,max(sAnn$q1) + sAnn[sAnn$q1==max(sAnn$q1),]$sd) 
  }
  
  if(type == "count"){
    sAnn     = summarySE(data = ann, measurevar = "q1", groupvars = c("tag"))
    sAnn$tag = factor(sAnn$tag, levels = ordered_annotations)
    
    plot.out = ggplot(sAnn, aes(x = tag, y = N, fill = tag)) + 
      geom_bar(position = position_dodge(), stat = "identity") + 
      scale_fill_manual(values = as.character(colorPalette$color)) +
      theme(legend.position = "none") +
      labs(x = "Annotation", y = "Frequency")+
      ggtitle("Frequency") +
      ylim(0,max(sAnn$N) + 5)
  }
  return(plot.out)
}


p_meanRatingsPerAnnotation = plot_ratings(ann = targets, columnAnn = "annotation", type = "mean")
p_countAnnotations         = plot_ratings(ann = targets, columnAnn = "annotation", type = "count")


p1.save = p_meanRatingsPerAnnotation + 
  theme(legend.position = "none",
        axis.text.x  = element_text(size = 30, colour = "black"),
        axis.text.y  = element_text(size = 30, colour = "black"),
        axis.title.y = element_text(size = 30),
        axis.title.x = element_blank(),
        legend.text  = element_text(size = 30, face = "italic"),
        legend.title = element_text(size = 30),
        strip.text.x = element_text(size = 28),
        strip.text.y = element_text(size = 28),
        plot.title   = element_blank())

p2.save = p_countAnnotations + 
  theme(legend.position = "none",
        axis.text.x  = element_text(size = 30, colour = "black"),
        axis.text.y  = element_text(size = 30, colour = "black"),
        axis.title.y = element_text(size = 30),
        axis.title.x = element_text(size = 30),
        legend.text  = element_text(size = 30, face = "italic"),
        legend.title = element_text(size = 30),
        strip.text.x = element_text(size = 28),
        strip.text.y = element_text(size = 28),
        plot.title   = element_blank())


# SAVE PLOT:
png(paste(pic.path,"plot_meanRatingCountsAnn.png", sep = ""), width = 2000, height = 1142)
ggarrange(p1.save, p2.save, ncol = 1)
dev.off()

