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

dfdefault <- spvs_importResults('/Volumes/Samsung/working/ISMRM/Philips/derivativesLCM/QuantifyResults/off_tCr.csv')
dfmoreMM15 <- spvs_importResults('/Volumes/Samsung/working/ISMRM/Philips/derivativesMM/moreMM15/QuantifyResults/off_tCr.csv')
dfmoreMM40 <- spvs_importResults('/Volumes/Samsung/working/ISMRM/Philips/derivativesMM/moreMM40/QuantifyResults/off_tCr.csv')
dfexpMM15 <- spvs_importResults('/Volumes/Samsung/working/ISMRM/Philips/derivativesMM/MMexp15/QuantifyResults/off_tCr.csv')
dfexpMM40 <- spvs_importResults('/Volumes/Samsung/working/ISMRM/Philips/derivativesMM/MMexp40/QuantifyResults/off_tCr.csv')


dfModels <- spvs_ConcatenateDataFrame(list(dfdefault,dfmoreMM15,dfmoreMM40,dfexpMM15,dfexpMM40),c('A-default','B-moreMM15','C-moreMM40','D-expMM15','E-expMM40'))

lowerLimit <- c(0.1,0.1,0.1,0.1)
upperLimit <- c(0.2,0.2,0.2,0.2)
color <- brewer.pal(10, 'Paired')


pLCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('tNAA','tCho','Ins','Glx'),c('Group'),lowerLimit,upperLimit,c(""),4)
pLCM <- pLCM + scale_color_manual(values = color)+scale_fill_manual(values = color)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/RaincloudAllexpMMmodelPhilips.pdf", pLCM, width = 30, height = 3,device=cairo_pdf) #saves g


