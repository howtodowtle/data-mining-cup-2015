# put this into your code to automatically set the working directory
# source("yourPathName/load_data.R", chdir = TRUE)
# make sure the source file is in the same folder as the data
fileList <- list.files()

longTemp <- read.csv(fileList[grepl("long_",fileList)], stringsAsFactors=TRUE)

for (var in c("premiumProduct","couponUsed","couponNr", "userID")){
  longTemp[,var] <- factor(longTemp[,var])
}

for (var in colnames(longTemp)[grepl("Cluster",colnames(longTemp))& !grepl("woe",colnames(longTemp))]){
  longTemp[,var] <- factor(longTemp[,var])
}

longTrain <- subset(longTemp,longTemp$trainingSetIndex==1)
longTest <- subset(longTemp,longTemp$trainingSetIndex==0)
longClass <- subset(longTemp,longTemp$trainingSetIndex==-1)
longTrain$trainingSetIndex <- NULL
longTest$trainingSetIndex <- NULL
longClass$trainingSetIndex <- NULL
rm(longTemp)

longTrain2 <- longTrain[,-(29:45)]

longTrain3 <- longTrain[!names(longTrain) %in%  grep("lust",colnames(longTrain), value=TRUE)]