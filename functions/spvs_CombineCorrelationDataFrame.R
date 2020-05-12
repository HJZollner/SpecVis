spvs_CombineCorrelationDataFrame <- function(dataFrames,Metabs,GroupVarNames1,GroupVarNames2,HueVar){
  # spvs_CombineCorrelationDataFrame <- function(dataFrames,Metabs,GroupVarNames1,GroupVarNames2,HueVar)
  # This function combines data frames for the correaltion facet plot and is called within the
  # spvs_Correaltion and spvs_Correaltion_Facet calls.  It is based on the dataFrame and MeasureVar lits
  #
  #   USAGE:
  #     df <- spvs_CombineCorrelationDataFrame(dataFrames,Metabs,GroupVarNames1,GroupVarNames2,HueVar)
  #
  #   INPUTS:
  #     dataFrames = dataFrame or list of dataFrames
  #     Metabs = list of measurement variables (e.g. c('tNAA','Glx')).
  #     GroupVarNames1 = list of names of the x and y axis of the correaltion plot
  #     GroupVarNames2 = list of names which determine the color of the datapoints
  #     HueVar = list of names which determines the hue variation 
  #
  #
  #   OUTPUTS:
  #     df     = sorted data frame for the correaltion plot
  #     
  #   AUTHOR:
  #     Dr. Helge Zöllner (Johns Hopkins University, 2020-04-15)
  #     hzoelln2@jhmi.edu
  #         
  #   CREDITS:    
  #     This code is based on numerous functions from the spant toolbox by
  #     Dr. Martin Wilson (University of Birmingham)
  #     https://martin3141.github.io/spant/index.html
  #      
  #      
  #   HISTORY:
  #     2020-04-15: First version of the code.
  # 1 Combine data frame ---------------------------------------------------------- 
  dfNumber <- 1
  uniqueCorr <- unique(GroupVarNames1)
  if (length(GroupVarNames1) == length(GroupVarNames2)){ # A list of data frames is combined
  for (df in dataFrames){
    df$Group1 <- rep(GroupVarNames1[dfNumber],nrow(df))
    df$Group2 <- rep(GroupVarNames2[dfNumber],nrow(df))
    dataFrames[[dfNumber]] <- df
    dfNumber <- dfNumber + 1
  }}
  else{ # A single data frame is passed and a number of MeasureVars are correalted 
  for (df in dataFrames){
    df$Group2 <- rep(GroupVarNames2[dfNumber],nrow(df))
    dataFrames[[dfNumber]] <- df
    dfNumber <- dfNumber + 1
  }
  }
  CombineDataFrame <- dplyr::bind_rows(dataFrames)
  # 2 Sort data frame ---------------------------------------------------------- 
  MeasureVar1 <- NULL
  MeasureVar2 <- NULL
  HueVarOut <- NULL  
  if (length(GroupVarNames1) == length(GroupVarNames2)){# A list of data frames is combined
    Group <- NULL
    MetaboliteNum <- NULL
    MetabName <- NULL
    MetabNum <- length(Metabs);
    dataFrame1 <- select(filter(CombineDataFrame, Group1 == uniqueCorr[[1]]),c(names(CombineDataFrame)))
    dataFrame2 <- select(filter(CombineDataFrame, Group1 == uniqueCorr[[2]]),c(names(CombineDataFrame)))
  for (metab in Metabs){
    MeasureVar1 <- cbind(MeasureVar1, dataFrame1[names(dataFrame1) == metab][[1]])
    MeasureVar2 <- cbind(MeasureVar2, dataFrame2[names(dataFrame2) == metab][[1]])
    if (!is.null(HueVar)){
      HueVarOut <- cbind(HueVarOut, dataFrame1[names(dataFrame1) == HueVar[[1]]][[1]])
    }
    Group <- rbind(Group,dataFrame1$Group2)
    MetaboliteNum <- rbind(MetaboliteNum,rep(MetabNum,nrow(dataFrame1)))
    MetabName <- rbind(MetabName,rep(metab,nrow(dataFrame1)))
    MetabNum <- MetabNum - 1
  }
  
  MeasureVar1 = c(MeasureVar1)
  MeasureVar2 = c(MeasureVar2)
  Group = array(t(Group))
  MetaboliteNum = array(t(MetaboliteNum))
  MetabName = array(t(MetabName))
  if (is.null(HueVar)){ #No hue is applied
  CombineDataFrame = data.frame(MeasureVar1,MeasureVar2,Group,MetaboliteNum,MetabName)
  }
  else{
    HueVar = c(HueVarOut)
    CombineDataFrame = data.frame(MeasureVar1,MeasureVar2,Group,MetaboliteNum,MetabName,HueVar)  
  }}
  
  else{# A single data frame is passed and a number of MeasureVars are correalted
    dataFrame1 <- CombineDataFrame
    Group <- NULL
    MetaboliteNum <- NULL
    MetabName <- NULL
    MetabNum <- length(Metabs)/2;
    for (n in  0:((length(Metabs)/2)-1)){
      MeasureVar1 <- cbind(MeasureVar1, dataFrame1[names(dataFrame1) == Metabs[[(2*n+1)]]][[1]])
      MeasureVar2 <- cbind(MeasureVar2, dataFrame1[names(dataFrame1) == Metabs[[(2*n+2)]]][[1]])
      if (!is.null(HueVar)){
        HueVarOut <- cbind(HueVarOut, dataFrame1[names(dataFrame1) == HueVar[[1]]][[1]])
      }
      Group <- rbind(Group,dataFrame1$Group2)
      MetaboliteNum <- rbind(MetaboliteNum,rep(MetabNum,nrow(dataFrame1)))
      MetabName <- rbind(MetabName,rep(paste(Metabs[[(2*n+1)]],Metabs[[(2*n+2)]],sep = ' vs '),nrow(dataFrame1)))
      MetabNum <- MetabNum - 1
    }
    
    MeasureVar1 = c(MeasureVar1)
    MeasureVar2 = c(MeasureVar2)
    Group = array(t(Group))
    MetaboliteNum = array(t(MetaboliteNum))
    MetabName = array(t(MetabName))
    if (is.null(HueVar)){# NO hue is applied
      CombineDataFrame = data.frame(MeasureVar1,MeasureVar2,Group,MetaboliteNum,MetabName)
    }
    else
    {
      HueVar = c(HueVarOut)
      CombineDataFrame = data.frame(MeasureVar1,MeasureVar2,Group,MetaboliteNum,MetabName,HueVar)  
    }   
    }
}# end of function