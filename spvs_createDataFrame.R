spvs_createDataFrame <- function(ListFile)
{
  df <- data.frame(matrix(unlist(ListFile), ncol=length(ListFile), nrow=length(unlist(ListFile))/length(ListFile),byrow = FALSE))
  names(df) <- names(ListFile)
  return(df)
}
