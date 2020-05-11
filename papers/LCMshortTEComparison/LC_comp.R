#   This script can be used to recreate the figures from the manuscript ' ' REF
#     
#
#   INPUTS:
#     loads R workspace with results data from the linear-combination algorithm comparison paper.
#     
#
#
#     
#   AUTHOR:
#     Dr. Helge Zöllner (Johns Hopkins University, 2020-05-11)
#     hzoelln2@jhmi.edu
#         
#   CREDITS:    
#     This code is based on numerous functions from the spant toolbox by
#     Dr. Martin Wilson (University of Birmingham)
#     https://martin3141.github.io/spant/index.html
#      
#      
#   HISTORY:
#     2020-05-11: First version of the code.
SpecVisPath <- '~/Documents/R/SpecVis'
# 1 Load workspace -----------------------------------
load(paste(SpecVisPath, 'papers/LCMshortTEComparison/ResultsToPlot.RData', sep = '/'))
source('dependencies.R')
source('spvs_importResults.R')
source('spvs_Correlation.R')
source('spvs_Correlation_Facet.R')
source('spvs_AddStatsToDataframe.R')
source('spvs_ConcatenateDataFrame.R')
source('spvs_RainCloud.R')
source('spvs_Statistics.R')


# 2 Figure 2 - Raincloud plots by vendors and tools -----------------------
lowerLimit <- c(0.75,.05,0.4,0.75)
upperLimit <- c(2.1,0.33,1.22,2.75)
color <- brewer.pal(8, 'Paired')
ToolColorMap <- c(color[6],color[2],color[4])

pGE <- spvs_RainCloud(dfGE, '/ [tCr]',list('tNAA','tCho','Ins','Glx'),c('Group'),lowerLimit,upperLimit,c(""),4)
pGE <- pGE + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pPh <- spvs_RainCloud(dfPh, '/ [tCr]',list('tNAA','tCho','Ins','Glx'),c('Group'),lowerLimit,upperLimit,c(""),4)
pPh <- pPh + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pSi <- spvs_RainCloud(dfSi, '/ [tCr]',list('tNAA','tCho','Ins','Glx'),c('Group'),lowerLimit,upperLimit,c(""),4)
pSi <- pSi + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pAll <- spvs_RainCloud(dfData, '/ [tCr]',list('tNAA','tCho','Ins','Glx'),c('Group'),lowerLimit,upperLimit,c(""),4)
pAll <- pAll + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pRain <- grid.arrange(pGE, pPh, pSi,pAll, ncol=1, nrow =4)
g <- arrangeGrob(pGE, pPh, pSi,pAll, ncol=1) #generates g
ggsave(file="~/Documents/R/SpecVis/papers/LCMshortTEComparison/Figure2.pdf", pRain, width = 10, height = 10,device=cairo_pdf) #saves g


# Figure 3 - Correlations between LCMs ------------------------------------
p <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Osprey','Osprey','Osprey','LCModel','LCModel','LCModel'),c('GE','Philips','Siemens','GE','Philips','Siemens'),c('group name','group name','group name','group name','group name','group name'),lowerLimit,upperLimit, 4)
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGETar,dfPhTar,dfSiTar)," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Osprey','Osprey','Osprey','Tarquin','Tarquin','Tarquin'),c('GE','Philips','Siemens','GE','Philips','Siemens'),c('group name','group name','group name','group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Tarquin','Tarquin','Tarquin','LCModel','LCModel','LCModel'),c('GE','Philips','Siemens','GE','Philips','Siemens'),c('group name','group name','group name','group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file="~/Documents/R/SpecVis/papers/LCMshortTEComparison/Figure3.pdf", p4, width = 10, height = 10,device=cairo_pdf) #saves g


# Figure 4 - Correlations baseline and metabolite estimates ---------------
lowerLimit <- c(.2,.75,.2,.05,.2,.4,.2,.75)
upperLimit <- c(.6,2.1,.6,.33,.6,1.22,.6,2.75)

p <- spvs_Correlation(list(dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c('bNAA','tNAA','bCho','tCho','bIns','Ins','bGlx','Glx'),c('bNAA','tNAA','bCho','tCho','bIns','Ins','bGlx','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp)," / [tCr]",c('bNAA','tNAA','bCho','tCho','bIns','Ins','bGlx','Glx'),c('bNAA','tNAA','bCho','tCho','bIns','Ins','bGlx','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar)," / [tCr]",c('bNAA','tNAA','bCho','tCho','bIns','Ins','bGlx','Glx'),c('bNAA','tNAA','bCho','tCho','bIns','Ins','bGlx','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file="~/Documents/R/SpecVis/papers/LCMshortTEComparison/Figure4.pdf", p4, width = 10, height = 10,device=cairo_pdf) #saves g


# S 1 - Correlations between LCMs facet -----------------------------------
lowerLimit <- c(0.75,.05,0.4,0.75)
upperLimit <- c(2.1,0.33,1.22,2.75)

p <- spvs_Correlation_Facet(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Osprey','Osprey','Osprey','LCModel','LCModel','LCModel'),c('GE','Philips','Siemens','GE','Philips','Siemens'),c('group name','group name','group name','group name','group name','group name'),lowerLimit,upperLimit, 4)
p2 <- spvs_Correlation_Facet(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGETar,dfPhTar,dfSiTar)," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Osprey','Osprey','Osprey','Tarquin','Tarquin','Tarquin'),c('GE','Philips','Siemens','GE','Philips','Siemens'),c('group name','group name','group name','group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation_Facet(list(dfGETar,dfPhTar,dfSiTar,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Tarquin','Tarquin','Tarquin','LCModel','LCModel','LCModel'),c('GE','Philips','Siemens','GE','Philips','Siemens'),c('group name','group name','group name','group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file="~/Documents/R/SpecVis/papers/LCMshortTEComparison/S1.pdf", p4, width = 30, height = 10,device=cairo_pdf) #saves g


# S 2 - Raincloud plot Cr Model --------------------------------------------
lowerLimit <- c(0.025)
upperLimit <- c(0.085)

pGEp <- spvs_RainCloud(dfGE, '/ [tCr]',list('ModelCrInt'),c('Group'),lowerLimit,upperLimit,c(""),1)
pGEp <- pGEp + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pPhp <- spvs_RainCloud(dfPh, '/ [tCr]',list('ModelCrInt'),c('Group'),lowerLimit,upperLimit,c(""),1)
pPhp <- pPhp + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pSip <- spvs_RainCloud(dfSi, '/ [tCr]',list('ModelCrInt'),c('Group'),lowerLimit,upperLimit,c(""),1)
pSip <- pSip + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pAllp <- spvs_RainCloud(dfData, '/ [tCr]',list('ModelCrInt'),c('Group'),lowerLimit,upperLimit,c(""),1)
pAllp <- pAllp + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pRainp <- grid.arrange(pGEp, pPhp, pSip,pAllp, ncol=1, nrow =4)
g <- arrangeGrob(pGEp, pPhp, pSip,pAllp, ncol=1) #generates g
ggsave(file="~/Documents/R/SpecVis/papers/LCMshortTEComparison/S2.pdf", pRainp, width = 10, height = 10,device=cairo_pdf) #saves g


# Statistics --------------------------------------------------------------
stData <- spvs_Statistics(dfData,list('tNAA','tCho','Ins','Glx'))
sink('~/Documents/R/SpecVis/papers/LCMshortTEComparison/statistics.txt')
print(stData)
sink()

