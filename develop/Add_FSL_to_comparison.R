dfPhFSL <- spvs_importResults('/Users/helge/Downloads/results_FSL 2/resultsFSL_MH/Ph_off_tCr.csv')
dfSiFSL <- spvs_importResults('/Users/helge/Downloads/results_FSL 2/resultsFSL_MH/Si_off_tCr.csv')
dfGEFSL <- spvs_importResults('/Users/helge/Downloads/results_FSL 2/resultsFSL_MH/GE_off_tCr.csv')

dfPhFSL <- spvs_AddStatsToDataframe(dfPhFSL,'/Volumes/Samsung/working/ISMRM/Philips/stat.csv')
dfSiFSL <- spvs_AddStatsToDataframe(dfSiFSL,'/Volumes/Samsung/working/ISMRM/Siemens/stat.csv')
dfGEFSL <- spvs_AddStatsToDataframe(dfGEFSL,'/Volumes/Samsung/working/ISMRM/GE/stat.csv')

lowerLimit <- c(0.75,.05,0.4,0.75)
upperLimit <- c(2.1,0.33,1.22,2.75)

color <- brewer.pal(8, 'Paired')
ToolColorMap <- c(color[6],color[2],color[4],color[8])


dfGE <- spvs_ConcatenateDataFrame(list(dfGELCM,dfGEOsp,dfGETar,dfGEFSL),c('A-LCModel','B-Osprey','C-Tarquin','D-FSL'))
dfPh <- spvs_ConcatenateDataFrame(list(dfPhLCM,dfPhOsp,dfPhTar,dfPhFSL),c('A-LCModel','B-Osprey','C-Tarquin','D-FSL'))
dfSi <- spvs_ConcatenateDataFrame(list(dfSiLCM,dfSiOsp,dfSiTar,dfSiFSL),c('A-LCModel','B-Osprey','C-Tarquin','D-FSL'))
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
