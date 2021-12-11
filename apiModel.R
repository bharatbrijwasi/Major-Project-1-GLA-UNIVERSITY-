library(httr)
library(rjson)
library(dplyr)
# Data API to get raw Data
dataAPI <- GET("https://api.openweathermap.org/data/2.5/onecall?lat=20.59&lon=78.96&exclude=hourly&appid=8fad3aa8180e550995c7f4b66f20a3f7")


rawData <- as.data.frame(fromJSON(rawToChar(dataAPI$content)))


rawDataFunction <- function(rawData1){
  for(i in 1:100){
    dataAPI <- GET("https://api.openweathermap.org/data/2.5/onecall?lat=20.59&lon=78.96&exclude=hourly&appid=8fad3aa8180e550995c7f4b66f20a3f7")
    tempData <- as.data.frame(fromJSON(rawToChar(dataAPI$content)))
    rawData <- rbind(rawData, tempData)
    
    
    # give 1 minute delay
    date_time <- Sys.time()
    while((as.numeric(Sys.time())-as.numeric(date_time)) < 60){}
  }
  return(rawData)
}

rawDataForAnalysis <- rawDataFunction(rawData)

#data selection from the raw data set
selectedData <- select(rawDataForAnalysis, c(1:21, 3))

# column name 
names(selectedData)

# summary and structure of data set
summary(selectedData)
str(selectedData)

# check NA values
anyNA(selectedData)

# plot data points
plotDataPoint <- select(selectedData, c(8:17))
plot.ts(plotDataPoint)

