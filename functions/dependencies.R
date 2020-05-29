# dependencies.R
# This function installs and initializes all the needed packages. It also makes sure they are loaded in the right order.
#
#
#   USAGE:
#     dependencies.R
#
#   AUTHOR:
#     Dr. Helge Zöllner (Johns Hopkins University, 2020-03-28)
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
packages <- c("ggplot2", "dplyr", "lavaan", "plyr", "cowplot", "rmarkdown","patchwork",'RColorBrewer', 'moments', 'ggnewscale',
              "readr", "caTools", "bitops","gridExtra","svglite","spant","see","tidyr","ggpmisc",'lawstat', 'onewaytests')

if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
  install.packages('spant', dependecies = TRUE)
}



library(spant)
library(dplyr,warn.conflicts = FALSE)
library(tidyr)
library(RColorBrewer)
library(ggplot2)
library(ggpmisc)
library(cowplot)
library(ggnewscale)
library(gridExtra)
library(grid)

library(readr)
library(lattice)
library(svglite)
library(see)
library(patchwork)
library(lawstat)
library(onewaytests)
library(moments)
