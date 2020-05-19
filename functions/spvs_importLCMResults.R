spvs_importLCMResults <- function(dir,quant) {
  # spvs_importLCMResults <- function(dir,quant)
  # This function imports LCM coord files from a directory into one Dataframe
  #
  #
  #   USAGE:
  #     spvs_importLCMResults <- function(dir,quant)
  #
  #   INPUTS:
  #     dir = folder with LCModel .coord files
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
  # Create a list with all .coord files in the directory 
  files <- list.files(path = dir,pattern = ".coord$",full.names = TRUE)
  # Loop over files  
  results <- NULL
  for (file in files) { #start file loop
    subject <- read_lcm_coord(file)
    results$amps <- rbind(results$amps, subject$res_tab$amps)
    results$crlbs <- rbind(results$crlbs, subject$res_tab$crlbs)
    results$diags <- rbind(results$diags, subject$res_tab$diags)
  } #end file loop

  # 3 Create dataframe ------------------------------------------------------
  # Create a dataframe from the imported list and rename it to defined defaults to allow dataframe subsetting
  source('functions/spvs_createDataFrame.R')
  amps <- spvs_createDataFrame(results$amps)
  crlbs <- spvs_createDataFrame(results$crlbs)
  
  if('-CrCH2' %in% colnames(amps)){
    amps <- plyr::rename(amps, c('-CrCH2' = 'CrCH2'))
    crlbs <- plyr::rename(crlbs, c('-CrCH2' = 'CrCH2'))
  }
  if('NAA+NAAG' %in% colnames(amps)){
    amps <- plyr::rename(amps, c('NAA+NAAG' = 'tNAA'))
    crlbs <- plyr::rename(crlbs, c('NAA+NAAG' = 'tNAA'))
  }
  if('Cr+PCr' %in% colnames(amps)){
    amps <- plyr::rename(amps, c('Cr+PCr' = 'tCr'))
    crlbs <- plyr::rename(crlbs, c('Cr+PCr' = 'tCr'))
  }
  if('PCh+GPC' %in% colnames(amps)){
    amps <- plyr::rename(amps, c('PCh+GPC' = 'tCho'))
    crlbs <- plyr::rename(crlbs, c('PCh+GPC' = 'tCho'))
  }
  if('Glu+Gln' %in% colnames(amps)){
    amps <- plyr::rename(amps, c('Glu+Gln' = 'Glx'))
    crlbs <- plyr::rename(crlbs, c('Glu+Gln' = 'Glx'))
  }
  if('Glc+Tau' %in% colnames(amps)){
    amps <- plyr::rename(amps, c('Glc+Tau' = 'GlcTau'))
    crlbs <- plyr::rename(crlbs, c('Glc+Tau' = 'GlcTau'))
  }
  #Normalize to tCr
  if (quant == 'tCr'){
    amps <- amps / amps$tCr
  }

  # 4 Create output ---------------------------------------------------------
  return(list(amps,crlbs,results$diags))
} # end of function