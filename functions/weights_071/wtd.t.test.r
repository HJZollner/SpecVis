wtd.t.test <- function(x, y=0, weight=NULL, weighty=NULL, samedata=TRUE){
  if(is.null(weight)){
    weight <- rep(1, length(x))
  }
  if(length(y)!=length(x) & length(y)>1){
    samedata <- FALSE
    warning("Treating data for x and y separately")
    if(is.null(weighty)){
       warning("y has no weights")
     }
  }
  if(is.null(weighty) & samedata==TRUE){
    weighty <- weight
  }
  if(is.null(weighty) & samedata==FALSE){
    weighty <- rep(1, length(y))
  }
  require(Hmisc)
  n <- sum(!is.na(x))
  mx <- wtd.mean(x, weight, na.rm=TRUE)
  vx <- wtd.var(x, weight, na.rm=TRUE)
  if(length(y)==1){
    dif <- mx-y
    sx <- sqrt(vx)
    se <- sx/sqrt(n)
    t <- (mx-y)/se
    df <- n-1
    p.value <- (1-pt(abs(t), df))*2
    coef <- c(t, df, p.value)
    out2 <- c(dif, mx, y, se)
    names(coef) <- c("t.value", "df", "p.value")
    names(out2) <- c("Difference", "Mean", "Alternative", "Std. Err")
    out <- list("One Sample Weighted T-Test", coef, out2)
    names(out) <- c("test", "coefficients", "additional")
  }
  if(length(y)>1){
    n2 <- sum(!is.na(y))
    my <- wtd.mean(y, weighty, na.rm=TRUE)
    vy <- wtd.var(y, weighty, na.rm=TRUE)
    dif <- mx-my
    sxy <- sqrt((vx/n)+(vy/n2))
    df <- (((vx/n)+(vy/n2))^2)/((((vx/n)^2)/(n-1))+((vy/n2)^2/(n2-1)))
    t <- (mx-my)/sxy
    p.value <- (1-pt(abs(t), df))*2
    coef <- c(t, df, p.value)
    out2 <- c(dif, mx, my, sxy)
    names(coef) <- c("t.value", "df", "p.value")
    names(out2) <- c("Difference", "Mean.x", "Mean.y", "Std. Err")
    out <- list("Two Sample Weighted T-Test (Welch)", coef, out2)
    names(out) <- c("test", "coefficients", "additional")
  }
  out
}
