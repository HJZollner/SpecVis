source('functions/dependencies.R')
source('functions/spvs_importResults.R')
source('functions/spvs_Correlation.R')
source('functions/spvs_BlandAltman.R')
source('functions/spvs_Correlation_Facet.R')
source('functions/spvs_AddStatsToDataframe.R')
source('functions/spvs_ConcatenateDataFrame.R')
source('functions/spvs_RainCloud.R')
source('functions/spvs_Boxplot.R')
source('functions/spvs_Statistics.R')

dfHERCsum <- spvs_importResults('/Volumes/Samsung/working/HERCULES/derivativesACC/QuantifyResults/sum_tCr_Voxel_1.csv')
dfHERCdiff1 <- spvs_importResults('/Volumes/Samsung/working/HERCULES/derivativesACC/QuantifyResults/diff1_tCr_Voxel_1.csv')
dfHERCdiff2 <- spvs_importResults('/Volumes/Samsung/working/HERCULES/derivativesACC/QuantifyResults/diff2_tCr_Voxel_1.csv')


dfHERCsep <- dfHERCsum

dfHERCsep$Asc <- dfHERCdiff2$Asc
dfHERCsep$Asp <- dfHERCdiff2$Asp
dfHERCsep$GSH <- dfHERCdiff2$GSH
dfHERCsep$NAAG <- dfHERCdiff2$NAAG
dfHERCsep$GABA <- dfHERCdiff1$GABA
dfHERCsep$GABAplus <- dfHERCdiff1$GABAplus
dfHERCsep$Lac <- dfHERCdiff2$Lac
dfHERCsep$PE <- dfHERCdiff2$PE
dfHERCsep$NAA <- dfHERCsum$NAA
dfHERCsep$tCho <- dfHERCsum$tCho
dfHERCsep$Ins <- dfHERCsum$Ins
dfHERCsep$Glu <- dfHERCsum$Glu
dfHERCsep$Gln <- dfHERCsum$Gln
dfHERCsep$Glx <- dfHERCsum$Glx

dfHERCsep <- spvs_AddStatsToDataframe(dfHERCsep,'/Volumes/Samsung/working/HERCULES/derivatives/stat.csv')

lowerLimit <- c(0.75,.05,0.4,0.75)
upperLimit <- c(2.1,0.33,1.22,2.75)
color <- brewer.pal(8, 'Dark2')
ToolColorMap <- c(color[3],color[2],color[1])



pAlledited <- spvs_RainCloud(dfHERCsep, '/ [tCr]',list('GABA','GABAplus','GSH','Asc','Asp','NAAG','Lac','PE'),c('Group'),title=c(""),colNum=3,CVlabel=2)
pAllunedited <- spvs_RainCloud(dfHERCsep, '/ [tCr]',list('NAA','tCho','Ins','Glu','Gln','Glx'),c('Group'),title=c(""),colNum=3,CVlabel=2)

ggsave(file="/Volumes/Samsung/working/HERCULES/derivativesACC/Figures/RaincloudEdited.pdf", pAlledited, width = 10, height = 10,device=cairo_pdf) #saves g
ggsave(file="/Volumes/Samsung/working/HERCULES/derivativesACC/Figures/RaincloudUnEdited.pdf", pAllunedited, width = 10, height = 10,device=cairo_pdf) #saves g

dfHERCsepini <- dfHERCsep[seq(1, nrow(dfHERCsep), 2), ] 
dfHERCseprep <- dfHERCsep[seq(2, nrow(dfHERCsep), 2), ] 

lowerLimit <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
upperLimit <- c(17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32)

lowerLimit <- c(0,0,0,0,0,0,0,0,-0.25,-0.075,-0.2,-0.15,-0.15,-0.15,-0.3,-0.4)
upperLimit <- c(0.5,0.15,0.4,0.3,0.3,0.3,0.6,0.8,0.25,0.075,0.2,0.15,0.15,0.15,0.3,0.4)

p1 <- spvs_BlandAltman(list(dfHERCsepini,dfHERCseprep)," / [tCr]",c('Asc','Asp','GABA','GABAplus','GSH','Lac','NAAG','PE'),c('test','retest'),c('',''),NULL,lowerLimit,upperLimit, 3)
p1 <- p1 + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
lowerLimit <- c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
upperLimit <- c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
p2 <- spvs_BlandAltman(list(dfHERCsepini,dfHERCseprep)," / [tCr]",c('NAA','tCho','Ins','Glu','Gln','Glx'),c('test','retest'),c('HERCsep','HERCsep'),NULL,lowerLimit,upperLimit, 3)
p2 <- p2 + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)

ggsave(file="/Volumes/Samsung/working/HERCULES/derivativesACC/Figures/EditedBA_ACC.pdf", p1, width = 10, height = 10,device=cairo_pdf) #saves g
ggsave(file="/Volumes/Samsung/working/HERCULES/derivativesACC/Figures/UnEditedBA.pdf", p2, width = 10, height = 10,device=cairo_pdf) #saves g



## PCC
dfHERCsum <- spvs_importResults('/Volumes/Samsung/working/HERCULES/derivativesPCC3/QuantifyResults/sum_tCr_Voxel_1.csv')
dfHERCdiff1 <- spvs_importResults('/Volumes/Samsung/working/HERCULES/derivativesPCC3/QuantifyResults/diff1_tCr_Voxel_1.csv')
dfHERCdiff2 <- spvs_importResults('/Volumes/Samsung/working/HERCULES/derivativesPCC3/QuantifyResults/diff2_tCr_Voxel_1.csv')


dfHERCsep <- dfHERCsum

dfHERCsep$Asc <- dfHERCdiff2$Asc
dfHERCsep$Asp <- dfHERCdiff2$Asp
dfHERCsep$GSH <- dfHERCdiff2$GSH
dfHERCsep$NAAG <- dfHERCdiff2$NAAG
dfHERCsep$GABA <- dfHERCdiff1$GABA
dfHERCsep$GABAplus <- dfHERCdiff1$GABAplus
dfHERCsep$Lac <- dfHERCdiff2$Lac
dfHERCsep$PE <- dfHERCdiff2$PE
dfHERCsep$NAA <- dfHERCsum$NAA
dfHERCsep$tCho <- dfHERCsum$tCho
dfHERCsep$Ins <- dfHERCsum$Ins
dfHERCsep$Glu <- dfHERCsum$Glu
dfHERCsep$Gln <- dfHERCsum$Gln
dfHERCsep$Glx <- dfHERCsum$Glx

dfHERCsep <- spvs_AddStatsToDataframe(dfHERCsep,'/Volumes/Samsung/working/HERCULES/derivatives/stat.csv')

lowerLimit <- c(0,0,0,0,0,0,0,0)
upperLimit <- (c(0.5,0.15,0.4,0.3,0.2,0.2,0.6,0.6))
color <- brewer.pal(8, 'Dark2')
ToolColorMap <- c(color[3],color[2],color[1])

pAlledited <- spvs_RainCloud(dfHERCsep, '/ [tCr]',list('Asc','Asp','GABA','GABAplus','GSH','Lac','NAAG','PE'),c('Group'),lowerLimits = lowerLimit, upperLimits=upperLimit,title=c(""),colNum=8,CVlabel=2)
pAllunedited <- spvs_RainCloud(dfHERCsep, '/ [tCr]',list('NAA','tCho','Ins','Glu','Gln','Glx'),c('Group'),title=c(""),colNum=3,CVlabel=2)

ggsave(file="/Volumes/Samsung/working/HERCULES/derivativesPCC3/Figures/RaincloudEdited.pdf", pAlledited, width = 20, height = 10,device=cairo_pdf) #saves g
ggsave(file="/Volumes/Samsung/working/HERCULES/derivativesPCC3/Figures/RaincloudUnEdited.pdf", pAllunedited, width = 10, height = 10,device=cairo_pdf) #saves g

dfHERCsepini <- dfHERCsep[seq(1, nrow(dfHERCsep), 2), ] 
dfHERCseprep <- dfHERCsep[seq(2, nrow(dfHERCsep), 2), ] 

lowerLimit <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
upperLimit <- c(17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32)

lowerLimit <- c(0,0,0,0,0,0,0,0,-0.25,-0.075,-0.2,-0.15,-0.1,-0.1,-0.3,-0.3)
upperLimit <- c(0.5,0.15,0.4,0.3,0.2,0.2,0.6,0.6,0.25,0.075,0.2,0.15,0.1,0.1,0.3,0.3)

p1 <- spvs_BlandAltman(list(dfHERCsepini,dfHERCseprep)," / [tCr]",c('Asc','Asp','GABA','GABAplus','GSH','Lac','NAAG','PE'),c('test','retest'),c('',''),NULL,lowerLimit,upperLimit, 8)
p1 <- p1 + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
lowerLimit <- c(0,0,0,0,0,0,-0.6,-0.6,-0.6,-0.6,-0.6,-0.6)
upperLimit <- c(0.6,0.2,0.35,0.35,0.6,0.6,0.6,0.6,0.6,0.6,0.6,0.6)
p2 <- spvs_BlandAltman(list(dfHERCsepini,dfHERCseprep)," / [tCr]",c('NAA','tCho','Ins','Glu','Gln','Glx'),c('test','retest'),c('',''),NULL,lowerLimit,upperLimit, 3)
p2 <- p2 + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
ggsave(file="/Volumes/Samsung/working/HERCULES/derivativesPCC3/Figures/EditedBA.pdf", p1, width = 20, height = 10,device=cairo_pdf) #saves g
ggsave(file="/Volumes/Samsung/working/HERCULES/derivativesPCC3/Figures/UnEditedBA.pdf", p2, width = 10, height = 10,device=cairo_pdf) #saves g

