spvs_breaks<- function(x) {if(max(x)<0.5){
  distance <- dist(c(round(min(x)+ 0.06*dist(range(x)),2), round(max(x)- 0.06*dist(range(x)),2)))
  interval <- round(distance / 3,2)
  shift <- distance %% interval
  breaks<-seq(round(min(x)+ 0.06*dist(range(x)),2)+shift, round(max(x)- 0.06*dist(range(x)),2),by=interval)
  if(max(x) < (breaks[3]+interval)){
    breaks <- c(breaks, breaks[3]+interval)
  }
  if(min(x) < (breaks[1]-interval)){
    breaks <- c(breaks[1]-interval,breaks)
  }
}
  else{distance <- dist(c(round(min(x)+ 0.06*dist(range(x)),1), round(max(x)- 0.06*dist(range(x)),1)))
  interval <- round(distance / 3,1)
  shift <- distance %% interval
  breaks<-seq(round(min(x)+ 0.06*dist(range(x)),1)+shift, round(max(x)- 0.06*dist(range(x)),1),by=interval)
  if(max(x) < (breaks[3]+interval)){
    breaks <- c(breaks, breaks[3]+interval)
  }
  if(min(x) < (breaks[1]-interval)){
    breaks <- c(breaks[1]-interval,breaks)
  }
  }
  return(breaks)}