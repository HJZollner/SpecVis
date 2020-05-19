spvs_Statistics <- function(dataFrame,MeasureVar){
  source('functions/summarySE.r')
  #for (meas in MeasureVar){
   # dataFrame[names(dataFrame) == meas] <- log10(dataFrame[names(dataFrame) == meas][[1]]+ (1-min(dataFrame[names(dataFrame) == meas][[1]])))
  #}
  
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
  
  stat <- NULL
  p <- NULL
  VarianceDiff <- NULL
  VarsName <- NULL
  method <- NULL
  uniqueGroups <- unique(dataFrame$Group)
  uniqueGroups <- as.list(uniqueGroups)
  for (meas in MeasureVar){
  #    Levene <- levene.test( dataFrame[,meas], dataFrame[,"Group"],location="median", correction.method="zero.correction")
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
  
  LevenePostHoc <- NULL
  method <- NULL
  stat <- NULL
  p <- NULL
  adj <- NULL
  VarsName <- NULL
    for (meas in MeasureVar){ 
      if (NormVar$VarianceDiff[NormVar$VarsName == meas] == 1){
        for(i in 1:choose(length(uniqueGroups),2)){
          measureF <- dataFrame[names(dataFrame) == meas][[1]]
          measure <-  measureF[dataFrame$Group == uniqueGroups[[i]]]
          measureC <- data.frame(measure)
          GroupF <- dataFrame[names(dataFrame) == 'Group'][[1]]
          Group <- GroupF[dataFrame$Group == uniqueGroups[[i]]]
          GroupC <- data.frame(Group)
          if(i != choose(length(uniqueGroups),2)){
          measure <-  measureF[dataFrame$Group == uniqueGroups[[i+1]]]}
          else{
            measure <-  measureF[dataFrame$Group == uniqueGroups[[1]]]  
          }
          measure <- data.frame(measure)
          if(i != choose(length(uniqueGroups),2)){
          Group <- GroupF[dataFrame$Group == uniqueGroups[[i+1]]]}
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
          if(i != choose(length(uniqueGroups),2)){
          VarsName <- rbind(VarsName,paste(meas[[1]], uniqueGroups[[i]], uniqueGroups[[i+1]]))}
          else{
          VarsName <- rbind(VarsName,paste(meas[[1]], uniqueGroups[[i]], uniqueGroups[[1]]))  
          }
          method <- rbind(method,'Fligner')
          adj <- rbind(adj,'Bomferroni')
        }
    }
    }
  padj <- p * nrow(p)
  sig <- padj
  sig[padj>0.05] = 0
  sig[padj<0.05] = '*'
  sig[padj<0.01] = '**'
  sig[padj<0.001] = '***'
  PostHocVar = data.frame(VarsName,method,adj,stat,padj,sig)
  
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
  }}
  else{
    postHoc <- pairwise.wilcox.test(dfPostHoc$measure, dfPostHoc$Group, paired = TRUE,
                               p.adjust.method = "bonferroni")
    method <- rbind(method,rep('Wilcoxon',length(uniqueGroups)-1))
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
names(PostHoc)[names(PostHoc) == "array.adjust."] <- "multi_comp_cor"

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