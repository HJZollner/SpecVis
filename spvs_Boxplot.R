spvs_Boxplot<- function(dataFrame,Quant,MeasureVar,GroupVars,title,colNum,legendTitle){
  # spvs_Boxplot <- function(dataFrame,Quant,MeasureVar,GroupVars,title,colNum,legendTitle)
  # This function creates boxplots with individual data pointsfrom the imported dataframe. You can concatenate different 
  # frames with spvs_ConcatenateDataframe.R (e.g. from different tools) beforehand. The data
  # will autaomatically be facceted in case a list of measurments is passed.
  #
  #   USAGE:
  #     p <- spvs_Boxplot(dataFrame,Quant,MeasureVar,GroupVars,title,colNum,legendTitle)
  #
  #   INPUTS:
  #     dataFrame = data frame with metabolite estiamtes
  #     Quant = name of the quantification for labelling purposes. default = '/ [tCr]'.
  #     MeasureVar = list of measurement variables (e.g. c('tNAA','Glx')). default = 'tNAA'.
  #     GroupVars = name of the column with the group variables. spvs_ConcatenateDataframe uses 'Group' by default. default = 'all datasets'
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
  source("R_rainclouds.R")
  source("summarySE.R")
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
    MetaboliteNum <- length(MeasureVar);
    for (metab in MeasureVar){ #Loop over MeasureVar list and create summary 
      MeasureVarL <- cbind(MeasureVarL, dataFrame[names(dataFrame) == metab][[1]])
      Group <- rbind(Group,dataFrame$Group)
      MetaboliteNumL <- rbind(MetaboliteNumL,rep(MetaboliteNum,nrow(dataFrame)))
      MetabName <- rbind(MetabName,rep(metab,nrow(dataFrame)))
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
  }
  

  dataFrame$NumericGroupVar <- rep(0,length(dataFrame$Group))
  # 3 Creating final plot ------------------------------------  
  if(is.list(MeasureVarIni)){ #Facet plot as a list was passed
    p <- ggplot(data = dataFrame, aes_string(x = 'NumericGroupVar', y = 'MeasureVar', fill = GroupVars[1])) +
      guides(colour=guide_legend(legendTitle))+guides(fill=guide_legend(legendTitle))+
      facet_wrap(~reorder(MetabName, -MetaboliteNum), scales = "free_y",ncol = colNum)+
      geom_point(aes_string(x = 'NumericGroupVar', y = 'MeasureVar', colour = GroupVars[1]),position = position_jitterdodge(jitter.width = .005, dodge.width = .025), size = 0.75, shape = 20)+
      geom_boxplot(aes_string(x = 'NumericGroupVar', y = 'MeasureVar'),outlier.shape = NA, alpha = .5,position = position_dodge( .025), width = .0125,size=.2, colour = 'black')+
      theme_cowplot()+
      scale_colour_brewer(palette = "Dark2")+
      scale_fill_brewer(palette = "Dark2")+
      ggtitle(title)+ylab(paste('[metabolite]', Quant))+xlab('')+  
      theme(plot.title = element_text(hjust = 0.5),aspect.ratio = 1,strip.background = element_blank(),axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())
  }  
  else{ #single plot
    p <- ggplot(data = dataFrame, aes_string(x = 'NumericGroupVar', y = 'MeasureVar', fill = GroupVars[1])) +
      guides(colour=guide_legend(legendTitle))+guides(fill=guide_legend(legendTitle))+
      geom_point(aes_string(x = 'NumericGroupVar', y = 'MeasureVar', colour = GroupVars[1]),position = position_jitterdodge(jitter.width = .005, dodge.width = .05), size = 0.75, shape = 20)+
      geom_boxplot(aes_string(x = 'NumericGroupVar', y = 'MeasureVar'),outlier.shape = NA, alpha = .5, width = .05,size=.2, colour = 'black')+
      theme_cowplot()+
      scale_colour_brewer(palette = "Dark2")+
      scale_fill_brewer(palette = "Dark2")+
      ggtitle(paste(MeasureVar, Quant))+ylab(paste(MeasureVar, Quant))+xlab('')+  
      theme(plot.title = element_text(hjust = 0.5),aspect.ratio = 1,axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())
    }
}# end of function