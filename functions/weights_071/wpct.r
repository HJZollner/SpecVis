wpct <- function(x, weight=NULL, na.rm=TRUE){
  require(Hmisc)
  if(is.null(weight)){
    weight <- rep(1, length(x))
  }
  y <- wtd.table(x, weight, na.rm=na.rm)$sum.of.weights/sum(wtd.table(x, weight, na.rm=na.rm)$sum.of.weights)
  z <- as.vector(y)
  names(z) <- names(y)
  if(is.logical(x))
    z <- rev(z)
  z
}
