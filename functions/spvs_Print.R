spvs_Print<- function(plotOut,path,size,formatOut){
  # spvs_Print <- function(plotOut,path,size,formatOut)
  # This function prints a plot into an external plot which can be pdf, eps or tiff.
  #
  #   USAGE:
  #     p <- spvs_Print<- function(plotOut,path,size,formatOut)
  #
  #   INPUTS:
  #     plotOut = R plot
  #     path = target path and name. (default is SpecVisDir)
  #     size = list with x and y dimensions. (default 10 by 10)
  #     formatOut = output format. (default is 'cairo_pdf'). Can also be 'eps' and 'tiff'
  #
  #
  #   OUTPUTS:
  #     p     = Fancy message
  #     
  #   AUTHOR:
  #     Dr. Helge Zöllner (Johns Hopkins University, 2020-08-24)
  #     hzoelln2@jhmi.edu
  #         
  #   CREDITS:    
  #     This code is based on numerous functions from the spant toolbox by
  #     Dr. Martin Wilson (University of Birmingham)
  #     https://martin3141.github.io/spant/index.html
  #      
  #      
  #   HISTORY:
  #     2020-08-22: First version of the code.
  # 1 Falling back into defaults ----------------------------------------------------------  
  if(missing(path)){
    thisPath <- function() {
      cmdArgs <- commandArgs(trailingOnly = FALSE)
      if (length(grep("^-f$", cmdArgs)) > 0) {
        # R console option
        normalizePath(dirname(cmdArgs[grep("^-f", cmdArgs) + 1]))[1]
      } else if (length(grep("^--file=", cmdArgs)) > 0) {
        # Rscript/R console option
        scriptPath <- normalizePath(dirname(sub("^--file=", "", cmdArgs[grep("^--file=", cmdArgs)])))[1]
      } else if (Sys.getenv("RSTUDIO") == "1") {
        # RStudio
        dirname(rstudioapi::getSourceEditorContext()$path)
      } else if (is.null(attr(stub, "srcref")) == FALSE) {
        # 'source'd via R console
        dirname(normalizePath(attr(attr(stub, "srcref"), "srcfile")$filename))
      } else {
        stop("Cannot find file path")
      }
    }
    path <- thisPath()
    path <- gsub("/functions","",path[[1]])
    path <- paste(path ,'FancyPlotYouShouldHaveNamed',sep='/')
    if(missing(formatOut)){
      formatOut <- 'pdf'
    }
    path <- paste(path ,formatOut,sep='.')
  } else
  {
    path <- paste(path ,formatOut,sep='.')      
    }
    
    
  if(missing(size)){
    xdim <- 10
    ydim <- 10
  }
  else{
    xdim <- size[1]
    ydim <- size[2]
  }
  if(missing(formatOut)){
   formatOut <- 'pdf'
  }
  
  if(formatOut == 'pdf'){
    tryCatch(
      expr = {
        ggsave(file=path,plotOut, width = xdim, height = ydim,device=cairo_pdf)
      },
      error = function(e){
        ggsave(file=path,plotOut, width = xdim, height = ydim,device=png)
        message('No working cairo device found. Please install cairo on your machine to create high res plots!')
        print(e)
      }
    )
  }
  
  if(formatOut == 'eps'){
    tryCatch(
      expr = {
        ggsave(file=path, plotOut, width = xdim, height = ydim,device=cairo_ps)
      },
      error = function(e){
        ggsave(file=path, plotOut, width = xdim, height = ydim,device=png)
        message('No working eps device found. Please install eps on your machine to create high res plots!')
        print(e)
      }
    )
  }
  
  if(formatOut == 'tiff'){
    tryCatch(
      expr = {
        ggsave(file=path,plotOut, width = xdim, height = ydim,device=tiff)
      },
      error = function(e){
        ggsave(file=path,plotOut, width = xdim, height = ydim,device=png)
        message('No working tiff device found. Please install tiff on your machine to create high res plots!')
        print(e)
      }
    )
  }
  
  if(formatOut == 'png'){
    tryCatch(
      expr = {
        ggsave(file=path, plotOut, width = xdim, height = ydim,device=png)
      },
      error = function(e){
        message('Can not print anything!')
        print(e)
      }
    )
  }
}# end of function