rm(list = ls(all = TRUE)) #CLEAR WORKSPACE
install.packages("quantmod")
install.packages("XML")

#Scrape data from the japans weather website
library(XML)
#vector with the names and the codes of the cities and variables
citycode<-c(47615,47624,	47626,	47629,	47638,47639,47641,47648,47654,47655,47656,47657,47662,47666,	47668	,47670	,47672,	47674,	47675,	47677	,47678,	47682,	47898,	47971)
cityname<-c('UTSUNOMIYA',	'MAEBASHI',	'KUMAGAYA',	'MITO',	'KOFU',	'FUJISAN',	'CHICHIBU',	'CHOSHI',	'HAMAMATSU',	'OMAEZAKI',	'SHIZUOKA',	'MISHIMA',	'TOKYO',	'IROZAKI',	'AJIRO',	'YOKOHAMA',	'TATEYAMA',	'KATSUURA',	'OSHIMA',	'MIYAKEJIMA',	'HACHIJOJIMA',	'CHIBA',	'SHIMIZU',	'CHICHIJIMA')
varycode<-c(1:14)
varyname<-c('Monthly mean air temperature',	'Monthly mean daily maximum temperature',	'Monthly mean daily minimum temperature',	'Monthly mean daily wind speed',	'Monthly mean sea level air pressure',	'Monthly mean station level pressure',	'Monthly mean relative humidity',	'Monthly mean vapor pressure',	'Monthly mean cloud amount',	'Monthly mean percentage of possible sunshine',	'Monthly mean global solar radiation',	'Monthly total of  sunshine duration',	'Monthly total precipitation',	'Monthly total of snowfall depth')
years<-c('2009',	'2010',	'2011',	'2012',	'2013',	'2014',	'2015')

for(i in 1:length(citycode)){
  station<-rep(cityname[i],12)
  for(j in 1:length(varycode)){
    metric<-rep(varyname[j],12)  
    rawjapW <- readHTMLTable(paste('http://www.data.jma.go.jp/obd/stats/etrn/view/monthly_s3_en.php?block_no=',citycode[i],'&view=',varycode[j],sep=""))
    
    Weth <- data.frame(rawjapW[[2]])
    if(as.character(Weth[1,1])!="This item is not observed."){
      # conditional for not observed variables: "This item is not observed."
      
      dataraw<-t(subset(Weth,Year %in% years,select = Year:Dec))
      #iteration over the years
      for(k in 1:7){
        mes<- dataraw[2:nrow(dataraw),k]
        Syear<-rep(dataraw[1,k],12)
        
        if(k==1&j==1&i==1){
          myframe<-data.frame(mes,Syear,station,metric)
        }else{
          myframe2<-data.frame(mes,Syear,station,metric)
          
          myframe<-rbind(myframe,myframe2 )
        }#end if for the data frames
      }# end for of k
    } # end if , variables not measured in some cities
  }#end for j
} #end for i

write.csv(myframe, file =paste("weather_japan_data" ,"csv",sep=".") )
#note: the final csv will need some data cleaning