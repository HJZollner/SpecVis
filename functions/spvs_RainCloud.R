spvs_RainCloud <- function(dataFrame,Quant,MeasureVar,GroupVars,lowerLimits,upperLimits,title,colNum,CVlabel, legendTitle){
  # spvs_RainCloud <- function(dataFrame,Quant,MeasureVar,GroupVars,lowerLimits,upperLimits,title,colNum,legendTitle)
  # This function creates raincloud plots the imported dataframe. You can concatenate different 
  # frames with spvs_ConcatenateDataframe.R (e.g. from different tools) beforehand. The data
  # will autaomatically be facceted in case a list of measurments is passed.
  #
  #   USAGE:
  #   p <-  spvs_RainCloud(dataFrame,Quant,MeasureVar,GroupVars,lowerLimits,upperLimits,title,colNum,legendTitle)
  #
  #   INPUTS:
  #     dataFrame = data frame with metabolite estiamtes
  #     Quant = name of the quantification for labelling purposes. default = '/ [tCr]'.
  #     MeasureVar = list of measurement variables (e.g. c('tNAA','Glx')). default = 'tNAA'.
  #     GroupVars = name of the column with the group variables. spvs_ConcatenateDataframe uses 'Group' by default. default = 'all datasets'
  #     lowerLimits/upperLimits = list of facet upper und lower axis Limits. You need to add one value per MeasureVar and 5 % margin will be added.
  #     title = title of the figure. default = MeasureVar / Quant or '[metabolite] / Quant' for lists.
  #     colNum = number of columns for the facet. default = 2.
  #     CVlabel = plot CV (CVlabel = 1) or mean/SD (CVlabel = 2) as text. default = 1. 
  #     legendTitle = title of the legend. default = ''.
  #
  #
  #   OUTPUTS:
  #     p     = raincloud plot of the MeasureVar list
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
  source("functions/summarySE.R")
  source("functions/R_rainclouds.R")
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
  if(missing(CVlabel)){
    CVlabel = 1
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
  
  sumcatdat$NumericGroupVar <- rep(0.15,length(sumcatdat$Group))
  dataFrame$NumericGroupVar <- rep(0,length(sumcatdat$Group))
  
  #Adding labels for CV and mean/SD
  if(CVlabel == 1){
    sumcatdat$label <- sprintf(
      "CV = %.1f%%\n", sumcatdat$CV * 100
    )
  }
  else{
    sumcatdat$label <- sprintf(
      "mean/SD = %.1f/%.2f ", sumcatdat$mean, sumcatdat$sd
    )
  }

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
  upLim = facetlim
  upLim = upLim %>%
    slice(-seq(0.5 * n()))
  upLim <- upLim[nrow(upLim):1,]
  upLim <- upLim %>% slice(rep(1:n(), each = length(unique(Group))))
  sumcatdat$ypos = sumcatdat$ypos * upLim$MeasureVar
  
  # 4 Creating final plot ------------------------------------  
  if(is.list(dataFrame)){ #Facet plot as a list was passed
    p <- ggplot(data = dataFrame, aes_string(x = 'NumericGroupVar', y = 'MeasureVar')) +
      guides(colour=guide_legend(legendTitle))+guides(fill=guide_legend(legendTitle))+
      facet_wrap(~reorder(MetabName, -MetaboliteNum), scales = "free_y", ncol = colNum)+
      geom_blank(data=facetlim, aes_string(x = 'NumericGroupVar', y = 'MeasureVar'))+
      geom_flat_violin(data = dataFrame,aes_string(fill = GroupVars[1]),position = position_nudge(x = .1), adjust = 2, trim = FALSE, alpha = .3, colour = NA, scale = 'count')+
      geom_point(aes_string(x = 'NumericGroupVar', y = 'MeasureVar', colour = GroupVars[1]),position = position_jitterdodge(jitter.width = .05, dodge.width = .1), size = 0.5, shape = 20)+
      geom_boxplot(aes_string(x = 'NumericGroupVar', y = 'MeasureVar',fill = GroupVars[1]),outlier.shape = NA, alpha = .5, width = .1,size=.2, colour = 'black')+
      geom_point(data = sumcatdat, aes_string(x = 'NumericGroupVar', y = 'mean', group = GroupVars[1], colour = GroupVars[1]),position = position_dodge(width = 0.1),size = 1.5, shape = 18) +
      geom_errorbar(data = sumcatdat, aes_string(y = 'mean',ymin = 'meanMsd', ymax = 'meanPsd', group = GroupVars[1], colour = GroupVars[1]),position = position_dodge(width = 0.1), width = .02)+
      geom_text(size= 4,data = sumcatdat,mapping = aes_string(x = 0.5, y = 'ypos', label = 'label',colour = GroupVars[1]),hjust=1) +
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
    geom_flat_violin(aes_string(fill = GroupVars[1]),position = position_nudge(x = .1), adjust = 2, trim = FALSE, alpha = .3, colour = NA, scale = 'count')+
    geom_point(aes_string(x = 'NumericGroupVar', y = 'MeasureVar', colour = GroupVars[1]),position = position_jitterdodge(jitter.width = .05, dodge.width = .1), size = 0.5, shape = 20)+
    geom_boxplot(aes_string(x = 'NumericGroupVar', y = 'MeasureVar',fill = GroupVars[1]),outlier.shape = NA, alpha = .5, width = .1,size=.2, colour = 'black')+
    geom_point(data = sumcatdat, aes_string(x = 'NumericGroupVar', y = 'mean', group = GroupVars[1], colour = GroupVars[1]),position = position_dodge(width = 0.1),size = 1.5, shape = 18) +
    geom_errorbar(data = sumcatdat, aes_string(y = 'mean', ymin = 'meanMsd', ymax = 'meanPsd', group = GroupVars[1], colour = GroupVars[1]),position = position_dodge(width = 0.1), width = .02)+
    geom_text(size= 4,data = sumcatdat,mapping = aes_string(x = 0.5, y = 'ypos', label = 'label',colour = GroupVars[1]),hjust=1) +
    theme_cowplot()+
    scale_colour_brewer(palette = "Dark2")+
    scale_fill_brewer(palette = "Dark2")+
    ggtitle(paste(MeasureVar, Quant))+ylab(paste(MeasureVar, Quant))+xlab('')+  
    theme(plot.title = element_text(hjust = 0.5),aspect.ratio = 1,axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())}
}# end of function