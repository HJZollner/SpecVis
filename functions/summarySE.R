## define function to calculate summary statistics
## Summarizes data.
## Gives count, mean, standard deviation, standard error of the mean, and 
## confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
##   adapted from Ryan Hope's function: 
##   https://www.rdocumentation.org/packages/Rmisc/versions/1.5/topics/summarySE

# summarySE function
summarySE <- function(data = NULL, measurevar, groupvars = NULL, na.rm = FALSE,
                      conf.interval = .95, .drop = TRUE) {

  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function(x, na.rm = FALSE) {
    if (na.rm) {
      sum(!is.na(x))
    } else {
      length(x)
    }
  }

  # This does the summary. For each group's data frame, return a vector with
  # N, mean, median, and sd

  datac <- plyr::ddply(data, groupvars, .drop=.drop,
                   .fun = function(xx, col) {
                       c(N      = length2(xx[[col]], na.rm=na.rm),
                         mean   = mean(xx[[col]], na.rm=na.rm),
                         median = median(xx[[col]], na.rm=na.rm),
                         sd      = sd(xx[[col]], na.rm=na.rm),
                         min      = min(xx[[col]], na.rm=na.rm),
                         max      = max(xx[[col]], na.rm=na.rm),
                         skew     = skewness(xx[[col]], na.rm=na.rm)
                       )
                   },
                   measurevar
  )
  
 datac$meanMsd <- datac$mean - datac$sd  # Calculate ymin
 datac$meanPsd <- datac$mean + datac$sd  # Calculate ymax
 datac$BAMsd <- datac$mean - 1.95*datac$sd  # Calculate ymin
 datac$BAPsd <- datac$mean + 1.95*datac$sd  # Calculate ymax  
 
 datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
 datac$CV <- datac$sd / datac$mean
 
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval:
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval / 2 + .5, datac$N - 1)
  datac$ci <- datac$se * ciMult

  return(datac)
}
