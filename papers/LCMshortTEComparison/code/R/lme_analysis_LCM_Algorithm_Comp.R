# Load packages -----------------------------------------------------------
library(lme4)
library(lattice)
library(raster)
library(boot)
library(pbkrtest)
library(parallel)
library(psych)
library(ggplot2)
library(nloptr)
library(optimx)
library(multcomp)
library(extrafont)
setwd("~/Documents/Johns Hopkins/Projects/Multi-Site Study/Stats/Big GABA II/")

# Load functions ----------------------------------------------------------
source("multiplot.R")

nloptFun <- function(fn, par, lower, upper, control=list(), ...) {
  for (n in names(defaultControl)) 
    if (is.null(control[[n]])) control[[n]] <- defaultControl[[n]]
    res <- nloptr(x0=par, eval_f=fn, lb=lower, ub=upper, opts=control, ...)
    with(res, list(par=solution,
                   fval=objective,
                   feval=iterations,
                   conv=if (status>0) 0 else status,
                   message=message))
}

cs. <- function(x) scale(x, center=T, scale=T) # for standardizing (z-transforming) outcome and predictor variables; aids with model convergence and interpretability of parameter estimates

r2.global <- function(m) {
  lmfit <-  lm(model.response(model.frame(m)) ~ fitted(m))
  summary(lmfit)$r.squared
}

r2.local <- function(small_model, large_model) {
  vc_small_model <- as.data.frame(VarCorr(small_model))[4]
  vc_large_model <- as.data.frame(VarCorr(large_model))[4]
  out <- as.numeric((tail(vc_small_model,n=1) - tail(vc_large_model,n=1)) / tail(vc_small_model,n=1))
  return(out)
}

## tNAA
Y.M0.1  <- lm(cs.(tNAA) ~ 1, data=dfLCMLMM)
Y.M0.2a <- lmer(cs.(tNAA) ~ (1 | site), data=dfLCMLMM, REML=F, control=optimToUse)
Y.M0.2b <- lmer(cs.(tNAA) ~ (1 | vendor), data=dfLCMLMM, REML=F, control=optimToUse)
Y.M0.3a <- lmer(cs.(tNAA) ~ (1 | site) + (1 | vendor), data=dfLCMLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.3a))[4]
vpc.M0.3a = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.3a)[[1]] <- c("Site","Vendor","Participant")
vpcLCM <-vpc.M0.3a
names(vpcLCM)[names(vpcLCM) == "vcov"] <- "tNAA"

# Set up parallel computation
nc <- detectCores()
clus <- makeCluster(rep("localhost", nc))
clusterEvalQ(clus, library(pbkrtest))
clusterExport(clus, c("nloptr", "defaultControl", "nloptFun"))

PB_LRT_LCM.tNAA1 <- PBmodcomp(Y.M0.3a, Y.M0.2a, nsim=2e3, cl=clus)
PB_LRT_LCM.tNAA2 <- PBmodcomp(Y.M0.3a, Y.M0.2b, nsim=2e3, cl=clus)

stopCluster(clus)

(LRT_LCM.tNAA1 <- anova(Y.M0.3a, Y.M0.2a))
(LRT_LCM.tNAA2 <- anova(Y.M0.3a, Y.M0.2b))

Y.M0.1  <- lm(cs.(tNAA) ~ 1, data=dfOspLMM)
Y.M0.2a <- lmer(cs.(tNAA) ~ (1 | site), data=dfOspLMM, REML=F, control=optimToUse)
Y.M0.2b <- lmer(cs.(tNAA) ~ (1 | vendor), data=dfOspLMM, REML=F, control=optimToUse)
Y.M0.3a <- lmer(cs.(tNAA) ~ (1 | site) + (1 | vendor), data=dfOspLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.3a))[4]
vpc.M0.3a = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.3a)[[1]] <- c("Site","Vendor","Participant")
vpcOsp <-vpc.M0.3a
names(vpcOsp)[names(vpcOsp) == "vcov"] <- "tNAA"

Y.M0.1  <- lm(cs.(tNAA) ~ 1, data=dfTarLMM)
Y.M0.2a <- lmer(cs.(tNAA) ~ (1 | site), data=dfTarLMM, REML=F, control=optimToUse)
Y.M0.2b <- lmer(cs.(tNAA) ~ (1 | vendor), data=dfTarLMM, REML=F, control=optimToUse)
Y.M0.3a <- lmer(cs.(tNAA) ~ (1 | site) + (1 | vendor), data=dfTarLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.3a))[4]
vpc.M0.3a = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.3a)[[1]] <- c("Site","Vendor","Participant")
vpcTar <-vpc.M0.3a
names(vpcTar)[names(vpcTar) == "vcov"] <- "tNAA"

## tCho
Y.M0.1  <- lm(cs.(tCho) ~ 1, data=dfLCMLMM)
Y.M0.2a <- lmer(cs.(tCho) ~ (1 | site), data=dfLCMLMM, REML=F, control=optimToUse)
Y.M0.2b <- lmer(cs.(tCho) ~ (1 | vendor), data=dfLCMLMM, REML=F, control=optimToUse)
Y.M0.3a <- lmer(cs.(tCho) ~ (1 | site) + (1 | vendor), data=dfLCMLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.3a))[4]
vpc.M0.3a = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.3a)[[1]] <- c("Site","Vendor","Participant")
vpcLCM$tCho <-vpc.M0.3a

Y.M0.1  <- lm(cs.(tCho) ~ 1, data=dfOspLMM)
Y.M0.2a <- lmer(cs.(tCho) ~ (1 | site), data=dfOspLMM, REML=F, control=optimToUse)
Y.M0.2b <- lmer(cs.(tCho) ~ (1 | vendor), data=dfOspLMM, REML=F, control=optimToUse)
Y.M0.3a <- lmer(cs.(tCho) ~ (1 | site) + (1 | vendor), data=dfOspLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.3a))[4]
vpc.M0.3a = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.3a)[[1]] <- c("Site","Vendor","Participant")
vpcOsp$tCho <-vpc.M0.3a

Y.M0.1  <- lm(cs.(tCho) ~ 1, data=dfTarLMM)
Y.M0.2a <- lmer(cs.(tCho) ~ (1 | site), data=dfTarLMM, REML=F, control=optimToUse)
Y.M0.2b <- lmer(cs.(tCho) ~ (1 | vendor), data=dfTarLMM, REML=F, control=optimToUse)
Y.M0.3a <- lmer(cs.(tCho) ~ (1 | site) + (1 | vendor), data=dfTarLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.3a))[4]
vpc.M0.3a = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.3a)[[1]] <- c("Site","Vendor","Participant")
vpcTar$tCho <-vpc.M0.3a

## Glx
Y.M0.1  <- lm(cs.(Glx) ~ 1, data=dfLCMLMM)
Y.M0.2a <- lmer(cs.(Glx) ~ (1 | site), data=dfLCMLMM, REML=F, control=optimToUse)
Y.M0.2b <- lmer(cs.(Glx) ~ (1 | vendor), data=dfLCMLMM, REML=F, control=optimToUse)
Y.M0.3a <- lmer(cs.(Glx) ~ (1 | site) + (1 | vendor), data=dfLCMLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.3a))[4]
vpc.M0.3a = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.3a)[[1]] <- c("Site","Vendor","Participant")
vpcLCM$Glx <-vpc.M0.3a

Y.M0.1  <- lm(cs.(Glx) ~ 1, data=dfOspLMM)
Y.M0.2a <- lmer(cs.(Glx) ~ (1 | site), data=dfOspLMM, REML=F, control=optimToUse)
Y.M0.2b <- lmer(cs.(Glx) ~ (1 | vendor), data=dfOspLMM, REML=F, control=optimToUse)
Y.M0.3a <- lmer(cs.(Glx) ~ (1 | site) + (1 | vendor), data=dfOspLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.3a))[4]
vpc.M0.3a = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.3a)[[1]] <- c("Site","Vendor","Participant")
vpcOsp$Glx <-vpc.M0.3a

Y.M0.1  <- lm(cs.(Glx) ~ 1, data=dfTarLMM)
Y.M0.2a <- lmer(cs.(Glx) ~ (1 | site), data=dfTarLMM, REML=F, control=optimToUse)
Y.M0.2b <- lmer(cs.(Glx) ~ (1 | vendor), data=dfTarLMM, REML=F, control=optimToUse)
Y.M0.3a <- lmer(cs.(Glx) ~ (1 | site) + (1 | vendor), data=dfTarLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.3a))[4]
vpc.M0.3a = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.3a)[[1]] <- c("Site","Vendor","Participant")
vpcTar$Glx <-vpc.M0.3a

## Ins
Y.M0.1  <- lm(cs.(Ins) ~ 1, data=dfLCMLMM)
Y.M0.2a <- lmer(cs.(Ins) ~ (1 | site), data=dfLCMLMM, REML=F, control=optimToUse)
Y.M0.2b <- lmer(cs.(Ins) ~ (1 | vendor), data=dfLCMLMM, REML=F, control=optimToUse)
Y.M0.3a <- lmer(cs.(Ins) ~ (1 | site) + (1 | vendor), data=dfLCMLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.3a))[4]
vpc.M0.3a = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.3a)[[1]] <- c("Site","Vendor","Participant")
vpcLCM$Ins <-vpc.M0.3a

Y.M0.1  <- lm(cs.(Ins) ~ 1, data=dfOspLMM)
Y.M0.2a <- lmer(cs.(Ins) ~ (1 | site), data=dfOspLMM, REML=F, control=optimToUse)
Y.M0.2b <- lmer(cs.(Ins) ~ (1 | vendor), data=dfOspLMM, REML=F, control=optimToUse)
Y.M0.3a <- lmer(cs.(Ins) ~ (1 | site) + (1 | vendor), data=dfOspLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.3a))[4]
vpc.M0.3a = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.3a)[[1]] <- c("Site","Vendor","Participant")
vpcOsp$Ins <-vpc.M0.3a

Y.M0.1  <- lm(cs.(Ins) ~ 1, data=dfTarLMM)
Y.M0.2a <- lmer(cs.(Ins) ~ (1 | site), data=dfTarLMM, REML=F, control=optimToUse)
Y.M0.2b <- lmer(cs.(Ins) ~ (1 | vendor), data=dfTarLMM, REML=F, control=optimToUse)
Y.M0.3a <- lmer(cs.(Ins) ~ (1 | site) + (1 | vendor), data=dfTarLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.3a))[4]
vpc.M0.3a = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.3a)[[1]] <- c("Site","Vendor","Participant")
vpcTar$Ins <-vpc.M0.3a

## Compare repeated measure tNAA
Y.M0.1 <- lmer(cs.(tNAA) ~ (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M0.2 <- lmer(cs.(tNAA) ~ tool + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)

Y.M1.1 <- lmer(cs.(tNAA) ~ (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M1.2 <- lmer(cs.(tNAA) ~ tool + (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M1.2a <- lmer(cs.(tNAA) ~ tool + (1 | site)  + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M1.2b <- lmer(cs.(tNAA) ~ tool + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.2))[4]
vpc.M0.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.2)[[1]] <- c("Tool","Participant")
vpcTool0<-vpc.M0.2
names(vpcTool0)[names(vpcTool0) == "vcov"] <- "tNAA"

(LRT_Tool0.tNAA <- anova(Y.M0.1, Y.M0.2))
R2_Tool0.tNAA <- r2.local(Y.M0.1, Y.M0.2)

vc <- as.data.frame(VarCorr(Y.M1.2))[4]
vpc.M1.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M1.2)[[1]] <- c("Tool","Site","Vendor","Participant")
vpcTool1<-vpc.M1.2
names(vpcTool1)[names(vpcTool1) == "vcov"] <- "tNAA"

(LRT_Tool1.tNAA <- anova(Y.M1.1, Y.M1.2))
R2_Tool1.tNAA <- r2.local(Y.M1.1, Y.M1.2)

# Set up parallel computation
nc <- detectCores()
clus <- makeCluster(rep("localhost", nc))
clusterEvalQ(clus, library(pbkrtest))
clusterExport(clus, c("nloptr", "defaultControl", "nloptFun"))

PB_LRT_Tool0.tNAA <- PBmodcomp(Y.M0.2, Y.M0.1, nsim=2e3, cl=clus)
PB_LRT_Tool1.tNAA <- PBmodcomp(Y.M1.2, Y.M1.1, nsim=2e3, cl=clus)
PB_LRT_Tool1.tNAAa <- PBmodcomp(Y.M1.2, Y.M1.2a, nsim=2e3, cl=clus)
PB_LRT_Tool1.tNAAb <- PBmodcomp(Y.M1.2, Y.M1.2b, nsim=2e3, cl=clus)

stopCluster(clus)

## Compare repeated measure tCho
Y.M0.1 <- lmer(cs.(tCho) ~ (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M0.2 <- lmer(cs.(tCho) ~ tool + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)

Y.M1.1 <- lmer(cs.(tCho) ~ (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M1.2 <- lmer(cs.(tCho) ~ tool + (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M1.2a <- lmer(cs.(tCho) ~ tool + (1 | site)  + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M1.2b <- lmer(cs.(tCho) ~ tool + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.2))[4]
vpc.M0.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.2)[[1]] <- c("Tool","Participant")
vpcTool0$tCho<-vpc.M0.2

(LRT_Tool0.tCho <- anova(Y.M0.1, Y.M0.2))
R2_Tool0.tCho <- r2.local(Y.M0.1, Y.M0.2)

vc <- as.data.frame(VarCorr(Y.M1.2))[4]
vpc.M1.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M1.2)[[1]] <- c("Tool","Site","Vendor","Participant")
vpcTool1$tCho<-vpc.M1.2

(LRT_Tool1.tCho <- anova(Y.M1.1, Y.M1.2))
R2_Tool1.tCho <- r2.local(Y.M1.1, Y.M1.2)

# Set up parallel computation
nc <- detectCores()
clus <- makeCluster(rep("localhost", nc))
clusterEvalQ(clus, library(pbkrtest))
clusterExport(clus, c("nloptr", "defaultControl", "nloptFun"))

PB_LRT_Tool0.tCho <- PBmodcomp(Y.M0.2, Y.M0.1, nsim=2e3, cl=clus)
PB_LRT_Tool1.tCho <- PBmodcomp(Y.M1.2, Y.M1.1, nsim=2e3, cl=clus)
PB_LRT_Tool1.tChoa <- PBmodcomp(Y.M1.2, Y.M1.2a, nsim=2e3, cl=clus)
PB_LRT_Tool1.tChob <- PBmodcomp(Y.M1.2, Y.M1.2b, nsim=2e3, cl=clus)

stopCluster(clus)

## Compare repeated measure Glx
Y.M0.1 <- lmer(cs.(Glx) ~ (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M0.2 <- lmer(cs.(Glx) ~ tool + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)

Y.M1.1 <- lmer(cs.(Glx) ~ (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M1.2 <- lmer(cs.(Glx) ~ tool + (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M1.2a <- lmer(cs.(Glx) ~ tool + (1 | site)  + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M1.2b <- lmer(cs.(Glx) ~ tool + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.2))[4]
vpc.M0.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.2)[[1]] <- c("Tool","Participant")
vpcTool0$Glx<-vpc.M0.2

(LRT_Tool0.Glx <- anova(Y.M0.1, Y.M0.2))
R2_Tool0.Glx <- r2.local(Y.M0.1, Y.M0.2)

vc <- as.data.frame(VarCorr(Y.M1.2))[4]
vpc.M1.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M1.2)[[1]] <- c("Tool","Site","Vendor","Participant")
vpcTool1$Glx<-vpc.M1.2

(LRT_Tool1.Glx <- anova(Y.M1.1, Y.M1.2))
R2_Tool1.Glx <- r2.local(Y.M1.1, Y.M1.2)

# Set up parallel computation
nc <- detectCores()
clus <- makeCluster(rep("localhost", nc))
clusterEvalQ(clus, library(pbkrtest))
clusterExport(clus, c("nloptr", "defaultControl", "nloptFun"))

PB_LRT_Tool0.Glx <- PBmodcomp(Y.M0.2, Y.M0.1, nsim=2e3, cl=clus)
PB_LRT_Tool1.Glx <- PBmodcomp(Y.M1.2, Y.M1.1, nsim=2e3, cl=clus)
PB_LRT_Tool1.Glxa <- PBmodcomp(Y.M1.2, Y.M1.2a, nsim=2e3, cl=clus)
PB_LRT_Tool1.Glxb <- PBmodcomp(Y.M1.2, Y.M1.2b, nsim=2e3, cl=clus)

stopCluster(clus)

## Compare repeated measure Ins
Y.M0.1 <- lmer(cs.(Ins) ~ (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M0.2 <- lmer(cs.(Ins) ~ tool + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)

Y.M1.1 <- lmer(cs.(Ins) ~ (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M1.2 <- lmer(cs.(Ins) ~ tool + (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M1.2a <- lmer(cs.(Ins) ~ tool + (1 | site)  + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M1.2b <- lmer(cs.(Ins) ~ tool + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.2))[4]
vpc.M0.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.2)[[1]] <- c("Tool","Participant")
vpcTool0$Ins<-vpc.M0.2

(LRT_Tool0.Ins <- anova(Y.M0.1, Y.M0.2))
R2_Tool0.Ins <- r2.local(Y.M0.1, Y.M0.2)

vc <- as.data.frame(VarCorr(Y.M1.2))[4]
vpc.M1.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M1.2)[[1]] <- c("Tool","Site","Vendor","Participant")
vpcTool1$Ins<-vpc.M1.2

(LRT_Tool1.Ins <- anova(Y.M1.1, Y.M1.2))
R2_Tool1.Ins <- r2.local(Y.M1.1, Y.M1.2)

# Set up parallel computation
nc <- detectCores()
clus <- makeCluster(rep("localhost", nc))
clusterEvalQ(clus, library(pbkrtest))
clusterExport(clus, c("nloptr", "defaultControl", "nloptFun"))

PB_LRT_Tool0.Ins <- PBmodcomp(Y.M0.2, Y.M0.1, nsim=2e3, cl=clus)
PB_LRT_Tool1.Ins <- PBmodcomp(Y.M1.2, Y.M1.1, nsim=2e3, cl=clus)
PB_LRT_Tool1.Insa <- PBmodcomp(Y.M1.2, Y.M1.2a, nsim=2e3, cl=clus)
PB_LRT_Tool1.Insb <- PBmodcomp(Y.M1.2, Y.M1.2b, nsim=2e3, cl=clus)

stopCluster(clus)
# plots
colorDark <- brewer.pal(8, 'Dark2')
colorDarkSite <- c(colorDark[1],colorDark[1],colorDark[1],colorDark[1],colorDark[1],colorDark[1],colorDark[1],colorDark[1])
colorDarkSite <- c(colorDarkSite,colorDark[2],colorDark[2],colorDark[2],colorDark[2],colorDark[2],colorDark[2],colorDark[2],colorDark[2],colorDark[2],colorDark[2])
colorDarkSite <- c(colorDarkSite,colorDark[3],colorDark[3],colorDark[3],colorDark[3],colorDark[3],colorDark[3],colorDark[3])

ptNAA <- ggplot(data = dfDataLMM, aes(x = tool, y = tNAA, fill = site)) + 
  geom_boxplot(position = position_dodge(width = 0.35), width =0.35, alpha = 0.5, outlier.shape = NA, size = .2) +
  geom_point(aes(x=tool, y=tNAA,color = vendor), position = position_dodge(width = 0.35), size = 0.33, shape = 20) +
  facet_wrap(~vendor)+
  ylim(1, 2.125)
ptNAA <- ptNAA + scale_color_manual(values = colorDark)+scale_fill_manual(values = colorDarkSite)
ggsave(file="tNAAVariance.pdf", ptNAA, width = 10, height = 3,device=cairo_pdf) #saves g

ptCho <- ggplot(data = dfDataLMM, aes(x = tool, y = tCho, fill = site)) + 
  geom_boxplot(position = position_dodge(width = 0.35), width =0.35, alpha = 0.5, outlier.shape = NA, size = .2) +
  geom_point(aes(x=tool, y=tCho,color = vendor), position = position_dodge(width = 0.35), size = 0.33, shape = 20) +
  facet_wrap(~vendor)+
  ylim(0.075, 0.3)
ptCho <- ptCho + scale_color_manual(values = colorDark)+scale_fill_manual(values = colorDarkSite)
ggsave(file="tChoVariance.pdf", ptCho, width = 10, height = 3,device=cairo_pdf) #saves g

pGlx <- ggplot(data = dfDataLMM, aes(x = tool, y = Glx, fill = site)) + 
  geom_boxplot(position = position_dodge(width = 0.35), width =0.35, alpha = 0.5, outlier.shape = NA, size = .2) +
  geom_point(aes(x=tool, y=Glx,color = vendor), position = position_dodge(width = 0.35), size = 0.33, shape = 20) +
  facet_wrap(~vendor)+
  ylim(0.75, 2.75)
pGlx <- pGlx + scale_color_manual(values = colorDark)+scale_fill_manual(values = colorDarkSite)
ggsave(file="GlxVariance.pdf", pGlx, width = 10, height = 3,device=cairo_pdf) #saves g

pIns <- ggplot(data = dfDataLMM, aes(x = tool, y = Ins, fill = site)) + 
  geom_boxplot(position = position_dodge(width = 0.35), width =0.35, alpha = 0.5, outlier.shape = NA, size = .2) +
  geom_point(aes(x=tool, y=Ins,color = vendor), position = position_dodge(width = 0.35), size = 0.33, shape = 20) +
  facet_wrap(~vendor)+
  ylim(0.35, 1.15)
pIns <- pIns + scale_color_manual(values = colorDark)+scale_fill_manual(values = colorDarkSite)
ggsave(file="InsVariance.pdf", pIns, width = 10, height = 3,device=cairo_pdf) #saves g

ptNAA <- ggplot(data = dfDataLMM, aes(x = tool, y = tNAA, fill = vendor)) + 
  geom_boxplot(position = position_dodge(width = 0.35), width =0.35, alpha = 0.5, outlier.shape = NA, size = .2) +
  geom_point(aes(x=tool, y=tNAA,color = vendor), position = position_dodge(width = 0.35), size = 0.75, shape = 20)+
  ylim(1, 2.125)
ptNAA <- ptNAA + scale_color_manual(values = colorDark)+scale_fill_manual(values = colorDark)
ggsave(file="tNAAVarianceVend.pdf", ptNAA, width = 5, height = 3,device=cairo_pdf) #saves g

ptCho <- ggplot(data = dfDataLMM, aes(x = tool, y = tCho, fill = vendor)) + 
  geom_boxplot(position = position_dodge(width = 0.35), width =0.35, alpha = 0.5, outlier.shape = NA, size = .2) +
  geom_point(aes(x=tool, y=tCho,color = vendor), position = position_dodge(width = 0.35), size = 0.75, shape = 20)+
  ylim(0.075, 0.3)
ptCho <- ptCho + scale_color_manual(values = colorDark)+scale_fill_manual(values = colorDark)
ggsave(file="tChoVarianceVend.pdf", ptCho, width = 5, height = 3,device=cairo_pdf) #saves g

pGlx <- ggplot(data = dfDataLMM, aes(x = tool, y = Glx, fill = vendor)) + 
  geom_boxplot(position = position_dodge(width = 0.35), width =0.35, alpha = 0.5, outlier.shape = NA, size = .2) +
  geom_point(aes(x=tool, y=Glx,color = vendor), position = position_dodge(width = 0.35), size = 0.75, shape = 20) +
  ylim(0.75, 2.75)
pGlx <- pGlx + scale_color_manual(values = colorDark)+scale_fill_manual(values = colorDark)
ggsave(file="GlxVarianceVend.pdf", pGlx, width = 5, height = 3,device=cairo_pdf) #saves g

pIns <- ggplot(data = dfDataLMM, aes(x = tool, y = Ins, fill = vendor)) + 
  geom_boxplot(position = position_dodge(width = 0.35), width =0.35, alpha = 0.5, outlier.shape = NA, size = .2) +
  geom_point(aes(x=tool, y=Ins,color = vendor), position = position_dodge(width = 0.35), size = 0.75, shape = 20) +
  ylim(0.35, 1.15)
pIns <- pIns + scale_color_manual(values = colorDark)+scale_fill_manual(values = colorDark)
ggsave(file="InsVarianceVend.pdf", pIns, width = 5, height = 3,device=cairo_pdf) #saves g

## Compare repeated measure tNAA
Y.M0.1 <- lmer(cs.(tNAA) ~ (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M0.2 <- lmer(cs.(tNAA) ~ (1 | tool) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)

Y.M2.1 <- lmer(cs.(tNAA) ~ (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2 <- lmer(cs.(tNAA) ~ (1 | tool) + (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2a <- lmer(cs.(tNAA) ~ (1 | tool) + (1 | site)  + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2b <- lmer(cs.(tNAA) ~ (1 | tool) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2c <- lmer(cs.(tNAA) ~ (1 | tool) + (1 | site) + (1 | vendor) , data=dfDataLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.2))[4]
vpc.M0.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.2)[[1]] <- c("Tool","Participant")
vpcTool0<-vpc.M0.2
names(vpcTool0)[names(vpcTool0) == "vcov"] <- "tNAA"

(LRT_Tool0.tNAA <- anova(Y.M0.1, Y.M0.2))
R2_Tool0.tNAA <- r2.local(Y.M0.1, Y.M0.2)

vc <- as.data.frame(VarCorr(Y.M2.2))[4]
vpc.M2.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M2.2)[[1]] <- c("Participant","Site","Vendor","Tool","Res")
vpcRandTool1<-vpc.M2.2
names(vpcRandTool1)[names(vpcRandTool1) == "vcov"] <- "tNAA"

(LRT_Tool1.tNAA <- anova(Y.M2.1, Y.M2.2))
(LRT_Tool1.tNAAa <- anova(Y.M2.2a, Y.M2.2))
(LRT_Tool1.tNAAb <- anova(Y.M2.2b, Y.M2.2))
(LRT_Tool1.tNAAc <- anova(Y.M2.2c, Y.M2.2))
R2_Tool1.tNAA <- r2.local(Y.M2.1, Y.M2.2)

# Set up parallel computation
nc <- detectCores()
clus <- makeCluster(rep("localhost", nc))
clusterEvalQ(clus, library(pbkrtest))
clusterExport(clus, c("nloptr", "defaultControl", "nloptFun"))

PB_LRT_Tool0.tNAA <- PBmodcomp(Y.M0.2, Y.M0.1, nsim=2e3, cl=clus)
PB_LRT_RandTool1.tNAA <- PBmodcomp(Y.M2.2, Y.M2.1, nsim=2e3, cl=clus)
PB_LRT_RandTool1.tNAAa <- PBmodcomp(Y.M2.2, Y.M2.2a, nsim=2e3, cl=clus)
PB_LRT_RandTool1.tNAAb <- PBmodcomp(Y.M2.2, Y.M2.2b, nsim=2e3, cl=clus)
PB_LRT_RandTool1.tNAAc <- PBmodcomp(Y.M2.2, Y.M2.2c, nsim=2e3, cl=clus)

stopCluster(clus)

## Compare repeated measure tCho
Y.M0.1 <- lmer(cs.(tCho) ~ (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M0.2 <- lmer(cs.(tCho) ~ (1 | tool) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)

Y.M2.1 <- lmer(cs.(tCho) ~ (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2 <- lmer(cs.(tCho) ~ (1 | tool) + (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2a <- lmer(cs.(tCho) ~ (1 | tool) + (1 | site)  + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2b <- lmer(cs.(tCho) ~ (1 | tool) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2c<- lmer(cs.(tCho) ~ (1 | tool) + (1 | site) + (1 | vendor), data=dfDataLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.2))[4]
vpc.M0.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.2)[[1]] <- c("Tool","Participant")
vpcTool0$tCho<-vpc.M0.2

(LRT_Tool0.tCho <- anova(Y.M0.1, Y.M0.2))
(LRT_Tool1.tChoa <- anova(Y.M2.2a, Y.M2.2))
(LRT_Tool1.tChob <- anova(Y.M2.2b, Y.M2.2))
R2_Tool0.tCho <- r2.local(Y.M0.1, Y.M0.2)

vc <- as.data.frame(VarCorr(Y.M2.2))[4]
vpc.M2.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M2.2)[[1]] <- c("Participant","Site","Vendor","Tool","Res")
vpcRandTool1$tCho<-vpc.M2.2

(LRT_Tool1.tCho <- anova(Y.M2.1, Y.M2.2))
R2_Tool1.tCho <- r2.local(Y.M2.1, Y.M2.2)

# Set up parallel computation
nc <- detectCores()
clus <- makeCluster(rep("localhost", nc))
clusterEvalQ(clus, library(pbkrtest))
clusterExport(clus, c("nloptr", "defaultControl", "nloptFun"))

PB_LRT_Tool0.tCho <- PBmodcomp(Y.M0.2, Y.M0.1, nsim=2e3, cl=clus)
PB_LRT_RandTool1.tCho <- PBmodcomp(Y.M2.2, Y.M2.1, nsim=2e3, cl=clus)
PB_LRT_RandTool1.tChoa <- PBmodcomp(Y.M2.2, Y.M2.2a, nsim=2e3, cl=clus)
PB_LRT_RandTool1.tChob <- PBmodcomp(Y.M2.2, Y.M2.2b, nsim=2e3, cl=clus)
PB_LRT_RandTool1.tChoc <- PBmodcomp(Y.M2.2, Y.M2.2c, nsim=2e3, cl=clus)

stopCluster(clus)

## Compare repeated measure Glx
Y.M0.1 <- lmer(cs.(Glx) ~ (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M0.2 <- lmer(cs.(Glx) ~ (1 | tool) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)

Y.M2.1 <- lmer(cs.(Glx) ~ (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2 <- lmer(cs.(Glx) ~ (1 | tool) + (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2a <- lmer(cs.(Glx) ~ (1 | tool) + (1 | site)  + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2b <- lmer(cs.(Glx) ~ (1 | tool) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2c <- lmer(cs.(Glx) ~ (1 | tool) + (1 | site) + (1 | vendor), data=dfDataLMM, REML=F, control=optimToUse)

vc <- as.data.frame(VarCorr(Y.M0.2))[4]
vpc.M0.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.2)[[1]] <- c("Tool","Participant")
vpcTool0$Glx<-vpc.M0.2

(LRT_Tool0.Glx <- anova(Y.M0.1, Y.M0.2))
(LRT_Tool1.Glxa <- anova(Y.M2.2a, Y.M2.2))
(LRT_Tool1.Glxb <- anova(Y.M2.2b, Y.M2.2))
R2_Tool0.Glx <- r2.local(Y.M0.1, Y.M0.2)

vc <- as.data.frame(VarCorr(Y.M2.2))[4]
vpc.M2.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M2.2)[[1]] <- c("Participant","Site","Vendor","Tool","Res")
vpcRandTool1$Glx<-vpc.M2.2

(LRT_Tool1.Glx <- anova(Y.M2.1, Y.M2.2))
R2_Tool1.Glx <- r2.local(Y.M2.1, Y.M2.2)

# Set up parallel computation
nc <- detectCores()
clus <- makeCluster(rep("localhost", nc))
clusterEvalQ(clus, library(pbkrtest))
clusterExport(clus, c("nloptr", "defaultControl", "nloptFun"))

PB_LRT_Tool0.Glx <- PBmodcomp(Y.M0.2, Y.M0.1, nsim=2e3, cl=clus)
PB_LRT_RandTool1.Glx <- PBmodcomp(Y.M2.2, Y.M2.1, nsim=2e3, cl=clus)
PB_LRT_RandTool1.Glxa <- PBmodcomp(Y.M2.2, Y.M2.2a, nsim=2e3, cl=clus)
PB_LRT_RandTool1.Glxb <- PBmodcomp(Y.M2.2, Y.M2.2b, nsim=2e3, cl=clus)
PB_LRT_RandTool1.Glxc <- PBmodcomp(Y.M2.2, Y.M2.2c, nsim=2e3, cl=clus)

stopCluster(clus)

## Compare repeated measure Ins
Y.M0.1 <- lmer(cs.(Ins) ~ (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M0.2 <- lmer(cs.(Ins) ~ (1 | tool) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)

Y.M2.1 <- lmer(cs.(Ins) ~ (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2 <- lmer(cs.(Ins) ~ (1 | tool) + (1 | site) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2a <- lmer(cs.(Ins) ~ (1 | tool) + (1 | site)  + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2b <- lmer(cs.(Ins) ~ (1 | tool) + (1 | vendor) + (1 | subjectID), data=dfDataLMM, REML=F, control=optimToUse)
Y.M2.2c <- lmer(cs.(Ins) ~ (1 | tool) + (1 | vendor), data=dfDataLMM, REML=F, control=optimToUse)


vc <- as.data.frame(VarCorr(Y.M0.2))[4]
vpc.M0.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M0.2)[[1]] <- c("Tool","Participant")
vpcTool0$Ins<-vpc.M0.2

(LRT_Tool0.Ins <- anova(Y.M0.1, Y.M0.2))
R2_Tool0.Ins <- r2.local(Y.M0.1, Y.M0.2)

vc <- as.data.frame(VarCorr(Y.M2.2))[4]
vpc.M2.2 = round(vc/sum(vc)*100,1)
dimnames(vpc.M2.2)[[1]] <- c("Participant","Site","Vendor","Tool","Res")
vpcRandTool1$Ins<-vpc.M2.2

(LRT_Tool1.Ins <- anova(Y.M2.1, Y.M2.2))
(LRT_Tool1.Insa <- anova(Y.M2.2a, Y.M2.2))
(LRT_Tool1.Insb <- anova(Y.M2.2b, Y.M2.2))
(LRT_Tool1.Insc <- anova(Y.M2.2c, Y.M2.2))
R2_Tool1.Ins <- r2.local(Y.M2.1, Y.M2.2)

# Set up parallel computation
nc <- detectCores()
clus <- makeCluster(rep("localhost", nc))
clusterEvalQ(clus, library(pbkrtest))
clusterExport(clus, c("nloptr", "defaultControl", "nloptFun"))

PB_LRT_Tool0.Ins <- PBmodcomp(Y.M0.2, Y.M0.1, nsim=2e3, cl=clus)
PB_LRT_RandTool1.Ins <- PBmodcomp(Y.M2.2, Y.M2.1, nsim=2e3, cl=clus)
PB_LRT_RandTool1.Insa <- PBmodcomp(Y.M2.2, Y.M2.2a, nsim=2e3, cl=clus)
PB_LRT_RandTool1.Insb <- PBmodcomp(Y.M2.2, Y.M2.2b, nsim=2e3, cl=clus)
PB_LRT_RandTool1.Insc <- PBmodcomp(Y.M2.2, Y.M2.2c, nsim=2e3, cl=clus)
stopCluster(clus)
