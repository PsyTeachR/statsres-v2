# Code from Yuan Yan <yuan.yan@dal.ca>
# Reference:
# Yan, Yuan, and Marc G. Genton. ‘The Tukey g-and-h Distribution’. Significance 16, no. 3 (2019): 12–13. https://doi.org/10.1111/j.1740-9713.2019.01273.x.

gh_trans <- function(z,g=0.2,h=0.1){
  if(g==0)
    x<-z*exp(h*z^2/2)
  else
    x<-1/g*(exp(g*z)-1)*exp(h*(z^2)/2)
  return(x)
}

#pdf: density function
den_tukey <- function(y,g=0.2,h=0.1,xi=0,omega=1,u=0,sig=1){
  y=(y-xi)/omega  
  z=tukey_inv(y,g,h)
  #   for(i in 1:length(y)){
  #     # z[i] <- uniroot(f,c(-10,10))$root
  #     z[i]<-nleqslv(0,fn=function(x){tukey(x,g,h)-y[i]})$x
  #   }
  dnorm(z,mean=u,sd=sig)/dtukey(z,g,h)/omega  
}

#inverse TGH transformation
tukey_inv <- function(y,g=0.2,h=0.1){
  if(g==0 & h==0)
    z=y
  else if(g==0)
    z<-sign(y)*sqrt(lambert_W0(h*y^2)/h) #better & 143 times faster
  else if(h==0){
    # if(g>0)
    #   y=y[y>-1/g]
    # else
    #   y=y[y<-1/g]
    z<-log(g*y+1)/g
  }
  else{
    z=numeric(length(y))
    for(i in 1:length(y)){
      # z[i] <- uniroot(f,c(-10,10))$root
      z[i]<-nleqslv(0,fn=function(x){gh_trans(x,g,h)-y[i]})$x
    }
  }
  return(z)
}

dtukey <- function(z,g=0.2,h=0.1){
  if(g==0)
    x<-exp(h*z^2/2)*(1+h*z^2)
  else
    x<-exp(g*z+h*z^2/2)+h*z/g*(exp(g*z)-1)*exp(h*(z^2)/2)
  return(x)
}