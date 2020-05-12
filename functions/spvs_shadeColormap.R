spvs_shadeColormap <- function(colormap, GroupNum, shades,r){
  # spvs_shadeColormap <- function(colormap, GroupNum, shades,r)
  # Creates a shaded colormap for the hue of a correaltion plot. 
  #
  #   USAGE:
  #     colorMap <- spvs_shadeColormap(colormap, GroupNum, shades,r)
  #
  #   INPUTS:
  #     colormap = list of data frames with metabolite estiamtes (e.g. c(dfOspreyGE,dfOspreySiemens,dfLCModelGE,dfLCModelSiemens))
  #     GroupNum = number of groups
  #     shades = number of shades.
  #     r = flag if shades with two directions should be created (e.g. r values from -1 (white) to 1 (black)) .
  #
  #
  #   OUTPUTS:
  #     colorMap     = color map with different shapes
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
  color <- brewer.pal(GroupNum, colormap)
  resultColorMap <- NULL
  if (r==0){
    for (groups in 1:GroupNum) {
      tempColor <- c("#FFFFFF", color[[groups]])
      pal <- colorRampPalette(tempColor)
      resultColorMap <- c(resultColorMap,pal(shades[[groups]]))
    }}
  else{
        for (groups in 1:GroupNum) {
          tempColor <- c("#FFFFFF", color[[groups]], "#000000")
          pal <- colorRampPalette(tempColor)
          resultColorMap <- c(resultColorMap,pal(201))
        }    
      }
  return(resultColorMap)
}  