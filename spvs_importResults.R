spvs_importResults <- function(dir,quant){
  # spvs_importLCMResults <- function(dir,quant)
  # This function imports all result files from major MRS packages (Osprey, LCModel, Tarquin) into one dataframe
  #
  #
  #   USAGE:
  #     df <- spvs_importResults(dir,quant)
  #
  #   INPUTS:
  #     dir = path to csv file (Osprey) or folder with .coord files (LCModel) / .csv files (Tarquin)
  #     quant = string specifiy if 'tCr' ratios should be imported (default), for Osprey the corresponding files ahs to chosen 
  #             otherwise water scaled amplitudes (in case water scan was provided to LCModel) or amplitudes are imported  
  #             
  #   OUTPUTS:
  #     list     = dataframe (Osprey) or List with amplitudes, CRLBs and diagnostics from the .coord/csv files (LCModel/Tarquin)
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
  # 1 Falling back into defaults ----------------------------------------------------------  
  if(missing(quant)){
    quant <- "tCr"
  }
  source("spvs_importOspreyResults.R")
  source("spvs_importLCMResults.R")
  source("spvs_importTarquinResults.R")

# 2 Import data according to file type ------------------------------------
  if(file_test('-f',dir)){
    data <- spvs_importOspreyResults(dir)
  }
  else{
    files <- list.files(path = dir)
    if(length(grep('.coord', files)) > 0){
      data <- spvs_importLCMResults(dir,quant)
    }
    else{
      data <- spvs_importTarquinResults(dir,quant)
    }
  }
  # 3 Create output ---------------------------------------------------------
  return(data)
} # end of function