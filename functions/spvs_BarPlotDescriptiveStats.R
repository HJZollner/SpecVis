spvs_BarPlotDescriptiveStats <- function(dataFrame,MeasureVar,MetabNames,YName,GroupVars,lowerLimits,upperLimits,title,colNum,CVlabel, legendTitle){
  # spvs_BarPlotDescriptiveStats <- function(dataFrame,Quant,MeasureVar,GroupVars,lowerLimits,upperLimits,title,colNum,legendTitle)
  # This function creates raincloud plots the imported dataframe. You can concatenate different 
  # frames with spvs_ConcatenateDataframe.R (e.g. from different tools) beforehand. The data
  # will autaomatically be facceted in case a list of measurments is passed.
  #
  #   USAGE:
  #   p <-  spvs_BarPlotDescriptiveStats(dataFrame,Quant,MeasureVar,GroupVars,lowerLimits,upperLimits,title,colNum,legendTitle)
  #
  #   INPUTS:
  #     dataFrame = data frame with metabolite estiamtes
  #     YName = name of the yaxus unit (default = 'CV')
  #     MeasureVar = list of measurement variables (e.g. c('tNAA','Glx')). default = 'tNAA'.
  #     GroupVars = name of the column with the group variables. spvs_ConcatenateDataframe uses 'Group' by default. default = 'all datasets'
  #     lowerLimits/upperLimits = list of facet upper und lower axis Limits. You need to add one value per MeasureVar and 5 % margin will be added.
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
  if(missing(YName)){
    YName <- "CV (%)"
  }
  if(missing(GroupVars)){
    GroupVars <- c("Group")
  }
  if (missing(lowerLimits)){
    lowerLimits <- NULL
  }
  if (missing(upperLimits)){
    upperLimits <- NULL
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
  dataFrame$NumericGroupVar <- rep(0,length(dataFrame$Group))
  dataFrame$NumericGroupVar2 <- rep(-.15,length(dataFrame$Group))
  
  #Adding labels for CV and mean/SD
  if(CVlabel == 1){
    numformat <- function(val) { sub("^(-?)0.", "\\1.", sprintf("%.2f", val)) }
    dataFrame$label <- numformat(dataFrame$CV)
  }
  
  # 3 Generating facet limits ------------------------------------  
  dataFrame$MetaboliteNum <- as.numeric(factor(dataFrame$Metab,levels = rev(unique(dataFrame$Metab))))
                                        
  facetlim = dataFrame %>% 
    group_by(Metab) %>% 
    summarise(min = min(CV)-((max(CV)-min(CV))*0.05), max = max(CV)+((max(CV)-min(CV))*0.05)) %>%
    gather(range, CV, -Metab)
  #facetlimN = dataFrame %>% 
   # group_by(MetaboliteNum) %>% 
    #summarise(min = min(CV), max = max(CV)) %>%
    #gather(range, MeasureVar1, -MetaboliteNum) 
  #facetlim$MetaboliteNum <- facetlimN$MetaboliteNum
  
  
  limits <- c(rev(lowerLimits),rev(upperLimits))
  facetlim$CV <- limits
  
  facetlim$NumericGroupVar <- rep(0,length(facetlim$Metab))
  upLim = facetlim
  upLim = upLim %>%
    slice(-seq(0.5 * n()))
  upLim <- upLim[nrow(upLim):1,]
  #upLim <- upLim %>% slice(rep(1:n(), each = length(unique(Group))))
  #sumcatdat$ypos = (sumcatdat$ypos * upLim$MeasureVar)
  #sumcatdat$ypos = (sumcatdat$ypos * sumcatdat$MAX)
  
  Metab <- dataFrame$Metab
  MetaboliteNum <- dataFrame$MetaboliteNum
  
  # 4 Creating final plot ------------------------------------  
  p <- ggplot(data=dataFrame)+ 
    guides(colour=guide_legend(''))+guides(fill=guide_legend(''))+
    facet_wrap(~reorder(Metab, -MetaboliteNum), scales = "free_y", ncol = colNum)+
    geom_blank(data=facetlim, aes_string(x = 'NumericGroupVar', y = 'CV'))+
    geom_bar(data=dataFrame,aes_string(x='Group', y='CV', fill = 'Group'), stat="identity")+
    geom_text(data=dataFrame,aes_string(x='Group', y='CV'+0.01,label = label, colour = 'Group'),angle=90,hjust = 0) +
    theme_cowplot()+
    scale_colour_brewer(palette = "Dark2")+
    scale_fill_brewer(palette = "Dark2")+
    ggtitle(title)+ylab(paste('[metabolite]', Quant))+xlab('')+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
    theme(plot.title = element_text(hjust = 0.5),aspect.ratio = 1,strip.background = element_blank(),axis.title.x=element_blank())

}# end of function