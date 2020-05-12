spvs_BlandAltman <- function(dataFrame,Quant,MeasureVar,GroupVarNames1,GroupVarNames2,HueVar,lowerLimits,upperLimits,colNum,title,legendTitle){
  source("summarySE.R")
  source("spvs_CombineCorrelationDataFrame.R")
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
      title <- paste ("Correlation [metabolite]", Quant)  
    }
    else{
      title <- paste ("Correlation", MeasureVar[1], Quant, "vs", MeasureVar[2], Quant) 
    }
  }
  if(missing(legendTitle)){
    legendTitle <- ""
  }
  
  if(length(dataFrame)>1){
    dfCorr <- spvs_CombineCorrelationDataFrame(dataFrame,MeasureVar,GroupVarNames1,GroupVarNames2,HueVar)
  }
  corrNames <- unique(GroupVarNames1)
  
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
    upperLimits <- upperLimits + ((upperLimits-lowerLimits)*0.05)
    lowerLimits <- lowerLimits - ((upperLimits-lowerLimits)*0.05)
    limits <- c(rev(lowerLimits),rev(upperLimits))
    facetlim$MeasureVar1 <- limits
    facetlim$MeasureVar2 <- limits
  }
  shadeColormap <- spvs_shadeColormap('Dark2',length(unique(dfCorr$Group)),c(8,10,7))
  formula <- y ~ x 
  if(length(dataFrame)>1){
    p<-  ggplot(dfCorr, aes_string(x = "MeasureVar1", y = "MeasureVar2")) +
      geom_blank(data=facetlim)+
      guides(colour=guide_legend(legendTitle))+guides(fill=guide_legend(legendTitle))+
      facet_wrap(~reorder(MetabName, -MetaboliteNum), scales = "free", ncol = colNum)+
      geom_point(aes_string(color = "Group"),size = 1.5)+
      geom_abline(slope = 1,intercept = 0,linetype="dashed",alpha = 0.5, col="black")+
      geom_smooth(color="black",method = "lm", formula = formula,size=1, fullrange = FALSE) +
      stat_fit_glance(method = 'lm', method.args = list(formula = formula),
                      aes(label=ifelse(..p.value..< 0.001,sprintf('R^2~"="~%.2f~"***"',
                                                                  stat(r.squared), stat(p.value)) , 
                                       ifelse(..p.value..>=0.001 & ..p.value..<0.01, sprintf('R^2~"="~%.2f~"**"',
                                                                                             stat(r.squared), stat(p.value)) ,
                                              ifelse(..p.value..>=0.01 & ..p.value..<0.05,sprintf('R^2~"="~%.2f~"*"',
                                                                                                  stat(r.squared), stat(p.value)) ,
                                                     sprintf('R^2~"="~%.2f~~p~"="~%.2g',stat(r.squared), stat(p.value)))))),
                      label.x = 0.95,
                      label.y = 'bottom', size = 4,parse = TRUE)+
      theme_cowplot()+
      theme(aspect.ratio = 1,strip.background = element_blank(),plot.title = element_text(hjust = 0.5),legend.position = 'top')+
      scale_colour_brewer(palette = "Dark2")+
      scale_fill_brewer(palette = "Dark2")+
      ggtitle(title)+ylab(corrNames[2])+xlab(corrNames[1])+
      scale_y_continuous(breaks = scales::extended_breaks(n = 5))+
      scale_x_continuous(breaks = scales::extended_breaks(n = 5))
    if (GroupVarNames2[1] == ''){
      p <- p + theme(legend.position = "none")
    }
    else{
      p <- p + geom_smooth(aes_string(color = "Group"),method = "lm", formula = formula,se = F,size=0.75)+
        stat_fit_glance(method = 'lm', method.args = list(formula = formula),
                        aes(color = Group, label=ifelse(..p.value..< 0.001,sprintf('R^2~"="~%.2f~"***"',
                                                                                   stat(r.squared), stat(p.value)) , 
                                                        ifelse(..p.value..>=0.001 & ..p.value..<0.01, sprintf('R^2~"="~%.2f~"**"',
                                                                                                              stat(r.squared), stat(p.value)) ,
                                                               ifelse(..p.value..>=0.01 & ..p.value..<0.05,sprintf('R^2~"="~%.2f~"*"',
                                                                                                                   stat(r.squared), stat(p.value)) ,
                                                                      sprintf('R^2~"="~%.2f~~p~"="~%.2g',stat(r.squared), stat(p.value)))))),
                        label.x = 0.05,
                        label.y = 'top', size = 3,parse = TRUE)
    }
  }  
  
}