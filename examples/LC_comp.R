## Description
#
# This script describes how to use several functions of the Spectra Visualizer R-package.
# It uses short-TE PRESS data from the https://www.nitrc.org/projects/biggaba/. Details are described in
# 'Comparison of Multivendor Single-Voxel MR Spectroscopy Data Acquired in Healthy Brain at 26 Sites'
# Považan et al. (2020). The analysis includes three sites (G1, P3, S5) which are each split into two
# abritrary halfs and analyzed with Osprey (), LCModel (), and Tarquin () to demonstrate the capabilities
# of the functions.
#
# AUTHOR:
#  Dr. Helge Zöllner (Johns Hopkins University, 2020-04-15)
#
# MAIL:
#  hzoelln2@jhmi.edu
#
# CREDITS:
#  This code is based on numerous functions from the spant toolbox by
# Dr. Martin Wilson (University of Birmingham)
# https://martin3141.github.io/spant/index.html

# 1 - Source needed scripts and set up path -----------------------------------
# You need to set the SpecVis directory as your working directory (setwd())
SpecVisPath <- '~/Documents/GitHub/SpecVis'
source('functions/dependencies.R')
source('functions/spvs_importResults.R')
source('functions/spvs_Correlation.R')
source('functions/spvs_Correlation_Facet.R')
source('functions/spvs_AddStatsToDataframe.R')
source('functions/spvs_ConcatenateDataFrame.R')
source('functions/spvs_RainCloud.R')
source('functions/spvs_Statistics.R')



# 2 - Load data and create dataframes -------------------------------------
# In the next part the results (from LCM native outputs) from the analysis with Osprey, LCModel,
# and Tarquin are loaded into different data containers. They are loaded for each vendor and
# LC modelling (LCM) algorithm creating 9 dataframes (dfGEOsp, dfPhOsp, dfSiOsp, dfGELCM, dfPhLCM,
# dfSiLCM, dfGETar, dfPhTar, dfSiTar).
# An additional 'stat.csv' is loaded and added to the dataframe for each vendor. This file can include
# any further measures to be corrrelated with the metabolite estimates, here we use 'age (years)'.
# It also includes the grouping variables 'group name' with the group names and a numerical group
# variable 'group'. These are used to group the data in the plots and you have to use these names to group
# your own data.
# Next the dataframes are combined into different frames either as vendor-collapsed dataframes (dfGE, dfPh, dfSi)
# with the LCM algorithm as group, or as LCM-collapsed dataframes (dfOsp, dfLCM, dfTar) with the vendor as group,
# or as complete dataset (dfData).

# spvs_importResults() is used to import the resutls from the LCM analysis.

# Load Osprey results from the 'off_tCr.csv' output from Osprey. Here the path points to a single file
# for each vendor
dfGEOsp <- spvs_importResults(paste(SpecVisPath , 'examples/data/GE/off_tCr.csv', sep = '/'))
dfPhOsp <- spvs_importResults(paste(SpecVisPath , 'examples/data/Philips/off_tCr.csv', sep = '/'))
dfSiOsp <- spvs_importResults(paste(SpecVisPath , 'examples/data/Siemens/off_tCr.csv', sep = '/'))

# Load LCModel results from .coord-files using a 'spant' function. Here the path points to the folder containing all
# .coord-files which are consecutivley loaded. It includes the quantification results, CRLBs, and quality
# control output. The first entry is picked as it contains the metabolite estimates.
dataGELCM <- spvs_importResults(paste(SpecVisPath , 'examples/data/GE/LCModelOutput', sep = '/'))
dfGELCM <- dataGELCM[[1]]
dataPhLCM <- spvs_importResults(paste(SpecVisPath , 'examples/data/Philips/LCModelOutput', sep = '/'))
dfPhLCM <- dataPhLCM[[1]]
dataSiLCM <- spvs_importResults(paste(SpecVisPath , 'examples/data/Siemens/LCModelOutput', sep = '/'))
dfSiLCM <- dataSiLCM[[1]]

# Load Tarquin results from .csv-files using a 'spant' function. Here the path points to the folder containing all
# .csv-files which are consecutivley loaded. It includes the quantification results, CRLBs, and quality
# control output. The first entry is picked as it contains the metabolite estimates.
dataGETar <- spvs_importResults(paste(SpecVisPath , 'examples/data/GE/TarquinOutput', sep = '/'))
dfGETar <- dataGETar[[1]]
dataPhTar <- spvs_importResults(paste(SpecVisPath , 'examples/data/Philips/TarquinOutput', sep = '/'))
dfPhTar <- dataPhTar[[1]]
dataSiTar <- spvs_importResults(paste(SpecVisPath , 'examples/data/Siemens/TarquinOutput', sep = '/'))
dfSiTar <- dataSiTar[[1]]

# Now we load and add the 'stat.csv' files to each dataframe.
# Add stats to GE dataframes.
dfGEOsp <- spvs_AddStatsToDataframe(dfGEOsp,paste(SpecVisPath , 'examples/data/GE/stat.csv', sep = '/'))
dfGELCM <- spvs_AddStatsToDataframe(dfGELCM,paste(SpecVisPath , 'examples/data/GE/stat.csv', sep = '/'))
dfGETar <- spvs_AddStatsToDataframe(dfGETar,paste(SpecVisPath , 'examples/data/GE/stat.csv', sep = '/'))
# Add stats to Philips dataframes.
dfPhOsp <- spvs_AddStatsToDataframe(dfPhOsp,paste(SpecVisPath , 'examples/data/Philips/stat.csv', sep = '/'))
dfPhLCM <- spvs_AddStatsToDataframe(dfPhLCM,paste(SpecVisPath , 'examples/data/Philips/stat.csv', sep = '/'))
dfPhTar <- spvs_AddStatsToDataframe(dfPhTar,paste(SpecVisPath , 'examples/data/Philips/stat.csv', sep = '/'))
# Add stats to Siemens dataframes.
dfSiOsp <- spvs_AddStatsToDataframe(dfSiOsp,paste(SpecVisPath , 'examples/data/Siemens/stat.csv', sep = '/'))
dfSiLCM <- spvs_AddStatsToDataframe(dfSiLCM,paste(SpecVisPath , 'examples/data/Siemens/stat.csv', sep = '/'))
dfSiTar <- spvs_AddStatsToDataframe(dfSiTar,paste(SpecVisPath , 'examples/data/Siemens/stat.csv', sep = '/'))

# Concatenate all vendor dataframes into vendor-collapsed dataframes using a list of dataframes and an array
# of the corresponding group names.
dfGE <- spvs_ConcatenateDataFrame(list(dfGELCM,dfGEOsp,dfGETar),c('LCModel','Osprey','Tarquin'))
dfPh <- spvs_ConcatenateDataFrame(list(dfPhLCM,dfPhOsp,dfPhTar),c('LCModel','Osprey','Tarquin'))
dfSi <- spvs_ConcatenateDataFrame(list(dfSiLCM,dfSiOsp,dfSiTar),c('LCModel','Osprey','Tarquin'))

# Concatenate all LCM dataframes into LCM-collapsed dataframes using a list of dataframes and an array
# of the corresponding group names.
dfOsp <- spvs_ConcatenateDataFrame(list(dfGEOsp,dfPhOsp,dfSiOsp),c('GE','Philips','Siemens'))
dfLCM <- spvs_ConcatenateDataFrame(list(dfGELCM,dfPhLCM,dfSiLCM),c('GE','Philips','Siemens'))
dfTar <- spvs_ConcatenateDataFrame(list(dfGETar,dfPhTar,dfSiTar),c('GE','Philips','Siemens'))

#Concatenate the vendor-collapsed dataframes into a global daatframe.
dfData <- dplyr::bind_rows(dfGE,dfPh,dfSi)


# 3 - Raincloud plots -----------------------------------------------------

# spvs_RainCloud() function is used to generate Raincloud plots.

# Now we are going to create the first plot, which will be a raincloud plot. This plot inlcudes
# individual datapoints, boxplots, distributions, and mean +- SD representations of the dataframe.
# The first variable indicates the dataframe to plot, the second variable is added to the axis lables,
# the third variable indicates the list of variables to be plotted (you can plot all variables form the dataframe),
# the fourth variable indicates the name of the Grouping variable, the fifth and sixth variables are the upper
# and lower limits of the plot (optional). The next variable indicates the title, and the last variable the
# number of columns. Some variables are optional.

# Create a collapsed overview for tNAA, tCho, Ins, and Glx of the whole dataset
pR1 <- spvs_RainCloud(dfData, '/ [tCr]',list('tNAA','tCho','Ins','Glx'))
pR1
ggsave(file=paste(SpecVisPath ,'examples/RaincloudCollapsed.pdf',sep='/'),
       pR1, width = 10, height = 10,device=cairo_pdf) #saves g

# Add groups to the plot
pR2 <- spvs_RainCloud(dfData, '/ [tCr]',list('tNAA','tCho','Ins','Glx'),c('Group'))
pR2
ggsave(file=paste(SpecVisPath ,'examples/RaincloudByLCM.pdf',sep='/'),
       pR2, width = 10, height = 10,device=cairo_pdf) #saves g


# Add reproducible upper and lower limits to the plot
lowerLimit <- c(0.75,.05,0.4,0.75)
upperLimit <- c(2.1,0.33,1.22,2.75)
pR3 <- spvs_RainCloud(dfData, '/ [tCr]',list('tNAA','tCho','Ins','Glx'),c('Group'),lowerLimit,upperLimit)
pR3
ggsave(file=paste(SpecVisPath ,'examples/RaincloudByLCMwithLimits.pdf',sep='/'),
       pR3, width = 10, height = 10,device=cairo_pdf) #saves g

#Add a specific title and change the number of columns
pR4 <- spvs_RainCloud(dfData, '/ [tCr]',list('tNAA','tCho','Ins','Glx'),c('Group'),lowerLimit,upperLimit,c('Distribution Analysis'),4)
pR4
ggsave(file=paste(SpecVisPath ,'examples/RaincloudByLCMwithLimits4colums.pdf',sep='/'),
       pR4, width = 20, height = 5,device=cairo_pdf) #saves g


# 4 - Normal correlation plots --------------------------------------------

# spvs_Correaltion() function is used to generate correlation plots.

# Now we are going to create a number of correaltion plots. The correlation plot can visualize global,
# correaltions and within group correaltions. Further, different sub-groups can be specified within a
# groups, in our case we have the vendor as groups and the half split of each site is going to be the
# sub-group. The first variable is a list of dataframes, each dataframe corresponds to one group. The
# second variable is again added to the axis lables. The third variable is the list of measures to be
# correlated (e.g. the sub-plots of metabolites). The fourth variable indicates the which measure to be
# plotted as x- and y-axis (e.g. Osprey and LCModel). The fifth varaible indicates the group, which
# corresponds to each dataframe named in the list (e.g. GE, Philips, Siemens). The sixth variable indicates
# if a sub-grouping (e.g. per site) should be added. The reamianing variables are lower and upper limit,
# number of columns and title.

lowerLimit <- c(0.75,.05,0.4,0.75)
upperLimit <- c(2.1,0.33,1.22,2.75)
#Let us create vendor-collapsed correlation plots  between Osprey-LCModel, Osprey-Tarquin, and LCModel-Tarquin
p <- spvs_Correlation(list(dfOsp,dfLCM)," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Osprey','LCModel'),
                      c('',''),NULL,lowerLimit,upperLimit, 4)
p2 <- spvs_Correlation(list(dfOsp,dfTar)," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('Osprey','Tarquin'),
                       c('',''),NULL,lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfLCM,dfTar)," / [tCr]",c("tNAA","tCho","Ins","Glx"),c('LCModel','Tarquin'),
                       c('',''),NULL,lowerLimit,upperLimit, 4,c(''))
pC1 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file=paste(SpecVisPath ,'examples/CorrelationCollapsed.pdf',sep='/'),
       pC1, width = 10, height = 10,device=cairo_pdf) #saves g

# Now we want to distinguish the vendors. Therefore, we add a list of dataframes.
# Here the number of dataframes matches the number of names to indicate x- and y axis
# and the number of names indicating the groups.
p <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c("tNAA","tCho","Ins","Glx"),
                      c('Osprey','Osprey','Osprey','LCModel','LCModel','LCModel'),
                      c('GE','Philips','Siemens','GE','Philips','Siemens'),NULL,lowerLimit,upperLimit, 4)
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGETar,dfPhTar,dfSiTar)," / [tCr]",c("tNAA","tCho","Ins","Glx"),
                       c('Osprey','Osprey','Osprey','Tarquin','Tarquin','Tarquin'),
                       c('GE','Philips','Siemens','GE','Philips','Siemens'),NULL,lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c("tNAA","tCho","Ins","Glx"),
                       c('Tarquin','Tarquin','Tarquin','LCModel','LCModel','LCModel'),
                       c('GE','Philips','Siemens','GE','Philips','Siemens'),NULL,lowerLimit,upperLimit, 4,c(''))
pC2 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file=paste(SpecVisPath ,'examples/CorrelationByVendor.pdf',sep='/'),
       pC2, width = 10, height = 10,device=cairo_pdf) #saves g

# Now we want to distinguish the sub-groups of each vendor. Again the number of sub group names
# matches the length of dataframes.
p <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c("tNAA","tCho","Ins","Glx"),
                      c('Osprey','Osprey','Osprey','LCModel','LCModel','LCModel'),
                      c('GE','Philips','Siemens','GE','Philips','Siemens'),
                      c('group name','group name','group name','group name','group name','group name'),lowerLimit,upperLimit, 4)
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGETar,dfPhTar,dfSiTar)," / [tCr]",c("tNAA","tCho","Ins","Glx"),
                       c('Osprey','Osprey','Osprey','Tarquin','Tarquin','Tarquin'),
                       c('GE','Philips','Siemens','GE','Philips','Siemens'),
                       c('group name','group name','group name','group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",c("tNAA","tCho","Ins","Glx"),
                       c('Tarquin','Tarquin','Tarquin','LCModel','LCModel','LCModel'),
                       c('GE','Philips','Siemens','GE','Philips','Siemens'),
                       c('group name','group name','group name','group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
pC3 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file=paste(SpecVisPath ,'examples/CorrelationByVendorWithSubgroups.pdf',sep='/'),
       pC3, width = 10, height = 10,device=cairo_pdf) #saves g



lowerLimit <- c(20,.75,20,.05,20,.4,20,.75)
upperLimit <- c(30,2.1,30,.33,30,1.22,30,2.75)

# We can also correlate measures within one dataframe e.g. metabolite estimates with age.
# Here the numbers between the dataframes, groups and sub-groups has to match. The correaltions
# are idnicated as pairs 'age years' 'tNAA' with each pair creating one sub plot. The number of
# pairs and names for the x- and y-axis has to match. In the current implementation x- and y-axis
# labels may have to be changes manually in other softwares.
p <- spvs_Correlation(list(dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",
                      c('age (years)','tNAA','age (years)','tCho','age (years)','Ins','age (years)','Glx'),
                      c('age (years)','tNAA','age (years)','tCho','age (years)','Ins','age (years)','Glx'),
                      c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp)," / [tCr]",
                       c('age (years)','tNAA','age (years)','tCho','age (years)','Ins','age (years)','Glx'),
                       c('age (years)','tNAA','age (years)','tCho','age (years)','Ins','age (years)','Glx'),
                       c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar)," / [tCr]",
                       c('age (years)','tNAA','age (years)','tCho','age (years)','Ins','age (years)','Glx'),
                       c('age (years)','tNAA','age (years)','tCho','age (years)','Ins','age (years)','Glx'),
                       c('GE','Philips','Siemens'),c('group name','group name','group name'),lowerLimit,upperLimit, 4,c(''))
pC4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file=paste(SpecVisPath ,'examples/CorrelationAge.pdf',sep='/'), pC4, width = 10, height = 10,device=cairo_pdf) #saves g


# 5 - Facet correlation plots --------------------------------------------
# We can also create a facetted correaltion plot, which addtionally shows correaltions for the sub-groups
# and gives an easier overview by facetting the plot.

lowerLimit <- c(0.75,.05,0.4,0.75)
upperLimit <- c(2.1,0.33,1.22,2.75)
p <- spvs_Correlation_Facet(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",
                            c("tNAA","tCho","Ins","Glx"),c('Osprey','Osprey','Osprey','LCModel','LCModel','LCModel'),
                            c('GE','Philips','Siemens','GE','Philips','Siemens'),
                            c('group name','group name','group name','group name','group name','group name'),
                            lowerLimit,upperLimit, 4)
p2 <- spvs_Correlation_Facet(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGETar,dfPhTar,dfSiTar)," / [tCr]",
                             c("tNAA","tCho","Ins","Glx"),c('Osprey','Osprey','Osprey','Tarquin','Tarquin','Tarquin'),
                             c('GE','Philips','Siemens','GE','Philips','Siemens'),
                             c('group name','group name','group name','group name','group name','group name'),
                             lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation_Facet(list(dfGETar,dfPhTar,dfSiTar,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",
                             c("tNAA","tCho","Ins","Glx"),c('Tarquin','Tarquin','Tarquin','LCModel','LCModel','LCModel'),
                             c('GE','Philips','Siemens','GE','Philips','Siemens'),
                             c('group name','group name','group name','group name','group name','group name'),
                             lowerLimit,upperLimit, 4,c(''))
pC5 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file=paste(SpecVisPath ,'examples/CorrelationFacet.pdf',sep='/'), pC5, width = 30, height = 10,device=cairo_pdf) #saves g

# 6 - Statistics --------------------------------------------
# Now we run a statistics script, which calculates proper statisitcs. In the current implementation paired
# tests are conducted.

stats <- spvs_Statistics(dfData,list('tNAA','tCho','Ins','Glx'))
sink(paste(SpecVisPath ,'examples/Statistics.txt',sep='/'))
print(stats)
sink()
