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

dfHERCsum <- spvs_importResults('/Volumes/Samsung/working/32_R21_HERCULES_MCI/derivatives/QuantifyResults/sum_tCr_Voxel_1.csv')
dfHERCdiff1 <- spvs_importResults('/Volumes/Samsung/working/32_R21_HERCULES_MCI/derivatives/QuantifyResults/diff1_tCr_Voxel_1.csv')
dfHERCdiff2 <- spvs_importResults('/Volumes/Samsung/working/32_R21_HERCULES_MCI/derivatives/QuantifyResults/diff2_tCr_Voxel_1.csv')


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

dfHERCsep <- spvs_AddStatsToDataframe(dfHERCsep,'/Volumes/Samsung/working/32_R21_HERCULES_MCI/derivatives/stat.csv')

lowerLimit <- c(0,0,0,0,0,0,0,0)
upperLimit <- (c(0.5,0.15,0.4,0.3,0.2,0.2,0.6,0.6))
color <- brewer.pal(8, 'Dark2')
ToolColorMap <- c(color[3],color[2],color[1])

pAlledited <- spvs_RainCloud(dfHERCsep, '/ [tCr]',list('Asc','Asp','GABA','GABAplus','GSH','Lac','NAAG','PE'),c('Group'),lowerLimits = lowerLimit, upperLimits=upperLimit,title=c(""),colNum=8,CVlabel=2)

lowerLimit <- c(0,0,0,0,0,0)
upperLimit <- (c(0.5,0.15,0.4,0.3,0.2,0.2))
pAllunedited <- spvs_RainCloud(dfHERCsep, '/ [tCr]',list('Gln','Glu','Glx','Ins','NAA','PE','tCho','tNAA'),c('Group'),title=c(""),colNum=8,CVlabel=2)

ggsave(file="/Volumes/Samsung/working/32_R21_HERCULES_MCI/derivatives/Figures/RaincloudEdited.pdf", pAlledited, width = 20, height = 10,device=cairo_pdf) #saves g
ggsave(file="/Volumes/Samsung/working/32_R21_HERCULES_MCI/derivatives/Figures/RaincloudUnEdited.pdf", pAllunedited, width = 20, height = 10,device=cairo_pdf) #saves g


statsEdited <- spvs_Statistics(dfHERCsep,list('Asc','Asp','GABA','GABAplus','GSH','Lac','NAAG','PE'),0)
sink('/Volumes/Samsung/working/32_R21_HERCULES_MCI/derivatives/MCI_PCC_Edited_stat.txt')
print(statsEdited)
sink()


statsUnEdited <- spvs_Statistics(dfHERCsep,list('Gln','Glu','Glx','Ins','NAA','tCho','tNAA'),0)
sink('/Volumes/Samsung/working/32_R21_HERCULES_MCI/derivatives/MCI_PCC_UnEdited_stat.txt')
print(statsUnEdited)
sink()
