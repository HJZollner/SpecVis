## For correlation with Gannet
knots <- list('055','04','025')
range <- list('full','inter','red')
comb <- list('','Comb')
filen <- 'diff1_amplMets.csv'
outname <- 'GABAtoCrConc'

dfGannet68 <- read.csv('/Volumes/Samsung/working/ISMRM/GannetBigGABA68.csv', header = TRUE,stringsAsFactors = FALSE)
dfGannet68 <- dfGannet68[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]

dfNoMMCr <- spvs_importResults('/Volumes/Samsung/working/ISMRM/Philips/full04/derivativesnone/QuantifyResults/off_amplMets.csv')
dfNoMMCr <- spvs_AddStatsToDataframe(dfNoMMCr,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
dfNoMMCr <- dfNoMMCr[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]




for (k in knots) 
{
  for(r in range)
  {
    for(c in comb){
      #Intermediate and reduced range
      dfNoMM <- spvs_importResults(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,c, k, '/derivativesnone/QuantifyResults/',filen,sep=''))
      df1to1 <- spvs_importResults(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,c, k, '/derivatives1to1GABA/QuantifyResults/',filen,sep=''))
      df1to1soft <- spvs_importResults(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,c, k, '/derivatives1to1GABAsoft/QuantifyResults/',filen,sep=''))
      dfFixedGauss <- spvs_importResults(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,c, k, '/derivativesfreeGauss14/QuantifyResults/',filen,sep=''))
      dfFreeGauss <- spvs_importResults(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,c, k, '/derivativesfreeGauss/QuantifyResults/',filen,sep=''))
      
      if (r == 'full'){
        # Full range
        df3to2 <- spvs_importResults(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,c, k, '/derivatives3to2MM/QuantifyResults/',filen,sep=''))
        df3to2soft <- spvs_importResults(paste('/Volumes/Samsung/working/ISMRM/Philips/', r,c, k, '/derivatives3to2MMsoft/QuantifyResults/',filen,sep=''))
        
        # Full range
        df3to2 <- spvs_AddStatsToDataframe(df3to2,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
        df3to2 <- df3to2[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
        if (c == ''){
        df3to2$GABAtoCr <- (df3to2$GABA+df3to2$MM09)/dfNoMMCr$tCr*0.5}
        else{
          df3to2$GABAtoCr <- (df3to2$GABA+df3to2$MM09+df3to2$HCar)/dfNoMMCr$tCr*0.5
        }
        df3to2$Gannet <- dfGannet68
        
        df3to2soft <- spvs_AddStatsToDataframe(df3to2soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
        df3to2soft <- df3to2soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
        if (c == ''){
        df3to2soft$GABAtoCr <- (df3to2soft$GABA+df3to2soft$MM3co)/dfNoMMCr$tCr*0.5}
        else{
          df3to2soft$GABAtoCr <- (df3to2soft$GABA+df3to2soft$MM3co+df3to2soft$HCar)/dfNoMMCr$tCr*0.5
       }
        df3to2soft$Gannet <- dfGannet68 
      }
      
      #Intermediate and reduced range
      dfNoMM <- spvs_AddStatsToDataframe(dfNoMM,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
      dfNoMM <- dfNoMM[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
      if (c == ''){
      dfNoMM$GABAtoCr <- dfNoMM$GABA/dfNoMMCr$tCr*0.5}
      else{
        dfNoMM$GABAtoCr <- (dfNoMM$GABA+dfNoMM$HCar)/dfNoMMCr$tCr*0.5
      }
      dfNoMM$Gannet <- dfGannet68
      
      df1to1 <- spvs_AddStatsToDataframe(df1to1,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
      df1to1 <- df1to1[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
      if (c == ''){
      df1to1$GABAtoCr <- df1to1$GABA/dfNoMMCr$tCr}
      else{
        df1to1$GABAtoCr <- (df1to1$GABA+df1to1$HCar)/dfNoMMCr$tCr
      }
      df1to1$Gannet <- dfGannet68
      
      df1to1soft <- spvs_AddStatsToDataframe(df1to1soft,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
      df1to1soft <- df1to1soft[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
      if (c == ''){
      df1to1soft$GABAtoCr <- (df1to1soft$GABA+df1to1soft$MM3co)/dfNoMMCr$tCr*0.5}
      else{
        df1to1soft$GABAtoCr <- (df1to1soft$GABA+df1to1soft$MM3co+df1to1soft$HCar)/dfNoMMCr$tCr*0.5
      }
      df1to1soft$Gannet <- dfGannet68
      
      dfFixedGauss <- spvs_AddStatsToDataframe(dfFixedGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
      dfFixedGauss <- dfFixedGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
      if (c == ''){
      dfFixedGauss$GABAtoCr <- (dfFixedGauss$GABA+dfFixedGauss$MM3co)/dfNoMMCr$tCr*0.5}
      else{
        dfFixedGauss$GABAtoCr <- (dfFixedGauss$GABA+dfFixedGauss$MM3co+dfFixedGauss$HCar)/dfNoMMCr$tCr*0.5
      }
      dfFixedGauss$Gannet <- dfGannet68
      
      dfFreeGauss <- spvs_AddStatsToDataframe(dfFreeGauss,'/Volumes/Samsung/working/ISMRM/Philips/statMP.csv')
      dfFreeGauss <- dfFreeGauss[-c(5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,26,27,34,35,36,37,38,39,40,41,42,43,44,45,74,78,79,81,98,99,100,101,102,103,104,105,106,107,108,109),]
      if (c == ''){
      dfFreeGauss$GABAtoCr <- (dfFreeGauss$GABA+dfFreeGauss$MM3co)/dfNoMMCr$tCr*0.5}
      else{
        dfFreeGauss$GABAtoCr <- (dfFreeGauss$GABA+dfFreeGauss$MM3co+dfFreeGauss$HCar)/dfNoMMCr$tCr*0.5
      }
      dfFreeGauss$Gannet <- dfGannet68
      
      if (r == 'full'){
        # Full range
        dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))
        dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss,df3to2,df3to2soft),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss','G-MM09Fixed','H-soft3to2MM09'))}
      else {
        #Intermediate and reduced range
        dfModels <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))
        dfModelsOsprey <- spvs_ConcatenateDataFrame(list(dfNoMM,df1to1,df1to1soft,dfFreeGauss,dfFixedGauss),c('B-NoMM','C-GABAFixed','D-soft1to1GABA','E-FixedGauss','F-FreeGauss'))}
      if (r == 'full'){
        MM09hard <- df3to2[,c('GABAtoCr')]
        MM09soft <- df3to2soft[,c('GABAtoCr')]
        }

        none <- dfNoMM[,c('GABAtoCr')]
        GABAhard <- df1to1[,c('GABAtoCr')]
        GABAsoft <- df1to1soft[,c('GABAtoCr')]
        GaussFixed <- dfFixedGauss[,c('GABAtoCr')]
        GaussFree <- dfFreeGauss[,c('GABAtoCr')]
      
      if (r == 'full'){
        M <-cbind(dfGannet68, none,GABAhard,GABAsoft,GaussFixed,GaussFree,MM09hard,MM09soft)    
      } else{
        M <-cbind(dfGannet68, none,GABAhard,GABAsoft,GaussFixed,GaussFree)    
      }
      
      corr <- cor(M)
      
      
      
      col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
      pdf(file=paste('/Volumes/Samsung/working/ISMRM/Philips/',outname,r,k,c, 'Corr.pdf',sep=''), width = 7.5, height = 3) #saves g
      corrpl <- corrplot(corr, method = "ellipse", col = col(200), cl.lim = c(-1, 1),
                         type = "upper", number.cex = .7, is.corr = FALSE,
                         addCoef.col = "black", # Add coefficient of correlation
                         tl.col = "black", tl.srt = 90, # Text label color and rotation
                         # hide correlation coefficient on the principal diagonal
                         diag = FALSE)
      dev.off()
      
      
      pscat <- ggplot(data=dfModels, aes(x=GABAtoCr, y=Gannet)) +
        geom_point()+ facet_grid(cols = vars(Group))
      ggsave(file=paste('/Volumes/Samsung/working/ISMRM/Philips/',outname,r,k,c, 'Scatter.pdf',sep=''), pscat, width = 7.5, height = 3,device=cairo_pdf) #saves g
      
    }
  }
}
