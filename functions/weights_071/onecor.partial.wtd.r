onecor.partial.wtd <- function(x, y, preds=NULL, weight=NULL){
  if(sum((!is.na(x))*(!is.na(y)))>0){
    if(is.null(weight)){
      weight <- rep(1, length(x))
    }
    use <- !is.na(y) & !is.na(x)
    if(!is.null(preds))
      use <- !is.na(y) & !is.na(x) & !is.na(rowSums(preds))
    x <- x[use]
    y <- y[use]
    weight <- weight[use]
    if(!is.null(preds)){
      preds <- as.matrix(preds)[use,]
      corcoef <- coef(summary(lm(stdz(y, weight=weight)~stdz(x, weight=weight)+preds, weight=weight)))[2,]
    }
    else{
      corcoef <- coef(summary(lm(stdz(y, weight=weight)~stdz(x, weight=weight), weight=weight)))[2,]
    }
  }
  else
    corcoef <- rep(NA, 4)
  names(corcoef) <- rep("", 4)
  corcoef
}
