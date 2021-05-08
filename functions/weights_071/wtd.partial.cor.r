wtd.partial.cor <- function(x, y=NULL, preds=NULL, weight=NULL, collapse=TRUE){
  x <- as.matrix(x)
  if(is.null(weight)){
    weight <- rep(1, dim(x)[1])
  }
  if(is.null(y)){
    y <- x
  }
  y <- as.matrix(y)
  preds <- as.matrix(preds)
  materset <- lapply(as.data.frame(x), function(x) lapply(as.data.frame(y), function(y) try(onecor.partial.wtd(x, y, preds=preds, weight))))
  est <- sapply(materset, function(q) sapply(q, function(g) g[1]))
  se <- sapply(materset, function(q) sapply(q, function(g) g[2]))
  tval <- sapply(materset, function(q) sapply(q, function(g) g[3]))
  pval <- sapply(materset, function(q) sapply(q, function(g) g[4]))
  out <- list(correlation=est, std.err=se, t.value=tval, p.value=pval)
  if(is.vector(est) & collapse==TRUE || (1 %in% dim(est)) & collapse==TRUE){
    out <- matrix(unlist(out), ncol=4, byrow=FALSE)
    rownames(out) <- names(est)
    colnames(out) <- c("correlation", "std.err", "t.value", "p.value")
  }
  out
}

