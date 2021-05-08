rd <- function(x, digits=2){
  y <- format(round(x, digits=digits), nsmall=digits)
  z <- sub("^([-]?)0[.]","\\1.", gsub(" +", "", y))
  z
}
