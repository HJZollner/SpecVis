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

dfNoMM <- spvs_importResults('/Volumes/Samsung/working/ISMRM/Philips/derivativesMP/QuantifyResults/diff1_tCr.csv')
df1to1 <- spvs_importResults('/Volumes/Samsung/working/ISMRM/Philips/derivativesMP1tot1GABA14/QuantifyResults/diff1_tCr.csv')
df3to2 <- spvs_importResults('/Volumes/Samsung/working/ISMRM/Philips/derivativesMP3to2MM/QuantifyResults/diff1_tCr.csv')
df1to1soft <- spvs_importResults('/Volumes/Samsung/working/ISMRM/Philips/derivativesMP1to1GABAsoft/QuantifyResults/diff1_tCr.csv')
df3to2soft <- spvs_importResults('/Volumes/Samsung/working/ISMRM/Philips/derivativesMP3to2MMsoft/QuantifyResults/diff1_tCr.csv')
dfFreeGauss <- spvs_importResults('/Volumes/Samsung/working/ISMRM/Philips/derivativesMPGaussFree/QuantifyResults/diff1_tCr.csv')
dfFreeGaussReal <- spvs_importResults('/Volumes/Samsung/working/ISMRM/Philips/derivativesMPGaussFreeReal/QuantifyResults/diff1_tCr.csv')
dfHCar <- spvs_importResults('/Volumes/Samsung/working/ISMRM/Philips/derivativesMPHCar/QuantifyResults/diff1_tCr.csv')


## Full fit range
dfGannet <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/MP_Philips_Gannet.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfGannet <- dfGannet[-c(2,6,8,18,19,20,21,22,23,24,25,26,27,28,29,33,47,48,49,62,66,67,69,86,87,88,89,90,91,92,93,94,95,96,97),]
dfNoMM <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_none.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfNoMM <- dfNoMM[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
##dfNoMM$GABAtoCr <- dfNoMM$GABAtoCr*0.5
dfNoMMCr <- dfNoMM
dfNoMM$GABAtoCr <- dfNoMM$GABAArea/dfNoMMCr$CrArea*0.5

df1to1 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_1to1GABA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1 <- df1to1[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
##df1to1$GABAtoCr <- df1to1$GABAtoCr*0.5
df1to1$GABAtoCr <- df1to1$GABAArea/dfNoMMCr$CrArea*0.5

df3to2 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_3to2MM.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df3to2 <- spvs_AddStatsToDataframe(df3to2,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df3to2 <- df3to2[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
##df3to2$GABAtoCr <- df3to2$GABAtoCr*0.5
df3to2$GABAtoCr <- df3to2$GABAArea/dfNoMMCr$CrArea*0.5

df1to1soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_1to1GABAsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1soft <- df1to1soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
##df1to1soft$GABAtoCr <- df1to1soft$GABAtoCr*0.5
df1to1soft$GABAtoCr <- df1to1soft$GABAArea/dfNoMMCr$CrArea*0.5

df3to2soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_3to2MMsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df3to2soft <- spvs_AddStatsToDataframe(df3to2soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df3to2soft <- df3to2soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
##df3to2soft$GABAtoCr <- df3to2soft$GABAtoCr*0.5
df3to2soft$GABAtoCr <- df3to2soft$GABAArea/dfNoMMCr$CrArea*0.5

dfFixedGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_freeGauss14.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFixedGauss <- dfFixedGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
##dfFixedGauss$GABAtoCr <- dfFixedGauss$GABAtoCr*0.5
dfFixedGauss$GABAtoCr <- dfFixedGauss$GABAArea/dfNoMMCr$CrArea*0.5

dfFreeGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_freeGauss.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFreeGauss <- dfFreeGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
##dfFreeGauss$GABAtoCr <- dfFreeGauss$GABAtoCr*0.5
dfFreeGauss$GABAtoCr <- dfFreeGauss$GABAArea/dfNoMMCr$CrArea*0.5

dfHCar <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_HCar.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfHCar <- spvs_AddStatsToDataframe(dfHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfHCar <- dfHCar[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
##dfHCar$GABAtoCr <- dfHCar$GABAtoCr*0.5
dfHCar$GABAtoCr <- dfHCar$GABAArea/dfNoMMCr$CrArea*0.5

dfModels <- spvs_ConcatenateDataFrame(list(dfGannet,dfNoMM,df1to1,df1to1soft,df3to2,df3to2soft,dfFreeGauss,dfFixedGauss,dfHCar),c('A-Gannet','B-NoMM','C-GABAFixed','D-soft1to1GABA','E-MM09Fixed','F-soft3to2MM09','G-FixedGauss','H-FreeGauss','I-HCar'))
dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,df3to2,df3to2soft,dfFreeGauss,dfFixedGauss,dfHCar),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-MM09Fixed','F-soft3to2MM09','G-FixedGauss','H-FreeGauss','I-HCar'))


lowerLimit <- rev(c(0))
upperLimit <- rev(c(0.24))
lowerLimitRes <- rev(c(0,0))
upperLimitRes <- rev(c(20,6))
colorPaired <- brewer.pal(10, 'Paired')
colorDark <- brewer.pal(8, 'Dark2')
colorGABA <- c(colorPaired[10],colorDark[8],colorPaired[2],colorPaired[1],colorPaired[4],colorPaired[3],colorPaired[6],colorPaired[5],colorDark[2])
colorRes <- c(colorDark[8],colorPaired[2],colorPaired[1],colorPaired[4],colorPaired[3],colorPaired[6],colorPaired[5],colorDark[2])

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrFull.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrFullCV.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModelsOsprey, '',list('GABAResRelAmpl','GABAResSD'),c('Group'),lowerLimitRes,upperLimitRes,c(""),2,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorRes)+scale_fill_manual(values = colorRes)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrFullRes.pdf", pGABALCM, width = 15, height = 3,device=cairo_pdf) #saves g

## Intermediate fit range
dfGannet <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/MP_Philips_Gannet.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfGannet <- dfGannet[-c(2,6,8,18,19,20,21,22,23,24,25,26,27,28,29,33,47,48,49,62,66,67,69,86,87,88,89,90,91,92,93,94,95,96,97),]
dfNoMM <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intind/Ph_Osp_GABAtoCr_none.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfNoMM <- dfNoMM[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfNoMM$GABAtoCr <- dfNoMM$GABAtoCr*0.5
dfNoMM$GABAtoCr <- dfNoMM$GABAArea/dfNoMMCr$CrArea*0.5

df1to1 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intind/Ph_Osp_GABAtoCr_1to1GABA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1 <- df1to1[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1$GABAtoCr <- df1to1$GABAtoCr*0.5
df1to1$GABAtoCr <- df1to1$GABAArea/dfNoMMCr$CrArea*0.5

df1to1soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intind/Ph_Osp_GABAtoCr_1to1GABAsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1soft <- df1to1soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1soft$GABAtoCr <- df1to1soft$GABAtoCr*0.5
df1to1soft$GABAtoCr <- df1to1soft$GABAArea/dfNoMMCr$CrArea*0.5

dfFixedGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intind/Ph_Osp_GABAtoCr_freeGauss14.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFixedGauss <- dfFixedGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFixedGauss$GABAtoCr <- dfFixedGauss$GABAtoCr*0.5
dfFixedGauss$GABAtoCr <- dfFixedGauss$GABAArea/dfNoMMCr$CrArea*0.5

dfFreeGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intind/Ph_Osp_GABAtoCr_freeGauss.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFreeGauss <- dfFreeGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFreeGauss$GABAtoCr <- dfFreeGauss$GABAtoCr*0.5
dfFreeGauss$GABAtoCr <- dfFreeGauss$GABAArea/dfNoMMCr$CrArea*0.5

dfHCar <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intind/Ph_Osp_GABAtoCr_HCar.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfHCar <- spvs_AddStatsToDataframe(dfHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfHCar <- dfHCar[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfHCar$GABAtoCr <- dfHCar$GABAtoCr*0.5
dfHCar$GABAtoCr <- dfHCar$GABAArea/dfNoMMCr$CrArea*0.5

dfModels <- spvs_ConcatenateDataFrame(list(dfGannet,dfNoMM,df1to1,df1to1soft,dfFixedGauss,dfFreeGauss,dfHCar),c('A-Gannet','B-NoMM','C-GABAFixed','D-soft1to1GABA','G-FixedGauss','H-FreeGauss','I-HCar'))
dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFixedGauss,dfFreeGauss,dfHCar),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','G-FixedGauss','H-FreeGauss','I-HCar'))


lowerLimit <- rev(c(0))
upperLimit <- rev(c(0.24))
colorPaired <- brewer.pal(10, 'Paired')
colorDark <- brewer.pal(8, 'Dark2')
colorGABA <- c(colorPaired[10],colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorDark[2])
colorRes <- c(colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorDark[2])


pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrInt.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrIntCV.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModelsOsprey, '',list('GABAResRelAmpl','GABAResSD'),c('Group'),lowerLimitRes,upperLimitRes,c(""),2,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorRes)+scale_fill_manual(values = colorRes)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrIntRes.pdf", pGABALCM, width = 15, height = 3,device=cairo_pdf) #saves g


## Reduced fit range
dfGannet <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/MP_Philips_Gannet.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfGannet <- dfGannet[-c(2,6,8,18,19,20,21,22,23,24,25,26,27,28,29,33,47,48,49,62,66,67,69,86,87,88,89,90,91,92,93,94,95,96,97),]
dfNoMM <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redind/Ph_Osp_GABAtoCr_none.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfNoMM <- dfNoMM[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfNoMM$GABAtoCr <- dfNoMM$GABAtoCr*0.5
dfNoMM$GABAtoCr <- dfNoMM$GABAArea/dfNoMMCr$CrArea*0.5

df1to1 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redind/Ph_Osp_GABAtoCr_1to1GABA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1 <- df1to1[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1$GABAtoCr <- df1to1$GABAtoCr*0.5
df1to1$GABAtoCr <- df1to1$GABAArea/dfNoMMCr$CrArea*0.5

df1to1soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redind/Ph_Osp_GABAtoCr_1to1GABAsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1soft <- df1to1soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1soft$GABAtoCr <- df1to1soft$GABAtoCr*0.5
df1to1soft$GABAtoCr <- df1to1soft$GABAArea/dfNoMMCr$CrArea*0.5

dfFixedGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redind/Ph_Osp_GABAtoCr_freeGauss14.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFixedGauss <- dfFixedGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFixedGauss$GABAtoCr <- dfFixedGauss$GABAtoCr*0.5
dfFixedGauss$GABAtoCr <- dfFixedGauss$GABAArea/dfNoMMCr$CrArea*0.5

dfFreeGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redind/Ph_Osp_GABAtoCr_freeGauss.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFreeGauss <- dfFreeGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFreeGauss$GABAtoCr <- dfFreeGauss$GABAtoCr*0.5
dfFreeGauss$GABAtoCr <- dfFreeGauss$GABAArea/dfNoMMCr$CrArea*0.5

dfHCar <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redind/Ph_Osp_GABAtoCr_HCar.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfHCar <- spvs_AddStatsToDataframe(dfHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfHCar <- dfHCar[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfHCar$GABAtoCr <- dfHCar$GABAtoCr*0.5
dfHCar$GABAtoCr <- dfHCar$GABAArea/dfNoMMCr$CrArea*0.5

dfModels <- spvs_ConcatenateDataFrame(list(dfGannet,dfNoMM,df1to1,df1to1soft,dfFixedGauss,dfFreeGauss,dfHCar),c('A-Gannet','B-NoMM','C-GABAFixed','D-soft1to1GABA','G-FixedGauss','H-FreeGauss','I-HCar'))
dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFixedGauss,dfFreeGauss,dfHCar),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','G-FixedGauss','H-FreeGauss','I-HCar'))

lowerLimit <- rev(c(0))
upperLimit <- rev(c(0.24))
colorPaired <- brewer.pal(10, 'Paired')
colorDark <- brewer.pal(8, 'Dark2')
colorGABA <- c(colorPaired[10],colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorDark[2])
colorRes <- c(colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorDark[2])


pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrRed.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrRedCV.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModelsOsprey, '',list('GABAResRelAmpl','GABAResSD'),c('Group'),lowerLimitRes,upperLimitRes,c(""),2,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorRes)+scale_fill_manual(values = colorRes)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrRedRes.pdf", pGABALCM, width = 15, height = 3,device=cairo_pdf) #saves g


## Full fit range comb
dfGannet <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/MP_Philips_Gannet.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfGannet <- dfGannet[-c(2,6,8,18,19,20,21,22,23,24,25,26,27,28,29,33,47,48,49,62,66,67,69,86,87,88,89,90,91,92,93,94,95,96,97),]

df1to1 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullcomb/Ph_Osp_GABAtoCr_1to1GABA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1 <- df1to1[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1$GABAtoCr <- df1to1$GABAtoCr*0.5

df3to2 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullcomb/Ph_Osp_GABAtoCr_3to2MM.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df3to2 <- spvs_AddStatsToDataframe(df3to2,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df3to2 <- df3to2[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df3to2$GABAtoCr <- df3to2$GABAtoCr*0.5

df1to1soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullcomb/Ph_Osp_GABAtoCr_1to1GABAsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1soft <- df1to1soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1soft$GABAtoCr <- df1to1soft$GABAtoCr*0.5

df3to2soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullcomb/Ph_Osp_GABAtoCr_3to2MMsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df3to2soft <- spvs_AddStatsToDataframe(df3to2soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df3to2soft <- df3to2soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df3to2soft$GABAtoCr <- df3to2soft$GABAtoCr*0.5

dfFixedGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullcomb/Ph_Osp_GABAtoCr_freeGauss14.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFixedGauss <- dfFixedGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFixedGauss$GABAtoCr <- dfFixedGauss$GABAtoCr*0.5

dfFreeGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullcomb/Ph_Osp_GABAtoCr_freeGauss.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFreeGauss <- dfFreeGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFreeGauss$GABAtoCr <- dfFreeGauss$GABAtoCr*0.5

dfModels <- spvs_ConcatenateDataFrame(list(dfGannet,df1to1,df1to1soft,df3to2,df3to2soft,dfFreeGauss,dfFixedGauss),c('A-Gannet','C-GABAFixed','D-soft1to1GABA','E-MM09Fixed','F-soft3to2MM09','G-FixedGauss','H-FreeGauss'))
dfModelsOsprey <- spvs_ConcatenateDataFrame(list(df1to1,df1to1soft,df3to2,df3to2soft,dfFreeGauss,dfFixedGauss),c('C-GABAFixed','D-soft1to1GABA','E-MM09Fixed','F-soft3to2MM09','G-FixedGauss','H-FreeGauss'))

lowerLimit <- rev(c(0))
upperLimit <- rev(c(0.24))
colorPaired <- brewer.pal(10, 'Paired')
colorDark <- brewer.pal(8, 'Dark2')
colorGABA <- c(colorPaired[10],colorPaired[2],colorPaired[1],colorPaired[4],colorPaired[3],colorPaired[6],colorPaired[5])
colorRes <- c(colorPaired[2],colorPaired[1],colorPaired[4],colorPaired[3],colorPaired[6],colorPaired[5])


pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrFullComb.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrFullCombCV.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModelsOsprey, '',list('GABAResRelAmpl','GABAResSD'),c('Group'),lowerLimitRes,upperLimitRes,c(""),2,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorRes)+scale_fill_manual(values = colorRes)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrFullCombRes.pdf", pGABALCM, width = 15, height = 3,device=cairo_pdf) #saves g

## Intermediate fit range comb
dfGannet <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/MP_Philips_Gannet.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfGannet <- dfGannet[-c(2,6,8,18,19,20,21,22,23,24,25,26,27,28,29,33,47,48,49,62,66,67,69,86,87,88,89,90,91,92,93,94,95,96,97),]

df1to1 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intcomb/Ph_Osp_GABAtoCr_1to1GABA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1 <- df1to1[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1$GABAtoCr <- df1to1$GABAtoCr*0.5

df1to1soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intcomb/Ph_Osp_GABAtoCr_1to1GABAsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1soft <- df1to1soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1soft$GABAtoCr <- df1to1soft$GABAtoCr*0.5

dfFixedGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intcomb/Ph_Osp_GABAtoCr_freeGauss14.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFixedGauss <- dfFixedGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFixedGauss$GABAtoCr <- dfFixedGauss$GABAtoCr*0.5

dfFreeGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intcomb/Ph_Osp_GABAtoCr_freeGauss.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFreeGauss <- dfFreeGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFreeGauss$GABAtoCr <- dfFreeGauss$GABAtoCr*0.5

dfModels <- spvs_ConcatenateDataFrame(list(dfGannet,df1to1,df1to1soft,dfFixedGauss,dfFreeGauss),c('A-Gannet','C-GABAFixed','D-soft1to1GABA','G-FixedGauss','H-FreeGauss'))
dfModelsOsprey <- spvs_ConcatenateDataFrame(list(df1to1,df1to1soft,dfFixedGauss,dfFreeGauss),c('C-GABAFixed','D-soft1to1GABA','G-FixedGauss','H-FreeGauss'))

lowerLimit <- rev(c(0))
upperLimit <- rev(c(0.24))
colorPaired <- brewer.pal(10, 'Paired')
colorDark <- brewer.pal(8, 'Dark2')
colorGABA <- c(colorPaired[10],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5])
colorRes <- c(colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5])

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrIntComb.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrIntCombCV.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModelsOsprey, '',list('GABAResRelAmpl','GABAResSD'),c('Group'),lowerLimitRes,upperLimitRes,c(""),2,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorRes)+scale_fill_manual(values = colorRes)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrIntCombRes.pdf", pGABALCM, width = 15, height = 3,device=cairo_pdf) #saves g

## Reduced fit range comb
dfGannet <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/MP_Philips_Gannet.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfGannet <- dfGannet[-c(2,6,8,18,19,20,21,22,23,24,25,26,27,28,29,33,47,48,49,62,66,67,69,86,87,88,89,90,91,92,93,94,95,96,97),]

df1to1 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redcomb/Ph_Osp_GABAtoCr_1to1GABA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1 <- df1to1[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1$GABAtoCr <- df1to1$GABAtoCr*0.5

df1to1soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redcomb/Ph_Osp_GABAtoCr_1to1GABAsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1soft <- df1to1soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1soft$GABAtoCr <- df1to1soft$GABAtoCr*0.5

dfFixedGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redcomb/Ph_Osp_GABAtoCr_freeGauss14.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFixedGauss <- dfFixedGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFixedGauss$GABAtoCr <- dfFixedGauss$GABAtoCr*0.5

dfFreeGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redcomb/Ph_Osp_GABAtoCr_freeGauss.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFreeGauss <- dfFreeGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFreeGauss$GABAtoCr <- dfFreeGauss$GABAtoCr*0.5

dfModels <- spvs_ConcatenateDataFrame(list(dfGannet,df1to1,df1to1soft,dfFixedGauss,dfFreeGauss),c('A-Gannet','C-GABAFixed','D-soft1to1GABA','G-FixedGauss','H-FreeGauss'))
dfModelsOsprey <- spvs_ConcatenateDataFrame(list(df1to1,df1to1soft,dfFixedGauss,dfFreeGauss),c('C-GABAFixed','D-soft1to1GABA','G-FixedGauss','H-FreeGauss'))

lowerLimit <- rev(c(0))
upperLimit <- rev(c(0.24))
colorPaired <- brewer.pal(10, 'Paired')
colorDark <- brewer.pal(8, 'Dark2')
colorGABA <- c(colorPaired[10],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5])
colorRes <- c(colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5])


pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrRedComb.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrRedCombCV.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModelsOsprey, '',list('GABAResRelAmpl','GABAResSD'),c('Group'),lowerLimitRes,upperLimitRes,c(""),2,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorRes)+scale_fill_manual(values = colorRes)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/GABAtoCrRedCombRes.pdf", pGABALCM, width = 15, height = 3,device=cairo_pdf) #saves g

## Full fit range MM sup
dfMMsup <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreasMMsup/fullind/Ph_Osp_GABAtoCr_none.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfMMsup <- spvs_AddStatsToDataframe(dfMMsup,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfMMsup <- dfMMsup[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfMMsup$pureGABAtoCr <- dfMMsup$pureGABAtoCr*0.5

dfNoMM <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_none.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfNoMM <- dfNoMM[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfNoMM$pureGABAtoCr <- dfNoMM$pureGABAtoCr*0.5

df1to1 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_1to1GABA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1 <- df1to1[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1$pureGABAtoCr <- df1to1$pureGABAtoCr*0.5

df3to2 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_3to2MM.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df3to2 <- spvs_AddStatsToDataframe(df3to2,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df3to2 <- df3to2[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df3to2$pureGABAtoCr <- df3to2$pureGABAtoCr*0.5

df1to1soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_1to1GABAsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1soft <- df1to1soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1soft$pureGABAtoCr <- df1to1soft$pureGABAtoCr*0.5

df3to2soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_3to2MMsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df3to2soft <- spvs_AddStatsToDataframe(df3to2soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df3to2soft <- df3to2soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df3to2soft$pureGABAtoCr <- df3to2soft$pureGABAtoCr*0.5

dfFixedGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_freeGauss14.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFixedGauss <- dfFixedGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFixedGauss$pureGABAtoCr <- dfFixedGauss$pureGABAtoCr*0.5

dfFreeGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_freeGauss.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFreeGauss <- dfFreeGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFreeGauss$pureGABAtoCr <- dfFreeGauss$pureGABAtoCr*0.5

dfHCar <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullind/Ph_Osp_GABAtoCr_HCar.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfHCar <- spvs_AddStatsToDataframe(dfHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfHCar <- dfHCar[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfHCar$pureGABAtoCr <- dfHCar$pureGABAtoCr*0.5

dfModels <- spvs_ConcatenateDataFrame(list(dfMMsup,dfNoMM,df1to1,df1to1soft,df3to2,df3to2soft,dfFreeGauss,dfFixedGauss,dfHCar),c('A-MMsup','B-NoMM','C-GABAFixed','D-soft1to1GABA','E-MM09Fixed','F-soft3to2MM09','G-FixedGauss','H-FreeGauss','I-HCar'))

lowerLimit <- rev(c(0))
upperLimit <- rev(c(0.15))

colorPaired <- brewer.pal(10, 'Paired')
colorDark <- brewer.pal(8, 'Dark2')
colorGABA <- c(colorDark[4],colorDark[8],colorPaired[2],colorPaired[1],colorPaired[4],colorPaired[3],colorPaired[6],colorPaired[5],colorDark[2])

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('pureGABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/pureGABAtoCrFull.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('pureGABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/pureGABAtoCrFullCV.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

## Intermediate fit range
dfMMsup <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreasMMsup/intind/Ph_Osp_GABAtoCr_none.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfMMsup <- spvs_AddStatsToDataframe(dfMMsup,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfMMsup <- dfMMsup[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfMMsup$pureGABAtoCr <- dfMMsup$pureGABAtoCr*0.5

dfNoMM <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intind/Ph_Osp_GABAtoCr_none.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfNoMM <- dfNoMM[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfNoMM$pureGABAtoCr <- dfNoMM$pureGABAtoCr*0.5

df1to1 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intind/Ph_Osp_GABAtoCr_1to1GABA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1 <- df1to1[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1$pureGABAtoCr <- df1to1$pureGABAtoCr*0.5

df1to1soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intind/Ph_Osp_GABAtoCr_1to1GABAsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1soft <- df1to1soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1soft$pureGABAtoCr <- df1to1soft$pureGABAtoCr*0.5

dfFixedGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intind/Ph_Osp_GABAtoCr_freeGauss14.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFixedGauss <- dfFixedGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFixedGauss$pureGABAtoCr <- dfFixedGauss$pureGABAtoCr*0.5

dfFreeGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intind/Ph_Osp_GABAtoCr_freeGauss.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFreeGauss <- dfFreeGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFreeGauss$pureGABAtoCr <- dfFreeGauss$pureGABAtoCr*0.5

dfHCar <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intind/Ph_Osp_GABAtoCr_HCar.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfHCar <- spvs_AddStatsToDataframe(dfHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfHCar <- dfHCar[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfHCar$pureGABAtoCr <- dfHCar$pureGABAtoCr*0.5

dfModels <- spvs_ConcatenateDataFrame(list(dfMMsup,dfNoMM,df1to1,df1to1soft,dfFixedGauss,dfFreeGauss,dfHCar),c('A-MMsup','B-NoMM','C-GABAFixed','D-soft1to1GABA','G-FixedGauss','H-FreeGauss','I-HCar'))


lowerLimit <- rev(c(0))
upperLimit <- rev(c(0.15))
colorPaired <- brewer.pal(10, 'Paired')
colorDark <- brewer.pal(8, 'Dark2')
colorGABA <- c(colorDark[4],colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorDark[2])



pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('pureGABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/pureGABAtoCrInt.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('pureGABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/pureGABAtoCrIntCV.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g



## Reduced fit range
dfMMsup <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreasMMsup/redind/Ph_Osp_GABAtoCr_none.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfMMsup <- spvs_AddStatsToDataframe(dfMMsup,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfMMsup <- dfMMsup[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfMMsup$pureGABAtoCr <- dfMMsup$pureGABAtoCr*0.5

dfNoMM <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redind/Ph_Osp_GABAtoCr_none.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfNoMM <- dfNoMM[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfNoMM$pureGABAtoCr <- dfNoMM$pureGABAtoCr*0.5

df1to1 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redind/Ph_Osp_GABAtoCr_1to1GABA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1 <- df1to1[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1$pureGABAtoCr <- df1to1$pureGABAtoCr*0.5

df1to1soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redind/Ph_Osp_GABAtoCr_1to1GABAsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1soft <- df1to1soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1soft$pureGABAtoCr <- df1to1soft$pureGABAtoCr*0.5

dfFixedGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redind/Ph_Osp_GABAtoCr_freeGauss14.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFixedGauss <- dfFixedGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFixedGauss$pureGABAtoCr <- dfFixedGauss$pureGABAtoCr*0.5

dfFreeGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redind/Ph_Osp_GABAtoCr_freeGauss.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFreeGauss <- dfFreeGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFreeGauss$pureGABAtoCr <- dfFreeGauss$pureGABAtoCr*0.5

dfHCar <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redind/Ph_Osp_GABAtoCr_HCar.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfHCar <- spvs_AddStatsToDataframe(dfHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfHCar <- dfHCar[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfHCar$pureGABAtoCr <- dfHCar$pureGABAtoCr*0.5

dfModels <- spvs_ConcatenateDataFrame(list(dfMMsup,dfNoMM,df1to1,df1to1soft,dfFixedGauss,dfFreeGauss,dfHCar),c('A-MMsup','B-NoMM','C-GABAFixed','D-soft1to1GABA','G-FixedGauss','H-FreeGauss','I-HCar'))

lowerLimit <- rev(c(0))
upperLimit <- rev(c(0.15))
colorPaired <- brewer.pal(10, 'Paired')
colorDark <- brewer.pal(8, 'Dark2')
colorGABA <- c(colorDark[4],colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorDark[2])



pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('pureGABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/pureGABAtoCrRed.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('pureGABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/pureGABAtoCrRedCV.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g


## Full fit range comb MM sup
dfMMsup <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreasMMsup/fullind/Ph_Osp_GABAtoCr_none.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfMMsup <- spvs_AddStatsToDataframe(dfMMsup,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfMMsup <- dfMMsup[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfMMsup$pureGABAtoCr <- dfMMsup$pureGABAtoCr*0.5

df1to1 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullcomb/Ph_Osp_GABAtoCr_1to1GABA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1 <- df1to1[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1$pureGABAtoCr <- df1to1$pureGABAtoCr*0.5

df3to2 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullcomb/Ph_Osp_GABAtoCr_3to2MM.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df3to2 <- spvs_AddStatsToDataframe(df3to2,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df3to2 <- df3to2[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df3to2$pureGABAtoCr <- df3to2$pureGABAtoCr*0.5

df1to1soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullcomb/Ph_Osp_GABAtoCr_1to1GABAsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1soft <- df1to1soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1soft$pureGABAtoCr <- df1to1soft$pureGABAtoCr*0.5

df3to2soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullcomb/Ph_Osp_GABAtoCr_3to2MMsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df3to2soft <- spvs_AddStatsToDataframe(df3to2soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df3to2soft <- df3to2soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df3to2soft$pureGABAtoCr <- df3to2soft$pureGABAtoCr*0.5

dfFixedGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullcomb/Ph_Osp_GABAtoCr_freeGauss14.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFixedGauss <- dfFixedGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFixedGauss$pureGABAtoCr <- dfFixedGauss$pureGABAtoCr*0.5

dfFreeGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/fullcomb/Ph_Osp_GABAtoCr_freeGauss.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFreeGauss <- dfFreeGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFreeGauss$pureGABAtoCr <- dfFreeGauss$pureGABAtoCr*0.5

dfModels <- spvs_ConcatenateDataFrame(list(dfMMsup,df1to1,df1to1soft,df3to2,df3to2soft,dfFreeGauss,dfFixedGauss),c('A-MMsup','C-GABAFixed','D-soft1to1GABA','E-MM09Fixed','F-soft3to2MM09','G-FixedGauss','H-FreeGauss'))

lowerLimit <- rev(c(0))
upperLimit <- rev(c(0.15))
colorPaired <- brewer.pal(10, 'Paired')
colorDark <- brewer.pal(8, 'Dark2')
colorGABA <- c(colorDark[4],colorPaired[2],colorPaired[1],colorPaired[4],colorPaired[3],colorPaired[6],colorPaired[5])


pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('pureGABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/pureGABAtoCrFullComb.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('pureGABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/pureGABAtoCrFullCombCV.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

## Intermediate fit range comb
dfMMsup <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreasMMsup/intind/Ph_Osp_GABAtoCr_none.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfMMsup <- spvs_AddStatsToDataframe(dfMMsup,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfMMsup <- dfMMsup[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfMMsup$pureGABAtoCr <- dfMMsup$pureGABAtoCr*0.5

df1to1 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intcomb/Ph_Osp_GABAtoCr_1to1GABA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1 <- df1to1[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1$pureGABAtoCr <- df1to1$pureGABAtoCr*0.5

df1to1soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intcomb/Ph_Osp_GABAtoCr_1to1GABAsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1soft <- df1to1soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1soft$pureGABAtoCr <- df1to1soft$pureGABAtoCr*0.5

dfFixedGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intcomb/Ph_Osp_GABAtoCr_freeGauss14.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFixedGauss <- dfFixedGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFixedGauss$pureGABAtoCr <- dfFixedGauss$pureGABAtoCr*0.5

dfFreeGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/intcomb/Ph_Osp_GABAtoCr_freeGauss.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFreeGauss <- dfFreeGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFreeGauss$pureGABAtoCr <- dfFreeGauss$pureGABAtoCr*0.5

dfModels <- spvs_ConcatenateDataFrame(list(dfMMsup,df1to1,df1to1soft,dfFixedGauss,dfFreeGauss),c('A-MMsup','C-GABAFixed','D-soft1to1GABA','G-FixedGauss','H-FreeGauss'))

lowerLimit <- rev(c(0))
upperLimit <- rev(c(0.24))
colorPaired <- brewer.pal(10, 'Paired')
colorDark <- brewer.pal(8, 'Dark2')
colorGABA <- c(colorDark[4],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5])

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('pureGABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/pureGABAtoCrIntComb.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('pureGABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/pureGABAtoCrIntCombCV.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g


## Reduced fit range comb
dfMMsup <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreasMMsup/redind/Ph_Osp_GABAtoCr_none.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfMMsup <- spvs_AddStatsToDataframe(dfMMsup,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfMMsup <- dfMMsup[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfMMsup$pureGABAtoCr <- dfMMsup$pureGABAtoCr*0.5

df1to1 <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redcomb/Ph_Osp_GABAtoCr_1to1GABA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1 <- df1to1[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1$pureGABAtoCr <- df1to1$pureGABAtoCr*0.5

df1to1soft <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redcomb/Ph_Osp_GABAtoCr_1to1GABAsoft.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
df1to1soft <- df1to1soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
df1to1soft$pureGABAtoCr <- df1to1soft$pureGABAtoCr*0.5

dfFixedGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redcomb/Ph_Osp_GABAtoCr_freeGauss14.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFixedGauss <- dfFixedGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFixedGauss$pureGABAtoCr <- dfFixedGauss$pureGABAtoCr*0.5

dfFreeGauss <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas/redcomb/Ph_Osp_GABAtoCr_freeGauss.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfFreeGauss <- dfFreeGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
dfFreeGauss$pureGABAtoCr <- dfFreeGauss$pureGABAtoCr*0.5

dfModels <- spvs_ConcatenateDataFrame(list(dfMMsup,df1to1,df1to1soft,dfFixedGauss,dfFreeGauss),c('A-MMsup','C-GABAFixed','D-soft1to1GABA','G-FixedGauss','H-FreeGauss'))

lowerLimit <- rev(c(0))
upperLimit <- rev(c(0.15))
colorPaired <- brewer.pal(10, 'Paired')
colorDark <- brewer.pal(8, 'Dark2')
colorGABA <- c(colorDark[4],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5])


pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('pureGABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,2)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/pureGABAtoCrRedComb.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g

pGABALCM <- spvs_RainCloud(dfModels, '/ [tCr]',list('pureGABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
ggsave(file="/Volumes/Samsung/working/ISMRM/Philips/pureGABAtoCrRedCombCV.pdf", pGABALCM, width = 7.5, height = 3,device=cairo_pdf) #saves g
