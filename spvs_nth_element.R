spvs_nth_element <- function(vector, starting_position, n) {
  # spvs_nth_element <- function(vector, starting_position, n)
  # This function picks the nth element from a vector starting at the element at thestarting postion
  #
  #
  #   USAGE:
  #     vec <- spvs_nth_element(vector, starting_position, n)
  #
  #   INPUTS:
  #     vector = vector to pcik the elements from
  #     starting_position = element to start with
  #     n = step size
  #             
  #   OUTPUTS:
  #     vec     = vector with picked elements
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
  vector[seq(starting_position, length(vector), n)] 
}