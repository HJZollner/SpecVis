spvs_BlandAltman <- function(dataFrame,Quant,MeasureVar,GroupVarNames1,GroupVarNames2,HueVar,lowerLimits,upperLimits,colNum,title,legendTitle){
  # spvs_BlandAltman <- function(dataFrame,Quant,MeasureVar,GroupVarNames1,GroupVarNames2,HueVar,lowerLimits,upperLimits,colNum,title,legendTitle)
  # Creates a correaltion plot for the list of MeasureVars. Different colors for groups and correaltions, as well as hue
  # for differentiation can be added. 
  #
  #   USAGE:
  #     p <- spvs_Correlation(dataFrame,Quant,MeasureVar,GroupVarNames1,GroupVarNames2,HueVar,lowerLimits,upperLimits,colNum,title,legendTitle)
  #
  #   INPUTS:
  #     dataFrame = list of data frames with metabolite estiamtes (e.g. c(dfOspreyGE,dfOspreySiemens,dfLCModelGE,dfLCModelSiemens))
  #     Quant = name of the quantification for labelling purposes. default = '/ [tCr]'.
  #     MeasureVar = list of measurement variables (e.g. c('tNAA','Glx')). default = 'tNAA'.
  #     GroupVarNames1 = list of x and y axis names corresponding to each data frame in the list (e.g. c('Osprey','Osprey','LCModel','LCModel')).
  #     GroupVarNames2 = list of groups of each data frame (e.g. different patient groups or vendors c('GE','Siemens','GE','Siemens'))
  #     HueVar = list of column names for the HueVar (e.g. different sites c('group name', 'group name','group name', 'group name')).
  #     lowerLimits/upperLimits = list of facet upper und lower axis Limits. You need to add one value per MeasureVar and 5 % margin will be added.
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
  if (missing(colNum)){
    colNum <- 2
  }
  if(missing(title)){
    if(length(dataFrame)>1){
      title <- paste ("Bland-Altman [metabolite]", Quant)  
    }
    else{
      title <- paste ("Bland-Altman", MeasureVar[1], Quant, "vs", MeasureVar[2], Quant) 
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
  dfCorr$average <- (dfCorr$MeasureVar2 + dfCorr$MeasureVar1) / 2
  dfCorr$difference <- dfCorr$MeasureVar2 - dfCorr$MeasureVar1

  sumcatdat <- summarySE(dfCorr, measurevar = 'difference', groupvars='MetabName')
  sumcatdat$MetaboliteNum = rev(1:nrow(sumcatdat))
  meanVal <- dfCorr %>%
    group_by(Group,MetabName) %>%
    summarize(means = mean(difference))
  meanValNum <- dfCorr %>%
    group_by(Group,MetaboliteNum) %>%
    summarize(sds = sd(difference))
  meanVal$MetaboliteNum <- meanValNum$MetaboliteNum
  meanVal$sds <- meanValNum$sds
  meanValNum <- dfCorr %>%
    group_by(Group,MetaboliteNum) %>%
    summarize(means = mean(average))
  meanVal$AvMean <- meanValNum$means
  
  meanValCol <- dfCorr %>%
    group_by(MetabName) %>%
    summarize(means = mean(difference))
  meanValNumCol <- dfCorr %>%
    group_by(MetaboliteNum) %>%
    summarize(sds = sd(difference))
  meanValCol$MetaboliteNum <- meanValNumCol$MetaboliteNum
  meanValCol$sds <- meanValNumCol$sds
  meanValNumCol <- dfCorr %>%
    group_by(MetaboliteNum) %>%
    summarize(means = mean(average))
  meanValCol$AvMean <- meanValNumCol$means
  
  # 2 Generating facet limits ------------------------------------  
  if(length(GroupVarNames1) == length(GroupVarNames2)){ #Preparing data as a list of data frames is passed
    facetlim = dfCorr %>% 
      group_by(MetabName) %>% 
      summarise(min = min(average)-((max(average)-min(average))*0.05), max = max(average)+((max(average)-min(average))*0.05)) %>%
      gather(range, average, -MetabName)
    facetlimN = dfCorr %>% 
      group_by(MetaboliteNum) %>% 
      summarise(min = min(average), max = max(average)) %>%
      gather(range, average, -MetaboliteNum)
    facetlim$MetaboliteNum <- facetlimN$MetaboliteNum}
  else{ #Preparing data if a single data frame is passed
    MetabName <- NULL
    facetlim = dfCorr %>% 
      group_by(MetaboliteNum) %>% 
      summarise(min = min(average)-((max(average)-min(average))*0.05), max = max(average)+((max(average)-min(average))*0.05)) %>%
      gather(range, average, -MetaboliteNum)
    facetlim2 = dfCorr %>% 
      group_by(MetaboliteNum) %>% 
      summarise(min = min(difference)-((max(difference)-min(difference))*0.05), max = max(difference)+((max(difference)-min(difference))*0.05)) %>%
      gather(range, difference, -MetaboliteNum)
    facetlim$difference <- facetlim2$difference
    for (n in  0:((length(MeasureVar)/2)-1)){
      MetabName <- rbind(MetabName,paste(MeasureVar[[(2*n+1)]],MeasureVar[[(2*n+2)]],sep = ' vs '))
    }
    MetabName <- c(rev(MetabName),rev(MetabName))
    facetlim$MetabName <- MetabName}
  
  facetlim$difference <- rep(0,nrow(facetlim))
  
  if (!is.null(upperLimits)){
    upperLimits <- upperLimits + ((upperLimits-lowerLimits)*0.05)
    lowerLimits <- lowerLimits - ((upperLimits-lowerLimits)*0.05)
    lowerLimits1 <- lowerLimits[1:(length(lowerLimit)/2)]
    upperLimits1 <- upperLimits[1:(length(upperLimits)/2)]
    lowerLimits2 <- lowerLimits[((length(lowerLimit)/2)+1):length(lowerLimit)]
    upperLimits2 <- upperLimits[((length(upperLimits)/2)+1):length(upperLimits)]
    limits1 <- c(rev(lowerLimits1),rev(upperLimits1))
    limits2 <- c(rev(lowerLimits2),rev(upperLimits2))
    if(length(GroupVarNames1) == length(GroupVarNames2)){ 
      facetlim$average <- limits1
      facetlim$difference <- limits2}
    else{
      facetlim$average <- spvs_nth_element(limits1,1,2)
      facetlim$difference <- spvs_nth_element(limits2,1,2)  
    }
  }
  
  shade <- NULL  
  for (i in 1:length(unique(dfCorr$Group))){   
    shade<-  cbind(shade,length(unique(dataFrame[[i]]$`group`)))}
  shadeColormap <- spvs_shadeColormap('Dark2',length(unique(dfCorr$Group)),shade,0)

  StatMeanLine <- ggproto("StatMeanLine", Stat,
                          compute_group = function(data, scales) {
                            transform(data, yintercept=mean(y))
                          },
                          required_aes = c("x", "y")
  )
  
  stat_mean_line <- function(mapping = NULL, data = NULL, geom = "hline",
                             position = "identity", na.rm = FALSE, show.legend = NA, 
                             inherit.aes = TRUE, ...) {
    layer(
      stat = StatMeanLine, data = data, mapping = mapping, geom = geom, 
      position = position, show.legend = show.legend, inherit.aes = inherit.aes,
      params = list(na.rm = na.rm, ...)
    )
  }
  
  BAUpLine <- ggproto("BAUpLine", Stat,
                          compute_group = function(data, scales) {
                            transform(data, yintercept=mean(y)+1.95*sd(y))
                          },
                          required_aes = c("x", "y")
  )
  
  BA_up_line <- function(mapping = NULL, data = NULL, geom = "hline",
                             position = "identity", na.rm = FALSE, show.legend = NA, 
                             inherit.aes = TRUE, ...) {
    layer(
      stat = BAUpLine, data = data, mapping = mapping, geom = geom, 
      position = position, show.legend = show.legend, inherit.aes = inherit.aes,
      params = list(na.rm = na.rm, ...)
    )
  }
  
  BALoLine <- ggproto("BALoLine", Stat,
                      compute_group = function(data, scales) {
                        transform(data, yintercept=mean(y)-1.95*sd(y))
                      },
                      required_aes = c("x", "y")
  )
  
  BA_lo_line <- function(mapping = NULL, data = NULL, geom = "hline",
                         position = "identity", na.rm = FALSE, show.legend = NA, 
                         inherit.aes = TRUE, ...) {
    layer(
      stat = BALoLine, data = data, mapping = mapping, geom = geom, 
      position = position, show.legend = show.legend, inherit.aes = inherit.aes,
      params = list(na.rm = na.rm, ...)
    )
  }
  
  meanVal$label <- sprintf(
      "RPC = %.1f%%", (1.95*meanVal$sds)/meanVal$AvMean * 100
    )
  
  meanValCol$label <- sprintf(
    "RPC = %.1f%%", (1.95*meanValCol$sds)/meanValCol$AvMean * 100
  )
  
  multiplierL <- NULL  
  for (i in 1:length(unique(MeasureVar))){
    multiplier = 1 - 0.1 * (i-1)
    multiplierL <- rbind(multiplierL,rep(multiplier,length(unique(dfCorr$Group))))
    }
  multi = array(t(multiplierL))
  
  meanVal$ypos <- rep(rev(upperLimits2),length(unique(dfCorr$Group)))
  meanVal$ypos <-  meanVal$ypos * multi
  meanVal$xpos <- rep(rev(lowerLimits1+(upperLimits1-lowerLimits1)/2),length(unique(dfCorr$Group)))
  # 3 Creating final plot ------------------------------------ 
  p <-  ggplot(dfCorr, aes(x = average, y = difference)) +
    geom_blank(data=facetlim)+
    guides(colour=guide_legend(legendTitle))+guides(fill=guide_legend(legendTitle))+
    #stat_mean_line(color="black") +
    #BA_up_line(color="black",linetype="dashed") +
    #BA_lo_line(color="black",linetype="dashed") +
    #geom_hline(data=meanVal,aes(yintercept=means,color = Group))+
    geom_point(aes_string(color = "Group"),size = 1.5)+
    geom_rug(aes_string(color = "Group"),alpha = 0.5, position = 'jitter')+
    geom_text(size= 4,data = meanVal,mapping = aes_string(x = 'xpos', y = 'ypos', label = 'label',colour = 'Group')) +
    geom_text(size= 5,data = meanValCol,mapping = aes_string(x = -Inf, y = -Inf, label = 'label'),colour = 'black',vjust = -1.1, hjust =-0.1) +
    stat_ellipse(type='t')+
    stat_ellipse(geom = 'polygon', aes(fill = Group),type='t',alpha = 0.25)+
  facet_wrap(~reorder(MetabName, -MetaboliteNum), scales = "free", ncol = colNum)
  p <- p + geom_abline(slope = 0,intercept = 0,linetype="dashed",alpha = 0.5, col="black")
  
  p <- p + theme_cowplot()+
    theme(aspect.ratio = 1,strip.background = element_blank(),plot.title = element_text(hjust = 0.5),legend.position = 'top')+
    scale_colour_brewer(palette = "Dark2")+
    scale_fill_brewer(palette = "Dark2")+
    ggtitle(title)+ylab(paste('diff(',corrNames[2],'vs',corrNames[1],')') )+xlab(paste('mean(',corrNames[2],'vs',corrNames[1],')'))+
    scale_y_continuous(breaks = scales::extended_breaks(n = 5))+
    scale_x_continuous(breaks = scales::extended_breaks(n = 5))
  if (GroupVarNames2[1] == ''){  #No Grouping for the fill color is applied
    p <- p + theme(legend.position = "none")
  }
  else{
    p <- p + theme(legend.position = "none")
    if (!is.null(HueVar)){  #No hue is applied
      p <- p +
        # geoms below will use another color scale
        new_scale_color() +
        geom_point(data = dfCorr,aes_string(color = "HueVar"), size = 1, shape = 20) +
        # Color scale applied to geoms added after new_scale_color()
        scale_color_manual(values = shadeColormap)+
        theme(legend.position = "none")}
    
    return (p)
  }
}  # end of function