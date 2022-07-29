spvs_part_corr <- function(dataFrame,MeasureVar,CorrVar,filename,covar, weighting){
  # spvs_part_corr <- function(dataFrame,MeasureVar)
  # Performs correlation statisitcs using with an automatic loop over the list of measure variables.
  # A vector with covariables and weights can also be inlcuded to perform partial or weighted correlations.
  #
  #   USAGE:
  #     stats <- spvs_lm_group <- function(dataFrame,MeasureVar,paired)
  #
  #   INPUTS:
  #     dataFrame = combined data frame (e.g. dfdata) (use spvs_ConcatenateDataFrame to create a single data frame)
  #     MeasureVar = list of measurement variables (e.g. c('tNAA','Glx')). default = 'tNAA'.
  #     CorrVar = variable to correlate the results with
  #     filename = path to filename for outputs
  #     covar = covariate for the statistic (e.g. age)
  #     weighting = weights variable for the statisitics (e.g. inverse absolute CRLBs)
  #
  #
  #   OUTPUTS:
  #     p     = list of p-values
  #     
  #   AUTHOR:
  #     Dr. Helge Zöllner (Johns Hopkins University, 2021-05-08)
  #     hzoelln2@jhmi.edu
  #         
  #   CREDITS:    
  #     This code is based on numerous functions from the spant toolbox by
  #     Dr. Martin Wilson (University of Birmingham)
  #     https://martin3141.github.io/spant/index.html
  #      
  #      
  #   HISTORY:
  #     2021-05-08: First version of the code.
  # 1 Falling back into defaults ---------------------------------------------------------- 
  
  source('functions/summarySE.r')
  source('functions/weights_071/wtd.cor.r')
  source('functions/weights_071/wtd.partial.cor.r')
  source('functions/weights_071/onecor.wtd.r')
  source('functions/weights_071/onecor.partial.wtd.r')
  #Check its existence
  if (file.exists(filename)) {
    #Delete file if it exists
    file.remove(filename)
  }
  
  # 1 partial correlations () calculations ----------------------------------------------------------  
  p <- NULL
  for (mm in 1:length(MeasureVar)){
    meas <- MeasureVar[[mm]]
    measure <- dataFrame[names(dataFrame) == meas][[1]]
    corrvar <- dataFrame[names(dataFrame) == CorrVar][[1]]
    
    if(missing(covar)){
      if(missing(weighting)){
         cors <- wtd.cor(corrvar,measure,weight = NULL)}
      else{
        weighting_factors <- dataFrame[names(dataFrame) == weighting[[mm]]][[1]]  
        cors <- wtd.cor(corrvar,measure,weight = weighting_factors)
      }
    }
    else{
      if(missing(weighting)){
        covariate <- dataFrame[names(dataFrame) == covar][[1]]
        cors <- wtd.partial.cor(corrvar,measure,covariate,weight = NULL)
      }
      else{
        covariate <- dataFrame[names(dataFrame) == covar][[1]]
        weighting_factors <- dataFrame[names(dataFrame) == weighting[[mm]]][[1]]
        cors <- wtd.partial.cor(corrvar,measure,covariate,weight = weighting_factors)
      }}
    # lms_summary <- summary(lms)
    row.names(cors)[[1]] <- meas[[1]]
    sink(filename,append = TRUE)
    cat( '\n')
    sink()  # returns output to the console
    sink(filename,append = TRUE)
    print(cors)
    sink()  # returns output to the console
    p <- rbind(p, cors[[4]])
  }
  
  
    ## Let's do within group
    if("Group" %in% colnames(dataFrame)){
      Group <- dataFrame[names(dataFrame) == 'Group'][[1]]
      names <- unique(Group)
      for (gg in 1:length(names)){
        name <- names[[gg]]
        dataFrameRed <- subset(dataFrame, Group == name)
        if (length(rownames(dataFrameRed)) > 2){
        sink(filename,append = TRUE)
        cat(name,'\n')
        sink()  # returns output to the console
        for (mm in 1:length(MeasureVar)){
          meas <- MeasureVar[[mm]]
          measure <- dataFrameRed[names(dataFrameRed) == meas][[1]]
          corrvar <- dataFrameRed[names(dataFrameRed) == CorrVar][[1]]
          
          if(missing(covar)){
            if(missing(weighting)){
              cors <- wtd.cor(corrvar,measure,weight = NULL)}
            else{
              weighting_factors <- dataFrameRed[names(dataFrameRed) == weighting[[mm]]][[1]]  
              cors <- wtd.cor(corrvar,measure,weight = weighting_factors)
            }
          }
          else{
            if(missing(weighting)){
              covariate <- dataFrameRed[names(dataFrameRed) == covar][[1]]
              cors <- wtd.partial.cor(corrvar,measure,covariate,weight = NULL)
            }
            else{
              covariate <- dataFrameRed[names(dataFrameRed) == covar][[1]]
              weighting_factors <- dataFrameRed[names(dataFrameRed) == weighting[[mm]]][[1]]
              cors <- wtd.partial.cor(corrvar,measure,covariate,weight = weighting_factors)
            }}
          row.names(cors)[[1]] <- paste(name[[1]], meas[[1]])
          sink(filename,append = TRUE)
          cat('\n')
          sink()  # returns output to the console
          sink(filename,append = TRUE)
          print(cors)
          sink()  # returns output to the console
          p <- rbind(p, cors[[4]])
      }
        }
      }
    }
  p
}
