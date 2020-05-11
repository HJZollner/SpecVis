source('dependencies.R')
source('spvs_importResults.R')
source('spvs_Correlation.R')
source('spvs_Correlation_Facet.R')
source('spvs_AddStatsToDataframe.R')
source('spvs_ConcatenateDataFrame.R')
source('spvs_RainCloud.R')

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

dfGELCMbase <- read.csv('/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/baselineValue/GE_LCModel_baselinepMM.csv', header = TRUE,stringsAsFactors = FALSE)
dfGETarbase <- read.csv('/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/baselineValue/GE_Tarquin_baselinepMM.csv', header = TRUE,stringsAsFactors = FALSE)
dfGEOspbase <- read.csv('/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/baselineValue/GE_overview_baselinepMM.csv', header = TRUE,stringsAsFactors = FALSE)
dfPhLCMbase <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/baselineValue/Ph_LCModel_baselinepMM.csv', header = TRUE,stringsAsFactors = FALSE)
dfPhTarbase <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/baselineValue/Ph_Tarquin_baselinepMM.csv', header = TRUE,stringsAsFactors = FALSE)
dfPhOspbase <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/baselineValue/Ph_overview_baselinepMM.csv', header = TRUE,stringsAsFactors = FALSE)
dfSiLCMbase <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/baselineValue/Si_LCModel_baselinepMM.csv', header = TRUE,stringsAsFactors = FALSE)
dfSiTarbase <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/baselineValue/Si_Tarquin_baselinepMM.csv', header = TRUE,stringsAsFactors = FALSE)
dfSiOspbase <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/baselineValue/Si_overview_baselinepMM.csv', header = TRUE,stringsAsFactors = FALSE)


dfGELCM <- bind_cols(dfGELCM,dfGELCMbase) 
dfGEOsp <- bind_cols(dfGEOsp,dfGEOspbase) 
dfGETar <- bind_cols(dfGETar,dfGETarbase) 
dfSiLCM <- bind_cols(dfSiLCM,dfSiLCMbase) 
dfSiOsp <- bind_cols(dfSiOsp,dfSiOspbase) 
dfSiTar <- bind_cols(dfSiTar,dfSiTarbase) 
dfPhLCM <- bind_cols(dfPhLCM,dfPhLCMbase) 
dfPhOsp <- bind_cols(dfPhOsp,dfPhOspbase) 
dfPhTar <- bind_cols(dfPhTar,dfPhTarbase) 

dfGELCMph <- read.csv('/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/phases/GE_LCModel_phases.csv', header = TRUE,stringsAsFactors = FALSE)
dfGETarph <- read.csv('/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/phases/GE_Tarquin_phases.csv', header = TRUE,stringsAsFactors = FALSE)
dfGEOspph <- read.csv('/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/phases/GE_overview_phases.csv', header = TRUE,stringsAsFactors = FALSE)
dfPhLCMph<- read.csv('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/phases/Philips_LCModel_phases.csv', header = TRUE,stringsAsFactors = FALSE)
dfPhTarph <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/phases/Philips_Tarquin_phases.csv', header = TRUE,stringsAsFactors = FALSE)
dfPhOspph <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/phases/Philips_overview_phases.csv', header = TRUE,stringsAsFactors = FALSE)
dfSiLCMph <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/phases/Siemens_LCModel_phases.csv', header = TRUE,stringsAsFactors = FALSE)
dfSiTarph <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/phases/Siemens_Tarquin_phases.csv', header = TRUE,stringsAsFactors = FALSE)
dfSiOspph <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/phases/Siemens_overview_phases.csv', header = TRUE,stringsAsFactors = FALSE)

dfGELCM <- bind_cols(dfGELCM,dfGELCMph) 
dfGEOsp <- bind_cols(dfGEOsp,dfGEOspph) 
dfGETar <- bind_cols(dfGETar,dfGETarph) 
dfSiLCM <- bind_cols(dfSiLCM,dfSiLCMph) 
dfSiOsp <- bind_cols(dfSiOsp,dfSiOspph) 
dfSiTar <- bind_cols(dfSiTar,dfSiTarph) 
dfPhLCM <- bind_cols(dfPhLCM,dfPhLCMph) 
dfPhOsp <- bind_cols(dfPhOsp,dfPhOspph) 
dfPhTar <- bind_cols(dfPhTar,dfPhTarph) 

dfGELCMCrM <- read.csv('/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/CrModel/GE_LCM_CrModel.csv', header = TRUE,stringsAsFactors = FALSE)
dfGETarCrM <- read.csv('/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/CrModel/GE_Tar_CrModel.csv', header = TRUE,stringsAsFactors = FALSE)
dfGEOspCrM <- read.csv('/Volumes/Samsung_T5/working/ISMRM/GE/derivativesLCM/CrModel/GE_Osp_CrModel.csv', header = TRUE,stringsAsFactors = FALSE)
dfPhLCMCrM<- read.csv('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/CrModel/Philips_LCM_CrModel.csv', header = TRUE,stringsAsFactors = FALSE)
dfPhTarCrM <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/CrModel/Philips_Tar_CrModel.csv', header = TRUE,stringsAsFactors = FALSE)
dfPhOspCrM <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Philips/derivativesLCM/CrModel/Philips_Osp_CrModel.csv', header = TRUE,stringsAsFactors = FALSE)
dfSiLCMCrM <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/CrModel/Siemens_LCM_CrModel.csv', header = TRUE,stringsAsFactors = FALSE)
dfSiTarCrM <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/CrModel/Siemens_Tar_CrModel.csv', header = TRUE,stringsAsFactors = FALSE)
dfSiOspCrM <- read.csv('/Volumes/Samsung_T5/working/ISMRM/Siemens/derivativesLCM/CrModel/Siemens_Osp_CrModel.csv', header = TRUE,stringsAsFactors = FALSE)

dfGELCM <- bind_cols(dfGELCM,dfGELCMCrM) 
dfGEOsp <- bind_cols(dfGEOsp,dfGEOspCrM) 
dfGETar <- bind_cols(dfGETar,dfGETarCrM) 
dfSiLCM <- bind_cols(dfSiLCM,dfSiLCMCrM) 
dfSiOsp <- bind_cols(dfSiOsp,dfSiOspCrM) 
dfSiTar <- bind_cols(dfSiTar,dfSiTarCrM) 
dfPhLCM <- bind_cols(dfPhLCM,dfPhLCMCrM) 
dfPhOsp <- bind_cols(dfPhOsp,dfPhOspCrM) 
dfPhTar <- bind_cols(dfPhTar,dfPhTarCrM) 


dfPhTar <- spvs_AddStatsToDataframe(dfPhTar,'/Volumes/Samsung_T5/working/ISMRM/Philips/stat.csv')
dfPhLCM <- spvs_AddStatsToDataframe(dfPhLCM,'/Volumes/Samsung_T5/working/ISMRM/Philips/stat.csv')
dfPhOsp <- spvs_AddStatsToDataframe(dfPhOsp,'/Volumes/Samsung_T5/working/ISMRM/Philips/stat.csv')
dfSiOsp <- spvs_AddStatsToDataframe(dfSiOsp,'/Volumes/Samsung_T5/working/ISMRM/Siemens/stat.csv')
dfSiLCM <- spvs_AddStatsToDataframe(dfSiLCM,'/Volumes/Samsung_T5/working/ISMRM/Siemens/stat.csv')
dfSiTar <- spvs_AddStatsToDataframe(dfSiTar,'/Volumes/Samsung_T5/working/ISMRM/Siemens/stat.csv')
dfGETar <- spvs_AddStatsToDataframe(dfGETar,'/Volumes/Samsung_T5/working/ISMRM/GE/stat.csv')
dfGELCM <- spvs_AddStatsToDataframe(dfGELCM,'/Volumes/Samsung_T5/working/ISMRM/GE/stat.csv')
dfGEOsp <- spvs_AddStatsToDataframe(dfGEOsp,'/Volumes/Samsung_T5/working/ISMRM/GE/stat.csv')

dfPhTar <- dfPhTar[-c(103), ]  #Cut a dataset were Ins quantification failed in Tarquin
dfPhOsp <- dfPhOsp[-c(103), ]  #Cut a dataset were Ins quantification failed in Tarquin
dfPhLCM <- dfPhLCM[-c(103), ]  #Cut a dataset were Ins quantification failed in Tarquin

lowerLimit <- c(0.75,.05,0.4,0.75)
upperLimit <- c(2.1,0.33,1.22,2.75)

color <- brewer.pal(8, 'Paired')
ToolColorMap <- c(color[6],color[2],color[4])

dfGE <- spvs_ConcatenateDataFrame(list(dfGELCM,dfGEOsp,dfGETar),c('LCModel','Osprey','Tarquin'))
dfPh <- spvs_ConcatenateDataFrame(list(dfPhLCM,dfPhOsp,dfPhTar),c('LCModel','Osprey','Tarquin'))
dfSi <- spvs_ConcatenateDataFrame(list(dfSiLCM,dfSiOsp,dfSiTar),c('LCModel','Osprey','Tarquin'))
dfData <- dplyr::bind_rows(dfGE,dfPh,dfSi)


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
ggsave(file="RaincloudByVendor.pdf", pRain, width = 10, height = 10,device=cairo_pdf) #saves g


p <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Osprey','Osprey','Osprey','LCModel','LCModel','LCModel'),c('GE','Philips','Siemens','GE','Philips','Siemens'),c('group name','group name','group name','group name','group name','group name'),lowerLimit,upperLimit, 4)
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGETar,dfPhTar,dfSiTar)," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Osprey','Osprey','Osprey','Tarquin','Tarquin','Tarquin'),c('GE','Philips','Siemens','GE','Philips','Siemens'),c('group name','group name','group name','group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Tarquin','Tarquin','Tarquin','LCModel','LCModel','LCModel'),c('GE','Philips','Siemens','GE','Philips','Siemens'),c('group name','group name','group name','group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file="CorrelationCollapsed.pdf", p4, width = 10, height = 10,device=cairo_pdf) #saves g


p <- spvs_Correlation_Facet(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Osprey','Osprey','Osprey','LCModel','LCModel','LCModel'),c('GE','Philips','Siemens','GE','Philips','Siemens'),c('group name','group name','group name','group name','group name','group name'),lowerLimit,upperLimit, 4)
p2 <- spvs_Correlation_Facet(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGETar,dfPhTar,dfSiTar)," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Osprey','Osprey','Osprey','Tarquin','Tarquin','Tarquin'),c('GE','Philips','Siemens','GE','Philips','Siemens'),c('group name','group name','group name','group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation_Facet(list(dfGETar,dfPhTar,dfSiTar,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Tarquin','Tarquin','Tarquin','LCModel','LCModel','LCModel'),c('GE','Philips','Siemens','GE','Philips','Siemens'),c('group name','group name','group name','group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file="CorrelationFacet.pdf", p4, width = 30, height = 10,device=cairo_pdf) #saves g


dfOsp <- spvs_ConcatenateDataFrame(list(dfGEOsp,dfPhOsp,dfSiOsp),c('GE','Philips','Siemens'))
dfTar <- spvs_ConcatenateDataFrame(list(dfGETar,dfPhTar,dfSiTar),c('GE','Philips','Siemens'))
dfLCM <- spvs_ConcatenateDataFrame(list(dfGELCM,dfPhLCM,dfSiLCM),c('GE','Philips','Siemens'))

lowerLimit <- c(.07,.75,.05,.05,.1,.4,.3,.75)
upperLimit <- c(.18,2.1,.11,.33,.3,1.22,.6,2.75)


p <- spvs_Correlation(list(dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c('bNAA','tNAA','bCho','tCho','bIns','Ins','bGlx','Glx'),c('bNAA','tNAA','bCho','tCho','bIns','Ins','bGlx','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp)," / [tCr]",c('bNAA','tNAA','bCho','tCho','bIns','Ins','bGlx','Glx'),c('bNAA','tNAA','bCho','tCho','bIns','Ins','bGlx','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar)," / [tCr]",c('bNAA','tNAA','bCho','tCho','bIns','Ins','bGlx','Glx'),c('bNAA','tNAA','bCho','tCho','bIns','Ins','bGlx','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file="CorrelationBaseline.pdf", p4, width = 10, height = 10,device=cairo_pdf) #saves g

dfGELCM$t20 <- dfGELCM$MM20 + dfGELCM$Lip20
dfPhLCM$t20 <- dfPhLCM$MM20 + dfPhLCM$Lip20
dfSiLCM$t20 <- dfSiLCM$MM20 + dfSiLCM$Lip20

dfGEOsp$t20 <- dfGEOsp$MM20 + dfGEOsp$Lip20
dfPhOsp$t20 <- dfPhOsp$MM20 + dfPhOsp$Lip20
dfSiOsp$t20 <- dfSiOsp$MM20 + dfSiOsp$Lip20

dfGETar$t20 <- dfGETar$MM20 + dfGETar$Lip20
dfPhTar$t20 <- dfPhTar$MM20 + dfPhTar$Lip20
dfSiTar$t20 <- dfSiTar$MM20 + dfSiTar$Lip20

lowerLimit <- c(.75,.75,0,.75,0,.75)
upperLimit <- c(2.75,2.1,3,2.1,3,2.75)

dfSiOsp <- dfSiOsp[-c(54), ] 

p <- spvs_Correlation(list(dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c('Glx','tNAA','t20','tNAA','t20','Glx'),c('Glx','tNAA','t20','tNAA','t20','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 3,c(''))
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp)," / [tCr]",c('Glx','tNAA','t20','tNAA','t20','Glx'),c('Glx','tNAA','t20','tNAA','t20','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 3,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar)," / [tCr]",c('Glx','tNAA','t20','tNAA','t20','Glx'),c('Glx','tNAA','t20','tNAA','t20','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 3,c(''))
p4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file="Correlation2ppm.pdf", p4, width = 10, height = 10,device=cairo_pdf) #saves g

lowerLimit <- c(-25,-55,-55,0.025)
upperLimit <- c(25,55,55,0.085)

pGEp <- spvs_RainCloud(dfGE, '/ [tCr]',list('ModelCrInt','ph0','ph1','ph'),c('Group'),lowerLimit,upperLimit,c(""),4)
pGEp <- pGEp + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pPhp <- spvs_RainCloud(dfPh, '/ [tCr]',list('ModelCrInt','ph0','ph1','ph'),c('Group'),lowerLimit,upperLimit,c(""),4)
pPhp <- pPhp + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pSip <- spvs_RainCloud(dfSi, '/ [tCr]',list('ModelCrInt','ph0','ph1','ph'),c('Group'),lowerLimit,upperLimit,c(""),4)
pSip <- pSip + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pAllp <- spvs_RainCloud(dfData, '/ [tCr]',list('ModelCrInt','ph0','ph1','ph'),c('Group'),lowerLimit,upperLimit,c(""),4)
pAllp <- pAllp + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pRainp <- grid.arrange(pGEp, pPhp, pSip,pAllp, ncol=1, nrow =4)
g <- arrangeGrob(pGEp, pPhp, pSip,pAllp, ncol=1) #generates g
ggsave(file="RaincloudByVendorPhaseCr.pdf", pRainp, width = 10, height = 10,device=cairo_pdf) #saves g



lowerLimit <- c(-25,.75,-25,.05,-25,.4,-25,.75)
upperLimit <- c(25,2.1,25,.33,25,1.22,25,2.75)

p <- spvs_Correlation(list(dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c('ph1','tNAA','ph1','tCho','ph1','Ins','ph1','Glx'),c('ph1','tNAA','ph1','tCho','ph1','Ins','ph1','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp)," / [tCr]",c('ph1','tNAA','ph1','tCho','ph1','Ins','ph1','Glx'),c('ph1','tNAA','ph1','tCho','ph1','Ins','ph1','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar)," / [tCr]",c('ph1','tNAA','ph1','tCho','ph1','Ins','ph1','Glx'),c('ph1','tNAA','ph1','tCho','ph1','Ins','ph1','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file="CorrelationPh1.pdf", p4, width = 10, height = 10,device=cairo_pdf) #saves g

lowerLimit <- c(-55,.75,-55,.05,-55,.4,-55,.75)
upperLimit <- c(55,2.1,55,.33,55,1.22,55,2.75)

p <- spvs_Correlation(list(dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c('ph0','tNAA','ph0','tCho','ph0','Ins','ph0','Glx'),c('ph0','tNAA','ph0','tCho','ph0','Ins','ph0','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp)," / [tCr]",c('ph0','tNAA','ph0','tCho','ph0','Ins','ph0','Glx'),c('ph0','tNAA','ph0','tCho','ph0','Ins','ph0','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar)," / [tCr]",c('ph0','tNAA','ph0','tCho','ph0','Ins','ph0','Glx'),c('ph0','tNAA','ph0','tCho','ph0','Ins','ph0','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file="CorrelationPh0.pdf", p4, width = 10, height = 10,device=cairo_pdf) #saves g

p <- spvs_Correlation(list(dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c('ph','tNAA','ph','tCho','ph','Ins','ph','Glx'),c('ph','tNAA','ph','tCho','ph','Ins','ph','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp)," / [tCr]",c('ph','tNAA','ph','tCho','ph','Ins','ph','Glx'),c('ph','tNAA','ph','tCho','ph','Ins','ph','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar)," / [tCr]",c('ph','tNAA','ph','tCho','ph','Ins','ph','Glx'),c('ph','tNAA','ph','tCho','ph','Ins','ph','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file="CorrelationPh.pdf", p4, width = 10, height = 10,device=cairo_pdf) #saves g


lowerLimit <- c(-25,.07,-25,.05,-25,.1,-25,.3)
upperLimit <- c(25,.18,25,.11,25,.3,25,.6)

p <- spvs_Correlation(list(dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c('ph1','bNAA','ph1','bCho','ph1','bIns','ph1','bGlx'),c('ph1','tNAA','ph1','tCho','ph1','Ins','ph1','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp)," / [tCr]",c('ph1','bNAA','ph1','bCho','ph1','bIns','ph1','bGlx'),c('ph1','tNAA','ph1','tCho','ph1','Ins','ph1','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar)," / [tCr]",c('ph1','bNAA','ph1','bCho','ph1','bIns','ph1','bGlx'),c('ph1','tNAA','ph1','tCho','ph1','Ins','ph1','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file="CorrelationBaselinePh1.pdf", p4, width = 10, height = 10,device=cairo_pdf) #saves g

lowerLimit <- c(-55,.07,-55,.05,-55,.1,-55,.3)
upperLimit <- c(55,.18,55,.11,55,.3,55,.6)

p <- spvs_Correlation(list(dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c('ph0','bNAA','ph0','bCho','ph0','bIns','ph0','bGlx'),c('ph0','tNAA','ph0','tCho','ph0','Ins','ph0','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp)," / [tCr]",c('ph0','bNAA','ph0','bCho','ph0','bIns','ph0','bGlx'),c('ph0','tNAA','ph0','tCho','ph0','Ins','ph0','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar)," / [tCr]",c('ph0','bNAA','ph0','bCho','ph0','bIns','ph0','bGlx'),c('ph0','tNAA','ph0','tCho','ph0','Ins','ph0','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file="CorrelationBaselinePh0.pdf", p4, width = 10, height = 10,device=cairo_pdf) #saves g

p <- spvs_Correlation(list(dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c('ph','bNAA','ph','bCho','ph','bIns','ph','bGlx'),c('ph','tNAA','ph','tCho','ph','Ins','ph','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp)," / [tCr]",c('ph','bNAA','ph','bCho','ph','bIns','ph','bGlx'),c('ph','tNAA','ph','tCho','ph','Ins','ph','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar)," / [tCr]",c('ph','bNAA','ph','bCho','ph','bIns','ph','bGlx'),c('ph','tNAA','ph','tCho','ph','Ins','ph','Glx'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file="CorrelationBaselinePh.pdf", p4, width = 10, height = 10,device=cairo_pdf) #saves g



lowerLimit <- c(-55,-25)
upperLimit <- c(55,25)

p <- spvs_Correlation(list(dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c('ph0','ph1'),c('ph0','ph1'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp)," / [tCr]",c('ph0','ph1'),c('ph0','ph1'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar)," / [tCr]",c('ph0','ph1'),c('ph0','ph1'),c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file="CorrelationPh0Ph1.pdf", p4, width = 10, height = 10,device=cairo_pdf) #saves g



