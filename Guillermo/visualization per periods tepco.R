
##########data visualizacion per periods of TEPCO data##########
## load of packages recommended by Hector Flores

install.packages("nlme")
install.packages("stats")#must be updated instead on install
install.packages("chron")

tepco<-read.csv("DATA_SET.csv")# remember set the directory

#head(tepco)
# first we add second for completing the time format
alltime<-paste(tepco$TIME,rep("00",length(tepco$TIME)),sep=":" )

thetimes <- chron(dates=as.character(tepco$DATE),
                  times=alltime,
                  format=c(dates="d/m/y",times="h:m:s"))
#length(tepco$TIME)#just for being sure of getting all the vector

#  seeing the time time vector  
#head(thetimes)
#with the concatenation the chron method works fine 

#ploting with for statement to obtain same period of different years  

frame()
par( mfrow = c( 3, 1 ) ) # 3 rows and 1 columns for comparing three years of one periods
Lperiod<-1*24 #indicates the space between labels is set to the end of one day
# some parameters
initMth=10  # initial month to include in the plot
endMth=12  #final month to include in the plot
iniDy=01  #initial  day of the initial month
endDy=30  #final day of the final month
for(i in 2009:2014){# skip the last year
  initDT<-as.Date(paste(as.character(i),as.character(initMth),as.character(iniDy),sep="-"))
  finDT <-as.Date(paste(as.character(i),as.character(endMth),as.character(endDy),sep="-"))
  
  x<-thetimes[thetimes>=initDT&thetimes<=finDT ]
  y<-tepco$LOAD.10MW.[thetimes>=initDT&thetimes<=finDT]
  
  plot(x,y, type="l", lwd=1, xaxt="n",xlab = "",ylab =i )
  axis(1, at = x[seq(Lperiod, length(x), by = Lperiod)],labels =weekdays(x[seq(Lperiod, length(x), by = Lperiod)]) , las=2,cex=.5)
} #end for i