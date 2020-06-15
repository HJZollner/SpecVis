source('functions/dependencies.R')
source('functions/spvs_importResults.R')
source('functions/spvs_Correlation.R')
source('functions/spvs_AddStatsToDataframe.R')
source('functions/spvs_Boxplot.R')
source('functions/spvs_ConcatenateDataFrame.R')
source('functions/spvs_Statistics.R')

dfPhOsp <- spvs_importResults('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/QuantifyResults/off_tCr.csv')
dfSiOsp <- spvs_importResults('/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/QuantifyResults/off_tCr.csv')
dfGEOsp <- spvs_importResults('/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/QuantifyResults/off_tCr.csv')
dataPhLCM <- spvs_importResults('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/LCMBaseline/LCMoutput_015')
dfPhLCM <- dataPhLCM[[1]]
dataSiLCM <- spvs_importResults('/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/LCMBaseline/LCMoutput_015')
dfSiLCM <- dataSiLCM[[1]]
dataGELCM <- spvs_importResults('/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/LCMBaseline/LCMoutput_015')
dfGELCM <- dataGELCM[[1]]
dataPhTar <- spvs_importResults('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/TarquinBaseline/TarquinAnalysis_Basis_10ms')
dfPhTar <- dataPhTar[[1]]
dataSiTar <- spvs_importResults('/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/TarquinBaseline/TarquinAnalysis_Basis_10ms')
dfSiTar <- dataSiTar[[1]]
dataGETar <- spvs_importResults('/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/TarquinBaseline/TarquinAnalysis_Basis_10ms')
dfGETar <- dataGETar[[1]]
dfPhTar <- spvs_AddStatsToDataframe(dfPhTar,'/Volumes/Samsung_T5/working/ISMRM/Philips/stat.csv')
dfPhLCM <- spvs_AddStatsToDataframe(dfPhLCM,'/Volumes/Samsung_T5/working/ISMRM/Philips/stat.csv')
dfPhOsp <- spvs_AddStatsToDataframe(dfPhOsp,'/Volumes/Samsung_T5/working/ISMRM/Philips/stat.csv')
dfSiOsp <- spvs_AddStatsToDataframe(dfSiOsp,'/Volumes/Samsung_T5/working/ISMRM/Siemens/stat.csv')
dfSiLCM <- spvs_AddStatsToDataframe(dfSiLCM,'/Volumes/Samsung_T5/working/ISMRM/Siemens/stat.csv')
dfSiTar <- spvs_AddStatsToDataframe(dfSiTar,'/Volumes/Samsung_T5/working/ISMRM/Siemens/stat.csv')
dfGETar <- spvs_AddStatsToDataframe(dfGETar,'/Volumes/Samsung_T5/working/ISMRM/GE/stat.csv')
dfGELCM <- spvs_AddStatsToDataframe(dfGELCM,'/Volumes/Samsung_T5/working/ISMRM/GE/stat.csv')
dfGEOsp <- spvs_AddStatsToDataframe(dfGEOsp,'/Volumes/Samsung_T5/working/ISMRM/GE/stat.csv')

lowerLimit <- c(1.2,0.12,0.4,1.2)
upperLimit <- c(1.75,0.25,1,2.4)
p <- spvs_Correlation(list(dfGEOsp[c(32:43),c(1:33)],dfGELCM[c(32:43),c(1:34)])," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Osprey','LCModel'),c('',''),NULL,lowerLimit,upperLimit, 4)
p2 <- spvs_Correlation(list(dfGEOsp[c(32:43),c(1:33)],dfGETar[c(32:43),c(1:35)])," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Osprey','Tarquin'),c('',''),NULL,lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar[c(32:43),c(1:35)],dfGELCM[c(32:43),c(1:34)])," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Tarquin','LCModel'),c('',''),NULL,lowerLimit,upperLimit, 4,c(''))
p4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file="CorrelationRevision.pdf", p4, width = 10, height = 10,device=cairo_pdf) #saves g


dfPaper <- spvs_ConcatenateDataFrame(list(dfGELCM[c(32:43),c(1:34)],dfGEOsp[c(32:43),c(1:33)],dfGETar[c(32:43),c(1:35)]),c('LCModel','Osprey','Tarquin'))

p <- spvs_RainCloud(dfPaper, '/ [tCr]',list('tNAA','tCho','Ins','Glx'),c('Group'),c("Philips S03 KKI"),4)
ggsave(file="RaincloudKKI.pdf", p, width = 12, height = 3,device=cairo_pdf) #saves g

p <- spvs_Boxplot(dfPaper, '/ [tCr]',list('tNAA','tCho','Ins','Glx'),c('Group'),c("Philips S03 KKI"),4)
ggsave(file="BoxplotRevision.pdf", p, width = 12, height = 3,device=cairo_pdf) #saves g

Norm <- spvs_Statistics(dfPaper,list('tNAA','tCho','Ins','Glx'))


