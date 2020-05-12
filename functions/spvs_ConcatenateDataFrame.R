spvs_ConcatenateDataFrame <- function(dataFrames,GroupVarNames){
  # spvs_ConcatenateDataFrame <- function(dataFrames,GroupVarNames)
  # This function concatenates data frames and adds a column with group names
  #
  #   USAGE:
  #     df <- spvs_ConcatenateDataFrame(dataFrames,GroupVarNames)
  #
  #   INPUTS:
  #     dataFrames = dataFrame or list of dataFrames
  #     GroupVarNames = list of group names, which will be attachted as a column at the end of the data frame
  #
  #
  #   OUTPUTS:
  #     df     = conctenated data frame
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
  for (df in dataFrames){
    df$Group <- rep(GroupVarNames[dfNumber],nrow(df))
    dataFrames[[dfNumber]] <- df
    dfNumber <- dfNumber + 1
  }
  ConcDataFrame <- dplyr::bind_rows(dataFrames)
}