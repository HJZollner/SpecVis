### This is the R analysis script for the manuscript: 
# Comparison of linear-combination modeling strategies for GABA-edited MRS at 3T
# Here the creatine ratios for the different metabolites GABA+, GABA, MM3co, and homocarnosine are
# calcualted. Addtionally, statistical testing, violin plots,  CV and SD outputs are generated.
# The correlation analysis between the results with a basis set with and without homocarnosine
# are generated in the end
# Source the needed functions ---------------------------------------------------------------
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

# Load creatine values from 0.4 ppm knot spacing and full fit range ---------------------------------------------------------------
dfMMpar <- read.csv('/Volumes/Samsung/working/editedMM/derivatives/BigGABAdefault/QuantifyResults/diff1_tCr_Voxel_1_Basis_1.tsv', header = TRUE,stringsAsFactors = FALSE,sep='\t')
dfMMpar <- spvs_AddStatsToDataframe(dfMMpar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')


dfMMexp <- read.csv('/Volumes/Samsung/working/editedMM/derivatives/BigGABAMMexp/QuantifyResults/diff1_tCr_Voxel_1_Basis_1.tsv', header = TRUE,stringsAsFactors = FALSE,sep='\t')
dfMMexp <- spvs_AddStatsToDataframe(dfMMexp,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
dfMMexp$GABAplus <- dfMMexp$GABA + (dfMMexp$MMexp/3)
dfMMexp$GABAplus <- dfMMexp$GABAplus

dfModels <- spvs_ConcatenateDataFrame(list(dfMMpar,dfMMexp),c('A-MMpar','B-MMexp'))

lowerLimit <- c(0,0)
upperLimit <- c(0.3,0.3)
color_data <- brewer.pal(10, 'Paired');
color_series <- brewer.pal(7,'Blues');
ToolColorMap <- c(color_data[4],color_series[7])

pGABA <- spvs_RainCloud(dfModels, '/ [tCr]',list('GABAplus','GABA'),c('Group'),lowerLimit,upperLimit,c(""),1,1)
pGABA <- pGABA + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pGABA
ggsave(file=paste('/Volumes/Samsung/working/editedMM/figures/', 'RainCloud.pdf',sep=''), pGABA, width = 5, height = 7.5,device=cairo_pdf) #saves g

pGABA <- spvs_RainCloud(dfModels, '/ [tCr]',list('GABAplus','GABA'),c('Group'),lowerLimit,upperLimit,c(""),1,2)
pGABA <- pGABA + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pGABA
ggsave(file=paste('/Volumes/Samsung/working/editedMM/figures/', 'RainCloudSD.pdf',sep=''), pGABA, width = 5, height = 7.5,device=cairo_pdf) #saves g


lowerLimit <- c(0,0)
upperLimit <- c(0.6,0.3)
p <- spvs_Correlation(list(dfMMpar,dfMMexp)," / [tCr]",c("GABAplus","GABA"),c('MMpar','MMexp'),c('',''), NULL,lowerLimit,upperLimit,2, 1)
ggsave(file=paste('/Volumes/Samsung/working/editedMM/figures/', 'Correlation.pdf',sep=''), p, width = 5, height = 7.5,device=cairo_pdf) #saves g


stats <- spvs_Statistics(dfModels,list('GABAplus','GABA'),1)
sink('/Volumes/Samsung/working/editedMM/figures/StatisticsG.txt')
print(stats)
sink()

# Load creatine values from 0.4 ppm knot spacing and full fit range ---------------------------------------------------------------
dfMMpar <- read.csv('/Volumes/Samsung/working/editedMM/SecondaryAnalysis/ResidualAnalysisMMpar.csv', header = TRUE,stringsAsFactors = FALSE)
dfMMpar <- spvs_AddStatsToDataframe(dfMMpar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')

dfMMexp <- read.csv('/Volumes/Samsung/working/editedMM/SecondaryAnalysis/ResidualAnalysisMMexp.csv', header = TRUE,stringsAsFactors = FALSE)
dfMMexp <- spvs_AddStatsToDataframe(dfMMexp,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')


dfModels <- spvs_ConcatenateDataFrame(list(dfMMpar,dfMMexp),c('A-MMpar','B-MMexp'))

lowerLimit <- c(0,0)
upperLimit <- c(0.025,0.025)
color_data <- brewer.pal(10, 'Paired');
color_series <- brewer.pal(7,'Blues');
ToolColorMap <- c(color_data[4],color_series[7])

pGABA <- spvs_RainCloud(dfModels, '/ [tCr]',list('ResRelAmpl','ResSD'),c('Group'),lowerLimit,upperLimit,c(""),1,2)
pGABA <- pGABA + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pGABA
ggsave(file=paste('/Volumes/Samsung/working/editedMM/figures/', 'RainCloudResidual.pdf',sep=''), pGABA, width = 5, height = 7.5,device=cairo_pdf) #saves g


stats <- spvs_Statistics(dfModels,list('ResRelAmpl','ResSD'),1)
sink('/Volumes/Samsung/working/editedMM/figures/Statistics.txt')
print(stats)
sink()


dfCorr <- read.csv('/Volumes/Samsung/working/editedMM/SecondaryAnalysis/Corr.csv', header = TRUE,stringsAsFactors = FALSE)
dfCorr <- spvs_AddStatsToDataframe(dfCorr,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')


lowerLimit <- c(0,0)
upperLimit <- c(0.025,0.025)
color_data <- brewer.pal(10, 'Paired');
color_series <- brewer.pal(7,'Blues');
ToolColorMap <- c(color_data[4],color_series[7])

pGABA <- spvs_RainCloud(dfCorr, '/ [tCr]',list('MM_corr','MM_ICC'),NULL,lowerLimit,upperLimit,c(""),1,2)
pGABA <- pGABA + scale_color_manual(values = ToolColorMap)+scale_fill_manual(values = ToolColorMap)
pGABA
ggsave(file=paste('/Volumes/Samsung/working/editedMM/figures/', 'RainCloudCorr.pdf',sep=''), pGABA, width = 5, height = 7.5,device=cairo_pdf) #saves g
