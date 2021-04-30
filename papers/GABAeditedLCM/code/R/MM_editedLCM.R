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
dfNoMMCr <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/full04/derivativesnone/QuantifyResults/off_amplMets_Voxel_1.csv', header = TRUE,stringsAsFactors = FALSE)
dfNoMMCr <- spvs_AddStatsToDataframe(dfNoMMCr,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')


# GABA+ conc ---------------------------------------------------------------
# Generate output for GABA+ = GABA + MM3co / GABA+ = GABA + MM3co + HCar

knots <- list('055','04','025')
range <- list('full','inter','red')
comb <- list('','Comb')
outname <- 'GABAtoCrConc'
for(c in comb){
    for(r in range){
      for (k in knots) {
    
      if (r == 'full'){    
        # Full range
        df3to2 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives3to2MM/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        df3to2soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives3to2MMsoft/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        
        df3to2 <- spvs_AddStatsToDataframe(df3to2,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
         if (c == 'Comb'){ 
        df3to2$GABAtoCr <- (df3to2$GABA+df3to2$MM09+df3to2$HCar)/dfNoMMCr$tCr}
        else{df3to2$GABAtoCr <- (df3to2$GABA+df3to2$MM09)/dfNoMMCr$tCr}
        
        df3to2soft <- spvs_AddStatsToDataframe(df3to2soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
         if (c == 'Comb'){ 
        df3to2soft$GABAtoCr <- (df3to2soft$GABA+df3to2soft$MM3co+df3to2soft$HCar)/dfNoMMCr$tCr}
      else{df3to2soft$GABAtoCr <- (df3to2soft$GABA+df3to2soft$MM3co)/dfNoMMCr$tCr}
      }
      
    #Intermediate and reduced range
    dfNoMM <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesnone/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
    df1to1 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives1to1GABA/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
    df1to1soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives1to1GABAsoft/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
    dfFixedGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesfreeGauss14/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
    dfFreeGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesfreeGauss/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)


    #Intermediate and reduced range
    dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    if (c == 'Comb'){ 
     dfNoMM$GABAtoCr <- (dfNoMM$GABA+dfNoMM$HCar)/dfNoMMCr$tCr}else{
       dfNoMM$GABAtoCr <- dfNoMM$GABA/dfNoMMCr$tCr}
    
    df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    if (c == 'Comb'){ 
    df1to1$GABAtoCr <- (df1to1$GABA*2+df1to1$HCar)/dfNoMMCr$tCr}else{
      df1to1$GABAtoCr <- df1to1$GABA*2/dfNoMMCr$tCr}
    
    df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    if (c == 'Comb'){ 
    df1to1soft$GABAtoCr <- (df1to1soft$GABA+df1to1soft$MM3co+df1to1soft$HCar)/dfNoMMCr$tCr}else{
      df1to1soft$GABAtoCr <- (df1to1soft$GABA+df1to1soft$MM3co)/dfNoMMCr$tCr}
    
    dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    if (c == 'Comb'){ 
    dfFixedGauss$GABAtoCr <- (dfFixedGauss$GABA+dfFixedGauss$MM3co+dfFixedGauss$HCar)/dfNoMMCr$tCr}else{
      dfFixedGauss$GABAtoCr <- (dfFixedGauss$GABA+dfFixedGauss$MM3co)/dfNoMMCr$tCr}
    
    dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
     if (c == 'Comb'){ 
    dfFreeGauss$GABAtoCr <- (dfFreeGauss$GABA+dfFreeGauss$MM3co+dfFreeGauss$HCar)/dfNoMMCr$tCr}else{
      dfFreeGauss$GABAtoCr <- (dfFreeGauss$GABA+dfFreeGauss$MM3co)/dfNoMMCr$tCr}
    
    # Full range
    if (r == 'full'){
    dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))
    dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))
    } else{
    #Intermediate and reduced range
    dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))
    dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))
    }
    
    lowerLimit <- rev(c(0))
    upperLimit <- rev(c(0.8))
    lowerLimitRes <- rev(c(0,0))
    upperLimitRes <- rev(c(15,6))
    colorPaired <- brewer.pal(10, 'Paired')
    colorDark <- brewer.pal(8, 'Dark2')
    colorGABA <- c(colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorPaired[4],colorPaired[3],colorDark[2])
    colorRes <- c(colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorPaired[4],colorPaired[3],colorDark[2])
    
    pGABALCM <- spvs_Violin(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1)
    dataSummary <- pGABALCM[[2]]
    dataSummary$CVpro <- dataSummary$CV * 100 
    pGABALCM <- pGABALCM[[1]]
    pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
    
    if (k == '055'){
      VioList1 <- pGABALCM }
    if (k == '04'){
      VioList2 <- pGABALCM }
    if (k == '025'){
      VioList3 <- pGABALCM
    p <- grid.arrange(VioList1, VioList2, VioList3, ncol=3, nrow =1)
    ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/GABAconc/',outname,r,c, 'Violin.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
    }
    
    write.csv(dataSummary, file=paste('/Volumes/Samsung/working/ISMRM/Philips/GABAconc/',outname,r,k,c, '.csv',sep=''))
    
    # 45 for GABA+
    pGABALCMbar <- ggplot(data=dataSummary, aes(x=Group, y=CVpro, fill=Group)) +
      geom_bar(stat="identity", position=position_dodge())+
      geom_text(aes(y=3,label= sprintf("%.1f%%\n", CV * 100)), vjust=0.82, color="white",
                position = position_dodge(15), size=3, angle = 90, fontface = "bold")+
      theme_cowplot()+ ylim(0,75)
    pGABALCMbar <- pGABALCMbar + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
    
    if (k == '055'){
      BarList1 <- pGABALCMbar }
    if (k == '04'){
      BarList2 <- pGABALCMbar }
    if (k == '025'){
      BarList3 <- pGABALCMbar
      p <- grid.arrange(BarList1, BarList2, BarList3, ncol=3, nrow =1)
      ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/GABAconc/',outname,r,c, 'Bar.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
    }
    
    pGABALCMbar <- ggplot(data=dataSummary, aes(x=Group, y=sd, fill=Group)) +
      geom_bar(stat="identity", position=position_dodge())+
      geom_text(aes(y=3,label= sprintf("%.1f\n", sd)), vjust=0.82, color="white",
                position = position_dodge(15), size=3, angle = 90, fontface = "bold")+
      theme_cowplot()+ ylim(0,.05)
    pGABALCMbar <- pGABALCMbar + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
    
    if (k == '055'){
      BarList1SD <- pGABALCMbar }
    if (k == '04'){
      BarList2SD <- pGABALCMbar }
    if (k == '025'){
      BarList3SD <- pGABALCMbar
      p <- grid.arrange(BarList1SD, BarList2SD, BarList3SD, ncol=3, nrow =1)
      ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/GABAconc/',outname,r,c, 'BarSD.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
    }
    
    stats <- spvs_Statistics(dfModels,list('GABAtoCr'),1)
    sink(paste('/Volumes/Samsung/working/ISMRM/Philips/GABAconc/',outname,r,k,c, 'stats.txt',sep=''))
    print(stats)
    sink()
    }#combs
  }#ranges
}#knots


# GABA ----------------------------------------------------------
# Generate output for GABA
knots <- list('055','04','025')
range <- list('full','inter','red')
comb <- list('')
outname <- 'GABA_sep_toCrConc'
for(c in comb){
  for(r in range){
    for (k in knots) {
      
      if (r == 'full'){    
        # Full range
        df3to2 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives3to2MM/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        df3to2soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives3to2MMsoft/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        
        df3to2 <- spvs_AddStatsToDataframe(df3to2,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
        if (c == 'Comb'){ 
          df3to2$GABAtoCr <- (df3to2$GABA+df3to2$HCar)/dfNoMMCr$tCr}
        else{df3to2$GABAtoCr <- (df3to2$GABA)/dfNoMMCr$tCr}
        
        df3to2soft <- spvs_AddStatsToDataframe(df3to2soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
        if (c == 'Comb'){ 
          df3to2soft$GABAtoCr <- (df3to2soft$GABA+df3to2soft$MM3co+df3to2soft$HCar)/dfNoMMCr$tCr}
        else{df3to2soft$GABAtoCr <- (df3to2soft$GABA)/dfNoMMCr$tCr}
      }
      
      #Intermediate and reduced range
      dfNoMM <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesnone/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      df1to1 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives1to1GABA/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      df1to1soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives1to1GABAsoft/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      dfFixedGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesfreeGauss14/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      dfFreeGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesfreeGauss/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      
      
      #Intermediate and reduced range
      dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        dfNoMM$GABAtoCr <- (dfNoMM$GABA+dfNoMM$HCar)/dfNoMMCr$tCr}else{
          dfNoMM$GABAtoCr <- dfNoMM$GABA/dfNoMMCr$tCr}
      
      df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        df1to1$GABAtoCr <- (df1to1$GABA+df1to1$HCar)/dfNoMMCr$tCr}else{
          df1to1$GABAtoCr <- df1to1$GABA/dfNoMMCr$tCr}
      
      df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        df1to1soft$GABAtoCr <- (df1to1soft$GABA+df1to1soft$HCar)/dfNoMMCr$tCr}else{
          df1to1soft$GABAtoCr <- (df1to1soft$GABA)/dfNoMMCr$tCr}
      
      dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        dfFixedGauss$GABAtoCr <- (dfFixedGauss$GABA+dfFixedGauss$HCar)/dfNoMMCr$tCr}else{
          dfFixedGauss$GABAtoCr <- (dfFixedGauss$GABA)/dfNoMMCr$tCr}
      
      dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        dfFreeGauss$GABAtoCr <- (dfFreeGauss$GABA+dfFreeGauss$HCar)/dfNoMMCr$tCr}else{
          dfFreeGauss$GABAtoCr <- (dfFreeGauss$GABA)/dfNoMMCr$tCr}
      
      # Full range
      if (r == 'full'){
        dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))
        dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))
      } else{
        #Intermediate and reduced range
        dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))
        dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))
      }
      
      lowerLimit <- rev(c(0))
      upperLimit <- rev(c(0.65))
      lowerLimitRes <- rev(c(0,0))
      upperLimitRes <- rev(c(15,6))
      colorPaired <- brewer.pal(10, 'Paired')
      colorDark <- brewer.pal(8, 'Dark2')
      colorGABA <- c(colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorPaired[4],colorPaired[3],colorDark[2])
      colorRes <- c(colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorPaired[4],colorPaired[3],colorDark[2])
      
      pGABALCM <- spvs_Violin(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1)
      dataSummary <- pGABALCM[[2]]
      dataSummary$CVpro <- dataSummary$CV * 100 
      pGABALCM <- pGABALCM[[1]]
      pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
      
      if (k == '055'){
        VioList1 <- pGABALCM }
      if (k == '04'){
        VioList2 <- pGABALCM }
      if (k == '025'){
        VioList3 <- pGABALCM
        p <- grid.arrange(VioList1, VioList2, VioList3, ncol=3, nrow =1)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/GABA_sep_conc/',outname,r,c, 'Violin.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
      }
      
      write.csv(dataSummary, file=paste('/Volumes/Samsung/working/ISMRM/Philips/GABA_sep_conc/',outname,r,k,c, '.csv',sep=''))
      
      pGABALCMbar <- ggplot(data=dataSummary, aes(x=Group, y=CVpro, fill=Group)) +
        geom_bar(stat="identity", position=position_dodge())+
        geom_text(aes(y=3,label= sprintf("%.1f%%\n", CV * 100)), vjust=0.82, color="white",
                  position = position_dodge(15), size=3, angle = 90, fontface = "bold")+
        theme_cowplot()+ ylim(0,75)
      pGABALCMbar <- pGABALCMbar + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
      
      if (k == '055'){
        BarList1 <- pGABALCMbar }
      if (k == '04'){
        BarList2 <- pGABALCMbar }
      if (k == '025'){
        BarList3 <- pGABALCMbar
        p <- grid.arrange(BarList1, BarList2, BarList3, ncol=3, nrow =1)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/GABA_sep_conc/',outname,r,c, 'Bar.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
      }
      
      pGABALCMbar <- ggplot(data=dataSummary, aes(x=Group, y=sd, fill=Group)) +
        geom_bar(stat="identity", position=position_dodge())+
        geom_text(aes(y=3,label= sprintf("%.1f\n", sd)), vjust=0.82, color="white",
                  position = position_dodge(15), size=3, angle = 90, fontface = "bold")+
        theme_cowplot()+ ylim(0,.05)
      pGABALCMbar <- pGABALCMbar + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
      
      if (k == '055'){
        BarList1SD <- pGABALCMbar }
      if (k == '04'){
        BarList2SD <- pGABALCMbar }
      if (k == '025'){
        BarList3SD <- pGABALCMbar
        p <- grid.arrange(BarList1SD, BarList2SD, BarList3SD, ncol=3, nrow =1)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/GABA_sep_conc/',outname,r,c, 'BarSD.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
      }
      
      stats <- spvs_Statistics(dfModels,list('GABAtoCr'),1)
      sink(paste('/Volumes/Samsung/working/ISMRM/Philips/GABA_sep_conc/',outname,r,k,c, 'stats.txt',sep=''))
      print(stats)
      sink()
    }#combs
  }#ranges
}#knots


# MM3co -------------------------------------------------------------------
# Generate output for MM3co
knots <- list('055','04','025')
range <- list('full','inter','red')
comb <- list('')
outname <- 'MM3cotoCrConc'
for(c in comb){
  for(r in range){
    for (k in knots) {
      
      if (r == 'full'){    
        # Full range
        df3to2 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives3to2MM/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        df3to2soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives3to2MMsoft/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        
        df3to2 <- spvs_AddStatsToDataframe(df3to2,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
        if (c == 'Comb'){ 
          df3to2$GABAtoCr <- (f3to2$MM09+df3to2$HCar)/dfNoMMCr$tCr}
        else{df3to2$GABAtoCr <- (df3to2$MM09)/dfNoMMCr$tCr}
        
        df3to2soft <- spvs_AddStatsToDataframe(df3to2soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
        if (c == 'Comb'){ 
          df3to2soft$GABAtoCr <- (df3to2soft$MM3co+df3to2soft$HCar)/dfNoMMCr$tCr}
        else{df3to2soft$GABAtoCr <- (df3to2soft$MM3co)/dfNoMMCr$tCr}
      }
      
      #Intermediate and reduced range
      dfNoMM <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesnone/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      df1to1 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives1to1GABA/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      df1to1soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives1to1GABAsoft/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      dfFixedGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesfreeGauss14/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      dfFreeGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesfreeGauss/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      
      
      #Intermediate and reduced range
      dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        dfNoMM$GABAtoCr <- (dfNoMM$GABA+dfNoMM$HCar)/dfNoMMCr$tCr}else{
          dfNoMM$GABAtoCr <- dfNoMM$GABA/dfNoMMCr$tCr}
      
      df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        df1to1$GABAtoCr <- (df1to1$GABA+df1to1$HCar)/dfNoMMCr$tCr}else{
          df1to1$GABAtoCr <- df1to1$GABA*2/dfNoMMCr$tCr}
      
      df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        df1to1soft$GABAtoCr <- (df1to1soft$MM3co+df1to1soft$HCar)/dfNoMMCr$tCr}else{
          df1to1soft$GABAtoCr <- (df1to1soft$MM3co)/dfNoMMCr$tCr}
      
      dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        dfFixedGauss$GABAtoCr <- (dfFixedGauss$MM3co+dfFixedGauss$HCar)/dfNoMMCr$tCr}else{
          dfFixedGauss$GABAtoCr <- (dfFixedGauss$MM3co)/dfNoMMCr$tCr}
      
      dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        dfFreeGauss$GABAtoCr <- (dfFreeGauss$MM3co+dfFreeGauss$HCar)/dfNoMMCr$tCr}else{
          dfFreeGauss$GABAtoCr <- (dfFreeGauss$MM3co)/dfNoMMCr$tCr}
      
      # Full range
      if (r == 'full'){
        dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))
        dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))
      } else{
        #Intermediate and reduced range
        dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))
        dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))
      }
      
      lowerLimit <- rev(c(0))
      upperLimit <- rev(c(0.65))
      lowerLimitRes <- rev(c(0,0))
      upperLimitRes <- rev(c(15,6))
      colorPaired <- brewer.pal(10, 'Paired')
      colorDark <- brewer.pal(8, 'Dark2')
      colorGABA <- c(colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorPaired[4],colorPaired[3],colorDark[2])
      colorRes <- c(colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorPaired[4],colorPaired[3],colorDark[2])
      
      pGABALCM <- spvs_Violin(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1)
      dataSummary <- pGABALCM[[2]]
      dataSummary$CVpro <- dataSummary$CV * 100 
      pGABALCM <- pGABALCM[[1]]
      pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
      
      if (k == '055'){
        VioList1 <- pGABALCM }
      if (k == '04'){
        VioList2 <- pGABALCM }
      if (k == '025'){
        VioList3 <- pGABALCM
        p <- grid.arrange(VioList1, VioList2, VioList3, ncol=3, nrow =1)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/MM3coconc/',outname,r,c, 'Violin.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
      }
      
      write.csv(dataSummary, file=paste('/Volumes/Samsung/working/ISMRM/Philips/MM3coconc/',outname,r,k,c, '.csv',sep=''))
      
      pGABALCMbar <- ggplot(data=dataSummary, aes(x=Group, y=CVpro, fill=Group)) +
        geom_bar(stat="identity", position=position_dodge())+
        geom_text(aes(y=3,label= sprintf("%.1f%%\n", CV * 100)), vjust=0.82, color="white",
                  position = position_dodge(15), size=3, angle = 90, fontface = "bold")+
        theme_cowplot()+ ylim(0,75)
      pGABALCMbar <- pGABALCMbar + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
      
      if (k == '055'){
        BarList1 <- pGABALCMbar }
      if (k == '04'){
        BarList2 <- pGABALCMbar }
      if (k == '025'){
        BarList3 <- pGABALCMbar
        p <- grid.arrange(BarList1, BarList2, BarList3, ncol=3, nrow =1)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/MM3coconc/',outname,r,c, 'Bar.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
      }
      
      pGABALCMbar <- ggplot(data=dataSummary, aes(x=Group, y=sd, fill=Group)) +
        geom_bar(stat="identity", position=position_dodge())+
        geom_text(aes(y=3,label= sprintf("%.1f\n", sd)), vjust=0.82, color="white",
                  position = position_dodge(15), size=3, angle = 90, fontface = "bold")+
        theme_cowplot()+ ylim(0,.05)
      pGABALCMbar <- pGABALCMbar + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
      
      if (k == '055'){
        BarList1SD <- pGABALCMbar }
      if (k == '04'){
        BarList2SD <- pGABALCMbar }
      if (k == '025'){
        BarList3SD <- pGABALCMbar
        p <- grid.arrange(BarList1SD, BarList2SD, BarList3SD, ncol=3, nrow =1)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/MM3coconc/',outname,r,c, 'BarSD.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
      }
      
      stats <- spvs_Statistics(dfModels,list('GABAtoCr'),1)
      sink(paste('/Volumes/Samsung/working/ISMRM/Philips/MM3coconc/',outname,r,k,c, 'stats.txt',sep=''))
      print(stats)
      sink()
    }#combs
  }#ranges
}#knots

# HCar -------------------------------------------------------------
# Generate output for HCar

knots <- list('055','04','025')
range <- list('full','inter','red')
comb <- list('Comb')
outname <- 'HCartoCrConc'

for(c in comb){
  for(r in range){
    for (k in knots) {
      
      if (r == 'full'){    
        # Full range
        df3to2 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives3to2MM/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        df3to2soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives3to2MMsoft/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        
        df3to2 <- spvs_AddStatsToDataframe(df3to2,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
        if (c == 'Comb'){ 
          df3to2$GABAtoCr <- (df3to2$HCar)/dfNoMMCr$tCr}
        else{df3to2$GABAtoCr <- (df3to2$MM09)/dfNoMMCr$tCr}
        
        df3to2soft <- spvs_AddStatsToDataframe(df3to2soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
        if (c == 'Comb'){ 
          df3to2soft$GABAtoCr <- (df3to2soft$HCar)/dfNoMMCr$tCr}
        else{df3to2soft$GABAtoCr <- (df3to2soft$MM3co)/dfNoMMCr$tCr}
      }
      
      #Intermediate and reduced range
      dfNoMM <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesnone/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      df1to1 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives1to1GABA/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      df1to1soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives1to1GABAsoft/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      dfFixedGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesfreeGauss14/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      dfFreeGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesfreeGauss/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      
      
      #Intermediate and reduced range
      dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        dfNoMM$GABAtoCr <- (dfNoMM$HCar)/dfNoMMCr$tCr}else{
          dfNoMM$GABAtoCr <- dfNoMM$GABA/dfNoMMCr$tCr}
      
      df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        df1to1$GABAtoCr <- (df1to1$HCar)/dfNoMMCr$tCr}else{
          df1to1$GABAtoCr <- df1to1$GABA*2/dfNoMMCr$tCr}
      
      df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        df1to1soft$GABAtoCr <- (df1to1soft$HCar)/dfNoMMCr$tCr}else{
          df1to1soft$GABAtoCr <- (df1to1soft$MM3co)/dfNoMMCr$tCr}
      
      dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        dfFixedGauss$GABAtoCr <- (dfFixedGauss$HCar)/dfNoMMCr$tCr}else{
          dfFixedGauss$GABAtoCr <- (dfFixedGauss$MM3co)/dfNoMMCr$tCr}
      
      dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        dfFreeGauss$GABAtoCr <- (dfFreeGauss$HCar)/dfNoMMCr$tCr}else{
          dfFreeGauss$GABAtoCr <- (dfFreeGauss$MM3co)/dfNoMMCr$tCr}
      
      # Full range
      if (r == 'full'){
        dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))
        dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))
      } else{
        #Intermediate and reduced range
        dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))
        dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))
      }
      
      lowerLimit <- rev(c(0))
      upperLimit <- rev(c(0.8))
      lowerLimitRes <- rev(c(0,0))
      upperLimitRes <- rev(c(15,6))
      colorPaired <- brewer.pal(10, 'Paired')
      colorDark <- brewer.pal(8, 'Dark2')
      colorGABA <- c(colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorPaired[4],colorPaired[3],colorDark[2])
      colorRes <- c(colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorPaired[4],colorPaired[3],colorDark[2])
      
      pGABALCM <- spvs_Violin(dfModels, '/ [tCr]',list('GABAtoCr'),c('Group'),lowerLimit,upperLimit,c(""),1)
      dataSummary <- pGABALCM[[2]]
      dataSummary$CVpro <- dataSummary$CV * 100 
      pGABALCM <- pGABALCM[[1]]
      pGABALCM <- pGABALCM + ylim(0-.80*.05,.80+.80*.05)
      pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
      
      if (r == 'full'){dataSummaryBckpFull <- dataSummary}
      if (r == 'red'){dataSummaryBckpRed <- dataSummary}
      
      if (k == '055'){
        VioList1 <- pGABALCM }
      if (k == '04'){
        VioList2 <- pGABALCM }
      if (k == '025'){
        VioList3 <- pGABALCM
        p <- grid.arrange(VioList1, VioList2, VioList3, ncol=3, nrow =1)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/HCarconc/',outname,r,c, 'Violin.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
      }
      
      write.csv(dataSummary, file=paste('/Volumes/Samsung/working/ISMRM/Philips/HCarconc/',outname,r,k,c, '.csv',sep=''))
      
      pGABALCMbar <- ggplot(data=dataSummary, aes(x=Group, y=CVpro, fill=Group)) +
        geom_bar(stat="identity", position=position_dodge())+
        geom_text(aes(y=3,label= sprintf("%.1f%%\n", CV * 100)), vjust=0.82, color="white",
                  position = position_dodge(15), size=3, angle = 90, fontface = "bold")+
        theme_cowplot()+ ylim(0,275)
      pGABALCMbar <- pGABALCMbar + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
      
      if (k == '055'){
        BarList1 <- pGABALCMbar }
      if (k == '04'){
        BarList2 <- pGABALCMbar }
      if (k == '025'){
        BarList3 <- pGABALCMbar
        p <- grid.arrange(BarList1, BarList2, BarList3, ncol=3, nrow =1)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/HCarconc/',outname,r,c, 'Bar.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
      }
      
      pGABALCMbar <- ggplot(data=dataSummary, aes(x=Group, y=sd, fill=Group)) +
        geom_bar(stat="identity", position=position_dodge())+
        geom_text(aes(y=3,label= sprintf("%.1f\n", sd)), vjust=0.82, color="white",
                  position = position_dodge(15), size=3, angle = 90, fontface = "bold")+
        theme_cowplot()+ ylim(0,.05)
      pGABALCMbar <- pGABALCMbar + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
      
      if (k == '055'){
        BarList1SD <- pGABALCMbar }
      if (k == '04'){
        BarList2SD <- pGABALCMbar }
      if (k == '025'){
        BarList3SD <- pGABALCMbar
        p <- grid.arrange(BarList1SD, BarList2SD, BarList3SD, ncol=3, nrow =1)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/HCarconc/',outname,r,c, 'BarSD.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
      }
      
      stats <- spvs_Statistics(dfModels,list('GABAtoCr'),1)
      sink(paste('/Volumes/Samsung/working/ISMRM/Philips/HCarconc/',outname,r,k,c, 'stats.txt',sep=''))
      print(stats)
      sink()
    }#combs
  }#ranges
}#knots

# HCar GABA+ ratio -------------------------------------------------------------
# Generate output for HCar to GABA= ratio
# Similar to Landheer et al paper.

knots <- list('055','04','025')
range <- list('full','inter','red')
comb <- list('Comb')
outname <- 'HCartoGABA+'

for(c in comb){
  for(r in range){
    for (k in knots) {
      
      if (r == 'full'){    
        # Full range
        df3to2 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives3to2MM/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        df3to2soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives3to2MMsoft/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        
        df3to2 <- spvs_AddStatsToDataframe(df3to2,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
        if (c == 'Comb'){ 
          df3to2$HCartoGABAp <- 100*(df3to2$HCar)/(df3to2$HCar+df3to2$GABA+df3to2$MM09)}
        else{df3to2$HCartoGABAp <- (df3to2$MM09)/dfNoMMCr$tCr}
        
        df3to2soft <- spvs_AddStatsToDataframe(df3to2soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
        if (c == 'Comb'){ 
          df3to2soft$HCartoGABAp <- 100*(df3to2soft$HCar)/(df3to2soft$HCar+df3to2soft$GABA+df3to2soft$MM3co)}
        else{df3to2soft$HCartoGABAp <- (df3to2soft$MM3co)/dfNoMMCr$tCr}
      }
      
      #Intermediate and reduced range
      dfNoMM <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesnone/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      df1to1 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives1to1GABA/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      df1to1soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives1to1GABAsoft/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      dfFixedGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesfreeGauss14/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      dfFreeGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesfreeGauss/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      
      
      #Intermediate and reduced range
      dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        dfNoMM$HCartoGABAp <- 100*(dfNoMM$HCar)/(dfNoMM$HCar+dfNoMM$GABA)}else{
          dfNoMM$HCartoGABAp <- dfNoMM$GABA/dfNoMMCr$tCr}
      
      df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        df1to1$HCartoGABAp <- 100*(df1to1$HCar)/(df1to1$GABA*2+df1to1$HCar)}else{
          df1to1$HCartoGABAp <- df1to1$GABA*2/dfNoMMCr$tCr}
      
      df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        df1to1soft$HCartoGABAp <- 100*(df1to1soft$HCar)/(df1to1soft$HCar+df1to1soft$GABA+df1to1soft$MM3co)}else{
          df1to1soft$HCartoGABAp <- (df1to1soft$MM3co)/dfNoMMCr$tCr}
      
      dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        dfFixedGauss$HCartoGABAp <- 100*(dfFixedGauss$HCar)/(dfFixedGauss$HCar+dfFixedGauss$GABA+dfFixedGauss$MM3co)}else{
          dfFixedGauss$HCartoGABAp <- (dfFixedGauss$MM3co)/dfNoMMCr$tCr}
      
      dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      if (c == 'Comb'){ 
        dfFreeGauss$HCartoGABAp <- 100*(dfFreeGauss$HCar)/(dfFreeGauss$HCar+dfFreeGauss$GABA+dfFreeGauss$MM3co)}else{
          dfFreeGauss$HCartoGABAp <- (dfFreeGauss$MM3co)/dfNoMMCr$tCr}
      
      # Full range
      if (r == 'full'){
        dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))
        dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))
      } else{
        #Intermediate and reduced range
        dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))
        dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))
      }
      
      lowerLimit <- rev(c(0))
      upperLimit <- rev(c(66))
      lowerLimitRes <- rev(c(0,0))
      upperLimitRes <- rev(c(15,6))
      colorPaired <- brewer.pal(10, 'Paired')
      colorDark <- brewer.pal(8, 'Dark2')
      colorGABA <- c(colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorPaired[4],colorPaired[3],colorDark[2])
      colorRes <- c(colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorPaired[4],colorPaired[3],colorDark[2])
      
      pGABALCM <- spvs_Violin(dfModels, '/ [tCr]',list('HCartoGABAp'),c('Group'),lowerLimit,upperLimit,c(""),1)
      dataSummary <- pGABALCM[[2]]
      dataSummary$CVpro <- dataSummary$CV * 100 
      pGABALCM <- pGABALCM[[1]]
      pGABALCM <- pGABALCM + ylim(0,66+66*.05)
      pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
      
      if (r == 'full'){dataSummaryBckpFull <- dataSummary}
      if (r == 'red'){dataSummaryBckpRed <- dataSummary}
      
      if (k == '055'){
        VioList1 <- pGABALCM }
      if (k == '04'){
        VioList2 <- pGABALCM }
      if (k == '025'){
        VioList3 <- pGABALCM
        p <- grid.arrange(VioList1, VioList2, VioList3, ncol=3, nrow =1)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/HCarGABAp/',outname,r,c, 'Violin.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
      }
      
      write.csv(dataSummary, file=paste('/Volumes/Samsung/working/ISMRM/Philips/HCarGABAp/',outname,r,k,c, '.csv',sep=''))
      
      pGABALCMbar <- ggplot(data=dataSummary, aes(x=Group, y=CVpro, fill=Group)) +
        geom_bar(stat="identity", position=position_dodge())+
        geom_text(aes(y=3,label= sprintf("%.1f%%\n", CV * 100)), vjust=0.82, color="white",
                  position = position_dodge(15), size=3, angle = 90, fontface = "bold")+
        theme_cowplot()+ ylim(0,75)
      pGABALCMbar <- pGABALCMbar + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
      
      if (k == '055'){
        BarList1 <- pGABALCMbar }
      if (k == '04'){
        BarList2 <- pGABALCMbar }
      if (k == '025'){
        BarList3 <- pGABALCMbar
        p <- grid.arrange(BarList1, BarList2, BarList3, ncol=3, nrow =1)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/HCarGABAp/',outname,r,c, 'Bar.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
      }
      
      pGABALCMbar <- ggplot(data=dataSummary, aes(x=Group, y=sd, fill=Group)) +
        geom_bar(stat="identity", position=position_dodge())+
        geom_text(aes(y=3,label= sprintf("%.1f\n", sd)), vjust=0.82, color="white",
                  position = position_dodge(15), size=3, angle = 90, fontface = "bold")+
        theme_cowplot()+ ylim(0,.05)
      pGABALCMbar <- pGABALCMbar + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
      
      if (k == '055'){
        BarList1SD <- pGABALCMbar }
      if (k == '04'){
        BarList2SD <- pGABALCMbar }
      if (k == '025'){
        BarList3SD <- pGABALCMbar
        p <- grid.arrange(BarList1SD, BarList2SD, BarList3SD, ncol=3, nrow =1)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/HCarGABAp/',outname,r,c, 'BarSD.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
      }
      
      stats <- spvs_Statistics(dfModels,list('HCartoGABAp'),1)
      sink(paste('/Volumes/Samsung/working/ISMRM/Philips/HCarGABAp/',outname,r,k,c, 'stats.txt',sep=''))
      print(stats)
    }#combs
  }#ranges
}#knots

# GABA GABA+ ratio -------------------------------------------------------------
# Generate output for GABA to GABA+ ratio

knots <- list('055','04','025')
range <- list('full','inter','red')
comb <- list('')
outname <- 'GABAtoGABA+'

for(c in comb){
  for(r in range){
    for (k in knots) {
      
      if (r == 'full'){    
        # Full range
        df3to2 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives3to2MM/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        df3to2soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives3to2MMsoft/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        
        df3to2 <- spvs_AddStatsToDataframe(df3to2,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')

          df3to2$GABAtoGABAp <- 100*(df3to2$GABA)/(df3to2$GABA+df3to2$MM09)
        
        df3to2soft <- spvs_AddStatsToDataframe(df3to2soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')

          df3to2soft$GABAtoGABAp <- 100*(df3to2soft$GABA)/(df3to2soft$GABA+df3to2soft$MM3co)}
      
      #Intermediate and reduced range
      dfNoMM <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesnone/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      df1to1 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives1to1GABA/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      df1to1soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivatives1to1GABAsoft/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      dfFixedGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesfreeGauss14/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      dfFreeGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r, c, k, '/derivativesfreeGauss/QuantifyResults/diff1_amplMets_Voxel_1.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
      
      
      #Intermediate and reduced range
      dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
     
        dfNoMM$GABAtoGABAp <- 100*(df1to1soft$GABA)/(df1to1soft$GABA+df1to1soft$MM3co)
        
      df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')

        df1to1$GABAtoGABAp <- 100*(df1to1soft$GABA)/(df1to1soft$GABA+df1to1soft$MM3co)
      
      df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')

        df1to1soft$GABAtoGABAp <- 100*(df1to1soft$GABA)/(df1to1soft$GABA+df1to1soft$MM3co)
      
      dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')

        dfFixedGauss$GABAtoGABAp <- 100*(dfFixedGauss$GABA)/(dfFixedGauss$GABA+dfFixedGauss$MM3co)
      
      dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')

        dfFreeGauss$GABAtoGABAp <- 100*(dfFreeGauss$GABA)/(dfFreeGauss$GABA+dfFreeGauss$MM3co)
      
      # Full range
      if (r == 'full'){
        dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))
        dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))
      } else{
        #Intermediate and reduced range
        dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))
        dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))
      }
      
      lowerLimit <- rev(c(0))
      upperLimit <- rev(c(66))
      lowerLimitRes <- rev(c(0,0))
      upperLimitRes <- rev(c(15,6))
      colorPaired <- brewer.pal(10, 'Paired')
      colorDark <- brewer.pal(8, 'Dark2')
      colorGABA <- c(colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorPaired[4],colorPaired[3],colorDark[2])
      colorRes <- c(colorDark[8],colorPaired[2],colorPaired[1],colorPaired[6],colorPaired[5],colorPaired[4],colorPaired[3],colorDark[2])
      
      pGABALCM <- spvs_Violin(dfModels, '/ [tCr]',list('GABAtoGABAp'),c('Group'),lowerLimit,upperLimit,c(""),1)
      dataSummary <- pGABALCM[[2]]
      dataSummary$CVpro <- dataSummary$CV * 100 
      pGABALCM <- pGABALCM[[1]]
      pGABALCM <- pGABALCM + ylim(0,66+66*.05)
      pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
      
      if (r == 'full'){dataSummaryBckpFull <- dataSummary}
      if (r == 'red'){dataSummaryBckpRed <- dataSummary}
      
      if (k == '055'){
        VioList1 <- pGABALCM }
      if (k == '04'){
        VioList2 <- pGABALCM }
      if (k == '025'){
        VioList3 <- pGABALCM
        p <- grid.arrange(VioList1, VioList2, VioList3, ncol=3, nrow =1)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/GABAGABAp/',outname,r,c, 'Violin.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
      }
      
      write.csv(dataSummary, file=paste('/Volumes/Samsung/working/ISMRM/Philips/GABAGABAp/',outname,r,k,c, '.csv',sep=''))
      
      pGABALCMbar <- ggplot(data=dataSummary, aes(x=Group, y=CVpro, fill=Group)) +
        geom_bar(stat="identity", position=position_dodge())+
        geom_text(aes(y=3,label= sprintf("%.1f%%\n", CV * 100)), vjust=0.82, color="white",
                  position = position_dodge(15), size=3, angle = 90, fontface = "bold")+
        theme_cowplot()+ ylim(0,75)
      pGABALCMbar <- pGABALCMbar + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
      
      if (k == '055'){
        BarList1 <- pGABALCMbar }
      if (k == '04'){
        BarList2 <- pGABALCMbar }
      if (k == '025'){
        BarList3 <- pGABALCMbar
        p <- grid.arrange(BarList1, BarList2, BarList3, ncol=3, nrow =1)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/GABAGABAp/',outname,r,c, 'Bar.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
      }
      
      pGABALCMbar <- ggplot(data=dataSummary, aes(x=Group, y=sd, fill=Group)) +
        geom_bar(stat="identity", position=position_dodge())+
        geom_text(aes(y=3,label= sprintf("%.1f\n", sd)), vjust=0.82, color="white",
                  position = position_dodge(15), size=3, angle = 90, fontface = "bold")+
        theme_cowplot()+ ylim(0,.05)
      pGABALCMbar <- pGABALCMbar + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
      
      if (k == '055'){
        BarList1SD <- pGABALCMbar }
      if (k == '04'){
        BarList2SD <- pGABALCMbar }
      if (k == '025'){
        BarList3SD <- pGABALCMbar
        p <- grid.arrange(BarList1SD, BarList2SD, BarList3SD, ncol=3, nrow =1)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/GABAGABAp/',outname,r,c, 'BarSD.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
      }
      
      stats <- spvs_Statistics(dfModels,list('GABAtoGABAp'),1)
      sink(paste('/Volumes/Samsung/working/ISMRM/Philips/GABAGABAp/',outname,r,k,c, 'stats.txt',sep=''))
      print(stats)
    }#combs
  }#ranges
}#knots

# AIC analysis ------------------------------------------------------------
# Generate output for AICs
knots <- list('055','04','025')
range <- list('full','inter','red')
comb <- list('')
outname <- 'AIC'
for(c in comb){
  for(r in range){
    for (k in knots) {
      if (r == 'full'){
        dataSummary <- spvs_AddStatsToDataframe(dataSummaryBckpFull,paste('/Volumes/Samsung/working/ISMRM/Philips/',r,c,k, '/dICsq.csv',sep=''))
      }else{
        dataSummary <- spvs_AddStatsToDataframe(dataSummaryBckpRed,paste('/Volumes/Samsung/working/ISMRM/Philips/',r,c,k, '/dICsq.csv',sep=''))
      }
      
        
        pGABALCMbar <- ggplot(data=dataSummary, aes(x=Group, y=dAIC_ll, fill=Group)) +
          geom_bar(stat="identity", position=position_dodge())+
          geom_text(aes(y=3,label= sprintf("%.1f\n", dAIC_ll)), vjust=0.82, color="white",
                    position = position_dodge(15), size=3, angle = 90, fontface = "bold")+
          theme_cowplot() + ylim(0,70)
        pGABALCMbar <- pGABALCMbar + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
        
        if (k == '055'){
          BarList1 <- pGABALCMbar }
        if (k == '04'){
          BarList2 <- pGABALCMbar }
        if (k == '025'){
          BarList3 <- pGABALCMbar
          p <- grid.arrange(BarList1, BarList2, BarList3, ncol=3, nrow =1)
          ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/AIC/',outname,r,c, 'dAIC_sqBar.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
        }
      }#combs
  }#ranges
}#knots

##For residual analysis -------------------------------------------------------------------
# Generate output the residual analysis
knots <- list('055','04','025')
range <- list('full','inter','red')
comb <- list('')

for(c in comb){
  for(r in range){
    for (k in knots) {
        #Intermediate and reduced range
        dfNoMM <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas',  k,'/',r,c, '/Ph_Osp_GABAtoCr_none.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        df1to1 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas', k,'/',r,c, '/Ph_Osp_GABAtoCr_1to1GABA.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        df1to1soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas', k,'/',r,c, '/Ph_Osp_GABAtoCr_1to1GABAsoft.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        dfFixedGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas', k,'/',r,c, '/Ph_Osp_GABAtoCr_freeGauss.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        dfFreeGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas', k,'/',r,c, '/Ph_Osp_GABAtoCr_freeGauss14.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
        
        if (r == 'full'){
          # Full range
          df3to2 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas', k,'/',r,c, '/Ph_Osp_GABAtoCr_3to2MM.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
          df3to2soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/GABAAreas', k,'/',r,c, '/Ph_Osp_GABAtoCr_3to2MMsoft.csv',sep=''), header = TRUE,stringsAsFactors = FALSE)
          
          # Full range
          df3to2 <- spvs_AddStatsToDataframe(df3to2,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
          
          df3to2soft <- spvs_AddStatsToDataframe(df3to2soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
           }  
        #Intermediate and reduced range
        dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
        
        df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
        
        df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
        
        dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
        
        dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
        
        if (r == 'full'){
        # Full range
        dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))
        dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))
        } else{
        
        #Intermediate and reduced range
        dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))
        dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))
        }
        outname<-'GABAResRelAmpl'
        lowerLimit <- rev(c(0))
        upperLimit <- rev(c(17.5))
        pGABALCM <- spvs_Violin(dfModels, '/ [tCr]',list('GABAResRelAmpl'),c('Group'),lowerLimit,upperLimit,c(""),1)
        dataSummary <- pGABALCM[[2]]
        pGABALCM <- pGABALCM[[1]]
        pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
        
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/GABAResRelAmpl/',outname,r,k,c, 'Violin.pdf',sep=''), pGABALCM, width = 10, height = 3,device=cairo_pdf) #saves g
        
        write.csv(dataSummary, file=paste('/Volumes/Samsung/working/ISMRM/Philips/GABAResRelAmpl/',outname,r,k,c, '.csv',sep=''))
        
        
        pGABALCMbar <- ggplot(data=dataSummary, aes(x=Group, y=mean, fill=Group)) +
          geom_bar(stat="identity", position=position_dodge())+
          geom_text(aes(y=3,label= sprintf("%.1f\n", mean)), vjust=0.82, color="white",
                    position = position_dodge(15), size=3, angle = 90, fontface = "bold")+
          geom_errorbar(data = dataSummary, aes_string(y = 'mean',ymin = 'meanMsd', ymax = 'meanPsd', group = 'Group'),position = position_dodge(width = 0.3), width = .02, colour = 'black')+
          theme_cowplot() + ylim(0,upperLimit)
        pGABALCMbar <- pGABALCMbar + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
        if (k == '055'){
          BarList1 <- pGABALCMbar }
        if (k == '04'){
          BarList2 <- pGABALCMbar }
        if (k == '025'){
          BarList3 <- pGABALCMbar
          p <- grid.arrange(BarList1, BarList2, BarList3, ncol=3, nrow =1)
          ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/GABAResRelAmpl/',outname,r,c, 'Bar.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
        }
        
        outname<-'RangeResRelAmpl'
        lowerLimit <- rev(c(0))
        upperLimit <- rev(c(20))
        pGABALCM <- spvs_Violin(dfModels, '/ [tCr]',list('RangeResRelAmpl'),c('Group'),lowerLimit,upperLimit,c(""),1)
        dataSummary <- pGABALCM[[2]]
        pGABALCM <- pGABALCM[[1]]
        pGABALCM <- pGABALCM + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
        ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/RangeResRelAmpl/',outname,r,k,c, 'Violin.pdf',sep=''), pGABALCM, width = 10, height = 3,device=cairo_pdf) #saves g
        
        write.csv(dataSummary, file=paste('/Volumes/Samsung/working/ISMRM/Philips/RangeResRelAmpl/',outname,r,k,c, '.csv',sep=''))
        
        
        pGABALCMbar <- ggplot(data=dataSummary, aes(x=Group, y=mean, fill=Group)) +
          geom_bar(stat="identity", position=position_dodge())+
          geom_text(aes(y=3,label= sprintf("%.1f\n", mean)), vjust=0.82, color="white",
                    position = position_dodge(15), size=3, angle = 90, fontface = "bold")+
          geom_errorbar(data = dataSummary, aes_string(y = 'mean',ymin = 'meanMsd', ymax = 'meanPsd', group = 'Group'),position = position_dodge(width = 0.3), width = .02, colour = 'black')+
          theme_cowplot()+ ylim(0,upperLimit)
        pGABALCMbar <- pGABALCMbar + scale_color_manual(values = colorGABA)+scale_fill_manual(values = colorGABA)
        if (k == '055'){
          BarSList1 <- pGABALCMbar }
        if (k == '04'){
          BarSList2 <- pGABALCMbar }
        if (k == '025'){
          BarSList3 <- pGABALCMbar
          p <- grid.arrange(BarSList1, BarSList2, BarSList3, ncol=3, nrow =1)
          ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/RangeResRelAmpl/',outname,r,c, 'Bar.pdf',sep=''), p, width = 30, height = 3,device=cairo_pdf) #saves g
        }
      }#combs
    }#ranges
}#knots

# Correlation analysis of differences -----------------------------------
# Generate output for correaltion between HCar and differences in GABA with and without HCar
knots <- list('055','04','025')
range <- list('full','inter','red')
filen <- 'diff1_amplMets_Voxel_1.csv'
outname <- 'NoHCarAndHCar'

dfNoMMCr <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/full04/derivativesnone/QuantifyResults/off_amplMets_Voxel_1.csv', header = TRUE,stringsAsFactors = FALSE)
dfNoMMCr <- spvs_AddStatsToDataframe(dfNoMMCr,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')

lowerLimit <- -0.25
upperLimit <- 0.25


for (k in knots) 
{
  for(r in range)
  {
    #Intermediate and reduced range
    dfNoMM <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,k, '/derivativesnone/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    df1to1 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,k, '/derivatives1to1GABA/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    df1to1soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,k, '/derivatives1to1GABAsoft/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    dfFixedGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,k, '/derivativesfreeGauss14/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    dfFreeGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,k, '/derivativesfreeGauss/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    
    dfNoMMHCar <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,'Comb',k, '/derivativesnone/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    df1to1HCar <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,'Comb',k, '/derivatives1to1GABA/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    df1to1softHCar <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,'Comb',k, '/derivatives1to1GABAsoft/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    dfFixedGaussHCar <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,'Comb',k, '/derivativesfreeGauss14/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    dfFreeGaussHCar <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,'Comb',k, '/derivativesfreeGauss/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    
    
    if (r == 'full'){
      # Full range
      df3to2 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,k, '/derivatives3to2MM/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
      df3to2soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,k, '/derivatives3to2MMsoft/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
      
      df3to2HCar <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,'Comb',k, '/derivatives3to2MM/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
      df3to2softHCar <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,'Comb',k, '/derivatives3to2MMsoft/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
      
      # Full range
      df3to2 <- spvs_AddStatsToDataframe(df3to2,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      
      
      df3to2soft <- spvs_AddStatsToDataframe(df3to2soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      
      
      df3to2HCar <- spvs_AddStatsToDataframe(df3to2HCar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      df3to2HCar$GABAtoCr <- (df3to2HCar$HCar)/dfNoMMCr$tCr
      
      df3to2softHCar <- spvs_AddStatsToDataframe(df3to2softHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      df3to2softHCar$GABAtoCr <- (df3to2softHCar$HCar)/dfNoMMCr$tCr
      
      df3to2$GABAtoCr <- (df3to2HCar$GABA-df3to2$GABA)/dfNoMMCr$tCr
      df3to2soft$GABAtoCr <- (df3to2softHCar$GABA-df3to2soft$GABA)/dfNoMMCr$tCr
    }
    
    #Intermediate and reduced range
    dfNoMMHCar <- spvs_AddStatsToDataframe(dfNoMMHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    dfNoMMHCar$GABAtoCr <- dfNoMMHCar$HCar/dfNoMMCr$tCr
    
    
    df1to1HCar <- spvs_AddStatsToDataframe(df1to1HCar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    df1to1HCar$GABAtoCr <- df1to1HCar$HCar/dfNoMMCr$tCr
    
    
    df1to1softHCar <- spvs_AddStatsToDataframe(df1to1softHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    df1to1softHCar$GABAtoCr <- (df1to1softHCar$HCar)/dfNoMMCr$tCr
    
    
    dfFixedGaussHCar <- spvs_AddStatsToDataframe(dfFixedGaussHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    dfFixedGaussHCar$GABAtoCr <- (dfFixedGaussHCar$HCar)/dfNoMMCr$tCr
    
    
    dfFreeGaussHCar <- spvs_AddStatsToDataframe(dfFreeGaussHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    dfFreeGaussHCar$GABAtoCr <- (dfFreeGaussHCar$HCar)/dfNoMMCr$tCr
    
    #Intermediate and reduced range
    dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    dfNoMM$GABAtoCr <- (dfNoMMHCar$GABA-dfNoMM$GABA)/dfNoMMCr$tCr
    
    
    df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    df1to1$GABAtoCr <- 2*(df1to1HCar$GABA-df1to1$GABA)/dfNoMMCr$tCr
    
    
    df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    df1to1soft$GABAtoCr <- (df1to1softHCar$GABA-df1to1soft$GABA)/dfNoMMCr$tCr
    
    
    dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    dfFixedGauss$GABAtoCr <- (dfFixedGaussHCar$GABA-dfFixedGauss$GABA)/dfNoMMCr$tCr
    
    
    dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    dfFreeGauss$GABAtoCr <- (dfFreeGaussHCar$GABA-dfFreeGauss$GABA)/dfNoMMCr$tCr
    
    
    if (r == 'full'){
      p <- spvs_Correlation(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft,dfNoMMHCar,df1to1HCar,df1to1softHCar,dfFreeGaussHCar,dfFixedGaussHCar,df3to2HCar,df3to2softHCar)," / [tCr]",c("GABAtoCr"),c('No HCar','No HCar','No HCar','No HCar','No HCar','No HCar','No HCar','HCar','HCar','HCar','HCar','HCar','HCar','HCar'),c('NoMM','1to1','1to1soft','FreeGauss','FixedGauss','3to2','3to2soft','NoMM','1to1','1to1soft','FreeGauss','FixedGauss','3to2','3to2soft'),NULL,lowerLimit,upperLimit, 1)
    } else{
      p <- spvs_Correlation(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,dfNoMMHCar,df1to1HCar,df1to1softHCar,dfFreeGaussHCar,dfFixedGaussHCar)," / [tCr]",c("GABAtoCr"),c('No HCar','No HCar','No HCar','No HCar','No HCar','HCar','HCar','HCar','HCar','HCar'),c('NoMM','1to1','1to1soft','FreeGauss','FixedGauss','NoMM','1to1','1to1soft','FreeGauss','FixedGauss'),NULL,lowerLimit,upperLimit, 1,1)
    }
    
    ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/CorrHCar_diffGABA/',outname,r,k, 'Scatter.pdf',sep=''), p, width = 7.5, height = 5,device=cairo_pdf) #saves g
    
    
    if (r == 'full'){
      p <- spvs_Correlation_Facet(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft,dfNoMMHCar,df1to1HCar,df1to1softHCar,dfFreeGaussHCar,dfFixedGaussHCar,df3to2HCar,df3to2softHCar)," / [tCr]",c("GABAtoCr"),c('No HCar','No HCar','No HCar','No HCar','No HCar','No HCar','No HCar','HCar','HCar','HCar','HCar','HCar','HCar','HCar'),c('NoMM','1to1','1to1soft','FreeGauss','FixedGauss','3to2','3to2soft','NoMM','1to1','1to1soft','FreeGauss','FixedGauss','3to2','3to2soft'),NULL,lowerLimit,upperLimit, 1)
    } else{
      p <- spvs_Correlation_Facet(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,dfNoMMHCar,df1to1HCar,df1to1softHCar,dfFreeGaussHCar,dfFixedGaussHCar)," / [tCr]",c("GABAtoCr"),c('No HCar','No HCar','No HCar','No HCar','No HCar','HCar','HCar','HCar','HCar','HCar'),c('NoMM','1to1','1to1soft','FreeGauss','FixedGauss','NoMM','1to1','1to1soft','FreeGauss','FixedGauss'),NULL,lowerLimit,upperLimit, 1,1)
    }
    ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/CorrHCar_diffGABA/',outname,r,k, 'ScatterFacet.pdf',sep=''), p, width = 7.5, height = 5,device=cairo_pdf) #saves g
    
  }
}


# Correlation analysis of differences -----------------------------------
# Generate output for correaltion between HCar and differences in MM3co with and without HCar
knots <- list('055','04','025')
range <- list('full','inter','red')
filen <- 'diff1_amplMets_Voxel_1.csv'
outname <- 'NoHCarAndHCar'

dfNoMMCr <- read.csv('/Volumes/Samsung/working/ISMRM/Philips/full04/derivativesnone/QuantifyResults/off_amplMets_Voxel_1.csv', header = TRUE,stringsAsFactors = FALSE)
dfNoMMCr <- spvs_AddStatsToDataframe(dfNoMMCr,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')


for (k in knots) 
{
  for(r in range)
  {
    #Intermediate and reduced range
    dfNoMM <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,k, '/derivativesnone/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    df1to1 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,k, '/derivatives1to1GABA/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    df1to1soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,k, '/derivatives1to1GABAsoft/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    dfFixedGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,k, '/derivativesfreeGauss14/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    dfFreeGauss <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,k, '/derivativesfreeGauss/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    
    dfNoMMHCar <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,'Comb',k, '/derivativesnone/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    df1to1HCar <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,'Comb',k, '/derivatives1to1GABA/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    df1to1softHCar <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,'Comb',k, '/derivatives1to1GABAsoft/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    dfFixedGaussHCar <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,'Comb',k, '/derivativesfreeGauss14/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    dfFreeGaussHCar <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,'Comb',k, '/derivativesfreeGauss/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
    
    
    if (r == 'full'){
      # Full range
      df3to2 <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,k, '/derivatives3to2MM/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
      df3to2soft <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,k, '/derivatives3to2MMsoft/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
      
      df3to2HCar <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,'Comb',k, '/derivatives3to2MM/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
      df3to2softHCar <- read.csv(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,'Comb',k, '/derivatives3to2MMsoft/QuantifyResults/',filen,sep=''), header = TRUE,stringsAsFactors = FALSE)
      
      # Full range
      df3to2 <- spvs_AddStatsToDataframe(df3to2,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      
      
      df3to2soft <- spvs_AddStatsToDataframe(df3to2soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      
      
      df3to2HCar <- spvs_AddStatsToDataframe(df3to2HCar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      df3to2HCar$GABAtoCr <- (df3to2HCar$HCar)/dfNoMMCr$tCr
      
      df3to2softHCar <- spvs_AddStatsToDataframe(df3to2softHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
      df3to2softHCar$GABAtoCr <- (df3to2softHCar$HCar)/dfNoMMCr$tCr
      
      df3to2$GABAtoCr <- (df3to2HCar$MM09-df3to2$MM09)/dfNoMMCr$tCr
      df3to2soft$GABAtoCr <- (df3to2softHCar$MM3co-df3to2soft$MM3co)/dfNoMMCr$tCr
    }
    
    #Intermediate and reduced range
    dfNoMMHCar <- spvs_AddStatsToDataframe(dfNoMMHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    dfNoMMHCar$GABAtoCr <- dfNoMMHCar$HCar/dfNoMMCr$tCr
    
    
    df1to1HCar <- spvs_AddStatsToDataframe(df1to1HCar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    df1to1HCar$GABAtoCr <- df1to1HCar$HCar/dfNoMMCr$tCr
    
    
    df1to1softHCar <- spvs_AddStatsToDataframe(df1to1softHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    df1to1softHCar$GABAtoCr <- (df1to1softHCar$HCar)/dfNoMMCr$tCr
    
    
    dfFixedGaussHCar <- spvs_AddStatsToDataframe(dfFixedGaussHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    dfFixedGaussHCar$GABAtoCr <- (dfFixedGaussHCar$HCar)/dfNoMMCr$tCr
    
    
    dfFreeGaussHCar <- spvs_AddStatsToDataframe(dfFreeGaussHCar,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    dfFreeGaussHCar$GABAtoCr <- (dfFreeGaussHCar$HCar)/dfNoMMCr$tCr
    
    #Intermediate and reduced range
    dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    dfNoMM$GABAtoCr <- (dfNoMMHCar$GABA-dfNoMM$GABA)/dfNoMMCr$tCr
    
    
    df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    df1to1$GABAtoCr <- 2*(df1to1HCar$GABA-df1to1$GABA)/dfNoMMCr$tCr
    
    
    df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    df1to1soft$GABAtoCr <- (df1to1softHCar$MM3co-df1to1soft$MM3co)/dfNoMMCr$tCr
    
    
    dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    dfFixedGauss$GABAtoCr <- (dfFixedGaussHCar$MM3co-dfFixedGauss$MM3co)/dfNoMMCr$tCr
    
    
    dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMPred.csv')
    dfFreeGauss$GABAtoCr <- (dfFreeGaussHCar$MM3co-dfFreeGauss$MM3co)/dfNoMMCr$tCr
    
    
    if (r == 'full'){
      p <- spvs_Correlation(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft,dfNoMMHCar,df1to1HCar,df1to1softHCar,dfFreeGaussHCar,dfFixedGaussHCar,df3to2HCar,df3to2softHCar)," / [tCr]",c("GABAtoCr"),c('No HCar','No HCar','No HCar','No HCar','No HCar','No HCar','No HCar','HCar','HCar','HCar','HCar','HCar','HCar','HCar'),c('NoMM','1to1','1to1soft','FreeGauss','FixedGauss','3to2','3to2soft','NoMM','1to1','1to1soft','FreeGauss','FixedGauss','3to2','3to2soft'),NULL,lowerLimit,upperLimit, 1)
    } else{
      p <- spvs_Correlation(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,dfNoMMHCar,df1to1HCar,df1to1softHCar,dfFreeGaussHCar,dfFixedGaussHCar)," / [tCr]",c("GABAtoCr"),c('No HCar','No HCar','No HCar','No HCar','No HCar','HCar','HCar','HCar','HCar','HCar'),c('NoMM','1to1','1to1soft','FreeGauss','FixedGauss','NoMM','1to1','1to1soft','FreeGauss','FixedGauss'),NULL,lowerLimit,upperLimit, 1,1)
    }
    
    ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/CorrHCar_diffMM3co/',outname,r,k, 'Scatter.pdf',sep=''), p, width = 7.5, height = 5,device=cairo_pdf) #saves g
    
    
    if (r == 'full'){
      p <- spvs_Correlation_Facet(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft,dfNoMMHCar,df1to1HCar,df1to1softHCar,dfFreeGaussHCar,dfFixedGaussHCar,df3to2HCar,df3to2softHCar)," / [tCr]",c("GABAtoCr"),c('No HCar','No HCar','No HCar','No HCar','No HCar','No HCar','No HCar','HCar','HCar','HCar','HCar','HCar','HCar','HCar'),c('NoMM','1to1','1to1soft','FreeGauss','FixedGauss','3to2','3to2soft','NoMM','1to1','1to1soft','FreeGauss','FixedGauss','3to2','3to2soft'),NULL,lowerLimit,upperLimit, 1)
    } else{
      p <- spvs_Correlation_Facet(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,dfNoMMHCar,df1to1HCar,df1to1softHCar,dfFreeGaussHCar,dfFixedGaussHCar)," / [tCr]",c("GABAtoCr"),c('No HCar','No HCar','No HCar','No HCar','No HCar','HCar','HCar','HCar','HCar','HCar'),c('NoMM','1to1','1to1soft','FreeGauss','FixedGauss','NoMM','1to1','1to1soft','FreeGauss','FixedGauss'),NULL,lowerLimit,upperLimit, 1,1)
    }
    ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/CorrHCar_diffMM3co/',outname,r,k, 'ScatterFacet.pdf',sep=''), p, width = 7.5, height = 5,device=cairo_pdf) #saves g
    
  }
}
