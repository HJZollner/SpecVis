spvs_importTarquinResults <- function(dir,quant) {
  # spvs_importTarquinResults <- function(dir,quant)
  # This function imports Tarquin csv result files from a directory into one dataframe
  #
  #
  #   USAGE:
  #     spvs_importTarquinResults <- function(dir,quant)
  #
  #   INPUTS:
  #     dir = folder with Tarquin .csv files
  #     quant = string specifiy if 'tCr' ratios should be imported (default)
  #             otherwise water scaled amplitudes (in case water scan was provided to LCModel) or amplitudes are imported  
  #             
  #   OUTPUTS:
  #     list     = List with amplitudes, CRLBs and diagnostics from the .coord file
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
  # 2 Import files ---------------------------------------------------------
  #Create a list with all .csv files in the directory 
  files <- list.files(path = dir,pattern = ".csv$",full.names = TRUE)
  
  results <- NULL
  for (file in files) {
    subject <- read_tqn_result(file)
    results$amps <- rbind(results$amps, subject$amps)
    results$crlbs <- rbind(results$crlbs, subject$crlbs)
    results$diags <- rbind(results$diags, subject$diags)
  }
  
  source('functions/spvs_createDataFrame.R')
  amps <- spvs_createDataFrame(results$amps)
  crlbs <- spvs_createDataFrame(results$crlbs)
  
  #Normalize to tCr
  tempAmp <- amps$TCr
  if (quant == 'tCr'){
    amps <- amps / tempAmp
    crlbs <- crlbs / tempAmp
  }
  
  # 3 Create dataframe ------------------------------------------------------
  # Create a dataframe from the imported list and rename it to defined defaults to allow dataframe subsetting  
  if('X.CrCH2' %in% colnames(amps)){
    amps <- plyr::rename(amps, c('X.CrCH2' = 'CrCH2'))
    crlbs <- plyr::rename(crlbs, c('X.CrCH2' = 'CrCH2'))
  }
  if('Glth' %in% colnames(amps)){
    amps <- plyr::rename(amps, c('Glth' = 'GSH'))
    crlbs <- plyr::rename(crlbs, c('Glth' = 'GSH'))
  }
  if('PEth' %in% colnames(amps)){
    amps <- plyr::rename(amps, c('PEth' = 'PE'))
    crlbs <- plyr::rename(crlbs, c('PEth' = 'PE'))
  }
  if('TNAA' %in% colnames(amps)){
    amps <- plyr::rename(amps, c('TNAA' = 'tNAA'))
    crlbs <- plyr::rename(crlbs, c('TNAA' = 'tNAA'))
  }
  if('TCr' %in% colnames(amps)){
    amps <- plyr::rename(amps, c('TCr' = 'tCr'))
    crlbs <- plyr::rename(crlbs, c('TCr' = 'tCr'))
  }
  if('TCho' %in% colnames(amps)){
    amps <- plyr::rename(amps, c('TCho' = 'tCho'))
    crlbs <- plyr::rename(crlbs, c('TCho' = 'tCho'))
  }
  # 4 Create output ---------------------------------------------------------
  return(list(amps,crlbs,results$diags))
} #end of function