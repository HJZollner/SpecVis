### This is the R analysis script for the manuscript: 

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


# Manuscript code ---------------------------------------------------------

dfFrac <- read.csv('/Volumes/Samsung/working/IDEAL/Frac_D.csv', header = TRUE,stringsAsFactors = FALSE)
dfCV <- read.csv('/Volumes/Samsung/working/IDEAL/Frac_D_CV.csv', header = TRUE,stringsAsFactors = FALSE)
dfCV[,1:8]<- dfCV[,1:8] * 100

lowerLimit <- c(0,0,0,0,0,0)
upperLimit <- c(25,50,60,25,50,120)
color_data <- c(rgb(  0.1059,0.6196,0.4667, maxColorValue = 1),       # . RGB values
        rgb(0.9059,0.1608,0.5412, maxColorValue = 1))



pCV <- spvs_Boxplot(dfCV, '',list('C_fslow','M_fslow','C_finter','M_finter','C_ffast','M_ffast'),c('Group'),lowerLimit,upperLimit,c(""),3,1)
pCV <- pCV + scale_color_manual(values = color_data)+scale_fill_manual(values = color_data)
pCV
ggsave(file=paste('/Volumes/Samsung/working/IDEAL/figures/', 'CVs.pdf',sep=''), pCV, width = 20, height = 10,device=cairo_pdf) #saves g

lowerLimit <- c(0,0)
upperLimit <- c(15,15)

pCV2 <- spvs_Boxplot(dfCV, '',list('C_Dslow','M_Dslow'),c('Group'),lowerLimit,upperLimit,c(""),2,1)
pCV2 <- pCV2 + scale_color_manual(values = color_data)+scale_fill_manual(values = color_data)
pCV2
ggsave(file=paste('/Volumes/Samsung/working/IDEAL/figures/', 'CV2s.pdf',sep=''), pCV2, width = 20 *2/3, height = 10,device=cairo_pdf) #saves g

lowerLimit <- c(0,0,0,0,0,0)
upperLimit <- c(1,1,1,1,1,1)


pFrac <- spvs_Boxplot(dfFrac, '',list('C_fslow','C_finter','C_ffast','M_fslow','M_finter','M_ffast'),c('Group'),lowerLimit,upperLimit,c(""),3,1)
pFrac <- pFrac + scale_color_manual(values = color_data)+scale_fill_manual(values = color_data)
pFrac
ggsave(file=paste('/Volumes/Samsung/working/IDEAL/figures/', 'frac.pdf',sep=''), pFrac, width = 20, height = 10,device=cairo_pdf) #saves g

lowerLimit <- c(0.0010,0.0010)
upperLimit <- c(0.0020,0.0020)


pFrac <- spvs_Boxplot(dfFrac, '',list('C_Dslow','M_Dslow'),c('Group'),lowerLimit,upperLimit,c(""),2,1)
pFrac <- pFrac + scale_color_manual(values = color_data)+scale_fill_manual(values = color_data)
pFrac
ggsave(file=paste('/Volumes/Samsung/working/IDEAL/figures/', 'D.pdf',sep=''), pFrac, width = 20 *2/3, height = 10,device=cairo_pdf) #saves g


stats <- spvs_Statistics(dfFrac,list('C_fslow','M_fslow','C_finter','M_finter','C_ffast','M_ffast'),1)
sink(paste('/Volumes/Samsung/working/IDEAL/figures' ,'Statistics.txt',sep='/'))
print(stats)
sink()

stats <- spvs_Statistics(dfCV,list('C_fslow','M_fslow','C_finter','M_finter','C_ffast','M_ffast','C_Dslow','M_Dslow'),1)
sink(paste('/Volumes/Samsung/working/IDEAL/figures' ,'StatisticsCV.txt',sep='/'))
print(stats)
sink()


dfGlobalC <- data.frame(matrix(ncol = 4, nrow = 9))
dfGlobalM <- data.frame(matrix(ncol = 4, nrow = 9))
dfIdealC <- data.frame(matrix(ncol = 4, nrow = 9))
dfIdealM <- data.frame(matrix(ncol = 4, nrow = 9))

colnames(dfGlobalC) <- c('fslow', 'finterm', 'ffast', 'Dslow')
colnames(dfGlobalM) <- c('fslow', 'finterm', 'ffast', 'Dslow')
colnames(dfIdealC) <- c('fslow', 'finterm', 'ffast', 'Dslow')
colnames(dfIdealM) <- c('fslow', 'finterm', 'ffast', 'Dslow')

dfGlobalC$fslow <-dfFrac[1:9,1]
dfGlobalC$finterm <-dfFrac[1:9,2]
dfGlobalC$ffast <-dfFrac[1:9,3]
dfGlobalC$Dslow <-dfFrac[1:9,7]
dfGlobalM$fslow <-dfFrac[1:9,4]
dfGlobalM$finterm <-dfFrac[1:9,5]
dfGlobalM$ffast <-dfFrac[1:9,6]
dfGlobalM$Dslow <-dfFrac[1:9,8]

dfIdealC$fslow <-dfFrac[10:18,1]
dfIdealC$finterm <-dfFrac[10:18,2]
dfIdealC$ffast <-dfFrac[10:18,3]
dfIdealC$Dslow <-dfFrac[10:18,7]
dfIdealM$fslow <-dfFrac[10:18,4]
dfIdealM$finterm <-dfFrac[10:18,5]
dfIdealM$ffast <-dfFrac[10:18,6]
dfIdealM$Dslow <-dfFrac[10:18,8]

dfGlobalContrast <- spvs_ConcatenateDataFrame(list(dfGlobalC,dfGlobalM),c('A-Cortex','B-Medulla'))
dfIdealContrast <- spvs_ConcatenateDataFrame(list(dfIdealC,dfIdealM),c('A-Cortex','B-Medulla'))

stats <- spvs_Statistics(dfGlobalContrast,list('fslow', 'finterm', 'ffast', 'Dslow'),0)
sink(paste('/Volumes/Samsung/working/IDEAL/figures' ,'StatisticsContrast_fixedD.txt',sep='/'))
print(stats)
sink()

stats <- spvs_Statistics(dfIdealContrast,list('fslow', 'finterm', 'ffast', 'Dslow'),0)
sink(paste('/Volumes/Samsung/working/IDEAL/figures' ,'StatisticsContrast_IDEAL.txt',sep='/'))
print(stats)
sink()


# Bi exponential fit ------------------------------------------------------

dfFrac <- read.csv('/Volumes/Samsung/working/IDEAL/Frac_D_bi.csv', header = TRUE,stringsAsFactors = FALSE)
dfCV <- read.csv('/Volumes/Samsung/working/IDEAL/Frac_D_CV_bi.csv', header = TRUE,stringsAsFactors = FALSE)
dfCV[,1:8]<- dfCV[,1:8] * 100

lowerLimit <- c(0,0,0,0)
upperLimit <- c(6,65,6,65)
#'M_fslow','M_ffast','C_fslow','C_ffast'
color_data <- c(rgb(  0.1059,0.6196,0.4667, maxColorValue = 1),       # . RGB values
                rgb(0.9059,0.1608,0.5412, maxColorValue = 1))



pCV <- spvs_Boxplot(dfCV, '',list('C_fslow','M_fslow','C_ffast','M_ffast'),c('Group'),lowerLimit,upperLimit,c(""),2,1)
pCV <- pCV + scale_color_manual(values = color_data)+scale_fill_manual(values = color_data)
pCV
ggsave(file=paste('/Volumes/Samsung/working/IDEAL/figures/', 'CVs_bi.pdf',sep=''), pCV, width = 20, height = 10,device=cairo_pdf) #saves g

lowerLimit <- c(0,0,0,0)
upperLimit <- c(400,400,7,7)
# M_Dslow M_Dfast C_Dslow C_Dfast
pCV2 <- spvs_Boxplot(dfCV, '',list('C_Dslow','M_Dslow','C_Dfast','M_Dfast'),c('Group'),lowerLimit,upperLimit,c(""),2,1)
pCV2 <- pCV2 + scale_color_manual(values = color_data)+scale_fill_manual(values = color_data)
pCV2
ggsave(file=paste('/Volumes/Samsung/working/IDEAL/figures/', 'CV2s_bi.pdf',sep=''), pCV2, width = 20 *2/3, height = 10,device=cairo_pdf) #saves g

lowerLimit <- c(0,0,0,0)
upperLimit <- c(1,1,1,1)


pFrac <- spvs_Boxplot(dfFrac, '',list('C_fslow','M_fslow','C_ffast','M_ffast'),c('Group'),lowerLimit,upperLimit,c(""),2,1)
pFrac <- pFrac + scale_color_manual(values = color_data)+scale_fill_manual(values = color_data)
pFrac
ggsave(file=paste('/Volumes/Samsung/working/IDEAL/figures/', 'frac_bi.pdf',sep=''), pFrac, width = 20, height = 10,device=cairo_pdf) #saves g

lowerLimit <- c(0.0014,0.0010,0.0014,0.0010)
upperLimit <- c(0.00225,0.07,0.00225,0.07)
# M_Dslow M_Dfast C_Dslow C_Dfast

pFrac <- spvs_Boxplot(dfFrac, '',list('C_Dslow','M_Dslow','C_Dfast','M_Dfast'),c('Group'),lowerLimit,upperLimit,c(""),2,1)
pFrac <- pFrac + scale_color_manual(values = color_data)+scale_fill_manual(values = color_data)
pFrac
ggsave(file=paste('/Volumes/Samsung/working/IDEAL/figures/', 'D_bi.pdf',sep=''), pFrac, width = 20 *2/3, height = 10,device=cairo_pdf) #saves g


stats <- spvs_Statistics(dfFrac,list('C_fslow','M_fslow','C_ffast','M_ffast','C_Dslow','M_Dslow','C_Dfast','M_Dfast'),1)
sink(paste('/Volumes/Samsung/working/IDEAL/figures' ,'Statistics_bi.txt',sep='/'))
print(stats)
sink()

stats <- spvs_Statistics(dfCV,list('C_fslow','M_fslow','C_ffast','M_ffast','C_Dslow','M_Dslow','C_Dfast','M_Dfast'),1)
sink(paste('/Volumes/Samsung/working/IDEAL/figures' ,'StatisticsCV_bi.txt',sep='/'))
print(stats)
sink()


dfSegC <- data.frame(matrix(ncol = 4, nrow = 9))
dfSegM <- data.frame(matrix(ncol = 4, nrow = 9))
dfIdealC <- data.frame(matrix(ncol = 4, nrow = 9))
dfIdealM <- data.frame(matrix(ncol = 4, nrow = 9))

colnames(dfSegC) <- c('fslow', 'ffast', 'Dslow', 'Dfast')
colnames(dfSegM) <- c('fslow', 'ffast', 'Dslow', 'Dfast')
colnames(dfIdealC) <- c('fslow', 'ffast', 'Dslow', 'Dfast')
colnames(dfIdealM) <- c('fslow', 'ffast', 'Dslow', 'Dfast')

dfSegC$fslow <-dfFrac[1:9,1]
dfSegC$ffast <-dfFrac[1:9,2]
dfSegC$Dslow <-dfFrac[1:9,5]
dfSegC$Dfast <-dfFrac[1:9,7]
dfSegM$fslow <-dfFrac[1:9,3]
dfSegM$ffast <-dfFrac[1:9,4]
dfSegM$Dslow <-dfFrac[1:9,6]
dfSegM$Dfast <-dfFrac[1:9,8]

dfIdealC$fslow <-dfFrac[10:18,1]
dfIdealC$ffast <-dfFrac[10:18,2]
dfIdealC$Dslow <-dfFrac[10:18,5]
dfIdealC$Dfast <-dfFrac[10:18,7]
dfIdealM$fslow <-dfFrac[10:18,3]
dfIdealM$ffast <-dfFrac[10:18,4]
dfIdealM$Dslow <-dfFrac[10:18,6]
dfIdealM$Dfast <-dfFrac[10:18,8]

dfSegContrast <- spvs_ConcatenateDataFrame(list(dfSegC,dfSegM),c('A-Cortex','B-Medulla'))
dfIdealContrast <- spvs_ConcatenateDataFrame(list(dfIdealC,dfIdealM),c('A-Cortex','B-Medulla'))

stats <- spvs_Statistics(dfSegContrast,list('fslow', 'ffast', 'Dslow', 'Dfast'),0)
sink(paste('/Volumes/Samsung/working/IDEAL/figures' ,'StatisticsContrast_Seg_bi.txt',sep='/'))
print(stats)
sink()

stats <- spvs_Statistics(dfIdealContrast,list('fslow', 'ffast', 'Dslow', 'Dfast'),0)
sink(paste('/Volumes/Samsung/working/IDEAL/figures' ,'StatisticsContrast_IDEAL_bi.txt',sep='/'))
print(stats)
sink()
# Abstract code ---------------------------------------------------------------
dfCV <- read.csv('/Volumes/Samsung2/working/DWI_kidney/CVs.csv', header = TRUE,stringsAsFactors = FALSE)

lowerLimit <- c(0,0,0,0,0,0)
upperLimit <- c(0.25,0.65,1.55,0.25,0.65,1.55)
color_data <- brewer.pal(8, 'Dark2');


pCV <- spvs_Boxplot(dfCV, '',list('C_fslow','C_finter','C_ffast','M_fslow','M_finter','M_ffast'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pCV <- pCV + scale_color_manual(values = color_data)+scale_fill_manual(values = color_data)
pCV
ggsave(file=paste('/Volumes/Samsung2/working/DWI_kidney/', 'CVs.pdf',sep=''), pCV, width = 5, height = 30,device=cairo_pdf) #saves g

lowerLimit <- c(0,0)
upperLimit <- c(0.15,0.15)
color_data <- brewer.pal(8, 'Dark2');

pCV2 <- spvs_Boxplot(dfCV, '',list('C_Dslow','M_Dslow'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pCV2 <- pCV2 + scale_color_manual(values = color_data)+scale_fill_manual(values = color_data)
pCV2
ggsave(file=paste('/Volumes/Samsung2/working/DWI_kidney/', 'CV2s.pdf',sep=''), pCV2, width = 5, height = 10,device=cairo_pdf) #saves g


dfFrac <- read.csv('/Volumes/Samsung2/working/DWI_kidney/Frac_D.csv', header = TRUE,stringsAsFactors = FALSE)

lowerLimit <- c(0,0,0,0,0,0)
upperLimit <- c(0.8,0.8,0.8,0.8,0.8,0.8)
color_data <- brewer.pal(8, 'Dark2');


pFrac <- spvs_Boxplot(dfFrac, '',list('C_fslow','C_finter','C_ffast','M_fslow','M_finter','M_ffast'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pFrac <- pFrac + scale_color_manual(values = color_data)+scale_fill_manual(values = color_data)
pFrac
ggsave(file=paste('/Volumes/Samsung2/working/DWI_kidney/', 'frac.pdf',sep=''), pFrac, width = 5, height = 30,device=cairo_pdf) #saves g

lowerLimit <- c(0.0010,0.0010)
upperLimit <- c(0.0020,0.0020)
color_data <- brewer.pal(8, 'Dark2');


pFrac <- spvs_Boxplot(dfFrac, '',list('C_Dslow','M_Dslow'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pFrac <- pFrac + scale_color_manual(values = color_data)+scale_fill_manual(values = color_data)
pFrac
ggsave(file=paste('/Volumes/Samsung2/working/DWI_kidney/', 'D.pdf',sep=''), pFrac, width = 5, height = 10,device=cairo_pdf) #saves g




