spvs_Statistics <- function(dataFrame,MeasureVar,paired){
  # spvs_Statistics <- function(dataFrame,MeasureVar,paired)
  # Automated statistics scripts which picks the right statistics for your analysis. It compares the measures
  # indicated in MesasureVar by the Group variables. Includes descriptive statisitcs, distribution tests, variance
  # test, group means tests, and post hoc testing. All stats are stored in a test file. You can also recreate this
  # test file by calling the last lines of this script on the resulting list.
  #
  #   USAGE:
  #     stats <- spvs_Statistics <- function(dataFrame,MeasureVar,paired)
  #
  #   INPUTS:
  #     dataFrame = combined data frame (e.g. dfdata) (use spvs_ConcatenateDataFrame to create a single data frame)
  #     MeasureVar = list of measurement variables (e.g. c('tNAA','Glx')). default = 'tNAA'.
  #     paired = indicate whether paired testing will be used.
  #
  #
  #   OUTPUTS:
  #     stats     = list with statistic results
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
  #     2020-06-14: First version of the code.
  # 1 Falling back into defaults ---------------------------------------------------------- 
  
  source('functions/summarySE.r')
  if(missing(paired)){
    paired <- 0
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
              select(-max) %>%
              select(-meanMsd) %>%
              select(-meanPsd) %>%
              select(-ci)
  
# 2 Test for normality ---------------------------------------------------------- 
  W <- NULL
  p <- NULL
  normal <- NULL
  VarsName <- NULL
  method <- NULL
  uniqueGroups <- unique(dataFrame$Group)
  uniqueGroups <- as.list(uniqueGroups)
  for (meas in MeasureVar){

    data <- dataFrame[names(dataFrame) == meas][[1]]
    for (groups in uniqueGroups){
    Normal <- shapiro.test(data[dataFrame$Group == groups])
    stat <- rbind(W,Normal$statistic[[1]])
    p <- rbind(p,Normal$p.value)
    VarsName <- rbind(VarsName,meas[[1]])
    method <- rbind(method,'ShapiroWilk')
    if (Normal$p.value < 0.05){
      normal <- rbind(normal,0)
    }
    else{
      normal <- rbind(normal,1)
    }
  }}
  NormShWi = data.frame(VarsName,method,stat,p,normal)
  
  # 3 Variance test ---------------------------------------------------------- 
  stat <- NULL
  p <- NULL
  VarianceDiff <- NULL
  VarsName <- NULL
  method <- NULL
  uniqueGroups <- unique(dataFrame$Group)
  uniqueGroups <- as.list(uniqueGroups)
  for (meas in MeasureVar){
      Fligner <- fligner.test( dataFrame[,meas], dataFrame[,"Group"])
      DiffVar <- print(Fligner)
      stat <- rbind(stat,DiffVar$statistic[[1]])
      p <- rbind(p,DiffVar$p.value)
      VarsName <- rbind(VarsName,meas[[1]])
      method <- rbind(method,'Fligner')
      if (DiffVar$p.value < 0.05){
        VarianceDiff <- rbind(VarianceDiff,1)
      }
      else{
        VarianceDiff <- rbind(VarianceDiff,0)
      }
    }
  NormVar = data.frame(VarsName,method,stat,p,VarianceDiff)
  
  # 4 Variance post hoc test ---------------------------------------------------------- 
  if (all(NormVar$VarianceDiff[NormVar$VarsName == meas] == 1) == TRUE ){
  LevenePostHoc <- NULL
  method <- NULL
  stat <- NULL
  p <- NULL
  adj <- NULL
  VarsName <- NULL
    for (meas in MeasureVar){ 
      if (NormVar$VarianceDiff[NormVar$VarsName == meas] == 1){
        for(i in 2:choose(length(uniqueGroups),1)){
          measureF <- dataFrame[names(dataFrame) == meas][[1]]
          measure <-  measureF[dataFrame$Group == uniqueGroups[[i]]]
          measureC <- data.frame(measure)
          GroupF <- dataFrame[names(dataFrame) == 'Group'][[1]]
          Group <- GroupF[dataFrame$Group == uniqueGroups[[i]]]
          GroupC <- data.frame(Group)
          if(i != choose(length(uniqueGroups),1)){
          measure <-  measureF[dataFrame$Group == uniqueGroups[[1]]]}
          else{
            measure <-  measureF[dataFrame$Group == uniqueGroups[[1]]]  
          }
          measure <- data.frame(measure)
          if(i != choose(length(uniqueGroups),1)){
          Group <- GroupF[dataFrame$Group == uniqueGroups[[1]]]}
          else{
            Group <- GroupF[dataFrame$Group == uniqueGroups[[1]]]  
          }
          Group <- data.frame(Group)
          measureC <- rbind(measureC,measure)
          GroupC <- rbind(GroupC,Group)
          dfVarAn = data.frame(measureC,GroupC)
          colnames(dfVarAn) = list('measure','Group')
          Fligner <- fligner.test( dfVarAn[,'measure'], dfVarAn[,'Group'])
          DiffVar <- print(Fligner)
          stat <- rbind(stat,DiffVar$statistic[[1]])
          p <- rbind(p,DiffVar$p.value)
          if(i != choose(length(uniqueGroups),1)){
          VarsName <- rbind(VarsName,paste(meas[[1]], uniqueGroups[[i]], uniqueGroups[[1]]))}
          else{
          VarsName <- rbind(VarsName,paste(meas[[1]], uniqueGroups[[i]], uniqueGroups[[1]]))  
          }
          method <- rbind(method,'Fligner')
          adj <- rbind(adj,'Bonferroni')
        }
    }
    }
  padj <- p * nrow(p)
  sig <- padj
  sig[padj>0.05] = 0
  sig[padj<0.05] = '*'
  sig[padj<0.01] = '**'
  sig[padj<0.001] = '***'
  PostHocVar = data.frame(VarsName,method,adj,stat,padj,sig)}
  else{
    PostHocVar = 'No significant difference in the variance'
  }
  
  
  # 5 Comparison of means ---------------------------------------------------------- 
  stat <- NULL
  p <- NULL
  differ <- NULL
  VarsName <- NULL
  method <- NULL
  for (meas in MeasureVar){
    VarsName <- rbind(VarsName,meas[[1]])
    if (all(NormShWi$normal[NormShWi$VarsName == meas] == 1) == TRUE | descriptive$N[[1]]>50){
      measure <- dataFrame[names(dataFrame) == meas][[1]]
      Group <- dataFrame[names(dataFrame) == 'Group'][[1]]
      dfVarAn = data.frame(measure,Group)
      if (NormVar$VarianceDiff[NormVar$VarsName == meas] == 0){
      VarAna <- aov(measure ~ Group, data = dfVarAn)
        method <- rbind(method,'ANOVA')
        VarAn <- summary(VarAna)}
      else{
        VarAn <- welch.test(measure ~ Group, data = dfVarAn)
        method <- rbind(method,'Welch')
      }
        

      if (NormVar$VarianceDiff[NormVar$VarsName == meas] == 0){
        stat <- rbind(stat,VarAn[[1]]$`F value`[[1]])
        p <- rbind(p,VarAn[[1]]$`Pr(>F)`[[1]])
        if (VarAn[[1]]$`Pr(>F)`[[1]] < 0.05){
          differ <- rbind(differ,1)
        }
        else{
          differ <- rbind(differ,0)
        }}
      else{
        stat <- rbind(stat,VarAn$statistic)
        p <- rbind(p,VarAn$p.value)
        if (VarAn$p.value < 0.05){
          differ <- rbind(differ,1)
        }
        else{
          differ <- rbind(differ,0)
        }
      }
        
    }
    else{
      measure <- dataFrame[names(dataFrame) == meas][[1]]
      Group <- dataFrame[names(dataFrame) == 'Group'][[1]]
      dfVarAn = data.frame(measure,Group)
      VarAn <- kruskal.test(measure ~ Group, data = dfVarAn)
      method <- rbind(method,'KruskalWallis')
      stat <- rbind(stat,VarAn$statistic[[1]])
      p <- rbind(p,VarAn$p.value)
      if (VarAn$p.value < 0.05){
        differ <- rbind(differ,1)
      }
      else{
        differ <- rbind(differ,0)
      }}
  

}
VarAna = data.frame(VarsName,method,stat,p,differ)

# 6 Post hoc test for means test ---------------------------------------------------------- 
if (paired == 1){
  if (any(VarAna$differ == 1) == TRUE){
  VarsName <- NULL
  p <- NULL
  differ <- NULL
  VarsName <- NULL
  method <- NULL
  adjust <- NULL
  for (meas in MeasureVar){
    measure <- dataFrame[names(dataFrame) == meas][[1]]
    Group <- dataFrame[names(dataFrame) == 'Group'][[1]]
    dfPostHoc = data.frame(measure,Group)
    if (all(NormShWi$normal[NormShWi$VarsName == meas] == 1) == TRUE | descriptive$N[[1]]>50){
    if (VarAna$differ[VarAna$VarsName == meas] == 1){
      if (NormVar$VarianceDiff[NormVar$VarsName == meas] == 0){
      postHoc <- pairwise.t.test(dfPostHoc$measure, dfPostHoc$Group, paired = TRUE,
                  p.adjust.method = "bonferroni")
      method <- rbind(method,rep('pairedTtest',length(uniqueGroups)-1))
      rownames(postHoc$p.value) <- paste (meas, rownames(postHoc$p.value))
      p <- rbind(p,postHoc$p.value)
      adjust <- rbind(adjust,rep(postHoc$p.adjust.method,length(uniqueGroups)-1))}
      else {
        postHoc <- pairwise.t.test(dfPostHoc$measure, dfPostHoc$Group, paired = TRUE,
                                   p.adjust.method = "bonferroni", var.equal = FALSE)
        method <- rbind(method,rep('UnVarPairedTtest',length(uniqueGroups)-1))
        rownames(postHoc$p.value) <- paste (meas, rownames(postHoc$p.value))
        p <- rbind(p,postHoc$p.value)
        adjust <- rbind(adjust,rep(postHoc$p.adjust.method,length(uniqueGroups)-1))
      }
    }
    }
    else{
      postHoc <- pairwise.wilcox.test(dfPostHoc$measure, dfPostHoc$Group, paired = TRUE,
                                 p.adjust.method = "bonferroni")
      method <- rbind(method,rep('PairedWilcoxon',length(uniqueGroups)-1))
      rownames(postHoc$p.value) <- paste (meas, rownames(postHoc$p.value))
      p <- rbind(p,postHoc$p.value)
      adjust <- rbind(adjust,rep(postHoc$p.adjust.method,length(uniqueGroups)-1))
    }
  }
  sig <- p
  sig[p>0.05] = 0
  sig[p<0.05] = '*'
  sig[p<0.01] = '**'
  sig[p<0.001] = '***'
  colnames(sig) <- paste ('sig', uniqueGroups[1:length(uniqueGroups)-1])
  
  PostHoc <- data.frame(array(method),array(adjust),p,sig)
  names(PostHoc)[names(PostHoc) == "array.method."] <- "method"
  names(PostHoc)[names(PostHoc) == "array.adjust."] <- "multi_comp_cor" }
  else
  {PostHoc <- 'No significant difference in the means'}}
else{
  if (any(VarAna$differ == 1) == TRUE){
    VarsName <- NULL
    p <- NULL
    differ <- NULL
    VarsName <- NULL
    method <- NULL
    adjust <- NULL
    for (meas in MeasureVar){
      measure <- dataFrame[names(dataFrame) == meas][[1]]
      Group <- dataFrame[names(dataFrame) == 'Group'][[1]]
      dfPostHoc = data.frame(measure,Group)
      if (all(NormShWi$normal[NormShWi$VarsName == meas] == 1) == TRUE | descriptive$N[[1]]>50){
        if (VarAna$differ[VarAna$VarsName == meas] == 1){
          if (NormVar$VarianceDiff[NormVar$VarsName == meas] == 0){
            postHoc <- pairwise.t.test(dfPostHoc$measure, dfPostHoc$Group, paired = FALSE,
                                       p.adjust.method = "bonferroni")
            method <- rbind(method,rep('Ttest',length(uniqueGroups)-1))
            rownames(postHoc$p.value) <- paste (meas, rownames(postHoc$p.value))
            p <- rbind(p,postHoc$p.value)
            adjust <- rbind(adjust,rep(postHoc$p.adjust.method,length(uniqueGroups)-1))}
          else {
            postHoc <- pairwise.t.test(dfPostHoc$measure, dfPostHoc$Group, paired = FALSE,
                                       p.adjust.method = "bonferroni", var.equal = FALSE)
            method <- rbind(method,rep('UnVarTtest',length(uniqueGroups)-1))
            rownames(postHoc$p.value) <- paste (meas, rownames(postHoc$p.value))
            p <- rbind(p,postHoc$p.value)
            row.names(p)[[length(row.names(p))]] <- meas[[1]]
            adjust <- rbind(adjust,rep(postHoc$p.adjust.method,length(uniqueGroups)-1))
          }
        }}
      else{
        postHoc <- wilcox.test(dfPostHoc$measure~dfPostHoc$Group, paired = FALSE,
                                        p.adjust.method = "bonferroni")
        method <- rbind(method,rep('Wilcoxon',length(uniqueGroups)-1))
        p <- rbind(p,postHoc$p.value*length(uniqueGroups)*length(MeasureVar))
        row.names(p)[[length(row.names(p))]] <- meas[[1]]
        adjust <- rbind(adjust,rep('bonferroni',length(uniqueGroups)-1))
      }
    }
    sig <- p
    sig[p>0.05] = 0
    sig[p<0.05] = '*'
    sig[p<0.01] = '**'
    sig[p<0.001] = '***'
    colnames(sig) <- paste ('sig', uniqueGroups[1:length(uniqueGroups)-1])
    
    PostHoc <- data.frame(array(method),array(adjust),p,sig)
    names(PostHoc)[names(PostHoc) == "array.method."] <- "method"
    names(PostHoc)[names(PostHoc) == "array.adjust."] <- "multi_comp_cor" }
  else
  {PostHoc <- 'No significant difference in the means'}}  


# 7 Store list and print ---------------------------------------------------------- 
statistics <- list(descriptive, NormShWi,NormVar,PostHocVar, VarAna,PostHoc)
names(statistics)[1]<- 'Descriptive Statistics'
names(statistics)[2]<- 'Test for Normal Distribution'
names(statistics)[3]<- 'Test for Normal Distribution of Variances'
names(statistics)[4]<- 'Post hoc test heterogeneous variances'
names(statistics)[5]<- 'Variance Analysis'
names(statistics)[6]<- 'Posthoc test Variance Analysis'

sink('statistics.txt')
print(statistics)
sink()
return(statistics)
}