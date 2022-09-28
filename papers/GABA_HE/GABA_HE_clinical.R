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
source('functions/spvs_lm_group.R')
source('functions/spvs_part_corr.R')
library(corrplot)
library(Cairo)

# Demographics ------------------------------------------------------------


#Get demographics and clinical data
dfDemo <- read.csv('/Volumes/Elements/working/GABA_HE/statFull.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfClinic <- read.csv('/Volumes/Elements/working/GABA_HE/clinicFull.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfClinicAll <- spvs_AddStatsToDataframe(dfDemo,'/Volumes/Elements/working/GABA_HE/clinicFull.csv')
dfClinicAll$Group...1<-NULL
dfClinicAll$Group...2<-NULL
dfClinicAll$numGroup...2<-NULL
dfClinicAll$numGroup<-dfClinicAll$numGroup...7
dfClinicAll$Group<-dfClinicAll$Group...6
dfClinicAll$numGroup...7<-NULL
dfClinicAll$Group...6<-NULL

dfDemo <- dfDemo[-c(34,35,36,37),]
dfClinic <- dfClinic[-c(34,35,36,37),]

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

dfDemo <- read.csv('/Volumes/Elements/working/GABA_HE/statFull.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfClinic <- read.csv('/Volumes/Elements/working/GABA_HE/clinicFull.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfClinicAll <- spvs_AddStatsToDataframe(dfDemo,'/Volumes/Elements/working/GABA_HE/clinicFull.csv')
dfClinicAll$Group...1<-NULL
dfClinicAll$Group...2<-NULL
dfClinicAll$numGroup...2<-NULL
dfClinicAll$numGroup<-dfClinicAll$numGroup...7
dfClinicAll$Group<-dfClinicAll$Group...6
dfClinicAll$numGroup...7<-NULL
dfClinicAll$Group...6<-NULL

#Sort demographics and clinical data
dfDemoCon <- subset(dfDemo, numGroup == 1,select=c(Group, numGroup,CFF,PEG,age))
dfDemomHE <- subset(dfDemo, numGroup == 2,select=c(Group, numGroup,CFF,PEG,age))
dfDemoHE <- subset(dfDemo, numGroup == 3,select=c(Group, numGroup,CFF,PEG,age))
dfDemo <- spvs_ConcatenateDataFrame(list(dfDemoCon,dfDemomHE,dfDemoHE),c('A-con','B-mHE','C-HE'))
dfClinicCon <- subset(dfClinic, numGroup == 1)
dfClinicmHE <- subset(dfClinic, numGroup == 2)
dfClinicHE <- subset(dfClinic, numGroup == 3)
dfClinic <- spvs_ConcatenateDataFrame(list(dfClinicCon,dfClinicmHE,dfClinicHE),c('A-con','B-mHE','C-HE'))


# Difference spectra ------------------------------------------------------
#Load GABA dataframes
colorRain <- c(color[1],color[3])
dfCERdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetCER.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfCERdiff <- spvs_AddStatsToDataframe(dfCERdiff,'/Volumes/Elements/working/GABA_HE/statFull.csv')

dfCERdiff$CRLBCr <- 1/(dfCERdiff$GABACr * dfCERdiff$GABAEr/100)
dfCERdiff$CRLBiu <- 1/(dfCERdiff$GABAiu * dfCERdiff$GABAEr/100)
#Remove outlier 
#dfCERdiff <- dfCERdiff[-c(1,2,23,11,13,34,35,36,37),]

dfCERdiff <- dfCERdiff[-c(11,13,23,34,35,36,37),]

#Sort cerebella differnce spectra data
dfCERdiffCon <- subset(dfCERdiff, numGroup == 1)
dfCERdiffmHE <- subset(dfCERdiff, numGroup == 2)
dfCERdiffHE <- subset(dfCERdiff, numGroup == 3)
dfCERdiff <- spvs_ConcatenateDataFrame(list(dfCERdiffCon,dfCERdiffmHE,dfCERdiffHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(5,0,5)
upperLiInst <- c(12,12,12)
pCERdiff <- spvs_RainCloud(dfCERdiff, '',list('FWHM','SNR','GABAEr'),c('Group'),lowerLiInst,upperLiInst,title=c(""),colNum=3,CVlabel=0)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_GABA/CER_QC.pdf", pCERdiff, width = 10, height = 10,device=cairo_pdf) #saves g
pCERdiff
dfCERdiff <- spvs_ConcatenateDataFrame(list(dfCERdiffCon,dfCERdiffHE),c('A-con','C-HE'))

lowerLiInst <- c(0,0.05)
upperLiInst <- c(6.5,0.175)

pCERdiffGABA <- spvs_RainCloud(dfCERdiff, '',list('GABACr','GABAiu'),c('Group'),lowerLiInst,upperLiInst,title=c(""),colNum=2,CVlabel=0)
pCERdiffGABA
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_GABA/CER_GABA.pdf", pCERdiffGABA, width = 10, height = 10,device=cairo_pdf) #saves g

dfCERdiff <- spvs_ConcatenateDataFrame(list(dfCERdiffCon,dfCERdiffHE),c('A-con','C-HE'))
CER_diff_p <- spvs_lm_group(dfCERdiff,list('GABACr','GABAiu'),'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_GABA/CER_GABA_lm.txt')
CER_diff_p <- spvs_lm_group(dfCERdiff,list('GABACr','GABAiu'),'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_GABA/CER_GABA_lm_age.txt','age')
CER_diff_p <- spvs_lm_group(dfCERdiff,list('GABACr','GABAiu'),'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_GABA/CER_GABA_lm_CRLB.txt',weighting=list('CRLBCr','CRLBiu'))
CER_diff_p <- spvs_lm_group(dfCERdiff,list('GABACr','GABAiu'),'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_GABA/CER_GABA_lm_age_CRLB.txt','age',list('CRLBCr','CRLBiu'))


statsCERdiff <- spvs_Statistics(dfCERdiff,list('GABACr','GABAiu'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/CER_GABA/CER_GABA_stat.txt')
print(statsCERdiff)
sink()

statsCER <- spvs_Statistics(dfCERdiff,list('FWHM','SNR','GABAEr'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/CER_GABA/CER_stat.txt')
print(statsCER)
sink()

#Load Thalamus GABA dataframes
dfTHAdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetTHA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfTHAdiff <- spvs_AddStatsToDataframe(dfTHAdiff,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfTHAdiff$CRLBCr <- 1/(dfTHAdiff$GABACr * dfTHAdiff$GABAEr/100)
dfTHAdiff$CRLBiu <- 1/(dfTHAdiff$GABAiu * dfTHAdiff$GABAEr/100)

#Remove outlier
dfTHAdiff <- dfTHAdiff[-c(2,34,35,36,37),]
#dfTHAdiff <- dfTHAdiff[-c(2,12,28,30,34,35,36,37),]

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
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_GABA/THA_QC.pdf", pTHAdiff, width = 10, height = 10,device=cairo_pdf) #saves g
pTHAdiff

lowerLiInst <- c(0,0.05)
upperLiInst <- c(6.5,0.175)

pTHAdiffGABA <- spvs_RainCloud(dfTHAdiff, '',list('GABACr','GABAiu'),c('Group'),lowerLiInst,upperLiInst,title=c(""),colNum=2,CVlabel=0)
pTHAdiffGABA
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_GABA/THA_GABA_iu.pdf", pTHAdiffGABA, width = 10, height = 10,device=cairo_pdf) #saves g


dfTHAdiff <- spvs_ConcatenateDataFrame(list(dfTHAdiffCon,dfTHAdiffHE),c('A-con','C-HE'))
THA_diff_p <- spvs_lm_group(dfTHAdiff,list('GABACr','GABAiu'),'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_GABA/THA_GABA_lm.txt')
THA_diff_p <- spvs_lm_group(dfTHAdiff,list('GABACr','GABAiu'),'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_GABA/THA_GABA_lm_age.txt','age')
THA_diff_p <- spvs_lm_group(dfTHAdiff,list('GABACr','GABAiu'),'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_GABA/THA_GABA_lm_CRLB.txt',weighting=list('CRLBCr','CRLBiu'))
THA_diff_p <- spvs_lm_group(dfTHAdiff,list('GABACr','GABAiu'),'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_GABA/THA_GABA_lm_age_CRLB.txt','age',list('CRLBCr','CRLBiu'))


statsTHAdiff <- spvs_Statistics(dfTHAdiff,list('GABACr','GABAiu'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/THA_GABA/THA_GABA_stat.txt')
print(statsTHAdiff)
sink()

statsTHA <- spvs_Statistics(dfTHAdiff,list('FWHM','SNR','GABAEr'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/THA_GABA/THA_stat_iu.txt')
print(statsTHA)
sink()

#Load MC GABA dataframes
dfMOTdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetMOT.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfMOTdiff <- spvs_AddStatsToDataframe(dfMOTdiff,'/Volumes/Elements/working/GABA_HE/statMOTdiff.csv')
dfMOTdiff$CRLBCr <- 1/(dfMOTdiff$GABACr * dfMOTdiff$GABAEr/100)
dfMOTdiff$CRLBiu <- 1/(dfMOTdiff$GABAiu * dfMOTdiff$GABAEr/100)


#Remove outlier
#dfMOTdiff <- dfMOTdiff[-c(2,4,7,14,15,19,32,34,35,36,37,39),]
dfMOTdiff <- dfMOTdiff[-c(4,7,14,15,32,34,35,36,37,39),]
#dfMOTdiff <- dfMOTdiff[-c(4,7,14,15,32,34,35,36,37,39),]

#Sort cerebella differnce spectra data
dfMOTdiffCon <- subset(dfMOTdiff, numGroup == 1)
dfMOTdiffmHE <- subset(dfMOTdiff, numGroup == 2)
dfMOTdiffHE <- subset(dfMOTdiff, numGroup == 3)

dfMOTdiff <- spvs_ConcatenateDataFrame(list(dfMOTdiffCon,dfMOTdiffmHE,dfMOTdiffHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(5,0,5)
upperLiInst <- c(12,12,12)
pMOTdiff <- spvs_RainCloud(dfMOTdiff, '',list('FWHM','SNR','GABAEr'),c('Group'),lowerLiInst,upperLiInst,title=c(""),colNum=3,CVlabel=0)
pMOTdiff <- pMOTdiff + scale_color_manual(values = colorRain)+scale_fill_manual(values = colorRain)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA/MOT_QC.pdf", pMOTdiff, width = 10, height = 10,device=cairo_pdf) #saves g
pMOTdiff

dfMOTdiff <- spvs_ConcatenateDataFrame(list(dfMOTdiffCon,dfMOTdiffHE),c('A-con','C-HE'))
lowerLiInst <- c(0,0.05)
upperLiInst <- c(6.5,0.175)

pMOTdiffGABA <- spvs_RainCloud(dfMOTdiff, '',list('GABACr','GABAiu'),c('Group'),lowerLiInst,upperLiInst,title=c(""),colNum=2,CVlabel=0)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA/MOT_GABA.pdf", pMOTdiffGABA, width = 10, height = 10,device=cairo_pdf) #saves g
pMOTdiffGABA

MOT_diff_p <- spvs_lm_group(dfMOTdiff,list('GABACr','GABAiu'),'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_GABA/MOT_GABA_lm.txt')
MOT_diff_p <- spvs_lm_group(dfMOTdiff,list('GABACr','GABAiu'),'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_GABA/MOT_GABA_lm_age.txt','age')
MOT_diff_p <- spvs_lm_group(dfMOTdiff,list('GABACr','GABAiu'),'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_GABA/MOT_GABA_lm_CRLB.txt',weighting=list('CRLBCr','CRLBiu'))
MOT_diff_p <- spvs_lm_group(dfMOTdiff,list('GABACr','GABAiu'),'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_GABA/MOT_GABA_lm_age_CRLB.txt','age',list('CRLBCr','CRLBiu'))


statsMOTdiff <- spvs_Statistics(dfMOTdiff,list('GABACr','GABAiu'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA/MOT_GABA_stat.txt')
print(statsMOTdiff)
sink()

statsMOT <- spvs_Statistics(dfMOTdiff,list('FWHM','SNR','GABAEr'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA/MOT_stat.txt')
print(statsMOT)
sink()


#Correlation plots GABA CER
dfCERdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetCER.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfCERdiff <- spvs_AddStatsToDataframe(dfCERdiff,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfCERdiff$CRLBCr <- 1/(dfCERdiff$GABACr * dfCERdiff$GABAEr/100)
dfCERdiff$CRLBiu <- 1/(dfCERdiff$GABAiu * dfCERdiff$GABAEr/100)
dfCERdiff$ammonia <- dfClinicAll$ammonia
dfCERdiff$CRP <- dfClinicAll$CRP
#Remove outlier
dfCERdiff <- dfCERdiff[-c(1,2,23,11,13,34,35,36,37),]
dfCERdiffCon <- subset(dfCERdiff, numGroup == 1)
dfCERdiffmHE <- subset(dfCERdiff, numGroup == 2)
dfCERdiffHE <- subset(dfCERdiff, numGroup == 3)
dfCERdiff <- spvs_ConcatenateDataFrame(list(dfCERdiffCon,dfCERdiffmHE,dfCERdiffHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.175)
pCERGABACrCorr <- spvs_Correlation(list(dfCERdiffCon,dfCERdiffmHE,dfCERdiffHE),"",c("CFF","GABACr",'PEG','GABACr'),c('CFF','GABACr','PEG','GABACr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_GABA/CFFvsCERGABACr.pdf", pCERGABACrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pCERGABACrCorr

lowerLiInst <- c(30,3,30,3)
upperLiInst <- c(45,7,45,7)
pCERGABACorr <- spvs_Correlation(list(dfCERdiffCon,dfCERdiffmHE,dfCERdiffHE),"",c("CFF","GABAiu",'PEG','GABAiu'),c('CFF','GABAiu','PEG','GABAiu'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_GABA/CFFvsCERGABA.pdf", pCERGABACorr, width = 5, height = 10,device=cairo_pdf) #saves g
pCERGABACorr

lowerLiInst <- c(30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.175)
pCERGABACrCorrAm <- spvs_Correlation(list(dfCERdiffmHE,dfCERdiffHE),"",c("ammonia","GABACr",'CRP','GABACr'),c('ammonia','GABACr','CRP','GABACr'),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_GABA/ammoniavsCERGABACr.pdf", pCERGABACrCorrAm, width = 5, height = 10,device=cairo_pdf) #saves g
pCERGABACrCorrAm

lowerLiInst <- c(30,3,30,3)
upperLiInst <- c(45,7,45,7)
pCERGABACorrAm <- spvs_Correlation(list(dfCERdiffmHE,dfCERdiffHE),"",c("ammonia","GABAiu",'CRP','GABAiu'),c('ammonia','GABAiu','CRP','GABAiu'),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_GABA/ammoniavsCERGABAiu.pdf", pCERGABACorrAm, width = 5, height = 10,device=cairo_pdf) #saves g
pCERGABACorrAm

CER_diff_p_CFF <- spvs_part_corr(dfCERdiff,list('GABACr','GABAiu'),'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_GABA/CER_GABA_CFF.txt')
CER_diff_p_CFF <- spvs_part_corr(dfCERdiff,list('GABACr','GABAiu'),'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_GABA/CER_GABA_CFF_age.txt','age')
CER_diff_p_CFF <- spvs_part_corr(dfCERdiff,list('GABACr','GABAiu'),'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_GABA/CER_GABA_CFF_CRLB.txt',weighting=list('CRLBCr','CRLBiu'))
CER_diff_p_CFF <- spvs_part_corr(dfCERdiff,list('GABACr','GABAiu'),'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_GABA/CER_GABA_CFF_age_CRLB.txt','age',list('CRLBCr','CRLBiu'))

CER_diff_p_PEG <- spvs_part_corr(dfCERdiff,list('GABACr','GABAiu'),'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_GABA/CER_GABA_PEG.txt')
CER_diff_p_PEG <- spvs_part_corr(dfCERdiff,list('GABACr','GABAiu'),'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_GABA/CER_GABA_PEG_age.txt','age')
CER_diff_p_PEG <- spvs_part_corr(dfCERdiff,list('GABACr','GABAiu'),'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_GABA/CER_GABA_PEG_CRLB.txt',weighting=list('CRLBCr','CRLBiu'))
CER_diff_p_PEG <- spvs_part_corr(dfCERdiff,list('GABACr','GABAiu'),'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_GABA/CER_GABA_PEG_age_CRLB.txt','age',list('CRLBCr','CRLBiu'))

CER_diff_p_NH3 <- spvs_part_corr(dfCERdiff,list('GABACr','GABAiu'),'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_GABA/CER_GABA_ammonia.txt')
CER_diff_p_NH3 <- spvs_part_corr(dfCERdiff,list('GABACr','GABAiu'),'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_GABA/CER_GABA_ammonia_age.txt','age')
CER_diff_p_NH3 <- spvs_part_corr(dfCERdiff,list('GABACr','GABAiu'),'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_GABA/CER_GABA_ammonia_CRLB.txt',weighting=list('CRLBCr','CRLBiu'))
CER_diff_p_NH3 <- spvs_part_corr(dfCERdiff,list('GABACr','GABAiu'),'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_GABA/CER_GABA_ammonia_age_CRLB.txt','age',list('CRLBCr','CRLBiu'))

#Correlation plots GABA THA
dfTHAdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetTHA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfTHAdiff <- spvs_AddStatsToDataframe(dfTHAdiff,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfTHAdiff$ammonia <- dfClinicAll$ammonia
dfTHAdiff$CRP <- dfClinicAll$CRP
dfTHAdiff$CRLBCr <- 1/(dfTHAdiff$GABACr * dfTHAdiff$GABAEr/100)
dfTHAdiff$CRLBiu <- 1/(dfTHAdiff$GABAiu * dfTHAdiff$GABAEr/100)
#Remove outlier
dfTHAdiff <- dfTHAdiff[-c(2,34,35,36,37),]
dfTHAdiffCon <- subset(dfTHAdiff, numGroup == 1)
dfTHAdiffmHE <- subset(dfTHAdiff, numGroup == 2)
dfTHAdiffHE <- subset(dfTHAdiff, numGroup == 3)
dfTHAdiff <- spvs_ConcatenateDataFrame(list(dfTHAdiffCon,dfTHAdiffmHE,dfTHAdiffHE),c('A-con','C-HE'))
lowerLiInst <- c(30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.175)
pTHAGABACrCorr <- spvs_Correlation(list(dfTHAdiffCon,dfTHAdiffmHE,dfTHAdiffHE),"",c("CFF","GABACr",'PEG','GABACr'),c('CFF','GABACr','PEG','GABACr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_GABA/CFFvsTHAGABACr.pdf", pTHAGABACrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pTHAGABACrCorr

lowerLiInst <- c(30,3,30,3)
upperLiInst <- c(45,7,45,7)
pTHAGABACorr <- spvs_Correlation(list(dfTHAdiffCon,dfTHAdiffmHE,dfTHAdiffHE),"",c("CFF","GABAiu",'PEG','GABAiu'),c('CFF','GABAiu','PEG','GABAiu'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_GABA/CFFvsTHAGABA.pdf", pTHAGABACorr, width = 5, height = 10,device=cairo_pdf) #saves g
pTHAGABACorr

lowerLiInst <- c(30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.175)
pTHAGABACrCorrAm <- spvs_Correlation(list(dfTHAdiffmHE,dfTHAdiffHE),"",c("ammonia","GABACr",'CRP','GABACr'),c('ammonia','GABACr','CRP','GABACr'),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_GABA/ammoniavsTHAGABACr.pdf", pTHAGABACrCorrAm, width = 5, height = 10,device=cairo_pdf) #saves g
pTHAGABACrCorrAm

lowerLiInst <- c(30,3,30,3)
upperLiInst <- c(45,7,45,7)
pTHAGABACorrAm <- spvs_Correlation(list(dfTHAdiffmHE,dfTHAdiffHE),"",c("ammonia","GABAiu",'CRP','GABAiu'),c('ammonia','GABAiu','CRP','GABAiu'),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_GABA/ammoniavsTHAGABA.pdf", pTHAGABACorrAm, width = 5, height = 10,device=cairo_pdf) #saves g
pTHAGABACorrAm

THA_diff_p_CFF <- spvs_part_corr(dfTHAdiff,list('GABACr','GABAiu'),'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_GABA/THA_GABA_CFF.txt')
THA_diff_p_CFF <- spvs_part_corr(dfTHAdiff,list('GABACr','GABAiu'),'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_GABA/THA_GABA_CFF_age.txt','age')
THA_diff_p_CFF <- spvs_part_corr(dfTHAdiff,list('GABACr','GABAiu'),'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_GABA/THA_GABA_CFF_CRLB.txt',weighting=list('CRLBCr','CRLBiu'))
THA_diff_p_CFF <- spvs_part_corr(dfTHAdiff,list('GABACr','GABAiu'),'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_GABA/THA_GABA_CFF_age_CRLB.txt','age',list('CRLBCr','CRLBiu'))

THA_diff_p_PEG <- spvs_part_corr(dfTHAdiff,list('GABACr','GABAiu'),'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_GABA/THA_GABA_PEG.txt')
THA_diff_p_PEG <- spvs_part_corr(dfTHAdiff,list('GABACr','GABAiu'),'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_GABA/THA_GABA_PEG_age.txt','age')
THA_diff_p_PEG <- spvs_part_corr(dfTHAdiff,list('GABACr','GABAiu'),'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_GABA/THA_GABA_PEG_CRLB.txt',weighting=list('CRLBCr','CRLBiu'))
THA_diff_p_PEG <- spvs_part_corr(dfTHAdiff,list('GABACr','GABAiu'),'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_GABA/THA_GABA_PEG_age_CRLB.txt','age',list('CRLBCr','CRLBiu'))

THA_diff_p_NH3 <- spvs_part_corr(dfTHAdiff,list('GABACr','GABAiu'),'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_GABA/THA_GABA_ammonia.txt')
THA_diff_p_NH3 <- spvs_part_corr(dfTHAdiff,list('GABACr','GABAiu'),'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_GABA/THA_GABA_ammonia_age.txt','age')
THA_diff_p_NH3 <- spvs_part_corr(dfTHAdiff,list('GABACr','GABAiu'),'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_GABA/THA_GABA_ammonia_CRLB.txt',weighting=list('CRLBCr','CRLBiu'))
THA_diff_p_NH3 <- spvs_part_corr(dfTHAdiff,list('GABACr','GABAiu'),'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_GABA/THA_GABA_ammonia_age_CRLB.txt','age',list('CRLBCr','CRLBiu'))


#Correlation plots GABA MOT
dfMOTdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetMOT.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfMOTdiff <- spvs_AddStatsToDataframe(dfMOTdiff,'/Volumes/Elements/working/GABA_HE/statMOTdiff.csv')
dfClinicMot <- dfClinicAll[-c(21,32),]
dfMOTdiff$ammonia <- dfClinicMot$ammonia
dfMOTdiff$CRP <- dfClinicMot$CRP
dfMOTdiff$CRLBCr <- 1/(dfMOTdiff$GABACr * dfMOTdiff$GABAEr/100)
dfMOTdiff$CRLBiu <- 1/(dfMOTdiff$GABAiu * dfMOTdiff$GABAEr/100)
#Remove outlier
dfMOTdiff <- dfMOTdiff[-c(4,7,14,15,32,34,35,36,37,39),]
dfMOTdiffCon <- subset(dfMOTdiff, numGroup == 1)
dfMOTdiffmHE <- subset(dfMOTdiff, numGroup == 2)
dfMOTdiffHE <- subset(dfMOTdiff, numGroup == 3)
dfMOTdiff <- spvs_ConcatenateDataFrame(list(dfMOTdiffCon,dfMOTdiffmHE,dfMOTdiffHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(30,0.05,30,0.05)
upperLiInst <- c(45,0.15,45,0.15)
pMOTGABACrCorr <- spvs_Correlation(list(dfMOTdiffCon,dfMOTdiffmHE,dfMOTdiffHE),"",c("CFF","GABACr",'PEG','GABACr'),c('CFF','GABACr','PEG','GABACr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA/CFFvsMOTGABACr.pdf", pMOTGABACrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTGABACrCorr

lowerLiInst <- c(30,1.5,30,1.5)
upperLiInst <- c(45,4.5,45,4.5)
pMOTGABACorr <- spvs_Correlation(list(dfMOTdiffCon,dfMOTdiffmHE,dfMOTdiffHE),"",c("CFF","GABAiu",'PEG','GABAiu'),c('CFF','GABAiu','PEG','GABAiu'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA/CFFvsMOTGABA.pdf", pMOTGABACorr, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTGABACorr

lowerLiInst <- c(30,0,30,0)
upperLiInst <- c(45,0.175,45,0.175)
pMOTGABACrCorr <- spvs_Correlation(list(dfMOTdiffCon,dfMOTdiffHE),"",c("CFF","GABACr",'PEG','GABACr'),c('CFF','GABACr','PEG','GABACr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA/CFFvsMOTGABACr_nomHE.pdf", pMOTGABACrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTGABACrCorr

lowerLiInst <- c(30,0,30,0)
upperLiInst <- c(45,4,45,4)
pMOTGABACorr <- spvs_Correlation(list(dfMOTdiffCon,dfMOTdiffHE),"",c("CFF","GABAiu",'PEG','GABAiu'),c('CFF','GABAiu','PEG','GABAiu'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA/CFFvsMOTGABA_nomHE.pdf", pMOTGABACorr, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTGABACorr

lowerLiInst <- c(30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.175)
pMOTGABACrCorrAm <- spvs_Correlation(list(dfMOTdiffmHE,dfMOTdiffHE),"",c("ammonia","GABACr",'CRP','GABACr'),c('ammonia','GABACr','CRP','GABACr'),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA/ammoniavsMOTGABACr.pdf", pMOTGABACrCorrAm, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTGABACrCorrAm

lowerLiInst <- c(30,3,30,3)
upperLiInst <- c(45,7,45,7)
pMOTGABACorrAm <- spvs_Correlation(list(dfMOTdiffmHE,dfMOTdiffHE),"",c("ammonia","GABAiu",'CRP','GABAiu'),c('ammonia','GABAiu','CRP','GABAiu'),c('mHE','HE'),NULL,lowerLiInst,upperLiInst, 2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA/ammoniavsMOTGABA.pdf", pMOTGABACorrAm, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTGABACorrAm

MOT_diff_p_CFF <- spvs_part_corr(dfMOTdiff,list('GABACr','GABAiu'),'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_GABA/MOT_GABA_CFF.txt')
MOT_diff_p_CFF <- spvs_part_corr(dfMOTdiff,list('GABACr','GABAiu'),'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_GABA/MOT_GABA_CFF_age.txt','age')
MOT_diff_p_CFF <- spvs_part_corr(dfMOTdiff,list('GABACr','GABAiu'),'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_GABA/MOT_GABA_CFF_CRLB.txt',weighting=list('CRLBCr','CRLBiu'))
MOT_diff_p_CFF <- spvs_part_corr(dfMOTdiff,list('GABACr','GABAiu'),'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_GABA/MOT_GABA_CFF_age_CRLB.txt','age',list('CRLBCr','CRLBiu'))

MOT_diff_p_PEG <- spvs_part_corr(dfMOTdiff,list('GABACr','GABAiu'),'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_GABA/MOT_GABA_PEG.txt')
MOT_diff_p_PEG <- spvs_part_corr(dfMOTdiff,list('GABACr','GABAiu'),'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_GABA/MOT_GABA_PEG_age.txt','age')
MOT_diff_p_PEG <- spvs_part_corr(dfMOTdiff,list('GABACr','GABAiu'),'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_GABA/MOT_GABA_PEG_CRLB.txt',weighting=list('CRLBCr','CRLBiu'))
MOT_diff_p_PEG <- spvs_part_corr(dfMOTdiff,list('GABACr','GABAiu'),'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_GABA/MOT_GABA_PEG_age_CRLB.txt','age',list('CRLBCr','CRLBiu'))

MOT_diff_p_NH3 <- spvs_part_corr(dfMOTdiff,list('GABACr','GABAiu'),'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_GABA/MOT_GABA_ammonia.txt')
MOT_diff_p_NH3 <- spvs_part_corr(dfMOTdiff,list('GABACr','GABAiu'),'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_GABA/MOT_GABA_ammonia_age.txt','age')
MOT_diff_p_NH3 <- spvs_part_corr(dfMOTdiff,list('GABACr','GABAiu'),'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_GABA/MOT_GABA_ammonia_CRLB.txt',weighting=list('CRLBCr','CRLBiu'))
MOT_diff_p_NH3 <- spvs_part_corr(dfMOTdiff,list('GABACr','GABAiu'),'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_GABA/MOT_GABA_ammonia_age_CRLB.txt','age',list('CRLBCr','CRLBiu'))


#Load Off CER dataframes
metablist <- list('tCho','Ins','GSH','tNAA','Asp','Gln','Glu','Glx')
invCRLBlist <- list('tCho_CRLB','Ins_CRLB','GSH_CRLB','tNAA_CRLB','Asp_CRLB','Gln_CRLB','Glu_CRLB','Glx_CRLB')

listCER <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/CER/LCMOutput_A_sep')
dfCER <- listCER[[1]]
dfCERCRLB <- listCER[[2]]
CRLB_sum <- summary(dfCERCRLB)
max_crlbs <- dfCERCRLB == 999
dfCERCRLB <- dfCER * dfCERCRLB/100
dfCERCRLB <- 1/dfCERCRLB
dfCERCRLB[max_crlbs] = 1/999
colnames(dfCERCRLB) <- paste(colnames(dfCERCRLB),'CRLB',sep='_')
dfCER <- spvs_AddStatsToDataframe(dfCER,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfCER <- bind_cols(dfCER,dfCERCRLB)
#Remove outlier
# dfCER <- dfCER[-c(1,4,6,11,13,17,20,35,36,37,38),]
dfCER <- dfCER[-c(15,34,35,36,37),]

#dfCERCon <- subset(dfCERCRLB, numGroup == 1)
#dfCERmHE <- subset(dfCERCRLB, numGroup == 2)
#dfCERHE <- subset(dfCERCRLB, numGroup == 3)

#dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERHE),c('A-con','C-HE'))
#statsCER <- spvs_Statistics(dfCER,list('tCho','Ins','Scyllo','Tau','GSH','tNAA','Asp','Gln','Glu','Glx'),0)
#sink('/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr/CER_stat_CRLB.txt')
#print(statsCER)
#sink()


#Sort cerebella differnce spectra data
dfCERCon <- subset(dfCER, numGroup == 1)
dfCERmHE <- subset(dfCER, numGroup == 2)
dfCERHE <- subset(dfCER, numGroup == 3)
dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERmHE,dfCERHE),c('A-con','B-mHE','C-HE'))

dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERHE),c('A-con','C-HE'))
lowerLiInst <- c(0,0,0,0)
upperLiInstOsmo <- c(0.4,1,0.1,1.25)
pCER <- spvs_RainCloud(dfCER, '/ [tCr]',list('Ins','Scyllo','Tau','tCho'),c('Group'),lowerLiInst,upperLiInstOsmo,c(""),2,2)
pCER
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr/CER_Off_Cr_OSMO_Vio.pdf", pCER, width = 10, height = 20,device=cairo_pdf) #saves g

lowerLiNeuro <- c(0,0,0)
upperLiInstNeuro <- c(2,2,1.5)
pCER <- spvs_RainCloud(dfCER, '/ [tCr]',list('Asp','Gln','Glu'),c('Group'),lowerLiNeuro,upperLiInstNeuro,c(""),2,2)
pCER
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr/CER_Off_Cr_NEURO_Vio.pdf", pCER, width = 10, height = 20,device=cairo_pdf) #saves g

lowerLiInstAnti <- c(0.75,0)
upperLiInstAnti <- c(2.5,0.3)
pCER <- spvs_RainCloud(dfCER, '/ [tCr]',list('GSH','tNAA'),c('Group'),lowerLiInstAnti,upperLiInstAnti,c(""),2,2)
pCER
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr/CER_Off_Cr_ANTI_Vio.pdf", pCER, width = 10, height = 20,device=cairo_pdf) #saves g



CER_off_cr_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_Cr/CER_lm.txt')
CER_off_cr_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_Cr/CER_lm_age.txt','age')
CER_off_cr_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_Cr/CER_lm_CRLB.txt',weighting=invCRLBlist)
CER_off_cr_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_Cr/CER_lm_age_CRLB.txt','age',invCRLBlist)

statsCER <- spvs_Statistics(dfCER,list('tCho','Ins','Scyllo','Tau','GSH','tNAA','Asp','Gln','Glu','Glx'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr/CER_stat_all.txt')
print(statsCER)
sink()

dfSummary <- data.frame(matrix(ncol = 8, nrow = 310))
#provide column names
colnames(dfSummary) <- c('mean','SD','Group','shift','metabolites','indiv_metabs_value','indiv_metabs_names','indiv_metabs_groups')
dfSummary[1:20,1] <- data_frame(statsCER$`Descriptive Statistics`$mean)
dfSummary[1:20,2] <- data_frame(statsCER$`Descriptive Statistics`$sd)
dfSummary[1:20,3] <- data_frame((rep(c('A-con','C-HE'), 10)))
dfSummary[1:20,4] <-data_frame(1:20)
dfSummary[1:20,5] <-c('tCho','tCho','Ins','Ins','Scyllo','Scyllo','Tau','Tau','GSH','GSH','tNAA','tNAA','Asp','Asp','Gln','Gln','Glu','Glu','Glx','Glx')
dfSummary[,6] <-c(dfCER$tCho,dfCER$Ins,dfCER$Scyllo,dfCER$Tau,dfCER$GSH,dfCER$tNAA,dfCER$Asp,dfCER$Gln,dfCER$Glu,dfCER$Glx)
dfSummary[,7] <-c(rep(c('tCho'),31),rep(c('Ins'),31),rep(c('Scyllo'),31),rep(c('Tau'),31),rep(c('GSH'),31),rep(c('tNAA'),31),rep(c('Asp'),31),rep(c('Gln'),31),rep(c('Glu'),31),rep(c('Glx'),31))
dfSummary[,8] <-c(rep(dfCER$Group,10))

colorBar <- c(color[1],color[2])
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,2.2)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
   scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr', '/CER_OFF_Cr_Bar1.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,0.5)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr', '/CER_OFF_Cr_Bar2.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g

bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,1)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr', '/CER_OFF_Cr_Bar3.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g

bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,.1)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr', '/CER_OFF_Cr_Bar4.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g


#Load OFF THA dataframes

listTHA <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/THA/LCMOutput_A_sep')
dfTHA <- listTHA[[1]]
dfTHACRLB <- listTHA[[2]]
CRLB_sum <- summary(dfTHACRLB)
max_crlbs <- dfTHACRLB == 999
dfTHACRLB <- dfTHA * dfTHACRLB/100
dfTHACRLB <- 1/dfTHACRLB
dfTHACRLB[max_crlbs] = 1/999
colnames(dfTHACRLB) <- paste(colnames(dfTHACRLB),'CRLB',sep='_')
dfTHA <- spvs_AddStatsToDataframe(dfTHA,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfTHA <- bind_cols(dfTHA,dfTHACRLB)

#Remove outlier
#dfTHACRLB <- spvs_AddStatsToDataframe(dfTHACRLB,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfTHA <- dfTHA[-c(28,34,35,36,37),]

#dfTHACon <- subset(dfTHACRLB, numGroup == 1)
#dfTHAmHE <- subset(dfTHACRLB, numGroup == 2)
#dfTHAHE <- subset(dfTHACRLB, numGroup == 3)
#dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAmHE,dfTHAHE),c('A-con','B-mHE','C-HE'))

#dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAHE),c('A-con','C-HE'))

#statsTHA <- spvs_Statistics(dfTHA,list('tCho','Ins','Scyllo','Tau','GSH','tNAA','Asp','Gln','Glu','Glx','tCr'),0)
#sink('/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_Cr/THA_stat_CRLB.txt')
#print(statsTHA)
#sink()

#Sort THAebella differnce spectra data
dfTHACon <- subset(dfTHA, numGroup == 1)
dfTHAmHE <- subset(dfTHA, numGroup == 2)
dfTHAHE <- subset(dfTHA, numGroup == 3)
dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAmHE,dfTHAHE),c('A-con','B-mHE','C-HE'))

dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAHE),c('A-con','C-HE'))

pTHA <- spvs_RainCloud(dfTHA, '/ [tCr]',list('Ins','Scyllo','Tau','tCho'),c('Group'),lowerLiInst,upperLiInstOsmo,c(""),2,2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_Cr/THA_Off_Cr_OSMO_Vio.pdf", pTHA, width = 10, height = 20,device=cairo_pdf) #saves g
pTHA

pTHA <- spvs_RainCloud(dfTHA, '/ [tCr]',list('Asp','Gln','Glu'),c('Group'),lowerLiNeuro,upperLiInstNeuro,c(""),2,2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_Cr/THA_Off_Cr_NEURO_Vio.pdf", pTHA, width = 10, height = 20,device=cairo_pdf) #saves g
pTHA

pTHA <- spvs_RainCloud(dfTHA, '/ [tCr]',list('GSH','tNAA'),c('Group'),lowerLiInstAnti,upperLiInstAnti,c(""),2,2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_Cr/THA_Off_Cr_ANTI_Vio.pdf", pTHA, width = 10, height = 20,device=cairo_pdf) #saves g
pTHA

THA_off_cr_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_Cr/THA_lm.txt')
THA_off_cr_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_Cr/THA_lm_age.txt','age')
THA_off_cr_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_Cr/THA_lm_CRLB.txt',weighting=invCRLBlist)
THA_off_cr_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_Cr/THA_lm_age_CRLB.txt','age',invCRLBlist)


statsTHA <- spvs_Statistics(dfTHA,list('tCho','Ins','Scyllo','Tau','GSH','tNAA','Asp','Gln','Glu','Glx'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_Cr/THA_stat_all.txt')
print(statsTHA)
sink()

dfSummary <- data.frame(matrix(ncol = 8, nrow = 310))
#provide column names
colnames(dfSummary) <- c('mean','SD','Group','shift','metabolites','indiv_metabs_value','indiv_metabs_names','indiv_metabs_groups')
dfSummary[1:20,1] <- data_frame(statsTHA$`Descriptive Statistics`$mean)
dfSummary[1:20,2] <- data_frame(statsTHA$`Descriptive Statistics`$sd)
dfSummary[1:20,3] <- data_frame((rep(c('A-con','C-HE'), 10)))
dfSummary[1:20,4] <-data_frame(1:20)
dfSummary[1:20,5] <-c('tCho','tCho','Ins','Ins','Scyllo','Scyllo','Tau','Tau','GSH','GSH','tNAA','tNAA','Asp','Asp','Gln','Gln','Glu','Glu','Glx','Glx')
dfSummary[,6] <-c(dfTHA$tCho,dfTHA$Ins,dfTHA$Scyllo,dfTHA$Tau,dfTHA$GSH,dfTHA$tNAA,dfTHA$Asp,dfTHA$Gln,dfTHA$Glu,dfTHA$Glx)
dfSummary[,7] <-c(rep(c('tCho'),31),rep(c('Ins'),31),rep(c('Scyllo'),31),rep(c('Tau'),31),rep(c('GSH'),31),rep(c('tNAA'),31),rep(c('Asp'),31),rep(c('Gln'),31),rep(c('Glu'),31),rep(c('Glx'),31))
dfSummary[,8] <-c(rep(dfTHA$Group,10))

colorBar <- c(color[1],color[2])
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,2.2)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_Cr', '/THA_OFF_Cr_Bar1.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,0.5)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_Cr', '/THA_OFF_Cr_Bar2.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,1)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_Cr', '/THA_OFF_Cr_Bar3.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,0.1)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_Cr', '/THA_OFF_Cr_Bar4.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g


#Load OFF MOT dataframes
listMOT <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/MOT/LCMOutput_A_sep')
dfMOT <- listMOT[[1]]
dfMOTCRLB <- listMOT[[2]]
CRLB_sum <- summary(dfMOTCRLB)
max_crlbs <- dfMOTCRLB == 999
dfMOTCRLB <- dfMOT * dfMOTCRLB/100
dfMOTCRLB <- 1/dfMOTCRLB
dfMOTCRLB[max_crlbs] = 1/999
colnames(dfMOTCRLB) <- paste(colnames(dfMOTCRLB),'CRLB',sep='_')
dfMOT <- spvs_AddStatsToDataframe(dfMOT,'/Volumes/Elements/working/GABA_HE/statMOT.csv')
dfMOT <- bind_cols(dfMOT,dfMOTCRLB)

#Remove outlier
dfMOT <- dfMOT[-c(2,13,18,33,34,35,36,37),]

dfMOTCRLB <- spvs_AddStatsToDataframe(dfMOTCRLB,'/Volumes/Elements/working/GABA_HE/statMOT.csv')
dfMOTCRLB <- dfMOTCRLB[-c(2,13,18,33,34,35,36,37),]
dfMOTCon <- subset(dfMOTCRLB, numGroup == 1)
dfMOTmHE <- subset(dfMOTCRLB, numGroup == 2)
dfMOTHE <- subset(dfMOTCRLB, numGroup == 3)
dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTmHE,dfMOTHE),c('A-con','B-mHE','C-HE'))
dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTHE),c('A-con','C-HE'))
statsMOT <- spvs_Statistics(dfMOT,list('tCho','Ins','Scyllo','Tau','GSH','tNAA','Asp','Gln','Glu','Glx','tCr'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_Cr/MOT_stat_CRLB.txt')
print(statsMOT)
sink()


#Sort MOT differnce spectra data
dfMOTCon <- subset(dfMOT, numGroup == 1)
dfMOTmHE <- subset(dfMOT, numGroup == 2)
dfMOTHE <- subset(dfMOT, numGroup == 3)
dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTmHE,dfMOTHE),c('A-con','B-mHE','C-HE'))
dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTHE),c('A-con','C-HE'))


pMOT <- spvs_RainCloud(dfMOT, '/ [tCr]',list('Ins','Scyllo','Tau','tCho'),c('Group'),lowerLiInst,upperLiInstOsmo,c(""),2,2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_Cr/MOT_Off_Cr_OSMO_Vio.pdf", pMOT, width = 10, height = 20,device=cairo_pdf) #saves g
pMOT

pMOT <- spvs_RainCloud(dfMOT, '/ [tCr]',list('Asp','Gln','Glu'),c('Group'),lowerLiNeuro,upperLiInstNeuro,c(""),2,2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_Cr/MOT_Off_Cr_NEURO_Vio.pdf", pMOT, width = 10, height = 20,device=cairo_pdf) #saves g
pMOT

pMOT <- spvs_RainCloud(dfMOT, '/ [tCr]',list('GSH','tNAA'),c('Group'),lowerLiInstAnti,upperLiInstAnti,c(""),2,2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_Cr/MOT_Off_Cr_ANTI_Vio.pdf", pMOT, width = 10, height = 20,device=cairo_pdf) #saves g
pMOT

MOT_off_cr_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_Cr/MOT_lm.txt')
MOT_off_cr_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_Cr/MOT_lm_age.txt','age')
MOT_off_cr_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_Cr/MOT_lm_CRLB.txt',weighting=invCRLBlist)
MOT_off_cr_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_Cr/MOT_lm_age_CRLB.txt','age',invCRLBlist)


statsMOT <- spvs_Statistics(dfMOT,list('tCho','Ins','Scyllo','Tau','GSH','tNAA','Asp','Gln','Glu','Glx'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_Cr/MOT_stat_all.txt')
print(statsMOT)
sink()

dfSummary <- data.frame(matrix(ncol = 8, nrow = 270))
#provide column names
colnames(dfSummary) <- c('mean','SD','Group','shift','metabolites','indiv_metabs_value','indiv_metabs_names','indiv_metabs_groups')
dfSummary[1:20,1] <- data_frame(statsMOT$`Descriptive Statistics`$mean)
dfSummary[1:20,2] <- data_frame(statsMOT$`Descriptive Statistics`$sd)
dfSummary[1:20,3] <- data_frame((rep(c('A-con','C-HE'), 10)))
dfSummary[1:20,4] <-data_frame(1:20)
dfSummary[1:20,5] <-c('tCho','tCho','Ins','Ins','Scyllo','Scyllo','Tau','Tau','GSH','GSH','tNAA','tNAA','Asp','Asp','Gln','Gln','Glu','Glu','Glx','Glx')
dfSummary[,6] <-c(dfMOT$tCho,dfMOT$Ins,dfMOT$Scyllo,dfMOT$Tau,dfMOT$GSH,dfMOT$tNAA,dfMOT$Asp,dfMOT$Gln,dfMOT$Glu,dfMOT$Glx)
dfSummary[,7] <-c(rep(c('tCho'),27),rep(c('Ins'),27),rep(c('Scyllo'),27),rep(c('Tau'),27),rep(c('GSH'),27),rep(c('tNAA'),27),rep(c('Asp'),27),rep(c('Gln'),27),rep(c('Glu'),27),rep(c('Glx'),27))
dfSummary[,8] <-c(rep(dfMOT$Group,10))

colorBar <- c(color[1],color[2])
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,2.2)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_Cr', '/MOT_OFF_Cr_Bar1.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,0.5)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_Cr', '/MOT_OFF_Cr_Bar2.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,1)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_Cr', '/MOT_OFF_Cr_Bar3.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,.1)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_Cr', '/MOT_OFF_Cr_Bar4.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g

#Correlation plots CER
listCER <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/CER/LCMOutput_A_sep')
dfCER <- listCER[[1]]
dfCERCRLB <- listCER[[2]]
max_crlbs <- dfCERCRLB == 999
CRLB_sum <- summary(dfCERCRLB)
dfCERCRLB <- dfCER * dfCERCRLB/100
dfCERCRLB <- 1/dfCERCRLB
dfCERCRLB[max_crlbs] = 1/999
colnames(dfCERCRLB) <- paste(colnames(dfCERCRLB),'CRLB',sep='_')
dfCER <- spvs_AddStatsToDataframe(dfCER,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfCER$ammonia <- dfClinicAll$ammonia
dfCER$GOT <- dfClinicAll$GOT
dfCER <- bind_cols(dfCER,dfCERCRLB)
#Remove outlier
# dfCER <- dfCER[-c(1,4,6,11,13,17,20,35,36,37,38),]
dfCER <- dfCER[-c(15,34,35,36,37),]

dfCERCon <- subset(dfCER, numGroup == 1)
dfCERmHE <- subset(dfCER, numGroup == 2)
dfCERHE <- subset(dfCER, numGroup == 3)
dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERmHE,dfCERHE),c('A-con','B-mHE','C-HE'))
dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERHE),c('A-con','C-HE'))
lowerLiInst <- c(30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075)
upperLiInst <- c(45,1.5,45,0.4,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175)
pCERCrCorr <- spvs_Correlation(list(dfCERCon,dfCERmHE,dfCERHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr/CFFvsCERCr.pdf", pCERCrCorr, width = 5, height = 20,device=cairo_pdf) #saves g
pCERCrCorr

pCERCrCorrPEG <- spvs_Correlation(list(dfCERCon,dfCERmHE,dfCERHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr/PEGvsCERCr.pdf", pCERCrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorrPEG

pCERCrCorrNH3 <- spvs_Correlation(list(dfCERCon,dfCERmHE,dfCERHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr/NH3vsCERCr.pdf", pCERCrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorrNH3

pCERCrCorrGOT <- spvs_Correlation(list(dfCERCon,dfCERmHE,dfCERHE),"",c("GOT","Asp",'GOT','tCho','GOT','GSH','GOT','Glu','GOT','Gln','GOT','Ins','GOT','tNAA'),c("GOT","Asp",'GOT','tCho','GOT','GSH','GOT','Glu','GOT','Gln','GOT','Ins','GOT','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr/GOTvsCERCr.pdf", pCERCrCorrGOT, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorrGOT

pCERCrCorr <- spvs_Correlation(list(dfCERCon,dfCERHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr/CFFvsCERCr_nomHE.pdf", pCERCrCorr, width = 5, height = 20,device=cairo_pdf) #saves g
pCERCrCorr

pCERCrCorrPEG <- spvs_Correlation(list(dfCERCon,dfCERHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr/PEGvsCERCr_nomHE.pdf", pCERCrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorrPEG

pCERCrCorrNH3 <- spvs_Correlation(list(dfCERCon,dfCERHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr/NH3vsCERCr_nomHE.pdf", pCERCrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorrNH3

pCERCrCorrGOT <- spvs_Correlation(list(dfCERCon,dfCERHE),"",c("GOT","Asp",'GOT','tCho','GOT','GSH','GOT','Glu','GOT','Gln','GOT','Ins','GOT','tNAA'),c("GOT","Asp",'GOT','tCho','GOT','GSH','GOT','Glu','GOT','Gln','GOT','Ins','GOT','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_Cr/GOTvsCERCr_nomHE.pdf", pCERCrCorrGOT, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorrGOT

CER_off_cr_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/CER_CFF_lm.txt')
CER_off_cr_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/CER_CFF_lm_age.txt','age')
CER_off_cr_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/CER_CFF_lm_CRLB.txt',weighting=invCRLBlist)
CER_off_cr_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/CER_CFF_lm_age_CRLB.txt','age',invCRLBlist)

CER_off_cr_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/CER_PEG_lm.txt')
CER_off_cr_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/CER_PEG_lm_age.txt','age')
CER_off_cr_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/CER_PEG_lm_CRLB.txt',weighting=invCRLBlist)
CER_off_cr_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/CER_PEG_lm_age_CRLB.txt','age',invCRLBlist)

CER_off_cr_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/CER_ammonia_lm.txt')
CER_off_cr_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/CER_ammonia_lm_age.txt','age')
CER_off_cr_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/CER_ammonia_lm_CRLB.txt',weighting=invCRLBlist)
CER_off_cr_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/CER_ammonia_lm_age_CRLB.txt','age',invCRLBlist)


#Correlation plots GABA THA

listTHA <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/THA/LCMOutput_A_sep')
dfTHA <- listTHA[[1]]
dfTHACRLB <- listTHA[[2]]
CRLB_sum <- summary(dfTHACRLB)
max_crlbs <- dfTHACRLB == 999
dfTHACRLB <- dfTHA * dfTHACRLB/100
dfTHACRLB <- 1/dfTHACRLB
dfTHACRLB[max_crlbs] = 1/999
colnames(dfTHACRLB) <- paste(colnames(dfTHACRLB),'CRLB',sep='_')
dfTHA <- spvs_AddStatsToDataframe(dfTHA,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfTHA$ammonia <- dfClinicAll$ammonia
dfTHA <- bind_cols(dfTHA,dfTHACRLB)

#Remove outlier
# dfTHA <- dfTHA[-c(1,2,12,21),]
dfTHA <- dfTHA[-c(28,34,35,36,37),]

dfTHACon <- subset(dfTHA, numGroup == 1)
dfTHAmHE <- subset(dfTHA, numGroup == 2)
dfTHAHE <- subset(dfTHA, numGroup == 3)
dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAmHE,dfTHAHE),c('A-con','B-mHE','C-HE'))

lowerLiInst <- c(30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.4,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175)
pTHACrCorr <- spvs_Correlation(list(dfTHACon,dfTHAmHE,dfTHAHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_Cr/CFFvsTHACr.pdf", pTHACrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pTHACrCorr

pTHACrCorrPEG <- spvs_Correlation(list(dfTHACon,dfTHAmHE,dfTHAHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_Cr/PEGvsTHACr.pdf", pTHACrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pTHACrCorrPEG


pTHACrCorrNH3 <- spvs_Correlation(list(dfTHACon,dfTHAmHE,dfTHAHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_Cr/NH3vsTHACr.pdf", pTHACrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pTHACrCorrNH3

THA_off_cr_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/THA_CFF_lm.txt')
THA_off_cr_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/THA_CFF_lm_age.txt','age')
THA_off_cr_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/THA_CFF_lm_CRLB.txt',weighting=invCRLBlist)
THA_off_cr_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/THA_CFF_lm_age_CRLB.txt','age',invCRLBlist)

THA_off_cr_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/THA_PEG_lm.txt')
THA_off_cr_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/THA_PEG_lm_age.txt','age')
THA_off_cr_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/THA_PEG_lm_CRLB.txt',weighting=invCRLBlist)
THA_off_cr_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/THA_PEG_lm_age_CRLB.txt','age',invCRLBlist)

THA_off_cr_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/THA_ammonia_lm.txt')
THA_off_cr_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/THA_ammonia_lm_age.txt','age')
THA_off_cr_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/THA_ammonia_lm_CRLB.txt',weighting=invCRLBlist)
THA_off_cr_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/THA_ammonia_lm_age_CRLB.txt','age',invCRLBlist)


#Correlation plots GABA MOT
listMOT <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/MOT/LCMOutput_A_sep')
dfMOT <- listMOT[[1]]
dfMOTCRLB <- listMOT[[2]]
CRLB_sum <- summary(dfMOTCRLB)
max_crlbs <- dfMOTCRLB == 999
dfMOTCRLB <- dfMOT * dfMOTCRLB/100
dfMOTCRLB <- 1/dfMOTCRLB
dfMOTCRLB[max_crlbs] = 1/999
colnames(dfMOTCRLB) <- paste(colnames(dfMOTCRLB),'CRLB',sep='_')
dfMOT <- spvs_AddStatsToDataframe(dfMOT,'/Volumes/Elements/working/GABA_HE/statMOT.csv')
dfClinicAllred <- dfClinicAll[-c(21,32),]
dfMOT$ammonia <- dfClinicAllred$ammonia
dfMOT <- bind_cols(dfMOT,dfMOTCRLB)

#Remove outlier
# dfMOT <- dfMOT[-c(2,4,5,9,12,14,15,19,20,32),]
# dfMOT <- dfMOT[-c(2,4,5,9,12,13,14,15,19,20,32),]
#dfMOT <- dfMOT[-c(2,13,18,33,34,35,36,37),]
dfMOT <- dfMOT[-c(2,4,14,19,33,34,35,36,37),]

dfMOTCon <- subset(dfMOT, numGroup == 1)
dfMOTmHE <- subset(dfMOT, numGroup == 2)
dfMOTHE <- subset(dfMOT, numGroup == 3)
dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTmHE,dfMOTHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.4,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175)
pMOTCrCorr <- spvs_Correlation(list(dfMOTCon,dfMOTmHE,dfMOTHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_Cr/CFFvsMOTCr.pdf", pMOTCrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorr

pMOTCrCorrPEG <- spvs_Correlation(list(dfMOTCon,dfMOTmHE,dfMOTHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_Cr/PEGvsMOTCr.pdf", pMOTCrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorrPEG

pMOTCrCorrNH3 <- spvs_Correlation(list(dfMOTCon,dfMOTmHE,dfMOTHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_Cr/NH3vsMOTCr.pdf", pMOTCrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorrNH3

pMOTCrCorr <- spvs_Correlation(list(dfMOTCon,dfMOTHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_Cr/CFFvsMOTCr_nomHE.pdf", pMOTCrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorr

pMOTCrCorrPEG <- spvs_Correlation(list(dfMOTCon,dfMOTHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_Cr/PEGvsMOTCr_nomHE.pdf", pMOTCrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorrPEG


pMOTCrCorrNH3 <- spvs_Correlation(list(dfMOTCon,dfMOTHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_Cr/NH3vsMOTCr_nomHE.pdf", pMOTCrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorrNH3

MOT_off_cr_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/MOT_CFF_lm.txt')
MOT_off_cr_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/MOT_CFF_lm_age.txt','age')
MOT_off_cr_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/MOT_CFF_lm_CRLB.txt',weighting=invCRLBlist)
MOT_off_cr_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/MOT_CFF_lm_age_CRLB.txt','age',invCRLBlist)

MOT_off_cr_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/MOT_PEG_lm.txt')
MOT_off_cr_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/MOT_PEG_lm_age.txt','age')
MOT_off_cr_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/MOT_PEG_lm_CRLB.txt',weighting=invCRLBlist)
MOT_off_cr_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/MOT_PEG_lm_age_CRLB.txt','age',invCRLBlist)

MOT_off_cr_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/MOT_ammonia_lm.txt')
MOT_off_cr_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/MOT_ammonia_lm_age.txt','age')
MOT_off_cr_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/MOT_ammonia_lm_CRLB.txt',weighting=invCRLBlist)
MOT_off_cr_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/MOT_ammonia_lm_age_CRLB.txt','age',invCRLBlist)


## Here starts i.u.

#Load OFF CER dataframes
listCER <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/CER/LCMOutput_A_sep','water')
dfCER <- listCER[[1]]
dfCERCRLB <- listCER[[2]]
CRLB_sum <- summary(dfCERCRLB)
max_crlbs <- dfCERCRLB == 999
dfCER <- spvs_AddStatsToDataframe(dfCER,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfCERdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetCER.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfCER$WM <- dfCERdiff$WM
dfCER$GM <- dfCERdiff$GM
dfCER$CSF <- dfCERdiff$CSF
dfCER$ammonia <- dfClinicAll$ammonia
dfCER <- spvs_TissueCorr(dfCER,.068,1.750,.068,1.750)
for (i in colnames(dfCERCRLB)){
  if (i %in% colnames(dfCER)){
    dfCERCRLB[[i]] <- dfCER[[i]] * dfCERCRLB[[i]]/100}
}
dfCERCRLB <- 1/dfCERCRLB
dfCERCRLB[max_crlbs] = 1/999
colnames(dfCERCRLB) <- paste(colnames(dfCERCRLB),'CRLB',sep='_')
dfCER <- bind_cols(dfCER,dfCERCRLB)
#Remove outlier
#dfCER <- dfCER[-c(4,6,17,18,20,32,35,37,38),]
dfCER <- dfCER[-c(34,35,36,37),]
#dfCER <- dfCER[-c(6,17,32,34,35,36,37),]

#Sort cerebella differnce spectra data
dfCERCon <- subset(dfCER, numGroup == 1)
dfCERmHE <- subset(dfCER, numGroup == 2)
dfCERHE <- subset(dfCER, numGroup == 3)
dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERmHE,dfCERHE),c('A-con','B-mHE','C-HE'))

dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERHE),c('A-con','C-HE'))
lowerLiInstOsmo <- c(0,0,0,0)
upperLiInstOsmo <- c(5,10,1.2,15)
pCER <- spvs_RainCloud(dfCER, '/ [tCr]',list('Ins','Scyllo','Tau','tCho'),c('Group'),lowerLiInstOsmo,upperLiInstOsmo,c(""),2,2)
pCER
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_iu/CER_Off_iu_OSMO_Vio.pdf", pCER, width = 10, height = 20,device=cairo_pdf) #saves g

lowerLiInstNeuro <- c(0,0,0)
upperLiInstNeuro <- c(35,35,17.5)
pCER <- spvs_RainCloud(dfCER, '/ [tCr]',list('Asp','Gln','Glu'),c('Group'),lowerLiInstNeuro,upperLiInstNeuro,c(""),2,2)
pCER
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_iu/CER_Off_iu_NEURO_Vio.pdf", pCER, width = 10, height = 20,device=cairo_pdf) #saves g

lowerLiInstAnti <- c(10,10,0)
upperLiInstAnti <- c(20,22,7.5)
pCER <- spvs_RainCloud(dfCER, '/ [tCr]',list('GSH','tCr','tNAA'),c('Group'),lowerLiInstAnti,upperLiInstAnti,c(""),2,2)
pCER
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_iu/CER_Off_iu_ANTI_Vio.pdf", pCER, width = 10, height = 20,device=cairo_pdf) #saves g



dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERHE),c('A-con','C-HE'))

CER_off_iu_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_iu/CER_iu_lm.txt')
CER_off_iu_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_iu/CER_iu_lm_age.txt','age')
CER_off_iu_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_iu/CER_iu_lm_CRLB.txt',weighting=invCRLBlist)
CER_off_iu_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_iu/CER_iu_lm_age_CRLB.txt','age',invCRLBlist)


statsCER <- spvs_Statistics(dfCER,list('tCho','Ins','Scyllo','Tau','GSH','tNAA','Asp','Gln','Glu','Glx','tCr'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_iu/CER_stat_all_iu.txt')
print(statsCER)
sink()

dfSummary <- data.frame(matrix(ncol = 8, nrow = 352))
#provide column names
colnames(dfSummary) <- c('mean','SD','Group','shift','metabolites','indiv_metabs_value','indiv_metabs_names','indiv_metabs_groups')
dfSummary[1:22,1] <- data_frame(statsCER$`Descriptive Statistics`$mean)
dfSummary[1:22,2] <- data_frame(statsCER$`Descriptive Statistics`$sd)
dfSummary[1:22,3] <- data_frame((rep(c('A-con','C-HE'), 11)))
dfSummary[1:22,4] <-data_frame(1:22)
dfSummary[1:22,5] <-c('tCho','tCho','Ins','Ins','Scyllo','Scyllo','Tau','Tau','GSH','GSH','tNAA','tNAA','Asp','Asp','Gln','Gln','Glu','Glu','Glx','Glx','tCr','tCr')
dfSummary[,6] <-c(dfCER$tCho,dfCER$Ins,dfCER$Scyllo,dfCER$Tau,dfCER$GSH,dfCER$tNAA,dfCER$Asp,dfCER$Gln,dfCER$Glu,dfCER$Glx,dfCER$tCr)
dfSummary[,7] <-c(rep(c('tCho'),32),rep(c('Ins'),32),rep(c('Scyllo'),32),rep(c('Tau'),32),rep(c('GSH'),32),rep(c('tNAA'),32),rep(c('Asp'),32),rep(c('Gln'),32),rep(c('Glu'),32),rep(c('Glx'),32),rep(c('tCr'),32))
dfSummary[,8] <-c(rep(dfCER$Group,11))

colorBar <- c(color[1],color[2])
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,40)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_iu', '/CER_OFF_iu_Bar1.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,7.5)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_iu', '/CER_OFF_iu_Bar2.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g

bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,20)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_iu', '/CER_OFF_iu_Bar3.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g

bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(-.2,1)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_iu', '/CER_OFF_iu_Bar4.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g



#Load OFF THA dataframes
listTHA <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/THA/LCMOutput_A_sep','water')
dfTHA <- listTHA[[1]]
dfTHACRLB <- listTHA[[2]]
CRLB_sum <- summary(dfTHACRLB)
max_crlbs <- dfTHACRLB == 999
colnames(dfTHACRLB) <- paste(colnames(dfTHACRLB),'CRLB',sep='_')
dfTHA <- spvs_AddStatsToDataframe(dfTHA,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfTHAdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetTHA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfTHA$WM <- dfTHAdiff$WM
dfTHA$GM <- dfTHAdiff$GM
dfTHA$CSF <- dfTHAdiff$CSF
dfTHA$ammonia <- dfClinicAll$ammonia
dfTHA <- spvs_TissueCorr(dfTHA,.068,1.750,.068,1.750)
for (i in colnames(dfTHACRLB)){
  if (i %in% colnames(dfTHA)){
    dfTHACRLB[[i]] <- dfTHA[[i]] * dfTHACRLB[[i]]/100}
}
dfTHACRLB <- 1/dfTHACRLB
dfTHACRLB[max_crlbs] = 1/999
dfTHA <- bind_cols(dfTHA,dfTHACRLB)
#Remove outlier
# dfTHA <- dfTHA[-c(1,2,12,21),]
dfTHA <- dfTHA[-c(2,28,34,35,36,37),]

#Sort THAebella differnce spectra data
dfTHACon <- subset(dfTHA, numGroup == 1)
dfTHAmHE <- subset(dfTHA, numGroup == 2)
dfTHAHE <- subset(dfTHA, numGroup == 3)
dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAmHE,dfTHAHE),c('A-con','B-mHE','C-HE'))

dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAHE),c('A-con','C-HE'))

pTHA <- spvs_RainCloud(dfTHA, '/ [tCr]',list('Ins','Scyllo','Tau','tCho'),c('Group'),lowerLiInstOsmo,upperLiInstOsmo,c(""),2,2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_iu/THA_Off_iu_OSMO_Vio.pdf", pTHA, width = 10, height = 20,device=cairo_pdf) #saves g
pTHA

pTHA <- spvs_RainCloud(dfTHA, '/ [tCr]',list('Asp','Gln','Glu'),c('Group'),lowerLiInstNeuro,upperLiInstNeuro,c(""),2,2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_iu/THA_Off_iu_NEURO_Vio.pdf", pTHA, width = 10, height = 20,device=cairo_pdf) #saves g
pTHA

pTHA <- spvs_RainCloud(dfTHA, '/ [tCr]',list('GSH','tCr','tNAA'),c('Group'),lowerLiInstAnti,upperLiInstAnti,c(""),2,2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_iu/THA_Off_iu_ANTI_Vio.pdf", pTHA, width = 10, height = 20,device=cairo_pdf) #saves g
pTHA

THA_off_iu_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_iu/THA_iu_lm.txt')
THA_off_iu_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_iu/THA_iu_lm_age.txt','age')
THA_off_iu_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_iu/THA_iu_lm_CRLB.txt',weighting=invCRLBlist)
THA_off_iu_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_iu/THA_iu_lm_age_CRLB.txt','age',invCRLBlist)


statsTHA <- spvs_Statistics(dfTHA,list('tCho','Ins','Scyllo','Tau','GSH','tNAA','Asp','Gln','Glu','Glx','tCr'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_iu/THA_stat_all_iu.txt')
print(statsTHA)
sink()

dfSummary <- data.frame(matrix(ncol = 8, nrow = 330))
#provide column names
colnames(dfSummary) <- c('mean','SD','Group','shift','metabolites','indiv_metabs_value','indiv_metabs_names','indiv_metabs_groups')
dfSummary[1:22,1] <- data_frame(statsTHA$`Descriptive Statistics`$mean)
dfSummary[1:22,2] <- data_frame(statsTHA$`Descriptive Statistics`$sd)
dfSummary[1:22,3] <- data_frame((rep(c('A-con','C-HE'), 11)))
dfSummary[1:22,4] <-data_frame(1:22)
dfSummary[1:22,5] <-c('tCho','tCho','Ins','Ins','Scyllo','Scyllo','Tau','Tau','GSH','GSH','tNAA','tNAA','Asp','Asp','Gln','Gln','Glu','Glu','Glx','Glx','tCr','tCr')
dfSummary[,6] <-c(dfTHA$tCho,dfTHA$Ins,dfTHA$Scyllo,dfTHA$Tau,dfTHA$GSH,dfTHA$tNAA,dfTHA$Asp,dfTHA$Gln,dfTHA$Glu,dfTHA$Glx,dfTHA$tCr)
dfSummary[,7] <-c(rep(c('tCho'),30),rep(c('Ins'),30),rep(c('Scyllo'),30),rep(c('Tau'),30),rep(c('GSH'),30),rep(c('tNAA'),30),rep(c('Asp'),30),rep(c('Gln'),30),rep(c('Glu'),30),rep(c('Glx'),30),rep(c('tCr'),30))
dfSummary[,8] <-c(rep(dfTHA$Group,11))

colorBar <- c(color[1],color[2])
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,40)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_iu', '/THA_OFF_iu_Bar1.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,7.5)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_iu', '/THA_OFF_iu_Bar2.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g

bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,20)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_iu', '/THA_OFF_iu_Bar3.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g

bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(-0.2,1)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_iu', '/THA_OFF_iu_Bar4.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g

#Load OFF MOT dataframes
listMOT <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/MOT/LCMOutput_A_sep','water')
dfMOT <- listMOT[[1]]
dfMOTCRLB <- listMOT[[2]]
CRLB_sum <- summary(dfMOTCRLB)
max_crlbs <- dfMOTCRLB == 999
dfMOT <- spvs_AddStatsToDataframe(dfMOT,'/Volumes/Elements/working/GABA_HE/statMOT.csv')
dfMOTdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetMOT.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfMOT$WM <- dfMOTdiff$WM
dfMOT$GM <- dfMOTdiff$GM
dfMOT$CSF <- dfMOTdiff$CSF
dfMOT <- spvs_TissueCorr(dfMOT,.068,1.750,.068,1.750)
for (i in colnames(dfMOTCRLB)){
  if (i %in% colnames(dfMOT)){
    dfMOTCRLB[[i]] <- dfMOT[[i]] * dfMOTCRLB[[i]]/100}
}
dfMOTCRLB <- 1/dfMOTCRLB
dfMOTCRLB[max_crlbs] = 1/999
colnames(dfMOTCRLB) <- paste(colnames(dfMOTCRLB),'CRLB',sep='_')
dfMOT <- bind_cols(dfMOT,dfMOTCRLB)
#Remove outlier
# dfMOT <- dfMOT[-c(2,4,5,9,12,14,15,19,20,32),]
# dfMOT <- dfMOT[-c(2,4,5,9,12,13,14,15,19,20,32),]
dfMOT <- dfMOT[-c(2,4,14,19,33,34,35,36,37),]

#Sort MOT differnce spectra data
dfMOTCon <- subset(dfMOT, numGroup == 1)
dfMOTmHE <- subset(dfMOT, numGroup == 2)
dfMOTHE <- subset(dfMOT, numGroup == 3)
dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTmHE,dfMOTHE),c('A-con','B-mHE','C-HE'))
dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTHE),c('A-con','C-HE'))


pMOT <- spvs_RainCloud(dfMOT, '/ [tCr]',list('Ins','Scyllo','Tau','tCho'),c('Group'),lowerLiInstOsmo,upperLiInstOsmo,c(""),2,2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_iu/MOT_Off_iu_OSMO_Vio.pdf", pMOT, width = 10, height = 20,device=cairo_pdf) #saves g
pMOT

pMOT <- spvs_RainCloud(dfMOT, '/ [tCr]',list('Asp','Gln','Glu'),c('Group'),lowerLiInstNeuro,upperLiInstNeuro,c(""),2,2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_iu/MOT_Off_iu_NEURO_Vio.pdf", pMOT, width = 10, height = 20,device=cairo_pdf) #saves g
pMOT

pMOT <- spvs_RainCloud(dfMOT, '/ [tCr]',list('GSH','tCr','tNAA'),c('Group'),lowerLiInstAnti,upperLiInstAnti,c(""),2,2)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_iu/MOT_Off_iu_ANTI_Vio.pdf", pMOT, width = 10, height = 20,device=cairo_pdf) #saves g
pMOT


MOT_off_iu_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_iu/MOT_iu_lm.txt')
MOT_off_iu_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_iu/MOT_iu_lm_age.txt','age')
MOT_off_iu_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_iu/MOT_iu_lm_CRLB.txt',weighting=invCRLBlist)
MOT_off_iu_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_iu/MOT_iu_lm_age_CRLB.txt','age',invCRLBlist)


statsMOT <- spvs_Statistics(dfMOT,list('tCho','Ins','Scyllo','Tau','GSH','tNAA','Asp','Gln','Glu','Glx','tCr'),0)
sink('/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_iu/MOT_stat_all_iu.txt')
print(statsMOT)
sink()


dfSummary <- data.frame(matrix(ncol = 8, nrow = 286))
#provide column names
colnames(dfSummary) <- c('mean','SD','Group','shift','metabolites','indiv_metabs_value','indiv_metabs_names','indiv_metabs_groups')
dfSummary[1:22,1] <- data_frame(statsMOT$`Descriptive Statistics`$mean)
dfSummary[1:22,2] <- data_frame(statsMOT$`Descriptive Statistics`$sd)
dfSummary[1:22,3] <- data_frame((rep(c('A-con','C-HE'), 11)))
dfSummary[1:22,4] <-data_frame(1:22)
dfSummary[1:22,5] <-c('tCho','tCho','Ins','Ins','Scyllo','Scyllo','Tau','Tau','GSH','GSH','tNAA','tNAA','Asp','Asp','Gln','Gln','Glu','Glu','Glx','Glx','tCr','tCr')
dfSummary[,6] <-c(dfMOT$tCho,dfMOT$Ins,dfMOT$Scyllo,dfMOT$Tau,dfMOT$GSH,dfMOT$tNAA,dfMOT$Asp,dfMOT$Gln,dfMOT$Glu,dfMOT$Glx,dfMOT$tCr)
dfSummary[,7] <-c(rep(c('tCho'),26),rep(c('Ins'),26),rep(c('Scyllo'),26),rep(c('Tau'),26),rep(c('GSH'),26),rep(c('tNAA'),26),rep(c('Asp'),26),rep(c('Gln'),26),rep(c('Glu'),26),rep(c('Glx'),26),rep(c('tCr'),26))
dfSummary[,8] <-c(rep(dfMOT$Group,11))

colorBar <- c(color[1],color[2])
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,40)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_iu', '/MOT_OFF_iu_Bar1.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g
bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,7.5)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_iu', '/MOT_OFF_iu_Bar2.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g

bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(0,20)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_iu', '/MOT_OFF_iu_Bar3.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g

bar <- ggplot(dfSummary) +
  geom_linerange( aes(x=metabolites, ymin=mean-SD, ymax=mean+SD,color=Group), position = position_dodge2(width =0.5), size=1)+
  geom_col( aes(x=metabolites, y=mean,color=Group,fill=Group), position = "dodge", width = 0.5)+theme_cowplot()+ ylim(-.2,1)+
  geom_point(aes(x=indiv_metabs_names, y=indiv_metabs_value,fill=indiv_metabs_groups,), position = position_jitterdodge(jitter.width =0,dodge.width =0.8), size=0.75,color='black')+
  scale_color_manual(values = colorBar)+scale_fill_manual(values = colorBar)
bar
ggsave(file=paste('/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_iu', '/MOT_OFF_iu_Bar4.pdf',sep=''), bar, width = 10, height = 10,device=cairo_pdf) #saves g


#Correlation plots CER
metablist <- list('tCho','Ins','GSH','tNAA','Asp','Gln','Glu','tCr')
invCRLBlist <- list('tCho_CRLB','Ins_CRLB','GSH_CRLB','tNAA_CRLB','Asp_CRLB','Gln_CRLB','Glu_CRLB','tCr_CRLB')

listCER <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/CER/LCMOutput_A_sep','water')
dfCER <- listCER[[1]]
dfCERCRLB <- listCER[[2]]
CRLB_sum <- summary(dfCERCRLB)
max_crlbs <- dfCERCRLB == 999
dfCER <- spvs_AddStatsToDataframe(dfCER,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfCER$ammonia <- dfClinicAll$ammonia
dfCER$WM <- dfCERdiff$WM
dfCER$GM <- dfCERdiff$GM
dfCER$CSF <- dfCERdiff$CSF
dfCER <- spvs_TissueCorr(dfCER,.068,1.750,.068,1.750)
for (i in colnames(dfCERCRLB)){
  if (i %in% colnames(dfCER)){
    dfCERCRLB[[i]] <- dfCER[[i]] * dfCERCRLB[[i]]/100}
}
dfCERCRLB <- 1/dfCERCRLB
colnames(dfCERCRLB) <- paste(colnames(dfCERCRLB),'CRLB',sep='_')
dfCERCRLB[max_crlbs] = 1/999
dfCER <- bind_cols(dfCER,dfCERCRLB)
#Remove outlier
# dfCER <- dfCER[-c(1,4,6,11,13,17,20,35,36,37,38),]
#dfCER <- dfCER[-c(4,6,17,18,20,32,35,37,38),]
dfCER <- dfCER[-c(6,17,32,34,35,37,38),]

dfCERCon <- subset(dfCER, numGroup == 1)
dfCERmHE <- subset(dfCER, numGroup == 2)
dfCERHE <- subset(dfCER, numGroup == 3)
dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERmHE,dfCERHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075)
upperLiInst <- c(45,20,45,4.5,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175)
pCERCrCorr <- spvs_Correlation(list(dfCERCon,dfCERmHE,dfCERHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA','CFF','tCr'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA','CFF','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_iu/CFFvsCERiu.pdf", pCERCrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorr

pCERCrCorrPEG <- spvs_Correlation(list(dfCERCon,dfCERmHE,dfCERHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA','PEG','tCr'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA','PEG','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_iu/PEGvsCERiu.pdf", pCERCrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorrPEG

pCERCrCorrNH3 <- spvs_Correlation(list(dfCERCon,dfCERmHE,dfCERHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA','ammonia','tCr'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA','ammonia','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_iu/NH3vsCERiu.pdf", pCERCrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorrNH3

pCERCrCorr <- spvs_Correlation(list(dfCERCon,dfCERHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA','CFF','tCr'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA','CFF','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_iu/CFFvsCERiu_nomHE.pdf", pCERCrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorr

pCERCrCorrPEG <- spvs_Correlation(list(dfCERCon,dfCERHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA','PEG','tCr'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA','PEG','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_iu/PEGvsCERiu_nomHE.pdf", pCERCrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorrPEG

pCERCrCorrNH3 <- spvs_Correlation(list(dfCERCon,dfCERHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA','ammonia','tCr'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA','ammonia','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/CER_OFF_iu/NH3vsCERiu_nomHE.pdf", pCERCrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pCERCrCorrNH3

CER_off_iu_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/CER_CFF_lm_iu.txt')
CER_off_iu_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/CER_CFF_lm_age_iu.txt','age')
CER_off_iu_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/CER_CFF_lm_CRLB_iu.txt',weighting=invCRLBlist)
CER_off_iu_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/CER_CFF_lm_age_CRLB_iu.txt','age',invCRLBlist)

CER_off_iu_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/CER_PEG_lm_iu.txt')
CER_off_iu_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/CER_PEG_lm_age_iu.txt','age')
CER_off_iu_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/CER_PEG_lm_CRLB_iu.txt',weighting=invCRLBlist)
CER_off_iu_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/CER_PEG_lm_age_CRLB_iu.txt','age',invCRLBlist)

CER_off_iu_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/CER_ammonia_lm_iu.txt')
CER_off_iu_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/CER_ammonia_lm_age_iu.txt','age')
CER_off_iu_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/CER_ammonia_lm_CRLB_iu.txt',weighting=invCRLBlist)
CER_off_iu_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/CER_ammonia_lm_age_CRLB_iu.txt','age',invCRLBlist)


#Correlation plots GABA THA

listTHA <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/THA/LCMOutput_A_sep','water')
dfTHA <- listTHA[[1]]
dfTHACRLB <- listTHA[[2]]
CRLB_sum <- summary(dfTHACRLB)
max_crlbs <- dfTHACRLB == 999
dfTHA <- spvs_AddStatsToDataframe(dfTHA,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfTHA$ammonia <- dfClinicAll$ammonia
dfTHAdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetTHA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfTHA$WM <- dfTHAdiff$WM
dfTHA$GM <- dfTHAdiff$GM
dfTHA$CSF <- dfTHAdiff$CSF
dfTHA <- spvs_TissueCorr(dfTHA,.068,1.750,.068,1.750)
for (i in colnames(dfTHACRLB)){
  if (i %in% colnames(dfTHA)){
    dfTHACRLB[[i]] <- dfTHA[[i]] * dfTHACRLB[[i]]/100}
}
dfTHACRLB <- 1/dfTHACRLB
dfTHACRLB[max_crlbs] = 1/999
colnames(dfTHACRLB) <- paste(colnames(dfTHACRLB),'CRLB',sep='_')
dfTHA <- bind_cols(dfTHA,dfTHACRLB)
#Remove outlier
# dfTHA <- dfTHA[-c(1,2,12,21),]
#dfTHA <- dfTHA[-c(1,2,12,21,28,36),]
dfTHA <- dfTHA[-c(2,28,34,35,36,37),]

dfTHACon <- subset(dfTHA, numGroup == 1)
dfTHAmHE <- subset(dfTHA, numGroup == 2)
dfTHAHE <- subset(dfTHA, numGroup == 3)
dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAmHE,dfTHAHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075)
upperLiInst <- c(45,20,45,4.5,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175)
pTHACrCorr <- spvs_Correlation(list(dfTHACon,dfTHAmHE,dfTHAHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA','CFF','tCr'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA','CFF','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_iu/CFFvsTHAiu.pdf", pTHACrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pTHACrCorr


pTHACrCorrPEG <- spvs_Correlation(list(dfTHACon,dfTHAmHE,dfTHAHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA','PEG','tCr'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA','PEG','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_iu/PEGvsTHAiu.pdf", pTHACrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pTHACrCorrPEG


pTHACrCorrNH3 <- spvs_Correlation(list(dfTHACon,dfTHAmHE,dfTHAHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA','ammonia','tCr'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA','ammonia','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_iu/NH3vsTHAiu.pdf", pTHACrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pTHACrCorrNH3

pTHACrCorrNH3 <- spvs_Correlation(list(dfTHACon,dfTHAHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA','ammonia','tCr'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA','ammonia','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/THA_OFF_iu/NH3vsTHAiu_nomHE.pdf", pTHACrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pTHACrCorrNH3

THA_off_iu_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/THA_CFF_lm_iu.txt')
THA_off_iu_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/THA_CFF_lm_age_iu.txt','age')
THA_off_iu_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/THA_CFF_lm_CRLB_iu.txt',weighting=invCRLBlist)
THA_off_iu_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/THA_CFF_lm_age_CRLB_iu.txt','age',invCRLBlist)

THA_off_iu_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/THA_PEG_lm_iu.txt')
THA_off_iu_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/THA_PEG_lm_age_iu.txt','age')
THA_off_iu_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/THA_PEG_lm_CRLB_iu.txt',weighting=invCRLBlist)
THA_off_iu_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/THA_PEG_lm_age_CRLB_iu.txt','age',invCRLBlist)

THA_off_iu_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/THA_ammonia_lm_iu.txt')
THA_off_iu_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/THA_ammonia_lm_age_iu.txt','age')
THA_off_iu_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/THA_ammonia_lm_CRLB_iu.txt',weighting=invCRLBlist)
THA_off_iu_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/THA_ammonia_lm_age_CRLB_iu.txt','age',invCRLBlist)


#Correlation plots GABA MOT
listMOT <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/MOT/LCMOutput_A_sep','water')
dfMOT <- listMOT[[1]]
dfMOTCRLB <- listMOT[[2]]
CRLB_sum <- summary(dfMOTCRLB)
max_crlbs <- dfMOTCRLB == 999
dfMOT <- spvs_AddStatsToDataframe(dfMOT,'/Volumes/Elements/working/GABA_HE/statMOT.csv')
#dfMOTdiffRed <- dfMOTdiff[-c(4),]
dfMOT$ammonia <- dfClinicMot$ammonia
dfMOT$WM <- dfMOTdiff$WM
dfMOT$GM <- dfMOTdiff$GM
dfMOT$CSF <- dfMOTdiff$CSF
dfMOT <- spvs_TissueCorr(dfMOT,.068,1.750,.068,1.750)
for (i in colnames(dfMOTCRLB)){
  if (i %in% colnames(dfMOT)){
    dfMOTCRLB[[i]] <- dfMOT[[i]] * dfMOTCRLB[[i]]/100}
}
dfMOTCRLB <- 1/dfMOTCRLB
dfMOTCRLB[max_crlbs] = 1/999
colnames(dfMOTCRLB) <- paste(colnames(dfMOTCRLB),'CRLB',sep='_')
dfMOT <- bind_cols(dfMOT,dfMOTCRLB)
#Remove outlier
# dfMOT <- dfMOT[-c(2,4,5,9,12,14,15,19,20,32),]
#dfMOT <- dfMOT[-c(2,4,5,9,12,13,14,15,19,20,32,37),]
dfMOT <- dfMOT[-c(2,4,14,19,33,34,35,36,37),]

dfMOTCon <- subset(dfMOT, numGroup == 1)
dfMOTmHE <- subset(dfMOT, numGroup == 2)
dfMOTHE <- subset(dfMOT, numGroup == 3)
dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTmHE,dfMOTHE),c('A-con','B-mHE','C-HE'))
lowerLiInst <- c(30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075,30,0.075)
upperLiInst <- c(45,0.175,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175,45,0.175)
pMOTCrCorr <- spvs_Correlation(list(dfMOTCon,dfMOTmHE,dfMOTHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA','CFF','tCr'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA','CFF','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_iu/CFFvsMOTiu.pdf", pMOTCrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorr


pMOTCrCorrPEG <- spvs_Correlation(list(dfMOTCon,dfMOTmHE,dfMOTHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA','PEG','tCr'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA','PEG','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_iu/PEGvsMOTiu.pdf", pMOTCrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorrPEG


pMOTCrCorrNH3 <- spvs_Correlation(list(dfMOTCon,dfMOTmHE,dfMOTHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA','ammonia','tCr'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA','ammonia','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_iu/NH3vsMOTiu.pdf", pMOTCrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorrNH3

pMOTCrCorr <- spvs_Correlation(list(dfMOTCon,dfMOTHE),"",c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA','CFF','tCr'),c("CFF","Asp",'CFF','tCho','CFF','GSH','CFF','Glu','CFF','Gln','CFF','Ins','CFF','tNAA','CFF','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_iu/CFFvsMOTiu_nomHE.pdf", pMOTCrCorr, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorr


pMOTCrCorrPEG <- spvs_Correlation(list(dfMOTCon,dfMOTHE),"",c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA','PEG','tCr'),c("PEG","Asp",'PEG','tCho','PEG','GSH','PEG','Glu','PEG','Gln','PEG','Ins','PEG','tNAA','PEG','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_iu/PEGvsMOTiu_nomHE.pdf", pMOTCrCorrPEG, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorrPEG


pMOTCrCorrNH3 <- spvs_Correlation(list(dfMOTCon,dfMOTHE),"",c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA','ammonia','tCr'),c("ammonia","Asp",'ammonia','tCho','ammonia','GSH','ammonia','Glu','ammonia','Gln','ammonia','Ins','ammonia','tNAA','ammonia','tCr'),c('con','mHE','HE'),NULL,lowerLiInst,upperLiInst, 3)
ggsave(file="/Volumes/Elements/working/GABA_HE/Figures/MOT_OFF_iu/NH3vsMOTiu_nomHE.pdf", pMOTCrCorrNH3, width = 5, height = 10,device=cairo_pdf) #saves g
pMOTCrCorrNH3

MOT_off_iu_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/MOT_CFF_lm_iu.txt')
MOT_off_iu_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/MOT_CFF_lm_age_iu.txt','age')
MOT_off_iu_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/MOT_CFF_lm_CRLB_iu.txt',weighting=invCRLBlist)
MOT_off_iu_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/MOT_CFF_lm_age_CRLB_iu.txt','age',invCRLBlist)

MOT_off_iu_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/MOT_PEG_lm_iu.txt')
MOT_off_iu_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/MOT_PEG_lm_age_iu.txt','age')
MOT_off_iu_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/MOT_PEG_lm_CRLB_iu.txt',weighting=invCRLBlist)
MOT_off_iu_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/MOT_PEG_lm_age_CRLB_iu.txt','age',invCRLBlist)

MOT_off_iu_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/MOT_ammonia_lm_iu.txt')
MOT_off_iu_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/MOT_ammonia_lm_age_iu.txt','age')
MOT_off_iu_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/MOT_ammonia_lm_CRLB_iu.txt',weighting=invCRLBlist)
MOT_off_iu_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/MOT_ammonia_lm_age_CRLB_iu.txt','age',invCRLBlist)

# CER_p <- c(CER_diff_p,CER_diff_p_CFF,CER_diff_p_PEG,CER_diff_p_NH3)
# Do FDR correction for the stats
#Contains Cr and iu GABA (8 estimates)          8
CER_diff_p
CER_diff_p_CFF
CER_diff_p_PEG
CER_diff_p_NH3

THA_diff_p
THA_diff_p_CFF
THA_diff_p_PEG
THA_diff_p_NH3

MOT_diff_p
MOT_diff_p_CFF
MOT_diff_p_PEG
MOT_diff_p_NH3

text <- c("GABA_Cr","GABA_iu")

p <- c(CER_diff_p)
p <- data_frame(p)
colnames(p) <- 'p'
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, "*", ""),p.fdr.sig = ifelse(p.fdr < .05, "*", ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/CER_GABA_stat_pvalue.txt')
print(p.fdr)
sink()

p <- c(THA_diff_p)
p <- data_frame(p)
colnames(p) <- 'p'
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, "*", ""),p.fdr.sig = ifelse(p.fdr < .05, "*", ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/THA_GABA_stat_pvalue.txt')
print(p.fdr)
sink()

p <- c(MOT_diff_p)
p <- data_frame(p)
colnames(p) <- 'p'
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, "*", ""),p.fdr.sig = ifelse(p.fdr < .05, "*", ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA_stat_pvalue.txt')
print(p.fdr)
sink()

text <- c("CER_GABA_Cr","CER_GABA_iu","THA_GABA_Cr","THA_GABA_iu","MOT_GABA_Cr","MOT_GABA_iu")
p <- c(CER_diff_p,THA_diff_p,MOT_diff_p)
p <- data_frame(p)
colnames(p) <- 'p'
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, "*", ""),p.fdr.sig = ifelse(p.fdr < .05, "*", ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/GABA_stat_pvalue.txt')
print(p.fdr)
sink()


text <- c("GABA_Cr_CFF","GABA_iu_CFF","GABA_Cr_CFF_Con","GABA_iu_CFF_Con","GABA_Cr_CFF_HE","GABA_iu_CFF_HE",
          "GABA_Cr_PEG","GABA_iu_PEG","GABA_Cr_PEG_Con","GABA_iu_PEG_Con","GABA_Cr_PEG_HE","GABA_iu_PEG_HE",
          "GABA_Cr_NH3","GABA_iu_NH3")

p <- c(CER_diff_p_CFF[[1]],CER_diff_p_PEG[[1]],CER_diff_p_NH3[[1]])
p <- data_frame(p)
colnames(p) <- 'p'
p <- p[-c(5,6,13,14,19,20,21,22,23,24),]
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, "*", ""),p.fdr.sig = ifelse(p.fdr < .05, "*", ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/CER_GABA_stat_pvalue_corr.txt')
print(p.fdr)
sink()
p_diff_corr_CER <- p.fdr

p <- c(THA_diff_p_CFF[[1]],THA_diff_p_PEG[[1]],THA_diff_p_NH3[[1]])
p <- data_frame(p)
colnames(p) <- 'p'
p <- p[-c(5,6,13,14,19,20,21,22,23,24),]
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, "*", ""),p.fdr.sig = ifelse(p.fdr < .05, "*", ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/THA_GABA_stat_pvalue_corr.txt')
print(p.fdr)
sink()
p_diff_corr_THA <- p.fdr

p <- c(MOT_diff_p_CFF[[1]],MOT_diff_p_PEG[[1]],MOT_diff_p_NH3[[1]])
p <- data_frame(p)
colnames(p) <- 'p'
p <- p[-c(15,16,17,18),]
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, "*", ""),p.fdr.sig = ifelse(p.fdr < .05, "*", ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/MOT_GABA_stat_pvalue_corr.txt')
print(p.fdr)
sink()
p_diff_corr_MOT <- p.fdr


#Contains Cr off (28 estimates)                 28
CER_off_cr_p
CER_off_cr_p_CFF
CER_off_cr_p_PEG
CER_off_cr_p_NH3

THA_off_cr_p
THA_off_cr_p_CFF
THA_off_cr_p_PEG
THA_off_cr_p_NH3

MOT_off_cr_p
MOT_off_cr_p_CFF
MOT_off_cr_p_PEG
MOT_off_cr_p_NH3

text <- c('tCho_Cr','Ins_Cr','GSH_Cr','tNAA_Cr','Asp_Cr','Gln_Cr','Glu_Cr','Glx_Cr')

p <- c(CER_off_cr_p)
p <- data_frame(p)
colnames(p) <- 'p'
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/CER_off_Cr_stat_pvalue.txt')
print(p.fdr)
sink()

p <- c(THA_off_cr_p)
p <- data_frame(p)
colnames(p) <- 'p'
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/THA_off_Cr_stat_pvalue.txt')
print(p.fdr)
sink()

p <- c(MOT_off_cr_p)
p <- data_frame(p)
colnames(p) <- 'p'
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/MOT_off_Cr_stat_pvalue.txt')
print(p.fdr)
sink()

text <- c('tCho_Cr_CFF','Ins_Cr_CFF','GSH_Cr_CFF','tNAA_Cr_CFF','Asp_Cr_CFF','Gln_Cr_CFF','Glu_Cr_CFF','Glx_Cr_CFF',
          'tCho_Cr_CFF_Con','Ins_Cr_CFF_Con','GSH_Cr_CFF_Con','tNAA_Cr_CFF_Con','Asp_Cr_CFF_Con','Gln_Cr_CFF_Con','Glu_Cr_CFF_Con','Glx_Cr_CFF_Con',
          'tCho_Cr_CFF_HE','Ins_Cr_CFF_HE','GSH_Cr_CFF_HE','tNAA_Cr_CFF_HE','Asp_Cr_CFF_HE','Gln_Cr_CFF_HE','Glu_Cr_CFF_HE','Glx_Cr_CFF_HE',
          'tCho_Cr_PEG','Ins_Cr_PEG','GSH_Cr_PEG','tNAA_Cr_PEG','Asp_Cr_PEG','Gln_Cr_PEG','Glu_Cr_PEG','Glx_Cr_PEG',
          'tCho_Cr_PEG_Con','Ins_Cr_PEG_Con','GSH_Cr_PEG_Con','tNAA_Cr_PEG_Con','Asp_Cr_PEG_Con','Gln_Cr_PEG_Con','Glu_Cr_PEG_Con','Glx_Cr_PEG_Con',
          'tCho_Cr_PEG_HE','Ins_Cr_PEG_HE','GSH_Cr_PEG_HE','tNAA_Cr_PEG_HE','Asp_Cr_PEG_HE','Gln_Cr_PEG_HE','Glu_Cr_PEG_HE','Glx_Cr_PEG_HE',
          'tCho_Cr_NH3','Ins_Cr_NH3','GSH_Cr_NH3','tNAA_Cr_NH3','Asp_Cr_NH3','Gln_Cr_NH3','Glu_Cr_NH3','Glx_Cr_NH3')

#text <- c('tCho_Cr_CFF','Ins_Cr_CFF','GSH_Cr_CFF','tNAA_Cr_CFF','Asp_Cr_CFF','Gln_Cr_CFF','Glu_Cr_CFF','Glx_Cr_CFF',
#          'tCho_Cr_CFF_Con','Ins_Cr_CFF_Con','GSH_Cr_CFF_Con','tNAA_Cr_CFF_Con','Asp_Cr_CFF_Con','Gln_Cr_CFF_Con','Glu_Cr_CFF_Con','Glx_Cr_CFF_Con',
#          'tCho_Cr_CFF_mHE','Ins_Cr_CFF_mHE','GSH_Cr_CFF_mHE','tNAA_Cr_CFF_mHE','Asp_Cr_CFF_mHE','Gln_Cr_CFF_mHE','Glu_Cr_CFF_mHE','Glx_Cr_CFF_mHE',
#          'tCho_Cr_CFF_HE','Ins_Cr_CFF_HE','GSH_Cr_CFF_HE','tNAA_Cr_CFF_HE','Asp_Cr_CFF_HE','Gln_Cr_CFF_HE','Glu_Cr_CFF_HE','Glx_Cr_CFF_HE',
#          'tCho_Cr_PEG','Ins_Cr_PEG','GSH_Cr_PEG','tNAA_Cr_PEG','Asp_Cr_PEG','Gln_Cr_PEG','Glu_Cr_PEG','Glx_Cr_PEG',
#          'tCho_Cr_PEG_Con','Ins_Cr_PEG_Con','GSH_Cr_PEG_Con','tNAA_Cr_PEG_Con','Asp_Cr_PEG_Con','Gln_Cr_PEG_Con','Glu_Cr_PEG_Con','Glx_Cr_PEG_Con',
#          'tCho_Cr_PEG_mHE','Ins_Cr_PEG_mHE','GSH_Cr_PEG_mHE','tNAA_Cr_PEG_mHE','Asp_Cr_PEG_mHE','Gln_Cr_PEG_mHE','Glu_Cr_PEG_mHE','Glx_Cr_PEG_mHE',
#          'tCho_Cr_PEG_HE','Ins_Cr_PEG_HE','GSH_Cr_PEG_HE','tNAA_Cr_PEG_HE','Asp_Cr_PEG_HE','Gln_Cr_PEG_HE','Glu_Cr_PEG_HE','Glx_Cr_PEG_HE',
#          'tCho_Cr_NH3','Ins_Cr_NH3','GSH_Cr_NH3','tNAA_Cr_NH3','Asp_Cr_NH3','Gln_Cr_NH3','Glu_Cr_NH3','Glx_Cr_NH3',
#          'tCho_Cr_NH3_Con','Ins_Cr_NH3_Con','GSH_Cr_NH3_Con','tNAA_Cr_NH3_Con','Asp_Cr_NH3_Con','Gln_Cr_NH3_Con','Glu_Cr_NH3_Con','Glx_Cr_NH3_Con',
#          'tCho_Cr_NH3_mHE','Ins_Cr_NH3_mHE','GSH_Cr_NH3_mHE','tNAA_Cr_NH3_mHE','Asp_Cr_NH3_mHE','Gln_Cr_NH3_mHE','Glu_Cr_NH3_mHE','Glx_Cr_NH3_mHE',
#          'tCho_Cr_NH3_HE','Ins_Cr_NH3_HE','GSH_Cr_NH3_HE','tNAA_Cr_NH3_HE','Asp_Cr_NH3_HE','Gln_Cr_NH3_HE','Glu_Cr_NH3_HE','Glx_Cr_NH3_HE')

p <- c(CER_off_cr_p_CFF[[1]],CER_off_cr_p_PEG[[1]],CER_off_cr_p_NH3[[1]])
p <- data_frame(p)
p <- p[-c(57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72),]
colnames(p) <- 'p'
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/CER_off_Cr_stat_pvalue_corr.txt')
print(p.fdr,n=length(text))
sink()
p_off_cr_corr_CER <- p.fdr

p <- c(THA_off_cr_p_CFF[[1]],THA_off_cr_p_PEG[[1]],THA_off_cr_p_NH3[[1]])
p <- data_frame(p)
colnames(p) <- 'p'
p <- p[-c(17,18,19,20,21,22,23,24,49,50,51,52,53,54,55,56,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96),]
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/THA_off_Cr_stat_pvalue_corr.txt')
print(p.fdr,n=length(text))
sink()
p_off_cr_corr_THA <- p.fdr

p <- c(MOT_off_cr_p_CFF[[1]],MOT_off_cr_p_PEG[[1]],MOT_off_cr_p_NH3[[1]])
p <- data_frame(p)
p <- p[-c(57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72),]
colnames(p) <- 'p'
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/MOT_off_Cr_stat_pvalue_corr.txt')
print(p.fdr,n=length(text))
sink()
p_off_cr_corr_MOT <- p.fdr

#Contains iu off (28 estimates)                 28
CER_off_iu_p
CER_off_iu_p_CFF
CER_off_iu_p_PEG
CER_off_iu_p_NH3

THA_off_iu_p
THA_off_iu_p_CFF
THA_off_iu_p_PEG
THA_off_iu_p_NH3

MOT_off_iu_p
MOT_off_iu_p_CFF
MOT_off_iu_p_PEG
MOT_off_iu_p_NH3

text <- c('tCho_iu','Ins_iu','GSH_iu','tNAA_iu','Asp_iu','Gln_iu','Glu_iu','tCr_iu')

p <- c(CER_off_iu_p)
p <- data_frame(p)
colnames(p) <- 'p'
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/CER_off_iu_stat_pvalue.txt')
print(p.fdr,n=length(text))
sink()

p <- c(THA_off_iu_p)
p <- data_frame(p)
colnames(p) <- 'p'
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/THA_off_iu_stat_pvalue.txt')
print(p.fdr,n=length(text))
sink()

p <- c(MOT_off_iu_p)
p <- data_frame(p)
colnames(p) <- 'p'
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/MOT_off_iu_stat_pvalue.txt')
print(p.fdr,n=length(text))
sink()

text <- c('tCho_iu_CFF','Ins_iu_CFF','GSH_iu_CFF','tNAA_iu_CFF','Asp_iu_CFF','Gln_iu_CFF','Glu_iu_CFF','tCr_iu_CFF',
          'tCho_iu_CFF_Con','Ins_iu_CFF_Con','GSH_iu_CFF_Con','tNAA_iu_CFF_Con','Asp_iu_CFF_Con','Gln_iu_CFF_Con','Glu_iu_CFF_Con','tCr_iu_CFF_Con',
          'tCho_iu_CFF_HE','Ins_iu_CFF_HE','GSH_iu_CFF_HE','tNAA_iu_CFF_HE','Asp_iu_CFF_HE','Gln_iu_CFF_HE','Glu_iu_CFF_HE','tCr_iu_CFF_HE',
          'tCho_iu_PEG','Ins_iu_PEG','GSH_iu_PEG','tNAA_iu_PEG','Asp_iu_PEG','Gln_iu_PEG','Glu_iu_PEG','tCr_iu_PEG',
          'tCho_iu_PEG_Con','Ins_iu_PEG_Con','GSH_iu_PEG_Con','tNAA_iu_PEG_Con','Asp_iu_PEG_Con','Gln_iu_PEG_Con','Glu_iu_PEG_Con','tCr_iu_PEG_Con',
          'tCho_iu_PEG_HE','Ins_iu_PEG_HE','GSH_iu_PEG_HE','tNAA_iu_PEG_HE','Asp_iu_PEG_HE','Gln_iu_PEG_HE','Glu_iu_PEG_HE','tCr_iu_PEG_HE',
          'tCho_iu_NH3','Ins_iu_NH3','GSH_iu_NH3','tNAA_iu_NH3','Asp_iu_NH3','Gln_iu_NH3','Glu_iu_NH3','tCr_iu_NH3')

#text <- c('tCho_iu_CFF','Ins_iu_CFF','GSH_iu_CFF','tNAA_iu_CFF','Asp_iu_CFF','Gln_iu_CFF','Glu_iu_CFF','Glx_iu_CFF',
#          'tCho_iu_CFF_Con','Ins_iu_CFF_Con','GSH_iu_CFF_Con','tNAA_iu_CFF_Con','Asp_iu_CFF_Con','Gln_iu_CFF_Con','Glu_iu_CFF_Con','Glx_iu_CFF_Con',
#          'tCho_iu_CFF_mHE','Ins_iu_CFF_mHE','GSH_iu_CFF_mHE','tNAA_iu_CFF_mHE','Asp_iu_CFF_mHE','Gln_iu_CFF_mHE','Glu_iu_CFF_mHE','Glx_iu_CFF_mHE',
#          'tCho_iu_CFF_HE','Ins_iu_CFF_HE','GSH_iu_CFF_HE','tNAA_iu_CFF_HE','Asp_iu_CFF_HE','Gln_iu_CFF_HE','Glu_iu_CFF_HE','Glx_iu_CFF_HE',
#          'tCho_iu_PEG','Ins_iu_PEG','GSH_iu_PEG','tNAA_iu_PEG','Asp_iu_PEG','Gln_iu_PEG','Glu_iu_PEG','Glx_iu_PEG',
#          'tCho_iu_PEG_Con','Ins_iu_PEG_Con','GSH_iu_PEG_Con','tNAA_iu_PEG_Con','Asp_iu_PEG_Con','Gln_iu_PEG_Con','Glu_iu_PEG_Con','Glx_iu_PEG_Con',
#          'tCho_iu_PEG_mHE','Ins_iu_PEG_mHE','GSH_iu_PEG_mHE','tNAA_iu_PEG_mHE','Asp_iu_PEG_mHE','Gln_iu_PEG_mHE','Glu_iu_PEG_mHE','Glx_iu_PEG_mHE',
#          'tCho_iu_PEG_HE','Ins_iu_PEG_HE','GSH_iu_PEG_HE','tNAA_iu_PEG_HE','Asp_iu_PEG_HE','Gln_iu_PEG_HE','Glu_iu_PEG_HE','Glx_iu_PEG_HE',
#          'tCho_iu_NH3','Ins_iu_NH3','GSH_iu_NH3','tNAA_iu_NH3','Asp_iu_NH3','Gln_iu_NH3','Glu_iu_NH3','Glx_iu_NH3',
#          'tCho_iu_NH3_Con','Ins_iu_NH3_Con','GSH_iu_NH3_Con','tNAA_iu_NH3_Con','Asp_iu_NH3_Con','Gln_iu_NH3_Con','Glu_iu_NH3_Con','Glx_iu_NH3_Con',
#          'tCho_iu_NH3_mHE','Ins_iu_NH3_mHE','GSH_iu_NH3_mHE','tNAA_iu_NH3_mHE','Asp_iu_NH3_mHE','Gln_iu_NH3_mHE','Glu_iu_NH3_mHE','Glx_iu_NH3_mHE',
#          'tCho_iu_NH3_HE','Ins_iu_NH3_HE','GSH_iu_NH3_HE','tNAA_iu_NH3_HE','Asp_iu_NH3_HE','Gln_iu_NH3_HE','Glu_iu_NH3_HE','Glx_iu_NH3_HE')


p <- c(CER_off_iu_p_CFF[[1]],CER_off_iu_p_PEG[[1]],CER_off_iu_p_NH3[[1]])
p <- data_frame(p)
colnames(p) <- 'p'
p <- p[-c(57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72),]
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/CER_off_iu_stat_pvalue_corr.txt')
print(p.fdr,n=length(text))
sink()
p_off_iu_corr_CER <- p.fdr

p <- c(THA_off_iu_p_CFF[[1]],THA_off_iu_p_PEG[[1]],THA_off_iu_p_NH3[[1]])
p <- data_frame(p)
colnames(p) <- 'p'
p <- p[-c(17,18,19,20,21,22,23,24,49,50,51,52,53,54,55,56,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96),]
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/THA_off_iu_stat_pvalue_corr.txt')
print(p.fdr,n=length(text))
sink()
p_off_iu_corr_THA <- p.fdr

p <- c(MOT_off_iu_p_CFF[[1]],MOT_off_iu_p_PEG[[1]],MOT_off_iu_p_NH3[[1]])
p <- data_frame(p)
colnames(p) <- 'p'
p <- p[-c(57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72),]
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/MOT_off_iu_stat_pvalue_corr.txt')
print(p.fdr,n=length(text))
sink()
p_off_iu_corr_MOT <- p.fdr

## MATRIX PLOTS start here
dfGABA_corr_r <- data.frame(matrix(ncol = 3, nrow = 3))
dfGABA_corr_p <- data.frame(matrix(ncol = 3, nrow = 3))
colnames(dfGABA_corr_r) <- c('CFF', 'PEG', 'NH3')
colnames(dfGABA_corr_p) <- c('CFF', 'PEG', 'NH3')
dfGABA_corr_r$CFF[[1]] <- CER_diff_p_CFF[[2]][[1]]
dfGABA_corr_r$CFF[[2]] <- THA_diff_p_CFF[[2]][[1]]
dfGABA_corr_r$CFF[[3]] <- MOT_diff_p_CFF[[2]][[1]]
dfGABA_corr_r$PEG[[1]] <- CER_diff_p_PEG[[2]][[1]]
dfGABA_corr_r$PEG[[2]] <- THA_diff_p_PEG[[2]][[1]]
dfGABA_corr_r$PEG[[3]] <- MOT_diff_p_PEG[[2]][[1]]
dfGABA_corr_r$NH3[[1]] <- CER_diff_p_NH3[[2]][[1]]
dfGABA_corr_r$NH3[[2]] <- THA_diff_p_NH3[[2]][[1]]
dfGABA_corr_r$NH3[[3]] <- MOT_diff_p_NH3[[2]][[1]]

dfGABA_corr_p$CFF[[1]] <- p_diff_corr_CER$p.fdr[[1]]
dfGABA_corr_p$CFF[[2]] <- p_diff_corr_THA$p.fdr[[1]]
dfGABA_corr_p$CFF[[3]] <- p_diff_corr_MOT$p.fdr[[1]]
dfGABA_corr_p$PEG[[1]] <- p_diff_corr_CER$p.fdr[[7]]
dfGABA_corr_p$PEG[[2]] <- p_diff_corr_THA$p.fdr[[7]]
dfGABA_corr_p$PEG[[3]] <- p_diff_corr_MOT$p.fdr[[7]]
dfGABA_corr_p$NH3[[1]] <- p_diff_corr_CER$p.fdr[[13]]
dfGABA_corr_p$NH3[[2]] <- p_diff_corr_THA$p.fdr[[13]]
dfGABA_corr_p$NH3[[3]] <- p_diff_corr_MOT$p.fdr[[13]]

rownames(dfGABA_corr_r) <- c('Cerebellum','Thalamus','Motor Cortex')
rownames(dfGABA_corr_p) <- c('Cerebellum','Thalamus','Motor Cortex')
CairoPDF(file=paste('/Volumes/Elements/working/GABA_HE/Figures/partialcorr/', 'Correlation_GABA_Cr.pdf',sep=''), width = 15, height = 5, onefile = TRUE)
p<-{corrplot(data.matrix(dfGABA_corr_r),p.mat=data.matrix(dfGABA_corr_p),sig.level = 0.05, insig='blank', method = 'ellipse', is.corr=FALSE,col.lim = c(-1,1),
             cl.pos = 'r', addgrid.col = 'white', addCoef.col = 'gray')$corrPos -> p1
  text(p1$x, p1$y, round(p1$corr, 2))
  recordPlot()    
}
dev.off()

dfGABA_corr_r <- data.frame(matrix(ncol = 3, nrow = 3))
dfGABA_corr_p <- data.frame(matrix(ncol = 3, nrow = 3))
colnames(dfGABA_corr_r) <- c('CFF', 'PEG', 'NH3')
colnames(dfGABA_corr_p) <- c('CFF', 'PEG', 'NH3')
dfGABA_corr_r$CFF[[1]] <- CER_diff_p_CFF[[2]][[2]]
dfGABA_corr_r$CFF[[2]] <- THA_diff_p_CFF[[2]][[2]]
dfGABA_corr_r$CFF[[3]] <- MOT_diff_p_CFF[[2]][[2]]
dfGABA_corr_r$PEG[[1]] <- CER_diff_p_PEG[[2]][[2]]
dfGABA_corr_r$PEG[[2]] <- THA_diff_p_PEG[[2]][[2]]
dfGABA_corr_r$PEG[[3]] <- MOT_diff_p_PEG[[2]][[2]]
dfGABA_corr_r$NH3[[1]] <- CER_diff_p_NH3[[2]][[2]]
dfGABA_corr_r$NH3[[2]] <- THA_diff_p_NH3[[2]][[2]]
dfGABA_corr_r$NH3[[3]] <- MOT_diff_p_NH3[[2]][[2]]

dfGABA_corr_p$CFF[[1]] <- p_diff_corr_CER$p.fdr[[2]]
dfGABA_corr_p$CFF[[2]] <- p_diff_corr_THA$p.fdr[[2]]
dfGABA_corr_p$CFF[[3]] <- p_diff_corr_MOT$p.fdr[[2]]
dfGABA_corr_p$PEG[[1]] <- p_diff_corr_CER$p.fdr[[8]]
dfGABA_corr_p$PEG[[2]] <- p_diff_corr_THA$p.fdr[[8]]
dfGABA_corr_p$PEG[[3]] <- p_diff_corr_MOT$p.fdr[[8]]
dfGABA_corr_p$NH3[[1]] <- p_diff_corr_CER$p.fdr[[14]]
dfGABA_corr_p$NH3[[2]] <- p_diff_corr_THA$p.fdr[[14]]
dfGABA_corr_p$NH3[[3]] <- p_diff_corr_MOT$p.fdr[[14]]

rownames(dfGABA_corr_r) <- c('Cerebellum','Thalamus','Motor Cortex')
rownames(dfGABA_corr_p) <- c('Cerebellum','Thalamus','Motor Cortex')
CairoPDF(file=paste('/Volumes/Elements/working/GABA_HE/Figures/partialcorr/', 'Correlation_GABA_iu.pdf',sep=''), width = 15, height = 5, onefile = TRUE)
p<-{corrplot(data.matrix(dfGABA_corr_r),p.mat=data.matrix(dfGABA_corr_p),sig.level = 0.05, insig='blank', method = 'ellipse', is.corr=FALSE,col.lim = c(-1,1),
             cl.pos = 'r', addgrid.col = 'white', addCoef.col = 'gray')$corrPos -> p1
  text(p1$x, p1$y, round(p1$corr, 2))
  recordPlot()    
}
dev.off()


dfCER_off_cr_corr_r <- data.frame(matrix(ncol = 3, nrow = 5))
dfCER_off_cr_corr_p <- data.frame(matrix(ncol = 3, nrow = 5))
#provide column names
colnames(dfCER_off_cr_corr_r) <- c('CFF', 'PEG', 'NH3')
colnames(dfCER_off_cr_corr_p) <- c('CFF', 'PEG', 'NH3')
dfCER_off_cr_corr_r$CFF[1] <- CER_off_cr_p_CFF[[2]][[6]]
dfCER_off_cr_corr_r$CFF[2] <- CER_off_cr_p_CFF[[2]][[7]]
dfCER_off_cr_corr_r$CFF[3] <- CER_off_cr_p_CFF[[2]][[2]]
dfCER_off_cr_corr_r$CFF[4] <- CER_off_cr_p_CFF[[2]][[3]]
dfCER_off_cr_corr_r$CFF[5] <- CER_off_cr_p_CFF[[2]][[1]]
dfCER_off_cr_corr_r$PEG[1] <- CER_off_cr_p_PEG[[2]][[6]]
dfCER_off_cr_corr_r$PEG[2] <- CER_off_cr_p_PEG[[2]][[7]]
dfCER_off_cr_corr_r$PEG[3] <- CER_off_cr_p_PEG[[2]][[2]]
dfCER_off_cr_corr_r$PEG[4] <- CER_off_cr_p_PEG[[2]][[3]]
dfCER_off_cr_corr_r$PEG[5] <- CER_off_cr_p_PEG[[2]][[1]]
dfCER_off_cr_corr_r$NH3[1] <- CER_off_cr_p_NH3[[2]][[6]]
dfCER_off_cr_corr_r$NH3[2] <- CER_off_cr_p_NH3[[2]][[7]]
dfCER_off_cr_corr_r$NH3[3] <- CER_off_cr_p_NH3[[2]][[2]]
dfCER_off_cr_corr_r$NH3[4] <- CER_off_cr_p_NH3[[2]][[3]]
dfCER_off_cr_corr_r$NH3[5] <- CER_off_cr_p_NH3[[2]][[1]]

dfCER_off_cr_corr_p$CFF[1] <- p_off_cr_corr_CER$p.fdr[[6]]
dfCER_off_cr_corr_p$CFF[2] <- p_off_cr_corr_CER$p.fdr[[7]]
dfCER_off_cr_corr_p$CFF[3] <- p_off_cr_corr_CER$p.fdr[[2]]
dfCER_off_cr_corr_p$CFF[4] <- p_off_cr_corr_CER$p.fdr[[3]]
dfCER_off_cr_corr_p$CFF[5] <- p_off_cr_corr_CER$p.fdr[[1]]
dfCER_off_cr_corr_p$PEG[1] <- p_off_cr_corr_CER$p.fdr[[30]]
dfCER_off_cr_corr_p$PEG[2] <- p_off_cr_corr_CER$p.fdr[[31]]
dfCER_off_cr_corr_p$PEG[3] <- p_off_cr_corr_CER$p.fdr[[26]]
dfCER_off_cr_corr_p$PEG[4] <- p_off_cr_corr_CER$p.fdr[[27]]
dfCER_off_cr_corr_p$PEG[5] <- p_off_cr_corr_CER$p.fdr[[25]]
dfCER_off_cr_corr_p$NH3[1] <- p_off_cr_corr_CER$p.fdr[[54]]
dfCER_off_cr_corr_p$NH3[2] <- p_off_cr_corr_CER$p.fdr[[55]]
dfCER_off_cr_corr_p$NH3[3] <- p_off_cr_corr_CER$p.fdr[[50]]
dfCER_off_cr_corr_p$NH3[4] <- p_off_cr_corr_CER$p.fdr[[51]]
dfCER_off_cr_corr_p$NH3[5] <- p_off_cr_corr_CER$p.fdr[[49]]

rownames(dfCER_off_cr_corr_r) <- c('Gln','Glu','Ins','GSH','tCho')
rownames(dfCER_off_cr_corr_p) <- c('Gln','Glu','Ins','GSH','tCho')
CairoPDF(file=paste('/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/', 'Correlation.pdf',sep=''), width = 15, height = 5, onefile = TRUE)
p<-{corrplot(data.matrix(dfCER_off_cr_corr_r),p.mat=data.matrix(dfCER_off_cr_corr_p),sig.level = 0.05, insig='blank', method = 'ellipse', is.corr=FALSE,col.lim = c(-1,1),
             cl.pos = 'r', addgrid.col = 'white', addCoef.col = 'gray')$corrPos -> p1
  text(p1$x, p1$y, round(p1$corr, 2))
  recordPlot()    
}
dev.off()

dfTHA_off_cr_corr_r <- data.frame(matrix(ncol = 3, nrow = 5))
dfTHA_off_cr_corr_p <- data.frame(matrix(ncol = 3, nrow = 5))
#provide column names
colnames(dfTHA_off_cr_corr_r) <- c('CFF', 'PEG', 'NH3')
colnames(dfTHA_off_cr_corr_p) <- c('CFF', 'PEG', 'NH3')
dfTHA_off_cr_corr_r$CFF[1] <- THA_off_cr_p_CFF[[2]][[6]]
dfTHA_off_cr_corr_r$CFF[2] <- THA_off_cr_p_CFF[[2]][[7]]
dfTHA_off_cr_corr_r$CFF[3] <- THA_off_cr_p_CFF[[2]][[2]]
dfTHA_off_cr_corr_r$CFF[4] <- THA_off_cr_p_CFF[[2]][[3]]
dfTHA_off_cr_corr_r$CFF[5] <- THA_off_cr_p_CFF[[2]][[1]]
dfTHA_off_cr_corr_r$PEG[1] <- THA_off_cr_p_PEG[[2]][[6]]
dfTHA_off_cr_corr_r$PEG[2] <- THA_off_cr_p_PEG[[2]][[7]]
dfTHA_off_cr_corr_r$PEG[3] <- THA_off_cr_p_PEG[[2]][[2]]
dfTHA_off_cr_corr_r$PEG[4] <- THA_off_cr_p_PEG[[2]][[3]]
dfTHA_off_cr_corr_r$PEG[5] <- THA_off_cr_p_PEG[[2]][[1]]
dfTHA_off_cr_corr_r$NH3[1] <- THA_off_cr_p_NH3[[2]][[6]]
dfTHA_off_cr_corr_r$NH3[2] <- THA_off_cr_p_NH3[[2]][[7]]
dfTHA_off_cr_corr_r$NH3[3] <- THA_off_cr_p_NH3[[2]][[2]]
dfTHA_off_cr_corr_r$NH3[4] <- THA_off_cr_p_NH3[[2]][[3]]
dfTHA_off_cr_corr_r$NH3[5] <- THA_off_cr_p_NH3[[2]][[1]]

dfTHA_off_cr_corr_p$CFF[1] <- p_off_cr_corr_THA$p.fdr[[6]]
dfTHA_off_cr_corr_p$CFF[2] <- p_off_cr_corr_THA$p.fdr[[7]]
dfTHA_off_cr_corr_p$CFF[3] <- p_off_cr_corr_THA$p.fdr[[2]]
dfTHA_off_cr_corr_p$CFF[4] <- p_off_cr_corr_THA$p.fdr[[3]]
dfTHA_off_cr_corr_p$CFF[5] <- p_off_cr_corr_THA$p.fdr[[1]]
dfTHA_off_cr_corr_p$PEG[1] <- p_off_cr_corr_THA$p.fdr[[30]]
dfTHA_off_cr_corr_p$PEG[2] <- p_off_cr_corr_THA$p.fdr[[31]]
dfTHA_off_cr_corr_p$PEG[3] <- p_off_cr_corr_THA$p.fdr[[26]]
dfTHA_off_cr_corr_p$PEG[4] <- p_off_cr_corr_THA$p.fdr[[27]]
dfTHA_off_cr_corr_p$PEG[5] <- p_off_cr_corr_THA$p.fdr[[25]]
dfTHA_off_cr_corr_p$NH3[1] <- p_off_cr_corr_THA$p.fdr[[54]]
dfTHA_off_cr_corr_p$NH3[2] <- p_off_cr_corr_THA$p.fdr[[55]]
dfTHA_off_cr_corr_p$NH3[3] <- p_off_cr_corr_THA$p.fdr[[50]]
dfTHA_off_cr_corr_p$NH3[4] <- p_off_cr_corr_THA$p.fdr[[51]]
dfTHA_off_cr_corr_p$NH3[5] <- p_off_cr_corr_THA$p.fdr[[49]]

rownames(dfTHA_off_cr_corr_r) <- c('Gln','Glu','Ins','GSH','tCho')
rownames(dfTHA_off_cr_corr_p) <- c('Gln','Glu','Ins','GSH','tCho')
CairoPDF(file=paste('/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/', 'Correlation.pdf',sep=''), width = 15, height = 5, onefile = TRUE)
p<-{corrplot(data.matrix(dfTHA_off_cr_corr_r),p.mat=data.matrix(dfTHA_off_cr_corr_p),sig.level = 0.05, insig='blank', method = 'ellipse', is.corr=FALSE,col.lim = c(-1,1),
             cl.pos = 'r', addgrid.col = 'white', addCoef.col = 'gray')$corrPos -> p1
  text(p1$x, p1$y, round(p1$corr, 2))
  recordPlot()    
}
dev.off()

dfMOT_off_cr_corr_r <- data.frame(matrix(ncol = 3, nrow = 5))
dfMOT_off_cr_corr_p <- data.frame(matrix(ncol = 3, nrow = 5))
#provide column names
colnames(dfMOT_off_cr_corr_r) <- c('CFF', 'PEG', 'NH3')
colnames(dfMOT_off_cr_corr_p) <- c('CFF', 'PEG', 'NH3')
dfMOT_off_cr_corr_r$CFF[1] <- MOT_off_cr_p_CFF[[2]][[6]]
dfMOT_off_cr_corr_r$CFF[2] <- MOT_off_cr_p_CFF[[2]][[7]]
dfMOT_off_cr_corr_r$CFF[3] <- MOT_off_cr_p_CFF[[2]][[2]]
dfMOT_off_cr_corr_r$CFF[4] <- MOT_off_cr_p_CFF[[2]][[3]]
dfMOT_off_cr_corr_r$CFF[5] <- MOT_off_cr_p_CFF[[2]][[1]]
dfMOT_off_cr_corr_r$PEG[1] <- MOT_off_cr_p_PEG[[2]][[6]]
dfMOT_off_cr_corr_r$PEG[2] <- MOT_off_cr_p_PEG[[2]][[7]]
dfMOT_off_cr_corr_r$PEG[3] <- MOT_off_cr_p_PEG[[2]][[2]]
dfMOT_off_cr_corr_r$PEG[4] <- MOT_off_cr_p_PEG[[2]][[3]]
dfMOT_off_cr_corr_r$PEG[5] <- MOT_off_cr_p_PEG[[2]][[1]]
dfMOT_off_cr_corr_r$NH3[1] <- MOT_off_cr_p_NH3[[2]][[6]]
dfMOT_off_cr_corr_r$NH3[2] <- MOT_off_cr_p_NH3[[2]][[7]]
dfMOT_off_cr_corr_r$NH3[3] <- MOT_off_cr_p_NH3[[2]][[2]]
dfMOT_off_cr_corr_r$NH3[4] <- MOT_off_cr_p_NH3[[2]][[3]]
dfMOT_off_cr_corr_r$NH3[5] <- MOT_off_cr_p_NH3[[2]][[1]]

dfMOT_off_cr_corr_p$CFF[1] <- p_off_cr_corr_MOT$p.fdr[[6]]
dfMOT_off_cr_corr_p$CFF[2] <- p_off_cr_corr_MOT$p.fdr[[7]]
dfMOT_off_cr_corr_p$CFF[3] <- p_off_cr_corr_MOT$p.fdr[[2]]
dfMOT_off_cr_corr_p$CFF[4] <- p_off_cr_corr_MOT$p.fdr[[3]]
dfMOT_off_cr_corr_p$CFF[5] <- p_off_cr_corr_MOT$p.fdr[[1]]
dfMOT_off_cr_corr_p$PEG[1] <- p_off_cr_corr_MOT$p.fdr[[30]]
dfMOT_off_cr_corr_p$PEG[2] <- p_off_cr_corr_MOT$p.fdr[[31]]
dfMOT_off_cr_corr_p$PEG[3] <- p_off_cr_corr_MOT$p.fdr[[26]]
dfMOT_off_cr_corr_p$PEG[4] <- p_off_cr_corr_MOT$p.fdr[[27]]
dfMOT_off_cr_corr_p$PEG[5] <- p_off_cr_corr_MOT$p.fdr[[25]]
dfMOT_off_cr_corr_p$NH3[1] <- p_off_cr_corr_MOT$p.fdr[[54]]
dfMOT_off_cr_corr_p$NH3[2] <- p_off_cr_corr_MOT$p.fdr[[55]]
dfMOT_off_cr_corr_p$NH3[3] <- p_off_cr_corr_MOT$p.fdr[[50]]
dfMOT_off_cr_corr_p$NH3[4] <- p_off_cr_corr_MOT$p.fdr[[51]]
dfMOT_off_cr_corr_p$NH3[5] <- p_off_cr_corr_MOT$p.fdr[[49]]

rownames(dfMOT_off_cr_corr_r) <- c('Gln','Glu','Ins','GSH','tCho')
rownames(dfMOT_off_cr_corr_p) <- c('Gln','Glu','Ins','GSH','tCho')
CairoPDF(file=paste('/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/', 'Correlation.pdf',sep=''), width = 15, height = 5, onefile = TRUE)
p<-{corrplot(data.matrix(dfMOT_off_cr_corr_r),p.mat=data.matrix(dfMOT_off_cr_corr_p),sig.level = 0.05, insig='blank', method = 'ellipse', is.corr=FALSE,col.lim = c(-1,1),
             cl.pos = 'r', addgrid.col = 'white', addCoef.col = 'gray')$corrPos -> p1
  text(p1$x, p1$y, round(p1$corr, 2))
  recordPlot()    
}
dev.off()

dfCER_off_iu_corr_r <- data.frame(matrix(ncol = 3, nrow = 5))
dfCER_off_iu_corr_p <- data.frame(matrix(ncol = 3, nrow = 5))
#provide column names
colnames(dfCER_off_iu_corr_r) <- c('CFF', 'PEG', 'NH3')
colnames(dfCER_off_iu_corr_p) <- c('CFF', 'PEG', 'NH3')
dfCER_off_iu_corr_r$CFF[1] <- CER_off_iu_p_CFF[[2]][[6]]
dfCER_off_iu_corr_r$CFF[2] <- CER_off_iu_p_CFF[[2]][[7]]
dfCER_off_iu_corr_r$CFF[3] <- CER_off_iu_p_CFF[[2]][[2]]
dfCER_off_iu_corr_r$CFF[4] <- CER_off_iu_p_CFF[[2]][[3]]
dfCER_off_iu_corr_r$CFF[5] <- CER_off_iu_p_CFF[[2]][[1]]
dfCER_off_iu_corr_r$PEG[1] <- CER_off_iu_p_PEG[[2]][[6]]
dfCER_off_iu_corr_r$PEG[2] <- CER_off_iu_p_PEG[[2]][[7]]
dfCER_off_iu_corr_r$PEG[3] <- CER_off_iu_p_PEG[[2]][[2]]
dfCER_off_iu_corr_r$PEG[4] <- CER_off_iu_p_PEG[[2]][[3]]
dfCER_off_iu_corr_r$PEG[5] <- CER_off_iu_p_PEG[[2]][[1]]
dfCER_off_iu_corr_r$NH3[1] <- CER_off_iu_p_NH3[[2]][[6]]
dfCER_off_iu_corr_r$NH3[2] <- CER_off_iu_p_NH3[[2]][[7]]
dfCER_off_iu_corr_r$NH3[3] <- CER_off_iu_p_NH3[[2]][[2]]
dfCER_off_iu_corr_r$NH3[4] <- CER_off_iu_p_NH3[[2]][[3]]
dfCER_off_iu_corr_r$NH3[5] <- CER_off_iu_p_NH3[[2]][[1]]

dfCER_off_iu_corr_p$CFF[1] <- p_off_iu_corr_CER$p.fdr[[6]]
dfCER_off_iu_corr_p$CFF[2] <- p_off_iu_corr_CER$p.fdr[[7]]
dfCER_off_iu_corr_p$CFF[3] <- p_off_iu_corr_CER$p.fdr[[2]]
dfCER_off_iu_corr_p$CFF[4] <- p_off_iu_corr_CER$p.fdr[[3]]
dfCER_off_iu_corr_p$CFF[5] <- p_off_iu_corr_CER$p.fdr[[1]]
dfCER_off_iu_corr_p$PEG[1] <- p_off_iu_corr_CER$p.fdr[[30]]
dfCER_off_iu_corr_p$PEG[2] <- p_off_iu_corr_CER$p.fdr[[31]]
dfCER_off_iu_corr_p$PEG[3] <- p_off_iu_corr_CER$p.fdr[[26]]
dfCER_off_iu_corr_p$PEG[4] <- p_off_iu_corr_CER$p.fdr[[27]]
dfCER_off_iu_corr_p$PEG[5] <- p_off_iu_corr_CER$p.fdr[[25]]
dfCER_off_iu_corr_p$NH3[1] <- p_off_iu_corr_CER$p.fdr[[54]]
dfCER_off_iu_corr_p$NH3[2] <- p_off_iu_corr_CER$p.fdr[[55]]
dfCER_off_iu_corr_p$NH3[3] <- p_off_iu_corr_CER$p.fdr[[50]]
dfCER_off_iu_corr_p$NH3[4] <- p_off_iu_corr_CER$p.fdr[[51]]
dfCER_off_iu_corr_p$NH3[5] <- p_off_iu_corr_CER$p.fdr[[49]]

rownames(dfCER_off_iu_corr_r) <- c('Gln','Glu','Ins','GSH','tCho')
rownames(dfCER_off_iu_corr_p) <- c('Gln','Glu','Ins','GSH','tCho')
CairoPDF(file=paste('/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/', 'Correlation.pdf',sep=''), width = 15, height = 5, onefile = TRUE)
p<-{corrplot(data.matrix(dfCER_off_iu_corr_r),p.mat=data.matrix(dfCER_off_iu_corr_p),sig.level = 0.05, insig='blank', method = 'ellipse', is.corr=FALSE,col.lim = c(-1,1),
             cl.pos = 'r', addgrid.col = 'white', addCoef.col = 'gray')$corrPos -> p1
  text(p1$x, p1$y, round(p1$corr, 2))
  recordPlot()    
}
dev.off()

dfTHA_off_iu_corr_r <- data.frame(matrix(ncol = 3, nrow = 5))
dfTHA_off_iu_corr_p <- data.frame(matrix(ncol = 3, nrow = 5))
#provide column names
colnames(dfTHA_off_iu_corr_r) <- c('CFF', 'PEG', 'NH3')
colnames(dfTHA_off_iu_corr_p) <- c('CFF', 'PEG', 'NH3')
dfTHA_off_iu_corr_r$CFF[1] <- THA_off_iu_p_CFF[[2]][[6]]
dfTHA_off_iu_corr_r$CFF[2] <- THA_off_iu_p_CFF[[2]][[7]]
dfTHA_off_iu_corr_r$CFF[3] <- THA_off_iu_p_CFF[[2]][[2]]
dfTHA_off_iu_corr_r$CFF[4] <- THA_off_iu_p_CFF[[2]][[3]]
dfTHA_off_iu_corr_r$CFF[5] <- THA_off_iu_p_CFF[[2]][[1]]
dfTHA_off_iu_corr_r$PEG[1] <- THA_off_iu_p_PEG[[2]][[6]]
dfTHA_off_iu_corr_r$PEG[2] <- THA_off_iu_p_PEG[[2]][[7]]
dfTHA_off_iu_corr_r$PEG[3] <- THA_off_iu_p_PEG[[2]][[2]]
dfTHA_off_iu_corr_r$PEG[4] <- THA_off_iu_p_PEG[[2]][[3]]
dfTHA_off_iu_corr_r$PEG[5] <- THA_off_iu_p_PEG[[2]][[1]]
dfTHA_off_iu_corr_r$NH3[1] <- as.numeric(THA_off_iu_p_NH3[[2]][[6]])
dfTHA_off_iu_corr_r$NH3[2] <- as.numeric(THA_off_iu_p_NH3[[2]][[7]])
dfTHA_off_iu_corr_r$NH3[3] <- as.numeric(THA_off_iu_p_NH3[[2]][[2]])
dfTHA_off_iu_corr_r$NH3[4] <- as.numeric(THA_off_iu_p_NH3[[2]][[3]])
dfTHA_off_iu_corr_r$NH3[5] <- as.numeric(THA_off_iu_p_NH3[[2]][[1]])

dfTHA_off_iu_corr_p$CFF[1] <- p_off_iu_corr_THA$p.fdr[[6]]
dfTHA_off_iu_corr_p$CFF[2] <- p_off_iu_corr_THA$p.fdr[[7]]
dfTHA_off_iu_corr_p$CFF[3] <- p_off_iu_corr_THA$p.fdr[[2]]
dfTHA_off_iu_corr_p$CFF[4] <- p_off_iu_corr_THA$p.fdr[[3]]
dfTHA_off_iu_corr_p$CFF[5] <- p_off_iu_corr_THA$p.fdr[[1]]
dfTHA_off_iu_corr_p$PEG[1] <- p_off_iu_corr_THA$p.fdr[[30]]
dfTHA_off_iu_corr_p$PEG[2] <- p_off_iu_corr_THA$p.fdr[[31]]
dfTHA_off_iu_corr_p$PEG[3] <- p_off_iu_corr_THA$p.fdr[[26]]
dfTHA_off_iu_corr_p$PEG[4] <- p_off_iu_corr_THA$p.fdr[[27]]
dfTHA_off_iu_corr_p$PEG[5] <- p_off_iu_corr_THA$p.fdr[[25]]
dfTHA_off_iu_corr_p$NH3[1] <- p_off_iu_corr_THA$p.fdr[[54]]
dfTHA_off_iu_corr_p$NH3[2] <- p_off_iu_corr_THA$p.fdr[[55]]
dfTHA_off_iu_corr_p$NH3[3] <- p_off_iu_corr_THA$p.fdr[[50]]
dfTHA_off_iu_corr_p$NH3[4] <- p_off_iu_corr_THA$p.fdr[[51]]
dfTHA_off_iu_corr_p$NH3[5] <- p_off_iu_corr_THA$p.fdr[[49]]

rownames(dfTHA_off_iu_corr_r) <- c('Gln','Glu','Ins','GSH','tCho')
rownames(dfTHA_off_iu_corr_p) <- c('Gln','Glu','Ins','GSH','tCho')
CairoPDF(file=paste('/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/', 'Correlation.pdf',sep=''), width = 15, height = 5, onefile = TRUE)
p<-{corrplot(data.matrix(dfTHA_off_iu_corr_r),p.mat=data.matrix(dfTHA_off_iu_corr_p),sig.level = 0.05, insig='blank', method = 'ellipse', is.corr=FALSE,col.lim = c(-1,1),
             cl.pos = 'r', addgrid.col = 'white', addCoef.col = 'gray')$corrPos -> p1
  text(p1$x, p1$y, round(p1$corr, 2))
  recordPlot()    
}
dev.off()

dfMOT_off_iu_corr_r <- data.frame(matrix(ncol = 3, nrow = 5))
dfMOT_off_iu_corr_p <- data.frame(matrix(ncol = 3, nrow = 5))
#provide column names
colnames(dfMOT_off_iu_corr_r) <- c('CFF', 'PEG', 'NH3')
colnames(dfMOT_off_iu_corr_p) <- c('CFF', 'PEG', 'NH3')
dfMOT_off_iu_corr_r$CFF[1] <- MOT_off_iu_p_CFF[[2]][[6]]
dfMOT_off_iu_corr_r$CFF[2] <- MOT_off_iu_p_CFF[[2]][[7]]
dfMOT_off_iu_corr_r$CFF[3] <- MOT_off_iu_p_CFF[[2]][[2]]
dfMOT_off_iu_corr_r$CFF[4] <- MOT_off_iu_p_CFF[[2]][[3]]
dfMOT_off_iu_corr_r$CFF[5] <- MOT_off_iu_p_CFF[[2]][[1]]
dfMOT_off_iu_corr_r$PEG[1] <- MOT_off_iu_p_PEG[[2]][[6]]
dfMOT_off_iu_corr_r$PEG[2] <- MOT_off_iu_p_PEG[[2]][[7]]
dfMOT_off_iu_corr_r$PEG[3] <- MOT_off_iu_p_PEG[[2]][[2]]
dfMOT_off_iu_corr_r$PEG[4] <- MOT_off_iu_p_PEG[[2]][[3]]
dfMOT_off_iu_corr_r$PEG[5] <- MOT_off_iu_p_PEG[[2]][[1]]
dfMOT_off_iu_corr_r$NH3[1] <- MOT_off_iu_p_NH3[[2]][[6]]
dfMOT_off_iu_corr_r$NH3[2] <- MOT_off_iu_p_NH3[[2]][[7]]
dfMOT_off_iu_corr_r$NH3[3] <- MOT_off_iu_p_NH3[[2]][[2]]
dfMOT_off_iu_corr_r$NH3[4] <- MOT_off_iu_p_NH3[[2]][[3]]
dfMOT_off_iu_corr_r$NH3[5] <- MOT_off_iu_p_NH3[[2]][[1]]

dfMOT_off_iu_corr_p$CFF[1] <- p_off_iu_corr_MOT$p.fdr[[6]]
dfMOT_off_iu_corr_p$CFF[2] <- p_off_iu_corr_MOT$p.fdr[[7]]
dfMOT_off_iu_corr_p$CFF[3] <- p_off_iu_corr_MOT$p.fdr[[2]]
dfMOT_off_iu_corr_p$CFF[4] <- p_off_iu_corr_MOT$p.fdr[[3]]
dfMOT_off_iu_corr_p$CFF[5] <- p_off_iu_corr_MOT$p.fdr[[1]]
dfMOT_off_iu_corr_p$PEG[1] <- p_off_iu_corr_MOT$p.fdr[[30]]
dfMOT_off_iu_corr_p$PEG[2] <- p_off_iu_corr_MOT$p.fdr[[31]]
dfMOT_off_iu_corr_p$PEG[3] <- p_off_iu_corr_MOT$p.fdr[[26]]
dfMOT_off_iu_corr_p$PEG[4] <- p_off_iu_corr_MOT$p.fdr[[27]]
dfMOT_off_iu_corr_p$PEG[5] <- p_off_iu_corr_MOT$p.fdr[[25]]
dfMOT_off_iu_corr_p$NH3[1] <- p_off_iu_corr_MOT$p.fdr[[54]]
dfMOT_off_iu_corr_p$NH3[2] <- p_off_iu_corr_MOT$p.fdr[[55]]
dfMOT_off_iu_corr_p$NH3[3] <- p_off_iu_corr_MOT$p.fdr[[50]]
dfMOT_off_iu_corr_p$NH3[4] <- p_off_iu_corr_MOT$p.fdr[[51]]
dfMOT_off_iu_corr_p$NH3[5] <- p_off_iu_corr_MOT$p.fdr[[49]]

rownames(dfMOT_off_iu_corr_r) <- c('Gln','Glu','Ins','GSH','tCho')
rownames(dfMOT_off_iu_corr_p) <- c('Gln','Glu','Ins','GSH','tCho')
CairoPDF(file=paste('/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/', 'Correlation.pdf',sep=''), width = 15, height = 5, onefile = TRUE)
p<-{corrplot(data.matrix(dfMOT_off_iu_corr_r),p.mat=data.matrix(dfMOT_off_iu_corr_p),sig.level = 0.05, insig='blank', method = 'ellipse', is.corr=FALSE,col.lim = c(-1,1),
             cl.pos = 'r', addgrid.col = 'white', addCoef.col = 'gray')$corrPos -> p1
  text(p1$x, p1$y, round(p1$corr, 2))
  recordPlot()    
}
dev.off()

dfAsp_corr_r <- data.frame(matrix(ncol = 3, nrow = 3))
dfAsp_corr_p <- data.frame(matrix(ncol = 3, nrow = 3))
colnames(dfAsp_corr_r) <- c('CFF', 'PEG', 'NH3')
colnames(dfAsp_corr_p) <- c('CFF', 'PEG', 'NH3')
dfAsp_corr_r$CFF[[1]] <- CER_off_cr_p_CFF[[2]][[5]]
dfAsp_corr_r$CFF[[2]] <- THA_off_cr_p_CFF[[2]][[5]]
dfAsp_corr_r$CFF[[3]] <- MOT_off_cr_p_CFF[[2]][[5]]
dfAsp_corr_r$PEG[[1]] <- CER_off_cr_p_PEG[[2]][[5]]
dfAsp_corr_r$PEG[[2]] <- THA_off_cr_p_PEG[[2]][[5]]
dfAsp_corr_r$PEG[[3]] <- MOT_off_cr_p_PEG[[2]][[5]]
dfAsp_corr_r$NH3[[1]] <- CER_off_cr_p_NH3[[2]][[5]]
dfAsp_corr_r$NH3[[2]] <- THA_off_cr_p_NH3[[2]][[5]]
dfAsp_corr_r$NH3[[3]] <- MOT_off_cr_p_NH3[[2]][[5]]

dfAsp_corr_p$CFF[[1]] <- p_off_cr_corr_CER$p.fdr[[5]]
dfAsp_corr_p$CFF[[2]] <- p_off_cr_corr_THA$p.fdr[[5]]
dfAsp_corr_p$CFF[[3]] <- p_off_cr_corr_MOT$p.fdr[[5]]
dfAsp_corr_p$PEG[[1]] <- p_off_cr_corr_CER$p.fdr[[29]]
dfAsp_corr_p$PEG[[2]] <- p_off_cr_corr_THA$p.fdr[[29]]
dfAsp_corr_p$PEG[[3]] <- p_off_cr_corr_MOT$p.fdr[[29]]
dfAsp_corr_p$NH3[[1]] <- p_off_cr_corr_CER$p.fdr[[53]]
dfAsp_corr_p$NH3[[2]] <- p_off_cr_corr_THA$p.fdr[[53]]
dfAsp_corr_p$NH3[[3]] <- p_off_cr_corr_MOT$p.fdr[[53]]

rownames(dfAsp_corr_r) <- c('Cerebellum','Thalamus','Motor cortex')
rownames(dfAsp_corr_p) <- c('Cerebellum','Thalamus','Motor cortex')
CairoPDF(file=paste('/Volumes/Elements/working/GABA_HE/Figures/partialcorr/', 'Correlation_Asp_Cr.pdf',sep=''), width = 15, height = 5, onefile = TRUE)
p<-{corrplot(data.matrix(dfAsp_corr_r),p.mat=data.matrix(dfAsp_corr_p),sig.level = 0.05, insig='blank', method = 'ellipse', is.corr=FALSE,col.lim = c(-1,1),
             cl.pos = 'r', addgrid.col = 'white', addCoef.col = 'gray')$corrPos -> p1
  text(p1$x, p1$y, round(p1$corr, 2))
  recordPlot()    
}
dev.off()

dfAsp_corr_r <- data.frame(matrix(ncol = 3, nrow = 3))
dfAsp_corr_p <- data.frame(matrix(ncol = 3, nrow = 3))
colnames(dfAsp_corr_r) <- c('CFF', 'PEG', 'NH3')
colnames(dfAsp_corr_p) <- c('CFF', 'PEG', 'NH3')
dfAsp_corr_r$CFF[[1]] <- CER_off_iu_p_CFF[[2]][[5]]
dfAsp_corr_r$CFF[[2]] <- THA_off_iu_p_CFF[[2]][[5]]
dfAsp_corr_r$CFF[[3]] <- MOT_off_iu_p_CFF[[2]][[5]]
dfAsp_corr_r$PEG[[1]] <- CER_off_iu_p_PEG[[2]][[5]]
dfAsp_corr_r$PEG[[2]] <- THA_off_iu_p_PEG[[2]][[5]]
dfAsp_corr_r$PEG[[3]] <- MOT_off_iu_p_PEG[[2]][[5]]
dfAsp_corr_r$NH3[[1]] <- as.numeric(CER_off_iu_p_NH3[[2]][[5]])
dfAsp_corr_r$NH3[[2]] <- as.numeric(THA_off_iu_p_NH3[[2]][[5]])
dfAsp_corr_r$NH3[[3]] <- as.numeric(MOT_off_iu_p_NH3[[2]][[5]])

dfAsp_corr_p$CFF[[1]] <- p_off_iu_corr_CER$p.fdr[[5]]
dfAsp_corr_p$CFF[[2]] <- p_off_iu_corr_THA$p.fdr[[5]]
dfAsp_corr_p$CFF[[3]] <- p_off_iu_corr_MOT$p.fdr[[5]]
dfAsp_corr_p$PEG[[1]] <- p_off_iu_corr_CER$p.fdr[[29]]
dfAsp_corr_p$PEG[[2]] <- p_off_iu_corr_THA$p.fdr[[29]]
dfAsp_corr_p$PEG[[3]] <- p_off_iu_corr_MOT$p.fdr[[29]]
dfAsp_corr_p$NH3[[1]] <- p_off_iu_corr_CER$p.fdr[[53]]
dfAsp_corr_p$NH3[[2]] <- p_off_iu_corr_THA$p.fdr[[53]]
dfAsp_corr_p$NH3[[3]] <- p_off_iu_corr_MOT$p.fdr[[53]]

rownames(dfAsp_corr_r) <- c('Cerebellum','Thalamus','Motor cortex')
rownames(dfAsp_corr_p) <- c('Cerebellum','Thalamus','Motor cortex')
CairoPDF(file=paste('/Volumes/Elements/working/GABA_HE/Figures/partialcorr/', 'Correlation_Asp_iu.pdf',sep=''), width = 15, height = 5, onefile = TRUE)
p<-{corrplot(data.matrix(dfAsp_corr_r),p.mat=data.matrix(dfAsp_corr_p),sig.level = 0.05, insig='blank', method = 'ellipse', is.corr=FALSE,col.lim = c(-1,1),
             cl.pos = 'r', addgrid.col = 'white', addCoef.col = 'gray')$corrPos -> p1
  text(p1$x, p1$y, round(p1$corr, 2))
  recordPlot()    
}
dev.off()

## Explorative Analysis
metablist <- list('Scyllo','Tau')
invCRLBlist <- list('Scyllo_CRLB','Tau_CRLB')

#Creatine ratios

listCER <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/CER/LCMOutput_A_sep')
dfCER <- listCER[[1]]
dfCERCRLB <- listCER[[2]]
max_crlbs <- dfCERCRLB == 999
CRLB_sum <- summary(dfCERCRLB)
dfCERCRLB <- dfCER * dfCERCRLB/100
dfCERCRLB <- 1/dfCERCRLB
dfCERCRLB[max_crlbs] = 1/999
colnames(dfCERCRLB) <- paste(colnames(dfCERCRLB),'CRLB',sep='_')
dfCER <- spvs_AddStatsToDataframe(dfCER,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfCER$ammonia <- dfClinicAll$ammonia
dfCER$GOT <- dfClinicAll$GOT
dfCER <- bind_cols(dfCER,dfCERCRLB)
#Remove outlier
# dfCER <- dfCER[-c(1,4,6,11,13,17,20,35,36,37,38),]
dfCER <- dfCER[-c(6,17,34,35,36,37),]

dfCERCon <- subset(dfCER, numGroup == 1)
dfCERmHE <- subset(dfCER, numGroup == 2)
dfCERHE <- subset(dfCER, numGroup == 3)

dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERHE),c('A-con','C-HE'))
Exp_CER_off_cr_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_Cr/Exp_CER_Cr_lm.txt')
Exp_CER_off_cr_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_Cr/Exp_CER_Cr_lm_age.txt','age')
Exp_CER_off_cr_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_Cr/Exp_CER_Cr_lm_CRLB.txt',weighting=invCRLBlist)
Exp_CER_off_cr_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_Cr/Exp_CER_Cr_lm_age_CRLB.txt','age',invCRLBlist)

dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERmHE,dfCERHE),c('A-con','B-mHE','C-HE'))
Exp_CER_off_cr_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/Exp_CER_CFF_lm.txt')
Exp_CER_off_cr_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/Exp_CER_CFF_lm_age.txt','age')
Exp_CER_off_cr_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/Exp_CER_CFF_lm_CRLB.txt',weighting=invCRLBlist)
Exp_CER_off_cr_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/Exp_CER_CFF_lm_age_CRLB.txt','age',invCRLBlist)

Exp_CER_off_cr_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/Exp_CER_PEG_lm.txt')
Exp_CER_off_cr_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/Exp_CER_PEG_lm_age.txt','age')
Exp_CER_off_cr_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/Exp_CER_PEG_lm_CRLB.txt',weighting=invCRLBlist)
Exp_CER_off_cr_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/Exp_CER_PEG_lm_age_CRLB.txt','age',invCRLBlist)

Exp_CER_off_cr_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/Exp_CER_ammonia_lm.txt')
Exp_CER_off_cr_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/Exp_CER_ammonia_lm_age.txt','age')
Exp_CER_off_cr_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/Exp_CER_ammonia_lm_CRLB.txt',weighting=invCRLBlist)
Exp_CER_off_cr_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_Cr/Exp_CER_ammonia_lm_age_CRLB.txt','age',invCRLBlist)


#Correlation plots GABA THA

listTHA <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/THA/LCMOutput_A_sep')
dfTHA <- listTHA[[1]]
dfTHACRLB <- listTHA[[2]]
CRLB_sum <- summary(dfTHACRLB)
max_crlbs <- dfTHACRLB == 999
dfTHACRLB <- dfTHA * dfTHACRLB/100
dfTHACRLB <- 1/dfTHACRLB
dfTHACRLB[max_crlbs] = 1/999
colnames(dfTHACRLB) <- paste(colnames(dfTHACRLB),'CRLB',sep='_')
dfTHA <- spvs_AddStatsToDataframe(dfTHA,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfTHA$ammonia <- dfClinicAll$ammonia
dfTHA <- bind_cols(dfTHA,dfTHACRLB)

#Remove outlier
# dfTHA <- dfTHA[-c(1,2,12,21),]
dfTHA <- dfTHA[-c(2,28,34,35,36,37),]

dfTHACon <- subset(dfTHA, numGroup == 1)
dfTHAmHE <- subset(dfTHA, numGroup == 2)
dfTHAHE <- subset(dfTHA, numGroup == 3)

dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAHE),c('A-con','C-HE'))
Exp_THA_off_cr_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_Cr/Exp_THA_Cr_lm.txt')
Exp_THA_off_cr_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_Cr/Exp_THA_Cr_lm_age.txt','age')
Exp_THA_off_cr_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_Cr/Exp_THA_Cr_lm_CRLB.txt',weighting=invCRLBlist)
Exp_THA_off_cr_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_Cr/Exp_THA_Cr_lm_age_CRLB.txt','age',invCRLBlist)

dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAmHE,dfTHAHE),c('A-con','B-mHE','C-HE'))
Exp_THA_off_cr_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/Exp_THA_CFF_lm.txt')
Exp_THA_off_cr_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/Exp_THA_CFF_lm_age.txt','age')
Exp_THA_off_cr_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/Exp_THA_CFF_lm_CRLB.txt',weighting=invCRLBlist)
Exp_THA_off_cr_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/Exp_THA_CFF_lm_age_CRLB.txt','age',invCRLBlist)

Exp_THA_off_cr_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/Exp_THA_PEG_lm.txt')
Exp_THA_off_cr_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/Exp_THA_PEG_lm_age.txt','age')
Exp_THA_off_cr_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/Exp_THA_PEG_lm_CRLB.txt',weighting=invCRLBlist)
Exp_THA_off_cr_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/Exp_THA_PEG_lm_age_CRLB.txt','age',invCRLBlist)

Exp_THA_off_cr_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/Exp_THA_ammonia_lm.txt')
Exp_THA_off_cr_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/Exp_THA_ammonia_lm_age.txt','age')
Exp_THA_off_cr_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/Exp_THA_ammonia_lm_CRLB.txt',weighting=invCRLBlist)
Exp_THA_off_cr_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_Cr/Exp_THA_ammonia_lm_age_CRLB.txt','age',invCRLBlist)


#Correlation plots GABA MOT
listMOT <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/MOT/LCMOutput_A_sep')
dfMOT <- listMOT[[1]]
dfMOTCRLB <- listMOT[[2]]
CRLB_sum <- summary(dfMOTCRLB)
max_crlbs <- dfMOTCRLB == 999
dfMOTCRLB <- dfMOT * dfMOTCRLB/100
dfMOTCRLB <- 1/dfMOTCRLB
dfMOTCRLB[max_crlbs] = 1/999
colnames(dfMOTCRLB) <- paste(colnames(dfMOTCRLB),'CRLB',sep='_')
dfMOT <- spvs_AddStatsToDataframe(dfMOT,'/Volumes/Elements/working/GABA_HE/statMOT.csv')
dfClinicAllred <- dfClinicAll[-c(21,32),]
dfMOT$ammonia <- dfClinicAllred$ammonia
dfMOT <- bind_cols(dfMOT,dfMOTCRLB)

#Remove outlier
# dfMOT <- dfMOT[-c(2,4,5,9,12,14,15,19,20,32),]
# dfMOT <- dfMOT[-c(2,4,5,9,12,13,14,15,19,20,32),]
#dfMOT <- dfMOT[-c(2,13,18,33,34,35,36,37),]
dfMOT <- dfMOT[-c(2,4,14,19,33,34,35,36,37),]

dfMOTCon <- subset(dfMOT, numGroup == 1)
dfMOTmHE <- subset(dfMOT, numGroup == 2)
dfMOTHE <- subset(dfMOT, numGroup == 3)

dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTHE),c('A-con','C-HE'))
Exp_MOT_off_cr_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_Cr/Exp_MOT_Cr_lm.txt')
Exp_MOT_off_cr_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_Cr/Exp_MOT_Cr_lm_age.txt','age')
Exp_MOT_off_cr_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_Cr/Exp_MOT_Cr_lm_CRLB.txt',weighting=invCRLBlist)
Exp_MOT_off_cr_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_Cr/Exp_MOT_Cr_lm_age_CRLB.txt','age',invCRLBlist)


dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTmHE,dfMOTHE),c('A-con','B-mHE','C-HE'))

Exp_MOT_off_cr_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/Exp_MOT_CFF_lm.txt')
Exp_MOT_off_cr_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/Exp_MOT_CFF_lm_age.txt','age')
Exp_MOT_off_cr_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/Exp_MOT_CFF_lm_CRLB.txt',weighting=invCRLBlist)
Exp_MOT_off_cr_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/Exp_MOT_CFF_lm_age_CRLB.txt','age',invCRLBlist)

Exp_MOT_off_cr_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/Exp_MOT_PEG_lm.txt')
Exp_MOT_off_cr_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/Exp_MOT_PEG_lm_age.txt','age')
Exp_MOT_off_cr_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/Exp_MOT_PEG_lm_CRLB.txt',weighting=invCRLBlist)
Exp_MOT_off_cr_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/Exp_MOT_PEG_lm_age_CRLB.txt','age',invCRLBlist)

Exp_MOT_off_cr_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/Exp_MOT_ammonia_lm.txt')
Exp_MOT_off_cr_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/Exp_MOT_ammonia_lm_age.txt','age')
Exp_MOT_off_cr_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/Exp_MOT_ammonia_lm_CRLB.txt',weighting=invCRLBlist)
Exp_MOT_off_cr_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_Cr/Exp_MOT_ammonia_lm_age_CRLB.txt','age',invCRLBlist)



# i.u.
listCER <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/CER/LCMOutput_A_sep','water')
dfCER <- listCER[[1]]
dfCERCRLB <- listCER[[2]]
CRLB_sum <- summary(dfCERCRLB)
max_crlbs <- dfCERCRLB == 999
dfCER <- spvs_AddStatsToDataframe(dfCER,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfCER$ammonia <- dfClinicAll$ammonia
dfCER$WM <- dfCERdiff$WM
dfCER$GM <- dfCERdiff$GM
dfCER$CSF <- dfCERdiff$CSF
dfCER <- spvs_TissueCorr(dfCER,.068,1.750,.068,1.750)
for (i in colnames(dfCERCRLB)){
  if (i %in% colnames(dfCER)){
    dfCERCRLB[[i]] <- dfCER[[i]] * dfCERCRLB[[i]]/100}
}
dfCERCRLB <- 1/dfCERCRLB
colnames(dfCERCRLB) <- paste(colnames(dfCERCRLB),'CRLB',sep='_')
dfCERCRLB[max_crlbs] = 1/999
dfCER <- bind_cols(dfCER,dfCERCRLB)
#Remove outlier
# dfCER <- dfCER[-c(1,4,6,11,13,17,20,35,36,37,38),]
#dfCER <- dfCER[-c(4,6,17,18,20,32,35,37,38),]
dfCER <- dfCER[-c(6,17,32,34,35,37,38),]

dfCERCon <- subset(dfCER, numGroup == 1)
dfCERmHE <- subset(dfCER, numGroup == 2)
dfCERHE <- subset(dfCER, numGroup == 3)

dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERHE),c('A-con','C-HE'))

Exp_CER_off_iu_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_iu/Exp_CER_iu_lm.txt')
Exp_CER_off_iu_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_iu/Exp_CER_iu_lm_age.txt','age')
Exp_CER_off_iu_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_iu/Exp_CER_iu_lm_CRLB.txt',weighting=invCRLBlist)
Exp_CER_off_iu_p <- spvs_lm_group(dfCER,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/CER_OFF_iu/Exp_CER_iu_lm_age_CRLB.txt','age',invCRLBlist)


dfCER <- spvs_ConcatenateDataFrame(list(dfCERCon,dfCERmHE,dfCERHE),c('A-con','B-mHE','C-HE'))

Exp_CER_off_iu_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/Exp_CER_CFF_lm_iu.txt')
Exp_CER_off_iu_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/Exp_CER_CFF_lm_age_iu.txt','age')
Exp_CER_off_iu_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/Exp_CER_CFF_lm_CRLB_iu.txt',weighting=invCRLBlist)
Exp_CER_off_iu_p_CFF <- spvs_part_corr(dfCER,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/Exp_CER_CFF_lm_age_CRLB_iu.txt','age',invCRLBlist)

Exp_CER_off_iu_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/Exp_CER_PEG_lm_iu.txt')
Exp_CER_off_iu_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/Exp_CER_PEG_lm_age_iu.txt','age')
Exp_CER_off_iu_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/Exp_CER_PEG_lm_CRLB_iu.txt',weighting=invCRLBlist)
Exp_CER_off_iu_p_PEG <- spvs_part_corr(dfCER,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/Exp_CER_PEG_lm_age_CRLB_iu.txt','age',invCRLBlist)

Exp_CER_off_iu_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/Exp_CER_ammonia_lm_iu.txt')
Exp_CER_off_iu_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/Exp_CER_ammonia_lm_age_iu.txt','age')
Exp_CER_off_iu_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/Exp_CER_ammonia_lm_CRLB_iu.txt',weighting=invCRLBlist)
Exp_CER_off_iu_p_NH3 <- spvs_part_corr(dfCER,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/CER_OFF_iu/Exp_CER_ammonia_lm_age_CRLB_iu.txt','age',invCRLBlist)


#Correlation plots GABA THA

listTHA <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/THA/LCMOutput_A_sep','water')
dfTHA <- listTHA[[1]]
dfTHACRLB <- listTHA[[2]]
CRLB_sum <- summary(dfTHACRLB)
max_crlbs <- dfTHACRLB == 999
dfTHA <- spvs_AddStatsToDataframe(dfTHA,'/Volumes/Elements/working/GABA_HE/statFull.csv')
dfTHA$ammonia <- dfClinicAll$ammonia
dfTHAdiff <- read.csv('/Volumes/Elements/working/GABA_HE/GannetTHA.csv', header = TRUE,stringsAsFactors = FALSE,check.names=FALSE)
dfTHA$WM <- dfTHAdiff$WM
dfTHA$GM <- dfTHAdiff$GM
dfTHA$CSF <- dfTHAdiff$CSF
dfTHA <- spvs_TissueCorr(dfTHA,.068,1.750,.068,1.750)
for (i in colnames(dfTHACRLB)){
  if (i %in% colnames(dfTHA)){
    dfTHACRLB[[i]] <- dfTHA[[i]] * dfTHACRLB[[i]]/100}
}
dfTHACRLB <- 1/dfTHACRLB
dfTHACRLB[max_crlbs] = 1/999
colnames(dfTHACRLB) <- paste(colnames(dfTHACRLB),'CRLB',sep='_')
dfTHA <- bind_cols(dfTHA,dfTHACRLB)
#Remove outlier
# dfTHA <- dfTHA[-c(1,2,12,21),]
#dfTHA <- dfTHA[-c(1,2,12,21,28,36),]
dfTHA <- dfTHA[-c(2,28,34,35,36,37),]

dfTHACon <- subset(dfTHA, numGroup == 1)
dfTHAmHE <- subset(dfTHA, numGroup == 2)
dfTHAHE <- subset(dfTHA, numGroup == 3)

dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAHE),c('A-con','C-HE'))

Exp_THA_off_iu_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_iu/Exp_THA_iu_lm.txt')
Exp_THA_off_iu_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_iu/Exp_THA_iu_lm_age.txt','age')
Exp_THA_off_iu_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_iu/Exp_THA_iu_lm_CRLB.txt',weighting=invCRLBlist)
Exp_THA_off_iu_p <- spvs_lm_group(dfTHA,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/THA_OFF_iu/Exp_THA_iu_lm_age_CRLB.txt','age',invCRLBlist)

dfTHA <- spvs_ConcatenateDataFrame(list(dfTHACon,dfTHAmHE,dfTHAHE),c('A-con','B-mHE','C-HE'))

Exp_THA_off_iu_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/Exp_THA_CFF_lm_iu.txt')
Exp_THA_off_iu_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/Exp_THA_CFF_lm_age_iu.txt','age')
Exp_THA_off_iu_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/Exp_THA_CFF_lm_CRLB_iu.txt',weighting=invCRLBlist)
Exp_THA_off_iu_p_CFF <- spvs_part_corr(dfTHA,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/Exp_THA_CFF_lm_age_CRLB_iu.txt','age',invCRLBlist)

Exp_THA_off_iu_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/Exp_THA_PEG_lm_iu.txt')
Exp_THA_off_iu_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/Exp_THA_PEG_lm_age_iu.txt','age')
Exp_THA_off_iu_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/Exp_THA_PEG_lm_CRLB_iu.txt',weighting=invCRLBlist)
Exp_THA_off_iu_p_PEG <- spvs_part_corr(dfTHA,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/Exp_THA_PEG_lm_age_CRLB_iu.txt','age',invCRLBlist)

Exp_THA_off_iu_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/Exp_THA_ammonia_lm_iu.txt')
Exp_THA_off_iu_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/Exp_THA_ammonia_lm_age_iu.txt','age')
Exp_THA_off_iu_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/Exp_THA_ammonia_lm_CRLB_iu.txt',weighting=invCRLBlist)
Exp_THA_off_iu_p_NH3 <- spvs_part_corr(dfTHA,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/THA_OFF_iu/Exp_THA_ammonia_lm_age_CRLB_iu.txt','age',invCRLBlist)


#Correlation plots GABA MOT
listMOT <- spvs_importResults('/Volumes/Elements/working/GABA_HE/derivatives/MOT/LCMOutput_A_sep','water')
dfMOT <- listMOT[[1]]
dfMOTCRLB <- listMOT[[2]]
CRLB_sum <- summary(dfMOTCRLB)
max_crlbs <- dfMOTCRLB == 999
dfMOT <- spvs_AddStatsToDataframe(dfMOT,'/Volumes/Elements/working/GABA_HE/statMOT.csv')
#dfMOTdiffRed <- dfMOTdiff[-c(4),]
dfMOT$ammonia <- dfClinicMot$ammonia
dfMOT$WM <- dfMOTdiff$WM
dfMOT$GM <- dfMOTdiff$GM
dfMOT$CSF <- dfMOTdiff$CSF
dfMOT <- spvs_TissueCorr(dfMOT,.068,1.750,.068,1.750)
for (i in colnames(dfMOTCRLB)){
  if (i %in% colnames(dfMOT)){
    dfMOTCRLB[[i]] <- dfMOT[[i]] * dfMOTCRLB[[i]]/100}
}
dfMOTCRLB <- 1/dfMOTCRLB
dfMOTCRLB[max_crlbs] = 1/999
colnames(dfMOTCRLB) <- paste(colnames(dfMOTCRLB),'CRLB',sep='_')
dfMOT <- bind_cols(dfMOT,dfMOTCRLB)
#Remove outlier
# dfMOT <- dfMOT[-c(2,4,5,9,12,14,15,19,20,32),]
#dfMOT <- dfMOT[-c(2,4,5,9,12,13,14,15,19,20,32,37),]
dfMOT <- dfMOT[-c(2,4,14,19,33,34,35,36,37),]

dfMOTCon <- subset(dfMOT, numGroup == 1)
dfMOTmHE <- subset(dfMOT, numGroup == 2)
dfMOTHE <- subset(dfMOT, numGroup == 3)

dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTHE),c('A-con','C-HE'))

Exp_MOT_off_iu_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_iu/Exp_MOT_iu_lm.txt')
Exp_MOT_off_iu_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_iu/Exp_MOT_iu_lm_age.txt','age')
Exp_MOT_off_iu_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_iu/Exp_MOT_iu_lm_CRLB.txt',weighting=invCRLBlist)
Exp_MOT_off_iu_p <- spvs_lm_group(dfMOT,metablist,'/Volumes/Elements/working/GABA_HE/Figures/lmstats/MOT_OFF_iu/Exp_MOT_iu_lm_age_CRLB.txt','age',invCRLBlist)


dfMOT <- spvs_ConcatenateDataFrame(list(dfMOTCon,dfMOTmHE,dfMOTHE),c('A-con','B-mHE','C-HE'))


Exp_MOT_off_iu_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/Exp_MOT_CFF_lm_iu.txt')
Exp_MOT_off_iu_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/Exp_MOT_CFF_lm_age_iu.txt','age')
Exp_MOT_off_iu_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/Exp_MOT_CFF_lm_CRLB_iu.txt',weighting=invCRLBlist)
Exp_MOT_off_iu_p_CFF <- spvs_part_corr(dfMOT,metablist,'CFF','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/Exp_MOT_CFF_lm_age_CRLB_iu.txt','age',invCRLBlist)

Exp_MOT_off_iu_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/Exp_MOT_PEG_lm_iu.txt')
Exp_MOT_off_iu_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/Exp_MOT_PEG_lm_age_iu.txt','age')
Exp_MOT_off_iu_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/Exp_MOT_PEG_lm_CRLB_iu.txt',weighting=invCRLBlist)
Exp_MOT_off_iu_p_PEG <- spvs_part_corr(dfMOT,metablist,'PEG','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/Exp_MOT_PEG_lm_age_CRLB_iu.txt','age',invCRLBlist)

Exp_MOT_off_iu_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/Exp_MOT_ammonia_lm_iu.txt')
Exp_MOT_off_iu_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/Exp_MOT_ammonia_lm_age_iu.txt','age')
Exp_MOT_off_iu_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/Exp_MOT_ammonia_lm_CRLB_iu.txt',weighting=invCRLBlist)
Exp_MOT_off_iu_p_NH3 <- spvs_part_corr(dfMOT,metablist,'ammonia','/Volumes/Elements/working/GABA_HE/Figures/partialcorr/MOT_OFF_iu/Exp_MOT_ammonia_lm_age_CRLB_iu.txt','age',invCRLBlist)


text <- c('Scyllo_cr','Tau_cr',
          'Scyllo_cr_CFF','Tau_cr_CFF',
          'Scyllo_cr_CFF_Con','Tau_cr_CFF_Con',
          'Scyllo_cr_CFF_HE','Tau_cr_CFF_HE',
          'Scyllo_cr_PEG','Tau_cr_PEG',
          'Scyllo_cr_PEG_Con','Tau_cr_PEG_Con',
          'Scyllo_cr_PEG_HE','Tau_cr_PEG_HE',
          'Scyllo_cr_NH3','Tau_cr_NH3')


p <- c(Exp_CER_off_cr_p,Exp_CER_off_cr_p_CFF[[1]],Exp_CER_off_cr_p_PEG[[1]],Exp_CER_off_cr_p_NH3[[1]])
p <- data_frame(p)
colnames(p) <- 'p'
p <- p[-c(7,8,15,16,21,22,23,24,25,26),]
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/Exp_CER_off_cr_stat_pvalue_corr.txt')
print(p.fdr,n=length(text))
sink()

p <- c(Exp_THA_off_cr_p,Exp_THA_off_cr_p_CFF[[1]],Exp_THA_off_cr_p_PEG[[1]],Exp_THA_off_cr_p_NH3[[1]])
p <- data_frame(p)
colnames(p) <- 'p'
p <- p[-c(7,8,15,16,21,22,23,24,25,26),]
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/Exp_THA_off_cr_stat_pvalue_corr.txt')
print(p.fdr,n=length(text))
sink()

p <- c(Exp_MOT_off_cr_p,Exp_MOT_off_cr_p_CFF[[1]],Exp_MOT_off_cr_p_PEG[[1]],Exp_MOT_off_cr_p_NH3[[1]])
p <- data_frame(p)
colnames(p) <- 'p'
p <- p[-c(15,16,17,18),]
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/Exp_MOT_off_cr_stat_pvalue_corr.txt')
print(p.fdr,n=length(text))
sink()

text <- c('Scyllo_iu','Tau_iu',
          'Scyllo_iu_CFF','Tau_iu_CFF',
          'Scyllo_iu_CFF_Con','Tau_iu_CFF_Con',
          'Scyllo_iu_CFF_HE','Tau_iu_CFF_HE',
          'Scyllo_iu_PEG','Tau_iu_PEG',
          'Scyllo_iu_PEG_Con','Tau_iu_PEG_Con',
          'Scyllo_iu_PEG_HE','Tau_iu_PEG_HE',
          'Scyllo_iu_NH3','Tau_iu_NH3')


p <- c(Exp_CER_off_iu_p,Exp_CER_off_iu_p_CFF[[1]],Exp_CER_off_iu_p_PEG[[1]],Exp_CER_off_iu_p_NH3[[1]])
p <- data_frame(p)
colnames(p) <- 'p'
p <- p[-c(15,16,17,18),]
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/Exp_CER_off_iu_stat_pvalue_corr.txt')
print(p.fdr,n=length(text))
sink()

p <- c(Exp_THA_off_iu_p,Exp_THA_off_iu_p_CFF[[1]],Exp_THA_off_iu_p_PEG[[1]],Exp_THA_off_iu_p_NH3[[1]])
p <- data_frame(p)
colnames(p) <- 'p'
p <- p[-c(7,8,15,16,21,22,23,24,25,26),]
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/Exp_THA_off_iu_stat_pvalue_corr.txt')
print(p.fdr,n=length(text))
sink()

p <- c(Exp_MOT_off_iu_p,Exp_MOT_off_iu_p_CFF[[1]],Exp_MOT_off_iu_p_PEG[[1]],Exp_MOT_off_iu_p_NH3[[1]])
p <- data_frame(p)
colnames(p) <- 'p'
p <- p[-c(15,16,17,18),]
p.fdr <-data_frame(p = p$p) %>% mutate(p.fdr = p.adjust(p, method="fdr"),p.sig = ifelse(p < .05, ifelse(p < .01, ifelse(p < .001, "***", "**"), "*"), ""),p.fdr.sig = ifelse(p.fdr < .05, ifelse(p.fdr < .01, ifelse(p.fdr < .001, "***", "**"), "*"), ""))
p.fdr$name <- text
sink('/Volumes/Elements/working/GABA_HE/Figures/Exp_MOT_off_iu_stat_pvalue_corr.txt')
print(p.fdr,n=length(text))
sink()

