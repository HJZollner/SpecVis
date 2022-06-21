spvs_Correlation <- function(dataFrame,Quant,MeasureVar,GroupVarNames1,GroupVarNames2,HueVar,lowerLimits,upperLimits,multiComp,colNum,title,legendTitle){
  # spvs_Correlation <- function(dataFrame,Quant,MeasureVar,GroupVarNames1,GroupVarNames2,HueVar,lowerLimits,upperLimits,multiComp,colNum,title,legendTitle)
  # Creates a correaltion plot for the list of MeasureVars. Different colors for groups and correaltions, as well as hue
  # for differentiation can be added. 
  #
  #   USAGE:
  #     p <- spvs_Correlation(dataFrame,Quant,MeasureVar,GroupVarNames1,GroupVarNames2,HueVar,lowerLimits,upperLimits,multiComp,colNum,title,legendTitle)
  #
  #   INPUTS:
  #     dataFrame = list of data frames with metabolite estiamtes (e.g. c(dfOspreyGE,dfOspreySiemens,dfLCModelGE,dfLCModelSiemens))
  #     Quant = name of the quantification for labelling purposes. default = '/ [tCr]'.
  #     MeasureVar = list of measurement variables (e.g. c('tNAA','Glx')). default = 'tNAA'.
  #     GroupVarNames1 = list of x and y axis names corresponding to each data frame in the list (e.g. c('Osprey','Osprey','LCModel','LCModel')).
  #     GroupVarNames2 = list of groups of each data frame (e.g. different patient groups or vendors c('GE','Siemens','GE','Siemens'))
  #     HueVar = list of column names for the HueVar (e.g. different sites c('group name', 'group name','group name', 'group name')).
  #     lowerLimits/upperLimits = list of facet upper und lower axis Limits. You need to add one value per MeasureVar and 5 % margin will be added.
  #     multiComp = number of comparisons used for the bonferoni correction
  #     colNum = number of columns for the facet. default = 2.     
  #     title = title of the figure. default = MeasureVar / Quant or '[metabolite] / Quant' for lists.
  #     legendTitle = title of the legend. default = ''.
  #
  #
  #   OUTPUTS:
  #     p     = Correlation plot of the MeasureVar list
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
  source("functions/spvs_nth_element.R")
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
    if(length(GroupVarNames1) == length(GroupVarNames2))
    {corrNames <- unique(GroupVarNames1)} 
    else{
      corrNames <- unique(GroupVarNames1)
      corrNames[[2]] <- ''
    }
    
  # 2 Generating facet limits ------------------------------------  
if(length(GroupVarNames1) == length(GroupVarNames2)){ #Preparing data as a list of data frames is passed
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
  facetlim$MetaboliteNum <- facetlimN$MetaboliteNum}
  else{ #Preparing data if a single data frame is passed
    MetabName <- NULL
  facetlim = dfCorr %>% 
    group_by(MetaboliteNum) %>% 
    summarise(min = min(MeasureVar1)-((max(MeasureVar1)-min(MeasureVar1))*0.05), max = max(MeasureVar1)+((max(MeasureVar1)-min(MeasureVar1))*0.05)) %>%
    gather(range, MeasureVar1, -MetaboliteNum)
  facetlim2 = dfCorr %>% 
    group_by(MetaboliteNum) %>% 
    summarise(min = min(MeasureVar2)-((max(MeasureVar2)-min(MeasureVar2))*0.05), max = max(MeasureVar2)+((max(MeasureVar2)-min(MeasureVar2))*0.05)) %>%
    gather(range, MeasureVar2, -MetaboliteNum)
  facetlim$MeasureVar2 <- facetlim2$MeasureVar2
  for (n in  0:((length(MeasureVar)/2)-1)){
    MetabName <- rbind(MetabName,paste(MeasureVar[[(2*n+1)]],MeasureVar[[(2*n+2)]],sep = ' vs '))
  }
  MetabName <- c(rev(MetabName),rev(MetabName))
  facetlim$MetabName <- MetabName}
  
  if (!is.null(upperLimits)){
  #  upperLimits <- upperLimits + ((upperLimits-lowerLimits)*0.05)
  #  lowerLimits <- lowerLimits - ((upperLimits-lowerLimits)*0.05)
    limits <- c(rev(lowerLimits),rev(upperLimits))
    if(length(GroupVarNames1) == length(GroupVarNames2)){ 
    facetlim$MeasureVar1 <- limits
    facetlim$MeasureVar2 <- limits}
    else{
      facetlim$MeasureVar1 <- spvs_nth_element(limits,2,2)
      facetlim$MeasureVar2 <- spvs_nth_element(limits,1,2)  
    }
  }
  shade <- NULL  
  for (i in 1:length(unique(dfCorr$Group))){   
   shade<-  cbind(shade,length(unique(dataFrame[[i]]$`group`)))}
  shadeColormap <- spvs_shadeColormap('Dark2',length(unique(dfCorr$Group)),shade,0)
  formula <- y ~ x 
  
  # 3 Creating final plot ------------------------------------ 
  p <-  ggplot(dfCorr, aes_string(x = "MeasureVar1", y = "MeasureVar2")) +
    geom_blank(data=facetlim)+
      guides(colour=guide_legend(legendTitle))+guides(fill=guide_legend(legendTitle))+
      facet_wrap(~reorder(MetabName, -MetaboliteNum), scales = "free", ncol = colNum)+
      geom_point(aes_string(color = "Group"),size = 1.5)
  
    if(facetlim$MeasureVar1[[1]] == facetlim$MeasureVar2[[1]]){ #Add line to devide plot
      p <- p + geom_abline(slope = 1,intercept = 0,linetype="dashed",alpha = 0.5, col="black")}
  
  p <- p + stat_fit_glance(method = 'cor.test', method.args = list(formula = ~ x + y),
                           aes(label=ifelse(..p.value..< (0.001/multiComp),sprintf('r~"="~%.2f~"***"',
                                                                                   stat(estimate)) , 
                                            ifelse(..p.value..>=(0.001/multiComp) & ..p.value..<(0.01/multiComp), sprintf('r~"="~%.2f~"**"',
                                                                                                                          stat(estimate)) ,
                                                   ifelse(..p.value..>=(0.01/multiComp) & ..p.value..<(0.05/multiComp),sprintf('r~"="~%.2f~"*"',
                                                                                                                               stat(estimate)) ,
                                                          sprintf('r~"="~%.2f~~p~"="~%.2g',stat(estimate), stat(p.value)))))),
                           label.x = 0.5,
                           label.y = 'bottom', size = 4,parse = TRUE)+
    
  #  p <- p + stat_fit_glance(method = 'lm', method.args = list(formula = formula),
  #                  aes(label=ifelse(..p.value..< (0.001/multiComp),sprintf('R^2~"="~%.2f~"***"',
  #                                                              stat(r.squared), stat(p.value)) , 
  #                                   ifelse(..p.value..>=(0.001/multiComp) & ..p.value..<(0.01/multiComp), sprintf('R^2~"="~%.2f~"**"',
  #                                                                                         stat(r.squared), stat(p.value)) ,
  #                                          ifelse(..p.value..>=(0.01/multiComp) & ..p.value..<(0.05/multiComp),sprintf('R^2~"="~%.2f~"*"',
  #                                                                                              stat(r.squared), stat(p.value)) ,
  #                                                 sprintf('R^2~"="~%.2f~~p~"="~%.2g',stat(r.squared), stat(p.value)))))),
  #                  label.x = 0.5,
  #                  label.y = 'bottom', size = 4,parse = TRUE)+
    theme_cowplot()+
    theme(aspect.ratio = 1,strip.background = element_blank(),plot.title = element_text(hjust = 0.5),legend.position = 'top')+
    scale_colour_brewer(palette = "Dark2")+
    scale_fill_brewer(palette = "Dark2")+
    ggtitle(title)+ylab(corrNames[2])+xlab(corrNames[1])+
      scale_y_continuous(breaks = scales::extended_breaks(n = 5))+
      scale_x_continuous(breaks = scales::extended_breaks(n = 5))
      if (GroupVarNames2[1] == ''){  #No Grouping for the fill color is applied
       p <- p + theme(legend.position = "none") +
         geom_smooth(color="black",method = "lm", formula = formula,size=1, fullrange = FALSE)
      }
      else{
        if (!is.null(HueVar)){  #No hue is applied
        p <- p +
          # geoms below will use another color scale
          new_scale_color() +
          geom_point(data = dfCorr,aes_string(color = "HueVar"), size = 1, shape = 20) +
          # Color scale applied to geoms added after new_scale_color()
          scale_color_manual(values = shadeColormap)+
          theme(legend.position = "none")}
        p <- p +
          # geoms below will use another color scale
          new_scale_color() +
          geom_smooth(color="black",method = "lm", formula = formula,size=1, fullrange = FALSE)+
          geom_smooth(aes_string(color = "Group"),method = "lm", formula = formula,se = F,size=0.75)+
          stat_fit_glance(method = 'cor.test', method.args = list(formula = ~ x + y),
                          aes(color = Group, label=ifelse(..p.value..< (0.001/multiComp),sprintf('R^2~"="~%.2f~"***"',
                                                                                                 stat(estimate)) , 
                                                          ifelse(..p.value..>=(0.001/multiComp) & ..p.value..<(0.01/multiComp), sprintf('R^2~"="~%.2f~"**"',
                                                                                                                                        stat(estimate)) ,
                                                                 ifelse(..p.value..>=(0.01/multiComp) & ..p.value..<(0.05/multiComp),sprintf('R^2~"="~%.2f~"*"',
                                                                                                                                             stat(estimate)) ,
                                                                        sprintf('R^2~"="~%.2f~~p~"="~%.2g',stat(estimate), stat(p.value)))))),
                          label.x = 0.05,
                          label.y = 'top', size = 3,parse = TRUE)+
        #  stat_fit_glance(method = 'lm', method.args = list(formula = formula),
        #                  aes(color = Group, label=ifelse(..p.value..< (0.001/multiComp),sprintf('R^2~"="~%.2f~"***"',
        #                                                                             stat(r.squared)) , 
        #                                                  ifelse(..p.value..>=(0.001/multiComp) & ..p.value..<(0.01/multiComp), sprintf('R^2~"="~%.2f~"**"',
        #                                                                                                        stat(r.squared)) ,
        #                                                         ifelse(..p.value..>=(0.01/multiComp) & ..p.value..<(0.05/multiComp),sprintf('R^2~"="~%.2f~"*"',
        #                                                                                                             stat(r.squared)) ,
        #                                                                sprintf('R^2~"="~%.2f~~p~"="~%.2g',stat(r.squared), stat(p.value)))))),
        #                  label.x = 0.05,
        #                  label.y = 'top', size = 3,parse = TRUE)+
          scale_colour_brewer(palette = "Dark2")
      }
    }  # end of function