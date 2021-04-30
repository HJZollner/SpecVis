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
source('functions/spvs_Violin.R')
source('functions/spvs_TissueCorr.R')

# Deomgraphics ------------------------------------------------------------


#Get demographics and clinical data
dfDemo <- read.csv('/Volumes/Elements/working/GABA_HE/statFull.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfClinic <- read.csv('/Volumes/Elements/working/GABA_HE/clinicFull.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfClinicAll <- spvs_AddStatsToDataframe(dfDemo,'/Volumes/Elements/working/GABA_HE/clinicFull.csv')
dfClinicAll$Group...6 <- NULL
dfClinicAll$numGroup...7- NULL

#Sort demographics and clinical data
dfDemoCon <- subset(dfDemo, numGroup == 1,select=c(Group, numGroup,CFF,PEG,age))
dfDemomHE <- subset(dfDemo, numGroup == 2,select=c(Group, numGroup,CFF,PEG,age))
dfDemoHE <- subset(dfDemo, numGroup == 3,select=c(Group, numGroup,CFF,PEG,age))
dfDemo <- spvs_ConcatenateDataFrame(list(dfDemoCon,dfDemomHE,dfDemoHE),c('A-con','B-mHE','C-HE'))
dfClinicCon <- subset(dfClinic, numGroup == 1)
dfClinicmHE <- subset(dfClinic, numGroup == 2)
dfClinicHE <- subset(dfClinic, numGroup == 3)
dfClinic <- spvs_ConcatenateDataFrame(list(dfClinicCon,dfClinicmHE,dfClinicHE),c('A-con','B-mHE','C-HE'))

dfDemo1 <- spvs_ConcatenateDataFrame(list(dfDemoCon,dfDemoHE),c('A-con','C-HE'))
statsDemo <- spvs_Statistics(dfDemo1,list('age','CFF','PEG'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/demo_stat_con_HE.txt')
print(statsDemo)
sink()
dfDemo1 <- spvs_ConcatenateDataFrame(list(dfDemoCon,dfDemomHE),c('A-con','B-mHE'))
statsDemo <- spvs_Statistics(dfDemo1,list('age','CFF','PEG'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/demo_stat_con_mHE.txt')
print(statsDemo)
sink()

statsDemo <- spvs_Statistics(dfClinic,list('ammonia','Bilirubin','GGT','GOT','GPT'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/clinic_stat.txt')
print(statsDemo)
sink()

#Plot demographics/distributions
lowerLiInst <- rev(c(45,30,45))
upperLiInst <- rev(c(80,45,80))
color <- brewer.pal(8, 'Dark2')
ToolColorMap <- c(color[6],color[2],color[4])
pAllDemo <- spvs_RainCloud(dfDemo, '',list('age','CFF','PEG'),c('Group'),lowerLiInst,upperLiInst,title=c(""),colNum=3,CVlabel=0)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/RaincloudDemo.pdf", pAllDemo, width = 10, height = 10,device=cairo_pdf) #saves g
pAllDemo

#Plot CFF vs PEG board correlation
lowerLiInst <- c(30,120)
upperLiInst <- c(45,400)
pAllClinicsCorr <- spvs_Correlation(list(dfDemoCon,dfDemomHE,dfDemoHE),"",c("CFF","PEG"),c('CFF','PEG'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 1)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CFFvsPEG.pdf", pAllClinicsCorr, width = 7.5, height = 5,device=cairo_pdf) #saves g
pAllClinicsCorr


dfClinicmHE <- subset(dfClinicAll, numGroup == 2)
dfClinicHE <- subset(dfClinicAll, numGroup == 3)

# CFF vs blood tests
lowerLiInst <- c(30,0,30,130,30,0,30,0,30,0,30,0)
upperLiInst <- c(45,0,45,131,45,0,45,0,45,0,45,0)
pCFFx1 <- spvs_Correlation(list(dfClinicmHE,dfClinicHE),"",c("CFF","ammonia","CFF","Natrium","CFF","Ka","CFF","Ca","CFF","Creatinin","CFF","Harnstoff"),c('CFF','ammonia',"CFF","Natrium","CFF","Ka","CFF","Ca","CFF","Creatinin","CFF","Harnstoff"),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
pCFFx1
pCFFx2<- spvs_Correlation(list(dfClinicmHE,dfClinicHE),"",c("CFF","Harnsaure","CFF","Bilirubin","CFF","CRP","CFF","GOT","CFF","GPT","CFF","GGT"),c("CFF","Harnsaure","CFF","Bilirubin","CFF","CRP","CFF","GOT","CFF","GPT","CFF","GGT"),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CFFvsCRP.pdf", pCFFx2, width = 7.5, height = 20,device=cairo_pdf) #saves g
pCFFx2
pCFFx3 <- spvs_Correlation(list(dfClinicmHE,dfClinicHE),"",c("CFF","Haemog","CFF","Haemat","CFF","MCV","CFF","MCH","CFF","MCHC","CFF","Quick"),c("CFF","Haemog","CFF","Haemat","CFF","MCV","CFF","MCH","CFF","MCHC","CFF","Quick"),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
pCFFx3
pCFFx4 <- spvs_Correlation(list(dfClinicmHE,dfClinicHE),"",c("CFF","INR","CFF","Haemat","CFF","MCV","CFF","MCH","CFF","MCHC","CFF","Quick"),c("CFF","Haemog","CFF","Haemat","CFF","MCV","CFF","MCH","CFF","MCHC","CFF","Quick"),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
pCFFx4

# PEG vs blood tests
lowerLiInst <- c(120,0,120,130,120,0,120,0,120,0,120,0)
upperLiInst <- c(450,0,450,131,450,0,450,0,450,0,450,0)
pPEGx1 <- spvs_Correlation(list(dfClinicmHE,dfClinicHE),"",c("PEG","ammonia","PEG","Natrium","PEG","Ka","PEG","Ca","PEG","Creatinin","PEG","Harnstoff"),c("PEG","ammonia","PEG","Natrium","PEG","Ka","PEG","Ca","PEG","Creatinin","PEG","Harnstoff"),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
pPEGx1
pPEGx2<- spvs_Correlation(list(dfClinicmHE,dfClinicHE),"",c("PEG","Harnsaure","PEG","Bilirubin","PEG","CRP","PEG","GOT","PEG","GPT","PEG","GGT"),c("PEG","Harnsaure","PEG","Bilirubin","PEG","CRP","PEG","GOT","PEG","GPT","PEG","GGT"),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
pPEGx2
pPEGx4 <- spvs_Correlation(list(dfClinicmHE,dfClinicHE),"",c("PEG","Haemog","PEG","Haemat","PEG","MCV","PEG","MCH","PEG","MCHC","PEG","Quick"),c("PEG","Haemog","PEG","Haemat","PEG","MCV","PEG","MCH","PEG","MCHC","PEG","Quick"),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
pPEGx4
pPEGx5 <- spvs_Correlation(list(dfClinicmHE,dfClinicHE),"",c("PEG","INR","PEG","Haemat","PEG","MCV","PEG","MCH","PEG","MCHC","PEG","Quick"),c("PEG","INR","PEG","Haemat","PEG","MCV","PEG","MCH","PEG","MCHC","PEG","Quick"),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
pPEGx5


# Difference spectra ------------------------------------------------------

#Load GABA dataframes
colorRain <- c(color[1],color[3])
dfCERdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetCER.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfCERdiff <- spvs_AddStatsToDataframe(dfCERdiff,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfCERdiff$CFF <- NULL
dfCERdiff$PEG <- NULL
dfCERdiff$age <- NULL

#Remove outlier
dfCERdiff <- dfCERdiff[-c(1,4,11,13,17,20,35,36,37,38),]

#Sort cerebella differnce spectra data
dfCERdiffCon <- subset(dfCERdiff, numGroup == 1)
dfCERdiffmHE <- subset(dfCERdiff, numGroup == 2)
dfCERdiffHE <- subset(dfCERdiff, numGroup == 3)
dfCERdiff <- spvs_ConcatenateDataFrame(list(dfCERdiffCon,dfCERdiffmHE,dfCERdiffHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(5,0,5)
upperLiInst <- c(12,12,12)
pCERdiff <- spvs_RainCloud(dfCERdiff, '',list('FWHM','SNR','GABAEr'),c('Group'),lowerLiInst,upperLiInst,title=c(""),colNum=3,CVlabel=0)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_QC.pdf", pCERdiff, width = 10, height = 10,device=cairo_pdf) #saves g
pCERdiff
dfCERdiff <- spvs_ConcatenateDataFrame(list(dfCERdiffCon,dfCERdiffHE),c('A-con','C-HE'))

lowerLiInst <- c(0)
upperLiInst <- c(0.2)

pCERdiffGABA <- spvs_RainCloud(dfCERdiff, '',list('GABACr','GABAiu'),c('Group'),lowerLiInst,upperLiInst,title=c(""),colNum=2,CVlabel=0)
pGABALCM <- spvs_Violin(dfCERdiff, '/ [tCr]',list('GABACr'),c('Group'),lowerLiInst,upperLiInst,c(""),1)
pGABALCM <- pGABALCM[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_GABA.pdf", pCERdiffGABA, width = 10, height = 10,device=cairo_pdf) #saves g
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_GABA_Vio_Cr.pdf", pGABALCM, width = 10, height = 10,device=cairo_pdf) #saves g

lowerLiInst <- c(0)
upperLiInst <- c(5)
pGABALCM <- spvs_Violin(dfCERdiff, '/ [tCr]',list('GABAiu'),c('Group'),lowerLiInst,upperLiInst,c(""),1)
pGABALCM <- pGABALCM[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_GABA_Vio_iu.pdf", pGABALCM, width = 10, height = 10,device=cairo_pdf) #saves g


statsCERdiff <- spvs_Statistics(dfCERdiff,list('GABACr','GABAiu'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/CER_GABA_stat.txt')
print(statsCERdiff)
sink()

statsCER <- spvs_Statistics(dfCERdiff,list('FWHM','SNR','GABAEr'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/CER_stat.txt')
print(statsCER)
sink()

#Load Thalamus GABA dataframes
dfTHAdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetTHA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfTHAdiff <- spvs_AddStatsToDataframe(dfTHAdiff,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfTHAdiff$CFF <- NULL
dfTHAdiff$PEG <- NULL
dfTHAdiff$age <- NULL

#Remove outlier
dfTHAdiff <- dfTHAdiff[-c(1,2,12,21),]
dfTHAdiff <- dfTHAdiff[-c(1,2,12,21,36,38),]

#Sort cerebella differnce spectra data
dfTHAdiffCon <- subset(dfTHAdiff, numGroup == 1)
dfTHAdiffmHE <- subset(dfTHAdiff, numGroup == 2)
dfTHAdiffHE <- subset(dfTHAdiff, numGroup == 3)
dfTHAdiff <- spvs_ConcatenateDataFrame(list(dfTHAdiffCon,dfTHAdiffmHE,dfTHAdiffHE),c('A-con','B-mHE','C-HE'))
dfTHAdiff <- spvs_ConcatenateDataFrame(list(dfTHAdiffCon,dfTHAdiffHE),c('A-con','C-HE'))

lowerLiInst <- c(5,0,5)
upperLiInst <- c(12,12,12)
pTHAdiff <- spvs_RainCloud(dfTHAdiff, '',list('FWHM','SNR','GABAEr'),c('Group'),lowerLiInst,upperLiInst,title=c(""),colNum=3,CVlabel=0)
pTHAdiff <- pTHAdiff + scale_color_manual(values = colorRain)+scale_fill_manual(values = colorRain)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_QC.pdf", pTHAdiff, width = 10, height = 10,device=cairo_pdf) #saves g
pTHAdiff

lowerLiInst <- c(3.5,0.075)
upperLiInst <- c(7,0.175)

pTHAdiffGABA <- spvs_RainCloud(dfTHAdiff, '',list('GABACr','GABAiu'),c('Group'),lowerLiInst,upperLiInst,title=c(""),colNum=2,CVlabel=0)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_GABA_iu.pdf", pTHAdiffGABA, width = 10, height = 10,device=cairo_pdf) #saves g

lowerLiInst <- c(0)
upperLiInst <- c(0.2)

pGABALCM <- spvs_Violin(dfTHAdiff, '/ [tCr]',list('GABACr'),c('Group'),lowerLiInst,upperLiInst,c(""),1)
pGABALCM <- pGABALCM[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_GABA_Vio_Cr.pdf", pGABALCM, width = 10, height = 10,device=cairo_pdf) #saves g

lowerLiInst <- c(0)
upperLiInst <- c(5)
pGABALCM <- spvs_Violin(dfTHAdiff, '/ [tCr]',list('GABAiu'),c('Group'),lowerLiInst,upperLiInst,c(""),1)
pGABALCM <- pGABALCM[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_GABA_Vio_iu.pdf", pGABALCM, width = 10, height = 10,device=cairo_pdf) #saves g



statsTHAdiff <- spvs_Statistics(dfTHAdiff,list('GABACr','GABAiu'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/THA_GABA_stat_iu.txt')
print(statsTHAdiff)
sink()

statsTHA <- spvs_Statistics(dfTHAdiff,list('FWHM','SNR','GABAEr'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/THA_stat_iu.txt')
print(statsTHA)
sink()

#Load MC GABA dataframes
dfMOTdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetMOT.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfMOTdiff <- spvs_AddStatsToDataframe(dfMOTdiff,'/Volumes/Elements/working/GABA_HE/statMOT.csv')
dfMOTdiff$CFF <- NULL
dfMOTdiff$PEG <- NULL
dfMOTdiff$age <- NULL

#Remove outlier
dfMOTdiff <- dfMOTdiff[-c(2,4,5,9,12,14,15,19,20,32),]

#Sort cerebella differnce spectra data
dfMOTdiffCon <- subset(dfMOTdiff, numGroup == 1)
dfMOTdiffmHE <- subset(dfMOTdiff, numGroup == 2)
dfMOTdiffHE <- subset(dfMOTdiff, numGroup == 3)
dfMOTdiff <- spvs_ConcatenateDataFrame(list(dfMOTdiffCon,dfMOTdiffHE),c('A-con','C-HE'))

dfMOTdiff <- spvs_ConcatenateDataFrame(list(dfMOTdiffCon,dfMOTdiffmHE,dfMOTdiffHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(5,0,5)
upperLiInst <- c(12,12,12)
pMOTdiff <- spvs_RainCloud(dfMOTdiff, '',list('FWHM','SNR','GABAEr'),c('Group'),lowerLiInst,upperLiInst,title=c(""),colNum=3,CVlabel=0)
pMOTdiff <- pMOTdiff + scale_color_manual(values = colorRain)+scale_fill_manual(values = colorRain)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_QC.pdf", pMOTdiff, width = 10, height = 10,device=cairo_pdf) #saves g
pMOTdiff

lowerLiInst <- c(3.5,0.075)
upperLiInst <- c(7,0.175)

pMOTdiffGABA <- spvs_RainCloud(dfMOTdiff, '',list('GABACr','GABAiu'),c('Group'),lowerLiInst,upperLiInst,title=c(""),colNum=2,CVlabel=0)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA.pdf", pMOTdiffGABA, width = 10, height = 10,device=cairo_pdf) #saves g
pMOTdiffGABA


lowerLiInst <- c(0)
upperLiInst <- c(0.2)

pGABALCM <- spvs_Violin(dfMOTdiff, '/ [tCr]',list('GABACr'),c('Group'),lowerLiInst,upperLiInst,c(""),1)
pGABALCM <- pGABALCM[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA_Vio_Cr.pdf", pGABALCM, width = 10, height = 10,device=cairo_pdf) #saves g

lowerLiInst <- c(0)
upperLiInst <- c(5)
pGABALCM <- spvs_Violin(dfMOTdiff, '/ [tCr]',list('GABAiu'),c('Group'),lowerLiInst,upperLiInst,c(""),1)
pGABALCM <- pGABALCM[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA_Vio_iu.pdf", pGABALCM, width = 10, height = 10,device=cairo_pdf) #saves g


statsMOTdiff <- spvs_Statistics(dfMOTdiff,list('GABACr','GABAiu'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA_stat.txt')
print(statsMOTdiff)
sink()

statsMOT <- spvs_Statistics(dfMOTdiff,list('FWHM','SNR','GABAEr'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/MOT_stat.txt')
print(statsMOT)
sink()


#Correlation plots GABA CER
dfCERdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetCER.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfCERdiff <- spvs_AddStatsToDataframe(dfCERdiff,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfCERdiff$ammonia <- dfClinicAll$ammonia
dfCERdiff$CRP <- dfClinicAll$CRP
#Remove outlier
dfCERdiff <- dfCERdiff[-c(1,4,11,13,17,20,35,36,37,38),]
dfCERdiffCon <- subset(dfCERdiff, numGroup == 1)
dfCERdiffmHE <- subset(dfCERdiff, numGroup == 2)
dfCERdiffHE <- subset(dfCERdiff, numGroup == 3)
dfCERdiff <- spvs_ConcatenateDataFrame(list(dfCERdiffCon,dfCERdiffmHE,dfCERdiffHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.175)
pCERGABACrCorr <- spvs_Correlation(list(dfCERdiffCon,dfCERdiffmHE,dfCERdiffHE),"",c("CFF","GABACr",'PEG','GABACr'),c('CFF','GABACr','PEG','GABACr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CFFvsCERGABACr.pdf", pCERGABACrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pCERGABACrCorr

lowerLiInst <- c(30,3,30,3)
upperLiInst <- c(45,7,45,7)
pCERGABACorr <- spvs_Correlation(list(dfCERdiffCon,dfCERdiffmHE,dfCERdiffHE),"",c("CFF","GABAiu",'PEG','GABAiu'),c('CFF','GABAiu','PEG','GABAiu'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CFFvsCERGABA.pdf", pCERGABACorr, width = 5, height = 10,device=cairo_pdf) #saves g
pCERGABACorr

lowerLiInst <- c(30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.175)
pCERGABACrCorrAm <- spvs_Correlation(list(dfCERdiffmHE,dfCERdiffHE),"",c("ammonia","GABACr",'CRP','GABACr'),c('ammonia','GABACr','CRP','GABACr'),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/ammoniavsCERGABACr.pdf", pCERGABACrCorrAm, width = 5, height = 10,device=cairo_pdf) #saves g
pCERGABACrCorrAm

lowerLiInst <- c(30,3,30,3)
upperLiInst <- c(45,7,45,7)
pCERGABACorrAm <- spvs_Correlation(list(dfCERdiffmHE,dfCERdiffHE),"",c("ammonia","GABAiu",'CRP','GABAiu'),c('ammonia','GABAiu','CRP','GABAiu'),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/ammoniavsCERGABAiu.pdf", pCERGABACorrAm, width = 5, height = 10,device=cairo_pdf) #saves g
pCERGABACorrAm

#Correlation plots GABA THA
dfTHAdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetTHA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfTHAdiff <- spvs_AddStatsToDataframe(dfTHAdiff,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfTHAdiff$ammonia <- dfClinicAll$ammonia
dfTHAdiff$CRP <- dfClinicAll$CRP
#Remove outlier
dfTHAdiff <- dfTHAdiff[-c(1,2,12,21),]
dfTHAdiff <- dfTHAdiff[-c(1,2,12,21,36,38),]
dfTHAdiffCon <- subset(dfTHAdiff, numGroup == 1)
dfTHAdiffmHE <- subset(dfTHAdiff, numGroup == 2)
dfTHAdiffHE <- subset(dfTHAdiff, numGroup == 3)
dfTHAdiff <- spvs_ConcatenateDataFrame(list(dfTHAdiffCon,dfTHAdiffmHE,dfTHAdiffHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.175)
pTHAGABACrCorr <- spvs_Correlation(list(dfTHAdiffCon,dfTHAdiffmHE,dfTHAdiffHE),"",c("CFF","GABACr",'PEG','GABACr'),c('CFF','GABACr','PEG','GABACr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CFFvsTHAGABACr.pdf", pTHAGABACrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pTHAGABACrCorr

lowerLiInst <- c(30,3,30,3)
upperLiInst <- c(45,7,45,7)
pTHAGABACorr <- spvs_Correlation(list(dfTHAdiffCon,dfTHAdiffmHE,dfTHAdiffHE),"",c("CFF","GABAiu",'PEG','GABAiu'),c('CFF','GABAiu','PEG','GABAiu'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CFFvsTHAGABA.pdf", pTHAGABACorr, width = 5, height = 10,device=cairo_pdf) #saves g
pTHAGABACorr

lowerLiInst <- c(30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.175)
pTHAGABACrCorrAm <- spvs_Correlation(list(dfTHAdiffmHE,dfTHAdiffHE),"",c("ammonia","GABACr",'CRP','GABACr'),c('ammonia','GABACr','CRP','GABACr'),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/ammoniavsTHAGABACr.pdf", pTHAGABACrCorrAm, width = 5, height = 10,device=cairo_pdf) #saves g
pTHAGABACrCorrAm

lowerLiInst <- c(30,3,30,3)
upperLiInst <- c(45,7,45,7)
pTHAGABACorrAm <- spvs_Correlation(list(dfTHAdiffmHE,dfTHAdiffHE),"",c("ammonia","GABAiu",'CRP','GABAiu'),c('ammonia','GABAiu','CRP','GABAiu'),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/ammoniavsTHAGABA.pdf", pTHAGABACorrAm, width = 5, height = 10,device=cairo_pdf) #saves g
pTHAGABACorrAm

#Correlation plots GABA MOT
dfMOTdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetMOT.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfMOTdiff <- spvs_AddStatsToDataframe(dfMOTdiff,'/Volumes/Elements/working/GABA_HE/statMOT.csv')
dfClinicMot <- dfClinicAll[-c(25,36),]
dfMOTdiff$ammonia <- dfClinicMot$ammonia
dfMOTdiff$CRP <- dfClinicMot$CRP
#Remove outlier
dfMOTdiff <- dfMOTdiff[-c(2,4,5,9,12,14,15,19,20,32),]
dfMOTdiffCon <- subset(dfMOTdiff, numGroup == 1)
dfMOTdiffmHE <- subset(dfMOTdiff, numGroup == 2)
dfMOTdiffHE <- subset(dfMOTdiff, numGroup == 3)
dfMOTdiff <- spvs_ConcatenateDataFrame(list(dfMOTdiffCon,dfMOTdiffmHE,dfMOTdiffHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(30,0,30,0)
upperLiInst <- c(45,0.175,45,0.175)
pMOTGABACrCorr <- spvs_Correlation(list(dfMOTdiffCon,dfMOTdiffmHE,dfMOTdiffHE),"",c("CFF","GABACr",'PEG','GABACr'),c('CFF','GABACr','PEG','GABACr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CFFvsMOTGABACr.pdf", pMOTGABACrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTGABACrCorr

lowerLiInst <- c(30,0,30,0)
upperLiInst <- c(45,4,45,4)
pMOTGABACorr <- spvs_Correlation(list(dfMOTdiffCon,dfMOTdiffmHE,dfMOTdiffHE),"",c("CFF","GABAiu",'PEG','GABAiu'),c('CFF','GABAiu','PEG','GABAiu'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CFFvsMOTGABA.pdf", pMOTGABACorr, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTGABACorr

lowerLiInst <- c(30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.175)
pMOTGABACrCorrAm <- spvs_Correlation(list(dfMOTdiffmHE,dfMOTdiffHE),"",c("ammonia","GABACr",'CRP','GABACr'),c('ammonia','GABACr','CRP','GABACr'),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/ammoniavsMOTGABACr.pdf", pMOTGABACrCorrAm, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTGABACrCorrAm

lowerLiInst <- c(30,3,30,3)
upperLiInst <- c(45,7,45,7)
pMOTGABACorrAm <- spvs_Correlation(list(dfMOTdiffmHE,dfMOTdiffHE),"",c("ammonia","GABAiu",'CRP','GABAiu'),c('ammonia','GABAiu','CRP','GABAiu'),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/ammoniavsMOTGABA.pdf", pMOTGABACorrAm, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTGABACorrAm



#Load Off CER dataframes
dfCER <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivativesCER/LCMoutput')
dfCER <- dfCER[[1]]
dfCER <- spvs_AddStatsToDataframe(dfCER,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfCER$CFF <- NULL
dfCER$PEG <- NULL
dfCER$age <- NULL

#Remove outlier
# dfCER <- dfCER[-c(1,4,6,11,13,17,20,35,36,37,38),]
dfCER <- dfCER[-c(4,6,17,18,20,32),]

#Sort cerebella differnce spectra data
dfCERCon <- subset(dfCER, numGroup == 1)
dfCERmHE <- subset(dfCER, numGroup == 2)
dfCERHE <- subset(dfCER, numGroup == 3)
dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERmHE,dfCERHE),c('A-con','B-mHE','C-HE'))

dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERHE),c('A-con','C-HE'))
lowerLiInst <- c(0,0,0,0)
upperLiInstOsmo <- c(1.3,.1,.75,.4)
pCER <- spvs_Violin(dfCER, '/ [tCr]',list('Ins','Scyllo','Tau','tCho'),c('Group'),lowerLiInst,upperLiInstOsmo,c(""),1)
pCER <- pCER[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_Off_Cr_OSMO_Vio.pdf", pCER, width = 10, height = 20,device=cairo_pdf) #saves g

lowerLiInst <- c(0,0,0)
upperLiInstNeuro <- c(1.5,2,2)
pCER <- spvs_Violin(dfCER, '/ [tCr]',list('Asp','Gln','Glu'),c('Group'),lowerLiInst,upperLiInstNeuro,c(""),1)
pCER <- pCER[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_Off_Cr_NEURO_Vio.pdf", pCER, width = 10, height = 20,device=cairo_pdf) #saves g

lowerLiInstAnti <- c(0,0.5)
upperLiInstAnti <- c(.4,2)
pCER <- spvs_Violin(dfCER, '/ [tCr]',list('GSH','tNAA'),c('Group'),lowerLiInstAnti,upperLiInstAnti,c(""),1)
pCER <- pCER[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_Off_Cr_ANTI_Vio.pdf", pCER, width = 10, height = 20,device=cairo_pdf) #saves g



dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERHE),c('A-con','C-HE'))
statsCER <- spvs_Statistics(dfCER,list('tCho','Ins','Scyllo','Tau','GSH','tNAA','Asp','Gln','Glu','Glx'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/CER_stat_all.txt')
print(statsCER)
sink()

#Load OFF THA dataframes

dfTHA <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivativesTHAconc/LCMoutput')
dfTHA <- dfTHA[[1]]
dfTHA <- spvs_AddStatsToDataframe(dfTHA,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfTHA$CFF <- NULL
dfTHA$PEG <- NULL
dfTHA$age <- NULL

#Remove outlier
dfTHA <- dfTHA[-c(1,2,12,21,28),]

#Sort THAebella differnce spectra data
dfTHACon <- subset(dfTHA, numGroup == 1)
dfTHAmHE <- subset(dfTHA, numGroup == 2)
dfTHAHE <- subset(dfTHA, numGroup == 3)
dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAmHE,dfTHAHE),c('A-con','B-mHE','C-HE'))

dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAHE),c('A-con','C-HE'))

pTHA <- spvs_Violin(dfTHA, '/ [tCr]',list('Ins','Scyllo','Tau','tCho'),c('Group'),lowerLiInst,upperLiInstOsmo,c(""),1)
pTHA <- pTHA[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_Off_Cr_OSMO_Vio.pdf", pTHA, width = 10, height = 20,device=cairo_pdf) #saves g
pTHA

pTHA <- spvs_Violin(dfTHA, '/ [tCr]',list('Asp','Gln','Glu'),c('Group'),lowerLiInst,upperLiInstNeuro,c(""),1)
pTHA <- pTHA[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_Off_Cr_NEURO_Vio.pdf", pTHA, width = 10, height = 20,device=cairo_pdf) #saves g
pTHA

pTHA <- spvs_Violin(dfTHA, '/ [tCr]',list('GSH','tNAA'),c('Group'),lowerLiInstAnti,upperLiInstAnti,c(""),1)
pTHA <- pTHA[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_Off_Cr_ANTI_Vio.pdf", pTHA, width = 10, height = 20,device=cairo_pdf) #saves g
pTHA

statsTHA <- spvs_Statistics(dfTHA,list('tCho','Ins','Scyllo','Tau','GSH','tNAA','Asp','Gln','Glu','Glx'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/THA_stat_all.txt')
print(statsTHA)
sink()

#Load OFF MOT dataframes
dfMOT <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivativesMOTsep/LCMoutput')
dfMOT <- dfMOT[[1]]
dfMOT <- spvs_AddStatsToDataframe(dfMOT,'/Volumes/Elements/working/GABA_HE/statMOT.csv')
dfMOT$CFF <- NULL
dfMOT$PEG <- NULL
dfMOT$age <- NULL

#Remove outlier
dfMOT <- dfMOT[-c(2,4,5,9,12,13,14,15,19,20,32),]

#Sort MOT differnce spectra data
dfMOTCon <- subset(dfMOT, numGroup == 1)
dfMOTmHE <- subset(dfMOT, numGroup == 2)
dfMOTHE <- subset(dfMOT, numGroup == 3)
dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTmHE,dfMOTHE),c('A-con','B-mHE','C-HE'))
dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTHE),c('A-con','C-HE'))


pMOT <- spvs_Violin(dfMOT, '/ [tCr]',list('Ins','Scyllo','Tau','tCho'),c('Group'),lowerLiInst,upperLiInstOsmo,c(""),1)
pMOT <- pMOT[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_Off_Cr_OSMO_Vio.pdf", pMOT, width = 10, height = 20,device=cairo_pdf) #saves g
pMOT

pMOT <- spvs_Violin(dfMOT, '/ [tCr]',list('Asp','Gln','Glu'),c('Group'),lowerLiInst,upperLiInstNeuro,c(""),1)
pMOT <- pMOT[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_Off_Cr_NEURO_Vio.pdf", pMOT, width = 10, height = 20,device=cairo_pdf) #saves g
pMOT

pMOT <- spvs_Violin(dfMOT, '/ [tCr]',list('GSH','tNAA'),c('Group'),lowerLiInstAnti,upperLiInstAnti,c(""),1)
pMOT <- pMOT[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_Off_Cr_ANTI_Vio.pdf", pMOT, width = 10, height = 20,device=cairo_pdf) #saves g
pMOT

statsMOT <- spvs_Statistics(dfMOT,list('tCho','Ins','Scyllo','Tau','GSH','tNAA','Asp','Glu','Gln'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/MOT_stat_all.txt')
print(statsMOT)
sink()



#Correlation plots CER
dfCER <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivativesCER/LCMoutput')
dfCER <- dfCER[[1]]
dfCER <- spvs_AddStatsToDataframe(dfCER,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfCER$ammonia <- dfClinicAll$ammonia
dfCER$GOT <- dfClinicAll$GOT

#Remove outlier
# dfCER <- dfCER[-c(1,4,6,11,13,17,20,35,36,37,38),]
dfCER <- dfCER[-c(4,6,17,18,20,32),]

dfCERCon <- subset(dfCER, numGroup == 1)
dfCERmHE <- subset(dfCER, numGroup == 2)
dfCERHE <- subset(dfCER, numGroup == 3)
dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERmHE,dfCERHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075)
upperLiInst <- c(45,1.5,45,0.4,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175)
pCERCrCorr <- spvs_Correlation(list(dfCERCon,dfCERmHE,dfCERHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CFFvsCERCr.pdf", pCERCrCorr, width = 5, height = 20,device=cairo_pdf) #saves g
pCERCrCorr

pCERCrCorrPEG <- spvs_Correlation(list(dfCERCon,dfCERmHE,dfCERHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/PEGvsCERCr.pdf", pCERCrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorrPEG

pCERCrCorrNH3 <- spvs_Correlation(list(dfCERCon,dfCERmHE,dfCERHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/NH3vsCERCr.pdf", pCERCrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorrNH3

pCERCrCorrGOT <- spvs_Correlation(list(dfCERCon,dfCERmHE,dfCERHE),"",c("GOT","Asp",'GOT','tCho','GOT','GSH','GOT','Glu','GOT','Gln','GOT','Ins','GOT','tNAA'),c("GOT","Asp",'GOT','tCho','GOT','GSH','GOT','Glu','GOT','Gln','GOT','Ins','GOT','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/GOTvsCERCr.pdf", pCERCrCorrGOT, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorrGOT

#Correlation plots GABA THA

dfTHA <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivativesTHAconc/LCMoutput')
dfTHA <- dfTHA[[1]]
dfTHA <- spvs_AddStatsToDataframe(dfTHA,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfTHA$ammonia <- dfClinicAll$ammonia

#Remove outlier
# dfTHA <- dfTHA[-c(1,2,12,21),]
dfTHA <- dfTHA[-c(1,2,12,21,28),]

dfTHACon <- subset(dfTHA, numGroup == 1)
dfTHAmHE <- subset(dfTHA, numGroup == 2)
dfTHAHE <- subset(dfTHA, numGroup == 3)
dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAmHE,dfTHAHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.4,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175)
pTHACrCorr <- spvs_Correlation(list(dfTHACon,dfTHAmHE,dfTHAHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CFFvsTHACr.pdf", pTHACrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pTHACrCorr

pTHACrCorrPEG <- spvs_Correlation(list(dfTHACon,dfTHAmHE,dfTHAHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/PEGvsTHACr.pdf", pTHACrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pTHACrCorrPEG


pTHACrCorrNH3 <- spvs_Correlation(list(dfTHACon,dfTHAmHE,dfTHAHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/NH3vsTHACr.pdf", pTHACrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pTHACrCorrNH3


#Correlation plots GABA MOT
dfMOT <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivativesMOTsep/LCMoutput')
dfMOT <- dfMOT[[1]]
dfMOT <- spvs_AddStatsToDataframe(dfMOT,'/Volumes/Elements/working/GABA_HE/statMOT.csv')
dfClinicAllred <- dfClinicAll[-c(25,36),]
dfMOT$ammonia <- dfClinicAllred$ammonia

#Remove outlier
# dfMOT <- dfMOT[-c(2,4,5,9,12,14,15,19,20,32),]
dfMOT <- dfMOT[-c(2,4,5,9,12,13,14,15,19,20,32),]

dfMOTCon <- subset(dfMOT, numGroup == 1)
dfMOTmHE <- subset(dfMOT, numGroup == 2)
dfMOTHE <- subset(dfMOT, numGroup == 3)
dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTmHE,dfMOTHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.4,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175)
pMOTCrCorr <- spvs_Correlation(list(dfMOTCon,dfMOTmHE,dfMOTHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CFFvsMOTCr.pdf", pMOTCrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorr

pMOTCrCorrPEG <- spvs_Correlation(list(dfMOTCon,dfMOTmHE,dfMOTHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/PEGvsMOTCr.pdf", pMOTCrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorrPEG


pMOTCrCorrNH3 <- spvs_Correlation(list(dfMOTCon,dfMOTmHE,dfMOTHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/NH3vsMOTCr.pdf", pMOTCrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorrNH3


## Here starts i.u.

#Load OFF CER dataframes
dfCER <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivativesCER/LCMoutput','water')
dfCER <- dfCER[[1]]
dfCER <- spvs_AddStatsToDataframe(dfCER,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfCER$CFF <- NULL
dfCER$PEG <- NULL
dfCER$age <- NULL
dfCER$WM <- dfCERdiff$WM
dfCER$GM <- dfCERdiff$GM
dfCER$CSF <- dfCERdiff$CSF
dfCER <- spvs_TissueCorr(dfCER,.068,1.750,.068,1.750)
#Remove outlier
# dfCER <- dfCER[-c(1,4,6,11,13,17,20,35,36,37,38),]
dfCER <- dfCER[-c(4,6,17,18,20,32,35,37,38),]

#Sort cerebella differnce spectra data
dfCERCon <- subset(dfCER, numGroup == 1)
dfCERmHE <- subset(dfCER, numGroup == 2)
dfCERHE <- subset(dfCER, numGroup == 3)
dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERmHE,dfCERHE),c('A-con','B-mHE','C-HE'))

dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERHE),c('A-con','C-HE'))
lowerLiInst <- c(0,0,0,0)
upperLiInst <- c(15,1.2,10,5)
pCER <- spvs_Violin(dfCER, '/ [tCr]',list('Ins','Scyllo','Tau','tCho'),c('Group'),lowerLiInst,upperLiInst,c(""),1)
pCER <- pCER[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_Off_iu_OSMO_Vio.pdf", pCER, width = 10, height = 20,device=cairo_pdf) #saves g

lowerLiInst <- c(0,0,0)
upperLiInst <- c(21,21,21)
pCER <- spvs_Violin(dfCER, '/ [tCr]',list('Asp','Gln','Glu'),c('Group'),lowerLiInst,upperLiInst,c(""),1)
pCER <- pCER[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_Off_iu_NEURO_Vio.pdf", pCER, width = 10, height = 20,device=cairo_pdf) #saves g

lowerLiInst <- c(0,0,0)
upperLiInst <- c(6,6,6)
pCER <- spvs_Violin(dfCER, '/ [tCr]',list('GSH','tCr','tNAA'),c('Group'),lowerLiInst,upperLiInst,c(""),1)
pCER <- pCER[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_Off_iu_ANTI_Vio.pdf", pCER, width = 10, height = 20,device=cairo_pdf) #saves g



dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERHE),c('A-con','C-HE'))
statsCER <- spvs_Statistics(dfCER,list('tCho','Ins','Scyllo','Tau','GSH','Asp','tNAA','Gln','Glu','Glx','tCr'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/CER_stat_all_iu.txt')
print(statsCER)
sink()

#Load OFF THA dataframes

dfTHA <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivativesTHAconc/LCMoutput','water')
dfTHA <- dfTHA[[1]]
dfTHA <- spvs_AddStatsToDataframe(dfTHA,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfTHA$CFF <- NULL
dfTHA$PEG <- NULL
dfTHA$age <- NULL
dfTHA$WM <- dfTHAdiff$WM
dfTHA$GM <- dfTHAdiff$GM
dfTHA$CSF <- dfTHAdiff$CSF
dfTHA <- spvs_TissueCorr(dfTHA,.068,1.750,.068,1.750)

#Remove outlier
# dfTHA <- dfTHA[-c(1,2,12,21),]
dfTHA <- dfTHA[-c(1,2,12,21,28,36),]

#Sort THAebella differnce spectra data
dfTHACon <- subset(dfTHA, numGroup == 1)
dfTHAmHE <- subset(dfTHA, numGroup == 2)
dfTHAHE <- subset(dfTHA, numGroup == 3)
dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAmHE,dfTHAHE),c('A-con','B-mHE','C-HE'))

dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAHE),c('A-con','C-HE'))

lowerLiInst <- c(0,0,0,0)
upperLiInst <- c(15,1.2,10,5)
pTHA <- spvs_Violin(dfTHA, '/ [tCr]',list('Ins','Scyllo','Tau','tCho'),c('Group'),lowerLiInst,upperLiInst,c(""),1)
pTHA <- pTHA[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_Off_iu_OSMO_Vio.pdf", pTHA, width = 10, height = 20,device=cairo_pdf) #saves g
pTHA

lowerLiInst <- c(0,0,0)
upperLiInst <- c(21,21,21)
pTHA <- spvs_Violin(dfTHA, '/ [tCr]',list('Asp','Gln','Glu'),c('Group'),lowerLiInst,upperLiInst,c(""),1)
pTHA <- pTHA[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_Off_iu_NEURO_Vio.pdf", pTHA, width = 10, height = 20,device=cairo_pdf) #saves g
pTHA

lowerLiInst <- c(0,0,0)
upperLiInst <- c(6,6,6)
pTHA <- spvs_Violin(dfTHA, '/ [tCr]',list('GSH','tCr','tNAA'),c('Group'),lowerLiInst,upperLiInst,c(""),1)
pTHA <- pTHA[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_Off_iu_ANTI_Vio.pdf", pTHA, width = 10, height = 20,device=cairo_pdf) #saves g
pTHA

statsTHA <- spvs_Statistics(dfTHA,list('tCho','Ins','Scyllo','Tau','GSH','Asp','tNAA','Gln','Glu','Glx','tCr'),0)
statsTHA <- spvs_Statistics(dfTHA,list('Ins','tCho','Scyllo','Tau','GSH','Asp','tNAA','Gln','Glu','Glx','tCr'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/THA_stat_all_iu.txt')
print(statsTHA)
sink()

#Load OFF MOT dataframes
dfMOT <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivativesMOTsep/LCMoutput','water')
dfMOT <- dfMOT[[1]]
dfMOT <- spvs_AddStatsToDataframe(dfMOT,'/Volumes/Elements/working/GABA_HE/statMOT.csv')
dfMOT$CFF <- NULL
dfMOT$PEG <- NULL
dfMOT$age <- NULL
dfMOT$WM <- dfMOTdiff$WM
dfMOT$GM <- dfMOTdiff$GM
dfMOT$CSF <- dfMOTdiff$CSF
dfMOT <- spvs_TissueCorr(dfMOT,.068,1.750,.068,1.750)

#Remove outlier
# dfMOT <- dfMOT[-c(2,4,5,9,12,14,15,19,20,32),]
dfMOT <- dfMOT[-c(2,4,5,9,12,13,14,15,19,20,32,37),]

#Sort MOT differnce spectra data
dfMOTCon <- subset(dfMOT, numGroup == 1)
dfMOTmHE <- subset(dfMOT, numGroup == 2)
dfMOTHE <- subset(dfMOT, numGroup == 3)
dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTmHE,dfMOTHE),c('A-con','B-mHE','C-HE'))
dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTHE),c('A-con','C-HE'))


lowerLiInst <- c(0,0,0,0)
upperLiInst <- c(15,1.2,10,5)
pMOT <- spvs_Violin(dfMOT, '/ [tCr]',list('Ins','Scyllo','Tau','tCho'),c('Group'),lowerLiInst,upperLiInst,c(""),1)
pMOT <- pMOT[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_Off_iu_OSMO_Vio.pdf", pMOT, width = 10, height = 20,device=cairo_pdf) #saves g
pMOT

lowerLiInst <- c(0,0,0)
upperLiInst <- c(21,21,21)
pMOT <- spvs_Violin(dfMOT, '/ [tCr]',list('Asp','Gln','Glu'),c('Group'),lowerLiInst,upperLiInst,c(""),1)
pMOT <- pMOT[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_Off_iu_NEURO_Vio.pdf", pMOT, width = 10, height = 20,device=cairo_pdf) #saves g
pMOT

lowerLiInst <- c(0,0,0)
upperLiInst <- c(6,6,6)
pMOT <- spvs_Violin(dfMOT, '/ [tCr]',list('GSH','tCr','tNAA'),c('Group'),lowerLiInst,upperLiInst,c(""),1)
pMOT <- pMOT[[1]]
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_Off_iu_ANTI_Vio.pdf", pMOT, width = 10, height = 20,device=cairo_pdf) #saves g
pMOT

statsMOT <- spvs_Statistics(dfMOT,list('tCho','Ins','Scyllo','Tau','GSH','Asp','tNAA','Glu','Gln','tCr'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/MOT_stat_all_iu.txt')
print(statsMOT)
sink()



#Correlation plots CER
dfCER <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivativesCER/LCMoutput','water')
dfCER <- dfCER[[1]]
dfCER <- spvs_AddStatsToDataframe(dfCER,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfCER$ammonia <- dfClinicAll$ammonia
dfCER$WM <- dfCERdiff$WM
dfCER$GM <- dfCERdiff$GM
dfCER$CSF <- dfCERdiff$CSF
dfCER <- spvs_TissueCorr(dfCER,.068,1.750,.068,1.750)

#Remove outlier
# dfCER <- dfCER[-c(1,4,6,11,13,17,20,35,36,37,38),]
dfCER <- dfCER[-c(4,6,17,18,20,32,35,37,38),]

dfCERCon <- subset(dfCER, numGroup == 1)
dfCERmHE <- subset(dfCER, numGroup == 2)
dfCERHE <- subset(dfCER, numGroup == 3)
dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERmHE,dfCERHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075)
upperLiInst <- c(45,20,45,4.5,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175)
pCERCrCorr <- spvs_Correlation(list(dfCERCon,dfCERmHE,dfCERHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CFFvsCERiu.pdf", pCERCrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorr

pCERCrCorrPEG <- spvs_Correlation(list(dfCERCon,dfCERmHE,dfCERHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/PEGvsCERiu.pdf", pCERCrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorrPEG

pCERCrCorrNH3 <- spvs_Correlation(list(dfCERCon,dfCERmHE,dfCERHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/NH3vsCERiu.pdf", pCERCrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorrNH3



#Correlation plots GABA THA

dfTHA <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivativesTHAconc/LCMoutput','water')
dfTHA <- dfTHA[[1]]
dfTHA <- spvs_AddStatsToDataframe(dfTHA,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfTHA$ammonia <- dfClinicAll$ammonia
dfTHA$WM <- dfTHAdiff$WM
dfTHA$GM <- dfTHAdiff$GM
dfTHA$CSF <- dfTHAdiff$CSF
dfTHA <- spvs_TissueCorr(dfTHA,.068,1.750,.068,1.750)

#Remove outlier
# dfTHA <- dfTHA[-c(1,2,12,21),]
dfTHA <- dfTHA[-c(1,2,12,21,28,36),]

dfTHACon <- subset(dfTHA, numGroup == 1)
dfTHAmHE <- subset(dfTHA, numGroup == 2)
dfTHAHE <- subset(dfTHA, numGroup == 3)
dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAmHE,dfTHAHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175)
pTHACrCorr <- spvs_Correlation(list(dfTHACon,dfTHAmHE,dfTHAHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CFFvsTHAiu.pdf", pTHACrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pTHACrCorr


pTHACrCorrPEG <- spvs_Correlation(list(dfTHACon,dfTHAmHE,dfTHAHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/PEGvsTHAiu.pdf", pTHACrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pTHACrCorrPEG


pTHACrCorrNH3 <- spvs_Correlation(list(dfTHACon,dfTHAmHE,dfTHAHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/NH3vsTHAiu.pdf", pTHACrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pTHACrCorrNH3


#Correlation plots GABA MOT
dfMOT <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivativesMOTsep/LCMoutput','water')
dfMOT <- dfMOT[[1]]
dfMOT <- spvs_AddStatsToDataframe(dfMOT,'/Volumes/Elements/working/GABA_HE/statMOT.csv')
dfClinicAllred <- dfClinicAll[-c(25,36),]
dfMOT$ammonia <- dfClinicAllred$ammonia
dfMOT$WM <- dfMOTdiff$WM
dfMOT$GM <- dfMOTdiff$GM
dfMOT$CSF <- dfMOTdiff$CSF
dfMOT <- spvs_TissueCorr(dfMOT,.068,1.750,.068,1.750)

#Remove outlier
# dfMOT <- dfMOT[-c(2,4,5,9,12,14,15,19,20,32),]
dfMOT <- dfMOT[-c(2,4,5,9,12,13,14,15,19,20,32,37),]

dfMOTCon <- subset(dfMOT, numGroup == 1)
dfMOTmHE <- subset(dfMOT, numGroup == 2)
dfMOTHE <- subset(dfMOT, numGroup == 3)
dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTmHE,dfMOTHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175)
pMOTCrCorr <- spvs_Correlation(list(dfMOTCon,dfMOTmHE,dfMOTHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','AscGtNAASH'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CFFvsMOTiu.pdf", pMOTCrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorr


pMOTCrCorrPEG <- spvs_Correlation(list(dfMOTCon,dfMOTmHE,dfMOTHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/PEGvsMOTiu.pdf", pMOTCrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorrPEG


pMOTCrCorrNH3 <- spvs_Correlation(list(dfMOTCon,dfMOTmHE,dfMOTHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/NH3vsMOTiu.pdf", pMOTCrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorrNH3
