spvs_importOspreyResults <- function(file) 
{
  # spvs_importOspreyResults <- function(file)
  # This function imports a result file from Osprey
  #
  #
  #   USAGE:
  #     spvs_importOspreyResults <- function(file)
  #
  #   INPUTS:
  #     file = path to csv file (Osprey)
  #             
  #   OUTPUTS:
  #     dataframe     = dataframe (Osprey) with results
  #     
  #   AUTHOR:
  #     Dr. Helge Zöllner (Johns Hopkins University, 2020-03-28)
  #     hzoelln2@jhmi.edu
  #         
  #   CREDITS:    
  #     This code is based on numerous functions from the spant toolbox by
  #     Dr. Martin Wilson (University of Birmingham)
  #     https://martin3141.github.io/spant/index.html
  #      
  #      
  #   HISTORY:
  #     2020-03-28: First version of the code.
  # 1 Import data ----------------------------------------------------------  
  
  #Load Osprey output csv
  dfOsp <- read.csv(file,stringsAsFactors = FALSE)

# 2 Create output ---------------------------------------------------------
  return(dfOsp)
}