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

dfPRESS <- spvs_importResults('/Volumes/Samsung_T5/working/PRESS_HERM_HERC/press_sep/QuantifyResults/off_tCr.csv')
dfHERMsum <- spvs_importResults('/Volumes/Samsung_T5/working/PRESS_HERM_HERC/herm_sep/QuantifyResults/sum_tCr.csv')
dfHERCsum <- spvs_importResults('/Volumes/Samsung_T5/working/PRESS_HERM_HERC/herc_sep/QuantifyResults/sum_tCr.csv')
dfHERMdiff1 <- spvs_importResults('/Volumes/Samsung_T5/working/PRESS_HERM_HERC/herm_sep/QuantifyResults/diff1_tCr.csv')
dfHERCdiff1 <- spvs_importResults('/Volumes/Samsung_T5/working/PRESS_HERM_HERC/herc_sep/QuantifyResults/diff1_tCr.csv')
dfHERMdiff2 <- spvs_importResults('/Volumes/Samsung_T5/working/PRESS_HERM_HERC/herm_sep/QuantifyResults/diff2_tCr.csv')
dfHERCdiff2 <- spvs_importResults('/Volumes/Samsung_T5/working/PRESS_HERM_HERC/herc_sep/QuantifyResults/diff2_tCr.csv')
dfHERMconc <- spvs_importResults('/Volumes/Samsung_T5/working/PRESS_HERM_HERC/herm_con/QuantifyResults/conc_tCr.csv')
dfHERCconc <- spvs_importResults('/Volumes/Samsung_T5/working/PRESS_HERM_HERC/herc_con/QuantifyResults/conc_tCr.csv')

dfHERMsep <- dfHERMconc
dfHERCsep <- dfHERCconc

dfHERMsep$Asc <- dfHERMsum$Asc
dfHERMsep$Asp <- dfHERMsum$Asp
dfHERMsep$GSH <- dfHERMdiff2$GSH
dfHERMsep$NAAG <- dfHERMsum$NAAG
dfHERMsep$GABA <- dfHERMdiff1$GABA
dfHERMsep$Lac <- dfHERMsum$Lac
dfHERMsep$NAA <- dfHERMsum$NAA
dfHERMsep$tCho <- dfHERMsum$tCho
dfHERMsep$Ins <- dfHERMsum$Ins
dfHERMsep$Glu <- dfHERMsum$Glu
dfHERMsep$Gln <- dfHERMsum$Gln
dfHERMsep$Glx <- dfHERMsum$Glx

dfHERCsep$Asc <- dfHERCdiff2$Asc
dfHERCsep$Asp <- dfHERCdiff2$Asp
dfHERCsep$GSH <- dfHERCdiff2$GSH
dfHERCsep$NAAG <- dfHERCdiff2$NAAG
dfHERCsep$GABA <- dfHERCdiff1$GABA
dfHERCsep$Lac <- dfHERCdiff2$Lac
dfHERCsep$NAA <- dfHERCsum$NAA
dfHERCsep$tCho <- dfHERCsum$tCho
dfHERCsep$Ins <- dfHERCsum$Ins
dfHERCsep$Glu <- dfHERCsum$Glu
dfHERCsep$Gln <- dfHERCsum$Gln
dfHERCsep$Glx <- dfHERCsum$Glx


dfallData <- spvs_ConcatenateDataFrame(list(dfPRESS,dfHERMsep,dfHERCsep,dfHERMconc,dfHERCconc),c('PRESS','HERMESsep','HERCsep','HERMESconc','HERCconc'))

dfredData <- spvs_ConcatenateDataFrame(list(dfPRESS,dfHERMconc,dfHERCconc),c('PRESS','HERMESconc','HERCconc'))


lowerLimit <- c(0.75,.05,0.4,0.75)
upperLimit <- c(2.1,0.33,1.22,2.75)
color <- brewer.pal(8, 'Paired')
ToolColorMap <- c(color[6],color[2],color[4])

pAlledited <- spvs_RainCloud(dfallData, '/ [tCr]',list('GABA','GSH','Asc','Asp','NAAG','Lac'),c('Group'),title=c(""),colNum=3)
pAllunedited <- spvs_RainCloud(dfallData, '/ [tCr]',list('NAA','tCho','Ins','Glu','Gln','Glx'),c('Group'),title=c(""),colNum=3)

ggsave(file="RaincloudEdited.pdf", pAlledited, width = 10, height = 10,device=cairo_pdf) #saves g
ggsave(file="RaincloudUnEdited.pdf", pAllunedited, width = 10, height = 10,device=cairo_pdf) #saves g

dfPRESSini <- dfPRESS[seq(1, nrow(dfPRESS), 2), ] 
dfPRESSrep <- dfPRESS[seq(2, nrow(dfPRESS), 2), ] 
dfHERMsepini <- dfHERMsep[seq(1, nrow(dfHERMsep), 2), ] 
dfHERMseprep <- dfHERMsep[seq(2, nrow(dfHERMsep), 2), ] 
dfHERMconcini <- dfHERMconc[seq(1, nrow(dfHERMconc), 2), ] 
dfHERMconcrep <- dfHERMconc[seq(2, nrow(dfHERMconc), 2), ] 
dfHERCsepini <- dfHERCsep[seq(1, nrow(dfHERCsep), 2), ] 
dfHERCseprep <- dfHERCsep[seq(2, nrow(dfHERCsep), 2), ] 
dfHERCconcini <- dfHERCconc[seq(1, nrow(dfHERCconc), 2), ] 
dfHERCconcrep <- dfHERCconc[seq(2, nrow(dfHERCconc), 2), ] 

p1 <- spvs_BlandAltman(list(dfPRESSini,dfPRESSrep,dfHERMsepini,dfHERMseprep,dfHERCsepini,dfHERCseprep)," / [tCr]",c('GABA','GSH','Asc','Asp','NAAG','Lac'),c('Ini','Ini','Ini','Rep','Rep','Rep'),c('PRESS','HERMESsep','HERCsep','PRESS','HERMESsep','HERCsep'),NULL,NULL,NULL, 3)
p2 <- spvs_BlandAltman(list(dfPRESSini,dfPRESSrep,dfHERMconcini,dfHERMconcrep,dfHERCconcini,dfHERCconcrep)," / [tCr]",c('GABA','GSH','Asc','Asp','NAAG','Lac'),c('Ini','Ini','Ini','Rep','Rep','Rep'),c('PRESS','HERMESconc','HERCconc','PRESS','HERMESconc','HERCconc'),NULL,NULL,NULL, 3)

ggsave(file="BlandAltmanCollapsed.pdf", p4, width = 10, height = 10,device=cairo_pdf) #saves g


