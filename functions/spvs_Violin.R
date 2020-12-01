spvs_Violin<- function(dataFrame,Quant,MeasureVar,GroupVars,lowerLimits,upperLimits,title,colNum,legendTitle){
  # spvs_Violin <- function(dataFrame,Quant,MeasureVar,GroupVars,lowerLimits,upperLimits,title,colNum,legendTitle)
  # This function creates violinplots with individual data pointsfrom the imported dataframe. You can concatenate different 
  # frames with spvs_ConcatenateDataframe.R (e.g. from different tools) beforehand. The data
  # will autaomatically be facceted in case a list of measurments is passed.
  #
  #   USAGE:
  #     p <- spvs_Boxplot(dataFrame,Quant,MeasureVar,GroupVars,lowerLimits,upperLimits,title,colNum,legendTitle)
  #
  #   INPUTS:
  #     dataFrame = data frame with metabolite estiamtes
  #     Quant = name of the quantification for labelling purposes. default = '/ [tCr]'.
  #     MeasureVar = list of measurement variables (e.g. c('tNAA','Glx')). default = 'tNAA'.
  #     GroupVars = name of the column with the group variables. spvs_ConcatenateDataframe uses 'Group' by default. default = 'all datasets'
  #     lowerLimits/upperLimits = list of facet upper und lower axis Limits. You need to add one value per MeasureVar and 5 % margin will be added.
  #     title = title of the figure. default = MeasureVar / Quant or '[metabolite] / Quant' for lists.
  #     colNum = number of columns for the facet. default = 2. 
  #     legendTitle = title of the legend. default = ''.
  #
  #
  #   OUTPUTS:
  #     p     = boxplot of the MeasureVar list
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
  # 1 Falling back into defaults ----------------------------------------------------------  
  source("functions/R_rainclouds.R")
  source("functions/summarySE.R")
  if(missing(Quant)){
    Quant <- "/ [tCr]"
  }
  if(missing(MeasureVar)){
    MeasureVar <- "tNAA"
  }
  if(missing(GroupVars)){
    if (dataFrame$tNAA[1] > 0) {dataFrame$Group = "all datasets"}
    if (dataFrame$tNAA[1] > 0) {dataFrame$NumericGroupVar = 1}
    GroupVars <- c("Group")
  }
  if (missing(lowerLimits)){
    lowerLimits <- NULL
  }
  if (missing(upperLimits)){
    upperLimits <- NULL
  }
  if(missing(title)){
    if(is.list(MeasureVar)){
      title <- paste ("[metabolite]", Quant)  
    }
    else{
      title <- paste (MeasureVar, Quant) 
    }
  }
  if(missing(colNum)){
    colNum = 2
  }
  if(missing(legendTitle)){
    legendTitle <- ""
  }
  # 2 Preparing data to plot ------------------------------------  
  if(is.list(MeasureVar)){ #Preparing data as a list was passed
    MeasureVarL <- NULL
    Group <- NULL
    MetaboliteNumL <- NULL
    MetabName <- NULL
    sumcatdat <- NULL
    MetaboliteNum <- length(MeasureVar);
    for (metab in MeasureVar){
      MeasureVarL <- cbind(MeasureVarL, dataFrame[names(dataFrame) == metab][[1]])
      Group <- rbind(Group,dataFrame$Group)
      MetaboliteNumL <- rbind(MetaboliteNumL,rep(MetaboliteNum,nrow(dataFrame)))
      MetabName <- rbind(MetabName,rep(metab,nrow(dataFrame)))
      sumcatdatTemp <- summarySE(dataFrame, measurevar = metab, groupvars=GroupVars)
      sumcatdatTemp$MetaboliteNum = rep(MetaboliteNum,nrow(sumcatdatTemp))
      sumcatdatTemp$MetabName = rep(metab,nrow(sumcatdatTemp))
      sumcatdatTemp$ypos = 1 - 0.1 * (0 : (nrow(sumcatdatTemp)-1))
      if (MetaboliteNum == length(MeasureVar)){
        sumcatdat <- rbind(sumcatdat, sumcatdatTemp)
      }
      else{ 
        sumcatdat <- rbind(sumcatdat, sumcatdatTemp)
      }
      MetaboliteNum <- MetaboliteNum - 1
    }
    MeasureVarIni <- MeasureVar
    MeasureVar = c(MeasureVarL)
    Group = array(t(Group))
    MetaboliteNum = array(t(MetaboliteNumL))
    MetabName = array(t(MetabName))
    dataFrame = data.frame(MeasureVar,Group,MetaboliteNum,MetabName)
  }
  else{ #single MeasureVar passed
    MeasureVarIni <- MeasureVar
    sumcatdat <- summarySE(dataFrame, measurevar = MeasureVar, groupvars=GroupVars)
  }
  
  sumcatdat$NumericGroupVar <- rep(0.03,length(sumcatdat$Group))
  
  dataFrame$NumericGroupVar <- rep(0,length(dataFrame$Group))
  
  # 3 Generating facet limits ------------------------------------     
  facetlim = dataFrame %>% 
    group_by(MetabName) %>% 
    summarise(min = min(MeasureVar)-((max(MeasureVar)-min(MeasureVar))*0.05), max = max(MeasureVar)+((max(MeasureVar)-min(MeasureVar))*0.05)) %>%
    gather(range, MeasureVar, -MetabName)
  facetlimN = dataFrame %>% 
    group_by(MetaboliteNum) %>% 
    summarise(min = min(MeasureVar), max = max(MeasureVar)) %>%
    gather(range, MeasureVar1, -MetaboliteNum) 
  facetlim$MetaboliteNum <- facetlimN$MetaboliteNum
  
  if (!is.null(upperLimits)){ #import facet limits if given
    upperLimits <- upperLimits + (upperLimits-lowerLimits)*0.05
    lowerLimits <- lowerLimits - (upperLimits-lowerLimits)*0.05
    limits <- c(rev(lowerLimits),rev(upperLimits))
    facetlim$MeasureVar <- limits
  }
  facetlim$NumericGroupVar <- rep(0,length(facetlim$MetaboliteNum))
  dataFrame$NumericGroupVarShift1 <- dataFrame$NumericGroupVar + 0.012
  dataFrame$NumericGroupVarShift2 <- dataFrame$NumericGroupVar - 0.012
  # 4 Creating final plot ------------------------------------  
  if(is.list(MeasureVarIni)){ #Facet plot as a list was passed
    p <- ggplot(data = dataFrame, aes_string(x = 'NumericGroupVar', y = 'MeasureVar')) +
      guides(colour=guide_legend(legendTitle))+guides(fill=guide_legend(legendTitle))+
      facet_wrap(~reorder(MetabName, -MetaboliteNum), scales = "free_y",ncol = colNum)+
      geom_blank(data=facetlim, aes_string(x = 'NumericGroupVar', y = 'MeasureVar'))+
      geom_flat_violin(data = dataFrame,aes_string(fill = GroupVars[1]), trim = FALSE, colour = NA, scale = 'width',position = position_dodge(0.35))+
      geom_boxplot(aes_string(x = 'NumericGroupVarShift2', y = 'MeasureVar', fill = GroupVars[1]), alpha = 0.5,position = position_dodge(.35),width = .03,size=.3, colour = 'black',outlier.shape = NA)+
      geom_point(aes_string(x = 'NumericGroupVarShift2', y = 'MeasureVar', colour = GroupVars[1]),position = position_jitterdodge(jitter.width = 0.005, dodge.width = .35),alpha = 0.75, size = 0.0001, shape = 20)+
      #geom_point(data = sumcatdat, aes_string(x = 'NumericGroupVar', y = 'mean', group = GroupVars[1]),position = position_dodge(width = 0.3),size = 1.5, shape = 18, colour = 'black') +
      geom_linerange(data = sumcatdat, aes_string(y = 'mean',ymin = 'meanMsd', ymax = 'meanPsd', group = GroupVars[1]),position = position_dodge(width = 0.35), size = .25, colour = 'black')+
      geom_linerange(data = sumcatdat, aes_string(y = 'mean',ymin = 'meanMsdS', ymax = 'meanPsdS', group = GroupVars[1]),position = position_dodge(width = 0.35), size = .25, colour = 'white')+
      theme_cowplot()+
      scale_colour_brewer(palette = "Dark2")+
      scale_fill_brewer(palette = "Dark2")+
      ggtitle(title)+ylab(paste('[metabolite]', Quant))+xlab('')+  
      theme(plot.title = element_text(hjust = 0.5),aspect.ratio = 1,strip.background = element_blank(),axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())
  }  
  else{ #single plot
    p <- ggplot(data = dataFrame, aes_string(x = 'NumericGroupVar', y = 'MeasureVar')) +
      guides(colour=guide_legend(legendTitle))+guides(fill=guide_legend(legendTitle))+
      geom_blank(data=facetlim, aes_string(x = 'NumericGroupVar', y = 'MeasureVar'))+
      #geom_point(aes_string(x = 'NumericGroupVarShift2', y = 'MeasureVar', colour = GroupVars[1]),position = position_jitterdodge(jitter.width = .01, dodge.width = .3), size = 0.5, shape = 20)+
      geom_flat_violin(data = dataFrame,aes_string(fill = GroupVars[1]), trim = FALSE, colour = NA, scale = 'width',position = position_dodge(0.3))+
      geom_boxplot(aes_string(x = 'NumericGroupVarShift1', y = 'MeasureVar', fill = GroupVars[1]), alpha = 0.01,position = position_dodge(.3),width = .03,size=.3, colour = 'black')+
      #geom_point(data = sumcatdat, aes_string(x = 'NumericGroupVar', y = 'mean', group = GroupVars[1]),position = position_dodge(width = 0.3),size = 1.5, shape = 18, colour = 'black') +
      geom_errorbar(data = sumcatdat, aes_string(y = 'mean',ymin = 'meanMsd', ymax = 'meanPsd', group = GroupVars[1]),position = position_dodge(width = 0.3), width = .02, colour = 'black')+
      theme_cowplot()+
      scale_colour_brewer(palette = "Dark2")+
      scale_fill_brewer(palette = "Dark2")+
      ggtitle(paste(MeasureVar, Quant))+ylab(paste(MeasureVar, Quant))+xlab('')+  
      theme(plot.title = element_text(hjust = 0.5),aspect.ratio = 1,axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())
  }
  out <- list(p,sumcatdat)
}# end of function