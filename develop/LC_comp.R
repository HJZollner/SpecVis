source('functions/dependencies.R')
source('functions/spvs_importResults.R')
source('functions/spvs_Correlation.R')
source('functions/spvs_Correlation_Facet.R')
source('functions/spvs_AddStatsToDataframe.R')
source('functions/spvs_ConcatenateDataFrame.R')
source('functions/spvs_RainCloud.R')

dfPDOsp <- spvs_importResults('/Volumes/Samsung_T5/working/PDmPFC/derivativesConvR/QuantifyResults/off_tCr.csv')
dataPDLCM <- spvs_importResults('/Volumes/Samsung_T5/working/PDmPFC/derivativesBasischange/LCMoutput')
dfPDLCM <- dataPDLCM[[1]]


dfPDOsp <- spvs_AddStatsToDataframe(dfPDOsp,'/Volumes/Samsung_T5/working/PDmPFC/derivativesBasischange/stat.csv')
dataPDLCM <- spvs_AddStatsToDataframe(dataPDLCM,'/Volumes/Samsung_T5/working/PDmPFC/derivativesBasischange/stat.csv')


dfPDOspLS <- read.csv('/Volumes/Samsung_T5/working/PDmPFC/derivativesConvR/GaussParams/Osprey_lineshapes.csv', header = TRUE,stringsAsFactors = FALSE)
dfPDLCMLS <- read.csv('/Volumes/Samsung_T5/working/PDmPFC/derivativesConvR/GaussParams/LCModel_lineshapes.csv', header = TRUE,stringsAsFactors = FALSE)

dfPDOsp <- bind_cols(dfPDOsp,dfPDOspLS) 
dfPDLCM <- bind_cols(dfPDLCM,dfPDLCMLS) 


lowerLimit <- c(0.75,.05,0.4)
upperLimit <- c(2.1,0.33,1.22)

color <- brewer.pal(8, 'Paired')
ToolColorMap <- c(color[6],color[2],color[4])

dfPD <- spvs_ConcatenateDataFrame(list(dfPDOsp,dfPDLCM),c('Osprey','LCModel'))


pPD <- spvs_RainCloud(dfPD, '/ [tCr]',list('Glx','Glu','Gln'),c('Group'),lowerLimit,upperLimit,c(""),3)
pPD <- pPD + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
ggsave(file="RaincloudByGlx.pdf", pPD, width = 5, height = 5,device=cairo_pdf) #saves g


lowerLimit <- c(0,0,0)
upperLimit <- c(80,80,80)
pPDls <- spvs_RainCloud(dfPD, '',list('iniGauss','convolutionRangeCC','convolutionRangePrelim'),c('Group'),lowerLimit,upperLimit,c(""),3)
pPDls <- pPDls + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
ggsave(file="RaincloudLineshapes.pdf", pPDls, width = 10, height = 7.5,device=cairo_pdf) #saves g

lowerLimit <- c(0,0,0)
upperLimit <- c(2,2,2)

pPDc <- spvs_Correlation(list(dfPDOsp,dfPDLCM)," / [tCr]",c("Glx","Glu","Gln"),c('Osprey','LCModel'),c('',''),NULL,lowerLimit,upperLimit, 3)
ggsave(file="CorrelationCollapsed.pdf", pPDc, width = 5, height = 5,device=cairo_pdf) #saves g


dfPhOspLS <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/GaussParams/Osprey_lineshapes.csv', header = TRUE,stringsAsFactors = FALSE)
dfPhLCMLS <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/GaussParams/LCModel_lineshapes.csv', header = TRUE,stringsAsFactors = FALSE)

dfPhOspLS <- spvs_AddStatsToDataframe(dfPhOspLS,'/Volumes/Samsung_T5/working/ISMRM/Philips/stat.csv')
dfPhLCMLS <- spvs_AddStatsToDataframe(dfPhLCMLS,'/Volumes/Samsung_T5/working/ISMRM/Philips/stat.csv')
dfPh <- spvs_ConcatenateDataFrame(list(dfPhOspLS,dfPhLCMLS),c('Osprey','LCModel'))

lowerLimit <- c(0,0,0)
upperLimit <- c(20,20,20)

pPhls <- spvs_RainCloud(dfPh, '',list('iniGauss','convolutionRangeCC','convolutionRangePrelim'),c('Group'),lowerLimit,upperLimit,c(""),3)
pPhls <- pPhls + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
ggsave(file="RaincloudLineshapesPh.pdf", pPhls, width = 10, height = 7.5,device=cairo_pdf) #saves g

