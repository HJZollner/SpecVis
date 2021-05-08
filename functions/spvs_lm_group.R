spvs_lm_group <- function(dataFrame,MeasureVar,filename,covar, weighting){
  # spvs_lm_group <- function(dataFrame,MeasureVar)
  # Performs model statisitcs using lm() with an automatic loop over the list of measure variables.
  # A vector with covariables and weights can also be inlcuded.
  #
  #   USAGE:
  #     stats <- spvs_lm_group <- function(dataFrame,MeasureVar,paired)
  #
  #   INPUTS:
  #     dataFrame = combined data frame (e.g. dfdata) (use spvs_ConcatenateDataFrame to create a single data frame)
  #     MeasureVar = list of measurement variables (e.g. c('tNAA','Glx')). default = 'tNAA'.
  #     filename = path to filename for outputs
  #     covar = covariate for the statistic 9e.g. age)
  #     weighting = weights variable for the statisitics (e.g. inverse absolute CRLBs)
  #
  #
  #   OUTPUTS:
  #     p values     =  vector with resulting p-values
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
  
  #Check its existence
  if (file.exists(filename)) {
    #Delete file if it exists
    file.remove(filename)
  }
  
  # 1 Descriptive stats ---------------------------------------------------------- 
  descriptive <- NULL
  for (meas in MeasureVar){
    summ <- summarySE(dataFrame, measurevar = meas, groupvars='Group')
    summ$Group <- paste(meas, summ$Group)
    descriptive <- rbind(descriptive,summ)
  }  
  descriptive<-  descriptive %>% 
    select(-min) %>%
    select(-max)
    sink(filename,append = TRUE)
    print(descriptive)
    sink()  # returns output to the console
  
  # 2 lm () calculations ----------------------------------------------------------  
  stat <- NULL
  p <- NULL
  for (mm in 1:length(MeasureVar)){
    meas <- MeasureVar[[mm]]
    measure <- dataFrame[names(dataFrame) == meas][[1]]
    Group <- dataFrame[names(dataFrame) == 'Group'][[1]]
    
    if(missing(covar)){
      if(missing(weighting)){
      dfVarAn = data.frame(measure,Group)
      lms <- lm(measure ~ Group, data = dfVarAn)}
      else{
        weighting_factors <- dataFrame[names(dataFrame) == weighting[[mm]]][[1]]  
        dfVarAn = data.frame(measure,Group,weighting_factors)
        lms <- lm(measure ~ Group, data = dfVarAn, weights = weighting_factors)
      }
    }
    else{
    if(missing(weighting)){
      covariate <- dataFrame[names(dataFrame) == covar][[1]]
      dfVarAn = data.frame(measure,Group,covariate)
      lms <- lm(measure ~ covariate + Group, data = dfVarAn)
      
      }
    else{
      covariate <- dataFrame[names(dataFrame) == covar][[1]]
      weighting_factors <- dataFrame[names(dataFrame) == weighting[[mm]]][[1]]
      dfVarAn = data.frame(measure,Group,covariate,weighting_factors)
      lms <- lm(measure ~ covariate + Group, data = dfVarAn, weights = weighting_factors)
    }}
    # lms_summary <- summary(lms)
    sink(filename,append = TRUE)
    print(meas)
    sink()  # returns output to the console
    sink(filename,append = TRUE)
    print(lms)
    sink()  # returns output to the console
    sink(filename,append = TRUE)
    print(summary(lms))
    sink()  # returns output to the console
    p <- rbind(p,pf(summary(lms)$fstatistic[1],summary(lms)$fstatistic[2],summary(lms)$fstatistic[3],lower.tail=FALSE))
  }
  p
}