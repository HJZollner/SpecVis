# Example script for SpecVis
## Description
 This script describes how to use several functions of the Spectra Visualizer R-package.
 It uses short-TE PRESS data from the https://www.nitrc.org/projects/biggaba/. Details are described in 
 'Comparison of Multivendor Single-Voxel MR Spectroscopy Data Acquired in Healthy Brain at 26 Sites' 
 Považan et al. (2020). The analysis includes three sites (G1, P3, S5) which are each split into two 
 abritrary halfs and analyzed with Osprey (https://www.biorxiv.org/content/10.1101/2020.02.12.944207v1), LCModel (https://doi.org/10.1002/mrm.1910300604), and Tarquin (https://doi.org/10.1002/mrm.22579) to demonstrate the capabilities
 of the functions. It can be found in the [examples](https://github.com/hezoe100/SpecVis/tree/master/examples) to be run manually in R.
 
AUTHOR:
  Dr. Helge Zöllner (Johns Hopkins University, 2020-04-15)
MAIL:  
  hzoelln2@jhmi.edu

CREDITS:    
This code is based on numerous functions from the spant toolbox by
Dr. Martin Wilson (University of Birmingham)
https://martin3141.github.io/spant/index.html

## 1 - Source functions and set up path
```r
source('dependencies.R')
source('spvs_importResults.R')
source('spvs_Correlation.R')
source('spvs_Correlation_Facet.R')
source('spvs_AddStatsToDataframe.R')
source('spvs_ConcatenateDataFrame.R')
source('spvs_RainCloud.R')
source('spvs_Statistics.R')
SpecVisPath <- '~/Documents/R/SpecVis'
```
## 2 - Load data and create dataframes
In the next part the results (from LCM native outputs) from the analysis with Osprey, LCModel, 
and Tarquin are loaded into different data containers. They are loaded for each vendor and 
LC modelling (LCM) algorithm creating 9 dataframes (dfGEOsp, dfPhOsp, dfSiOsp, dfGELCM, dfPhLCM, 
dfSiLCM, dfGETar, dfPhTar, dfSiTar). 
An additional 'stat.csv' is loaded and added to the dataframe for each vendor. This file can include
any further measures to be corrrelated with the metabolite estimates, here we use 'age (years)'. 
It also includes the grouping variables 'group name' with the group names and a numerical group 
variable 'group'. These are used to group the data in the plots and you have to use these names to group
your own data.
Next the dataframes are combined into different frames either as vendor-collapsed dataframes (dfGE, dfPh, dfSi) 
with the LCM algorithm as group, or as LCM-collapsed dataframes (dfOsp, dfLCM, dfTar) with the vendor as group, 
or as complete dataset (dfData).

`spvs_importResults()` is used to import the resutls from the LCM analysis.

Load Osprey results from the 'off_tCr.csv' output from Osprey. Here the path points to a single file for each vendor.
```r
dfGEOsp <- spvs_importResults(paste(SpecVisPath , 'examples/data/GE/off_tCr.csv', sep = '/'))
dfPhOsp <- spvs_importResults(paste(SpecVisPath , 'examples/data/Philips/off_tCr.csv', sep = '/'))
dfSiOsp <- spvs_importResults(paste(SpecVisPath , 'examples/data/Siemens/off_tCr.csv', sep = '/'))
```

Load LCModel results from .coord-files using a 'spant' function. Here the path points to the folder containing all .coord-files which are consecutivley loaded. It includes the quantification results, CRLBs, and quality control output. The first entry is picked as it contains the metabolite estimates.
```r
dataGELCM <- spvs_importResults(paste(SpecVisPath , 'examples/data/GE/LCModelOutput', sep = '/'))
dfGELCM <- dataGELCM[[1]]
dataPhLCM <- spvs_importResults(paste(SpecVisPath , 'examples/data/Philips/LCModelOutput', sep = '/'))
dfPhLCM <- dataPhLCM[[1]]
dataSiLCM <- spvs_importResults(paste(SpecVisPath , 'examples/data/Siemens/LCModelOutput', sep = '/'))
dfSiLCM <- dataSiLCM[[1]]
```

Load Tarquin results from .csv-files using a 'spant' function. Here the path points to the folder containing all .csv-files which are consecutivley loaded. It includes the quantification results, CRLBs, and quality control output. The first entry is picked as it contains the metabolite estimates.
```r
dataGETar <- spvs_importResults(paste(SpecVisPath , 'examples/data/GE/TarquinOutput', sep = '/'))
dfGETar <- dataGETar[[1]]
dataPhTar <- spvs_importResults(paste(SpecVisPath , 'examples/data/Philips/TarquinOutput', sep = '/'))
dfPhTar <- dataPhTar[[1]]
dataSiTar <- spvs_importResults(paste(SpecVisPath , 'examples/data/Siemens/TarquinOutput', sep = '/'))
dfSiTar <- dataSiTar[[1]]
```

Now we load and add the 'stat.csv' files to each dataframe.
```r
# Add stats to GE dataframes.
dfGEOsp <- spvs_AddStatsToDataframe(dfGEOsp,paste(SpecVisPath,'examples/data/GE/stat.csv', sep = '/'))
dfGELCM <- spvs_AddStatsToDataframe(dfGELCM,paste(SpecVisPath,'examples/data/GE/stat.csv', sep = '/'))
dfGETar <- spvs_AddStatsToDataframe(dfGETar,paste(SpecVisPath,'examples/data/GE/stat.csv', sep = '/'))
# Add stats to Philips dataframes.
dfPhOsp <- spvs_AddStatsToDataframe(dfPhOsp,paste(SpecVisPath,'examples/data/Philips/stat.csv',sep ='/'))
dfPhLCM <- spvs_AddStatsToDataframe(dfPhLCM,paste(SpecVisPath,'examples/data/Philips/stat.csv',sep='/'))
dfPhTar <- spvs_AddStatsToDataframe(dfPhTar,paste(SpecVisPath,'examples/data/Philips/stat.csv',sep='/'))
# Add stats to Siemens dataframes.
dfSiOsp <- spvs_AddStatsToDataframe(dfSiOsp,paste(SpecVisPath,'examples/data/Siemens/stat.csv',sep ='/'))
dfSiLCM <- spvs_AddStatsToDataframe(dfSiLCM,paste(SpecVisPath,'examples/data/Siemens/stat.csv',sep='/'))
dfSiTar <- spvs_AddStatsToDataframe(dfSiTar,paste(SpecVisPath,'examples/data/Siemens/stat.csv',sep='/'))
```
Concatenate all vendor dataframes into vendor-collapsed dataframes using a list of dataframes and an array of the corresponding group names.
```r
dfGE <- spvs_ConcatenateDataFrame(list(dfGELCM,dfGEOsp,dfGETar),c('LCModel','Osprey','Tarquin'))
dfPh <- spvs_ConcatenateDataFrame(list(dfPhLCM,dfPhOsp,dfPhTar),c('LCModel','Osprey','Tarquin'))
dfSi <- spvs_ConcatenateDataFrame(list(dfSiLCM,dfSiOsp,dfSiTar),c('LCModel','Osprey','Tarquin'))
```

Concatenate all LCM dataframes into LCM-collapsed dataframes using a list of dataframes and an array of the corresponding group names.
```r
dfOsp <- spvs_ConcatenateDataFrame(list(dfGEOsp,dfPhOsp,dfSiOsp),c('GE','Philips','Siemens'))
dfLCM <- spvs_ConcatenateDataFrame(list(dfGELCM,dfPhLCM,dfSiLCM),c('GE','Philips','Siemens'))
dfTar <- spvs_ConcatenateDataFrame(list(dfGETar,dfPhTar,dfSiTar),c('GE','Philips','Siemens'))
```

Concatenate the vendor-collapsed dataframes into a global dataframe.
```r
dfData <- dplyr::bind_rows(dfGE,dfPh,dfSi)
```
## 3 - Raincloud plots (https://wellcomeopenresearch.org/articles/4-63)

`spvs_RainCloud()` function is used to generate Raincloud plots (https://wellcomeopenresearch.org/articles/4-63).

Now we are going to create the first plot, which will be a raincloud plot. This plot inlcudes individual datapoints, boxplots, distributions, and mean +- SD representations of the dataframe. The first variable indicates the dataframe to plot, the second variable is added to the axis lables, the third variable indicates the list of variables to be plotted (you can plot all variables form the dataframe), the fourth variable indicates the name of the Grouping variable, the fifth and sixth variables are the upper and lower limits of the plot (optional). The next variable indicates the title, and the last variable the number of columns. Some variables are optional.

Create a collapsed overview for tNAA, tCho, Ins, and Glx of the whole dataset.
```r
pR1 <- spvs_RainCloud(dfData, '/ [tCr]',list('tNAA','tCho','Ins','Glx'))
ggsave(file=paste(SpecVisPath ,'examples/RaincloudCollapsed.pdf',sep='/'), 
       pR1, width = 10, height = 10,device=cairo_pdf) #saves g
pR1 
```
![pR1](/examples/RaincloudCollapsed.png)

Add groups to the plot.
```r
pR2 <- spvs_RainCloud(dfData, '/ [tCr]',list('tNAA','tCho','Ins','Glx'),c('Group'))
ggsave(file=paste(SpecVisPath ,'examples/RaincloudByLCM.pdf',sep='/'),
       pR2, width = 10, height = 10,device=cairo_pdf) #saves g
pR2
```
![pR2](/examples/RaincloudByLCM.png)

Add reproducible upper and lower limits to the plot.
```r
lowerLimit <- c(0.75,.05,0.4,0.75)
upperLimit <- c(2.1,0.33,1.22,2.75)
pR3 <- spvs_RainCloud(dfData, '/ [tCr]',list('tNAA','tCho','Ins','Glx'),c('Group'),
                      lowerLimit,upperLimit)
ggsave(file=paste(SpecVisPath ,'examples/RaincloudByLCMwithLimits.pdf',sep='/'),
       pR3, width = 10, height = 10,device=cairo_pdf) #saves g
pR3
```
![pR3](/examples/RaincloudByLCMwithLimits.png)

Add a specific title and change the number of columns
```r
pR4 <- spvs_RainCloud(dfData, '/ [tCr]',list('tNAA','tCho','Ins','Glx'),c('Group'),
                      lowerLimit,upperLimit,c('Distribution Analysis'),4)
ggsave(file=paste(SpecVisPath ,'examples/RaincloudByLCMwithLimits4colums.pdf',sep='/'),
       pR4, width = 20, height = 5,device=cairo_pdf) #saves g
pR4  
```
![pR4](/examples/RaincloudByLCMwithLimits4colums.png)

## 4 - Normal correlation plots

`spvs_Correlation()` function is used to generate correlation plots.

Now we are going to create a number of correlation plots. The correlation plot can visualize global, correlations and within group correlations. Further, different sub-groups can be specified within a groups, in our case we have the vendor as groups and the half split of each site is going to be the sub-group. The first variable is a list of dataframes, each dataframe corresponds to one group. The second variable is again added to the axis lables. The third variable is the list of measures to be correlated (e.g. the sub-plots of metabolites). The fourth variable indicates the which measure to be plotted as x- and y-axis (e.g. Osprey and LCModel). The fifth varaible indicates the group, which corresponds to each dataframe named in the list (e.g. GE, Philips, Siemens). The sixth variable indicates if a sub-grouping (e.g. per site) should be added. The remaining variables are lower and upper limit, number of columns and title.
```r
lowerLimit <- c(0.75,.05,0.4,0.75)
upperLimit <- c(2.1,0.33,1.22,2.75)
# Let us create vendor-collapsed correlation plots  between Osprey-LCModel,
# Osprey-Tarquin, and LCModel-Tarquin
p <- spvs_Correlation(list(dfOsp,dfLCM)," / [tCr]",c("tNAA","tCho","Ins","Glx"),
                      c('Osprey','LCModel'),c('',''),NULL,lowerLimit,upperLimit, 4)
p2 <- spvs_Correlation(list(dfOsp,dfTar)," / [tCr]",c("tNAA","tCho","Ins","Glx"),
                       c('Osprey','Tarquin'), c('',''),NULL,lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfLCM,dfTar)," / [tCr]",c("tNAA","tCho","Ins","Glx"),
                       c('LCModel','Tarquin'), c('',''),NULL,lowerLimit,upperLimit, 4,c(''))
pC1 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file=paste(SpecVisPath ,'examples/CorrelationCollapsed.pdf',sep='/'),
       pC1, width = 10, height = 10,device=cairo_pdf) #saves g
pC1       
```
![pC1](/examples/CorrelationCollapsed.png)

Now we want to distinguish the vendors. Therefore, we add a list of dataframes. Here the number of dataframes matches the number of names to indicate x- and y axis and the number of names indicating the groups.
```r
p <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",
                      c("tNAA","tCho","Ins","Glx"),
                      c('Osprey','Osprey','Osprey','LCModel','LCModel','LCModel'),
                      c('GE','Philips','Siemens','GE','Philips','Siemens'),NULL,
                      lowerLimit,upperLimit, 4)
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGETar,dfPhTar,dfSiTar)," / [tCr]",
                       c("tNAA","tCho","Ins","Glx"),
                       c('Osprey','Osprey','Osprey','Tarquin','Tarquin','Tarquin'),
                       c('GE','Philips','Siemens','GE','Philips','Siemens'),
                       NULL,lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",
                       c("tNAA","tCho","Ins","Glx"),
                       c('Tarquin','Tarquin','Tarquin','LCModel','LCModel','LCModel'),
                       c('GE','Philips','Siemens','GE','Philips','Siemens'),
                       NULL,lowerLimit,upperLimit, 4,c(''))
pC2 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file=paste(SpecVisPath ,'examples/CorrelationByVendor.pdf',sep='/'),
       pC2, width = 10, height = 10,device=cairo_pdf) #saves g
pC2
```
![pC2](/examples/CorrelationByVendor.png)

Now we want to distinguish the sub-groups of each vendor. Again the number of sub group names matches the length of dataframes.
```r
p <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",
                      c("tNAA","tCho","Ins","Glx"),
                      c('Osprey','Osprey','Osprey','LCModel','LCModel','LCModel'),
                      c('GE','Philips','Siemens','GE','Philips','Siemens'),
                      c('group name','group name','group name','group name','group name','group name'),
                      lowerLimit,upperLimit, 4)
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp,dfGETar,dfPhTar,dfSiTar)," / [tCr]",
                       c("tNAA","tCho","Ins","Glx"),
                       c('Osprey','Osprey','Osprey','Tarquin','Tarquin','Tarquin'),
                       c('GE','Philips','Siemens','GE','Philips','Siemens'),
                       c('group name','group name','group name','group name','group name','group name'),
                       lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar,dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",
                       c("tNAA","tCho","Ins","Glx"),
                       c('Tarquin','Tarquin','Tarquin','LCModel','LCModel','LCModel'),
                       c('GE','Philips','Siemens','GE','Philips','Siemens'),
                       c('group name','group name','group name','group name','group name','group name'),
                       lowerLimit,upperLimit, 4,c(''))
pC3 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file=paste(SpecVisPath ,'examples/CorrelationByVendorWithSubgroups.pdf',sep='/'),
       pC3, width = 10, height = 10,device=cairo_pdf) #saves g
pC3
```
![pC3](/examples/CorrelationByVendorWithSubgroups.png)

We can also correlate measures within one dataframe e.g. metabolite estimates with age. Here the numbers between the dataframes, groups and sub-groups has to match. The correlations are idnicated as pairs 'age years' 'tNAA' with each pair creating one sub plot. The number of pairs and names for the x- and y-axis has to match. In the current implementation x- and y-axis labels may have to be changes manually in other softwares.

```r
lowerLimit <- c(20,.75,20,.05,20,.4,20,.75)
upperLimit <- c(30,2.1,30,.33,30,1.22,30,2.75)
p <- spvs_Correlation(list(dfGELCM,dfPhLCM,dfSiLCM)," / [tCr]",
                      c('age (years)','tNAA','age (years)','tCho','age (years)','Ins','age (years)','Glx'),
                      c('age (years)','tNAA','age (years)','tCho','age (years)','Ins','age (years)','Glx'),
                      c('GE','Philips','Siemens'),c('group name','group name','group name'),
                      lowerLimit,upperLimit, 4,c(''))
p2 <- spvs_Correlation(list(dfGEOsp,dfPhOsp,dfSiOsp)," / [tCr]",
                       c('age (years)','tNAA','age (years)','tCho','age (years)','Ins','age (years)','Glx'),
                       c('age (years)','tNAA','age (years)','tCho','age (years)','Ins','age (years)','Glx'),
                       c('GE','Philips','Siemens'),c('group name','group name','group name'),
                       lowerLimit,upperLimit, 4,c(''))
p3 <- spvs_Correlation(list(dfGETar,dfPhTar,dfSiTar)," / [tCr]",
                       c('age (years)','tNAA','age (years)','tCho','age (years)','Ins','age (years)','Glx'),
                       c('age (years)','tNAA','age (years)','tCho','age (years)','Ins','age (years)','Glx'),
                       c('GE','Philips','Siemens'),c('group name','group name','group name'),
                       lowerLimit,upperLimit, 4,c(''))
pC4 <- grid.arrange(p, p2, p3, ncol=1, nrow =3)
g <- arrangeGrob(p, p2, p3, ncol=1) #generates g
ggsave(file=paste(SpecVisPath ,'examples/CorrelationAge.pdf',sep='/'), 
       pC4, width = 10, height = 10,device=cairo_pdf) #saves g
pC4
```
![pC4](/examples/CorrelationAge.png)

## 5 - Facet correlation plots
We can also create a facetted correlation plot, which addtionally shows correlations for the sub-groups and gives an easier overview by facetting the plot.
```r
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
ggsave(file=paste(SpecVisPath ,'examples/CorrelationFacet.pdf',sep='/'),
        pC5, width = 30, height = 10,device=cairo_pdf) #saves g
pC5        
```
![pC5](/examples/CorrelationFacet.png)

Let us zoom in on the tNAA facets.
![pC5z](/examples/CorrelationFacetSmall.png)

# 6 - Statistics
Now we run a statistics script, which calculates proper statisitcs. In the current implementation paired tests are conducted.
```r
stats <- spvs_Statistics(dfData,list('tNAA','tCho','Ins','Glx'))
sink(paste(SpecVisPath ,'examples/Statistics.txt',sep='/'))
print(stats)
sink()
stats

$`Descriptive Statistics`
          Group  N      mean    median         sd        skew          se         CV
1  tNAA LCModel 35 1.4788926 1.4915889 0.17275995  0.87434668 0.029201761 0.11681710
2   tNAA Osprey 35 1.5475494 1.5465182 0.14647368  0.96876399 0.024758571 0.09464879
3  tNAA Tarquin 35 1.4922791 1.4958005 0.16847081  0.51755138 0.028476764 0.11289497
4  tCho LCModel 35 0.1803956 0.1785564 0.02001130  0.45413725 0.003382527 0.11093006
5   tCho Osprey 35 0.1843655 0.1804427 0.01804520  0.47870891 0.003050196 0.09787736
6  tCho Tarquin 35 0.1913266 0.1923406 0.03549241  0.03489895 0.005999313 0.18550698
7   Ins LCModel 35 0.8352432 0.8271063 0.08042637  0.35144506 0.013594538 0.09629097
8    Ins Osprey 35 0.8700612 0.8826057 0.10519155 -0.22411160 0.017780617 0.12090132
9   Ins Tarquin 35 0.6104961 0.5966697 0.08161796  0.49355980 0.013795954 0.13369120
10  Glx LCModel 35 1.6307792 1.6263345 0.21268794  0.26151544 0.035950824 0.13042105
11   Glx Osprey 35 1.4133724 1.3679951 0.18594697  0.65180311 0.031430774 0.13156261
12  Glx Tarquin 35 2.0113409 2.0542739 0.25815497 -0.29299931 0.043636154 0.12834968

$`Test for Normal Distribution`
   VarsName      method      stat          p normal
1      tNAA ShapiroWilk 0.9766313 0.11829663      1
2      tNAA ShapiroWilk 0.9766313 0.02259208      0
3      tNAA ShapiroWilk 0.9766313 0.27226749      1
4      tCho ShapiroWilk 0.9766313 0.22295161      1
5      tCho ShapiroWilk 0.9766313 0.27789399      1
6      tCho ShapiroWilk 0.9766313 0.42967870      1
7       Ins ShapiroWilk 0.9766313 0.85005325      1
8       Ins ShapiroWilk 0.9766313 0.72555726      1
9       Ins ShapiroWilk 0.9766313 0.25752809      1
10      Glx ShapiroWilk 0.9766313 0.39871066      1
11      Glx ShapiroWilk 0.9766313 0.16523963      1
12      Glx ShapiroWilk 0.9766313 0.64754500      1

$`Test for Normal Distribution of Variances`
  VarsName  method       stat           p VarianceDiff
1     tNAA Fligner  0.6744646 0.713743006            0
2     tCho Fligner 10.4351600 0.005420431            1
3      Ins Fligner  2.1258578 0.345442566            0
4      Glx Fligner  3.6065148 0.164761318            0

$`Post hoc test heterogeneous variances`
              VarsName  method        adj      stat       padj sig
1  tCho LCModel Osprey Fligner Bomferroni 0.1343162 2.14199461   0
2  tCho Osprey Tarquin Fligner Bomferroni 7.8459178 0.01528068   *
3 tCho Tarquin LCModel Fligner Bomferroni 6.1670544 0.03904534   *

$`Variance Analysis`
  VarsName        method      stat            p differ
1     tNAA KruskalWallis  4.588002 1.008621e-01      0
2     tCho         Welch  1.295562 2.807561e-01      0
3      Ins         ANOVA 86.141507 1.231585e-22      1
4      Glx         ANOVA 65.678493 4.672482e-19      1

$`Posthoc test Variance Analysis`
                  method multi_comp_cor      LCModel       Osprey sig.LCModel sig.Osprey
tNAA Osprey     Wilcoxon     bonferroni 1.652545e-03           NA          **       <NA>
tNAA Tarquin pairedTtest     bonferroni 1.000000e+00 1.605886e-01           0          0
Ins Osprey   pairedTtest     bonferroni 1.879861e-01           NA           0       <NA>
Ins Tarquin     Wilcoxon     bonferroni 5.659449e-18 1.766059e-18         ***        ***
Glx Osprey   pairedTtest     bonferroni 1.355763e-08           NA         ***       <NA>
Glx Tarquin  pairedTtest     bonferroni 3.544509e-14 1.191189e-18         ***        ***


```
