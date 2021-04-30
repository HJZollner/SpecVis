spvs_Correlation_Facet <- function(dataFrame,Quant,MeasureVar,GroupVarNames1,GroupVarNames2,HueVar,lowerLimits,upperLimits,multiComp,colNum,title,legendTitle){
  # spvs_Correlation_Facet <- function(dataFrame,Quant,MeasureVar,GroupVarNames1,GroupVarNames2,HueVar,lowerLimits,upperLimits,multiComp,colNum,title,legendTitle)
  # Creates a correaltion plot for the list of MeasureVars. Different colors for groups and correaltions, as well as hue
  # for differentiation can be added. 
  #
  #   USAGE:
  #     p <- spvs_Correlation_Facet(dataFrame,Quant,MeasureVar,GroupVarNames1,GroupVarNames2,HueVar,lowerLimits,upperLimits,multiComp,colNum,title,legendTitle)
  #
  #   INPUTS:
  #     dataFrame = list of data frames with metabolite estiamtes (e.g. c(dfOspreyGE,dfOspreySiemens,dfLCModelGE,dfLCModelSiemens))
  #     Quant = name of the quantification for labelling purposes. default = '/ [tCr]'.
  #     MeasureVar = list of measurement variables (e.g. c('tNAA','Glx')). default = 'tNAA'.
  #     GroupVarNames1 = list of x and y axis names corresponding to each data frame in the list (e.g. c('Osprey','Osprey','LCModel','LCModel')).
  #     GroupVarNames2 = list of groups of each data frame, which will create teh different facets (e.g. different patient groups or vendors c('GE','Siemens','GE','Siemens'))
  #     HueVar = list of column names for the HueVar (e.g. different sites c('group name', 'group name','group name', 'group name')).
  #     lowerLimits/upperLimits = list of facet upper und lower axis Limits. You need to add one value per MeasureVar and 5 % margin will be added.
  #     multiComp = number of comparisons used for the bonferoni correction
  #     colNum = number of columns for the facet. default = 2.     
  #     title = title of the figure. default = MeasureVar / Quant or '[metabolite] / Quant' for lists.
  #     legendTitle = title of the legend. default = ''.
  #
  #
  #   OUTPUTS:
  #     p     = Correlation plot of the MeasureVar list with facets by group and invidual correlations per Hue
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
  source("functions/spvs_CombineCorrelationDataFrame.R")
  source("functions/spvs_shadeColormap.R")
  if(missing(Quant)){
    Quant <- "/ [tCr]"
  }
  if(missing(MeasureVar)){
    MeasureVar <- "tNAA"
  }
  if(missing(GroupVarNames1)){
    if(length(dataFrame)>1){
      GroupVarNames1 <- c('Osprey','LCModel')
    }
    else{
      GroupVarNames1 <- c('Osprey')  
    }
  }
  if(missing(GroupVarNames2)){
    if(length(dataFrame)>1){
      GroupVarNames2 <- c('','')
    }
    else{
      GroupVarNames2 <- c('')  
    }
  }
  if(missing(HueVar)){
    HueVar <- NULL
  }
  if (missing(lowerLimits)){
    lowerLimits <- NULL
  }
  if (missing(upperLimits)){
    upperLimits <- NULL
  }
  if (missing(multiComp)){
    multiComp <- 1
  }  
  if (missing(colNum)){
    colNum <- 2
  }
  if(missing(title)){
    if(length(dataFrame)>1){
      title <- paste ("Correlation [metabolite]", Quant)  
    }
    else{
      title <- paste ("Correlation", MeasureVar[1], Quant, "vs", MeasureVar[2], Quant) 
    }
  }
  if(missing(legendTitle)){
    legendTitle <- ""
  }
  dfCorr <- spvs_CombineCorrelationDataFrame(dataFrame,MeasureVar,GroupVarNames1,GroupVarNames2,HueVar)
  corrNames <- unique(GroupVarNames1)
  
  # 2 Generating facet limits ------------------------------------   
  facetlim = dfCorr %>% 
    group_by(MetabName) %>% 
    summarise(min = min(MeasureVar1, MeasureVar2)-((max(MeasureVar1, MeasureVar2)-min(MeasureVar1, MeasureVar2))*0.05), max = max(MeasureVar1, MeasureVar2)+((max(MeasureVar1, MeasureVar2)-min(MeasureVar1, MeasureVar2))*0.05)) %>%
    gather(range, MeasureVar1, -MetabName) %>%
    mutate(MeasureVar2 = MeasureVar1, range = NULL)
  facetlimN = dfCorr %>% 
    group_by(MetaboliteNum) %>% 
    summarise(min = min(MeasureVar1, MeasureVar2), max = max(MeasureVar1, MeasureVar2)) %>%
    gather(range, MeasureVar1, -MetaboliteNum) %>%
    mutate(MeasureVar2 = MeasureVar1, range = NULL)
  facetlim$MetaboliteNum <- facetlimN$MetaboliteNum
  
  if (!is.null(upperLimits)){
    upperLimits <- upperLimits + (upperLimits-lowerLimits)*0.05
    lowerLimits <- lowerLimits - (upperLimits-lowerLimits)*0.05
    limits <- c(rev(lowerLimits),rev(upperLimits))
    facetlim$MeasureVar1 <- limits
    facetlim$MeasureVar2 <- limits
  }
  formula <- y ~ x 
  dfCorrAll <- dfCorr
  facetlimAll <- facetlim
  p <- vector("list", length(MeasureVar))
  MeasVarNum <- 1;
  shade <- NULL  
  for (i in 1:length(unique(dfCorr$Group))){   
    shade<-  cbind(shade,length(unique(dataFrame[[i]]$`group`)))}
  shadeColormap <- spvs_shadeColormap('Dark2',length(unique(dfCorr$Group)),shade,0)
  # 3 Creating final plot ------------------------------------ 
  for (MeasVar in MeasureVar){ #Loop over MeasureVar list
    if (!is.null(HueVar)){  #No hue is applied
  dfCorr <- subset(dfCorrAll, MetabName==MeasVar,select=MeasureVar1:HueVar)
  facetlim <- subset(facetlimAll, MetabName==MeasVar,select=MetabName:MetaboliteNum)}
    else{
      dfCorr <- subset(dfCorrAll, MetabName==MeasVar,select=MeasureVar1:MetaboliteNum)
      facetlim <- subset(facetlimAll, MetabName==MeasVar,select=MetabName:MetaboliteNum)  
    }
  
    pTemp<-  ggplot(dfCorr, aes_string(x = "MeasureVar1", y = "MeasureVar2")) +
      geom_blank(data=facetlim)+
      guides(colour=guide_legend(legendTitle))+guides(fill=guide_legend(legendTitle))+
      facet_wrap(~Group, scales = "free")+
      geom_point(aes_string(color = "Group"),size = 2, shape = 20)+
      geom_abline(slope = 1,intercept = 0,linetype="dashed",alpha = 0.5, col="black")+
      stat_fit_glance(method = 'lm', method.args = list(formula = formula),
                      aes(color = Group,label=ifelse(..p.value..< (0.001/multiComp),sprintf('R^2~"="~%.2f~"***"',
                                                                  stat(r.squared), stat(p.value)) , 
                                       ifelse(..p.value..>=(0.001/multiComp) & ..p.value..<(0.01/multiComp), sprintf('R^2~"="~%.2f~"**"',
                                                                                             stat(r.squared), stat(p.value)) ,
                                              ifelse(..p.value..>=(0.01/multiComp) & ..p.value..<(0.05/multiComp),sprintf('R^2~"="~%.2f~"*"',
                                                                                                  stat(r.squared), stat(p.value)) ,
                                                     sprintf('R^2~"="~%.2f~~p~"="~%.2g',stat(r.squared), stat(p.value)))))),
                      label.x = 0.95,
                      label.y = 0.05, size = 3,parse = TRUE)+
      theme_cowplot()+
      theme(aspect.ratio = 1,strip.background = element_blank(),plot.title = element_text(hjust = 0.5),legend.position = 'top')+
      scale_colour_brewer(palette = "Dark2")+
      scale_fill_brewer(palette = "Dark2")+
      ggtitle(MeasVar)+ylab(corrNames[2])+xlab(corrNames[1])+
      scale_y_continuous(breaks = scales::extended_breaks(n = 5))+
      scale_x_continuous(breaks = scales::extended_breaks(n = 5))
    if (!is.null(HueVar)){  #No hue is applied
      # geoms below will use another color scale
      pTemp <- pTemp +
      new_scale_color() +
      geom_point(data = dfCorr,aes_string(color = "HueVar"), size = 1, shape = 20) +
      geom_smooth(aes_string(color = "HueVar"),method = "lm", formula = formula,se = F,size=0.35, alpha = 0.5)+
      # Color scale applied to geoms added after new_scale_color()
      scale_color_manual(values = shadeColormap)}
    
      pTemp <- pTemp +
      new_scale_color() +
      geom_smooth(aes_string(color = "Group"),method = "lm", formula = formula,size=0.6)+
      scale_colour_brewer(palette = "Dark2") +
      theme(legend.position = "none")
      p[[MeasVarNum]] <- pTemp
      MeasVarNum <- MeasVarNum + 1
  }
  final_p <- grid.arrange(grobs = p, ncol=colNum,top = title)
  return(final_p)
}# end of function