spvs_AddStatsToDataframe <- function(dataFrame,statfile){
  # spvs_AddStatsToDataframe <- function(dataFrame,statfile)
  # This function imports a stat .csv-file and concatenates it to an existing dataframe. 
  #
  #   USAGE:
  #     df <- spvs_AddStatsToDataframe(dataFrame,statfile)
  #
  #   INPUTS:
  #     dataFrame = data frame the stat file should be added to
  #     statfile = path to the stat file 
  #             
  #   OUTPUTS:
  #     dataFrame     = dataframe (Osprey) with the added stat file
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
  
  dfStat <- read.csv(statfile, stringsAsFactors = FALSE, check.names=FALSE)
  mergeddataFrame <- bind_cols(dataFrame,dfStat) 
} # end of function